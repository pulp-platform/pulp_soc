// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "periph_bus_defines.sv"

module fc_subsystem import cv32e40p_apu_core_pkg::*; #(
    parameter CORE_TYPE           = 0,
    parameter USE_XPULP           = 1,
    parameter USE_FPU             = 1,
    parameter USE_ZFINX           = 1,
    parameter USE_HWPE            = 1,
    parameter N_EXT_PERF_COUNTERS = 1,
    parameter EVENT_ID_WIDTH      = 8,
    parameter PER_ID_WIDTH        = 32,
    parameter NB_HWPE_PORTS       = 4,
    parameter PULP_SECURE         = 1,
    parameter TB_RISCV            = 0,
    parameter CORE_ID             = 4'h0,
    parameter CLUSTER_ID          = 6'h1F
)
(
    input  logic                      clk_i,
    input  logic                      rst_ni,
    input  logic                      test_en_i,

    XBAR_TCDM_BUS.Master              l2_data_master,
    XBAR_TCDM_BUS.Master              l2_instr_master,
    XBAR_TCDM_BUS.Master              l2_hwpe_master [NB_HWPE_PORTS-1:0],
    APB_BUS.Slave                     apb_slave_eu,
    APB_BUS.Slave                     apb_slave_hwpe,

    input  logic                      fetch_en_i,
    input  logic [31:0]               boot_addr_i,
    input  logic                      debug_req_i,

    input  logic                      event_fifo_valid_i,
    output logic                      event_fifo_fulln_o,
    input  logic [EVENT_ID_WIDTH-1:0] event_fifo_data_i, // goes indirectly to core interrupt
    input  logic [31:0]               events_i, // goes directly to core interrupt, should be called irqs
    output logic [1:0]                hwpe_events_o,

    output logic                      supervisor_mode_o
);

    localparam USE_IBEX   = CORE_TYPE == 1 || CORE_TYPE == 2;
    localparam IBEX_RV32M = CORE_TYPE == 1 ? ibex_pkg::RV32MFast : ibex_pkg::RV32MNone;
    localparam IBEX_RV32E = CORE_TYPE == 2;

    // Set register file for ibex based on bender targets.
    //     Default to FF for simulation, use FGPA for FPGA, use Latch for synthesis.
    //     Override by setting bender targets (`-t ibex_use_ff_regfile`) or defines below
    localparam IBEX_RegFile =   `ifdef TARGET_IBEX_USE_FPGA_REGFILE  ibex_pkg::RegFileFPGA;  `else // Override FPGA
                                `ifdef TARGET_IBEX_USE_LATCH_REGFILE ibex_pkg::RegFileLatch; `else // Override Latch
                                `ifdef TARGET_IBEX_USE_FF_REGFILE    ibex_pkg::RegFileFF;    `else // Override FF
                                `ifdef TARGET_FPGA                   ibex_pkg::RegFileFPGA;  `else // FPGA
                                `ifdef TARGET_SYNTHESIS              ibex_pkg::RegFileLatch; `else // Synthesis
                                                                     ibex_pkg::RegFileFF;          // Default
                                `endif `endif `endif `endif `endif

    // Interrupt signals
    logic        core_irq_req   ;
    logic [4:0]  core_irq_id    ;
    logic [4:0]  core_irq_ack_id;
    logic        core_irq_ack   ;
    logic [31:0] core_irq_x;

    // Signals for OBI-PULP conversion
    logic        pulp_instr_req, pulp_data_req;

    // Boot address, core id, cluster id, fethc enable and core_status
    logic [31:0] boot_addr        ;
    logic        fetch_en_int     ;
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
    logic        core_data_we  ;
    logic [ 3:0]  core_data_be ;

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
    assign l2_data_master.req    = pulp_data_req;
    assign l2_data_master.add    = core_data_addr;
    assign l2_data_master.wen    = ~core_data_we;
    assign l2_data_master.wdata  = core_data_wdata;
    assign l2_data_master.be     = core_data_be;
    assign core_data_gnt         = l2_data_master.gnt;
    assign core_data_rvalid      = l2_data_master.r_valid;
    assign core_data_rdata       = l2_data_master.r_rdata;
    assign core_data_err         = l2_data_master.r_opc;

    // OBI-PULP adapter
    obi_pulp_adapter i_obi_pulp_adapter_data (
        .rst_ni       (rst_ni),
        .clk_i        (clk_i),
        .core_req_i   (core_data_req),
        .mem_gnt_i    (core_data_gnt),
        .mem_rvalid_i (core_data_rvalid),
        .mem_req_o    (pulp_data_req)
    );

    assign l2_instr_master.req   = pulp_instr_req;
    assign l2_instr_master.add   = core_instr_addr;
    assign l2_instr_master.wen   = 1'b1;
    assign l2_instr_master.wdata = '0;
    assign l2_instr_master.be    = 4'b1111;
    assign core_instr_gnt        = l2_instr_master.gnt;
    assign core_instr_rvalid     = l2_instr_master.r_valid;
    assign core_instr_rdata      = l2_instr_master.r_rdata;
    assign core_instr_err        = l2_instr_master.r_opc;

    // OBI-PULP adapter
    obi_pulp_adapter i_obi_pulp_adapter_instr (
        .rst_ni       (rst_ni),
        .clk_i        (clk_i),
        .core_req_i   (core_instr_req),
        .mem_gnt_i    (core_instr_gnt),
        .mem_rvalid_i (core_instr_rvalid),
        .mem_req_o    (pulp_instr_req)
    );

    //********************************************************
    //************ RISCV CORE ********************************
    //********************************************************

    generate
    if ( USE_IBEX == 0) begin: FC_CORE
    assign boot_addr = boot_addr_i;
`ifdef PULP_FPGA_EMUL
    cv32e40p_core #(
