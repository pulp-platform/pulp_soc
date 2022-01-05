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

module boot_rom #(
    parameter ROM_ADDR_WIDTH = 13,
    parameter MACRO_ROM = 0
) (
    input logic               clk_i,
    input logic               rst_ni,
    input logic               init_ni,
          XBAR_TCDM_BUS.Slave mem_slave,
    input logic               test_mode_i
);

  assign mem_slave.r_opc = 1'b0;

  //Perform TCDM handshaking for constant 1 cycle latency
  assign mem_slave.gnt   = mem_slave.req;
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      mem_slave.r_valid <= 1'b0;
    end else begin
      mem_slave.r_valid <= mem_slave.req;
    end
  end

  //Remove address offset
  logic [31:0] address;
  assign address = mem_slave.add - `SOC_MEM_MAP_BOOT_ROM_START_ADDR;

`ifdef PULP_FPGA_EMUL

  fpga_autogen_rom #(
      .ADDR_WIDTH(ROM_ADDR_WIDTH-2), //The ROM uses 32-bit word addressing while the bus addresses bytes
      .DATA_WIDTH(32)
  ) i_fpga_autogen_rom (
      .CLK(clk_i),
      .CEN(~mem_slave.req),
      .A  (address[ROM_ADDR_WIDTH-1:2]),  //Cutoff insignificant address bits. The interconnect
      //makes sure we only receive addresses in the bootrom address space
      .Q  (mem_slave.r_rdata)
  );

`else  // !`ifdef PULP_FPGA_EMUL

  if (MACRO_ROM) begin : rom_macro

    // ROM is implemented with a ROM memory macro
    bootrom_macro_wrap #(
        .NumWords (2 ** ROM_ADDR_WIDTH),
        .DataWidth(32)
    ) i_bootrom_macro (
        .clk_i,
        .rst_ni,
        .req_i(mem_slave.req),
        .we_i(~mem_slave.wen),
        .addr_i(address[ROM_ADDR_WIDTH-1:2]),
        .wdata_i(mem_slave.wdata),
        .be_i(mem_slave.be),
        .rdata_o(mem_slave.r_rdata)
    );

  end else begin : rom_comb  // block: rom_macro

    // ROM is implemented with a combinatorial circuit
    asic_autogen_rom #(
        .ADDR_WIDTH(ROM_ADDR_WIDTH-2), //The ROM uses 32-bit word addressing while the bus addresses bytes
        .DATA_WIDTH(32)
    ) i_asic_autogen_rom (
        .CLK(clk_i),
        .CEN(~mem_slave.req),
        .A  (address[ROM_ADDR_WIDTH-1:2]),  //Cutoff insignificant address bits. The
        //interconnect makes sure we only receive addresses in the bootrom address space
        .Q  (mem_slave.r_rdata)
    );

  end // block: rom_comb

`endif // !`ifdef PULP_FPGA_EMUL

endmodule
