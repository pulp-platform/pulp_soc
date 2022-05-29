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
`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"


module soc_peripherals /*import rv_plic_reg_pkg::*;*/ #(
    parameter CORE_TYPE           = 0,
    parameter MEM_ADDR_WIDTH      = 13,
    parameter APB_ADDR_WIDTH      = 32,
    parameter APB_DATA_WIDTH      = 32,
    parameter NB_CORES            = 4,
    parameter NB_CLUSTERS         = 0,
    parameter EVNT_WIDTH          = 8,
    parameter NGPIO               = 32,
    parameter NBIT_PADCFG         = 4,
    parameter N_UART              = 1,
    parameter N_SPI               = 1,
    parameter N_I2C               = 2,
    parameter N_I2C_SLV           = 2,
    parameter SIM_STDOUT          = 1,
    parameter AXI_ADDR_WIDTH      = 0,
    parameter AXI_DATA_OUT_WIDTH  = 0,
    parameter AXI_DATA_IN_WIDTH   = 0,
    parameter AXI_64_ID_IN_WIDTH  = 0,
    parameter AXI_32_ID_OUT_WIDTH = 0,
    parameter AXI_32_USER_WIDTH   = 0
) (
    input logic                               clk_i,
    input logic                               periph_clk_i,
    input logic                               rst_ni,
    //check the reset
    input logic                               slow_clk_i,

    input logic                               sel_clk_i,
    input logic                               dft_test_mode_i,
    input logic                               dft_cg_enable_i,
    output logic [31:0]                       fc_bootaddr_o,
    output logic                              fc_fetchen_o,
    input logic [7:0]                         soc_jtag_reg_i,
    output logic [7:0]                        soc_jtag_reg_o,

    input logic                               bootsel_valid_i,
    input logic [1:0]                         bootsel_i,
    // fc fetch enable can be controlled through this signal or through an APB
    // write to the fc fetch enable register
    input logic                               fc_fetch_en_valid_i,
    input logic                               fc_fetch_en_i,

    // SLAVE PORTS
    // APB SLAVE PORT
    APB_BUS.Slave                             apb_slave,
    APB_BUS.Master                            apb_eu_master,
    APB_BUS.Master                            apb_clic_master,
    APB_BUS.Master                            apb_hwpe_master,
    APB_BUS.Master                            apb_debug_master,
    // MASTER PORT TO SOC CLK CTRL
    APB_BUS.Master                            apb_clk_ctrl_master,
    // MASTER PORT TO SERIAL LINK
    APB_BUS.Master                            apb_serial_link_master,
    // MASTER PORT TO PADFRAME
    APB_BUS.Master                            apb_pad_cfg_master,
    // FABRIC CONTROLLER MASTER REFILL PORT
    XBAR_TCDM_BUS.Master                      l2_rx_master,
    XBAR_TCDM_BUS.Master                      l2_tx_master,
    // MASTER PORT FOR SPI SLAVE
    AXI_BUS.Master                            axi_mst_spi_slv,

    input logic                               dma_pe_evt_i,
    input logic                               dma_pe_irq_i,
    input logic                               pf_evt_i,
    input logic [1:0]                         fc_hwpe_events_i,
    output logic [31:0]                       fc_events_o,

    input logic [NGPIO-1:0]                   gpio_in,
    output logic [NGPIO-1:0]                  gpio_out,
    output logic [NGPIO-1:0]                  gpio_dir,
    output logic [NGPIO-1:0][NBIT_PADCFG-1:0] gpio_padcfg,

    output logic [3:0]                        timer_ch0_o,
    output logic [3:0]                        timer_ch1_o,
    output logic [3:0]                        timer_ch2_o,
    output logic [3:0]                        timer_ch3_o,

    //UART
    output logic [N_UART-1:0]                 uart_tx,
    input  logic [N_UART-1:0]                 uart_rx,


    //I2C
    input logic [N_I2C-1:0]                   i2c_scl_i,
    output logic [N_I2C-1:0]                  i2c_scl_o,
    output logic [N_I2C-1:0]                  i2c_scl_oe_o,
    input logic [N_I2C-1:0]                   i2c_sda_i,
    output logic [N_I2C-1:0]                  i2c_sda_o,
    output logic [N_I2C-1:0]                  i2c_sda_oe_o,

    //I2C slave
    input logic  [N_I2C_SLV-1:0]              i2c_slv_scl_i,
    output logic [N_I2C_SLV-1:0]              i2c_slv_scl_o,
    output logic [N_I2C_SLV-1:0]              i2c_slv_scl_oe_o,
    input logic  [N_I2C_SLV-1:0]              i2c_slv_sda_i,
    output logic [N_I2C_SLV-1:0]              i2c_slv_sda_o,
    output logic [N_I2C_SLV-1:0]              i2c_slv_sda_oe_o,

    //SPI MASTER
    output logic [N_SPI-1:0]                  spi_clk_o,
    output logic [N_SPI-1:0][3:0]             spi_csn_o,
    output logic [N_SPI-1:0][3:0]             spi_oen_o,
    output logic [N_SPI-1:0][3:0]             spi_sdo_o,
    input logic [N_SPI-1:0][3:0]              spi_sdi_i,

    //SPI SLAVE
    input logic                               spi_clk_i,
    input logic                               spi_csn_i,
    output logic [3:0]                        spi_oen_slv_o,
    output logic [3:0]                        spi_sdo_slv_o,
    input logic [3:0]                         spi_sdi_slv_i,

    //INTER-SOCKET MUX SIGNALS
    output logic                              sel_spi_dir_o,
    output logic                              sel_i2c_mux_o,


    output logic [EVNT_WIDTH-1:0]             cl_event_data_o,
    output logic                              cl_event_valid_o,
    input logic                               cl_event_ready_i,

    output logic [EVNT_WIDTH-1:0]             fc_event_data_o,
    output logic                              fc_event_valid_o,
    input logic                               fc_event_ready_i,

    output logic                              cluster_pow_o,
    output logic                              cluster_byp_o, // bypass cluster
    output logic [63:0]                       cluster_boot_addr_o,
    output logic                              cluster_fetch_enable_o,
    output logic                              cluster_rstn_o,
    output logic                              cluster_irq_o,

    output logic [1:0]                        wdt_alert_o,
    input  logic                              wdt_alert_clear_i,

    input logic                               bus_instr_err_i,
    input logic                               bus_data_err_i,

    AXI_BUS.Master                            axi_i2c_slv_bmc,
    AXI_BUS.Master                            axi_i2c_slv_1
);

    localparam USE_IBEX = CORE_TYPE == 1 || CORE_TYPE == 2;


    APB_BUS s_gpio_bus ();
    APB_BUS s_udma_bus ();
    APB_BUS s_soc_ctrl_bus ();
    APB_BUS s_adv_timer_bus ();
    APB_BUS s_soc_evnt_gen_bus ();
    APB_BUS s_clic_bus ();
    APB_BUS s_stdout_bus ();
    APB_BUS s_apb_timer_bus ();

    APB_BUS s_apb_wdt_bus ();
    APB_BUS s_apb_i2c_slv_bmc_bus();
    APB_BUS s_apb_i2c_slv_1_bus();

    localparam UDMA_EVENTS = 32*4;

    logic [NGPIO-1:0] s_gpio_sync;

    logic       s_sel_hyper_axi;
    logic       s_sel_spi_dir;

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

    logic s_i2c_slv_bmc_event;
    logic s_i2c_slv_1_event;

    logic wdt_rst;
    logic wdt_alert;

    assign s_events[UDMA_EVENTS-1:0]  = s_udma_events;
    assign s_events[135]              = s_adv_timer_events[0];
    assign s_events[136]              = s_adv_timer_events[1];
    assign s_events[137]              = s_adv_timer_events[2];
    assign s_events[138]              = s_adv_timer_events[3];
    assign s_events[139]              = s_gpio_event;
    assign s_events[140]              = fc_hwpe_events_i[0];
    assign s_events[141]              = fc_hwpe_events_i[1];
    assign s_events[159:142]          = '0;

    generate
    if ( USE_IBEX == 0) begin: FC_EVENTS
    assign fc_events_o[7:0] = 8'h0; //RESERVED for sw events
    assign fc_events_o[8]   = dma_pe_evt_i;
    assign fc_events_o[9]   = dma_pe_irq_i;
    assign fc_events_o[10]  = s_timer_lo_event;
    assign fc_events_o[11]  = s_timer_hi_event;
    assign fc_events_o[12]  = pf_evt_i;
    assign fc_events_o[13]  = s_i2c_slv_bmc_event;
    assign fc_events_o[14]  = s_ref_rise_event | s_ref_fall_event;
    assign fc_events_o[15]  = s_gpio_event;
    assign fc_events_o[16]  = s_i2c_slv_1_event;
    assign fc_events_o[17]  = s_adv_timer_events[0];
    assign fc_events_o[18]  = s_adv_timer_events[1];
    assign fc_events_o[19]  = s_adv_timer_events[2];
    assign fc_events_o[20]  = s_adv_timer_events[3];
    assign fc_events_o[21]  = bus_instr_err_i;
    assign fc_events_o[22]  = bus_data_err_i;
    assign fc_events_o[23]  = 1'b0;
    assign fc_events_o[24]  = 1'b0;
    assign fc_events_o[25]  = 1'b0; // RESERVED for plic interrupts
    assign fc_events_o[26]  = 1'b0; // RESERVED for soc event FIFO
                                    // (many events get implicitely muxed into
                                    // this interrupt. A user that gets such an
                                    // interrupt has to check the event unit's
                                    // registers to see what happened)
    assign fc_events_o[27]  = 1'b0;
    assign fc_events_o[28]  = wdt_rst; // edge triggered wdt rst request
    assign fc_events_o[29]  = s_fc_err_events;
    assign fc_events_o[30]  = s_fc_hp_events[0];
    assign fc_events_o[31]  = s_fc_hp_events[1];
    end else begin : FC_EVENTS
    assign fc_events_o[0]     = s_timer_lo_event;
    assign fc_events_o[1]     = s_timer_hi_event;
    assign fc_events_o[2]     = s_ref_rise_event | s_ref_fall_event;
    assign fc_events_o[3]     = s_gpio_event;
    assign fc_events_o[4]     = s_adv_timer_events[0];
    assign fc_events_o[5]     = s_adv_timer_events[1];
    assign fc_events_o[6]     = s_adv_timer_events[2];
    assign fc_events_o[7]     = s_adv_timer_events[3];
    assign fc_events_o[8]     = s_i2c_slv_bmc_event;
    assign fc_events_o[9]     = s_i2c_slv_1_event;
    assign fc_events_o[10]    = 1'b0; //RESERVED for soc event FIFO
    assign fc_events_o[11]    = s_fc_err_events;
    assign fc_events_o[12]    = s_fc_hp_events[0];
    assign fc_events_o[13]    = s_fc_hp_events[1];
    assign fc_events_o[14]    = wdt_rst;
    assign fc_events_o[31:15] = 17'b0; // not supported by Ibex
    end
    endgenerate

    assign sel_spi_dir_o = s_sel_spi_dir;
	

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
    ) i_periph_bus (
        .clk_i               ( clk_i                 ),
        .rst_ni              ( rst_ni                ),

        .apb_slave           ( apb_slave             ),

        .clk_ctrl_master     ( apb_clk_ctrl_master   ),
        .serial_link_master  ( apb_serial_link_master),
        .pad_cfg_master      ( apb_pad_cfg_master    ),
        .gpio_master         ( s_gpio_bus            ),
        .udma_master         ( s_udma_bus            ),
        .soc_ctrl_master     ( s_soc_ctrl_bus        ),
        .adv_timer_master    ( s_adv_timer_bus       ),
        .soc_evnt_gen_master ( s_soc_evnt_gen_bus    ),
        .clic_master         ( apb_clic_master       ),
        .eu_master           ( apb_eu_master         ),
        .mmap_debug_master   ( apb_debug_master      ),
        .hwpe_master         ( apb_hwpe_master       ),
        .timer_master        ( s_apb_timer_bus       ),
        .stdout_master       ( s_stdout_bus          ),
        .wdt_master          ( s_apb_wdt_bus         ),
        .i2c_slv_bmc_master  ( s_apb_i2c_slv_bmc_bus ),
        .i2c_slv_1_master    ( s_apb_i2c_slv_1_bus   )
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
          .ADDR_WIDTH ( 32       ),
          .DATA_WIDTH ( 32       ),
          .NB_CORES   ( NB_CORES ),
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
     assign s_stdout_bus.pready  = 'h0;
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

    if (NBIT_PADCFG != 4)
        $error("apb_gpio doesn't support a NBIT_PADCFG bitwidth other than 4");

    apb_gpio #(
        .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
        .PAD_NUM        (NGPIO),
        .PAD_CFG        (NBIT_PADCFG)
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
        .UDMA_EVENTS        ( UDMA_EVENTS          ),
        .N_SPI              ( N_SPI                ),
        .N_UART             ( N_UART               ),
        .N_I2C              ( N_I2C                )
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
        .dft_cg_enable_i  ( dft_cg_enable_i      ),

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

        .uart_rx_i        ( uart_rx              ),
        .uart_tx_o        ( uart_tx              ),

        .i2c_scl_i        ( i2c_scl_i            ),
        .i2c_scl_o        ( i2c_scl_o            ),
        .i2c_scl_oe       ( i2c_scl_oe_o         ),
        .i2c_sda_i        ( i2c_sda_i            ),
        .i2c_sda_o        ( i2c_sda_o            ),
        .i2c_sda_oe       ( i2c_sda_oe_o         )

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

        .sel_clk_i           ( sel_clk_i              ),
        .bootsel_valid_i     ( bootsel_valid_i        ),
        .bootsel_i           ( bootsel_i              ),
        .fc_fetch_en_valid_i ( fc_fetch_en_valid_i    ),
        .fc_fetch_en_i       ( fc_fetch_en_i          ),

        .fc_bootaddr_o       ( fc_bootaddr_o          ),
        .fc_fetchen_o        ( fc_fetchen_o           ),

        .soc_jtag_reg_i      ( soc_jtag_reg_i         ),
        .soc_jtag_reg_o      ( soc_jtag_reg_o         ),

        .cluster_pow_o       ( cluster_pow_o          ),
        .sel_hyper_axi_o     ( s_sel_hyper_axi        ),
        .sel_spi_dir_o       ( s_sel_spi_dir          ),
		.sel_i2c_mux_o       ( sel_i2c_mux_o          ),

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

    //
    // event generator (now only for cluster)
    //

    soc_event_generator #(
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .APB_EVNT_NUM   ( 8              ),
        .PER_EVNT_NUM   ( 160            ),
        .EVNT_WIDTH     ( EVNT_WIDTH     ),
        .FC_EVENT_POS   ( 7              )
    ) i_u_evnt_gen (
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

    // arbitrate interrupt requests between plic and soc event generator


    //
    // timer unit
    //

    apb_timer_unit #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
    ) i_apb_timer_unit (
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


    /////////////////////////////////////////////////////////////////
    //  █████╗ ██████╗ ██████╗       ██╗    ██╗ ██████╗  ████████╗ //
    // ██╔══██╗██╔══██╗██╔══██╗      ██║    ██║ ██╔══██╗ ╚══██╔══╝ //
    // ███████║██████╔╝██████╔╝      ██║ █╗ ██║ ██║  ██║    ██║    //
    // ██╔══██║██╔═══╝ ██╔══██╗      ██║███╗██║ ██║  ██║    ██║    //
    // ██║  ██║██║     ██████╔╝      ╚███╔███╔╝ ██████╔╝    ██║    //
    // ╚═╝  ╚═╝╚═╝     ╚═════╝        ╚══╝╚══╝  ╚═════╝     ╚═╝    //
    ////////////////////////////////////////////////////////////////

    wdt #(
        .APB_ADDR_WIDTH(APB_ADDR_WIDTH)
    ) i_wdt (
        .clk_i,
        .rst_ni,

        .wdt_rst_o     ( wdt_rst               ),
        .alert_clear_i ( wdt_alert_clear_i     ),
        .alert_o       ( wdt_alert             ),

        .hclk_i        ( clk_i                 ),
        .hreset_ni     ( rst_ni                ),
        .paddr_i       ( s_apb_wdt_bus.paddr   ),
        .pwdata_i      ( s_apb_wdt_bus.pwdata  ),
        .pwrite_i      ( s_apb_wdt_bus.pwrite  ),
        .psel_i        ( s_apb_wdt_bus.psel    ),
        .penable_i     ( s_apb_wdt_bus.penable ),

        .prdata_o      ( s_apb_wdt_bus.prdata  ),
        .pready_o      ( s_apb_wdt_bus.pready  ),
        .pslverr_o     ( s_apb_wdt_bus.pslverr )
    );

    // we currently support only one type of alert
    assign wdt_alert_o = {1'b0, wdt_alert};

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    █████╗ ██╗  ██╗██╗     █████╗ ██████╗ ██████╗     ██╗██████╗  ██████╗    ███████╗██╗      █████╗ ██╗   ██╗███████╗    ██████╗ ███╗   ███╗ ██████╗   //
    //   ██╔══██╗╚██╗██╔╝██║    ██╔══██╗██╔══██╗██╔══██╗    ██║╚════██╗██╔════╝    ██╔════╝██║     ██╔══██╗██║   ██║██╔════╝    ██╔══██╗████╗ ████║██╔════╝   //
    //   ███████║ ╚███╔╝ ██║    ███████║██████╔╝██████╔╝    ██║ █████╔╝██║         ███████╗██║     ███████║██║   ██║█████╗      ██████╔╝██╔████╔██║██║        //
    //   ██╔══██║ ██╔██╗ ██║    ██╔══██║██╔═══╝ ██╔══██╗    ██║██╔═══╝ ██║         ╚════██║██║     ██╔══██║╚██╗ ██╔╝██╔══╝      ██╔══██╗██║╚██╔╝██║██║        //
    //   ██║  ██║██╔╝ ██╗██║    ██║  ██║██║     ██████╔╝    ██║███████╗╚██████╗    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗    ██████╔╝██║ ╚═╝ ██║╚██████╗   //
    //   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚═╝  ╚═╝╚═╝     ╚═════╝     ╚═╝╚══════╝ ╚═════╝    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝    ╚═════╝ ╚═╝     ╚═╝ ╚═════╝   //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    axi_apb_i2c_slave #(
        .APB_ADDR_WIDTH         ( APB_ADDR_WIDTH                           ),
        .AXI_ADDR_WIDTH         ( AXI_ADDR_WIDTH                           ),
        .AXI_DATA_WIDTH         ( AXI_DATA_IN_WIDTH                        ), //TODO: Add AXI dwc converter
        .AXI_ID_WIDTH           ( AXI_64_ID_IN_WIDTH                       ),
        .AXI_USER_WIDTH         ( AXI_32_USER_WIDTH                        ),
        .BASE_ADDRESS           ( 32'h1C03_0000                            )
    ) i_axi_apb_i2c_slave_bmc (
        .clk_i                  ( clk_i                                    ),
        .rstn_i                 ( rst_ni                                   ),
        //i2c
        .scl_i                  ( i2c_slv_scl_i[0]                         ),
        .scl_o                  ( i2c_slv_scl_o[0]                         ),
        .scl_oe                 ( i2c_slv_scl_oe_o[0]                      ),
        .sda_i                  ( i2c_slv_sda_i[0]                         ),
        .sda_o                  ( i2c_slv_sda_o[0]                         ),
        .sda_oe                 ( i2c_slv_sda_oe_o[0]                      ),
        //interrupt:
        .int1_o                 ( s_i2c_slv_bmc_event                      ),
        //apb
        .HCLK_i                 ( clk_i                                    ),
        .HRESETn_i              ( rst_ni                                   ),
        .PADDR_i                ( s_apb_i2c_slv_bmc_bus.paddr              ),
        .PWDATA_i               ( s_apb_i2c_slv_bmc_bus.pwdata             ),
        .PWRITE_i               ( s_apb_i2c_slv_bmc_bus.pwrite             ),
        .PSEL_i                 ( s_apb_i2c_slv_bmc_bus.psel               ),
        .PENABLE_i              ( s_apb_i2c_slv_bmc_bus.penable            ),

        .PRDATA_o               ( s_apb_i2c_slv_bmc_bus.prdata             ),
        .PREADY_o               ( s_apb_i2c_slv_bmc_bus.pready             ),
        .PSLVERR_o              ( s_apb_i2c_slv_bmc_bus.pslverr            ),

         //AXI4:
        .axi_aclk_i             ( clk_i                                    ),
        .axi_aresetn_i          ( rst_ni                                   ),

        // ADDRESS WRITE CHANNEL
        .axi_master_aw_addr_o   ( axi_i2c_slv_bmc.aw_addr                        ),
        .axi_master_aw_prot_o   ( axi_i2c_slv_bmc.aw_prot                        ),
        .axi_master_aw_region_o ( axi_i2c_slv_bmc.aw_region                      ),
        .axi_master_aw_len_o    ( axi_i2c_slv_bmc.aw_len                         ),
        .axi_master_aw_size_o   ( axi_i2c_slv_bmc.aw_size                        ),
        .axi_master_aw_burst_o  ( axi_i2c_slv_bmc.aw_burst                       ),
        .axi_master_aw_lock_o   ( axi_i2c_slv_bmc.aw_lock                        ),
        .axi_master_aw_cache_o  ( axi_i2c_slv_bmc.aw_cache                       ),
        .axi_master_aw_qos_o    ( axi_i2c_slv_bmc.aw_qos                         ),
        .axi_master_aw_id_o     ( axi_i2c_slv_bmc.aw_id[AXI_64_ID_IN_WIDTH-1:0]     ),
        .axi_master_aw_user_o   ( axi_i2c_slv_bmc.aw_user[AXI_32_USER_WIDTH-1:0] ),
        .axi_master_aw_valid_o  ( axi_i2c_slv_bmc.aw_valid                       ),
        .axi_master_aw_ready_i  ( axi_i2c_slv_bmc.aw_ready                       ),

        // ADDRESS READ CHANNEL
        .axi_master_ar_addr_o   ( axi_i2c_slv_bmc.ar_addr                        ),
        .axi_master_ar_prot_o   ( axi_i2c_slv_bmc.ar_prot                        ),
        .axi_master_ar_region_o ( axi_i2c_slv_bmc.ar_region                      ),
        .axi_master_ar_len_o    ( axi_i2c_slv_bmc.ar_len                         ),
        .axi_master_ar_size_o   ( axi_i2c_slv_bmc.ar_size                        ),
        .axi_master_ar_burst_o  ( axi_i2c_slv_bmc.ar_burst                       ),
        .axi_master_ar_lock_o   ( axi_i2c_slv_bmc.ar_lock                        ),
        .axi_master_ar_cache_o  ( axi_i2c_slv_bmc.ar_cache                       ),
        .axi_master_ar_qos_o    ( axi_i2c_slv_bmc.ar_qos                         ),
        .axi_master_ar_id_o     ( axi_i2c_slv_bmc.ar_id[AXI_64_ID_IN_WIDTH-1:0]     ),
        .axi_master_ar_user_o   ( axi_i2c_slv_bmc.ar_user[AXI_32_USER_WIDTH-1:0] ),
        .axi_master_ar_valid_o  ( axi_i2c_slv_bmc.ar_valid                       ),
        .axi_master_ar_ready_i  ( axi_i2c_slv_bmc.ar_ready                       ),

        // WRITE CHANNEL
        .axi_master_w_user_o    ( axi_i2c_slv_bmc.w_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_w_data_o    ( axi_i2c_slv_bmc.w_data                         ),
        .axi_master_w_strb_o    ( axi_i2c_slv_bmc.w_strb                         ),
        .axi_master_w_last_o    ( axi_i2c_slv_bmc.w_last                         ),
        .axi_master_w_valid_o   ( axi_i2c_slv_bmc.w_valid                        ),
        .axi_master_w_ready_i   ( axi_i2c_slv_bmc.w_ready                        ),

        // READ CHANNEL
        .axi_master_r_id_i      ( axi_i2c_slv_bmc.r_id[AXI_64_ID_IN_WIDTH-1:0]      ),
        .axi_master_r_user_i    ( axi_i2c_slv_bmc.r_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_r_data_i    ( axi_i2c_slv_bmc.r_data                         ),
        .axi_master_r_resp_i    ( axi_i2c_slv_bmc.r_resp                         ),
        .axi_master_r_last_i    ( axi_i2c_slv_bmc.r_last                         ),
        .axi_master_r_valid_i   ( axi_i2c_slv_bmc.r_valid                        ),
        .axi_master_r_ready_o   ( axi_i2c_slv_bmc.r_ready                        ),

        // WRITE RESPONSE CHANNEL
        .axi_master_b_id_i      ( axi_i2c_slv_bmc.b_id[AXI_64_ID_IN_WIDTH-1:0]      ),
        .axi_master_b_resp_i    ( axi_i2c_slv_bmc.b_resp                         ),
        .axi_master_b_user_i    ( axi_i2c_slv_bmc.b_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_b_valid_i   ( axi_i2c_slv_bmc.b_valid                        ),
        .axi_master_b_ready_o   ( axi_i2c_slv_bmc.b_ready                        )

    );


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //   █████╗ ██╗  ██╗██╗     █████╗ ██████╗ ██████╗     ██╗██████╗  ██████╗    ███████╗██╗      █████╗ ██╗   ██╗███████╗     ██╗ //
    //  ██╔══██╗╚██╗██╔╝██║    ██╔══██╗██╔══██╗██╔══██╗    ██║╚════██╗██╔════╝    ██╔════╝██║     ██╔══██╗██║   ██║██╔════╝    ███║ //
    //  ███████║ ╚███╔╝ ██║    ███████║██████╔╝██████╔╝    ██║ █████╔╝██║         ███████╗██║     ███████║██║   ██║█████╗      ╚██║ //
    //  ██╔══██║ ██╔██╗ ██║    ██╔══██║██╔═══╝ ██╔══██╗    ██║██╔═══╝ ██║         ╚════██║██║     ██╔══██║╚██╗ ██╔╝██╔══╝       ██║ //
    //  ██║  ██║██╔╝ ██╗██║    ██║  ██║██║     ██████╔╝    ██║███████╗╚██████╗    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗     ██║ //
    //  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚═╝  ╚═╝╚═╝     ╚═════╝     ╚═╝╚══════╝ ╚═════╝    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝     ╚═╝ //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    axi_apb_i2c_slave #(
        .APB_ADDR_WIDTH         ( APB_ADDR_WIDTH                               ),
        .AXI_ADDR_WIDTH         ( AXI_ADDR_WIDTH                               ),
        .AXI_DATA_WIDTH         ( AXI_DATA_IN_WIDTH                            ), //TODO: Add AXI dwc converter
        .AXI_ID_WIDTH           ( AXI_64_ID_IN_WIDTH                           ),
        .AXI_USER_WIDTH         ( AXI_32_USER_WIDTH                            ),
        .BASE_ADDRESS           ( 32'h1A15_0000                                )
    ) i_axi_apb_i2c_slave_1 (
        .clk_i                  ( clk_i                                        ),
        .rstn_i                 ( rst_ni                                       ),
        //i2c
        .scl_i                  ( i2c_slv_scl_i[1]                             ),
        .scl_o                  ( i2c_slv_scl_o[1]                             ),
        .scl_oe                 ( i2c_slv_scl_oe_o[1]                          ),
        .sda_i                  ( i2c_slv_sda_i[1]                             ),
        .sda_o                  ( i2c_slv_sda_o[1]                             ),
        .sda_oe                 ( i2c_slv_sda_oe_o[1]                          ),
        //interrupt:
        .int1_o                 ( s_i2c_slv_1_event                            ),
        //apb
        .HCLK_i                 ( clk_i                                        ),
        .HRESETn_i              ( rst_ni                                       ),
        .PADDR_i                ( s_apb_i2c_slv_1_bus.paddr                    ),
        .PWDATA_i               ( s_apb_i2c_slv_1_bus.pwdata                   ),
        .PWRITE_i               ( s_apb_i2c_slv_1_bus.pwrite                   ),
        .PSEL_i                 ( s_apb_i2c_slv_1_bus.psel                     ),
        .PENABLE_i              ( s_apb_i2c_slv_1_bus.penable                  ),

        .PRDATA_o               ( s_apb_i2c_slv_1_bus.prdata                   ),
        .PREADY_o               ( s_apb_i2c_slv_1_bus.pready                   ),
        .PSLVERR_o              ( s_apb_i2c_slv_1_bus.pslverr                  ),

         //AXI4:
        .axi_aclk_i             ( clk_i                                        ),
        .axi_aresetn_i          ( rst_ni                                       ),

        // ADDRESS WRITE CHANNEL
        .axi_master_aw_addr_o   ( axi_i2c_slv_1.aw_addr                        ),
        .axi_master_aw_prot_o   ( axi_i2c_slv_1.aw_prot                        ),
        .axi_master_aw_region_o ( axi_i2c_slv_1.aw_region                      ),
        .axi_master_aw_len_o    ( axi_i2c_slv_1.aw_len                         ),
        .axi_master_aw_size_o   ( axi_i2c_slv_1.aw_size                        ),
        .axi_master_aw_burst_o  ( axi_i2c_slv_1.aw_burst                       ),
        .axi_master_aw_lock_o   ( axi_i2c_slv_1.aw_lock                        ),
        .axi_master_aw_cache_o  ( axi_i2c_slv_1.aw_cache                       ),
        .axi_master_aw_qos_o    ( axi_i2c_slv_1.aw_qos                         ),
        .axi_master_aw_id_o     ( axi_i2c_slv_1.aw_id[AXI_64_ID_IN_WIDTH-1:0]     ),
        .axi_master_aw_user_o   ( axi_i2c_slv_1.aw_user[AXI_32_USER_WIDTH-1:0] ),
        .axi_master_aw_valid_o  ( axi_i2c_slv_1.aw_valid                       ),
        .axi_master_aw_ready_i  ( axi_i2c_slv_1.aw_ready                       ),

        // ADDRESS READ CHANNEL
        .axi_master_ar_addr_o   ( axi_i2c_slv_1.ar_addr                        ),
        .axi_master_ar_prot_o   ( axi_i2c_slv_1.ar_prot                        ),
        .axi_master_ar_region_o ( axi_i2c_slv_1.ar_region                      ),
        .axi_master_ar_len_o    ( axi_i2c_slv_1.ar_len                         ),
        .axi_master_ar_size_o   ( axi_i2c_slv_1.ar_size                        ),
        .axi_master_ar_burst_o  ( axi_i2c_slv_1.ar_burst                       ),
        .axi_master_ar_lock_o   ( axi_i2c_slv_1.ar_lock                        ),
        .axi_master_ar_cache_o  ( axi_i2c_slv_1.ar_cache                       ),
        .axi_master_ar_qos_o    ( axi_i2c_slv_1.ar_qos                         ),
        .axi_master_ar_id_o     ( axi_i2c_slv_1.ar_id[AXI_64_ID_IN_WIDTH-1:0]  ),
        .axi_master_ar_user_o   ( axi_i2c_slv_1.ar_user[AXI_32_USER_WIDTH-1:0] ),
        .axi_master_ar_valid_o  ( axi_i2c_slv_1.ar_valid                       ),
        .axi_master_ar_ready_i  ( axi_i2c_slv_1.ar_ready                       ),

        // WRITE CHANNEL
        .axi_master_w_user_o    ( axi_i2c_slv_1.w_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_w_data_o    ( axi_i2c_slv_1.w_data                         ),
        .axi_master_w_strb_o    ( axi_i2c_slv_1.w_strb                         ),
        .axi_master_w_last_o    ( axi_i2c_slv_1.w_last                         ),
        .axi_master_w_valid_o   ( axi_i2c_slv_1.w_valid                        ),
        .axi_master_w_ready_i   ( axi_i2c_slv_1.w_ready                        ),

        // READ CHANNEL
        .axi_master_r_id_i      ( axi_i2c_slv_1.r_id[AXI_64_ID_IN_WIDTH-1:0]   ),
        .axi_master_r_user_i    ( axi_i2c_slv_1.r_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_r_data_i    ( axi_i2c_slv_1.r_data                         ),
        .axi_master_r_resp_i    ( axi_i2c_slv_1.r_resp                         ),
        .axi_master_r_last_i    ( axi_i2c_slv_1.r_last                         ),
        .axi_master_r_valid_i   ( axi_i2c_slv_1.r_valid                        ),
        .axi_master_r_ready_o   ( axi_i2c_slv_1.r_ready                        ),

        // WRITE RESPONSE CHANNEL
        .axi_master_b_id_i      ( axi_i2c_slv_1.b_id[AXI_64_ID_IN_WIDTH-1:0]   ),
        .axi_master_b_resp_i    ( axi_i2c_slv_1.b_resp                         ),
        .axi_master_b_user_i    ( axi_i2c_slv_1.b_user[AXI_32_USER_WIDTH-1:0]  ),
        .axi_master_b_valid_i   ( axi_i2c_slv_1.b_valid                        ),
        .axi_master_b_ready_o   ( axi_i2c_slv_1.b_ready                        )

    );


    //////////////////////////////////////////////////////////////////////////////////////////////
    //   █████╗ ██╗  ██╗██╗    ███████╗██████╗ ██╗    ███████╗██╗      █████╗ ██╗   ██╗███████╗ //
    //  ██╔══██╗╚██╗██╔╝██║    ██╔════╝██╔══██╗██║    ██╔════╝██║     ██╔══██╗██║   ██║██╔════╝ //
    //  ███████║ ╚███╔╝ ██║    ███████╗██████╔╝██║    ███████╗██║     ███████║██║   ██║█████╗   //
    //  ██╔══██║ ██╔██╗ ██║    ╚════██║██╔═══╝ ██║    ╚════██║██║     ██╔══██║╚██╗ ██╔╝██╔══╝   //
    //  ██║  ██║██╔╝ ██╗██║    ███████║██║     ██║    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗ //
    //  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚══════╝╚═╝     ╚═╝    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝ //
    //////////////////////////////////////////////////////////////////////////////////////////////

    axi_spi_slave_wrap #(
      .AXI_ADDRESS_WIDTH  ( AXI_ADDR_WIDTH       ),
      .AXI_DATA_WIDTH     ( AXI_DATA_IN_WIDTH    ), //TODO: Add AXI dwc converter
      .AXI_USER_WIDTH     ( AXI_32_USER_WIDTH    ),
      .AXI_ID_WIDTH       ( AXI_64_ID_IN_WIDTH   )
    ) axi_spi_slave_i (
      .clk_i      ( clk_i            ),
      .rst_ni     ( rst_ni           ),

      .test_mode  ( dft_test_mode_i  ),

      .axi_master ( axi_mst_spi_slv  ),

      .spi_clk    ( spi_clk_i        ),
      .spi_cs     ( spi_csn_i        ),
      .spi_oen0_o ( spi_oen_slv_o[0] ),
      .spi_oen1_o ( spi_oen_slv_o[1] ),
      .spi_oen2_o ( spi_oen_slv_o[2] ),
      .spi_oen3_o ( spi_oen_slv_o[3] ),
      .spi_sdo0   ( spi_sdo_slv_o[0] ),
      .spi_sdo1   ( spi_sdo_slv_o[1] ),
      .spi_sdo2   ( spi_sdo_slv_o[2] ),
      .spi_sdo3   ( spi_sdo_slv_o[3] ),
      .spi_sdi0   ( spi_sdi_slv_i[0] ),
      .spi_sdi1   ( spi_sdi_slv_i[1] ),
      .spi_sdi2   ( spi_sdi_slv_i[2] ),
      .spi_sdi3   ( spi_sdi_slv_i[3] )
    );

endmodule
