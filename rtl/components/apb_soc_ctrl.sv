// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


`define REG_INFO        7'b0000000 //BASEADDR+0x00 CONTAINS NUMBER OF CORES [31:16] AND CLUSTERS [15:0]
`define REG_FCBOOT      7'b0000001 //BASEADDR+0x04 not used at the moment
`define REG_FCFETCH     7'b0000010 //BASEADDR+0x08 not used at the moment
`define REG_CORE_RELEASE 7'b0000110 //BASEADDR+0X18 core release in preloaded bootmode

// Regster to configure the direction of SPI and I2C peripherals: the first bit as select signal for output multiplexers ('0' for master, '1' for slave)
`define REG_SPI_DIRECTION  7'b0011000 //BASEADDR+0x60 mux selection bit for inter-socket SPI
`define REG_I2C_DIRECTION  7'b0011001 //BASEADDR+0x64 mux selection bit for inter-socket I2C

`define REG_JTAGREG     7'b0011101 //BASEADDR+0x74 JTAG REG

`define REG_CORESTATUS  7'b0101000 //BASEADDR+0xA0 32bit GP register to be used during testing to return EOC(bit[31]) and status(bit[30:0])
`define REG_CS_RO       7'b0110000 //BASEADDR+0xC0 32bit GP register to be used during testing to return EOC(bit[31]) and status(bit[30:0]) Read Only mirror
`define REG_BOOTSEL     7'b0110001 //BASEADDR+0xC4 bootsel
`define REG_CLKSEL      7'b0110010 //BASEADDR+0xC8 clocksel
//`define REG_CORE_RELEASE 7'b0110011 //BASEADDR+0xCC core release in preloaded bootmode
 //BASEADDR+0xCC clocksel


`define REG_CLUSTER_CTRL 7'b0011100 //BASEADDR+0x70 CLUSTER Ctrl
`define REG_CTRL_PER     7'b0011110
`define REG_CLUSTER_IRQ  7'b0011111

`define REG_CLUSTER_BOOT_ADDR0 7'b0100000
`define REG_CLUSTER_BOOT_ADDR1 7'b0100001
// NOTE: safe regs will be mapped starting from BASEADDR+0x100

//`define MSG_VERBOSE

module apb_soc_ctrl #(
    parameter int unsigned APB_ADDR_WIDTH = 12,  // APB slaves are 4KB by default
    parameter int unsigned NB_CLUSTERS    = 0,   // N_CLUSTERS
    parameter int unsigned NB_CORES       = 4,   // N_CORES
    parameter int unsigned JTAG_REG_SIZE  = 8
) (
    input  logic                      HCLK,
    input  logic                      HRESETn,
    input  logic [APB_ADDR_WIDTH-1:0] PADDR,
    input  logic               [31:0] PWDATA,
    input  logic                      PWRITE,
    input  logic                      PSEL,
    input  logic                      PENABLE,
    output logic               [31:0] PRDATA,
    output logic                      PREADY,
    output logic                      PSLVERR,

    input  logic                      sel_clk_i,
    input  logic                      bootsel_valid_i,
    input  logic [1:0]                bootsel_i,
    input  logic                      fc_fetch_en_valid_i,
    input  logic                      fc_fetch_en_i,

    input  logic                [JTAG_REG_SIZE-1:0] soc_jtag_reg_i,
    output logic                [JTAG_REG_SIZE-1:0] soc_jtag_reg_o,

    output logic               [31:0] fc_bootaddr_o,

    output logic                      fc_fetchen_o,
    output logic                      sel_hyper_axi_o,
    output logic                      sel_spi_dir_o,
	output logic                      sel_i2c_mux_o,
    output logic                      cluster_pow_o, // power cluster
    output logic                      cluster_byp_o, // bypass cluster
    output logic               [63:0] cluster_boot_addr_o,
    output logic                      cluster_fetch_enable_o,
    output logic                      cluster_rstn_o,
    output logic                      cluster_irq_o
    );

   logic     [31:0] r_pwr_reg;
   logic     [31:0] r_corestatus;


   logic      [6:0] s_apb_addr;

   logic     [15:0] n_cores;
   logic     [15:0] n_clusters;

   logic     [63:0] r_cluster_boot;
   logic            r_cluster_fetch_enable;
   logic            r_cluster_rstn;

   logic      [JTAG_REG_SIZE-1:0] r_jtag_rego;
   logic      [JTAG_REG_SIZE-1:0] r_jtag_regi_sync[1:0];

   logic            r_cluster_byp;
   logic            r_cluster_pow;
   logic     [31:0] r_bootaddr;
   logic            r_fetchen;
   logic            r_core_release;

   logic            r_cluster_irq;

   logic            r_sel_hyper_axi;
   logic            r_sel_spi_dir;
   logic            r_sel_i2c_mux;
   logic      [1:0] r_bootsel;

   logic            s_apb_write;

   assign soc_jtag_reg_o = r_jtag_rego;

   assign fc_bootaddr_o = r_bootaddr;
   assign fc_fetchen_o  = r_fetchen;

   assign cluster_pow_o = r_cluster_pow;
   assign sel_hyper_axi_o = r_sel_hyper_axi;

   // Inter-socket select signal assign
   assign sel_spi_dir_o = r_sel_spi_dir;
   assign sel_i2c_mux_o = r_sel_i2c_mux;

   assign s_apb_write = PSEL && PENABLE && PWRITE;

   assign cluster_rstn_o = r_cluster_rstn;

   assign cluster_boot_addr_o = r_cluster_boot;
   assign cluster_fetch_enable_o = r_cluster_fetch_enable;
   assign cluster_byp_o = r_cluster_byp;
   assign cluster_irq_o = r_cluster_irq;


   assign s_apb_addr = PADDR[8:2];

    always_ff @(posedge HCLK, negedge HRESETn)
    begin
      if(~HRESETn) begin
        r_corestatus           <= '0;
        r_pwr_reg              <= '0;
        r_jtag_regi_sync[0]    <= 'h0;
        r_jtag_regi_sync[1]    <= 'h0;
        r_jtag_rego            <= 'h0;
        r_bootaddr             <= 32'h1A000080;
        r_bootsel              <= 2'h0;
        r_fetchen              <= 1'h0; // on reset, fc doesn't do anything
        r_cluster_pow          <= 1'b0;
        r_cluster_byp          <= 1'b1;
        r_sel_hyper_axi        <= 1'b0;
        r_sel_spi_dir          <= 1'b1; // default value of select signal for inter-socket spi peripheral: slave
		r_sel_i2c_mux          <= 1'b1; // default value of select signal for inter-socket i2c peripheral: master
        r_cluster_fetch_enable <= 1'b0;
        r_cluster_boot         <= '0;
        r_cluster_rstn         <= 1'b1;
        r_cluster_irq          <= 1'b0;
      end
      else
      begin
        r_jtag_regi_sync[1] <= soc_jtag_reg_i;
        r_jtag_regi_sync[0] <= r_jtag_regi_sync[1];

        // allow fc fetch enable to be controlled through a signal
        if (fc_fetch_en_valid_i)
            r_fetchen <= fc_fetch_en_i;

        // allow bootsel to be controlled through a signal
        if (bootsel_valid_i)
            r_bootsel <= bootsel_i;

        if (PSEL && PENABLE && PWRITE)
        begin
          case (s_apb_addr)
                `REG_FCBOOT:
                 begin
                   r_bootaddr <= PWDATA;
                 end
                `REG_BOOTSEL:
                 begin
                   // allow bootsel to be controlled through JTAG
                   r_bootsel <= PWDATA[1:0];
                 end
                `REG_FCFETCH:
                 begin
                   // allow fc fetch enable to be controlled through JTAG
                   r_fetchen <= PWDATA[0];
                 end
                `REG_CORE_RELEASE:
                 begin
                   r_core_release <= PWDATA[0];
                 end
                `REG_SPI_DIRECTION:
                begin
                   r_sel_spi_dir <= PWDATA[0];
                end
				`REG_I2C_DIRECTION:
				begin
                   r_sel_i2c_mux <= PWDATA[0];
                end

                `REG_JTAGREG:
                begin
                  r_jtag_rego   <= PWDATA[JTAG_REG_SIZE-1:0];
                end
                `REG_CORESTATUS:
                begin
                  r_corestatus  <= PWDATA[31:0];
                end
                `REG_CLUSTER_CTRL:
                begin
                  r_cluster_byp          <= PWDATA[0];
                  r_cluster_pow          <= PWDATA[1];
                  r_cluster_fetch_enable <= PWDATA[2];
                  r_cluster_rstn         <= PWDATA[3];
                end
                `REG_CTRL_PER: begin
                  r_sel_hyper_axi <= PWDATA[0];
                end
                `REG_CLUSTER_IRQ:
                    r_cluster_irq <= PWDATA[0];
                `REG_CLUSTER_BOOT_ADDR0:
                    r_cluster_boot[31:0] <= PWDATA;
                `REG_CLUSTER_BOOT_ADDR1:
                    r_cluster_boot[63:32] <= PWDATA;
                default: begin
                `ifndef SYNTHESIS
                  `ifdef MSG_VERBOSE
                  $display("[APB SOC CTRL] INVALID WRITE ACCESS to %x at time %t\n",PADDR, $time);
                  `endif
                `endif
                end
          endcase
        end
      end
    end

    // read data
    always_comb
    begin
        PRDATA = '0;
        case (s_apb_addr)
          `REG_FCBOOT:
            PRDATA = r_bootaddr;
          `REG_FCFETCH:
            PRDATA = r_fetchen;
          `REG_CORE_RELEASE:
            PRDATA = r_core_release;
          `REG_INFO:
            PRDATA = {n_cores,n_clusters};
          `REG_CORESTATUS:
            PRDATA = r_corestatus;
          `REG_CS_RO:
            PRDATA = r_corestatus;
          `REG_BOOTSEL:
            PRDATA =  {30'h0, r_bootsel};
          `REG_CLKSEL:
            PRDATA = {31'h0, sel_clk_i};
          `REG_CLUSTER_CTRL:
            PRDATA = {
              29'h0,
              r_cluster_rstn,
              r_cluster_fetch_enable,
              r_cluster_pow,
              r_cluster_byp };
          `REG_JTAGREG:
            PRDATA = {16'h0,r_jtag_regi_sync[0],r_jtag_rego};
          `REG_SPI_DIRECTION:
            PRDATA = {31'b0, r_sel_spi_dir};
		  `REG_I2C_DIRECTION:
            PRDATA = {31'b0, r_sel_i2c_mux};
          `REG_CTRL_PER:
            PRDATA = {31'b0, r_sel_hyper_axi};
          `REG_CLUSTER_IRQ:
            PRDATA = {31'b0, r_cluster_irq};
          `REG_CLUSTER_BOOT_ADDR0:
            PRDATA = r_cluster_boot[31:0];
          `REG_CLUSTER_BOOT_ADDR1:
            PRDATA = r_cluster_boot[63:32];
          default:
            begin
            PRDATA = 'h0;
            `ifndef SYNTHESIS
              `ifdef MSG_VERBOSE
              $display("[APB SOC CTRL] INVALID READ ACCESS to %x at time %t\n",PADDR, $time);
              `endif
            `endif
            end
        endcase
    end

   assign n_cores    = NB_CORES;
   assign n_clusters = NB_CLUSTERS;

   assign PREADY     = 1'b1;
   assign PSLVERR    = 1'b0;

endmodule
