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
`include "axi/typedef.svh"
`include "axi/assign.svh"

module pulp_soc import dm::*; #(
    parameter CORE_TYPE          = 0,
    parameter PULP_XPULP         = 1,
    parameter USE_FPU            = 1,
    parameter USE_HWPE           = 1,
    parameter USE_CLUSTER_EVENT  = 1,
    parameter ZFINX              = 0,
    parameter AXI_ADDR_WIDTH     = 32,
    parameter AXI_DATA_IN_WIDTH  = 64,
    parameter AXI_DATA_OUT_WIDTH = 32,
    parameter AXI_ID_IN_WIDTH    = 7,
    parameter AXI_ID_OUT_WIDTH   = 5,
    parameter AXI_USER_WIDTH     = 6,
    parameter AXI_STRB_WIDTH_IN  = AXI_DATA_IN_WIDTH/8,
    parameter AXI_STRB_WIDTH_OUT = AXI_DATA_OUT_WIDTH/8,
    parameter BUFFER_WIDTH       = 8,
    parameter C2S_AW_WIDTH       = 80,
    parameter C2S_W_WIDTH        = 79,
    parameter C2S_B_WIDTH        = 15,
    parameter C2S_AR_WIDTH       = 74,
    parameter C2S_R_WIDTH        = 80,
    parameter S2C_AW_WIDTH       = 78,
    parameter S2C_W_WIDTH        = 43,
    parameter S2C_B_WIDTH        = 13,
    parameter S2C_AR_WIDTH       = 72,
    parameter S2C_R_WIDTH        = 46,
    parameter LOG_DEPTH          = 3,
    parameter EVNT_WIDTH         = 8,
    parameter NB_CORES           = 8,
    parameter NB_HWPE_PORTS      = 4,
    parameter NGPIO              = 32,
    parameter NBIT_PADCFG        = 4, //Must not be changed as other parts
                                      //downstreams are not parametrci

    parameter int unsigned N_UART = 1,
    parameter int unsigned N_SPI  = 1,
    parameter int unsigned N_I2C  = 2,
    parameter int unsigned N_I2C_SLV  = 2,

    parameter int unsigned N_L2_BANKS = 0,
    parameter int unsigned N_L2_BANKS_PRI = 0,
    parameter int unsigned L2_BANK_SIZE = 0,
    parameter int unsigned L2_BANK_SIZE_PRI = 0
) (
    input  logic                          sys_clk_i,
    input  logic                          ref_clk_i,
    output logic                          soc_clk_o,
    input  logic                          test_clk_i,
    input  logic                          rstn_glob_i,
    output logic                          rst_l2_no,

    input  logic                          dft_test_mode_i,
    input  logic                          dft_cg_enable_i,
    input  logic                          mode_select_i,
    input  logic [1:0]                    bootsel_i,

    input  logic                          fc_fetch_en_valid_i,
    input  logic                          fc_fetch_en_i,

    // AXI interfaces to outside of control pulp
    AXI_BUS.Slave                         axi_ext_slv,  // from nci_cp_top
    AXI_BUS.Master                        axi_ext_mst,

    // TCDM interfaces to memory cuts (all are placed outside of control-pulp)
    XBAR_TCDM_BUS.Master                  s_mem_l2_bus[N_L2_BANKS-1:0],
    XBAR_TCDM_BUS.Master                  s_mem_l2_pri_bus[N_L2_BANKS_PRI-1:0],

    output logic                          cluster_rtc_o,
    output logic                          cluster_fetch_enable_o,
    output logic [63:0]                   cluster_boot_addr_o,
    output logic                          cluster_test_en_o,
    output logic                          cluster_pow_o,
    output logic                          cluster_byp_o,
    output logic                          cluster_rstn_o,
    output logic                          cluster_irq_o,

    // AXI4 SLAVE
    input logic [LOG_DEPTH:0]                         async_data_slave_aw_wptr_i,
    input logic [2**LOG_DEPTH-1:0][C2S_AW_WIDTH-1:0]  async_data_slave_aw_data_i,
    output logic [LOG_DEPTH:0]                        async_data_slave_aw_rptr_o,

    // READ ADDRESS CHANNEL
    input logic [LOG_DEPTH:0]                         async_data_slave_ar_wptr_i,
    input logic [2**LOG_DEPTH-1:0][C2S_AR_WIDTH-1:0]  async_data_slave_ar_data_i,
    output logic [LOG_DEPTH:0]                        async_data_slave_ar_rptr_o,

    // WRITE DATA CHANNEL
    input logic [LOG_DEPTH:0]                         async_data_slave_w_wptr_i,
    input logic [2**LOG_DEPTH-1:0][C2S_W_WIDTH-1:0]   async_data_slave_w_data_i,
    output logic [LOG_DEPTH:0]                        async_data_slave_w_rptr_o,

    // READ DATA CHANNEL
    output logic [LOG_DEPTH:0]                        async_data_slave_r_wptr_o,
    output logic [2**LOG_DEPTH-1:0][C2S_R_WIDTH-1:0]  async_data_slave_r_data_o,
    input logic [LOG_DEPTH:0]                         async_data_slave_r_rptr_i,

    // WRITE RESPONSE CHANNEL
    output logic [LOG_DEPTH:0]                        async_data_slave_b_wptr_o,
    output logic [2**LOG_DEPTH-1:0][C2S_B_WIDTH-1:0]  async_data_slave_b_data_o,
    input logic [LOG_DEPTH:0]                         async_data_slave_b_rptr_i,

    // AXI4 MASTER
    output logic [LOG_DEPTH:0]                        async_data_master_aw_wptr_o,
    output logic [2**LOG_DEPTH-1:0][S2C_AW_WIDTH-1:0] async_data_master_aw_data_o,
    input logic [LOG_DEPTH:0]                         async_data_master_aw_rptr_i,

    // READ ADDRESS CHANNEL
    output logic [LOG_DEPTH:0]                        async_data_master_ar_wptr_o,
    output logic [2**LOG_DEPTH-1:0][S2C_AR_WIDTH-1:0] async_data_master_ar_data_o,
    input logic [LOG_DEPTH:0]                         async_data_master_ar_rptr_i,

    // WRITE DATA CHANNEL
    output logic [LOG_DEPTH:0]                        async_data_master_w_wptr_o,
    output logic [2**LOG_DEPTH-1:0][S2C_W_WIDTH-1:0]  async_data_master_w_data_o,
    input logic [LOG_DEPTH:0]                         async_data_master_w_rptr_i,

    // READ DATA CHANNEL
    input logic [LOG_DEPTH:0]                         async_data_master_r_wptr_i,
    input logic [2**LOG_DEPTH-1:0][S2C_R_WIDTH-1:0]   async_data_master_r_data_i,
    output logic [LOG_DEPTH:0]                        async_data_master_r_rptr_o,

    // WRITE RESPONSE CHANNEL
    input logic [LOG_DEPTH:0]                         async_data_master_b_wptr_i,
    input logic [2**LOG_DEPTH-1:0][S2C_B_WIDTH-1:0]   async_data_master_b_data_i,
    output logic [LOG_DEPTH:0]                        async_data_master_b_rptr_o,

    output logic [BUFFER_WIDTH-1:0]                   cluster_events_wt_o,
    input logic [BUFFER_WIDTH-1:0]                    cluster_events_rp_i,
    output logic [EVNT_WIDTH-1:0]                     cluster_events_da_o,
    output logic                                      cluster_clk_o,
    input logic                                       cluster_busy_i,
    output logic                                      dma_pe_evt_ack_o,
    input logic                                       dma_pe_evt_valid_i,
    output logic                                      dma_pe_irq_ack_o,
    input logic                                       dma_pe_irq_valid_i,
    output logic                                      pf_evt_ack_o,
    input logic                                       pf_evt_valid_i,
    ///////////////////////////////////////////////////
    //      To I/O Controller and padframe           //
    ///////////////////////////////////////////////////

    input  logic [NGPIO-1:0]                  gpio_in_i,
    output logic [NGPIO-1:0]                  gpio_out_o,
    output logic [NGPIO-1:0]                  gpio_dir_o,
    output logic [NGPIO-1:0][NBIT_PADCFG-1:0] gpio_cfg_o,

    output logic [N_UART-1:0]             uart_tx_o,
    input  logic [N_UART-1:0]             uart_rx_i,
    output logic [3:0]                    timer_ch0_o,
    output logic [3:0]                    timer_ch1_o,
    output logic [3:0]                    timer_ch2_o,
    output logic [3:0]                    timer_ch3_o,

    input  logic [N_I2C-1:0]              i2c_scl_i,
    output logic [N_I2C-1:0]              i2c_scl_o,
    output logic [N_I2C-1:0]              i2c_scl_oe_o,
    input  logic [N_I2C-1:0]              i2c_sda_i,
    output logic [N_I2C-1:0]              i2c_sda_o,
    output logic [N_I2C-1:0]              i2c_sda_oe_o,

    input logic  [N_I2C_SLV-1:0]          i2c_slv_scl_i,
    output logic [N_I2C_SLV-1:0]          i2c_slv_scl_o,
    output logic [N_I2C_SLV-1:0]          i2c_slv_scl_oe_o,
    input logic  [N_I2C_SLV-1:0]          i2c_slv_sda_i,
    output logic [N_I2C_SLV-1:0]          i2c_slv_sda_o,
    output logic [N_I2C_SLV-1:0]          i2c_slv_sda_oe_o,

    output logic [N_SPI-1:0]              spi_clk_o,
    output logic [N_SPI-1:0][3:0]         spi_csn_o,
    output logic [N_SPI-1:0][3:0]         spi_oen_o,
    output logic [N_SPI-1:0][3:0]         spi_sdo_o,
    input  logic [N_SPI-1:0][3:0]         spi_sdi_i,

    input  logic                          spi_clk_i,
    input  logic                          spi_csn_i,
    output logic [3:0]                    spi_oen_slv_o,
    output logic [3:0]                    spi_sdo_slv_o,
    input  logic [3:0]                    spi_sdi_slv_i,

    //inter-socket mux signal
    output logic                          sel_spi_dir_o,

    output logic                          sdio_clk_o,
    output logic                          sdio_cmd_o,
    input  logic                          sdio_cmd_i,
    output logic                          sdio_cmd_oen_o,
    output logic                    [3:0] sdio_data_o,
    input  logic                    [3:0] sdio_data_i,
    output logic                    [3:0] sdio_data_oen_o,

    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    // From JTAG Tap Controller to axi_dcb module    //
    ///////////////////////////////////////////////////
    input logic                                       jtag_tck_i,
    input logic                                       jtag_trst_ni,
    input logic                                       jtag_tms_i,
    input logic                                       jtag_tdi_i,
    output logic                                      jtag_tdo_o,
    output logic [NB_CORES-1:0]                       cluster_dbg_irq_valid_o,
    ///////////////////////////////////////////////////

    // external interrupts
    input logic                           scg_irq_i,
    input logic                           scp_irq_i,
    input logic                           scp_secure_irq_i,
    input logic [71:0]                    mbox_irq_i,
    input logic [71:0]                    mbox_secure_irq_i
);

    localparam int unsigned AXI_DATA_EXT_WIDTH = 64;

    localparam int unsigned CLK_CTRL_ADDR_WIDTH = 32;
    localparam int unsigned CLK_CTRL_DATA_WIDTH = 32;

    localparam L2_MEM_ADDR_WIDTH     = $clog2(L2_BANK_SIZE * N_L2_BANKS) - $clog2(N_L2_BANKS);    // 2**L2_MEM_ADDR_WIDTH rows (64bit each) in L2 --> TOTAL L2 SIZE = 8byte * 2^L2_MEM_ADDR_WIDTH

    localparam ROM_ADDR_WIDTH        = 13;

    localparam FC_CORE_CLUSTER_ID    = 6'd31;
    localparam CL_CORE_CLUSTER_ID    = 6'd0;

    localparam FC_CORE_CORE_ID       = 4'd0;
    localparam FC_CORE_MHARTID       = {FC_CORE_CLUSTER_ID, 1'b0, FC_CORE_CORE_ID};

    //  PULP RISC-V cores have not continguos MHARTID.
    //  This leads to set the number of HARTS >= the maximum value of the MHARTID.
    //  In this case, the MHARD ID is {FC_CORE_CLUSTER_ID,1'b0,FC_CORE_CORE_ID} --> 996 (1024 chosen as power of 2)
    //  To avoid paying 1024 flip flop for each number of harts's related register, we implemented
    //  the masking parameter, aka SELECTABLE_HARTS.
    //  In One-Hot-Encoding way, you select 1 when that MHARTID-related HART can actally be selected.
    //  e.g. if you have 2 core with MHART 10 and 5, you select NrHarts=16 and SELECTABLE_HARTS = (1<<10) | (1<<5).
    //  This mask will be used to generated only the flip flop needed and the constant-propagator engine of the synthesizer
    //  will remove the other flip flops and related logic.

    localparam NrHarts                               = 1024;

    // this is a constant expression
    function logic [NrHarts-1:0] SEL_HARTS_FX();
        SEL_HARTS_FX = (1 << FC_CORE_MHARTID);
        for (int i = 0; i < NB_CORES; i++) begin
            SEL_HARTS_FX |= (1 << {CL_CORE_CLUSTER_ID, 1'b0, i[3:0]});
        end
    endfunction

    // Each hart with hartid=x sets the x'th bit in SELECTABLE_HARTS
    localparam logic [NrHarts-1:0] SELECTABLE_HARTS = SEL_HARTS_FX();

    // cluster core ids gathere as vector for convenience
    logic [NB_CORES-1:0][10:0] cluster_core_id;
    for (genvar i = 0; i < NB_CORES; i++) begin : gen_cluster_core_id
        assign cluster_core_id[i] = {CL_CORE_CLUSTER_ID, 1'b0, i[3:0]};
    end

    localparam dm::hartinfo_t RI5CY_HARTINFO = '{
       zero1:        '0,
       nscratch:      2, // Debug module needs at least two scratch regs
       zero0:        '0,
       dataaccess: 1'b1, // data registers are memory mapped in the debugger
       datasize: dm::DataCount,
       dataaddr: dm::DataAddr
    };

    dm::hartinfo_t [NrHarts-1:0] hartinfo;

    /*
       This module has been tested only with the default parameters.
    */

    //********************************************************
    //***************** SIGNALS DECLARATION ******************
    //********************************************************
    logic [ 1:0]           s_fc_hwpe_events;
    logic [31:0]           s_fc_events;

    logic [7:0]            s_soc_events_ack;
    logic [7:0]            s_soc_events_val;

    logic                  s_timer_lo_event;
    logic                  s_timer_hi_event;

    logic [EVNT_WIDTH-1:0] s_cl_event_data ;
    logic                  s_cl_event_valid;
    logic                  s_cl_event_ready;

    logic [EVNT_WIDTH-1:0] s_fc_event_data ;
    logic                  s_fc_event_valid;
    logic                  s_fc_event_ready;

    logic                  s_plic_irq_valid;
    logic                  s_plic_irq_ready;

    logic [7:0][31:0]      s_apb_mpu_rules;
    logic                  s_supervisor_mode;

    logic [31:0]           s_fc_bootaddr;

    logic                  s_slow_clk;

    logic                  s_periph_clk;
    logic                  s_periph_rstn;
    logic                  s_soc_clk;
    logic                  s_soc_rstn;
    logic                  s_cluster_clk;
    logic                  s_cluster_rstn;
    logic                  s_cluster_rstn_soc_ctrl;
    logic                  s_sel_clk;

    logic                  s_dma_pe_evt;
    logic                  s_dma_pe_irq;
    logic                  s_pf_evt;

    logic                  s_fc_fetchen;
    logic [NrHarts-1:0]    dm_debug_req;

    logic                  jtag_req_valid;
    logic                  debug_req_ready;
    logic                  jtag_resp_ready;
    logic                  jtag_resp_valid;
    dm::dmi_req_t          jtag_dmi_req;
    dm::dmi_resp_t         debug_resp;
    logic                  slave_grant, slave_valid, slave_req , slave_we;
    logic                  [31:0] slave_addr, slave_wdata, slave_rdata;
    logic                  [3:0]  slave_be;
    logic                  lint_riscv_jtag_bus_master_we;
    logic                  int_td;

    logic                  master_req;
    logic [31:0]           master_add;
    logic                  master_we;
    logic [31:0]           master_wdata;
    logic [3:0]            master_be;
    logic                  master_gnt;
    logic                  master_r_valid;
    logic [31:0]           master_r_rdata;


    logic [7:0]            soc_jtag_reg_tap;
    logic [7:0]            soc_jtag_reg_soc;


    logic                  spi_master0_csn3, spi_master0_csn2;

    logic                  wdt_reset_o;

    // Propagate soc_clk to top-level (it feeds AXI ports)
    assign soc_clk_o = s_soc_clk;

    // tap to lint wrap
    logic                  s_jtag_shift_dr;
    logic                  s_jtag_update_dr;
    logic                  s_jtag_capture_dr;
    logic                  s_jtag_axireg_sel;
    logic                  s_jtag_axireg_tdi;
    logic                  s_jtag_axireg_tdo;

    APB_BUS                s_apb_eu_bus ();
    APB_BUS                s_apb_hwpe_bus ();
    APB_BUS                s_apb_debug_bus();
    APB_BUS                s_apb_clk_ctrl_bus();

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH   ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH    )
    ) s_data_in_bus (); // from cluster

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH ( AXI_DATA_OUT_WIDTH),
        .AXI_ID_WIDTH   ( AXI_ID_OUT_WIDTH  ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH    )
    ) s_data_out_bus (); // to cluster

    ////////////////////
    // AXI Mux inputs //
    ////////////////////

    // 5 inputs to AXI Mux from external: cl_slv, spi_slv, i2c_slv_1, i2c_slv_2, ext_slv (i.e. nci_cp_top)

    localparam int unsigned N_EXT_MASTERS_TO_SOC = 5; // 3 + 2 i2c

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH  ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH    ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
    ) s_axi_spi (); // from spi_slv

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH  ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH    ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
    ) axi_i2c_slv_bmc (); // from i2c_slv_1

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH  ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH    ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
    ) axi_i2c_slv_1 (); // from i2c_slv_2

    // Wrap into single interface
    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH  ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH    ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
    ) ext_masters_to_soc [N_EXT_MASTERS_TO_SOC-1:0] ();

    `AXI_ASSIGN(ext_masters_to_soc[0], s_data_in_bus);    // from cluster
    `AXI_ASSIGN(ext_masters_to_soc[1], s_axi_spi);        // from spi_slv
    `AXI_ASSIGN(ext_masters_to_soc[2], axi_ext_slv);      // from ext (nci_cp_top)
    `AXI_ASSIGN(ext_masters_to_soc[3], axi_i2c_slv_1);    // from i2c_slv_1
    `AXI_ASSIGN(ext_masters_to_soc[4], axi_i2c_slv_bmc);  // from i2c_slv_2

    //assign s_data_out_bus.aw_atop = 6'b0;

    APB_BUS s_apb_periph_bus ();

    XBAR_TCDM_BUS s_mem_rom_bus ();

    XBAR_TCDM_BUS s_lint_debug_bus();
    XBAR_TCDM_BUS s_lint_pulp_jtag_bus();
    XBAR_TCDM_BUS s_lint_riscv_jtag_bus();
    XBAR_TCDM_BUS s_lint_udma_tx_bus ();
    XBAR_TCDM_BUS s_lint_udma_rx_bus ();
    XBAR_TCDM_BUS s_lint_fc_data_bus ();
    XBAR_TCDM_BUS s_lint_fc_instr_bus ();
    XBAR_TCDM_BUS s_lint_hwpe_bus[NB_HWPE_PORTS-1:0]();

    `ifdef REMAP_ADDRESS
        logic [3:0] base_addr_int;
        assign base_addr_int = 4'b0001; //FIXME attach this signal somewhere in the soc peripherals --> IGOR
    `endif

    logic s_cluster_isolate_dc;
    logic s_rstn_cluster_sync_soc;

    assign cluster_clk_o  = s_cluster_clk;
    assign cluster_rstn_o = s_cluster_rstn && s_cluster_rstn_soc_ctrl;
    assign s_rstn_cluster_sync_soc = s_cluster_rstn && s_cluster_rstn_soc_ctrl;

    assign cluster_rtc_o     = ref_clk_i;
    assign cluster_test_en_o = dft_test_mode_i;
    // isolate dc if the cluster is down
    assign s_cluster_isolate_dc = 1'b0;
//cluster_byp_o;

   // If you want to connect a real PULP cluster you also need a cluster_busy_i signal

   `AXI_TYPEDEF_AW_CHAN_T(c2s_aw_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_W_CHAN_T(c2s_w_chan_t,logic[AXI_DATA_IN_WIDTH-1:0],logic[AXI_DATA_IN_WIDTH/8-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_B_CHAN_T(c2s_b_chan_t,logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_AR_CHAN_T(c2s_ar_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_R_CHAN_T(c2s_r_chan_t,logic[AXI_DATA_IN_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])

   `AXI_TYPEDEF_REQ_T(c2s_req_t,c2s_aw_chan_t,c2s_w_chan_t,c2s_ar_chan_t)
   `AXI_TYPEDEF_RESP_T(c2s_resp_t,c2s_b_chan_t,c2s_r_chan_t)

   c2s_req_t   dst_req ;
   c2s_resp_t  dst_resp;

   `AXI_ASSIGN_FROM_REQ(s_data_in_bus,dst_req)
   `AXI_ASSIGN_TO_RESP(dst_resp,s_data_in_bus)

   // CLUSTER TO SOC AXI
   axi_cdc_dst #(
     .aw_chan_t (c2s_aw_chan_t),
     .w_chan_t  (c2s_w_chan_t ),
     .b_chan_t  (c2s_b_chan_t ),
     .r_chan_t  (c2s_r_chan_t ),
     .ar_chan_t (c2s_ar_chan_t),
     .axi_req_t (c2s_req_t    ),
     .axi_resp_t(c2s_resp_t   ),
     .LogDepth        ( 3                      )
    ) axi_slave_cdc_i (
     .dst_rst_ni                       ( s_cluster_rstn             ),
     .dst_clk_i                        ( s_soc_clk                  ),
     .dst_req_o                        ( dst_req                    ),
     .dst_resp_i                       ( dst_resp                   ),
     .async_data_slave_aw_wptr_i       ( async_data_slave_aw_wptr_i ),
     .async_data_slave_aw_rptr_o       ( async_data_slave_aw_rptr_o ),
     .async_data_slave_aw_data_i       ( async_data_slave_aw_data_i ),
     .async_data_slave_w_wptr_i        ( async_data_slave_w_wptr_i  ),
     .async_data_slave_w_rptr_o        ( async_data_slave_w_rptr_o  ),
     .async_data_slave_w_data_i        ( async_data_slave_w_data_i  ),
     .async_data_slave_ar_wptr_i       ( async_data_slave_ar_wptr_i ),
     .async_data_slave_ar_rptr_o       ( async_data_slave_ar_rptr_o ),
     .async_data_slave_ar_data_i       ( async_data_slave_ar_data_i ),
     .async_data_slave_b_wptr_o        ( async_data_slave_b_wptr_o  ),
     .async_data_slave_b_rptr_i        ( async_data_slave_b_rptr_i  ),
     .async_data_slave_b_data_o        ( async_data_slave_b_data_o  ),
     .async_data_slave_r_wptr_o        ( async_data_slave_r_wptr_o  ),
     .async_data_slave_r_rptr_i        ( async_data_slave_r_rptr_i  ),
     .async_data_slave_r_data_o        ( async_data_slave_r_data_o  )
    );


   `AXI_TYPEDEF_AW_CHAN_T(s2c_aw_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_OUT_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_W_CHAN_T(s2c_w_chan_t,logic[AXI_DATA_OUT_WIDTH-1:0],logic[AXI_DATA_OUT_WIDTH/8-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_B_CHAN_T(s2c_b_chan_t,logic[AXI_ID_OUT_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_AR_CHAN_T(s2c_ar_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_OUT_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_R_CHAN_T(s2c_r_chan_t,logic[AXI_DATA_OUT_WIDTH-1:0],logic[AXI_ID_OUT_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])

   `AXI_TYPEDEF_REQ_T(s2c_req_t,s2c_aw_chan_t,s2c_w_chan_t,s2c_ar_chan_t)
   `AXI_TYPEDEF_RESP_T(s2c_resp_t,s2c_b_chan_t,s2c_r_chan_t)

   s2c_req_t   src_req ;
   s2c_resp_t  src_resp;

   `AXI_ASSIGN_TO_REQ(src_req,s_data_out_bus)
   `AXI_ASSIGN_FROM_RESP(s_data_out_bus,src_resp)


   // SOC TO CLUSTER
   axi_cdc_src #(
     .aw_chan_t (s2c_aw_chan_t),
     .w_chan_t  (s2c_w_chan_t),
     .b_chan_t  (s2c_b_chan_t),
     .r_chan_t  (s2c_r_chan_t),
     .ar_chan_t (s2c_ar_chan_t),
     .axi_req_t (s2c_req_t              ),
     .axi_resp_t(s2c_resp_t             ),
    .LogDepth        ( LOG_DEPTH               )
    ) axi_master_cdc_i (
     .src_rst_ni                       ( s_rstn_cluster_sync_soc     ),
     .src_clk_i                        ( s_soc_clk                   ),
     .src_req_i                        ( src_req                     ),
     .src_resp_o                       ( src_resp                    ),
     .async_data_master_aw_wptr_o      ( async_data_master_aw_wptr_o ),
     .async_data_master_aw_rptr_i      ( async_data_master_aw_rptr_i ),
     .async_data_master_aw_data_o      ( async_data_master_aw_data_o ),
     .async_data_master_w_wptr_o       ( async_data_master_w_wptr_o  ),
     .async_data_master_w_rptr_i       ( async_data_master_w_rptr_i  ),
     .async_data_master_w_data_o       ( async_data_master_w_data_o  ),
     .async_data_master_ar_wptr_o      ( async_data_master_ar_wptr_o ),
     .async_data_master_ar_rptr_i      ( async_data_master_ar_rptr_i ),
     .async_data_master_ar_data_o      ( async_data_master_ar_data_o ),
     .async_data_master_b_wptr_i       ( async_data_master_b_wptr_i  ),
     .async_data_master_b_rptr_o       ( async_data_master_b_rptr_o  ),
     .async_data_master_b_data_i       ( async_data_master_b_data_i  ),
     .async_data_master_r_wptr_i       ( async_data_master_r_wptr_i  ),
     .async_data_master_r_rptr_o       ( async_data_master_r_rptr_o  ),
     .async_data_master_r_data_i       ( async_data_master_r_data_i  )
    );

    //********************************************************
    //********************* SOC L2 RAM ***********************
    //********************************************************

    // NOTE: The L2 memories are outside the control-pulp module!

    //********************************************************
    //******              SOC BOOT ROM             ***********
    //********************************************************

    boot_rom #(
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
    ) boot_rom_i (
        .clk_i       ( s_soc_clk       ),
        .rst_ni      ( s_soc_rstn      ),
        .init_ni     ( 1'b1            ),
        .mem_slave   ( s_mem_rom_bus   ),
        .test_mode_i ( dft_test_mode_i )
    );

    //********************************************************
    //********************* SOC PERIPHERALS ******************
    //********************************************************

    soc_peripherals #(
        .CORE_TYPE          ( CORE_TYPE                             ),
        .MEM_ADDR_WIDTH     ( L2_MEM_ADDR_WIDTH+$clog2(N_L2_BANKS)  ),
        .APB_ADDR_WIDTH     ( 32                                    ),
        .APB_DATA_WIDTH     ( 32                                    ),
        .NB_CORES           ( NB_CORES                              ),
        .NB_CLUSTERS        ( `NB_CLUSTERS                          ),
        .EVNT_WIDTH         ( EVNT_WIDTH                            ),
        .NGPIO              ( NGPIO                                 ),
        .NBIT_PADCFG        ( NBIT_PADCFG                           ),
        .N_UART             ( N_UART                                ),
        .N_SPI              ( N_SPI                                 ),
        .N_I2C              ( N_I2C                                 ),
        .N_I2C_SLV          ( N_I2C_SLV                             ),

        // AXI widths for spi_slv, i2c_slvs AXI conversion within soc_peripherals
        .AXI_ADDR_WIDTH     ( AXI_ADDR_WIDTH                        ),
        .AXI_DATA_OUT_WIDTH ( AXI_DATA_OUT_WIDTH                    ),
        .AXI_DATA_IN_WIDTH  ( AXI_DATA_IN_WIDTH                     ),
        .AXI_64_ID_IN_WIDTH ( AXI_ID_IN_WIDTH                       ),
        .AXI_32_ID_OUT_WIDTH( AXI_ID_OUT_WIDTH                      ),
        .AXI_32_USER_WIDTH  ( AXI_USER_WIDTH                        )

    ) soc_peripherals_i (

        .clk_i                  ( s_soc_clk              ),
        .periph_clk_i           ( s_periph_clk           ),
        .rst_ni                 ( s_soc_rstn             ),
        .sel_clk_i              ( s_sel_clk              ),
        .slow_clk_i             ( s_slow_clk             ),

        .dft_test_mode_i        ( dft_test_mode_i        ),
        .dft_cg_enable_i        ( 1'b0                   ),

        .bootsel_i              ( bootsel_i              ),

        .fc_fetch_en_valid_i    ( fc_fetch_en_valid_i    ),
        .fc_fetch_en_i          ( fc_fetch_en_i          ),

        .fc_bootaddr_o          ( s_fc_bootaddr          ),
        .fc_fetchen_o           ( s_fc_fetchen           ),

        .apb_slave              ( s_apb_periph_bus       ),

        .apb_eu_master          ( s_apb_eu_bus           ),
        .apb_debug_master       ( s_apb_debug_bus        ),
        .apb_hwpe_master        ( s_apb_hwpe_bus         ),
        .apb_clk_ctrl_master    ( s_apb_clk_ctrl_bus     ),

        .l2_rx_master           ( s_lint_udma_rx_bus     ),
        .l2_tx_master           ( s_lint_udma_tx_bus     ),

        .axi_mst_spi_slv        ( s_axi_spi              ),

        .soc_jtag_reg_i         ( soc_jtag_reg_tap       ),
        .soc_jtag_reg_o         ( soc_jtag_reg_soc       ),

        .fc_hwpe_events_i       ( s_fc_hwpe_events       ),
        .fc_events_o            ( s_fc_events            ),

        .dma_pe_evt_i           ( s_dma_pe_evt           ),
        .dma_pe_irq_i           ( s_dma_pe_irq           ),
        .pf_evt_i               ( s_pf_evt               ),

        .scg_irq_i,
        .scp_irq_i,
        .scp_secure_irq_i,
        .mbox_irq_i,
        .mbox_secure_irq_i,

        .gpio_in                ( gpio_in_i              ),
        .gpio_out               ( gpio_out_o             ),
        .gpio_dir               ( gpio_dir_o             ),
        .gpio_padcfg            ( gpio_cfg_o             ),

        //UART
        .uart_tx                ( uart_tx_o              ),
        .uart_rx                ( uart_rx_i              ),

        //I2C
        .i2c_scl_i              ( i2c_scl_i              ),
        .i2c_scl_o              ( i2c_scl_o              ),
        .i2c_scl_oe_o           ( i2c_scl_oe_o           ),
        .i2c_sda_i              ( i2c_sda_i              ),
        .i2c_sda_o              ( i2c_sda_o              ),
        .i2c_sda_oe_o           ( i2c_sda_oe_o           ),

        //I2C slave
        .i2c_slv_scl_i          ( i2c_slv_scl_i          ),
        .i2c_slv_scl_o          ( i2c_slv_scl_o          ),
        .i2c_slv_scl_oe_o       ( i2c_slv_scl_oe_o       ),
        .i2c_slv_sda_i          ( i2c_slv_sda_i          ),
        .i2c_slv_sda_o          ( i2c_slv_sda_o          ),
        .i2c_slv_sda_oe_o       ( i2c_slv_sda_oe_o       ),

         //SPI MASTER
        .spi_clk_o              ( spi_clk_o              ),
        .spi_csn_o              ( spi_csn_o              ),
        .spi_oen_o              ( spi_oen_o              ),
        .spi_sdo_o              ( spi_sdo_o              ),
        .spi_sdi_i              ( spi_sdi_i              ),

         //SPI SLAVE
        .spi_clk_i              ( spi_clk_i              ),
        .spi_csn_i              ( spi_csn_i              ),
        .spi_oen_slv_o          ( spi_oen_slv_o          ),
        .spi_sdo_slv_o          ( spi_sdo_slv_o          ),
        .spi_sdi_slv_i          ( spi_sdi_slv_i          ),

        //INTER-SOCKET MUX SIGNALS
        .sel_spi_dir_o          ( sel_spi_dir_o          ),

        //SDIO
        .sdclk_o                ( sdio_clk_o             ),
        .sdcmd_o                ( sdio_cmd_o             ),
        .sdcmd_i                ( sdio_cmd_i             ),
        .sdcmd_oen_o            ( sdio_cmd_oen_o         ),
        .sddata_o               ( sdio_data_o            ),
        .sddata_i               ( sdio_data_i            ),
        .sddata_oen_o           ( sdio_data_oen_o        ),

        .timer_ch0_o            ( timer_ch0_o            ),
        .timer_ch1_o            ( timer_ch1_o            ),
        .timer_ch2_o            ( timer_ch2_o            ),
        .timer_ch3_o            ( timer_ch3_o            ),

        .cl_event_data_o        ( s_cl_event_data        ),
        .cl_event_valid_o       ( s_cl_event_valid       ),
        .cl_event_ready_i       ( s_cl_event_ready       ),

        .fc_event_data_o        ( s_fc_event_data        ),
        .fc_event_valid_o       ( s_fc_event_valid       ),
        .fc_event_ready_i       ( s_fc_event_ready       ),

        .plic_irq_valid_o       ( s_plic_irq_valid       ),
        .plic_irq_ready_i       ( s_plic_irq_ready       ),

        .cluster_pow_o          ( cluster_pow_o          ),
        .cluster_byp_o          ( cluster_byp_o          ),
        .cluster_boot_addr_o    ( cluster_boot_addr_o    ),
        .cluster_fetch_enable_o ( cluster_fetch_enable_o ),
        .cluster_rstn_o         ( s_cluster_rstn_soc_ctrl),
        .cluster_irq_o          ( cluster_irq_o          ),

        .wdt_reset_o            ( wdt_reset_o            ),
        .axi_i2c_slv_bmc        ( axi_i2c_slv_bmc        ),
        .axi_i2c_slv_1          ( axi_i2c_slv_1          )
    );



    dc_token_ring_fifo_din #(
        .DATA_WIDTH   ( EVNT_WIDTH   ),
        .BUFFER_DEPTH ( BUFFER_WIDTH )
    ) u_event_dc (
        .clk          ( s_soc_clk               ),
        .rstn         ( s_rstn_cluster_sync_soc ),
        .data         ( s_cl_event_data         ),
        .valid        ( s_cl_event_valid        ),
        .ready        ( s_cl_event_ready        ),
        .write_token  ( cluster_events_wt_o     ),
        .read_pointer ( cluster_events_rp_i     ),
        .data_async   ( cluster_events_da_o     )
    );


    edge_propagator_rx ep_dma_pe_evt_i (
        .clk_i   ( s_soc_clk               ),
        .rstn_i  ( s_rstn_cluster_sync_soc ),
        .valid_o ( s_dma_pe_evt            ),
        .ack_o   ( dma_pe_evt_ack_o        ),
        .valid_i ( dma_pe_evt_valid_i      )
    );

    edge_propagator_rx ep_dma_pe_irq_i (
        .clk_i   ( s_soc_clk               ),
        .rstn_i  ( s_rstn_cluster_sync_soc ),
        .valid_o ( s_dma_pe_irq            ),
        .ack_o   ( dma_pe_irq_ack_o        ),
        .valid_i ( dma_pe_irq_valid_i      )
    );
`ifndef PULP_FPGA_EMUL
    edge_propagator_rx ep_pf_evt_i (
        .clk_i   ( s_soc_clk               ),
        .rstn_i  ( s_rstn_cluster_sync_soc ),
        .valid_o ( s_pf_evt                ),
        .ack_o   ( pf_evt_ack_o            ),
        .valid_i ( pf_evt_valid_i          )
    );
`endif

    fc_subsystem #(
        .CORE_TYPE  ( CORE_TYPE          ),
        .PULP_XPULP ( PULP_XPULP         ),
        .USE_FPU    ( USE_FPU            ),
        .ZFINX      ( ZFINX              ),
        .CORE_ID    ( FC_CORE_CORE_ID    ),
        .CLUSTER_ID ( FC_CORE_CLUSTER_ID ),
        .USE_HWPE   ( USE_HWPE           )
    ) fc_subsystem_i (
        .clk_i               ( s_soc_clk           ),
        .rst_ni              ( s_soc_rstn          ),

        .test_en_i           ( dft_test_mode_i     ),

        //wdt
        .wdt_reset_i         ( wdt_reset_o         ),

        .boot_addr_i         ( s_fc_bootaddr       ),

        .fetch_en_i          ( s_fc_fetchen        ),

        .l2_data_master      ( s_lint_fc_data_bus  ),
        .l2_instr_master     ( s_lint_fc_instr_bus ),
        .l2_hwpe_master      ( s_lint_hwpe_bus     ),
        .apb_slave_eu        ( s_apb_eu_bus        ),
        .apb_slave_hwpe      ( s_apb_hwpe_bus      ),
        .debug_req_i         ( dm_debug_req[FC_CORE_MHARTID] ),

        .event_fifo_valid_i  ( s_fc_event_valid    ),
        .event_fifo_fulln_o  ( s_fc_event_ready    ),
        .event_fifo_data_i   ( s_fc_event_data     ),
        .events_i            ( s_fc_events         ),

        .plic_irq_valid_i    ( s_plic_irq_valid    ),
        .plic_irq_ready_o    ( s_plic_irq_ready    ),

        .hwpe_events_o       ( s_fc_hwpe_events    ),

        .supervisor_mode_o   ( s_supervisor_mode   )
    );

    assign rst_l2_no = s_soc_rstn;

    soc_clk_rst_gen i_clk_rst_gen (
        .sys_clk_i                  ( sys_clk_i                     ),
        .ref_clk_i                  ( ref_clk_i                     ),
        .test_clk_i                 ( test_clk_i                    ),
        .sel_clk_i                  ( s_sel_clk                     ),

        .rstn_glob_i                ( rstn_glob_i                   ),
        .rstn_soc_sync_o            ( s_soc_rstn                    ),
        .rstn_cluster_sync_o        ( s_cluster_rstn                ),

        .clk_cluster_o              ( s_cluster_clk                 ),
        .test_mode_i                ( dft_test_mode_i               ),
        .shift_enable_i             ( 1'b0                          ),

        .apb_slave                  ( s_apb_clk_ctrl_bus            ),

        .clk_soc_o                  ( s_soc_clk                     ),
        .clk_per_o                  ( s_periph_clk                  ),
        .clk_slow_o                 ( s_slow_clk                    )
    );

    soc_interconnect_wrap #(
        .NR_HWPE_PORTS       ( NB_HWPE_PORTS    ),
        .NR_L2_PORTS         ( control_pulp_pkg::N_L2_BANKS       ),
        .AXI_USER_WIDTH      ( AXI_USER_WIDTH   ),
        .AXI_IN_ID_WIDTH     ( AXI_ID_IN_WIDTH  ),
        .N_EXT_MASTERS_TO_SOC( N_EXT_MASTERS_TO_SOC )
    ) i_soc_interconnect_wrap (
        .clk_i            ( s_soc_clk           ),
        .rst_ni           ( s_soc_rstn          ),
        .test_en_i        ( dft_test_mode_i     ),
        .tcdm_fc_data     ( s_lint_fc_data_bus  ),
        .tcdm_fc_instr    ( s_lint_fc_instr_bus ),
        .tcdm_udma_rx     ( s_lint_udma_rx_bus  ),
        .tcdm_udma_tx     ( s_lint_udma_tx_bus  ),
        .tcdm_debug       ( s_lint_debug_bus    ),
        .tcdm_hwpe        ( s_lint_hwpe_bus     ),

        // ext-to-pms direction (wrapped interface)
        .axi_master_plug  ( ext_masters_to_soc  ), // from external modules (cluster, spi, i2c_1, i2c_2, nci_cp_top)

        // pms-to-ext direction (discrete interfaces)
        .axi_slave_plug   ( s_data_out_bus      ), // to_cluster
        .axi_ext_mst      ( axi_ext_mst         ), // to nci_cp_top
        .apb_peripheral_bus    ( s_apb_periph_bus        ), // to apb_periph

        .l2_interleaved_slaves ( s_mem_l2_bus            ), // to interleaved L2
        .l2_private_slaves     ( s_mem_l2_pri_bus        ), // to private L2
        .boot_rom_slave        ( s_mem_rom_bus           )  // to bootrom
    );

    // Debug Subsystem
    dmi_jtag #(
        .IdcodeValue          ( `DMI_JTAG_IDCODE    )
    ) i_dmi_jtag (
        .clk_i                ( s_soc_clk           ),
        .rst_ni               ( s_soc_rstn          ),
        .testmode_i           ( 1'b0                ),
        .dmi_req_o            ( jtag_dmi_req        ),
        .dmi_req_valid_o      ( jtag_req_valid      ),
        .dmi_req_ready_i      ( debug_req_ready     ),
        .dmi_resp_i           ( debug_resp          ),
        .dmi_resp_ready_o     ( jtag_resp_ready     ),
        .dmi_resp_valid_i     ( jtag_resp_valid     ),
        .dmi_rst_no           (                     ), // not connected
        .tck_i                ( jtag_tck_i          ),
        .tms_i                ( jtag_tms_i          ),
        .trst_ni              ( jtag_trst_ni        ),
        .td_i                 ( jtag_tdi_i          ),
        .td_o                 ( int_td              ),
        .tdo_oe_o             (                     )
    );

    // set hartinfo
    always_comb begin: set_hartinfo
        for (int hartid = 0; hartid < NrHarts; hartid = hartid + 1) begin
            hartinfo[hartid] = RI5CY_HARTINFO;
        end
    end

    // redirect debug request from dm to correct cluster core
    for (genvar dbg_var = 0; dbg_var < NB_CORES; dbg_var = dbg_var + 1) begin : gen_debug_valid
        assign cluster_dbg_irq_valid_o[dbg_var] = dm_debug_req[cluster_core_id[dbg_var]];
    end

    dm_top #(
       .NrHarts           ( NrHarts                   ),
       .BusWidth          ( 32                        ),
       .SelectableHarts   ( SELECTABLE_HARTS          )
    ) i_dm_top (

       .clk_i             ( s_soc_clk                 ),
       .rst_ni            ( s_soc_rstn                ),
       .testmode_i        ( 1'b0                      ),
       .ndmreset_o        (                           ),
       .dmactive_o        (                           ), // active debug session
       .debug_req_o       ( dm_debug_req              ),
       .unavailable_i     ( ~SELECTABLE_HARTS         ),
       .hartinfo_i        ( hartinfo                  ),

       .slave_req_i       ( slave_req                 ),
       .slave_we_i        ( slave_we                  ),
       .slave_addr_i      ( slave_addr                ),
       .slave_be_i        ( slave_be                  ),
       .slave_wdata_i     ( slave_wdata               ),
       .slave_rdata_o     ( slave_rdata               ),

       .master_req_o      ( s_lint_riscv_jtag_bus.req      ),
       .master_add_o      ( s_lint_riscv_jtag_bus.add      ),
       .master_we_o       ( lint_riscv_jtag_bus_master_we  ),
       .master_wdata_o    ( s_lint_riscv_jtag_bus.wdata    ),
       .master_be_o       ( s_lint_riscv_jtag_bus.be       ),
       .master_gnt_i      ( s_lint_riscv_jtag_bus.gnt      ),
       .master_r_valid_i  ( s_lint_riscv_jtag_bus.r_valid  ),
       .master_r_rdata_i  ( s_lint_riscv_jtag_bus.r_rdata  ),

       .dmi_rst_ni        ( s_soc_rstn                ),
       .dmi_req_valid_i   ( jtag_req_valid            ),
       .dmi_req_ready_o   ( debug_req_ready           ),
       .dmi_req_i         ( jtag_dmi_req              ),
       .dmi_resp_valid_o  ( jtag_resp_valid           ),
       .dmi_resp_ready_i  ( jtag_resp_ready           ),
       .dmi_resp_o        ( debug_resp                )
    );
    assign s_lint_riscv_jtag_bus.wen = ~lint_riscv_jtag_bus_master_we;

    jtag_tap_top jtag_tap_top_i
    (
        .tck_i                    ( jtag_tck_i         ),
        .trst_ni                  ( jtag_trst_ni       ),
        .tms_i                    ( jtag_tms_i         ),
        .td_i                     ( int_td             ),
        .td_o                     ( jtag_tdo_o         ),

        .test_clk_i               ( 1'b0               ),
        .test_rstn_i              ( s_soc_rstn         ),

        .jtag_shift_dr_o          ( s_jtag_shift_dr    ),
        .jtag_update_dr_o         ( s_jtag_update_dr   ),
        .jtag_capture_dr_o        ( s_jtag_capture_dr  ),

        .axireg_sel_o             ( s_jtag_axireg_sel  ),
        .dbg_axi_scan_in_o        ( s_jtag_axireg_tdi  ),
        .dbg_axi_scan_out_i       ( s_jtag_axireg_tdo  ),
        .soc_jtag_reg_i           ( soc_jtag_reg_soc   ),
        .soc_jtag_reg_o           ( soc_jtag_reg_tap   ),
        .sel_clk_o                ( s_sel_clk          )
    );

    lint_jtag_wrap i_lint_jtag (
        .tck_i                    ( jtag_tck_i           ),
        .tdi_i                    ( s_jtag_axireg_tdi    ),
        .trstn_i                  ( jtag_trst_ni         ),
        .tdo_o                    ( s_jtag_axireg_tdo    ),
        .shift_dr_i               ( s_jtag_shift_dr      ),
        .pause_dr_i               ( 1'b0                 ),
        .update_dr_i              ( s_jtag_update_dr     ),
        .capture_dr_i             ( s_jtag_capture_dr    ),
        .lint_select_i            ( s_jtag_axireg_sel    ),
        .clk_i                    ( s_soc_clk            ),
        .rst_ni                   ( s_soc_rstn           ),
        .jtag_lint_master         ( s_lint_pulp_jtag_bus )
    );

    tcdm_arbiter_2x1 jtag_lint_arbiter_i
     (
        .clk_i(s_soc_clk),
        .rst_ni(s_soc_rstn),
        .tcdm_bus_1_i(s_lint_riscv_jtag_bus),
        .tcdm_bus_0_i(s_lint_pulp_jtag_bus),
        .tcdm_bus_o(s_lint_debug_bus)
    );

    apb2per #(
        .PER_ADDR_WIDTH ( 32  ),
        .APB_ADDR_WIDTH ( 32  )
    ) apb2per_newdebug_i (
        .clk_i                ( s_soc_clk               ),
        .rst_ni               ( s_soc_rstn              ),

        .PADDR                ( s_apb_debug_bus.paddr   ),
        .PWDATA               ( s_apb_debug_bus.pwdata  ),
        .PWRITE               ( s_apb_debug_bus.pwrite  ),
        .PSEL                 ( s_apb_debug_bus.psel    ),
        .PENABLE              ( s_apb_debug_bus.penable ),
        .PRDATA               ( s_apb_debug_bus.prdata  ),
        .PREADY               ( s_apb_debug_bus.pready  ),
        .PSLVERR              ( s_apb_debug_bus.pslverr ),

        .per_master_req_o     ( slave_req               ),
        .per_master_add_o     ( slave_addr              ),
        .per_master_we_o      ( slave_we                ),
        .per_master_wdata_o   ( slave_wdata             ),
        .per_master_be_o      ( slave_be                ),
        .per_master_gnt_i     ( slave_grant             ),
        .per_master_r_valid_i ( slave_valid             ),
        .per_master_r_opc_i   ( '0                      ),
        .per_master_r_rdata_i ( slave_rdata             )
     );

     assign slave_grant = slave_req;
     always_ff @(posedge s_soc_clk or negedge s_soc_rstn) begin : apb2per_valid
         if(~s_soc_rstn) begin
             slave_valid <= 0;
         end else begin
             slave_valid <= slave_grant;
         end
     end

endmodule

// Local Variables:
// verilog-indent-level: 4
// verilog-indent-level-module: 4
// verilog-indent-level-declaration: 4
// verilog-indent-level-behavioral: 4
// verilog-case-indent: 4
// verilog-cexp-indent: 4
// End:
