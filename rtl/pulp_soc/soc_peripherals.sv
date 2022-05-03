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
    parameter EVNT_WIDTH     = 8,
    parameter NGPIO          = 64,
    parameter NPAD           = 64,
    parameter NBIT_PADCFG    = 4,
    parameter NBIT_PADMUX    = 2,
    parameter N_UART         = 1,
    parameter N_SPI          = 1,
    parameter N_I2C          = 2,
    parameter SIM_STDOUT     = 1
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

    input  logic                       boot_l2_i,
    input  logic [1:0]                 bootsel_i,
    // fc fetch enable can be controlled through this signal or through an APB
    // write to the fc fetch enable register
    input  logic                       fc_fetch_en_valid_i,
    input  logic                       fc_fetch_en_i,

    // SLAVE PORTS
    // APB SLAVE PORT
    APB_BUS.Slave                      apb_slave,
    APB_BUS.Master                     apb_eu_master,
    APB_BUS.Master                     apb_hwpe_master,
    APB_BUS.Master                     apb_debug_master,

    // FABRIC CONTROLLER MASTER REFILL PORT
    XBAR_TCDM_BUS.Master               l2_rx_master,
    XBAR_TCDM_BUS.Master               l2_tx_master,
    // MASTER PORT TO SOC FLL
    FLL_BUS.out                        soc_fll_master,
    // MASTER PORT TO PER FLL
    FLL_BUS.out                        per_fll_master,
    // MASTER PORT TO CLUSTER FLL
    FLL_BUS.out                        cluster_fll_master,
