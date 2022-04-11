// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "pulp_soc_defines.sv"
`include "periph_bus_defines.sv"


`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"

module fc_subsystem #(
    parameter CORE_TYPE           = 0,
    parameter PULP_XPULP          = 1,
    parameter USE_FPU             = 1,
    parameter ZFINX               = 0,
    parameter USE_HWPE            = 1,
    parameter N_EXT_PERF_COUNTERS = 1,
    parameter EVENT_ID_WIDTH      = 8,
    parameter PER_ID_WIDTH        = 32,
    parameter NB_HWPE_PORTS       = 4,
    parameter PULP_SECURE         = 1,
    parameter TB_RISCV            = 0,
    parameter CORE_ID             = 4'h0,
    parameter CLUSTER_ID          = 6'h1F,
    parameter NUM_INTERRUPTS      = 0
) (
    input  logic                      clk_i,
    input  logic                      rst_ni,
    input  logic                      test_en_i,

    XBAR_TCDM_BUS.Master              l2_data_master,
    XBAR_TCDM_BUS.Master              l2_instr_master,
    XBAR_TCDM_BUS.Master              l2_shadow_master,
    XBAR_TCDM_BUS.Master              l2_hwpe_master [NB_HWPE_PORTS],
    APB_BUS.Slave                     apb_slave_eu,
    APB_BUS.Slave                     apb_slave_clic,
    APB_BUS.Slave                     apb_slave_hwpe,

    input  logic                      fetch_en_i,
    input  logic [31:0]               boot_addr_i,
    input  logic                      debug_req_i,

    input  logic                      event_fifo_valid_i,
    output logic                      event_fifo_fulln_o,
    input  logic [EVENT_ID_WIDTH-1:0] event_fifo_data_i, // goes indirectly to core interrupt
    input  logic [31:0]               events_i, // goes directly to core interrupt, should be called irqs

    output logic [1:0]                hwpe_events_o,

    input logic                       sdma_term_event_i,
    input logic                       sdma_busy_i,

    output logic                      supervisor_mode_o,

    // external interrupts
    input logic                       scg_irq_i,
    input logic                       scp_irq_i,
    input logic                       scp_secure_irq_i,
    input logic [71:0]                mbox_irq_i,
    input logic [71:0]                mbox_secure_irq_i
);

    import cv32e40p_apu_core_pkg::*;

    // Interrupt signals
    logic        core_irq_req   ;
    logic        core_irq_sec   ;
    logic [$clog2(NUM_INTERRUPTS)-1:0]  core_irq_id    ;
    logic [7:0]  core_irq_level ;
    logic        core_irq_shv   ;
    //logic [4:0]  core_irq_ack_id;
    logic        core_irq_ack   ;
    logic [14:0] core_irq_fast  ;
    logic [NUM_INTERRUPTS-1:0] core_irq_x     ;

    logic [3:0]  irq_ack_id;

    logic        soc_event_int;

    // Signals for OBI-PULP conversion
    logic        obi_instr_req;
    logic        pulp_instr_req;

    // Boot address, core id, cluster id, fethc enable and core_status
    logic [31:0] boot_addr        ;
    logic        fetch_en_int     ;
    logic        core_busy_int    ;
    logic        perf_counters_int;
    logic [31:0] hart_id;

    //EU signals
    logic core_clock_en;
    logic fetch_en_eu  ;

    //Core Instr Bus
    logic [31:0] core_instr_addr, core_instr_rdata;
    logic        core_instr_req, core_instr_gnt, core_instr_rvalid, core_instr_err;

    //Core Data Bus
    logic [31:0] core_data_addr, core_data_rdata, core_data_wdata;
    logic        core_data_req, core_data_gnt, core_data_rvalid, core_data_err;
    logic        core_data_we;
    logic [3:0]  core_data_be;

    //Core Shadow Data Bus
    logic [31:0] core_shadow_addr, core_shadow_rdata, core_shadow_wdata;
    logic        core_shadow_req, core_shadow_gnt, core_shadow_rvalid, core_shadow_err;
    logic        core_shadow_we;
    logic [3:0]  core_shadow_be;


    assign perf_counters_int = 1'b0;
    assign fetch_en_int      = fetch_en_eu & fetch_en_i;

    assign hart_id = {21'b0, CLUSTER_ID[5:0], 1'b0, CORE_ID[3:0]};

    XBAR_TCDM_BUS core_data_bus ();
    XBAR_TCDM_BUS core_instr_bus ();

    // APU Core to FP Wrapper
    logic                               apu_req;
    logic [    APU_NARGS_CPU-1:0][31:0] apu_operands;
    logic [      APU_WOP_CPU-1:0]       apu_op;
    logic [ APU_NDSFLAGS_CPU-1:0]       apu_flags;


    // APU FP Wrapper to Core
    logic                               apu_gnt;
    logic                               apu_rvalid;
    logic [                 31:0]       apu_rdata;
    logic [ APU_NUSFLAGS_CPU-1:0]       apu_rflags;

    //********************************************************
    //************ CORE DEMUX (TCDM vs L2) *******************
    //********************************************************
    assign l2_data_master.req    = core_data_req;
    assign l2_data_master.add    = core_data_addr;
    assign l2_data_master.wen    = ~core_data_we;
    assign l2_data_master.wdata  = core_data_wdata;
    assign l2_data_master.be     = core_data_be;
    assign core_data_gnt         = l2_data_master.gnt;
    assign core_data_rvalid      = l2_data_master.r_valid;
    assign core_data_rdata       = l2_data_master.r_rdata;
    assign core_data_err         = l2_data_master.r_opc;


    assign l2_instr_master.req   = core_instr_req;
    assign l2_instr_master.add   = core_instr_addr;
    assign l2_instr_master.wen   = 1'b1;
    assign l2_instr_master.wdata = '0;
    assign l2_instr_master.be    = 4'b1111;
    assign core_instr_gnt        = l2_instr_master.gnt;
    assign core_instr_rvalid     = l2_instr_master.r_valid;
    assign core_instr_rdata      = l2_instr_master.r_rdata;
    assign core_instr_err        = l2_instr_master.r_opc;

    assign l2_shadow_master.req   = core_shadow_req;
    assign l2_shadow_master.add   = core_shadow_addr;
    assign l2_shadow_master.wen   = ~core_shadow_we;
    assign l2_shadow_master.wdata = core_shadow_wdata;
    assign l2_shadow_master.be    = core_shadow_be;
    assign core_shadow_gnt        = l2_shadow_master.gnt;
    assign core_shadow_rvalid     = l2_shadow_master.r_valid;
    assign core_shadow_rdata      = l2_shadow_master.r_rdata;
    assign core_shadow_err        = l2_shadow_master.r_opc;

    //********************************************************
    //************ RISCV CORE ********************************
    //********************************************************

    assign boot_addr = boot_addr_i;

