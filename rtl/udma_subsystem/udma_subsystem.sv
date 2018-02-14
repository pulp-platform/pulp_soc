// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module udma_subsystem
#(
    parameter UDMA_EVENTS   = 28,
    parameter L2_ADDR_WIDTH = 15,
    parameter L2_DATA_WIDTH = 32,
    parameter CAM_DATA_WIDTH = 8,
    parameter APB_ADDR_WIDTH = 12,  //APB slaves are 4KB by default
    parameter TRANS_SIZE     = 17
)
(
    output logic                       L2_ro_wen_o    ,
    output logic                       L2_ro_req_o    ,
    input  logic                       L2_ro_gnt_i    ,
    output logic                [31:0] L2_ro_addr_o   ,
    output logic [L2_DATA_WIDTH/8-1:0] L2_ro_be_o     ,
    output logic   [L2_DATA_WIDTH-1:0] L2_ro_wdata_o  ,
    input  logic                       L2_ro_rvalid_i ,
    input  logic   [L2_DATA_WIDTH-1:0] L2_ro_rdata_i  ,

    output logic                       L2_wo_wen_o    ,
    output logic                       L2_wo_req_o    ,
    input  logic                       L2_wo_gnt_i    ,
    output logic                [31:0] L2_wo_addr_o   ,
    output logic   [L2_DATA_WIDTH-1:0] L2_wo_wdata_o  ,
    output logic [L2_DATA_WIDTH/8-1:0] L2_wo_be_o     ,
    input  logic                       L2_wo_rvalid_i ,
    input  logic   [L2_DATA_WIDTH-1:0] L2_wo_rdata_i  ,

    input  logic                       dft_test_mode_i,
    input  logic                       dft_cg_enable_i,

    input  logic                       sys_clk_i,
    input  logic                       periph_clk_i,
    input  logic                       HRESETn,
    input  logic  [APB_ADDR_WIDTH-1:0] PADDR,
    input  logic                [31:0] PWDATA,
    input  logic                       PWRITE,
    input  logic                       PSEL,
    input  logic                       PENABLE,
    output logic                [31:0] PRDATA,
    output logic                       PREADY,
    output logic                       PSLVERR,

    output logic     [UDMA_EVENTS-1:0] events_o,

    input  logic                      event_valid_i,
    input  logic                [7:0] event_data_i,
    output logic                      event_ready_o,

    output logic                       spi0_clk,
    output logic                       spi0_csn0,
    output logic                       spi0_csn1,
    output logic                       spi0_csn2,
    output logic                       spi0_csn3,
    output logic                 [1:0] spi0_mode,
    output logic                       spi0_sdo0,
    output logic                       spi0_sdo1,
    output logic                       spi0_sdo2,
    output logic                       spi0_sdo3,
    input  logic                       spi0_sdi0,
    input  logic                       spi0_sdi1,
    input  logic                       spi0_sdi2,
    input  logic                       spi0_sdi3,

    input  logic                       cam_clk_i,
    input  logic  [CAM_DATA_WIDTH-1:0] cam_data_i,
    input  logic                       cam_hsync_i,
    input  logic                       cam_vsync_i,

    input  logic                       uart_rx,
    output logic                       uart_tx,

    input  logic                       i2s_sd0_i,
    input  logic                       i2s_sd1_i,
    input  logic                       i2s_ws_i,
    input  logic                       i2s_sck_i,
    output logic                       i2s_ws0_o,
    output logic                       i2s_sck0_o,
    output logic [1:0]                 i2s_mode0_o,
    output logic                       i2s_ws1_o,
    output logic                       i2s_sck1_o,
    output logic [1:0]                 i2s_mode1_o,

    input  logic                       i2c0_scl_i,
    output logic                       i2c0_scl_o,
    output logic                       i2c0_scl_oe,
    input  logic                       i2c0_sda_i,
    output logic                       i2c0_sda_o,
    output logic                       i2c0_sda_oe,

    input  logic                       i2c1_scl_i,
    output logic                       i2c1_scl_o,
    output logic                       i2c1_scl_oe,
    input  logic                       i2c1_sda_i,
    output logic                       i2c1_sda_o,
    output logic                       i2c1_sda_oe,

    output logic                       sdclk_o,           
    output logic                       sdcmd_o,
    input  logic                       sdcmd_i,
    output logic                       sdcmd_oen_o,
    output logic                 [3:0] sddata_o,
    input  logic                 [3:0] sddata_i,
    output logic                 [3:0] sddata_oen_o

);
    localparam N_I2S  = 1;
    localparam N_UART = 1;
    localparam N_SPI  = 1;
    localparam N_I2C  = 2;
    localparam N_CAM  = 1;
    localparam N_RF   = 0;
    localparam N_SDIO = 1;
    localparam N_HYPER = 0;

    localparam N_RX_CHANNELS = N_SPI + N_HYPER + N_UART + N_I2C + N_SDIO + N_CAM + 2*N_I2S;
    localparam N_TX_CHANNELS = N_SPI + N_HYPER + N_UART + N_I2C + N_SDIO;

    localparam L2_AWIDTH_NOAL = L2_ADDR_WIDTH+2; //address width not aligned to 64bit

    localparam N_PERIPHS = N_RF + N_SPI + N_HYPER + N_UART + N_I2C + N_SDIO + N_CAM + N_I2S;

    localparam CH_ID_UART  = 0;
    localparam CH_ID_SPIM0 = 1;
    localparam CH_ID_SDIO  = 2;
    localparam CH_ID_I2C0  = 3;
    localparam CH_ID_I2C1  = 4;
    localparam CH_ID_I2S   = 5;
    localparam CH_ID_CAM   = 7;

    localparam PER_ID_UART  = 0;
    localparam PER_ID_SPIM0 = 1;
    localparam PER_ID_SDIO  = 2;
    localparam PER_ID_I2C0  = 3;
    localparam PER_ID_I2C1  = 4;
    localparam PER_ID_I2S   = 5;
    localparam PER_ID_CAM   = 6;

    logic [N_TX_CHANNELS-1:0] [L2_AWIDTH_NOAL-1 : 0] tx_cfg_startaddr;
    logic [N_TX_CHANNELS-1:0]     [TRANS_SIZE-1 : 0] tx_cfg_size;
    logic [N_TX_CHANNELS-1:0]                        tx_cfg_continuous;
    logic [N_TX_CHANNELS-1:0]                        tx_cfg_en;
    logic [N_TX_CHANNELS-1:0]                        tx_cfg_clr;

    logic [N_TX_CHANNELS-1:0]                        tx_ch_req;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_gnt;
    logic [N_TX_CHANNELS-1:0]               [31 : 0] tx_ch_data;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_valid;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_ready;
    logic [N_TX_CHANNELS-1:0]                [1 : 0] tx_ch_datasize;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_events;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_en;
    logic [N_TX_CHANNELS-1:0]                        tx_ch_pending;
    logic [N_TX_CHANNELS-1:0] [L2_AWIDTH_NOAL-1 : 0] tx_ch_curr_addr;
    logic [N_TX_CHANNELS-1:0]     [TRANS_SIZE-1 : 0] tx_ch_bytes_left;

    logic [N_RX_CHANNELS-1:0] [L2_AWIDTH_NOAL-1 : 0] rx_cfg_startaddr;
    logic [N_RX_CHANNELS-1:0]     [TRANS_SIZE-1 : 0] rx_cfg_size;
    logic [N_RX_CHANNELS-1:0]                        rx_cfg_continuous;
    logic [N_RX_CHANNELS-1:0]                        rx_cfg_filter;
    logic [N_RX_CHANNELS-1:0]                        rx_cfg_en;
    logic [N_RX_CHANNELS-1:0]                        rx_cfg_clr;

    logic [N_RX_CHANNELS-1:0]               [31 : 0] rx_ch_data;
    logic [N_RX_CHANNELS-1:0]                        rx_ch_valid;
    logic [N_RX_CHANNELS-1:0]                        rx_ch_ready;
    logic [N_RX_CHANNELS-1:0]                [1 : 0] rx_ch_datasize;
    logic [N_RX_CHANNELS-1:0]                        rx_ch_events;
    logic [N_RX_CHANNELS-1:0]                        rx_ch_en;
    logic [N_RX_CHANNELS-1:0]                        rx_ch_pending;
    logic [N_RX_CHANNELS-1:0] [L2_AWIDTH_NOAL-1 : 0] rx_ch_curr_addr;
    logic [N_RX_CHANNELS-1:0]     [TRANS_SIZE-1 : 0] rx_ch_bytes_left;

    logic [L2_ADDR_WIDTH-1:0] s_L2_ro_addr;
    logic [L2_ADDR_WIDTH-1:0] s_L2_wo_addr;

    logic [UDMA_EVENTS-1:0] s_events;

    logic         [1:0] s_rf_event;

    logic               s_spi0_eot;
    logic               s_spi1_eot;
    logic               s_spi2_eot;

    logic [N_PERIPHS-1:0]        s_clk_periphs_core;
    logic [N_PERIPHS-1:0]        s_clk_periphs_per;

    logic                 [31:0] s_periph_data_to;
    logic                  [4:0] s_periph_addr;
    logic                        s_periph_rwn;
    logic [N_PERIPHS-1:0] [31:0] s_periph_data_from;
    logic [N_PERIPHS-1:0]        s_periph_valid;
    logic [N_PERIPHS-1:0]        s_periph_ready;

    logic        [31:0] s_periph_data_from_spim0;
    logic               s_periph_valid_spim0;
    logic               s_periph_ready_from_spim0;

    logic        [31:0] s_periph_data_from_sdio;
    logic               s_periph_valid_sdio;
    logic               s_periph_ready_from_sdio;

    logic        [31:0] s_periph_data_from_i2c0;
    logic               s_periph_valid_i2c0;
    logic               s_periph_ready_from_i2c0;

    logic        [31:0] s_periph_data_from_i2c1;
    logic               s_periph_valid_i2c1;
    logic               s_periph_ready_from_i2c1;

    logic        [31:0] s_periph_data_from_uart;
    logic               s_periph_valid_uart;
    logic               s_periph_ready_from_uart;

    logic        [31:0] s_periph_data_from_i2s;
    logic               s_periph_valid_i2s;
    logic               s_periph_ready_from_i2s;

    logic        [31:0] s_periph_data_from_cam;
    logic               s_periph_valid_cam;
    logic               s_periph_ready_from_cam;

    logic         [3:0] s_trigger_events;

    logic s_cam_evt;
    logic s_i2s_evt;
    logic s_i2c1_evt;
    logic s_i2c0_evt;
    logic s_uart_evt;

    logic [2:0] s_tgen_en;

    assign L2_ro_addr_o = {8'h1C,{(32-L2_ADDR_WIDTH-10){1'b0}},s_L2_ro_addr,2'b00};
    assign L2_wo_addr_o = {8'h1C,{(32-L2_ADDR_WIDTH-10){1'b0}},s_L2_wo_addr,2'b00};

    assign s_cam_evt  = 1'b0;
    assign s_i2s_evt  = 1'b0;
    assign s_uart_evt = 1'b0;

    assign rx_cfg_filter[CH_ID_UART]  = 1'b0;
    assign rx_cfg_filter[CH_ID_SDIO]  = 1'b0;
    assign rx_cfg_filter[CH_ID_SPIM0] = 1'b0;
    assign rx_cfg_filter[CH_ID_I2C0]  = 1'b0;
    assign rx_cfg_filter[CH_ID_I2C1]  = 1'b0;
    assign rx_cfg_filter[CH_ID_I2S]   = 1'b0;
    assign rx_cfg_filter[CH_ID_I2S+1] = 1'b0;

    assign s_events = {
                    `ifdef HYPER_RAM
                        3'h0,
                    `else
                        6'h0,
                    `endif
                        s_cam_evt,                     //camera event            EVENT25
                        rx_ch_events[CH_ID_CAM],       //camera IF               EVENT24
                        s_i2s_evt,                     //i2s event               EVENT23
                        rx_ch_events[CH_ID_I2S+1],     //i2s0 channels           EVENT22
                        rx_ch_events[CH_ID_I2S],       //i2s0 channels           EVENT21
                        2'h0,
                        s_i2c1_evt,                    //i2c1 event              EVENT18
                        rx_ch_events[CH_ID_I2C1],      //i2c1                    EVENT17
                        tx_ch_events[CH_ID_I2C1],      //i2c1                    EVENT16
                        s_i2c0_evt,                    //i2c0 event              EVENT15
                        rx_ch_events[CH_ID_I2C0],      //i2c0                    EVENT14
                        tx_ch_events[CH_ID_I2C0],      //i2c0                    EVENT13
                        1'b0      ,                    //hyper RFU               EVENT9
                        rx_ch_events[CH_ID_SDIO],      //sdio  rx                EVENT8
                        tx_ch_events[CH_ID_SDIO],      //sdio  tx                EVENT7
                        s_spi0_eot,                    //spim0 end of transfer   EVENT12
                        rx_ch_events[CH_ID_SPIM0],     //spim0 rx                EVENT11
                        tx_ch_events[CH_ID_SPIM0],     //spim0 tx                EVENT10
                        s_uart_evt,                    //uart event              EVENT6
                        rx_ch_events[CH_ID_UART],      //uart rx                 EVENT5
                        tx_ch_events[CH_ID_UART],      //uart tx                 EVENT4
                        4'h0
                      };

    integer i;

    assign s_periph_data_from = {
                        s_periph_data_from_cam,
                        s_periph_data_from_i2s,
                        s_periph_data_from_i2c1,
                        s_periph_data_from_i2c0,
                        s_periph_data_from_sdio,
                        s_periph_data_from_spim0,
                        s_periph_data_from_uart
    };

    assign s_periph_ready = {
                        s_periph_ready_from_cam,
                        s_periph_ready_from_i2s,
                        s_periph_ready_from_i2c1,
                        s_periph_ready_from_i2c0,
                        s_periph_ready_from_sdio,
                        s_periph_ready_from_spim0,
                        s_periph_ready_from_uart
    };

    assign s_periph_valid_uart  = s_periph_valid[PER_ID_UART];
    assign s_periph_valid_spim0 = s_periph_valid[PER_ID_SPIM0];
    assign s_periph_valid_sdio  = s_periph_valid[PER_ID_SDIO];
    assign s_periph_valid_i2c0  = s_periph_valid[PER_ID_I2C0];
    assign s_periph_valid_i2c1  = s_periph_valid[PER_ID_I2C1];
    assign s_periph_valid_i2s   = s_periph_valid[PER_ID_I2S];
    assign s_periph_valid_cam   = s_periph_valid[PER_ID_CAM];

    assign events_o = s_events;

    assign L2_ro_wen_o   = 1'b1;
    assign L2_wo_wen_o   = 1'b0;

    assign L2_ro_be_o    =  'h0;
    assign L2_ro_wdata_o =  'h0;

    udma_core #(
        .L2_ADDR_WIDTH(L2_ADDR_WIDTH),
        .L2_DATA_WIDTH(L2_DATA_WIDTH),
        .DATA_WIDTH(32),
        .N_RX_CHANNELS(N_RX_CHANNELS),
        .N_TX_CHANNELS(N_TX_CHANNELS),
        .TRANS_SIZE(TRANS_SIZE),
        .N_PERIPHS(N_PERIPHS),
	.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
    ) u_udmacore (
        .sys_clk_i(sys_clk_i),
        .per_clk_i(periph_clk_i),

        .dft_cg_enable_i(dft_cg_enable_i),

        .HRESETn(HRESETn),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),

        .periph_per_clk_o(s_clk_periphs_per),
        .periph_sys_clk_o(s_clk_periphs_core),
    
        .event_valid_i(event_valid_i),
        .event_data_i (event_data_i),
        .event_ready_o(event_ready_o),

        .event_o(s_trigger_events),

        .filter_eot_o( s_filter_eot_evt ),
        .filter_act_o( s_filter_act_evt ),

        .periph_data_to_o(s_periph_data_to),
        .periph_addr_o(s_periph_addr),
        .periph_data_from_i(s_periph_data_from),
        .periph_ready_i(s_periph_ready),
        .periph_valid_o(s_periph_valid),
        .periph_rwn_o(s_periph_rwn),

        .tx_l2_req_o(L2_ro_req_o),
        .tx_l2_gnt_i(L2_ro_gnt_i),
        .tx_l2_addr_o(s_L2_ro_addr),
        .tx_l2_rdata_i(L2_ro_rdata_i),
        .tx_l2_rvalid_i(L2_ro_rvalid_i),

        .rx_l2_req_o(L2_wo_req_o),
        .rx_l2_gnt_i(L2_wo_gnt_i),
        .rx_l2_addr_o(s_L2_wo_addr),
        .rx_l2_be_o(L2_wo_be_o),
        .rx_l2_wdata_o(L2_wo_wdata_o),

        .tx_ch_req_i(tx_ch_req),
        .tx_ch_gnt_o(tx_ch_gnt),
        .tx_ch_valid_o(tx_ch_valid),
        .tx_ch_data_o(tx_ch_data),
        .tx_ch_ready_i(tx_ch_ready),
        .tx_ch_datasize_i(tx_ch_datasize),
        .tx_ch_events_o(tx_ch_events),
        .tx_ch_en_o(tx_ch_en),
        .tx_ch_pending_o(tx_ch_pending),
        .tx_ch_curr_addr_o(tx_ch_curr_addr),
        .tx_ch_bytes_left_o(tx_ch_bytes_left),

        .tx_cfg_startaddr_i(tx_cfg_startaddr),
        .tx_cfg_size_i(tx_cfg_size),
        .tx_cfg_continuous_i(tx_cfg_continuous),
        .tx_cfg_en_i(tx_cfg_en),
        .tx_cfg_clr_i(tx_cfg_clr),

        .rx_ch_valid_i(rx_ch_valid),
        .rx_ch_data_i(rx_ch_data),
        .rx_ch_ready_o(rx_ch_ready),
        .rx_ch_datasize_i(rx_ch_datasize),
        .rx_ch_events_o(rx_ch_events),
        .rx_ch_en_o(rx_ch_en),
        .rx_ch_pending_o(rx_ch_pending),
        .rx_ch_curr_addr_o(rx_ch_curr_addr),
        .rx_ch_bytes_left_o(rx_ch_bytes_left),

        .rx_cfg_startaddr_i(rx_cfg_startaddr),
        .rx_cfg_size_i(rx_cfg_size),
        .rx_cfg_continuous_i(rx_cfg_continuous),
        .rx_cfg_filter_i(rx_cfg_filter),
        .rx_cfg_en_i(rx_cfg_en),
        .rx_cfg_clr_i(rx_cfg_clr)
    );


    udma_uart_top #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     )
    ) u_uart (
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_UART] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_UART]  ),
        .rstn_i              ( HRESETn                  ),

        .uart_tx_o           ( uart_tx                  ),
        .uart_rx_i           ( uart_rx                  ),

        .cfg_data_i          ( s_periph_data_to         ),
        .cfg_addr_i          ( s_periph_addr            ),
        .cfg_valid_i         ( s_periph_valid_uart      ),
        .cfg_rwn_i           ( s_periph_rwn             ),
        .cfg_data_o          ( s_periph_data_from_uart  ),
        .cfg_ready_o         ( s_periph_ready_from_uart ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_UART]      ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_UART]           ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_UART]     ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_UART]             ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_UART]            ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_UART]              ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_UART]         ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_UART]       ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_UART]      ),
        .cfg_rx_datasize_o   (                          ), // FIXME ANTONIO

        .cfg_tx_startaddr_o  ( tx_cfg_startaddr[CH_ID_UART]      ),
        .cfg_tx_size_o       ( tx_cfg_size[CH_ID_UART]           ),
        .cfg_tx_continuous_o ( tx_cfg_continuous[CH_ID_UART]     ),
        .cfg_tx_en_o         ( tx_cfg_en[CH_ID_UART]             ),
        .cfg_tx_clr_o        ( tx_cfg_clr[CH_ID_UART]            ),
        .cfg_tx_en_i         ( tx_ch_en[CH_ID_UART]              ),
        .cfg_tx_pending_i    ( tx_ch_pending[CH_ID_UART]         ),
        .cfg_tx_curr_addr_i  ( tx_ch_curr_addr[CH_ID_UART]       ),
        .cfg_tx_bytes_left_i ( tx_ch_bytes_left[CH_ID_UART]      ),
        .cfg_tx_datasize_o   (                          ), // FIXME ANTONIO

        .data_tx_req_o       ( tx_ch_req[CH_ID_UART]             ),
        .data_tx_gnt_i       ( tx_ch_gnt[CH_ID_UART]             ),
        .data_tx_datasize_o  ( tx_ch_datasize[CH_ID_UART]        ),
        .data_tx_i           ( tx_ch_data[CH_ID_UART]            ),
        .data_tx_valid_i     ( tx_ch_valid[CH_ID_UART]           ),
        .data_tx_ready_o     ( tx_ch_ready[CH_ID_UART]           ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_UART]        ),
        .data_rx_o           ( rx_ch_data[CH_ID_UART]            ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_UART]           ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_UART]           )
    );

    udma_spim_top #(
        .L2_AWIDTH_NOAL      ( L2_AWIDTH_NOAL            ),
        .TRANS_SIZE          ( TRANS_SIZE                )
    ) u_spim0 (
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_SPIM0] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_SPIM0]  ),
        .rstn_i              ( HRESETn                   ),

        .dft_test_mode_i     ( dft_test_mode_i           ),
        .dft_cg_enable_i     ( dft_cg_enable_i           ),

        .spi_eot_o           ( s_spi0_eot                ),

        .spi_event_i         ( s_trigger_events          ),

        .spi_clk_o           ( spi0_clk                  ),
        .spi_csn0_o          ( spi0_csn0                 ),
        .spi_csn1_o          ( spi0_csn1                 ),
        .spi_csn2_o          ( spi0_csn2                 ),
        .spi_csn3_o          ( spi0_csn3                 ),
        .spi_mode_o          ( spi0_mode                 ),
        .spi_sdo0_o          ( spi0_sdo0                 ),
        .spi_sdo1_o          ( spi0_sdo1                 ),
        .spi_sdo2_o          ( spi0_sdo2                 ),
        .spi_sdo3_o          ( spi0_sdo3                 ),
        .spi_sdi0_i          ( spi0_sdi0                 ),
        .spi_sdi1_i          ( spi0_sdi1                 ),
        .spi_sdi2_i          ( spi0_sdi2                 ),
        .spi_sdi3_i          ( spi0_sdi3                 ),

        .cfg_data_i          ( s_periph_data_to          ),
        .cfg_addr_i          ( s_periph_addr             ),
        .cfg_valid_i         ( s_periph_valid_spim0      ),
        .cfg_rwn_i           ( s_periph_rwn              ),
        .cfg_data_o          ( s_periph_data_from_spim0  ),
        .cfg_ready_o         ( s_periph_ready_from_spim0 ),

        .data_tx_req_o       ( tx_ch_req[CH_ID_SPIM0]              ),
        .data_tx_gnt_i       ( tx_ch_gnt[CH_ID_SPIM0]              ),
        .data_tx_datasize_o  ( tx_ch_datasize[CH_ID_SPIM0]         ),
        .data_tx_i           ( tx_ch_data[CH_ID_SPIM0]             ),
        .data_tx_valid_i     ( tx_ch_valid[CH_ID_SPIM0]            ),
        .data_tx_ready_o     ( tx_ch_ready[CH_ID_SPIM0]            ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_SPIM0]         ),
        .data_rx_o           ( rx_ch_data[CH_ID_SPIM0]             ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_SPIM0]            ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_SPIM0]            ),

        .cfg_tx_startaddr_o  ( tx_cfg_startaddr[CH_ID_SPIM0]       ),
        .cfg_tx_size_o       ( tx_cfg_size[CH_ID_SPIM0]            ),
        .cfg_tx_continuous_o ( tx_cfg_continuous[CH_ID_SPIM0]      ),
        .cfg_tx_en_o         ( tx_cfg_en[CH_ID_SPIM0]              ),
        .cfg_tx_clr_o        ( tx_cfg_clr[CH_ID_SPIM0]             ),
        .cfg_tx_en_i         ( tx_ch_en[CH_ID_SPIM0]               ),
        .cfg_tx_pending_i    ( tx_ch_pending[CH_ID_SPIM0]          ),
        .cfg_tx_curr_addr_i  ( tx_ch_curr_addr[CH_ID_SPIM0]        ),
        .cfg_tx_bytes_left_i ( tx_ch_bytes_left[CH_ID_SPIM0]       ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_SPIM0]       ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_SPIM0]            ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_SPIM0]      ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_SPIM0]              ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_SPIM0]             ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_SPIM0]               ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_SPIM0]          ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_SPIM0]        ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_SPIM0]       )
    );

    udma_sdio_top #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     )
    ) u_sdio (
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_UART] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_UART]  ),
        .rstn_i              ( HRESETn                  ),

	.err_o               (              ),
        .eot_o               (              ),
	
        .sdclk_o             ( sdclk_o      ),           
        .sdcmd_o             ( sdcmd_o      ),
        .sdcmd_i             ( sdcmd_i      ),
        .sdcmd_oen_o         ( sdcmd_oen_o  ),
        .sddata_o            ( sddata_o     ),
        .sddata_i            ( sddata_i     ),
        .sddata_oen_o        ( sddata_oen_o ),

        .cfg_data_i          ( s_periph_data_to         ),
        .cfg_addr_i          ( s_periph_addr            ),
        .cfg_valid_i         ( s_periph_valid_sdio      ),
        .cfg_rwn_i           ( s_periph_rwn             ),
        .cfg_data_o          ( s_periph_data_from_sdio  ),
        .cfg_ready_o         ( s_periph_ready_from_sdio ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_SDIO]      ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_SDIO]           ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_SDIO]     ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_SDIO]             ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_SDIO]            ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_SDIO]              ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_SDIO]         ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_SDIO]       ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_SDIO]      ),

        .cfg_tx_startaddr_o  ( tx_cfg_startaddr[CH_ID_SDIO]      ),
        .cfg_tx_size_o       ( tx_cfg_size[CH_ID_SDIO]           ),
        .cfg_tx_continuous_o ( tx_cfg_continuous[CH_ID_SDIO]     ),
        .cfg_tx_en_o         ( tx_cfg_en[CH_ID_SDIO]             ),
        .cfg_tx_clr_o        ( tx_cfg_clr[CH_ID_SDIO]            ),
        .cfg_tx_en_i         ( tx_ch_en[CH_ID_SDIO]              ),
        .cfg_tx_pending_i    ( tx_ch_pending[CH_ID_SDIO]         ),
        .cfg_tx_curr_addr_i  ( tx_ch_curr_addr[CH_ID_SDIO]       ),
        .cfg_tx_bytes_left_i ( tx_ch_bytes_left[CH_ID_SDIO]      ),

        .data_tx_req_o       ( tx_ch_req[CH_ID_SDIO]             ),
        .data_tx_gnt_i       ( tx_ch_gnt[CH_ID_SDIO]             ),
        .data_tx_datasize_o  ( tx_ch_datasize[CH_ID_SDIO]        ),
        .data_tx_i           ( tx_ch_data[CH_ID_SDIO]            ),
        .data_tx_valid_i     ( tx_ch_valid[CH_ID_SDIO]           ),
        .data_tx_ready_o     ( tx_ch_ready[CH_ID_SDIO]           ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_SDIO]        ),
        .data_rx_o           ( rx_ch_data[CH_ID_SDIO]            ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_SDIO]           ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_SDIO]           )
    );

    udma_i2c_top #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     )
    ) u_i2c0 (
        //
        // inputs & outputs
        //
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_I2C0] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_I2C0]  ),
        .rstn_i              ( HRESETn                  ),

        .cfg_data_i          ( s_periph_data_to         ),
        .cfg_addr_i          ( s_periph_addr            ),
        .cfg_valid_i         ( s_periph_valid_i2c0      ),
        .cfg_rwn_i           ( s_periph_rwn             ),
        .cfg_data_o          ( s_periph_data_from_i2c0  ),
        .cfg_ready_o         ( s_periph_ready_from_i2c0 ),

        .cfg_tx_startaddr_o  ( tx_cfg_startaddr[CH_ID_I2C0]      ),
        .cfg_tx_size_o       ( tx_cfg_size[CH_ID_I2C0]           ),
        .cfg_tx_continuous_o ( tx_cfg_continuous[CH_ID_I2C0]     ),
        .cfg_tx_en_o         ( tx_cfg_en[CH_ID_I2C0]             ),
        .cfg_tx_clr_o        ( tx_cfg_clr[CH_ID_I2C0]            ),
        .cfg_tx_en_i         ( tx_ch_en[CH_ID_I2C0]              ),
        .cfg_tx_pending_i    ( tx_ch_pending[CH_ID_I2C0]         ),
        .cfg_tx_curr_addr_i  ( tx_ch_curr_addr[CH_ID_I2C0]       ),
        .cfg_tx_bytes_left_i ( tx_ch_bytes_left[CH_ID_I2C0]      ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_I2C0]      ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_I2C0]           ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_I2C0]     ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_I2C0]             ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_I2C0]            ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_I2C0]              ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_I2C0]         ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_I2C0]       ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_I2C0]      ),

        .data_tx_req_o       ( tx_ch_req[CH_ID_I2C0]             ),
        .data_tx_gnt_i       ( tx_ch_gnt[CH_ID_I2C0]             ),
        .data_tx_datasize_o  ( tx_ch_datasize[CH_ID_I2C0]        ),
        .data_tx_i           ( tx_ch_data[CH_ID_I2C0][7:0]       ),
        .data_tx_valid_i     ( tx_ch_valid[CH_ID_I2C0]           ),
        .data_tx_ready_o     ( tx_ch_ready[CH_ID_I2C0]           ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_I2C0]        ),
        .data_rx_o           ( rx_ch_data[CH_ID_I2C0][7:0]       ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_I2C0]           ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_I2C0]           ),

        .err_o               ( s_i2c0_evt               ),

        .scl_i               ( i2c0_scl_i               ),
        .scl_o               ( i2c0_scl_o               ),
        .scl_oe              ( i2c0_scl_oe              ),
        .sda_i               ( i2c0_sda_i               ),
        .sda_o               ( i2c0_sda_o               ),
        .sda_oe              ( i2c0_sda_oe              ),
        .ext_events_i        ( s_trigger_events         )
    );
    assign rx_ch_data[CH_ID_I2C0][31:8]= 'h0;

    udma_i2c_top #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     )
    ) u_i2c1 (
        //
        // inputs & outputs
        //
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_I2C1] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_I2C1]  ),
        .rstn_i              ( HRESETn                  ),

        .cfg_data_i          ( s_periph_data_to         ),
        .cfg_addr_i          ( s_periph_addr            ),
        .cfg_valid_i         ( s_periph_valid_i2c1      ),
        .cfg_rwn_i           ( s_periph_rwn             ),
        .cfg_data_o          ( s_periph_data_from_i2c1  ),
        .cfg_ready_o         ( s_periph_ready_from_i2c1 ),

        .cfg_tx_startaddr_o  ( tx_cfg_startaddr[CH_ID_I2C1]      ),
        .cfg_tx_size_o       ( tx_cfg_size[CH_ID_I2C1]           ),
        .cfg_tx_continuous_o ( tx_cfg_continuous[CH_ID_I2C1]     ),
        .cfg_tx_en_o         ( tx_cfg_en[CH_ID_I2C1]             ),
        .cfg_tx_clr_o        ( tx_cfg_clr[CH_ID_I2C1]            ),
        .cfg_tx_en_i         ( tx_ch_en[CH_ID_I2C1]              ),
        .cfg_tx_pending_i    ( tx_ch_pending[CH_ID_I2C1]         ),
        .cfg_tx_curr_addr_i  ( tx_ch_curr_addr[CH_ID_I2C1]       ),
        .cfg_tx_bytes_left_i ( tx_ch_bytes_left[CH_ID_I2C1]      ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_I2C1]      ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_I2C1]           ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_I2C1]     ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_I2C1]             ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_I2C1]            ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_I2C1]              ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_I2C1]         ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_I2C1]       ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_I2C1]      ),

        .data_tx_req_o       ( tx_ch_req[CH_ID_I2C1]             ),
        .data_tx_gnt_i       ( tx_ch_gnt[CH_ID_I2C1]             ),
        .data_tx_datasize_o  ( tx_ch_datasize[CH_ID_I2C1]        ),
        .data_tx_i           ( tx_ch_data[CH_ID_I2C1][7:0]       ),
        .data_tx_valid_i     ( tx_ch_valid[CH_ID_I2C1]           ),
        .data_tx_ready_o     ( tx_ch_ready[CH_ID_I2C1]           ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_I2C1]        ),
        .data_rx_o           ( rx_ch_data[CH_ID_I2C1][7:0]       ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_I2C1]           ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_I2C1]           ),

        .err_o               ( s_i2c1_evt               ),

        .scl_i               ( i2c1_scl_i               ),
        .scl_o               ( i2c1_scl_o               ),
        .scl_oe              ( i2c1_scl_oe              ),
        .sda_i               ( i2c1_sda_i               ),
        .sda_o               ( i2c1_sda_o               ),
        .sda_oe              ( i2c1_sda_oe              ),
        .ext_events_i        ( s_trigger_events         )
    );
    assign rx_ch_data[CH_ID_I2C1][31:8]= 'h0;

    udma_i2s_2ch #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     )
    ) u_i2s_udma (
        .sys_clk_i           ( s_clk_periphs_core[PER_ID_I2S] ),
        .periph_clk_i        ( s_clk_periphs_per[PER_ID_I2S]  ),
        .rstn_i                  ( HRESETn                 ),

        .dft_test_mode_i         ( dft_test_mode_i         ),
        .dft_cg_enable_i         ( dft_cg_enable_i         ),

        .ext_sd0_i               ( i2s_sd0_i               ),
        .ext_sd1_i               ( i2s_sd1_i               ),
        .ext_sck_i               ( i2s_sck_i               ),
        .ext_ws_i                ( i2s_ws_i                ),
        .ext_ws_o                (                         ),
        .ext_sck0_o              ( i2s_sck0_o              ),
        .ext_ws0_o               ( i2s_ws0_o               ),
        .ext_mode0_o             ( i2s_mode0_o             ),
        .ext_sck1_o              ( i2s_sck1_o              ),
        .ext_ws1_o               ( i2s_ws1_o               ),
        .ext_mode1_o             ( i2s_mode1_o             ),

        .cfg_data_i              ( s_periph_data_to        ),
        .cfg_addr_i              ( s_periph_addr           ),
        .cfg_valid_i             ( s_periph_valid_i2s      ),
        .cfg_rwn_i               ( s_periph_rwn            ),
        .cfg_data_o              ( s_periph_data_from_i2s  ),
        .cfg_ready_o             ( s_periph_ready_from_i2s ),

        .cfg_rx_ch0_startaddr_o  ( rx_cfg_startaddr[CH_ID_I2S]     ),
        .cfg_rx_ch0_size_o       ( rx_cfg_size[CH_ID_I2S]          ),
        .cfg_rx_ch0_continuous_o ( rx_cfg_continuous[CH_ID_I2S]    ),
        .cfg_rx_ch0_en_o         ( rx_cfg_en[CH_ID_I2S]            ),
        .cfg_rx_ch0_clr_o        ( rx_cfg_clr[CH_ID_I2S]           ),
        .cfg_rx_ch0_en_i         ( rx_ch_en[CH_ID_I2S]             ),
        .cfg_rx_ch0_pending_i    ( rx_ch_pending[CH_ID_I2S]        ),
        .cfg_rx_ch0_curr_addr_i  ( rx_ch_curr_addr[CH_ID_I2S]      ),
        .cfg_rx_ch0_bytes_left_i ( rx_ch_bytes_left[CH_ID_I2S]     ),
        .cfg_rx_ch0_datasize_o   (                         ), //FIXME ANTONIO

        .cfg_rx_ch1_startaddr_o  ( rx_cfg_startaddr[CH_ID_I2S+1]     ),
        .cfg_rx_ch1_size_o       ( rx_cfg_size[CH_ID_I2S+1]          ),
        .cfg_rx_ch1_continuous_o ( rx_cfg_continuous[CH_ID_I2S+1]    ),
        .cfg_rx_ch1_en_o         ( rx_cfg_en[CH_ID_I2S+1]            ),
        .cfg_rx_ch1_clr_o        ( rx_cfg_clr[CH_ID_I2S+1]           ),
        .cfg_rx_ch1_en_i         ( rx_ch_en[CH_ID_I2S+1]             ),
        .cfg_rx_ch1_pending_i    ( rx_ch_pending[CH_ID_I2S+1]        ),
        .cfg_rx_ch1_curr_addr_i  ( rx_ch_curr_addr[CH_ID_I2S+1]      ),
        .cfg_rx_ch1_bytes_left_i ( rx_ch_bytes_left[CH_ID_I2S+1]     ),
        .cfg_rx_ch1_datasize_o   (                         ), //FIXME ANTONIO

        .data_rx_ch0_datasize_o  ( rx_ch_datasize[CH_ID_I2S]       ),
        .data_rx_ch0_o           ( rx_ch_data[CH_ID_I2S]           ),
        .data_rx_ch0_valid_o     ( rx_ch_valid[CH_ID_I2S]          ),
        .data_rx_ch0_ready_i     ( rx_ch_ready[CH_ID_I2S]          ),

        .data_rx_ch1_datasize_o  ( rx_ch_datasize[CH_ID_I2S+1]       ),
        .data_rx_ch1_o           ( rx_ch_data[CH_ID_I2S+1]           ),
        .data_rx_ch1_valid_o     ( rx_ch_valid[CH_ID_I2S+1]          ),
        .data_rx_ch1_ready_i     ( rx_ch_ready[CH_ID_I2S+1]          )
    );

    camera_if #(
        .L2_AWIDTH_NOAL ( L2_AWIDTH_NOAL ),
        .TRANS_SIZE     ( TRANS_SIZE     ),
        .DATA_WIDTH     ( 8              )
    ) u_camera_if (
        .clk_i(s_clk_periphs_core[PER_ID_CAM]),
        .rstn_i              ( HRESETn                 ),

        .dft_test_mode_i     ( dft_test_mode_i         ),
        .dft_cg_enable_i     ( dft_cg_enable_i         ),

        .cfg_data_i          ( s_periph_data_to        ),
        .cfg_addr_i          ( s_periph_addr           ),
        .cfg_valid_i         ( s_periph_valid_cam      ),
        .cfg_rwn_i           ( s_periph_rwn            ),
        .cfg_data_o          ( s_periph_data_from_cam  ),
        .cfg_ready_o         ( s_periph_ready_from_cam ),

        .cfg_rx_startaddr_o  ( rx_cfg_startaddr[CH_ID_CAM]     ),
        .cfg_rx_size_o       ( rx_cfg_size[CH_ID_CAM]          ),
        .cfg_rx_continuous_o ( rx_cfg_continuous[CH_ID_CAM]    ),
        .cfg_rx_en_o         ( rx_cfg_en[CH_ID_CAM]            ),
        .cfg_rx_filter_o     ( rx_cfg_filter[CH_ID_CAM]        ),
        .cfg_rx_clr_o        ( rx_cfg_clr[CH_ID_CAM]           ),
        .cfg_rx_en_i         ( rx_ch_en[CH_ID_CAM]             ),
        .cfg_rx_pending_i    ( rx_ch_pending[CH_ID_CAM]        ),
        .cfg_rx_curr_addr_i  ( rx_ch_curr_addr[CH_ID_CAM]      ),
        .cfg_rx_bytes_left_i ( rx_ch_bytes_left[CH_ID_CAM]     ),

        .data_rx_datasize_o  ( rx_ch_datasize[CH_ID_CAM]       ),
        .data_rx_data_o      ( rx_ch_data[CH_ID_CAM][15:0]     ),
        .data_rx_valid_o     ( rx_ch_valid[CH_ID_CAM]          ),
        .data_rx_ready_i     ( rx_ch_ready[CH_ID_CAM]          ),

        .cam_clk_i           ( cam_clk_i               ),
        .cam_data_i          ( cam_data_i              ),
        .cam_hsync_i         ( cam_hsync_i             ),
        .cam_vsync_i         ( cam_vsync_i             )
    );
    assign rx_ch_data[CH_ID_CAM][31:16]='h0;


endmodule