/*
    input  logic                       jtag_req_valid_i,
    output logic                       debug_req_ready_o,
    input  logic                       jtag_resp_ready_i,
    output logic                       jtag_resp_valid_o,
    input  dm::dmi_req_t               jtag_dmi_req_i,
    output dm::dmi_resp_t              debug_resp_o,
    output logic                       ndmreset_o,
    output logic                       dm_debug_req_o,
*/
    input  logic                       dma_pe_evt_i,
    input  logic                       dma_pe_irq_i,
    input  logic                       pf_evt_i,
    input  logic [1:0]                 fc_hwpe_events_i,
    output logic [31:0]                fc_events_o,

    input  logic [NGPIO-1:0]           gpio_in,
    output logic [NGPIO-1:0]           gpio_out,
    output logic [NGPIO-1:0]           gpio_dir,
    output logic [NGPIO-1:0][NBIT_PADCFG-1:0] gpio_padcfg,

    output logic [NPAD-1:0][NBIT_PADMUX-1:0] pad_mux_o,
    output logic [NPAD-1:0][NBIT_PADCFG-1:0] pad_cfg_o,

    output logic [3:0]                 timer_ch0_o,
    output logic [3:0]                 timer_ch1_o,
    output logic [3:0]                 timer_ch2_o,
    output logic [3:0]                 timer_ch3_o,

    //CAMERA
    input  logic                       cam_clk_i,
    input  logic [7:0]                 cam_data_i,
    input  logic                       cam_hsync_i,
    input  logic                       cam_vsync_i,

    //UART
    // output logic [N_UART-1:0]          uart_tx,
    // input  logic [N_UART-1:0]          uart_rx,
    output logic           uart_tx,
    input  logic           uart_rx,


    //I2C
    input  logic [N_I2C-1:0]           i2c_scl_i,
    output logic [N_I2C-1:0]           i2c_scl_o,
    output logic [N_I2C-1:0]           i2c_scl_oe_o,
    input  logic [N_I2C-1:0]           i2c_sda_i,
    output logic [N_I2C-1:0]           i2c_sda_o,
    output logic [N_I2C-1:0]           i2c_sda_oe_o,

    //I2S
    input  logic                       i2s_slave_sd0_i,
    input  logic                       i2s_slave_sd1_i,
    input  logic                       i2s_slave_ws_i,
    output logic                       i2s_slave_ws_o,
    output logic                       i2s_slave_ws_oe,
    input  logic                       i2s_slave_sck_i,
    output logic                       i2s_slave_sck_o,
    output logic                       i2s_slave_sck_oe,

    //SPI
    output logic [N_SPI-1:0]           spi_clk_o,
    output logic [N_SPI-1:0][3:0]      spi_csn_o,
    output logic [N_SPI-1:0][3:0]      spi_oen_o,
    output logic [N_SPI-1:0][3:0]      spi_sdo_o,
    input  logic [N_SPI-1:0][3:0]      spi_sdi_i,

    //SDIO
    output logic                       sdclk_o,
    output logic                       sdcmd_o,
    input  logic                       sdcmd_i,
    output logic                       sdcmd_oen_o,
    output logic                 [3:0] sddata_o,
    input  logic                 [3:0] sddata_i,
    output logic                 [3:0] sddata_oen_o,

    // HYPERBUS
    output logic [1:0]                 hyper_cs_no,
    output logic                       hyper_ck_o,
    output logic                       hyper_ck_no,
    output logic [1:0]                 hyper_rwds_o,
    input  logic                       hyper_rwds_i,
    output logic [1:0]                 hyper_rwds_oe_o,
    input  logic [15:0]                hyper_dq_i,
    output logic [15:0]                hyper_dq_o,
    output logic [1:0]                 hyper_dq_oe_o,
    output logic                       hyper_reset_no,


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

    localparam UDMA_EVENTS = 16*8;

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
    logic [          159:0] s_events;

    logic s_timer_in_lo_event;
    logic s_timer_in_hi_event;

    assign s_events[UDMA_EVENTS-1:0]  = s_udma_events;
    assign s_events[135]              = s_adv_timer_events[0];
    assign s_events[136]              = s_adv_timer_events[1];
    assign s_events[137]              = s_adv_timer_events[2];
    assign s_events[138]              = s_adv_timer_events[3];
    assign s_events[139]              = s_gpio_event;
    assign s_events[140]              = fc_hwpe_events_i[0];
    assign s_events[141]              = fc_hwpe_events_i[1];
    assign s_events[159:142]          = '0;

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
    assign fc_events_o[26]  = 1'b0; // RESERVED for soc event FIFO
                                    // (many events get implicitely muxed into
                                    // this interrupt. A user that gets such an
                                    // interrupt has to check the event unit's
                                    // registers to see what happened)
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

        .fll1_req_o    ( soc_fll_master.req      ),
        .fll1_wrn_o    ( soc_fll_master.wrn      ),
        .fll1_add_o    ( soc_fll_master.addr[1:0] ),
        .fll1_data_o   ( soc_fll_master.wdata     ),
        .fll1_ack_i    ( soc_fll_master.ack      ),
        .fll1_r_data_i ( soc_fll_master.rdata   ),
        .fll1_lock_i   ( soc_fll_master.lock     ),

        .fll2_req_o    ( per_fll_master.req      ),
        .fll2_wrn_o    ( per_fll_master.wrn      ),
        .fll2_add_o    ( per_fll_master.addr[1:0] ),
        .fll2_data_o   ( per_fll_master.wdata     ),
        .fll2_ack_i    ( per_fll_master.ack      ),
        .fll2_r_data_i ( per_fll_master.rdata   ),
        .fll2_lock_i   ( per_fll_master.lock     ),

        .fll3_req_o    ( cluster_fll_master.req      ),
        .fll3_wrn_o    ( cluster_fll_master.wrn      ),
        .fll3_add_o    ( cluster_fll_master.addr[1:0] ),
        .fll3_data_o   ( cluster_fll_master.wdata     ),
        .fll3_ack_i    ( cluster_fll_master.ack      ),
        .fll3_r_data_i ( cluster_fll_master.rdata   ),
        .fll3_lock_i   ( cluster_fll_master.lock     ),

        .bbgen_req_o   (),
        .bbgen_wrn_o   (),
        .bbgen_sel_o   (),
        .bbgen_data_o  (),
        .bbgen_ack_i   (),
        .bbgen_r_data_i(),
        .bbgen_lock_i  ()
    );


