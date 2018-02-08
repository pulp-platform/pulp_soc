// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


`include "soc_bus_defines.sv"

module fc_subsystem #(
    parameter CORE_TYPE           = 0,
    parameter USE_FPU             = 1,
    parameter N_EXT_PERF_COUNTERS = 1,
    parameter EVENT_ID_WIDTH      = 8,
    parameter PER_ID_WIDTH        = 32,
    parameter NB_HWPE_PORTS       = 4
) (
    input  logic                      clk_i,
    input  logic                      rst_ni,
    input  logic                      test_en_i,

    XBAR_TCDM_BUS.Master              l2_data_master,
    XBAR_TCDM_BUS.Master              l2_instr_master,
    XBAR_TCDM_BUS.Master              l2_hwpe_master [NB_HWPE_PORTS-1:0],
    UNICAD_MEM_BUS_32.Master          scm_l2_data_master,
    UNICAD_MEM_BUS_32.Master          scm_l2_instr_master,
    APB_BUS.Slave                     apb_slave_eu,
    APB_BUS.Slave                     apb_slave_debug,
    APB_BUS.Slave                     apb_slave_hwpe,

    input  logic                      fetch_en_i,
    input  logic [31:0]               boot_addr_i,

    input  logic                      event_fifo_valid_i,
    output logic                      event_fifo_fulln_o,
    input  logic [EVENT_ID_WIDTH-1:0] event_fifo_data_i,
    input  logic [31:0]               events_i,
    output logic [1:0]                hwpe_events_o,

    output logic                      supervisor_mode_o
);

    localparam USE_ZERORISCY   = CORE_TYPE == 1 || CORE_TYPE == 2;
    localparam ZERORISCY_RV32M = CORE_TYPE == 1;
    localparam ZERORISCY_RV32E = CORE_TYPE == 2;

    // Interrupt signals
    logic       core_irq_req   ;
    logic       core_irq_sec   ;
    logic [4:0] core_irq_id    ;
    logic [4:0] core_irq_ack_id;
    logic       core_irq_ack   ;

    // Boot address, core id, cluster id, fethc enable and core_status
    logic [ 3:0] core_id_int      ;
    logic [ 5:0] cluster_id_int   ;
    logic        fetch_en_int     ;
    logic        core_busy_int    ;
    logic        perf_counters_int;

    //EU signals
    logic core_clock_en;
    logic fetch_en_eu  ;

    //Core Instr Bus
    logic [31:0] core_instr_addr, core_instr_rdata;
    logic        core_instr_req, core_instr_gnt, core_instr_rvalid;

    //Core Data Bus
    logic [31:0] core_data_addr, core_data_rdata, core_data_wdata;
    logic        core_data_req, core_data_gnt, core_data_rvalid;
    logic        core_data_we  ;
    logic [ 3:0] core_data_be  ;
    logic        core_data_err ;

    logic is_scm_instr_req, is_scm_data_req;

    //DEBUG
    logic        debug_req   ;
    logic [14:0] debug_addr  ;
    logic        debug_we    ;
    logic [31:0] debug_wdata ;
    logic        debug_gnt   ;
    logic        debug_rvalid;
    logic [31:0] debug_rdata ;

    assign core_id_int       = 4'b0;
    assign cluster_id_int    = 6'b01_1111;
    assign perf_counters_int = 1'b0;
    assign fetch_en_int      = fetch_en_eu & fetch_en_i;

    XBAR_TCDM_BUS core_data_bus ();
    XBAR_TCDM_BUS core_instr_bus ();

    //********************************************************
    //************ CORE DEMUX (TCDM vs L2) *******************
    //********************************************************

    assign is_scm_instr_req = (core_instr_addr < `SOC_L2_PRI_CH0_SCM_END_ADDR) && (core_instr_addr >= `SOC_L2_PRI_CH0_SCM_START_ADDR) || (core_instr_addr < `ALIAS_SOC_L2_PRI_CH0_SCM_END_ADDR) && (core_instr_addr >= `ALIAS_SOC_L2_PRI_CH0_SCM_START_ADDR);

    fc_demux fc_demux_instr_i (
        .clk          ( clk_i               ),
        .rst_n        ( rst_ni              ),
        .port_sel_i   ( is_scm_instr_req    ),
        .slave_port   ( core_instr_bus      ),
        .master_port0 ( l2_instr_master     ),
        .master_port1 ( scm_l2_instr_master )
    );

    assign core_instr_bus.req   = core_instr_req;
    assign core_instr_bus.add   = core_instr_addr;
    assign core_instr_bus.wen   = ~1'b0;
    assign core_instr_bus.wdata = '0;
    assign core_instr_bus.be    = 4'b1111;
    assign core_instr_gnt       = core_instr_bus.gnt;
    assign core_instr_rvalid    = core_instr_bus.r_valid;
    assign core_instr_rdata     = core_instr_bus.r_rdata;

    assign is_scm_data_req = (core_data_addr < `SOC_L2_PRI_CH0_SCM_END_ADDR) && (core_data_addr >= `SOC_L2_PRI_CH0_SCM_START_ADDR) || (core_data_addr < `ALIAS_SOC_L2_PRI_CH0_SCM_END_ADDR) && (core_data_addr >= `ALIAS_SOC_L2_PRI_CH0_SCM_START_ADDR);

    fc_demux fc_demux_data_i (
        .clk          ( clk_i              ),
        .rst_n        ( rst_ni             ),
        .port_sel_i   ( is_scm_data_req    ),
        .slave_port   ( core_data_bus      ),
        .master_port0 ( l2_data_master     ),
        .master_port1 ( scm_l2_data_master )
    );

    assign core_data_bus.req   = core_data_req;
    assign core_data_bus.add   = core_data_addr;
    assign core_data_bus.wen   = ~core_data_we;
    assign core_data_bus.wdata = core_data_wdata;
    assign core_data_bus.be    = core_data_be;
    assign core_data_gnt       = core_data_bus.gnt;
    assign core_data_rvalid    = core_data_bus.r_valid;
    assign core_data_rdata     = core_data_bus.r_rdata;

    //********************************************************
    //************ RISCV CORE ********************************
    //********************************************************
    generate
    if ( USE_ZERORISCY == 0) begin: FC_CORE

    riscv_core #(
        .N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ),
        .PULP_CLUSTER        ( 0                   ),
        .FPU                 ( USE_FPU             ),
        .SHARED_FP           ( 0                   ),
        .SHARED_FP_DIVSQRT   ( 2                   )
    ) lFC_CORE (
        .clk_i                 ( clk_i             ),
        .rst_ni                ( rst_ni            ),
        .clock_en_i            ( core_clock_en     ),
        .test_en_i             ( test_en_i         ),
        .boot_addr_i           ( boot_addr_i       ),
        .core_id_i             ( core_id_int       ),
        .cluster_id_i          ( cluster_id_int    ),

        // Instruction Memory Interface:  Interface to Instruction Logaritmic interconnect: Req->grant handshake
        .instr_addr_o          ( core_instr_addr   ),
        .instr_req_o           ( core_instr_req    ),
        .instr_rdata_i         ( core_instr_rdata  ),
        .instr_gnt_i           ( core_instr_gnt    ),
        .instr_rvalid_i        ( core_instr_rvalid ),

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

        // apu-interconnect
        // handshake signals
        .apu_master_req_o      (                   ),
        .apu_master_ready_o    (                   ),
        .apu_master_gnt_i      ( 1'b1              ),
        // request channel
        .apu_master_operands_o (                   ),
        .apu_master_op_o       (                   ),
        .apu_master_type_o     (                   ),
        .apu_master_flags_o    (                   ),
        // response channel
        .apu_master_valid_i    ( '0                ),
        .apu_master_result_i   ( '0                ),
        .apu_master_flags_i    ( '0                ),

        .irq_i                 ( core_irq_req      ),
        .irq_id_i              ( core_irq_id       ),
        .irq_ack_o             ( core_irq_ack      ),
        .irq_id_o              ( core_irq_ack_id   ),
        .irq_sec_i             ( 1'b0              ),
        .sec_lvl_o             (                   ),

        .debug_req_i           ( debug_req         ),
        .debug_gnt_o           ( debug_gnt         ),
        .debug_rvalid_o        ( debug_rvalid      ),
        .debug_addr_i          ( debug_addr        ),
        .debug_we_i            ( debug_we          ),
        .debug_wdata_i         ( debug_wdata       ),
        .debug_rdata_o         ( debug_rdata       ),
        .debug_halted_o        (                   ),
        .debug_halt_i          ( 1'b0              ),
        .debug_resume_i        ( 1'b0              ),
        .fetch_enable_i        ( fetch_en_int      ),
        .core_busy_o           (                   ),
        .ext_perf_counters_i   ( perf_counters_int ),
        .fregfile_disable_i    ( 1'b0              ) // try me!
    );
    end else begin: FC_CORE

    zeroriscy_core #(
        .N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ),
        .RV32E               ( ZERORISCY_RV32E     ),
        .RV32M               ( ZERORISCY_RV32M     )
    ) lFC_CORE (
        .clk_i                 ( clk_i             ),
        .rst_ni                ( rst_ni            ),
        .clock_en_i            ( core_clock_en     ),
        .test_en_i             ( test_en_i         ),
        .boot_addr_i           ( boot_addr_i       ),
        .core_id_i             ( core_id_int       ),
        .cluster_id_i          ( cluster_id_int    ),

        // Instruction Memory Interface:  Interface to Instruction Logaritmic interconnect: Req->grant handshake
        .instr_addr_o          ( core_instr_addr   ),
        .instr_req_o           ( core_instr_req    ),
        .instr_rdata_i         ( core_instr_rdata  ),
        .instr_gnt_i           ( core_instr_gnt    ),
        .instr_rvalid_i        ( core_instr_rvalid ),

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

        .irq_i                 ( core_irq_req      ),
        .irq_id_i              ( core_irq_id       ),
        .irq_ack_o             ( core_irq_ack      ),
        .irq_id_o              ( core_irq_ack_id   ),

        .debug_req_i           ( debug_req         ),
        .debug_gnt_o           ( debug_gnt         ),
        .debug_rvalid_o        ( debug_rvalid      ),
        .debug_addr_i          ( debug_addr        ),
        .debug_we_i            ( debug_we          ),
        .debug_wdata_i         ( debug_wdata       ),
        .debug_rdata_o         ( debug_rdata       ),
        .debug_halted_o        (                   ),
        .debug_halt_i          ( 1'b0              ),
        .debug_resume_i        ( 1'b0              ),
        .fetch_enable_i        ( fetch_en_int      ),
        .ext_perf_counters_i   ( perf_counters_int )
    );
    end
    endgenerate

    assign supervisor_mode_o = 1'b1;

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

    apb2per #(
        .PER_ADDR_WIDTH ( 15  ),
        .APB_ADDR_WIDTH ( 32  )
    ) apb2per_debug_i (
        .clk_i                ( clk_i                   ),
        .rst_ni               ( rst_ni                  ),

        .PADDR                ( apb_slave_debug.paddr   ),
        .PWDATA               ( apb_slave_debug.pwdata  ),
        .PWRITE               ( apb_slave_debug.pwrite  ),
        .PSEL                 ( apb_slave_debug.psel    ),
        .PENABLE              ( apb_slave_debug.penable ),
        .PRDATA               ( apb_slave_debug.prdata  ),
        .PREADY               ( apb_slave_debug.pready  ),
        .PSLVERR              ( apb_slave_debug.pslverr ),

        .per_master_req_o     ( debug_req               ),
        .per_master_add_o     ( debug_addr              ),
        .per_master_we_o      ( debug_we                ),
        .per_master_wdata_o   ( debug_wdata             ),
        .per_master_be_o      (                         ),
        .per_master_gnt_i     ( debug_gnt               ),

        .per_master_r_valid_i ( debug_rvalid            ),
        .per_master_r_opc_i   ( '0                      ),
        .per_master_r_rdata_i ( debug_rdata             )
    );

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

endmodule
