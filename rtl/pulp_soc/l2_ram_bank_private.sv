// Copyright 2021 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module l2_ram_bank_private #(
    parameter int unsigned BehavMem  = 1,
    parameter int unsigned FPGAMem   = 1,
    parameter int unsigned NumWords  = 0,
    parameter int unsigned DataWidth = 0
) (
    input logic clk_i,
    input logic rst_ni,
    input logic req_i,
    input logic we_i,
    input logic [$clog2(NumWords)-1:0] addr_i,
    input logic [DataWidth-1:0] wdata_i,
    input logic [((DataWidth+8-1)/8)-1:0] be_i,
    output logic [DataWidth-1:0] rdata_o
);

  if (BehavMem || FPGAMem) begin : l2_ram_pri_behav
    tc_sram #(
        .NumWords (NumWords),
        .DataWidth(DataWidth),
        .NumPorts (1)
    ) i_l2_ram_bank_pri_behav (
        .clk_i,
        .rst_ni,
        .req_i,
        .we_i,
        .addr_i,
        .wdata_i,
        .be_i,
        .rdata_o
    );
  end else begin : l2_ram_pri_macro  // block: l2_ram_pri_behav
    l2_sram_private_macro_wrap #(
        .NumWords (NumWords),
        .DataWidth(DataWidth)
    ) i_l2_ram_bank_pri_macro (
        .clk_i,
        .rst_ni,
        .req_i,
        .we_i,
        .addr_i,
        .wdata_i,
        .be_i,
        .rdata_o
    );

  end  // block: l2_ram_pri_macro

endmodule
