// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module l2_ram_multi_bank #(
  parameter int unsigned NB_BANKS                   = 4,
  parameter int unsigned NB_BANKS_PRI               = 2,
  parameter int unsigned BANK_SIZE                  = 32768,
  parameter int unsigned MEM_ADDR_WIDTH             = 14,
  parameter int unsigned MEM_ADDR_WIDTH_PRI         = 13
) (
  input logic             clk_i,
  input logic             rst_ni,
  input logic             init_ni,
  input logic             test_mode_i,
  UNICAD_MEM_BUS_32.Slave mem_slave[NB_BANKS-1:0],
  UNICAD_MEM_BUS_32.Slave mem_pri_slave[NB_BANKS_PRI-1:0]
);
  // Used in testbenches
  localparam int unsigned BANK_SIZE_PRI1 = 8192;
  localparam int unsigned BANK_SIZE_PRI0 = 8192;

  localparam int unsigned BANK_SIZE_INTL_SRAM = 32768;

  // INTERLEAVED
  for (genvar i = 0; i < NB_BANKS; i++) begin : CUTS
`ifndef PULP_FPGA_EMUL
    model_sram_32768x32 bank_i (
      .CLK   ( clk_i                                ),
      .RSTN  ( rst_ni                               ),
      .D     ( mem_slave[i].wdata                   ),
      .A     ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
      .CEN   ( mem_slave[i].csn                     ),
      .WEN   ( mem_slave[i].wen                     ),
      .BEN   ( ~mem_slave[i].be                     ),
      .Q     ( mem_slave[i].rdata                   )
    );
`else // !`ifndef PULP_FPGA_EMUL
    fpga_interleaved_ram #(
      .ADDR_WIDTH(MEM_ADDR_WIDTH)
    ) bank_i (
      .clk_i,
      .rst_ni,
      .csn_i(mem_slave[i].csn),
      .wen_i(mem_slave[i].wen),
      .be_i(mem_slave[i].be),
      .addr_i(mem_slave[i].add[MEM_ADDR_WIDTH-1:0]),
      .wdata_i(mem_slave[i].wdata),
      .rdata_o(mem_slave[i].rdata)
    );
`endif
  end

  // PRIVATE BANK1
`ifndef PULP_FPGA_EMUL
  generic_memory #(
    .ADDR_WIDTH ( MEM_ADDR_WIDTH_PRI  ),
    .DATA_WIDTH ( 32                  )
  ) bank_sram_pri1_i (
    .CLK   ( clk_i                      ),
    .INITN ( 1'b1                       ),
    .CEN   ( mem_pri_slave[1].csn       ),
    .BEN   ( ~mem_pri_slave[1].be       ),
    .WEN   ( mem_pri_slave[1].wen       ),
    .A     ( mem_pri_slave[1].add[MEM_ADDR_WIDTH_PRI-1:0] ),
    .D     ( mem_pri_slave[1].wdata     ),
    .Q     ( mem_pri_slave[1].rdata     )
  );
`else // !`ifndef PULP_FPGA_EMUL
  fpga_private_ram #(
    .ADDR_WIDTH(MEM_ADDR_WIDTH_PRI)
  ) bank_sram_pri1_i (
    .clk_i,
    .rst_ni,
    .csn_i(mem_pri_slave[1].csn),
    .wen_i(mem_pri_slave[1].wen),
    .be_i(mem_pri_slave[1].be),
    .addr_i(mem_pri_slave[1].add[MEM_ADDR_WIDTH-1:0]),
    .wdata_i(mem_pri_slave[1].wdata),
    .rdata_o(mem_pri_slave[1].rdata)
  );
`endif

  // PRIVATE BANK0
`ifndef PULP_FPGA_EMUL
  generic_memory #(
    .ADDR_WIDTH ( MEM_ADDR_WIDTH_PRI  ),
    .DATA_WIDTH ( 32                  )
  ) bank_sram_pri0_i (
    .CLK   ( clk_i                      ),
    .INITN ( 1'b1                       ),
    .CEN   ( mem_pri_slave[0].csn       ),
    .BEN   ( ~mem_pri_slave[0].be       ),
    .WEN   ( mem_pri_slave[0].wen       ),
    .A     ( mem_pri_slave[0].add[MEM_ADDR_WIDTH_PRI-1:0] ),
    .D     ( mem_pri_slave[0].wdata     ),
    .Q     ( mem_pri_slave[0].rdata     )
  );
`else // !`ifndef PULP_FPGA_EMUL
  fpga_private_ram #(
    .ADDR_WIDTH(MEM_ADDR_WIDTH_PRI)
  ) bank_sram_pri0_i (
    .clk_i,
    .rst_ni,
    .csn_i(mem_pri_slave[0].csn),
    .wen_i(mem_pri_slave[0].wen),
    .be_i(mem_pri_slave[0].be),
    .addr_i(mem_pri_slave[0].add[MEM_ADDR_WIDTH-1:0]),
    .wdata_i(mem_pri_slave[0].wdata),
    .rdata_o(mem_pri_slave[0].rdata)
  );
`endif

endmodule // l2_ram_multi_bank