`ifndef PULP_FPGA_EMUL
  `ifdef SYNTHESIS
    cv32e40p_core #(
  `else
    cv32e40p_wrapper #(
  `endif
`else
    cv32e40p_core #(
`endif
        .PULP_XPULP       (PULP_XPULP),
        .PULP_CLUSTER     (0),
        .FPU              (USE_FPU),
        .PULP_ZFINX       (ZFINX),
        .NUM_MHPMCOUNTERS (N_EXT_PERF_COUNTERS),
        .NUM_INTERRUPTS   (NUM_INTERRUPTS),
        .CLIC             (1),
        .MCLICBASE_ADDR   (`CLIC_START_ADDR),        // Base address for CLIC memory mapped registers
        .SHADOW           (1)
    ) FC_CORE_i (

        // Clock and Reset
        .clk_i                (clk_i),
        .rst_ni               (rst_ni),

        // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
        .pulp_clock_en_i      ('0 ),
        .scan_cg_en_i         (test_en_i),
        .boot_addr_i          (boot_addr),
        .mtvec_addr_i         (32'h0),
        .mtvt_addr_i          (32'h0),
        .dm_halt_addr_i       (`DEBUG_START_ADDR + dm::HaltAddress[31:0]),
        .hart_id_i            (hart_id),
        .dm_exception_addr_i  (`DEBUG_START_ADDR + dm::ExceptionAddress[31:0]),

        // Instruction memory interface
        .instr_req_o           (obi_instr_req),
        .instr_gnt_i           (core_instr_gnt),
        .instr_rvalid_i        (core_instr_rvalid),
        .instr_addr_o          (core_instr_addr),
        .instr_rdata_i         (core_instr_rdata),

        // Data memory interface
        .data_req_o            (core_data_req),
        .data_gnt_i            (core_data_gnt),
        .data_rvalid_i         (core_data_rvalid),
        .data_we_o             (core_data_we),
        .data_be_o             (core_data_be),
        .data_addr_o           (core_data_addr),
        .data_wdata_o          (core_data_wdata),
        .data_rdata_i          (core_data_rdata),
        .data_atop_o           (               ), // currently, FC does not support
                                                  // AMOs and LR/SC in ControlPULP

        // Shadow memory interface
        .shadow_req_o          (core_shadow_req),
        .shadow_gnt_i          (core_shadow_gnt),
        .shadow_rvalid_i       (core_shadow_rvalid),
        .shadow_we_o           (core_shadow_we),
        .shadow_be_o           (core_shadow_be),
        .shadow_addr_o         (core_shadow_addr),
        .shadow_wdata_o        (core_shadow_wdata),
        .shadow_rdata_i        (core_shadow_rdata),

        // apu-interconnect
        // handshake signals
        .apu_req_o             (apu_req),
        .apu_gnt_i             (apu_gnt),
        // request channel
        .apu_operands_o        (apu_operands),
        .apu_op_o              (apu_op),
        .apu_type_o            (),
        .apu_flags_o           (apu_flags),
        // response channel
        .apu_rvalid_i          (apu_rvalid),
        .apu_result_i          (apu_rdata),
        .apu_flags_i           (apu_rflags),

        // Interrupt inputs
        .irq_i                 (core_irq_x),  // CLINT interrupts + CLINT extension interrupts
        .irq_level_i           (core_irq_level),
        .irq_shv_i             (core_irq_shv),
        .irq_ack_o             (core_irq_ack),
        .irq_id_o              (/*core_irq_ack_id*/),

        // Debug Interface
        .debug_req_i           (debug_req_i),
        .debug_havereset_o     (),
        .debug_running_o       (),
        .debug_halted_o        (),

        // CPU Control Signals
        .fetch_enable_i        (fetch_en_int),
        .core_sleep_o          ()
    );

    // OBI-PULP adapter
    obi_pulp_adapter i_obi_pulp_adapter (
        .rst_ni       (rst_ni),
        .clk_i        (clk_i),
        .core_req_i   (obi_instr_req),
        .mem_gnt_i    (core_instr_gnt),
        .mem_rvalid_i (core_instr_rvalid),
        .mem_req_o    (pulp_instr_req)
      );
    assign core_instr_req = pulp_instr_req;

    assign supervisor_mode_o = 1'b1;

    always_comb begin : gen_core_irq_x
        core_irq_x = '0;
        if (core_irq_req) begin
            core_irq_x[core_irq_id] = 1'b1;
        end
    end

    // warnings for transitioning off apb_interrupt_cntrl
`ifndef SYNTHESIS
    assert property (@(posedge clk_i)
        !(apb_slave_eu.psel == 1'b1
         && apb_slave_eu.penable == 1'b1))
        else $info("[soc_clk_rst_gen]  %t - Detected legacy CLINT access", $time);
`endif

    // TODO: imported this hardcoded stuff from apb_interrupt_cntrl. Why was
    // this even the job of the interrupt controller?
    assign fetch_en_eu = 1'b1;
    assign core_clock_en = 1'b1;

    // convert soc events to level sensitive interrupt
    event_to_level_int #(
        .EVENT_WIDTH (EVENT_ID_WIDTH)
    ) i_event_to_level_int (
        .clk_i,
        .rst_ni,
        .ctrl          (apb_slave_eu),
        .event_data_i  (event_fifo_data_i),
        .event_valid_i (event_fifo_valid_i),
        .event_ready_o (event_fifo_fulln_o),
        .int_lvl_o     (soc_event_int)
    );

    localparam int unsigned REG_BUS_ADDR_WIDTH = 32;
    localparam int unsigned REG_BUS_DATA_WIDTH = 32;

    REG_BUS #(
        .ADDR_WIDTH (REG_BUS_ADDR_WIDTH),
        .DATA_WIDTH (REG_BUS_DATA_WIDTH)
    ) reg_bus (clk_i);

    apb_to_reg i_apb_to_reg (
        .clk_i,
        .rst_ni,
        .penable_i (apb_slave_clic.penable),
        .pwrite_i  (apb_slave_clic.pwrite),
        .paddr_i   (apb_slave_clic.paddr),
        .psel_i    (apb_slave_clic.psel),
        .pwdata_i  (apb_slave_clic.pwdata),
        .prdata_o  (apb_slave_clic.prdata),
        .pready_o  (apb_slave_clic.pready),
        .pslverr_o (apb_slave_clic.pslverr),
        .reg_o     (reg_bus)
    );

    typedef logic [REG_BUS_ADDR_WIDTH-1:0] addr_t;
    typedef logic [REG_BUS_DATA_WIDTH-1:0] data_t;
    typedef logic [REG_BUS_DATA_WIDTH/8-1:0] strb_t;

    `REG_BUS_TYPEDEF_REQ(reg_a32_d32_req_t, addr_t, data_t, strb_t)
    `REG_BUS_TYPEDEF_RSP(reg_a32_d32_rsp_t, data_t)

    reg_a32_d32_req_t clic_req;
    reg_a32_d32_rsp_t clic_rsp;

    assign clic_req.addr  = reg_bus.addr;
    assign clic_req.write = reg_bus.write;
    assign clic_req.wdata = reg_bus.wdata;
    assign clic_req.wstrb = reg_bus.wstrb;
    assign clic_req.valid = reg_bus.valid;

    assign reg_bus.rdata = clic_rsp.rdata;
    assign reg_bus.error = clic_rsp.error;
    assign reg_bus.ready = clic_rsp.ready;

    // TODO: make this useful
    // localparam int unsigned N_SOURCE = 256;

    logic [255:0] clic_irqs;
    assign clic_irqs = {
      {75{1'b0}},         // 75 (systemverilog has default:0 but that doesn't work reliably)
      sdma_busy_i,        // 1
      sdma_term_event_i,  // 1
      mbox_secure_irq_i,  // 72
      mbox_irq_i,         // 72
      scp_secure_irq_i,   // 1
      scp_irq_i,          // 1
      scg_irq_i,          // 1
      events_i[31:27],    // 32 (regular clint interrupts)
      soc_event_int,      // 26 (soc event int) TODO: ugly
      events_i[25:0]      // 32 (regular clint interrupts)
    };

    clic #(
        .reg_req_t ( reg_a32_d32_req_t ),
        .reg_rsp_t ( reg_a32_d32_rsp_t )
    ) i_clic (
        .clk_i,
        .rst_ni,
         // Bus Interface
        .reg_req_i   ( clic_req       ),
        .reg_rsp_o   ( clic_rsp       ),
        // Interrupt Sources
        .intr_src_i  ( clic_irqs      ),
        // Interrupt notification to core
        .irq_valid_o ( core_irq_req   ),
        .irq_ready_i ( core_irq_ack   ),
        .irq_id_o    ( core_irq_id    ),
        .irq_level_o ( core_irq_level ),
        .irq_shv_o   ( core_irq_shv   )
    );


    if(USE_HWPE) begin : fc_hwpe_gen
        fc_hwpe #(
            .N_MASTER_PORT ( NB_HWPE_PORTS ),
            .ID_WIDTH      ( 2             )
        ) i_fc_hwpe (
            .clk_i             ( clk_i          ),
            .rst_ni            ( rst_ni         ),
            .test_mode_i       ( test_en_i      ),
            .hwacc_xbar_master ( l2_hwpe_master ),
            .hwacc_cfg_slave   ( apb_slave_hwpe ),
            .evt_o             ( hwpe_events_o  ),
            .busy_o            (                )
        );
    end
    else begin : no_fc_hwpe_gen
        assign hwpe_events_o = '0;
        assign apb_slave_hwpe.prdata  = '0;
        assign apb_slave_hwpe.pready  = '0;
        assign apb_slave_hwpe.pslverr = '0;
        for(genvar ii=0; ii<NB_HWPE_PORTS; ii++) begin
            assign l2_hwpe_master[ii].req   = '0;
            assign l2_hwpe_master[ii].wen   = '0;
            assign l2_hwpe_master[ii].wdata = '0;
            assign l2_hwpe_master[ii].be    = '0;
            assign l2_hwpe_master[ii].add   = '0;
        end
    end


    //*************************************
    //****** APU INTERFACE WITH FPU *******
    //*************************************

    if (USE_FPU) begin : gen_fp_wrapper
        cv32e40p_fp_wrapper #(
            .FP_DIVSQRT (1)
        ) fp_wrapper_i (
            .clk_i         (clk_i),
            .rst_ni        (rst_ni),
            .apu_req_i     (apu_req),
            .apu_gnt_o     (apu_gnt),
            .apu_operands_i(apu_operands),
            .apu_op_i      (apu_op),
            .apu_flags_i   (apu_flags),
            .apu_rvalid_o  (apu_rvalid),
            .apu_rdata_o   (apu_rdata),
            .apu_rflags_o  (apu_rflags)
        );
    end else begin : gen_no_fp_wrapper
        assign apu_req      = 1'b0;
        assign apu_gnt      = 1'b0;
        assign apu_operands = 1'b0;
        assign apu_op       = 1'b0;
        assign apu_flags    = 1'b0;
        assign apu_rvalid   = 1'b0;
        assign apu_rdata    = 1'b0;
        assign apu_rflags   = 1'b0;
    end

endmodule
