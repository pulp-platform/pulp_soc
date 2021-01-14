// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


// 128 KiB SRAM bank
module model_sram_32768x32
(
    input  logic        CLK,
    input  logic        RSTN,

    input  logic        CEN,
    input  logic        WEN,
    input  logic  [3:0] BEN,
    input  logic [14:0] A,
    input  logic [31:0] D,
    output logic [31:0] Q
);
         logic [7:0]       CEN_int;
         logic             CEN_sram;
         logic [7:0][31:0] Q_int;

         logic  [2:0] muxsel;
         logic [31:0] BE_BW;

         logic [3:0]   BE;
         assign BE = ~BEN;

         assign BE_BW      = { {8{BE[3]}}, {8{BE[2]}}, {8{BE[1]}}, {8{BE[0]}} };


         assign CEN_int[0] = CEN |  A[14] |  A[13] |  A[12];
         assign CEN_int[1] = CEN |  A[14] |  A[13] | ~A[12];
         assign CEN_int[2] = CEN |  A[14] | ~A[13] |  A[12];
         assign CEN_int[3] = CEN |  A[14] | ~A[13] | ~A[12];
         assign CEN_int[4] = CEN | ~A[14] |  A[13] |  A[12];
         assign CEN_int[5] = CEN | ~A[14] |  A[13] | ~A[12];
         assign CEN_int[6] = CEN | ~A[14] | ~A[13] |  A[12];
         assign CEN_int[7] = CEN | ~A[14] | ~A[13] | ~A[12];

         assign Q = Q_int[muxsel];

         always_ff @(posedge CLK or negedge RSTN)
         begin
            if(~RSTN)
            begin
                muxsel <= '0;
            end
            else
            begin
                if(CEN == 1'b0)
                     muxsel <= A[14:12];
            end
         end

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_0 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[0]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[0]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_1 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[1]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[1]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_2 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[2]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[2]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_3 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[3]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[3]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_4 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[4]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[4]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_5 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[5]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[5]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_6 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[6]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[6]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
           ) cut_7 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[7]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[7]    )
         );

endmodule