`elsif SYNTHESIS
    cv32e40p_core #(
`elsif VERILATOR
    cv32e40p_core #(
`else
    cv32e40p_wrapper #(
`endif
        .PULP_XPULP       (USE_XPULP),
        .PULP_CLUSTER     (0),
        .FPU              (USE_FPU),
        .PULP_ZFINX       (USE_ZFINX),
        .NUM_MHPMCOUNTERS (N_EXT_PERF_COUNTERS)
    ) FC_CORE_i (

        // Clock and Reset
        .clk_i,
        .rst_ni,

        // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
        .pulp_clock_en_i      ('0 ),
        .scan_cg_en_i         (test_en_i),
        .boot_addr_i          (boot_addr),
        .mtvec_addr_i         (32'h0),
        .dm_halt_addr_i       (`DEBUG_START_ADDR + dm::HaltAddress[31:0]),
        .hart_id_i            (hart_id),
        .dm_exception_addr_i  (`DEBUG_START_ADDR + dm::ExceptionAddress[31:0]),

        // Instruction memory interface
        .instr_req_o           (core_instr_req),
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

        // apu-interconnect
        // handshake signals
        .apu_req_o             (apu_req),
        .apu_gnt_i             (apu_gnt),

        // request channel
        .apu_operands_o        (apu_operands),
        .apu_op_o              (apu_op),
        //.apu_type_o            (),
        .apu_flags_o           (apu_flags),

        // response channel
        .apu_rvalid_i          (apu_rvalid),
        .apu_result_i          (apu_rdata),
        .apu_flags_i           (apu_rflags),

        // Interrupt inputs
        .irq_i                 (core_irq_x),
        .irq_ack_o             (core_irq_ack),
        .irq_id_o              (core_irq_ack_id),

        // Debug Interface
        .debug_req_i           (debug_req_i),
        .debug_havereset_o     (),
        .debug_running_o       (),
        .debug_halted_o        (),

        // CPU Control Signals
        .fetch_enable_i        (fetch_en_int),
        .core_sleep_o          ()
    );

    assign supervisor_mode_o = 1'b1;

    end else begin: FC_CORE
    assign boot_addr = boot_addr_i & 32'hFFFFFF00; // RI5CY expects 0x80 offset, Ibex expects 0x00 offset (adds reset offset 0x80 internally)
`ifdef VERILATOR
    ibex_core #(
`elsif TRACE_EXECUTION
    ibex_core_tracing #(
`else
    ibex_core #(
`endif
        .PMPEnable        ( 1'b0                ),
        .PMPGranularity   ( 0                   ),
        .PMPNumRegions    ( 4                   ),
        .MHPMCounterNum   ( 10                  ),
        .MHPMCounterWidth ( 40                  ),
        .RV32E            ( IBEX_RV32E          ),
        .RV32M            ( IBEX_RV32M          ),
        .RV32B            ( ibex_pkg::RV32BNone ),
        .RegFile          ( IBEX_RegFile        ),
        .BranchTargetALU  ( 1'b0                ),
        .WritebackStage   ( 1'b0                ),
        .ICache           ( 1'b0                ),
        .ICacheECC        ( 1'b0                ),
        .BranchPredictor  ( 1'b0                ),
        .DbgTriggerEn     ( 1'b1                ),
        .DbgHwBreakNum    ( 1                   ),
        .SecureIbex       ( 1'b0                ),
        .DmHaltAddr       ( `DEBUG_START_ADDR + dm::HaltAddress[31:0]      ),
        .DmExceptionAddr  ( `DEBUG_START_ADDR + dm::ExceptionAddress[31:0] )
    ) lFC_CORE (
        .clk_i                 ( clk_i             ),
        .rst_ni                ( rst_ni            ),

        .test_en_i             ( test_en_i         ),

        .hart_id_i             ( hart_id           ),
        .boot_addr_i           ( boot_addr         ),

        // Instruction Memory Interface:  Interface to Instruction Logaritmic interconnect: Req->grant handshake
        .instr_addr_o          ( core_instr_addr   ),
        .instr_req_o           ( core_instr_req    ),
        .instr_rdata_i         ( core_instr_rdata  ),
        .instr_gnt_i           ( core_instr_gnt    ),
        .instr_rvalid_i        ( core_instr_rvalid ),
        .instr_err_i           ( core_instr_err    ),

        // Data memory interface:
        .data_addr_o           ( core_data_addr    ),
        .data_req_o            ( core_data_req     ),
        .data_be_o             ( core_data_be      ),
        .data_rdata_i          ( core_data_rdata   ),
        .data_we_o             ( core_data_we      ),
        .data_gnt_i            ( core_data_gnt     ),
        .data_wdata_o          ( core_data_wdata   ),
        .data_rvalid_i         ( core_data_rvalid  ),
        .data_err_i            ( core_data_err     ),

        .irq_software_i        ( 1'b0              ),
        .irq_timer_i           ( 1'b0              ),
        .irq_external_i        ( 1'b0              ),
        .irq_fast_i            ( 15'b0             ),
        .irq_nm_i              ( 1'b0              ),

        // Ibex supports 32 additional fast interrupts and reads the interrupt lines directly.
        .irq_x_i               ( core_irq_x        ),
        .irq_x_ack_o           ( core_irq_ack      ),
        .irq_x_ack_id_o        ( core_irq_ack_id   ),

        .external_perf_i       ( { {16 - N_EXT_PERF_COUNTERS {'0}}, perf_counters_int } ),

        .debug_req_i           ( debug_req_i       ),

        .fetch_enable_i        ( fetch_en_int      ),
        .alert_minor_o         (                   ),
        .alert_major_o         (                   ),
        .core_sleep_o          (                   )
    );

    assign supervisor_mode_o = 1'b1;
 
    end
    endgenerate

    apb_interrupt_cntrl #(.PER_ID_WIDTH(PER_ID_WIDTH)) fc_eu_i (
        .clk_i              ( clk_i              ),
        .rst_ni             ( rst_ni             ),
        .test_mode_i        ( test_en_i          ),
        .events_i           ( events_i           ),
        .event_fifo_valid_i ( event_fifo_valid_i ),
        .event_fifo_fulln_o ( event_fifo_fulln_o ),
        .event_fifo_data_i  ( event_fifo_data_i  ),
        .core_secure_mode_i ( 1'b0               ),
        .core_irq_id_o      ( core_irq_id        ),
        .core_irq_req_o     ( core_irq_req       ),
        .core_irq_ack_i     ( core_irq_ack       ),
        .core_irq_id_i      ( core_irq_ack_id    ),
        .core_irq_sec_o     ( /* SECURE IRQ */   ),
        .core_clock_en_o    ( core_clock_en      ),
        .fetch_en_o         ( fetch_en_eu        ),
        .apb_slave          ( apb_slave_eu       )
    );

    // Convert ID back to interrupt lines
    always_comb begin : gen_core_irq_x
        core_irq_x = '0;
        if (core_irq_req) begin
            core_irq_x[core_irq_id] = 1'b1;
        end
    end


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
        for(genvar ii=0; ii<NB_HWPE_PORTS; ii++) begin : no_fc_hwpe_gen_loop
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

    if (USE_FPU && CORE_TYPE == 0) begin
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
    end else begin
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