`ifdef SYNTHESIS
    if (SIM_STDOUT)
        $fatal(1, "SIM_STDOUT is not synthesizable. Set SIM_STDOUT=0");
`endif

 if (SIM_STDOUT) begin
     logic pready_q;

     assign s_stdout_bus.pready  = pready_q;
     assign s_stdout_bus.pslverr = 1'b0;

     tb_fs_handler #(
          .ADDR_WIDTH ( 32          ),
          .DATA_WIDTH ( 32          ),
          .NB_CORES   ( NB_CORES + 1), // cluster cores + fc core
          .OPEN_FILES ( `ifdef LOG_SIM_STDOUT 1 `else 0 `endif )
     ) i_fs_handler (
          .clk   ( clk_i                                                  ),
          .rst_n ( rst_ni                                                 ),
          .CSN   ( ~(s_stdout_bus.psel & s_stdout_bus.penable & pready_q) ),
          .WEN   ( ~s_stdout_bus.pwrite                                   ),
          .ADDR  ( s_stdout_bus.paddr                                     ),
          .WDATA ( s_stdout_bus.pwdata                                    ),
          .BE    ( 4'hf                                                   ),
          .RDATA ( s_stdout_bus.prdata                                    )
     );

     always_ff @(posedge clk_i or negedge rst_ni) begin
        if(~rst_ni) begin
           pready_q <= 0;
        end else begin
           pready_q <= (s_stdout_bus.psel & s_stdout_bus.penable);
        end
     end
 end else begin
     assign s_stdout_bus.pready  = 'h1;
     assign s_stdout_bus.pslverr = 1'b0;
     assign s_stdout_bus.prdata  = 'h0;
 end

    ///////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗      ██████╗ ██████╗ ██╗ ██████╗  //
    // ██╔══██╗██╔══██╗██╔══██╗    ██╔════╝ ██╔══██╗██║██╔═══██╗ //
    // ███████║██████╔╝██████╔╝    ██║  ███╗██████╔╝██║██║   ██║ //
    // ██╔══██║██╔═══╝ ██╔══██╗    ██║   ██║██╔═══╝ ██║██║   ██║ //
    // ██║  ██║██║     ██████╔╝    ╚██████╔╝██║     ██║╚██████╔╝ //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝      ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  //
    ///////////////////////////////////////////////////////////////

    apb_gpio #(
        .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
        .PAD_NUM        (NGPIO),
        .NBIT_PADCFG    (NBIT_PADCFG)
    ) i_apb_gpio (
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
        .APB_ADDR_WIDTH     ( APB_ADDR_WIDTH       ),
        .L2_ADDR_WIDTH      ( MEM_ADDR_WIDTH       ),
        .N_SPI (N_SPI),
        .N_UART(N_UART),
        .N_I2C (N_I2C)
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
        .sys_resetn_i     ( rst_ni               ),

        .udma_apb_paddr   ( s_udma_bus.paddr     ),
        .udma_apb_pwdata  ( s_udma_bus.pwdata    ),
        .udma_apb_pwrite  ( s_udma_bus.pwrite    ),
        .udma_apb_psel    ( s_udma_bus.psel      ),
        .udma_apb_penable ( s_udma_bus.penable   ),
        .udma_apb_prdata  ( s_udma_bus.prdata    ),
        .udma_apb_pready  ( s_udma_bus.pready    ),
        .udma_apb_pslverr ( s_udma_bus.pslverr   ),

        .events_o         ( s_udma_events        ),

        .event_valid_i    ( s_pr_event_valid     ),
        .event_data_i     ( s_pr_event_data      ),
        .event_ready_o    ( s_pr_event_ready     ),

        .spi_clk          ( spi_clk_o            ),
        .spi_csn          ( spi_csn_o            ),
        .spi_oen          ( spi_oen_o            ),
        .spi_sdo          ( spi_sdo_o            ),
        .spi_sdi          ( spi_sdi_i            ),

        .sdio_clk_o       ( sdclk_o              ),
        .sdio_cmd_o       ( sdcmd_o              ),
        .sdio_cmd_i       ( sdcmd_i              ),
        .sdio_cmd_oen_o   ( sdcmd_oen_o          ),
        .sdio_data_o      ( sddata_o             ),
        .sdio_data_i      ( sddata_i             ),
        .sdio_data_oen_o  ( sddata_oen_o         ),

        .cam_clk_i        ( cam_clk_i            ),
        .cam_data_i       ( cam_data_i           ),
        .cam_hsync_i      ( cam_hsync_i          ),
        .cam_vsync_i      ( cam_vsync_i          ),

        .i2s_slave_sd0_i  ( i2s_slave_sd0_i      ),
        .i2s_slave_sd1_i  ( i2s_slave_sd1_i      ),
        .i2s_slave_ws_i   ( i2s_slave_ws_i       ),
        .i2s_slave_ws_o   ( i2s_slave_ws_o       ),
        .i2s_slave_ws_oe  ( i2s_slave_ws_oe      ),
        .i2s_slave_sck_i  ( i2s_slave_sck_i      ),
        .i2s_slave_sck_o  ( i2s_slave_sck_o      ),
        .i2s_slave_sck_oe ( i2s_slave_sck_oe     ),

        .uart_rx_i        ( uart_rx              ),
        .uart_tx_o        ( uart_tx              ),

        .i2c_scl_i        ( i2c_scl_i            ),
        .i2c_scl_o        ( i2c_scl_o            ),
        .i2c_scl_oe       ( i2c_scl_oe_o         ),
        .i2c_sda_i        ( i2c_sda_i            ),
        .i2c_sda_o        ( i2c_sda_o            ),
        .i2c_sda_oe       ( i2c_sda_oe_o         ),


        .hyper_cs_no      ( hyper_cs_no          ),
        .hyper_ck_o       ( hyper_ck_o           ),
        .hyper_ck_no      ( hyper_ck_no          ),
        .hyper_rwds_o     ( hyper_rwds_o         ),
        .hyper_rwds_i     ( hyper_rwds_i         ),
        .hyper_rwds_oe_o  ( hyper_rwds_oe_o      ),
        .hyper_dq_i       ( hyper_dq_i           ),
        .hyper_dq_o       ( hyper_dq_o           ),
        .hyper_dq_oe_o    ( hyper_dq_oe_o        ),
        .hyper_reset_no   ( hyper_reset_no       )

    );

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗     ███████╗ ██████╗  ██████╗     ██████╗████████╗██████╗ ██╗      //
    // ██╔══██╗██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔════╝    ██╔════╝╚══██╔══╝██╔══██╗██║      //
    // ███████║██████╔╝██████╔╝    ███████╗██║   ██║██║         ██║        ██║   ██████╔╝██║      //
    // ██╔══██║██╔═══╝ ██╔══██╗    ╚════██║██║   ██║██║         ██║        ██║   ██╔══██╗██║      //
    // ██║  ██║██║     ██████╔╝    ███████║╚██████╔╝╚██████╗    ╚██████╗   ██║   ██║  ██║███████╗ //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝     ╚══════╝ ╚═════╝  ╚═════╝     ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    if (NPAD != 64)
        $error("apb_soc_ctrl doesn't support any other value than NPAD=64");

    apb_soc_ctrl #(
        .NB_CORES       ( NB_CORES       ),
        .NB_CLUSTERS    ( NB_CLUSTERS    ),
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .NBIT_PADCFG    ( NBIT_PADCFG    )
    ) i_apb_soc_ctrl (
        .HCLK                ( clk_i                  ),
        .HRESETn             ( rst_ni                 ),

        .PADDR               ( s_soc_ctrl_bus.paddr   ),
        .PWDATA              ( s_soc_ctrl_bus.pwdata  ),
        .PWRITE              ( s_soc_ctrl_bus.pwrite  ),
        .PSEL                ( s_soc_ctrl_bus.psel    ),
        .PENABLE             ( s_soc_ctrl_bus.penable ),
        .PRDATA              ( s_soc_ctrl_bus.prdata  ),
        .PREADY              ( s_soc_ctrl_bus.pready  ),
        .PSLVERR             ( s_soc_ctrl_bus.pslverr ),

        .sel_fll_clk_i       ( sel_fll_clk_i          ),
        .boot_l2_i           ( boot_l2_i              ),
        .bootsel_i           ( bootsel_i              ),
        .fc_fetch_en_valid_i ( fc_fetch_en_valid_i    ),
        .fc_fetch_en_i       ( fc_fetch_en_i          ),

        .fc_bootaddr_o       ( fc_bootaddr_o          ),
        .fc_fetchen_o        ( fc_fetchen_o           ),

        .soc_jtag_reg_i      ( soc_jtag_reg_i         ),
        .soc_jtag_reg_o      ( soc_jtag_reg_o         ),

        .pad_mux             ( pad_mux_o              ),
        .pad_cfg             ( pad_cfg_o              ),
        .cluster_pow_o       ( cluster_pow_o          ),
        .sel_hyper_axi_o     ( s_sel_hyper_axi        ),

        .cluster_byp_o            ( cluster_byp_o          ),
        .cluster_boot_addr_o      ( cluster_boot_addr_o    ),
        .cluster_fetch_enable_o   ( cluster_fetch_enable_o ),
        .cluster_rstn_o           ( cluster_rstn_o         ),
        .cluster_irq_o            ( cluster_irq_o          )
    );

    apb_adv_timer #(
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .EXTSIG_NUM     ( 32             )
    ) i_apb_adv_timer (
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
        .PER_EVNT_NUM   ( 160            ),
        .EVNT_WIDTH     ( EVNT_WIDTH     ),
        .FC_EVENT_POS   ( 7              )
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
