// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module counter #(
    parameter CNT_WIDTH = 10,
    parameter CNT_INIT  = 15
)
(
    input  logic                  clk_i,
    input  logic                  rstn_i,
    input  logic  [CNT_WIDTH-1:0] cfg_i,
    input  logic                  clear_i,
    output logic                  event_o
);

    logic [CNT_WIDTH-1:0] r_counter;

    assign event_o = (r_counter == 'h0);

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(rstn_i == 1'b0)
		begin
            r_counter <= CNT_INIT;
		end
		else
		begin
            if(clear_i)
                r_counter <= cfg_i;
            else if (r_counter == 'h0)
                r_counter <= cfg_i;
            else
                r_counter <= r_counter - 1;
		end
	end



endmodule
