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

module soc_peripherals #(
    parameter MEM_ADDR_WIDTH = 13,
    parameter APB_ADDR_WIDTH = 32,
    parameter APB_DATA_WIDTH = 32,
    parameter NB_CORES       = 4,
    parameter NB_CLUSTERS    = 0,
    parameter EVNT_WIDTH     = 8
) (
    input  logic                       clk_i,
    input  logic                       periph_clk_i,
    input  logic                       rst_ni,
    //check the reset
    input  logic                       ref_clk_i,
    input  logic                       slow_clk_i,

    input  logic                       sel_fll_clk_i,
    input  logic                       dft_test_mode_i,
    input  logic                       dft_cg_enable_i,
    output logic [31:0]                fc_bootaddr_o,
    output logic                       fc_fetchen_o,
    input  logic [7:0]                 soc_jtag_reg_i,
    output logic [7:0]                 soc_jtag_reg_o,
    // SLAVE PORTS
    // APB SLAVE PORT
    APB_BUS.Slave                      apb_slave,
    APB_BUS.Master                     apb_eu_master,
    APB_BUS.Master                     apb_debug_master,
    APB_BUS.Master                     apb_hwpe_master,

    // FABRIC CONTROLLER MASTER REFILL PORT
    XBAR_TCDM_BUS.Master               l2_rx_master,
    XBAR_TCDM_BUS.Master               l2_tx_master,
    // MASTER PORT TO SOC FLL
    FLL_BUS.Master                     soc_fll_master,
    // MASTER PORT TO PER FLL
    FLL_BUS.Master                     per_fll_master,
    // MASTER PORT TO CLUSTER FLL
    FLL_BUS.Master                     cluster_fll_master,
    input  logic                       dma_pe_evt_i,
    input  logic                       dma_pe_irq_i,
    input  logic                       pf_evt_i,
    input  logic [1:0]                 fc_hwpe_events_i,
    output logic [31:0]                fc_events_o,
    input  logic [31:0]                gpio_in,
    output logic [31:0]                gpio_out,
    output logic [31:0]                gpio_dir,
    output logic [31:0]        [5:0]   gpio_padcfg,
    output logic [63:0]        [1:0]   pad_mux_o,
    output logic [63:0]        [5:0]   pad_cfg_o,
    output logic [3:0]                 timer_ch0_o,
    output logic [3:0]                 timer_ch1_o,
    output logic [3:0]                 timer_ch2_o,
    output logic [3:0]                 timer_ch3_o,
    input  logic                       cam_clk_i,
    input  logic [7:0]                 cam_data_i,
    input  logic                       cam_hsync_i,
    input  logic                       cam_vsync_i,
    output logic                       uart_tx,
    input  logic                       uart_rx,
    input  logic                       i2c0_scl_i,
    output logic                       i2c0_scl_o,
    output logic                       i2c0_scl_oe_o,
    input  logic                       i2c0_sda_i,
    output logic                       i2c0_sda_o,
    output logic                       i2c0_sda_oe_o,
    input  logic                       i2c1_scl_i,
    output logic                       i2c1_scl_o,
    output logic                       i2c1_scl_oe_o,
    input  logic                       i2c1_sda_i,
    output logic                       i2c1_sda_o,
    output logic                       i2c1_sda_oe_o,
    input  logic                       i2s_sck_i,
    input  logic                       i2s_ws_i,
    input  logic                       i2s_sd0_i,
    input  logic                       i2s_sd1_i,
    output logic                       i2s_sck0_o,
    output logic                       i2s_ws0_o,
    output logic [1:0]                 i2s_mode0_o,
    output logic                       i2s_sck1_o,
    output logic                       i2s_ws1_o,
    output logic [1:0]                 i2s_mode1_o,
    output logic                       spi_master0_clk,
    output logic                       spi_master0_csn0,
    output logic                       spi_master0_csn1,
    output logic                       spi_master0_csn2,
    output logic                       spi_master0_csn3,
    output logic [1:0]                 spi_master0_mode,
    output logic                       spi_master0_sdo0,
    output logic                       spi_master0_sdo1,
    output logic                       spi_master0_sdo2,
    output logic                       spi_master0_sdo3,
    input  logic                       spi_master0_sdi0,
    input  logic                       spi_master0_sdi1,
    input  logic                       spi_master0_sdi2,
    input  logic                       spi_master0_sdi3,
    output logic                       sdclk_o,           
    output logic                       sdcmd_o,
    input  logic                       sdcmd_i,
    output logic                       sdcmd_oen_o,
    output logic                 [3:0] sddata_o,
    input  logic                 [3:0] sddata_i,
    output logic                 [3:0] sddata_oen_o,

    output logic [EVNT_WIDTH-1:0]      cl_event_data_o,
    output logic                       cl_event_valid_o,
    input  logic                       cl_event_ready_i,
    output logic [EVNT_WIDTH-1:0]      fc_event_data_o,
    output logic                       fc_event_valid_o,
    input  logic                       fc_event_ready_i,

    output logic                       cluster_pow_o,
    output logic                       cluster_byp_o, // bypass cluster
    output logic                [63:0] cluster_boot_addr_o,
    output logic                       cluster_fetch_enable_o,
    output logic                       cluster_rstn_o,
    output logic                       cluster_irq_o
);


    APB_BUS s_fll_bus ();

    APB_BUS s_gpio_bus ();
    APB_BUS s_udma_bus ();
    APB_BUS s_soc_ctrl_bus ();
    APB_BUS s_adv_timer_bus ();
    APB_BUS s_soc_evnt_gen_bus ();
    APB_BUS s_stdout_bus ();
    APB_BUS s_apb_timer_bus ();

    localparam UDMA_EVENTS = 29;
    localparam SOC_EVENTS  = 3 ;

    logic [31:0] s_gpio_sync;
    logic       s_sel_hyper_axi;

    logic       s_gpio_event      ;
    logic [1:0] s_spim_event      ;
    logic       s_uart_event      ;
    logic       s_i2c_event       ;
    logic       s_i2s_event       ;
    logic       s_i2s_cam_event   ;

    logic [3:0] s_adv_timer_events;
    logic [1:0] s_fc_hp_events;
    logic       s_fc_err_events;
    logic       s_ref_rise_event;
    logic       s_ref_fall_event;
    logic       s_timer_hi_event;
    logic       s_timer_lo_event;

    logic       s_pr_event_valid;
    logic [7:0] s_pr_event_data ;
    logic       s_pr_event_ready;

    logic [UDMA_EVENTS-1:0] s_udma_events;
    logic [ SOC_EVENTS-1:0] s_soc_events;
    logic [           47:0] s_events;

    logic s_timer_in_lo_event;
    logic s_timer_in_hi_event;

    assign s_events[0]  = s_udma_events[5];      //spim0 rx      UDMA EVENT5
    assign s_events[1]  = s_udma_events[4];      //spim0 tx      UDMA EVENT4
    assign s_events[2]  = s_udma_events[8];      //spim1 rx      UDMA EVENT8
    assign s_events[3]  = s_udma_events[7];      //spim1 tx      UDMA EVENT7
    assign s_events[4]  = s_udma_events[11];     //hyper rx      UDMA EVENT11
    assign s_events[5]  = s_udma_events[10];     //hyper tx      UDMA EVENT10
    assign s_events[6]  = s_udma_events[14];     //uart rx       UDMA EVENT14
    assign s_events[7]  = s_udma_events[13];     //uart tx       UDMA EVENT13
    assign s_events[8]  = s_udma_events[17];     //i2c0 rx       UDMA EVENT17
    assign s_events[9]  = s_udma_events[16];     //i2c0 tx       UDMA EVENT16
    assign s_events[10] = s_udma_events[20];     //i2c1 rx       UDMA EVENT20
    assign s_events[11] = s_udma_events[19];     //i2c1 tx       UDMA EVENT19
    assign s_events[12] = s_udma_events[24];     //i2s0 channels UDMA EVENT24
    assign s_events[13] = s_udma_events[25];     //i2s0 channels UDMA EVENT25
    assign s_events[14] = s_udma_events[27];     //camera IF     UDMA EVENT27
    assign s_events[15] = 1'b0;
    assign s_events[16] = s_udma_events[1];      //TGEN events
    assign s_events[17] = s_udma_events[0];      //TGEN events
    assign s_events[18] = s_udma_events[3];      //TGEN events
    assign s_events[19] = s_udma_events[2];      //TGEN events
    assign s_events[20] = s_udma_events[23];     //TGEN events
    assign s_events[21] = s_udma_events[22];     //TGEN events
    assign s_events[22] = s_udma_events[6];      //spim0 end of transfer UDMA EVENT6
    assign s_events[23] = s_udma_events[9];      //spim1 end of transfer UDMA EVENT9
    assign s_events[24] = s_udma_events[12];     //spim2 end of transfer UDMA EVENT12
    assign s_events[25] = s_udma_events[15];     //uart event            UDMA EVENT15
    assign s_events[26] = s_udma_events[18];     //i2c0 event            UDMA EVENT18
    assign s_events[27] = s_udma_events[21];     //i2c1 event            UDMA EVENT21
    assign s_events[28] = s_udma_events[26];     //i2s event             UDMA EVENT26
    assign s_events[29] = s_udma_events[28];     //camera event          UDMA EVENT28
    assign s_events[30] = 1'b0;
    assign s_events[31] = 1'b0;
    assign s_events[32] = 1'b0;
    assign s_events[33] = 1'b0;
    assign s_events[34] = 1'b0;
    assign s_events[35] = 1'b0;
    assign s_events[36] = 1'b0;
    assign s_events[37] = 1'b0;
    assign s_events[38] = s_adv_timer_events[0];
    assign s_events[39] = s_adv_timer_events[1];
    assign s_events[40] = s_adv_timer_events[2];
    assign s_events[41] = s_adv_timer_events[3];
    assign s_events[42] = s_gpio_event;
    assign s_events[43] = 1'b0;
    assign s_events[44] = 1'b0;
    assign s_events[45] = 1'b0;
    assign s_events[46] = fc_hwpe_events_i[0];
    assign s_events[47] = fc_hwpe_events_i[1];


    assign fc_events_o[7:0] = 8'h0; //RESERVED for sw events
    assign fc_events_o[8]   = dma_pe_evt_i;
    assign fc_events_o[9]   = dma_pe_irq_i;
    assign fc_events_o[10]  = s_timer_lo_event;
    assign fc_events_o[11]  = s_timer_hi_event;
    assign fc_events_o[12]  = pf_evt_i;
    assign fc_events_o[13]  = 1'b0;
    assign fc_events_o[14]  = s_ref_rise_event | s_ref_fall_event;
    assign fc_events_o[15]  = s_gpio_event;
    assign fc_events_o[16]  = 1'b0;
    assign fc_events_o[17]  = s_adv_timer_events[0];
    assign fc_events_o[18]  = s_adv_timer_events[1];
    assign fc_events_o[19]  = s_adv_timer_events[2];
    assign fc_events_o[20]  = s_adv_timer_events[3];
    assign fc_events_o[21]  = 1'b0;
    assign fc_events_o[22]  = 1'b0;
    assign fc_events_o[23]  = 1'b0;
    assign fc_events_o[24]  = 1'b0;
    assign fc_events_o[25]  = 1'b0;
    assign fc_events_o[26]  = 1'b0; //RESERVED for soc event FIFO
    assign fc_events_o[27]  = 1'b0;
    assign fc_events_o[28]  = 1'b0;
    assign fc_events_o[29]  = s_fc_err_events;
    assign fc_events_o[30]  = s_fc_hp_events[0];
    assign fc_events_o[31]  = s_fc_hp_events[1];

    pulp_sync_wedge i_ref_clk_sync (
        .clk_i    ( clk_i            ),
        .rstn_i   ( rst_ni           ),
        .en_i     ( 1'b1             ),
        .serial_i ( slow_clk_i       ),
        .r_edge_o ( s_ref_rise_event ),
        .f_edge_o ( s_ref_fall_event ),
        .serial_o (                  )
    );


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // ██████╗ ███████╗██████╗ ██╗██████╗ ██╗  ██╗    ██████╗ ██╗   ██╗███████╗    ██╗    ██╗██████╗  █████╗ ██████╗  //
    // ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗██║  ██║    ██╔══██╗██║   ██║██╔════╝    ██║    ██║██╔══██╗██╔══██╗██╔══██╗ //
    // ██████╔╝█████╗  ██████╔╝██║██████╔╝███████║    ██████╔╝██║   ██║███████╗    ██║ █╗ ██║██████╔╝███████║██████╔╝ //
    // ██╔═══╝ ██╔══╝  ██╔══██╗██║██╔═══╝ ██╔══██║    ██╔══██╗██║   ██║╚════██║    ██║███╗██║██╔══██╗██╔══██║██╔═══╝  //
    // ██║     ███████╗██║  ██║██║██║     ██║  ██║    ██████╔╝╚██████╔╝███████║    ╚███╔███╔╝██║  ██║██║  ██║██║      //
    // ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝  ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝      //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    periph_bus_wrap #(
        .APB_ADDR_WIDTH ( 32 ),
        .APB_DATA_WIDTH ( 32 )
    ) periph_bus_i (
        .clk_i               ( clk_i              ),
        .rst_ni              ( rst_ni             ),

        .apb_slave           ( apb_slave          ),

        .fll_master          ( s_fll_bus          ),
        .gpio_master         ( s_gpio_bus         ),
        .udma_master         ( s_udma_bus         ),
        .soc_ctrl_master     ( s_soc_ctrl_bus     ),
        .adv_timer_master    ( s_adv_timer_bus    ),
        .soc_evnt_gen_master ( s_soc_evnt_gen_bus ),
        .eu_master           ( apb_eu_master      ),
        .mmap_debug_master   ( apb_debug_master   ),
        .hwpe_master         ( apb_hwpe_master    ),
        .timer_master        ( s_apb_timer_bus    ),
        .stdout_master       ( s_stdout_bus       )
    );

    `ifdef SYNTHESIS
        assign s_stdout_bus.pready  = 'h0;
        assign s_stdout_bus.pslverr = 'h0;
        assign s_stdout_bus.prdata  = 'h0;
    `endif


    /////////////////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗     ███████╗██╗     ██╗         ██╗███████╗ //
    // ██╔══██╗██╔══██╗██╔══██╗    ██╔════╝██║     ██║         ██║██╔════╝ //
    // ███████║██████╔╝██████╔╝    █████╗  ██║     ██║         ██║█████╗   //
    // ██╔══██║██╔═══╝ ██╔══██╗    ██╔══╝  ██║     ██║         ██║██╔══╝   //
    // ██║  ██║██║     ██████╔╝    ██║     ███████╗███████╗    ██║██║      //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝     ╚═╝     ╚══════╝╚══════╝    ╚═╝╚═╝      //
    /////////////////////////////////////////////////////////////////////////
    apb_fll_if #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) apb_fll_if_i (
        .HCLK        ( clk_i                   ),
        .HRESETn     ( rst_ni                  ),

        .PADDR       ( s_fll_bus.paddr         ),
        .PWDATA      ( s_fll_bus.pwdata        ),
        .PWRITE      ( s_fll_bus.pwrite        ),
        .PSEL        ( s_fll_bus.psel          ),
        .PENABLE     ( s_fll_bus.penable       ),
        .PRDATA      ( s_fll_bus.prdata        ),
        .PREADY      ( s_fll_bus.pready        ),
        .PSLVERR     ( s_fll_bus.pslverr       ),

        .fll1_req    ( soc_fll_master.req      ),
        .fll1_wrn    ( soc_fll_master.wrn      ),
        .fll1_add    ( soc_fll_master.add[1:0] ),
        .fll1_data   ( soc_fll_master.data     ),
        .fll1_ack    ( soc_fll_master.ack      ),
        .fll1_r_data ( soc_fll_master.r_data   ),
        .fll1_lock   ( soc_fll_master.lock     ),

        .fll2_req    ( per_fll_master.req      ),
        .fll2_wrn    ( per_fll_master.wrn      ),
        .fll2_add    ( per_fll_master.add[1:0] ),
        .fll2_data   ( per_fll_master.data     ),
        .fll2_ack    ( per_fll_master.ack      ),
        .fll2_r_data ( per_fll_master.r_data   ),
        .fll2_lock   ( per_fll_master.lock     ),

        .fll3_req    ( cluster_fll_master.req      ),
        .fll3_wrn    ( cluster_fll_master.wrn      ),
        .fll3_add    ( cluster_fll_master.add[1:0] ),
        .fll3_data   ( cluster_fll_master.data     ),
        .fll3_ack    ( cluster_fll_master.ack      ),
        .fll3_r_data ( cluster_fll_master.r_data   ),
        .fll3_lock   ( cluster_fll_master.lock     )
    );

    ///////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗      ██████╗ ██████╗ ██╗ ██████╗  //
    // ██╔══██╗██╔══██╗██╔══██╗    ██╔════╝ ██╔══██╗██║██╔═══██╗ //
    // ███████║██████╔╝██████╔╝    ██║  ███╗██████╔╝██║██║   ██║ //
    // ██╔══██║██╔═══╝ ██╔══██╗    ██║   ██║██╔═══╝ ██║██║   ██║ //
    // ██║  ██║██║     ██████╔╝    ╚██████╔╝██║     ██║╚██████╔╝ //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝      ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  //
    ///////////////////////////////////////////////////////////////
    apb_gpio #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) apb_gpio_i (
        .HCLK            ( clk_i              ),
        .HRESETn         ( rst_ni             ),

        .dft_cg_enable_i ( dft_cg_enable_i    ),

        .PADDR           ( s_gpio_bus.paddr   ),
        .PWDATA          ( s_gpio_bus.pwdata  ),
        .PWRITE          ( s_gpio_bus.pwrite  ),
        .PSEL            ( s_gpio_bus.psel    ),
        .PENABLE         ( s_gpio_bus.penable ),
        .PRDATA          ( s_gpio_bus.prdata  ),
        .PREADY          ( s_gpio_bus.pready  ),
        .PSLVERR         ( s_gpio_bus.pslverr ),

        .gpio_in_sync    ( s_gpio_sync        ),

        .gpio_in         ( gpio_in            ),
        .gpio_out        ( gpio_out           ),
        .gpio_dir        ( gpio_dir           ),
        .gpio_padcfg     ( gpio_padcfg        ),
        .interrupt       ( s_gpio_event       )
    );

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // ██╗   ██╗██████╗ ███╗   ███╗ █████╗     ███████╗██╗   ██╗██████╗ ███████╗██╗   ██╗███████╗ //
    // ██║   ██║██╔══██╗████╗ ████║██╔══██╗    ██╔════╝██║   ██║██╔══██╗██╔════╝╚██╗ ██╔╝██╔════╝ //
    // ██║   ██║██║  ██║██╔████╔██║███████║    ███████╗██║   ██║██████╔╝███████╗ ╚████╔╝ ███████╗ //
    // ██║   ██║██║  ██║██║╚██╔╝██║██╔══██║    ╚════██║██║   ██║██╔══██╗╚════██║  ╚██╔╝  ╚════██║ //
    // ╚██████╔╝██████╔╝██║ ╚═╝ ██║██║  ██║    ███████║╚██████╔╝██████╔╝███████║   ██║   ███████║ //
    //  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝ //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    udma_subsystem #(
        .UDMA_EVENTS    ( UDMA_EVENTS    ),
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .L2_ADDR_WIDTH  ( MEM_ADDR_WIDTH )
    ) i_udma (
        .L2_ro_req_o      ( l2_tx_master.req     ),
        .L2_ro_gnt_i      ( l2_tx_master.gnt     ),
        .L2_ro_wen_o      ( l2_tx_master.wen     ),
        .L2_ro_addr_o     ( l2_tx_master.add     ),
        .L2_ro_wdata_o    ( l2_tx_master.wdata   ),
        .L2_ro_be_o       ( l2_tx_master.be      ),
        .L2_ro_rdata_i    ( l2_tx_master.r_rdata ),
        .L2_ro_rvalid_i   ( l2_tx_master.r_valid ),

        .L2_wo_req_o      ( l2_rx_master.req     ),
        .L2_wo_gnt_i      ( l2_rx_master.gnt     ),
        .L2_wo_wen_o      ( l2_rx_master.wen     ),
        .L2_wo_addr_o     ( l2_rx_master.add     ),
        .L2_wo_wdata_o    ( l2_rx_master.wdata   ),
        .L2_wo_be_o       ( l2_rx_master.be      ),
        .L2_wo_rdata_i    ( l2_rx_master.r_rdata ),
        .L2_wo_rvalid_i   ( l2_rx_master.r_valid ),

        .dft_test_mode_i  ( dft_test_mode_i      ),
        .dft_cg_enable_i  ( 1'b0                 ),

        .sys_clk_i        ( clk_i                ),
        .periph_clk_i     ( periph_clk_i         ),
        .HRESETn          ( rst_ni               ),

        .PADDR            ( s_udma_bus.paddr     ),
        .PWDATA           ( s_udma_bus.pwdata    ),
        .PWRITE           ( s_udma_bus.pwrite    ),
        .PSEL             ( s_udma_bus.psel      ),
        .PENABLE          ( s_udma_bus.penable   ),
        .PRDATA           ( s_udma_bus.prdata    ),
        .PREADY           ( s_udma_bus.pready    ),
        .PSLVERR          ( s_udma_bus.pslverr   ),

        .events_o         ( s_udma_events        ),

        .event_valid_i    ( s_pr_event_valid     ),
        .event_data_i     ( s_pr_event_data      ),
        .event_ready_o    ( s_pr_event_ready     ),

        .spi0_clk         ( spi_master0_clk      ),
        .spi0_csn0        ( spi_master0_csn0     ),
        .spi0_csn1        ( spi_master0_csn1     ),
        .spi0_csn2        ( spi_master0_csn2     ),
        .spi0_csn3        ( spi_master0_csn3     ),
        .spi0_mode        ( spi_master0_mode     ),
        .spi0_sdo0        ( spi_master0_sdo0     ),
        .spi0_sdo1        ( spi_master0_sdo1     ),
        .spi0_sdo2        ( spi_master0_sdo2     ),
        .spi0_sdo3        ( spi_master0_sdo3     ),
        .spi0_sdi0        ( spi_master0_sdi0     ),
        .spi0_sdi1        ( spi_master0_sdi1     ),
        .spi0_sdi2        ( spi_master0_sdi2     ),
        .spi0_sdi3        ( spi_master0_sdi3     ),

        .sdclk_o          ( sdclk_o              ),           
        .sdcmd_o          ( sdcmd_o              ),
        .sdcmd_i          ( sdcmd_i              ),
        .sdcmd_oen_o      ( sdcmd_oen_o          ),
        .sddata_o         ( sddata_o             ),
        .sddata_i         ( sddata_i             ),
        .sddata_oen_o     ( sddata_oen_o         ),

        .cam_clk_i        ( cam_clk_i            ),
        .cam_data_i       ( cam_data_i           ),
        .cam_hsync_i      ( cam_hsync_i          ),
        .cam_vsync_i      ( cam_vsync_i          ),

        .i2s_sd0_i        ( i2s_sd0_i            ),
        .i2s_sd1_i        ( i2s_sd1_i            ),
        .i2s_ws_i         ( i2s_ws_i             ),
        .i2s_sck_i        ( i2s_sck_i            ),
        .i2s_ws0_o        ( i2s_ws0_o            ),
        .i2s_sck0_o       ( i2s_sck0_o           ),
        .i2s_mode0_o      ( i2s_mode0_o          ),
        .i2s_ws1_o        ( i2s_ws1_o            ),
        .i2s_sck1_o       ( i2s_sck1_o           ),
        .i2s_mode1_o      ( i2s_mode1_o          ),

        .uart_rx          ( uart_rx              ),
        .uart_tx          ( uart_tx              ),

        .i2c0_scl_i       ( i2c0_scl_i           ),
        .i2c0_scl_o       ( i2c0_scl_o           ),
        .i2c0_scl_oe      ( i2c0_scl_oe_o        ),
        .i2c0_sda_i       ( i2c0_sda_i           ),
        .i2c0_sda_o       ( i2c0_sda_o           ),
        .i2c0_sda_oe      ( i2c0_sda_oe_o        ),

        .i2c1_scl_i       ( i2c1_scl_i           ),
        .i2c1_scl_o       ( i2c1_scl_o           ),
        .i2c1_scl_oe      ( i2c1_scl_oe_o        ),
        .i2c1_sda_i       ( i2c1_sda_i           ),
        .i2c1_sda_o       ( i2c1_sda_o           ),
        .i2c1_sda_oe      ( i2c1_sda_oe_o        )
    );


    ////////////////////////////////////////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗     ███████╗ ██████╗  ██████╗     ██████╗████████╗██████╗ ██╗      //
    // ██╔══██╗██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔════╝    ██╔════╝╚══██╔══╝██╔══██╗██║      //
    // ███████║██████╔╝██████╔╝    ███████╗██║   ██║██║         ██║        ██║   ██████╔╝██║      //
    // ██╔══██║██╔═══╝ ██╔══██╗    ╚════██║██║   ██║██║         ██║        ██║   ██╔══██╗██║      //
    // ██║  ██║██║     ██████╔╝    ███████║╚██████╔╝╚██████╗    ╚██████╗   ██║   ██║  ██║███████╗ //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝     ╚══════╝ ╚═════╝  ╚═════╝     ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    apb_soc_ctrl #(
        .NB_CORES       ( NB_CORES       ),
        .NB_CLUSTERS    ( NB_CLUSTERS    ),
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH )
    ) apb_soc_ctrl_i (
        .HCLK           ( clk_i                  ),
        .HRESETn        ( rst_ni                 ),

        .PADDR          ( s_soc_ctrl_bus.paddr   ),
        .PWDATA         ( s_soc_ctrl_bus.pwdata  ),
        .PWRITE         ( s_soc_ctrl_bus.pwrite  ),
        .PSEL           ( s_soc_ctrl_bus.psel    ),
        .PENABLE        ( s_soc_ctrl_bus.penable ),
        .PRDATA         ( s_soc_ctrl_bus.prdata  ),
        .PREADY         ( s_soc_ctrl_bus.pready  ),
        .PSLVERR        ( s_soc_ctrl_bus.pslverr ),

        .sel_fll_clk_i  ( sel_fll_clk_i          ),

        .fc_bootaddr_o  ( fc_bootaddr_o          ),
        .fc_fetchen_o   ( fc_fetchen_o           ),

        .soc_jtag_reg_i ( soc_jtag_reg_i         ),
        .soc_jtag_reg_o ( soc_jtag_reg_o         ),

        .pad_mux        ( pad_mux_o              ),
        .pad_cfg        ( pad_cfg_o              ),
        .cluster_pow_o  ( cluster_pow_o          ),
        .sel_hyper_axi_o ( s_sel_hyper_axi        ),

        .cluster_byp_o            ( cluster_byp_o          ),
        .cluster_boot_addr_o      ( cluster_boot_addr_o    ),
        .cluster_fetch_enable_o   ( cluster_fetch_enable_o ),
        .cluster_rstn_o           ( cluster_rstn_o         ),
        .cluster_irq_o            ( cluster_irq_o          )
    );

    apb_adv_timer #(
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .EXTSIG_NUM     ( 32             )
    ) apb_adv_timer_i (
        .HCLK            ( clk_i                   ),
        .HRESETn         ( rst_ni                  ),

        .dft_cg_enable_i ( dft_cg_enable_i         ),

        .PADDR           ( s_adv_timer_bus.paddr   ),
        .PWDATA          ( s_adv_timer_bus.pwdata  ),
        .PWRITE          ( s_adv_timer_bus.pwrite  ),
        .PSEL            ( s_adv_timer_bus.psel    ),
        .PENABLE         ( s_adv_timer_bus.penable ),
        .PRDATA          ( s_adv_timer_bus.prdata  ),
        .PREADY          ( s_adv_timer_bus.pready  ),
        .PSLVERR         ( s_adv_timer_bus.pslverr ),

        .low_speed_clk_i ( slow_clk_i              ),
        .ext_sig_i       ( s_gpio_sync             ),

        .events_o        ( s_adv_timer_events      ),

        .ch_0_o          ( timer_ch0_o             ),
        .ch_1_o          ( timer_ch1_o             ),
        .ch_2_o          ( timer_ch2_o             ),
        .ch_3_o          ( timer_ch3_o             )
    );

    /////////////////////////////////////////////////////////////////////////////////
    // ███████╗██╗   ██╗███████╗███╗   ██╗████████╗     ██████╗ ███████╗███╗   ██╗ //
    // ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝    ██╔════╝ ██╔════╝████╗  ██║ //
    // █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║       ██║  ███╗█████╗  ██╔██╗ ██║ //
    // ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║       ██║   ██║██╔══╝  ██║╚██╗██║ //
    // ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║       ╚██████╔╝███████╗██║ ╚████║ //
    // ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝        ╚═════╝ ╚══════╝╚═╝  ╚═══╝ //
    /////////////////////////////////////////////////////////////////////////////////
    soc_event_generator #(
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .APB_EVNT_NUM   ( 8              ),
        .PER_EVNT_NUM   ( 48             ),
        .EVNT_WIDTH     ( EVNT_WIDTH     )
    ) u_evnt_gen (
        .HCLK             ( clk_i                      ),
        .HRESETn          ( rst_ni                     ),

        .PADDR            ( s_soc_evnt_gen_bus.paddr   ),
        .PWDATA           ( s_soc_evnt_gen_bus.pwdata  ),
        .PWRITE           ( s_soc_evnt_gen_bus.pwrite  ),
        .PSEL             ( s_soc_evnt_gen_bus.psel    ),
        .PENABLE          ( s_soc_evnt_gen_bus.penable ),
        .PRDATA           ( s_soc_evnt_gen_bus.prdata  ),
        .PREADY           ( s_soc_evnt_gen_bus.pready  ),
        .PSLVERR          ( s_soc_evnt_gen_bus.pslverr ),

        .low_speed_clk_i  ( slow_clk_i                 ),
        .timer_event_lo_o ( s_timer_in_lo_event        ),
        .timer_event_hi_o ( s_timer_in_hi_event        ),
        .per_events_i     ( s_events                   ),
        .err_event_o      ( s_fc_err_events            ),
        .fc_events_o      ( s_fc_hp_events             ),

        .fc_event_valid_o ( fc_event_valid_o           ),
        .fc_event_data_o  ( fc_event_data_o            ),
        .fc_event_ready_i ( fc_event_ready_i           ),
        .cl_event_valid_o ( cl_event_valid_o           ),
        .cl_event_data_o  ( cl_event_data_o            ),
        .cl_event_ready_i ( cl_event_ready_i           ),
        .pr_event_valid_o ( s_pr_event_valid           ),
        .pr_event_data_o  ( s_pr_event_data            ),
        .pr_event_ready_i ( s_pr_event_ready           )
    );


    apb_timer_unit #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) i_apb_timer_unit (
        .HCLK       ( clk_i                   ),
        .HRESETn    ( rst_ni                  ),
        .PADDR      ( s_apb_timer_bus.paddr   ),
        .PWDATA     ( s_apb_timer_bus.pwdata  ),
        .PWRITE     ( s_apb_timer_bus.pwrite  ),
        .PSEL       ( s_apb_timer_bus.psel    ),
        .PENABLE    ( s_apb_timer_bus.penable ),
        .PRDATA     ( s_apb_timer_bus.prdata  ),
        .PREADY     ( s_apb_timer_bus.pready  ),
        .PSLVERR    ( s_apb_timer_bus.pslverr ),
        .ref_clk_i  ( slow_clk_i              ),
        .event_lo_i ( s_timer_in_lo_event     ),
        .event_hi_i ( s_timer_in_hi_event     ),
        .irq_lo_o   ( s_timer_lo_event        ),
        .irq_hi_o   ( s_timer_hi_event        ),
        .busy_o     (                         )
    );


endmodule
