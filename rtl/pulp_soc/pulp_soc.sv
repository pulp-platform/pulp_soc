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
`include "soc_mem_map.svh"
`include "axi/typedef.svh"
`include "axi/assign.svh"

module pulp_soc import dm::*; #(
    parameter  CORE_TYPE          = 0, // 0 for CV32E40P with XPULP Extensions, 1 for IBEX RV32IMC (formerly ZERORISCY), 2 for IBEX RV32EC (formerly MICRORISCY)
    parameter  USE_XPULP          = 1, // Enable XPULP extensions on CV32E40P.
                                       // Has no effect if an IBEX core variant
                                       // is use.
    parameter  USE_FPU            = 1, // Mutually exclusive with the use of IBEX. I.e.
                                       // if an IBEX core variant is used, this paraeter
                                       // is ignored.
    parameter  USE_ZFINX          = 1, // Standard RISC-V extension: Reuses the integer
                                       // regfile for FPU usage instead of requiring a
                                       // dedicated FPU regfile. Requires correct
                                       // compiler settings for software to work!
    parameter  USE_HWPE           = 1,
    parameter  SIM_STDOUT         = 1, // Enable the virtual stdout interface
                                       // for communication with simulated
                                       // testbenches. This parameter must be
                                       // disabled during any form of physical
                                       // implementation.
    parameter AXI_ADDR_WIDTH      = 32,
    parameter AXI_DATA_IN_WIDTH   = 64,
    parameter AXI_DATA_OUT_WIDTH  = 32,
    parameter AXI_ID_IN_WIDTH     = 6,
    localparam AXI_ID_OUT_WIDTH   = pkg_soc_interconnect::AXI_ID_OUT_WIDTH,
    parameter AXI_USER_WIDTH      = 6,
    parameter AXI_STRB_WIDTH_IN   = AXI_DATA_IN_WIDTH/8,
    parameter AXI_STRB_WIDTH_OUT  = AXI_DATA_OUT_WIDTH/8,
    parameter CDC_FIFOS_LOG_DEPTH = 3,
    parameter EVNT_WIDTH          = 8,
    parameter NB_CORES            = 8,
    parameter NB_HWPE_PORTS       = 4,
    localparam SOC_VERSION        = 5, // A increasing number that software can
                                       // read from soc_ctrl_reg to determine which
                                       // version of pulp_soc it running on. Increase
                                       // this number by one whenever something
                                       // significant changed in pulp_soc or
                                       // when you freeze a tapeout.
    localparam NGPIO              = gpio_reg_pkg::GPIOCount,
    localparam C2S_AW_WIDTH       = AXI_ID_IN_WIDTH+AXI_ADDR_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::len_t)+$bits(axi_pkg::size_t)+$bits(axi_pkg::burst_t)+$bits(axi_pkg::cache_t)+$bits(axi_pkg::prot_t)+$bits(axi_pkg::qos_t)+$bits(axi_pkg::region_t)+$bits(axi_pkg::atop_t)+1,
    localparam C2S_W_WIDTH        = AXI_USER_WIDTH+AXI_STRB_WIDTH_IN+AXI_DATA_IN_WIDTH+1,
    localparam C2S_R_WIDTH        = AXI_ID_IN_WIDTH+AXI_DATA_IN_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::resp_t)+1,
    localparam C2S_B_WIDTH        = AXI_USER_WIDTH+AXI_ID_IN_WIDTH+$bits(axi_pkg::resp_t),
    localparam C2S_AR_WIDTH       = AXI_ID_IN_WIDTH+AXI_ADDR_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::len_t)+$bits(axi_pkg::size_t)+$bits(axi_pkg::burst_t)+$bits(axi_pkg::cache_t)+$bits(axi_pkg::prot_t)+$bits(axi_pkg::qos_t)+$bits(axi_pkg::region_t)+1,
    localparam S2C_AW_WIDTH       = AXI_ID_OUT_WIDTH+AXI_ADDR_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::len_t)+$bits(axi_pkg::size_t)+$bits(axi_pkg::burst_t)+$bits(axi_pkg::cache_t)+$bits(axi_pkg::prot_t)+$bits(axi_pkg::qos_t)+$bits(axi_pkg::region_t)+$bits(axi_pkg::atop_t)+1,
    localparam S2C_W_WIDTH        = AXI_USER_WIDTH+AXI_STRB_WIDTH_OUT+AXI_DATA_OUT_WIDTH+1,
    localparam S2C_R_WIDTH        = AXI_ID_OUT_WIDTH+AXI_DATA_OUT_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::resp_t)+1,
    localparam S2C_B_WIDTH        = AXI_USER_WIDTH+AXI_ID_OUT_WIDTH+$bits(axi_pkg::resp_t),
    localparam S2C_AR_WIDTH       = AXI_ID_OUT_WIDTH+AXI_ADDR_WIDTH+AXI_USER_WIDTH+$bits(axi_pkg::len_t)+$bits(axi_pkg::size_t)+$bits(axi_pkg::burst_t)+$bits(axi_pkg::cache_t)+$bits(axi_pkg::prot_t)+$bits(axi_pkg::qos_t)+$bits(axi_pkg::region_t)+1
) (
    input logic                                                 slow_clk_i,
    /// Async reset with deassertion synced to slow_clk rising edge. Do not just
    /// reset domains individually! This needs clock domain/reset domain crossing
    /// safe sequencing!!!
    input logic                                                 slow_clk_rstn_synced_i,
    input logic                                                 soc_clk_i,
    /// Async reset with deassertion synced to soc_clk rising edge. Do not just
    /// reset domains individually! This needs clock domain/reset domain crossing
    /// safe sequencing!!!
    input logic                                                 soc_rstn_synced_i,
    input logic                                                 per_clk_i,
    /// Async reset with deassertion synced to per_clk rising edge. Do not just
    /// reset domains individually! This needs clock domain/reset domain crossing
    /// safe sequencing!!!
    input logic                                                 per_rstn_synced_i,

    /// If you want to individually reset either the cluster or the SoC clock
    /// domain, a toplevel reset controller is REQUIRED. The controller should
    /// first gate both, the SoC and the cluster clock domain, reset the desired
    /// one of the two domains while ALSO asserting the soc_cluster_cdc_rst_ni
    /// signal and finally ungate both clock domains.
    input logic                                                 soc_cluster_cdc_rst_ni,
    /// DFT signals, if you need DFT double check each internal connection. Some
    /// connections are likely to be missing
    input logic                                                 dft_test_mode_i,
    input logic                                                 dft_cg_enable_i,

    /// Boot mode selection. The boot firmare in the bootrom reads the bootsel
    /// bits via the soc_ctrl register and initiates the desired boot procedure.
    /// The meaining of each bootsel value thus depends on the boot firmware used.
    input logic [1:0]                                           bootsel_i,

    /// Enable/Disable the instruction fetcher of the fabric controller. After
    /// reset, fetching is by default disabled. It can be enabled with these two
    /// signals or by writing to soc_ctrl register e.g. through the JTAG debug unit.
    input logic                                                 fc_fetch_en_valid_i,
    input logic                                                 fc_fetch_en_i,

    /// Active-low cluster reset request from soc_ctrl register. This signal is
    /// supposed to reset the external cluster (if present). MAKE SURE TO PROPERLY
    /// HANDLY RESET DOMAIN CROSSINGS AND CDC RESETTING. YOU CANNOT JUST RESET ONE
    /// SIDE OF A CDC (see header of
    /// https://github.com/pulp-platform/common_cells/blob/master/src/cdc_reset_ctrlr.sv
    /// for more information )!!!
    output logic                                                cluster_rstn_req_o,

    /// Asnychronous CDC crossing signals to/from external cluster (if present)
    //  AXI4 SLAVE
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_slave_aw_wptr_i,
    input logic [2**CDC_FIFOS_LOG_DEPTH-1:0][C2S_AW_WIDTH-1:0]  async_data_slave_aw_data_i,
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_slave_aw_rptr_o,

    // READ ADDRESS CHANNEL
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_slave_ar_wptr_i,
    input logic [2**CDC_FIFOS_LOG_DEPTH-1:0][C2S_AR_WIDTH-1:0]  async_data_slave_ar_data_i,
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_slave_ar_rptr_o,

    // WRITE DATA CHANNEL
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_slave_w_wptr_i,
    input logic [2**CDC_FIFOS_LOG_DEPTH-1:0][C2S_W_WIDTH-1:0]   async_data_slave_w_data_i,
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_slave_w_rptr_o,

    // READ DATA CHANNEL
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_slave_r_wptr_o,
    output logic [2**CDC_FIFOS_LOG_DEPTH-1:0][C2S_R_WIDTH-1:0]  async_data_slave_r_data_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_slave_r_rptr_i,

    // WRITE RESPONSE CHANNEL
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_slave_b_wptr_o,
    output logic [2**CDC_FIFOS_LOG_DEPTH-1:0][C2S_B_WIDTH-1:0]  async_data_slave_b_data_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_slave_b_rptr_i,

    // AXI4 MASTER
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_master_aw_wptr_o,
    output logic [2**CDC_FIFOS_LOG_DEPTH-1:0][S2C_AW_WIDTH-1:0] async_data_master_aw_data_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_master_aw_rptr_i,

    // READ ADDRESS CHANNEL
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_master_ar_wptr_o,
    output logic [2**CDC_FIFOS_LOG_DEPTH-1:0][S2C_AR_WIDTH-1:0] async_data_master_ar_data_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_master_ar_rptr_i,

    // WRITE DATA CHANNEL
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_master_w_wptr_o,
    output logic [2**CDC_FIFOS_LOG_DEPTH-1:0][S2C_W_WIDTH-1:0]  async_data_master_w_data_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_master_w_rptr_i,

    // READ DATA CHANNEL
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_master_r_wptr_i,
    input logic [2**CDC_FIFOS_LOG_DEPTH-1:0][S2C_R_WIDTH-1:0]   async_data_master_r_data_i,
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_master_r_rptr_o,

    // WRITE RESPONSE CHANNEL
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_data_master_b_wptr_i,
    input logic [2**CDC_FIFOS_LOG_DEPTH-1:0][S2C_B_WIDTH-1:0]   async_data_master_b_data_i,
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_data_master_b_rptr_o,

    // EVENT BUS
    output logic [CDC_FIFOS_LOG_DEPTH:0]                        async_cluster_events_wptr_o,
    input logic [CDC_FIFOS_LOG_DEPTH:0]                         async_cluster_events_rptr_i,
    output logic [EVNT_WIDTH-1:0][2**CDC_FIFOS_LOG_DEPTH-1:0]   async_cluster_events_data_o,

    input logic                                                 cluster_busy_i,
    output logic                                                dma_pe_evt_ack_o,
    input logic                                                 dma_pe_evt_valid_i,
    output logic                                                dma_pe_irq_ack_o,
    input logic                                                 dma_pe_irq_valid_i,
    output logic                                                pf_evt_ack_o,
    input logic                                                 pf_evt_valid_i,


    // Peripheral Connections
    // Timer Channels
    output logic [3:0]                                          timer_ch0_o,
    output logic [3:0]                                          timer_ch1_o,
    output logic [3:0]                                          timer_ch2_o,
    output logic [3:0]                                          timer_ch3_o,

    // UART
    output                                                      uart_pkg::uart_to_pad_t [udma_cfg_pkg::N_UART-1:0] uart_to_pad_o,
    input                                                       uart_pkg::pad_to_uart_t [udma_cfg_pkg::N_UART-1:0] pad_to_uart_i,
    // I2C
    output                                                      i2c_pkg::i2c_to_pad_t [udma_cfg_pkg::N_I2C-1:0] i2c_to_pad_o,
    input                                                       i2c_pkg::pad_to_i2c_t [udma_cfg_pkg::N_I2C-1:0] pad_to_i2c_i,
    // SDIO
    output                                                      sdio_pkg::sdio_to_pad_t [udma_cfg_pkg::N_SDIO-1:0] sdio_to_pad_o,
    input                                                       sdio_pkg::pad_to_sdio_t [udma_cfg_pkg::N_SDIO-1:0] pad_to_sdio_i,
    // I2S
    output                                                      i2s_pkg::i2s_to_pad_t [udma_cfg_pkg::N_I2S-1:0] i2s_to_pad_o,
    input                                                       i2s_pkg::pad_to_i2s_t [udma_cfg_pkg::N_I2S-1:0] pad_to_i2s_i,
    // QSPI
    output                                                      qspi_pkg::qspi_to_pad_t [udma_cfg_pkg::N_QSPIM-1:0] qspi_to_pad_o,
    input                                                       qspi_pkg::pad_to_qspi_t [udma_cfg_pkg::N_QSPIM-1:0] pad_to_qspi_i,
    // CPI
    input                                                       cpi_pkg::pad_to_cpi_t [udma_cfg_pkg::N_CPI-1:0] pad_to_cpi_i,
    // HYPER
    output                                                      hyper_pkg::hyper_to_pad_t [udma_cfg_pkg::N_HYPER-1:0] hyper_to_pad_o,
    input                                                       hyper_pkg::pad_to_hyper_t [udma_cfg_pkg::N_HYPER-1:0] pad_to_hyper_i,
    // GPIO
    input logic [NGPIO-1:0]                                     gpio_i,
    output logic [NGPIO-1:0]                                    gpio_o,
    output logic [NGPIO-1:0]                                    gpio_tx_en_o,


    /////////////////////////////////////////
    // Configuration ports to Chip Control //
    /////////////////////////////////////////
    // FLL bypass request bit from the PULP JTAG TAP. Connect this to your FLL
    // bypass multiplexers (e.g. by combining it with an externa bypass_pad
    // signal).  MAKE SURE TO USE A GLITCH-FREE CLOCK MULTIPLEXER FOR THIS!!!
    output logic                                                jtag_tap_bypass_fll_clk_o,
    // General Purpose Configuration Port for all chip specific configuration
    // (e.g. clock generation). All transactions to address space
    // `SOC_MEM_MAP_CHIP_CTRL_START_ADDR - `SOC_MEM_MAP_CHIP_CTRL_END_ADDR  are
    // routed to this port (see soc_mem_map.svh header files in chip level
    // repositories. The definitions of the address spaces are not in this repo
    // but defined by the toplevle chip repo.)
    // ALL SIGNALS OF THE CHIP-CTRL PORT ARE SYNCHRONOUS TO SOC_CLK_I.
    output logic [31:0]                                         apb_chip_ctrl_master_paddr_o,
    output logic [2:0]                                          apb_chip_ctrl_master_pprot_o,
    output logic                                                apb_chip_ctrl_master_psel_o,
    output logic                                                apb_chip_ctrl_master_penable_o,
    output logic                                                apb_chip_ctrl_master_pwrite_o,
    output logic [31:0]                                         apb_chip_ctrl_master_pwdata_o,
    output logic [3:0]                                          apb_chip_ctrl_master_pstrb_o,
    input logic [31:0]                                          apb_chip_ctrl_master_prdata_i,
    input logic                                                 apb_chip_ctrl_master_pready_i,
    input logic                                                 apb_chip_ctrl_master_pslverr_i,

    // JTAG signals
    // pulp-soc's JTAG chain contains two JTAG taps:
    // TDI-> RISC-DEBUG TAP (IR-size: 5, IDCODE: 0x50001db3) -> Legacy PULP JTAG TAP (IR-size: 5, IDCODE: 0x5fffedb3) -> TDO.
    // The reason we keep the legacy pulp JTAG tap is, that it provides much faster read/write access to the system memory and
    // it is much easier to generate static test vectors for SoC testing.
    input logic                                                 jtag_tck_i,
    input logic                                                 jtag_trst_ni,
    input logic                                                 jtag_tms_i,
    input logic                                                 jtag_tdi_i,
    output logic                                                jtag_tdo_o,
    // Debug request lines from the RISC-V debug unit to the cluster cores. Upon
    // debug request, the debugged harts/cores will start to communicate with
    // the debug unit by fetching instructions from a speciac debug ROM within
    // the debug unit itself (which is exposed as a normal soc peripheral to the
    // soc_peripheral interconnect).
    output logic [NB_CORES-1:0]                                 cluster_dbg_irq_valid_o
);

    localparam NB_L2_BANKS = `NB_L2_CHANNELS;
    //The L2 parameter do not influence the size of the memories. Change them in the l2_ram_multibank. This parameters
    //are only here to save area in the uDMA by only storing relevant bits.
    localparam L2_BANK_SIZE          = 16384;            // in 32-bit words
    localparam L2_MEM_ADDR_WIDTH     = $clog2(L2_BANK_SIZE * NB_L2_BANKS) - $clog2(NB_L2_BANKS);    // 2**L2_MEM_ADDR_WIDTH rows (64bit each) in L2 --> TOTAL L2 SIZE = 8byte * 2^L2_MEM_ADDR_WIDTH
    localparam NB_L2_BANKS_PRI       = 2;

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
        for (bit[31:0] i = 0; i < NB_CORES; i++) begin
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
    logic [31:0]           s_fc_interrupts;

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

    logic [7:0][31:0]      s_apb_mpu_rules;
    logic                  s_supervisor_mode;

    logic [31:0]           s_fc_bootaddr;

    logic                  s_sel_fll_clk;

    logic                  s_dma_pe_evt;
    logic                  s_dma_pe_irq;
    logic                  s_pf_evt;

    logic                  s_fc_fetchen;
    logic [NrHarts-1:0]    dm_debug_req;

    logic                  jtag_req_valid;
    logic                  debug_req_ready;
    logic                  jtag_resp_ready;
    logic                  jtag_resp_valid;
    logic                  dmi_rst_n;
    dm::dmi_req_t          jtag_dmi_req;
    dm::dmi_resp_t         debug_resp;
    logic                  slave_grant, slave_valid, dm_slave_req , dm_slave_we;
    logic                  [31:0] dm_slave_addr, dm_slave_wdata, dm_slave_rdata;
    logic                  [3:0]  dm_slave_be;
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

    // tap to lint wrap
    logic                  s_jtag_shift_dr;
    logic                  s_jtag_update_dr;
    logic                  s_jtag_capture_dr;
    logic                  s_jtag_axireg_sel;
    logic                  s_jtag_axireg_tdi;
    logic                  s_jtag_axireg_tdo;


    APB #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) s_apb_intrpt_ctrl_bus ();
    APB #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) s_apb_hwpe_bus ();
    APB #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) s_apb_debug_bus();
    APB #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) s_apb_chip_ctrl_bus();

    // Explode chip control APB interface to individual signals to support
    // standalone synthesis/floorplaining (Many tools don't like SV interfaces
    // at the toplevel and the APB structs are hard to use in a port list.)
    assign apb_chip_ctrl_master_paddr_o = s_apb_chip_ctrl_bus.paddr;
    assign apb_chip_ctrl_master_pprot_o = s_apb_chip_ctrl_bus.pprot;
    assign apb_chip_ctrl_master_psel_o = s_apb_chip_ctrl_bus.psel;
    assign apb_chip_ctrl_master_penable_o = s_apb_chip_ctrl_bus.penable;
    assign apb_chip_ctrl_master_pwrite_o = s_apb_chip_ctrl_bus.pwrite;
    assign apb_chip_ctrl_master_pwdata_o = s_apb_chip_ctrl_bus.pwdata;
    assign apb_chip_ctrl_master_pstrb_o = s_apb_chip_ctrl_bus.pstrb;
    assign s_apb_chip_ctrl_bus.prdata = apb_chip_ctrl_master_prdata_i;
    assign s_apb_chip_ctrl_bus.pready = apb_chip_ctrl_master_pready_i;
    assign s_apb_chip_ctrl_bus.pslverr = apb_chip_ctrl_master_pslverr_i;


    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH ( AXI_DATA_IN_WIDTH ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH   ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH    )
    ) s_data_in_bus ();


    AXI_BUS #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH ( AXI_DATA_OUT_WIDTH),
        .AXI_ID_WIDTH   ( AXI_ID_OUT_WIDTH  ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH    )
    ) s_data_out_bus ();

    //assign s_data_out_bus.aw_atop = 6'b0;

    AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) s_periph_bus ();

    XBAR_TCDM_BUS s_mem_rom_bus ();

    XBAR_TCDM_BUS  s_mem_l2_bus[NB_L2_BANKS]();
    XBAR_TCDM_BUS  s_mem_l2_pri_bus[NB_L2_BANKS_PRI]();

    XBAR_TCDM_BUS s_lint_debug_bus();
    XBAR_TCDM_BUS s_lint_pulp_jtag_bus();
    XBAR_TCDM_BUS s_lint_riscv_jtag_bus();
    XBAR_TCDM_BUS s_lint_udma_tx_bus ();
    XBAR_TCDM_BUS s_lint_udma_rx_bus ();
    XBAR_TCDM_BUS s_lint_fc_data_bus ();
    XBAR_TCDM_BUS s_lint_fc_instr_bus ();
    XBAR_TCDM_BUS s_lint_hwpe_bus[NB_HWPE_PORTS-1:0]();


    ////////////////////////
    // Cluster connection //
    ////////////////////////

    // This is only relevant if pulp_soc is instantiated next to a PULP cluster.
    // In thi case the following module instantiations handle the CDC crossing
    // for communication between cluster and soc. There are two independent AXI
    // channels for communication: A smaller 32-bit Axi channel with soc domain
    // acting as master and cluster as slave and a wider 64-bit AXI connection
    // with reversed roles.

    assign cluster_test_en_o = dft_test_mode_i;
    // If you want to connect a real PULP cluster you also need a cluster_busy_i signal

   `AXI_TYPEDEF_AW_CHAN_T(c2s_aw_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_W_CHAN_T(c2s_w_chan_t,logic[AXI_DATA_IN_WIDTH-1:0],logic[AXI_DATA_IN_WIDTH/8-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_B_CHAN_T(c2s_b_chan_t,logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_AR_CHAN_T(c2s_ar_chan_t,logic[AXI_ADDR_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])
   `AXI_TYPEDEF_R_CHAN_T(c2s_r_chan_t,logic[AXI_DATA_IN_WIDTH-1:0],logic[AXI_ID_IN_WIDTH-1:0],logic[AXI_USER_WIDTH-1:0])

    //Make sure the cluster -> soc cdc signals have the correct width
    if ($bits(c2s_aw_chan_t) != C2S_AW_WIDTH)
        $error("C2S_AW_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(c2s_aw_chan_t));
    if ($bits(c2s_w_chan_t) != C2S_W_WIDTH)
        $error("C2S_W_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(c2s_w_chan_t));
    if ($bits(c2s_b_chan_t) != C2S_B_WIDTH)
        $error("C2S_B_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(c2s_b_chan_t));
    if ($bits(c2s_ar_chan_t) != C2S_AR_WIDTH)
        $error("C2S_AR_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(c2s_ar_chan_t));
    if ($bits(c2s_r_chan_t) != C2S_R_WIDTH)
        $error("C2S_R_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(c2s_r_chan_t));


    `AXI_TYPEDEF_REQ_T(c2s_req_t,c2s_aw_chan_t,c2s_w_chan_t,c2s_ar_chan_t)
    `AXI_TYPEDEF_RESP_T(c2s_resp_t,c2s_b_chan_t,c2s_r_chan_t)

     c2s_req_t   dst_req ;
     c2s_resp_t  dst_resp;

    `AXI_ASSIGN_FROM_REQ(s_data_in_bus,dst_req)
    `AXI_ASSIGN_TO_RESP(dst_resp,s_data_in_bus)

    // One-sided CDC Reset
    // In the case of pulp_cluster and pulp_soc we not only have the issue of clock
    // domain crossing, we also have a problem with reset domain crossings. Since
    // both, the cluster and the SoC can be reset individually, we need to be
    // extremely carefuly in how we handle these one-sided resets on the clock
    // domain boundaries.
    //
    // WARNING: Do not just connect each domains specific reset signal
    // to the respective side of the cdc. this will not work at all.
    //
    // In order to handle one-sided resets properly, a toplevel reset controller
    // has to gate both clock domains and assert the CDC reset signal.

    // CLUSTER TO SOC AXI
    axi_cdc_dst #(
       .aw_chan_t  ( c2s_aw_chan_t ),
       .w_chan_t   ( c2s_w_chan_t  ),
       .b_chan_t   ( c2s_b_chan_t  ),
       .r_chan_t   ( c2s_r_chan_t  ),
       .ar_chan_t  ( c2s_ar_chan_t ),
       .axi_req_t  ( c2s_req_t     ),
       .axi_resp_t ( c2s_resp_t    ),
       .LogDepth   ( 3             )
    ) axi_slave_cdc_i (
       .dst_rst_ni                 ( soc_cluster_cdc_rst_ni     ),
       .dst_clk_i                  ( soc_clk_i                  ),
       .dst_req_o                  ( dst_req                    ),
       .dst_resp_i                 ( dst_resp                   ),
       .async_data_slave_aw_wptr_i ( async_data_slave_aw_wptr_i ),
       .async_data_slave_aw_rptr_o ( async_data_slave_aw_rptr_o ),
       .async_data_slave_aw_data_i ( async_data_slave_aw_data_i ),
       .async_data_slave_w_wptr_i  ( async_data_slave_w_wptr_i  ),
       .async_data_slave_w_rptr_o  ( async_data_slave_w_rptr_o  ),
       .async_data_slave_w_data_i  ( async_data_slave_w_data_i  ),
       .async_data_slave_ar_wptr_i ( async_data_slave_ar_wptr_i ),
       .async_data_slave_ar_rptr_o ( async_data_slave_ar_rptr_o ),
       .async_data_slave_ar_data_i ( async_data_slave_ar_data_i ),
       .async_data_slave_b_wptr_o  ( async_data_slave_b_wptr_o  ),
       .async_data_slave_b_rptr_i  ( async_data_slave_b_rptr_i  ),
       .async_data_slave_b_data_o  ( async_data_slave_b_data_o  ),
       .async_data_slave_r_wptr_o  ( async_data_slave_r_wptr_o  ),
       .async_data_slave_r_rptr_i  ( async_data_slave_r_rptr_i  ),
       .async_data_slave_r_data_o  ( async_data_slave_r_data_o  )
    );


    `AXI_TYPEDEF_AW_CHAN_T(s2c_aw_chan_t, logic[AXI_ADDR_WIDTH-1:0],     logic[AXI_ID_OUT_WIDTH-1:0],     logic[AXI_USER_WIDTH-1:0])
    `AXI_TYPEDEF_W_CHAN_T (s2c_w_chan_t,  logic[AXI_DATA_OUT_WIDTH-1:0], logic[AXI_DATA_OUT_WIDTH/8-1:0], logic[AXI_USER_WIDTH-1:0])
    `AXI_TYPEDEF_B_CHAN_T (s2c_b_chan_t,  logic[AXI_ID_OUT_WIDTH-1:0],   logic[AXI_USER_WIDTH-1:0])
    `AXI_TYPEDEF_AR_CHAN_T(s2c_ar_chan_t, logic[AXI_ADDR_WIDTH-1:0],     logic[AXI_ID_OUT_WIDTH-1:0],     logic[AXI_USER_WIDTH-1:0])
    `AXI_TYPEDEF_R_CHAN_T (s2c_r_chan_t, logic[AXI_DATA_OUT_WIDTH-1:0],  logic[AXI_ID_OUT_WIDTH-1:0],     logic[AXI_USER_WIDTH-1:0])

    //Make sure the soc -> cluster cdc signals have the correct width
    if ($bits(s2c_aw_chan_t) != S2C_AW_WIDTH)
        $error("S2C_AW_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(s2c_aw_chan_t));
    if ($bits(s2c_w_chan_t) != S2C_W_WIDTH)
        $error("S2C_W_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(s2c_w_chan_t));
    if ($bits(s2c_b_chan_t) != S2C_B_WIDTH)
        $error("S2C_B_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(s2c_b_chan_t));
    if ($bits(s2c_ar_chan_t) != S2C_AR_WIDTH)
        $error("S2C_AR_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(s2c_ar_chan_t));
    if ($bits(s2c_r_chan_t) != S2C_R_WIDTH)
        $error("S2C_R_WIDTH does not mach the size of the AXI AW channel. With the current values of AXI_DATA_OUT_WIDTH, AXI_ADDR_WIDTH, AXI_ID_OUT_WIDTH and AXI_USER_WIDTH this value must be set to %d.", $bits(s2c_r_chan_t));

    `AXI_TYPEDEF_REQ_T(s2c_req_t,s2c_aw_chan_t,s2c_w_chan_t,s2c_ar_chan_t)
    `AXI_TYPEDEF_RESP_T(s2c_resp_t,s2c_b_chan_t,s2c_r_chan_t)

    s2c_req_t   src_req ;
    s2c_resp_t  src_resp;

    `AXI_ASSIGN_TO_REQ(src_req,s_data_out_bus)
    `AXI_ASSIGN_FROM_RESP(s_data_out_bus,src_resp)

    // SOC TO CLUSTER
    axi_cdc_src #(
        .aw_chan_t  ( s2c_aw_chan_t       ),
        .w_chan_t   ( s2c_w_chan_t        ),
        .b_chan_t   ( s2c_b_chan_t        ),
        .r_chan_t   ( s2c_r_chan_t        ),
        .ar_chan_t  ( s2c_ar_chan_t       ),
        .axi_req_t  ( s2c_req_t           ),
        .axi_resp_t ( s2c_resp_t          ),
        .LogDepth   ( CDC_FIFOS_LOG_DEPTH )
    ) axi_master_cdc_i (
        .src_rst_ni                  ( soc_cluster_cdc_rst_ni      ),
        .src_clk_i                   ( soc_clk_i                   ),
        .src_req_i                   ( src_req                     ),
        .src_resp_o                  ( src_resp                    ),
        .async_data_master_aw_wptr_o ( async_data_master_aw_wptr_o ),
        .async_data_master_aw_rptr_i ( async_data_master_aw_rptr_i ),
        .async_data_master_aw_data_o ( async_data_master_aw_data_o ),
        .async_data_master_w_wptr_o  ( async_data_master_w_wptr_o  ),
        .async_data_master_w_rptr_i  ( async_data_master_w_rptr_i  ),
        .async_data_master_w_data_o  ( async_data_master_w_data_o  ),
        .async_data_master_ar_wptr_o ( async_data_master_ar_wptr_o ),
        .async_data_master_ar_rptr_i ( async_data_master_ar_rptr_i ),
        .async_data_master_ar_data_o ( async_data_master_ar_data_o ),
        .async_data_master_b_wptr_i  ( async_data_master_b_wptr_i  ),
        .async_data_master_b_rptr_o  ( async_data_master_b_rptr_o  ),
        .async_data_master_b_data_i  ( async_data_master_b_data_i  ),
        .async_data_master_r_wptr_i  ( async_data_master_r_wptr_i  ),
        .async_data_master_r_rptr_o  ( async_data_master_r_rptr_o  ),
        .async_data_master_r_data_i  ( async_data_master_r_data_i  )
    );

    //********************************************************
    //********************* SOC L2 RAM ***********************
    //********************************************************

    l2_ram_multi_bank #(
        .NB_BANKS            ( NB_L2_BANKS  ),
        .BANK_SIZE_INTL_SRAM ( L2_BANK_SIZE )
    ) l2_ram_i (
        .clk_i         ( soc_clk_i          ),
        .rst_ni        ( soc_rstn_synced_i  ),
        .init_ni       ( 1'b1               ),
        .test_mode_i   ( dft_test_mode_i    ),
        .mem_slave     ( s_mem_l2_bus       ),
        .mem_pri_slave ( s_mem_l2_pri_bus   )
    );


    //********************************************************
    //******              SOC BOOT ROM             ***********
    //********************************************************

    boot_rom #(
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
    ) boot_rom_i (
        .clk_i       ( soc_clk_i         ),
        .rst_ni      ( soc_rstn_synced_i ),
        .init_ni     ( 1'b1              ),
        .mem_slave   ( s_mem_rom_bus     ),
        .test_mode_i ( dft_test_mode_i   )
    );

    //********************************************************
    //********************* SOC PERIPHERALS ******************
    //********************************************************

    soc_peripherals #(
        .MEM_ADDR_WIDTH ( L2_MEM_ADDR_WIDTH+$clog2(NB_L2_BANKS) ),
        .APB_ADDR_WIDTH ( 32                                    ),
        .APB_DATA_WIDTH ( 32                                    ),
        .NB_CORES       ( NB_CORES                              ),
        .NB_CLUSTERS    ( `NB_CLUSTERS                          ),
        .EVNT_WIDTH     ( EVNT_WIDTH                            ),
        .SIM_STDOUT     ( SIM_STDOUT                            ),
        .SOC_VERSION    ( SOC_VERSION                           ),
        .CORE_TYPE      ( CORE_TYPE                             ),
        .FPU_PRESENT    ( USE_FPU                               ),
        .ZFINX          ( USE_ZFINX                             ),
        .HWPE_PRESENT   ( USE_HWPE                              )
    ) soc_peripherals_i (
        .clk_i                  ( soc_clk_i              ),
        .rst_ni                 ( soc_rstn_synced_i      ),
        .periph_clk_i           ( per_clk_i              ),
        .periph_rstn_i          ( per_rstn_synced_i      ),

        .slow_clk_i             ( slow_clk_i             ),
        .slow_rstn_i            ( slow_clk_rstn_synced_i ),

        .sel_pll_clk_i          ( s_sel_fll_clk          ),
        .dft_test_mode_i        ( dft_test_mode_i        ),
        .dft_cg_enable_i        ( dft_cg_enable_i        ),
        .fc_bootaddr_o          ( s_fc_bootaddr          ),
        .fc_fetchen_o           ( s_fc_fetchen           ),
        .soc_jtag_reg_i         ( soc_jtag_reg_tap       ),
        .soc_jtag_reg_o         ( soc_jtag_reg_soc       ),

        .bootsel_i              ( bootsel_i              ),

        .fc_fetch_en_valid_i    ( fc_fetch_en_valid_i    ),
        .fc_fetch_en_i          ( fc_fetch_en_i          ),

        .axi_lite_slave         ( s_periph_bus           ),

        .apb_intrpt_ctrl_master ( s_apb_intrpt_ctrl_bus  ),
        .apb_hwpe_master        ( s_apb_hwpe_bus         ),
        .apb_debug_master       ( s_apb_debug_bus        ),
        .apb_chip_ctrl_master   ( s_apb_chip_ctrl_bus    ),

        .l2_rx_master           ( s_lint_udma_rx_bus     ),
        .l2_tx_master           ( s_lint_udma_tx_bus     ),

        .dma_pe_evt_i           ( s_dma_pe_evt           ),
        .dma_pe_irq_i           ( s_dma_pe_irq           ),
        .pf_evt_i               ( s_pf_evt               ),
        .fc_hwpe_events_i       ( s_fc_hwpe_events       ),
        .fc_interrupts_o        ( s_fc_interrupts        ),

        .timer_ch0_o            ( timer_ch0_o            ),
        .timer_ch1_o            ( timer_ch1_o            ),
        .timer_ch2_o            ( timer_ch2_o            ),
        .timer_ch3_o            ( timer_ch3_o            ),

        // UART
        .uart_to_pad_o,
        .pad_to_uart_i,
        // I2C
        .i2c_to_pad_o,
        .pad_to_i2c_i,
        // SDIO
        .sdio_to_pad_o,
        .pad_to_sdio_i,
        // I2S
        .i2s_to_pad_o,
        .pad_to_i2s_i,
        // QSPI
        .qspi_to_pad_o,
        .pad_to_qspi_i,
        // CPI
        .pad_to_cpi_i,
        // HYPER
        .hyper_to_pad_o,
        .pad_to_hyper_i,

        // GPIO
        .gpio_i,
        .gpio_o,
        .gpio_tx_en_o,

        .cl_event_data_o        ( s_cl_event_data        ),
        .cl_event_valid_o       ( s_cl_event_valid       ),
        .cl_event_ready_i       ( s_cl_event_ready       ),

        .fc_event_data_o        ( s_fc_event_data        ),
        .fc_event_valid_o       ( s_fc_event_valid       ),
        .fc_event_ready_i       ( s_fc_event_ready       ),

        .cluster_rstn_req_o
    );

    cdc_fifo_gray_src #(
      .T           ( logic[EVNT_WIDTH-1:0] ),
      .LOG_DEPTH   ( CDC_FIFOS_LOG_DEPTH   ),
      .SYNC_STAGES ( 2                     )
    ) i_event_cdc_src (
      .src_rst_ni               ( soc_cluster_cdc_rst_ni      ),
      .src_clk_i                ( soc_clk_i                   ),
      .src_data_i               ( s_cl_event_data             ),
      .src_valid_i              ( s_cl_event_valid            ),
      .src_ready_o              ( s_cl_event_ready            ),
      (* async *) .async_data_o ( async_cluster_events_data_o ),
      (* async *) .async_wptr_o ( async_cluster_events_wptr_o ),
      (* async *) .async_rptr_i ( async_cluster_events_rptr_i )
    );

    edge_propagator_rx ep_dma_pe_evt_i (
        .clk_i   ( soc_clk_i          ),
        .rstn_i  ( soc_rstn_synced_i  ),
        .valid_o ( s_dma_pe_evt       ),
        .ack_o   ( dma_pe_evt_ack_o   ),
        .valid_i ( dma_pe_evt_valid_i )
    );

    edge_propagator_rx ep_dma_pe_irq_i (
        .clk_i   ( soc_clk_i          ),
        .rstn_i  ( soc_rstn_synced_i  ),
        .valid_o ( s_dma_pe_irq       ),
        .ack_o   ( dma_pe_irq_ack_o   ),
        .valid_i ( dma_pe_irq_valid_i )
    );
`ifndef PULP_FPGA_EMUL
    edge_propagator_rx ep_pf_evt_i (
        .clk_i   ( soc_clk_i         ),
        .rstn_i  ( soc_rstn_synced_i ),
        .valid_o ( s_pf_evt          ),
        .ack_o   ( pf_evt_ack_o      ),
        .valid_i ( pf_evt_valid_i    )
    );
`endif

    fc_subsystem #(
        .CORE_TYPE  ( CORE_TYPE          ),
        .USE_XPULP  ( USE_XPULP          ),
        .USE_FPU    ( USE_FPU            ),
        .USE_ZFINX  ( USE_ZFINX          ),
        .CORE_ID    ( FC_CORE_CORE_ID    ),
        .CLUSTER_ID ( FC_CORE_CLUSTER_ID ),
        .USE_HWPE   ( USE_HWPE           )
    ) fc_subsystem_i (
        .clk_i              ( soc_clk_i                     ),
        .rst_ni             ( soc_rstn_synced_i             ),

        .test_en_i          ( dft_test_mode_i               ),

        .boot_addr_i        ( s_fc_bootaddr                 ),

        .fetch_en_i         ( s_fc_fetchen                  ),

        .l2_data_master     ( s_lint_fc_data_bus            ),
        .l2_instr_master    ( s_lint_fc_instr_bus           ),
        .l2_hwpe_master     ( s_lint_hwpe_bus               ),
        .apb_slave_eu       ( s_apb_intrpt_ctrl_bus         ),
        .apb_slave_hwpe     ( s_apb_hwpe_bus                ),
        .debug_req_i        ( dm_debug_req[FC_CORE_MHARTID] ),

        .event_fifo_valid_i ( s_fc_event_valid              ),
        .event_fifo_fulln_o ( s_fc_event_ready              ),
        .event_fifo_data_i  ( s_fc_event_data               ),
        .interrupts_i       ( s_fc_interrupts               ),
        .hwpe_events_o      ( s_fc_hwpe_events              ),

        .supervisor_mode_o  ( s_supervisor_mode             )
    );

    soc_interconnect_wrap #(
      .NR_HWPE_PORTS   ( NB_HWPE_PORTS   ),
      .NR_L2_PORTS     ( NB_L2_BANKS     ),
      .AXI_IN_ID_WIDTH ( AXI_ID_IN_WIDTH ),
      .AXI_USER_WIDTH  ( AXI_USER_WIDTH  )
    ) i_soc_interconnect_wrap (
      .clk_i                   ( soc_clk_i           ),
      .rst_ni                  ( soc_rstn_synced_i   ),
      .test_en_i               ( dft_test_mode_i     ),
      .tcdm_fc_data            ( s_lint_fc_data_bus  ),
      .tcdm_fc_instr           ( s_lint_fc_instr_bus ),
      .tcdm_udma_rx            ( s_lint_udma_rx_bus  ),
      .tcdm_udma_tx            ( s_lint_udma_tx_bus  ),
      .tcdm_debug              ( s_lint_debug_bus    ),
      .tcdm_hwpe               ( s_lint_hwpe_bus     ),
      .axi_master_plug         ( s_data_in_bus       ),
      .axi_slave_plug          ( s_data_out_bus      ),
      .axi_lite_peripheral_bus ( s_periph_bus        ),
      .l2_interleaved_slaves   ( s_mem_l2_bus        ),
      .l2_private_slaves       ( s_mem_l2_pri_bus    ),
      .boot_rom_slave          ( s_mem_rom_bus       )
    );

    /* Debug Subsystem */

    dmi_jtag #(
        .IdcodeValue          ( `DMI_JTAG_IDCODE    )
    ) i_dmi_jtag (
        .clk_i                ( soc_clk_i           ),
        .rst_ni               ( soc_rstn_synced_i   ),
        .testmode_i           ( 1'b0                ),
        .dmi_req_o            ( jtag_dmi_req        ),
        .dmi_req_valid_o      ( jtag_req_valid      ),
        .dmi_req_ready_i      ( debug_req_ready     ),
        .dmi_resp_i           ( debug_resp          ),
        .dmi_resp_ready_o     ( jtag_resp_ready     ),
        .dmi_resp_valid_i     ( jtag_resp_valid     ),
        .dmi_rst_no           ( dmi_rst_n           ),
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
       .SelectableHarts   ( SELECTABLE_HARTS          ),
       .ReadByteEnable    ( 0                         )
    ) i_dm_top (

       .clk_i             ( soc_clk_i                 ),
       .rst_ni            ( soc_rstn_synced_i         ),
       .testmode_i        ( 1'b0                      ),
       .ndmreset_o        (                           ),
       .dmactive_o        (                           ), // active debug session
       .debug_req_o       ( dm_debug_req              ),
       .unavailable_i     ( ~SELECTABLE_HARTS         ),
       .hartinfo_i        ( hartinfo                  ),

       .slave_req_i          ( dm_slave_req                  ),
       .slave_we_i           ( dm_slave_we                   ),
       .slave_addr_i         ( dm_slave_addr                 ),
       .slave_be_i           ( dm_slave_be                   ),
       .slave_wdata_i        ( dm_slave_wdata                ),
       .slave_rdata_o        ( dm_slave_rdata                ),

       .master_req_o         ( s_lint_riscv_jtag_bus.req     ),
       .master_add_o         ( s_lint_riscv_jtag_bus.add     ),
       .master_we_o          ( lint_riscv_jtag_bus_master_we ),
       .master_wdata_o       ( s_lint_riscv_jtag_bus.wdata   ),
       .master_be_o          ( s_lint_riscv_jtag_bus.be      ),
       .master_gnt_i         ( s_lint_riscv_jtag_bus.gnt     ),
       .master_r_valid_i     ( s_lint_riscv_jtag_bus.r_valid ),
       .master_r_err_i       ( s_lint_riscv_jtag_bus.r_opc   ),
       .master_r_other_err_i ( 1'b0                          ),
       .master_r_rdata_i     ( s_lint_riscv_jtag_bus.r_rdata ),

       .dmi_rst_ni           ( dmi_rst_n                     ),
       .dmi_req_valid_i      ( jtag_req_valid                ),
       .dmi_req_ready_o      ( debug_req_ready               ),
       .dmi_req_i            ( jtag_dmi_req                  ),
       .dmi_resp_valid_o     ( jtag_resp_valid               ),
       .dmi_resp_ready_i     ( jtag_resp_ready               ),
       .dmi_resp_o           ( debug_resp                    )
    );
    assign s_lint_riscv_jtag_bus.wen = ~lint_riscv_jtag_bus_master_we;


    jtag_tap_top  #(
        .IDCODE_VALUE             ( `PULP_JTAG_IDCODE  )
    ) jtag_tap_top_i (
        .tck_i                    ( jtag_tck_i         ),
        .trst_ni                  ( jtag_trst_ni       ),
        .tms_i                    ( jtag_tms_i         ),
        .td_i                     ( int_td             ),
        .td_o                     ( jtag_tdo_o         ),

        .test_clk_i               ( 1'b0               ),
        .test_rstn_i              ( soc_rstn_synced_i  ),

        .jtag_shift_dr_o          ( s_jtag_shift_dr    ),
        .jtag_update_dr_o         ( s_jtag_update_dr   ),
        .jtag_capture_dr_o        ( s_jtag_capture_dr  ),

        .axireg_sel_o             ( s_jtag_axireg_sel  ),
        .dbg_axi_scan_in_o        ( s_jtag_axireg_tdi  ),
        .dbg_axi_scan_out_i       ( s_jtag_axireg_tdo  ),
        .soc_jtag_reg_i           ( soc_jtag_reg_soc   ),
        .soc_jtag_reg_o           ( soc_jtag_reg_tap   ),
        .sel_fll_clk_o            ( s_sel_fll_clk      )
    );

    assign jtag_tap_bypass_fll_clk_o = s_sel_fll_clk;

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
        .clk_i                    ( soc_clk_i            ),
        .rst_ni                   ( soc_rstn_synced_i    ),
        .jtag_lint_master         ( s_lint_pulp_jtag_bus )
    );

    tcdm_arbiter_2x1 jtag_lint_arbiter_i
     (
        .clk_i(soc_clk_i),
        .rst_ni(soc_rstn_synced_i),
        .tcdm_bus_1_i(s_lint_riscv_jtag_bus),
        .tcdm_bus_0_i(s_lint_pulp_jtag_bus),
        .tcdm_bus_o(s_lint_debug_bus)
    );

    apb2per #(
        .PER_ADDR_WIDTH ( 32  ),
        .APB_ADDR_WIDTH ( 32  )
    ) apb2per_newdebug_i (
        .clk_i                ( soc_clk_i               ),
        .rst_ni               ( soc_rstn_synced_i       ),

        .PADDR                ( s_apb_debug_bus.paddr   ),
        .PWDATA               ( s_apb_debug_bus.pwdata  ),
        .PWRITE               ( s_apb_debug_bus.pwrite  ),
        .PSEL                 ( s_apb_debug_bus.psel    ),
        .PENABLE              ( s_apb_debug_bus.penable ),
        .PRDATA               ( s_apb_debug_bus.prdata  ),
        .PREADY               ( s_apb_debug_bus.pready  ),
        .PSLVERR              ( s_apb_debug_bus.pslverr ),

        .per_master_req_o     ( dm_slave_req            ),
        .per_master_add_o     ( dm_slave_addr           ),
        .per_master_we_o      ( dm_slave_we             ),
        .per_master_wdata_o   ( dm_slave_wdata          ),
        .per_master_be_o      ( dm_slave_be             ),
        .per_master_gnt_i     ( slave_grant             ),
        .per_master_r_valid_i ( slave_valid             ),
        .per_master_r_opc_i   ( '0                      ),
        .per_master_r_rdata_i ( dm_slave_rdata          )
     );

     assign slave_grant = dm_slave_req;
     always_ff @(posedge soc_clk_i or negedge soc_rstn_synced_i) begin : apb2per_valid
         if(~soc_rstn_synced_i) begin
             slave_valid <= 0;
         end else begin
             slave_valid <= slave_grant;
         end
     end
endmodule
