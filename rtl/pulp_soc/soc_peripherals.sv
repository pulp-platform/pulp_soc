// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "soc_mem_map.svh"
`include "apb/typedef.svh"
`include "apb/assign.svh"
`include "axi/typedef.svh"
`include "axi/assign.svh"
`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"

module soc_peripherals
    import pkg_soc_interconnect::addr_map_rule_t;
#(
    parameter MEM_ADDR_WIDTH = 13,
    parameter APB_ADDR_WIDTH = 32,
    parameter APB_DATA_WIDTH = 32,
    parameter NB_CORES       = 4,
    parameter NB_CLUSTERS    = 0,
    parameter EVNT_WIDTH     = 8,
    parameter SIM_STDOUT     = 1,
    localparam NGPIO         = gpio_reg_pkg::GPIOCount // Have a look at the
                                // README in the GPIO repo in order to change
                                // the number of GPIOs.
) (
    input  logic                       clk_i,
    input  logic                       rst_ni,
    input  logic                       periph_clk_i,
    input  logic                       periph_rstn_i,
    //check the reset
    input  logic                       slow_clk_i,
    input  logic                       slow_rstn_i,

    input  logic                       sel_pll_clk_i,
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
    AXI_LITE.Slave                     axi_lite_slave,
    APB.Master                         apb_intrpt_ctrl_master,
    APB.Master                         apb_hwpe_master,
    APB.Master                         apb_debug_master,
    APB.Master                         apb_chip_ctrl_master,

    // FABRIC CONTROLLER MASTER REFILL PORT
    XBAR_TCDM_BUS.Master               l2_rx_master,
    XBAR_TCDM_BUS.Master               l2_tx_master,

    input  logic                       dma_pe_evt_i,
    input  logic                       dma_pe_irq_i,
    input  logic                       pf_evt_i,
    input  logic [1:0]                 fc_hwpe_events_i,
    output logic [31:0]                fc_interrupts_o,

    output logic [3:0]                 timer_ch0_o,
    output logic [3:0]                 timer_ch1_o,
    output logic [3:0]                 timer_ch2_o,
    output logic [3:0]                 timer_ch3_o,

    // uDMA Connections
    // UART
    output  uart_pkg::uart_to_pad_t [udma_cfg_pkg::N_UART-1:0]  uart_to_pad_o,
    input   uart_pkg::pad_to_uart_t [udma_cfg_pkg::N_UART-1:0]  pad_to_uart_i,
    // I2C
    output  i2c_pkg::i2c_to_pad_t   [udma_cfg_pkg::N_I2C-1:0]  i2c_to_pad_o,
    input   i2c_pkg::pad_to_i2c_t   [udma_cfg_pkg::N_I2C-1:0]  pad_to_i2c_i,
    // SDIO
    output  sdio_pkg::sdio_to_pad_t [udma_cfg_pkg::N_SDIO-1:0]  sdio_to_pad_o,
    input   sdio_pkg::pad_to_sdio_t [udma_cfg_pkg::N_SDIO-1:0]  pad_to_sdio_i,
    // I2S
    output  i2s_pkg::i2s_to_pad_t   [udma_cfg_pkg::N_I2S-1:0]    i2s_to_pad_o,
    input   i2s_pkg::pad_to_i2s_t   [udma_cfg_pkg::N_I2S-1:0]    pad_to_i2s_i,
    // QSPI
    output  qspi_pkg::qspi_to_pad_t [udma_cfg_pkg::N_QSPIM-1:0]  qspi_to_pad_o,
    input   qspi_pkg::pad_to_qspi_t [udma_cfg_pkg::N_QSPIM-1:0]  pad_to_qspi_i,
    // CPI
    input   cpi_pkg::pad_to_cpi_t   [udma_cfg_pkg::N_CPI-1:0] pad_to_cpi_i,
    // HYPER
    output hyper_pkg::hyper_to_pad_t [udma_cfg_pkg::N_HYPER-1:0] hyper_to_pad_o,
    input  hyper_pkg::pad_to_hyper_t [udma_cfg_pkg::N_HYPER-1:0] pad_to_hyper_i,
    // GPIO
    input logic [NGPIO-1:0]               gpio_i,
    output logic [NGPIO-1:0]              gpio_o,
    output logic [NGPIO-1:0]              gpio_tx_en_o,


    output logic [EVNT_WIDTH-1:0]      cl_event_data_o,
    output logic                       cl_event_valid_o,
    input  logic                       cl_event_ready_i,
    output logic [EVNT_WIDTH-1:0]      fc_event_data_o,
    output logic                       fc_event_valid_o,
    input  logic                       fc_event_ready_i,

    output logic                       cluster_rstn_req_o
);


    //---------- Wiring Signals and internal parameters ----------
    localparam UDMA_EVENTS = 16*8;

    logic [NGPIO-1:0] s_gpio_sync;
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

    logic [31:0][3:0] s_udma_events;
    logic [159:0] s_events;

    logic s_timer_in_lo_event;
    logic s_timer_in_hi_event;

    //-------------------- Events Assignments --------------------

    assign s_events[UDMA_EVENTS-1:0]  = s_udma_events;
    assign s_events[135]              = s_adv_timer_events[0];
    assign s_events[136]              = s_adv_timer_events[1];
    assign s_events[137]              = s_adv_timer_events[2];
    assign s_events[138]              = s_adv_timer_events[3];
    assign s_events[139]              = s_gpio_event;
    assign s_events[140]              = fc_hwpe_events_i[0];
    assign s_events[141]              = fc_hwpe_events_i[1];
    assign s_events[159:142]          = '0;

    //------------------ Interrupt Assignments ------------------
    assign fc_interrupts_o[7:0] = 8'h0; //RESERVED for sw events
    assign fc_interrupts_o[8]   = dma_pe_evt_i;
    assign fc_interrupts_o[9]   = dma_pe_irq_i;
    assign fc_interrupts_o[10]  = s_timer_lo_event;
    assign fc_interrupts_o[11]  = s_timer_hi_event;
    assign fc_interrupts_o[12]  = pf_evt_i;
    assign fc_interrupts_o[13]  = 1'b0;
    assign fc_interrupts_o[14]  = s_ref_rise_event | s_ref_fall_event;
    assign fc_interrupts_o[15]  = s_gpio_event;
    assign fc_interrupts_o[16]  = 1'b0;
    assign fc_interrupts_o[17]  = s_adv_timer_events[0];
    assign fc_interrupts_o[18]  = s_adv_timer_events[1];
    assign fc_interrupts_o[19]  = s_adv_timer_events[2];
    assign fc_interrupts_o[20]  = s_adv_timer_events[3];
    assign fc_interrupts_o[21]  = 1'b0;
    assign fc_interrupts_o[22]  = 1'b0;
    assign fc_interrupts_o[23]  = 1'b0;
    assign fc_interrupts_o[24]  = 1'b0;
    assign fc_interrupts_o[25]  = 1'b0;
    assign fc_interrupts_o[26]  = 1'b0; // RESERVED for soc event FIFO
                                    // (many events get implicitely muxed into
                                    // this interrupt. A user that gets such an
                                    // interrupt has to check the event unit's
                                    // registers to see what happened)
    assign fc_interrupts_o[27]  = 1'b0;
    assign fc_interrupts_o[28]  = 1'b0;
    assign fc_interrupts_o[29]  = s_fc_err_events;
    assign fc_interrupts_o[30]  = s_fc_hp_events[0];
    assign fc_interrupts_o[31]  = s_fc_hp_events[1];

    // Synchronizer to generate synchronous ref_clk rise an fall events (used as
    // interrupt 14)
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

    // Typedefs
    typedef logic [31:0] addr_t;
    typedef logic [31:0] data_t;
    typedef logic [3:0] strb_t;
    `APB_TYPEDEF_REQ_T(apb_req_t, addr_t, data_t, strb_t)
    `APB_TYPEDEF_RESP_T(apb_resp_t, data_t)
    `AXI_LITE_TYPEDEF_ALL(axi_lite, addr_t, data_t, strb_t)
    `REG_BUS_TYPEDEF_ALL(regbus, addr_t, data_t, strb_t);

    // Convert AXI lite interface to structs
    axi_lite_req_t s_axi_lite_master_req;
    axi_lite_resp_t s_axi_lite_master_resp;
    `AXI_LITE_ASSIGN_TO_REQ(s_axi_lite_master_req, axi_lite_slave)
    `AXI_LITE_ASSIGN_FROM_RESP(axi_lite_slave, s_axi_lite_master_resp)

    // APB Slaves
    localparam NumAPBSlaves = 12;
    addr_map_rule_t [NumAPBSlaves-1:0] apb_addr_ranges;
    apb_req_t [NumAPBSlaves-1:0] s_apb_slaves_req;
    apb_resp_t [NumAPBSlaves-1:0] s_apb_slaves_resp;

// Helper Macro to quickly create and attach new APB slave interfaces.
// Adding a new slave: Increment value of NumAPBSlaves, call this macro
// where port_idx is an incrementing port index number (just increase the
// previously used by one), slave_name must be valid SV identifier, start/end
// address define the start and end address of the associated address space that
// will be routed to the new slave. The macro will generate a new APB interface
// instance with the name s_<slave_name>_slave that should be hooked up to the
// APB slave module.
`define SOC_PERIPHERALS_CREATE_SLAVE(port_idx, slave_name, start_address, end_address) \
  APB #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) s_``slave_name``_slave(); \
  assign apb_addr_ranges[port_idx] = '{ idx: port_idx, start_addr: start_address, end_addr: end_address}; \
  `APB_ASSIGN_FROM_REQ(s_``slave_name``_slave, s_apb_slaves_req[port_idx]) \
  `APB_ASSIGN_TO_RESP(s_apb_slaves_resp[port_idx], s_``slave_name``_slave)

    `SOC_PERIPHERALS_CREATE_SLAVE(0,  gpio,           `SOC_MEM_MAP_GPIO_START_ADDR,           `SOC_MEM_MAP_GPIO_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(1,  udma,           `SOC_MEM_MAP_UDMA_START_ADDR,           `SOC_MEM_MAP_UDMA_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(2,  soc_ctrl,       `SOC_MEM_MAP_SOC_CTRL_START_ADDR,       `SOC_MEM_MAP_SOC_CTRL_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(3,  adv_timer,      `SOC_MEM_MAP_ADV_TIMER_START_ADDR,      `SOC_MEM_MAP_ADV_TIMER_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(4,  soc_event_gen,  `SOC_MEM_MAP_SOC_EVENT_GEN_START_ADDR,  `SOC_MEM_MAP_SOC_EVENT_GEN_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(5,  interrupt_ctrl, `SOC_MEM_MAP_INTERRUPT_CTRL_START_ADDR, `SOC_MEM_MAP_INTERRUPT_CTRL_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(6,  apb_timer,      `SOC_MEM_MAP_APB_TIMER_START_ADDR,      `SOC_MEM_MAP_APB_TIMER_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(7,  hwpe,           `SOC_MEM_MAP_HWPE_START_ADDR,           `SOC_MEM_MAP_HWPE_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(8,  virtual_stdout, `SOC_MEM_MAP_VIRTUAL_STDOUT_START_ADDR, `SOC_MEM_MAP_VIRTUAL_STDOUT_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(9,  debug,          `SOC_MEM_MAP_DEBUG_START_ADDR,          `SOC_MEM_MAP_DEBUG_END_ADDR)
    `SOC_PERIPHERALS_CREATE_SLAVE(10, chip_ctrl,      `SOC_MEM_MAP_CHIP_CTRL_START_ADDR,      `SOC_MEM_MAP_CHIP_CTRL_END_ADDR)


 // AXI Lite to APB converter with integrated APB Crossbar
    axi_lite_to_apb #(
      .NoApbSlaves      ( NumAPBSlaves    ),
      .NoRules          ( NumAPBSlaves    ),
      .AddrWidth        ( 32              ),
      .DataWidth        ( 32              ),
      .PipelineRequest  ( 1'b1            ),
      .PipelineResponse ( 1'b1            ),
      .axi_lite_req_t   ( axi_lite_req_t  ),
      .axi_lite_resp_t  ( axi_lite_resp_t ),
      .apb_req_t        ( apb_req_t       ),
      .apb_resp_t       ( apb_resp_t      ),
      .rule_t           ( addr_map_rule_t )
    ) i_axi_lite_to_apb (
      .clk_i,
      .rst_ni,
      .axi_lite_req_i  ( s_axi_lite_master_req  ),
      .axi_lite_resp_o ( s_axi_lite_master_resp ),
      .apb_req_o       ( s_apb_slaves_req       ),
      .apb_resp_i      ( s_apb_slaves_resp      ),
      .addr_map_i      ( apb_addr_ranges        )
    );

    // Assign internal slave signals to external APB ports
    `APB_ASSIGN(apb_intrpt_ctrl_master ,s_interrupt_ctrl_slave)
    `APB_ASSIGN(apb_hwpe_master, s_hwpe_slave)
    `APB_ASSIGN(apb_debug_master, s_debug_slave)
    `APB_ASSIGN(apb_chip_ctrl_master, s_chip_ctrl_slave)

`ifdef SYNTHESIS
    if (SIM_STDOUT)
        $fatal(1, "SIM_STDOUT is not synthesizable. Set SIM_STDOUT=0");
`endif

 if (SIM_STDOUT) begin
     logic pready_q;

     assign s_virtual_stdout_slave.pready  = pready_q;
     assign s_virtual_stdout_slave.pslverr = 1'b0;

     tb_fs_handler #(
          .ADDR_WIDTH ( 32          ),
          .DATA_WIDTH ( 32          ),
          .NB_CORES   ( NB_CORES + 1), // cluster cores + fc core
          .OPEN_FILES ( `ifdef LOG_SIM_STDOUT 1 `else 0 `endif )
     ) i_fs_handler (
          .clk   ( clk_i                                                  ),
          .rst_n ( rst_ni                                                 ),
          .CSN   ( ~(s_virtual_stdout_slave.psel & s_virtual_stdout_slave.penable & pready_q) ),
          .WEN   ( ~s_virtual_stdout_slave.pwrite                                   ),
          .ADDR  ( s_virtual_stdout_slave.paddr                                     ),
          .WDATA ( s_virtual_stdout_slave.pwdata                                    ),
          .BE    ( 4'hf                                                   ),
          .RDATA ( s_virtual_stdout_slave.prdata                                    )
     );

     always_ff @(posedge clk_i or negedge rst_ni) begin
        if(~rst_ni) begin
           pready_q <= 0;
        end else begin
           pready_q <= (s_virtual_stdout_slave.psel & s_virtual_stdout_slave.penable);
        end
     end
 end else begin
     assign s_virtual_stdout_slave.pready  = 'h1;
     assign s_virtual_stdout_slave.pslverr = 1'b0;
     assign s_virtual_stdout_slave.prdata  = 'h0;
 end

    logic sys_rst_ni;
    logic sys_clk_i;

    pulp_io #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) i_pulp_io (
        .sys_rst_ni      (rst_ni               ),
        .sys_clk_i       (clk_i                ),
        .periph_clk_i    (periph_clk_i         ),

        .L2_ro_wen_o     (l2_tx_master.wen     ),
        .L2_ro_req_o     (l2_tx_master.req     ),
        .L2_ro_gnt_i     (l2_tx_master.gnt     ),
        .L2_ro_addr_o    (l2_tx_master.add     ),
        .L2_ro_be_o      (l2_tx_master.be      ),
        .L2_ro_wdata_o   (l2_tx_master.wdata   ),
        .L2_ro_rvalid_i  (l2_tx_master.r_valid ),
        .L2_ro_rdata_i   (l2_tx_master.r_rdata ),

        .L2_wo_wen_o     (l2_rx_master.wen     ),
        .L2_wo_req_o     (l2_rx_master.req     ),
        .L2_wo_gnt_i     (l2_rx_master.gnt     ),
        .L2_wo_addr_o    (l2_rx_master.add     ),
        .L2_wo_wdata_o   (l2_rx_master.wdata   ),
        .L2_wo_be_o      (l2_rx_master.be      ),
        .L2_wo_rvalid_i  (l2_rx_master.r_valid ),
        .L2_wo_rdata_i   (l2_rx_master.r_rdata ),

        .dft_test_mode_i (dft_test_mode_i      ),
        .dft_cg_enable_i (dft_cg_enable_i      ),

        .udma_apb_paddr  (s_udma_slave.paddr   ),
        .udma_apb_pwdata (s_udma_slave.pwdata  ),
        .udma_apb_pwrite (s_udma_slave.pwrite  ),
        .udma_apb_psel   (s_udma_slave.psel    ),
        .udma_apb_penable(s_udma_slave.penable ),
        .udma_apb_prdata (s_udma_slave.prdata  ),
        .udma_apb_pready (s_udma_slave.pready  ),
        .udma_apb_pslverr(s_udma_slave.pslverr ),

        .gpio_apb_paddr  (s_gpio_slave.paddr     ),
        .gpio_apb_pwdata (s_gpio_slave.pwdata    ),
        .gpio_apb_pwrite (s_gpio_slave.pwrite    ),
        .gpio_apb_psel   (s_gpio_slave.psel      ),
        .gpio_apb_penable(s_gpio_slave.penable   ),
        .gpio_apb_prdata (s_gpio_slave.prdata    ),
        .gpio_apb_pready (s_gpio_slave.pready    ),
        .gpio_apb_pslverr(s_gpio_slave.pslverr   ),

        .events_o        (s_udma_events       ),
        .event_valid_i   (s_pr_event_valid    ),
        .event_data_i    (s_pr_event_data     ),
        .event_ready_o   (s_pr_event_ready    ),

        .uart_to_pad      (uart_to_pad_o  ),
        .pad_to_uart      (pad_to_uart_i  ),
        .i2c_to_pad       (i2c_to_pad_o   ),
        .pad_to_i2c       (pad_to_i2c_i   ),
        .sdio_to_pad      (sdio_to_pad_o  ),
        .pad_to_sdio      (pad_to_sdio_i  ),
        .i2s_to_pad       (i2s_to_pad_o   ),
        .pad_to_i2s       (pad_to_i2s_i   ),
        .qspi_to_pad      (qspi_to_pad_o  ),
        .pad_to_qspi      (pad_to_qspi_i  ),
        .pad_to_cpi       (pad_to_cpi_i   ),
        .hyper_to_pad     (hyper_to_pad_o ),
        .pad_to_hyper     (pad_to_hyper_i ),
        .gpio_in          (gpio_i         ),
        .gpio_out         (gpio_o         ),
        .gpio_tx_en_o     (gpio_tx_en_o   ),
        .gpio_in_sync_o   (s_gpio_sync    ),
        .gpio_interrupt_o (s_gpio_event   )
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
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .NBIT_PADCFG    ( 3              ) // APB SoC control is no longer
                                           // responsible for pad config. This is handled
                                           // by the padmux IP genreated by
                                           // Padrick. The value here is thus irrelevant.
    ) i_apb_soc_ctrl (
        .HCLK                ( clk_i                  ),
        .HRESETn             ( rst_ni                 ),

        .PADDR               ( s_soc_ctrl_slave.paddr   ),
        .PWDATA              ( s_soc_ctrl_slave.pwdata  ),
        .PWRITE              ( s_soc_ctrl_slave.pwrite  ),
        .PSEL                ( s_soc_ctrl_slave.psel    ),
        .PENABLE             ( s_soc_ctrl_slave.penable ),
        .PRDATA              ( s_soc_ctrl_slave.prdata  ),
        .PREADY              ( s_soc_ctrl_slave.pready  ),
        .PSLVERR             ( s_soc_ctrl_slave.pslverr ),

        .sel_pll_clk_i       ( sel_pll_clk_i          ),
        .boot_l2_i           ( boot_l2_i              ),
        .bootsel_i           ( bootsel_i              ),
        .fc_fetch_en_valid_i ( fc_fetch_en_valid_i    ),
        .fc_fetch_en_i       ( fc_fetch_en_i          ),

        .fc_bootaddr_o       ( fc_bootaddr_o          ),
        .fc_fetchen_o        ( fc_fetchen_o           ),

        .soc_jtag_reg_i      ( soc_jtag_reg_i         ),
        .soc_jtag_reg_o      ( soc_jtag_reg_o         ),

        .pad_mux             (                        ), // Not used. Padmuxing is handled externally.
        .pad_cfg             (                        ), // Not used. Padmuxing is handled externally.
        .cluster_pow_o       ( cluster_pow_o          ),
        .sel_hyper_axi_o     ( s_sel_hyper_axi        ),

        .cluster_byp_o            (                        ), // Not used anymore
        .cluster_boot_addr_o      (                        ), // Not used anymore
        .cluster_fetch_enable_o   (                        ), // Not used anymore
        .cluster_rstn_o           ( cluster_rstn_req_o     ),
        .cluster_irq_o            (                        )  // Not used anymore
    );

    apb_adv_timer #(
        .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
        .EXTSIG_NUM     ( NGPIO      )
    ) i_apb_adv_timer (
        .HCLK            ( clk_i                   ),
        .HRESETn         ( rst_ni                  ),

        .dft_cg_enable_i ( dft_cg_enable_i         ),

        .PADDR           ( s_adv_timer_slave.paddr   ),
        .PWDATA          ( s_adv_timer_slave.pwdata  ),
        .PWRITE          ( s_adv_timer_slave.pwrite  ),
        .PSEL            ( s_adv_timer_slave.psel    ),
        .PENABLE         ( s_adv_timer_slave.penable ),
        .PRDATA          ( s_adv_timer_slave.prdata  ),
        .PREADY          ( s_adv_timer_slave.pready  ),
        .PSLVERR         ( s_adv_timer_slave.pslverr ),

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

        .PADDR            ( s_soc_event_gen_slave.paddr   ),
        .PWDATA           ( s_soc_event_gen_slave.pwdata  ),
        .PWRITE           ( s_soc_event_gen_slave.pwrite  ),
        .PSEL             ( s_soc_event_gen_slave.psel    ),
        .PENABLE          ( s_soc_event_gen_slave.penable ),
        .PRDATA           ( s_soc_event_gen_slave.prdata  ),
        .PREADY           ( s_soc_event_gen_slave.pready  ),
        .PSLVERR          ( s_soc_event_gen_slave.pslverr ),

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
        .PADDR      ( s_apb_timer_slave.paddr   ),
        .PWDATA     ( s_apb_timer_slave.pwdata  ),
        .PWRITE     ( s_apb_timer_slave.pwrite  ),
        .PSEL       ( s_apb_timer_slave.psel    ),
        .PENABLE    ( s_apb_timer_slave.penable ),
        .PRDATA     ( s_apb_timer_slave.prdata  ),
        .PREADY     ( s_apb_timer_slave.pready  ),
        .PSLVERR    ( s_apb_timer_slave.pslverr ),
        .ref_clk_i  ( slow_clk_i              ),
        .event_lo_i ( s_timer_in_lo_event     ),
        .event_hi_i ( s_timer_in_hi_event     ),
        .irq_lo_o   ( s_timer_lo_event        ),
        .irq_hi_o   ( s_timer_hi_event        ),
        .busy_o     (                         )
    );

endmodule
