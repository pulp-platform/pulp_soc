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
   parameter NB_BANKS                   = 4,
   parameter NB_BANKS_PRI               = 2,
   parameter BANK_SIZE                  = 29184,
   parameter MEM_ADDR_WIDTH             = 14,
   parameter MEM_ADDR_WIDTH_PRI         = 13
) (
   input logic             clk_i,
   input logic             rst_ni,
   input logic             init_ni,
   input logic             test_mode_i,
   UNICAD_MEM_BUS_32.Slave mem_slave[NB_BANKS-1:0],
   UNICAD_MEM_BUS_32.Slave mem_pri_slave[NB_BANKS_PRI-1:0],
   UNICAD_MEM_BUS_32.Slave scm_data_slave,
   UNICAD_MEM_BUS_32.Slave scm_instr_slave
);
   //Used in testbenches
   localparam  BANK_SIZE_PRI1       = 8192;
   localparam  BANK_SIZE_PRI0_SRAM  = 6144;
   localparam  BANK_SIZE_PRI0_SCM   = 2048;

   localparam  BANK_SIZE_INTL_SRAM  = 28672;
   localparam  BANK_SIZE_INTL_SCM   = 512;


   //use xilinx ips for l2 memories when on fpga !!NOTE: ONLY BANK_SIZE=8192 IS IMPLEMENTED!!
   `ifdef PULP_FPGA_EMUL

      logic [NB_BANKS-1:0][7:0]   wea;

      genvar                      i,j;
      generate
         for(i=0; i<NB_BANKS; i++)
         begin : CUTS
            for(j=0; j<8; j++)
            assign wea[i][j] = ~mem_slave[i].csn & ~mem_slave[i].wen & mem_slave[i].be[j];

            xilinx_l2_mem_8192x64 l2_mem_i (
               .clka  ( clk_i                                ),
               .rsta  ( ~rst_ni                              ),
               .ena   ( ~mem_slave[i].csn                    ),
               .wea   ( wea[i]                               ),
               .addra ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
               .dina  ( mem_slave[i].wdata                   ),
               .douta ( mem_slave[i].rdata                   )
            );
         end
      endgenerate

      //otherwise generate banks as usual
   `else

      genvar i,j;
      generate

         //INTERLEAVED
         for(i=0; i<NB_BANKS; i++)
         begin : CUTS
            `ifdef SYNTHESIS
            case (BANK_SIZE)

               32768:
               begin : bank_gen
                  l2_mem_bank_32768x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end

               29184:
               begin : bank_gen
                  l2_mem_bank_sram_28672x32_scm_512x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end

               28672:
               begin : bank_gen
                  l2_mem_bank_sram_28672x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end

               16384:
               begin : bank_gen
                  l2_mem_bank_16384x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end


               12288:
               begin : bank_gen
                  l2_mem_bank_12288x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end

               8192:
               begin : bank_gen
                  l2_mem_bank_8192x32 bank_i (
                     .CLK  ( clk_i                                ),
                     .RSTN ( rst_ni                               ),
                     .CEN  ( mem_slave[i].csn                     ),
                     .BEN  ( ~mem_slave[i].be                     ),
                     .WEN  ( mem_slave[i].wen                     ),
                     .A    ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .D    ( mem_slave[i].wdata                   ),
                     .Q    ( mem_slave[i].rdata                   )
                  );
               end
            endcase
            `else //~SYNTHESIS
            /*
               This model the hybrid SRAM and SCM configuration
               that has been tape-out.
            */
                  model_sram_28672x32_scm_512x32 bank_i (
                     .CLK   ( clk_i                                ),
		     .RSTN  ( rst_ni                               ),
                     .D     ( mem_slave[i].wdata                   ),
                     .A     ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .CEN   ( mem_slave[i].csn                     ),
                     .WEN   ( mem_slave[i].wen                     ),
                     .BEN   ( ~mem_slave[i].be                     ),
                     .Q     ( mem_slave[i].rdata                   )
                  );
            `endif
         end
      endgenerate

      /*
      As the PRI Banks are divided in SCM and SRAM,
      a demux from the interconnect is needed.
      The 8 KWord (32 KByte) Bank is
      divided in 4Kword + 2Kword + 2Kword (16 Kbyte + 8 Kbyte + 8 Kbyte)
      The first 2 Kword (address 0 to 2047) are for the SCM
      */

      // PRIVATE BANKS
      `ifdef SYNTHESIS
      l2_mem_bank_8192x32 bank_sram_pri1_i (
         .CLK  ( clk_i                      ),
         .RSTN ( rst_ni                     ),
         .CEN  ( mem_pri_slave[1].csn       ),
         .BEN  ( ~mem_pri_slave[1].be       ),
         .WEN  ( mem_pri_slave[1].wen       ),
         .A    ( mem_pri_slave[1].add[MEM_ADDR_WIDTH_PRI-1:0] ),
         .D    ( mem_pri_slave[1].wdata     ),
         .Q    ( mem_pri_slave[1].rdata     )
      );

      l2_mem_bank_6144x32_2048x32scm bank_sram24k_scm8k_pri0_i (
         .CLK      ( clk_i                      ),
         .RSTN     ( rst_ni                     ),
         .CEN      ( mem_pri_slave[0].csn       ),
         .CEN_scm0 ( scm_data_slave.csn         ),
         .CEN_scm1 ( scm_instr_slave.csn        ),

         .BEN      ( ~mem_pri_slave[0].be       ),
         .BEN_scm0 ( ~scm_data_slave.be         ),
         .WEN      ( mem_pri_slave[0].wen       ),
         .WEN_scm0 ( scm_data_slave.wen         ),
         .WEN_scm1 ( scm_instr_slave.wen        ),

         .A        ( mem_pri_slave[0].add[MEM_ADDR_WIDTH_PRI-1:0] ),
         .A_scm0   ( scm_data_slave.add[MEM_ADDR_WIDTH_PRI-1:2]   ),
         .A_scm1   ( scm_instr_slave.add[MEM_ADDR_WIDTH_PRI-1:2]  ),

         .D        ( mem_pri_slave[0].wdata     ),
         .D_scm0   ( scm_data_slave.wdata       ),

         .Q        ( mem_pri_slave[0].rdata     ),
         .Q_scm0   ( scm_data_slave.rdata       ),
         .Q_scm1   ( scm_instr_slave.rdata      )
      );
      `else //~SYNTHESIS
      /*
         This model the hybrid SRAM and SCM configuration
         that has been tape-out.
      */
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

      model_6144x32_2048x32scm bank_sram24k_scm8k_pri0_i (
         .CLK      ( clk_i                      ),
         .RSTN     ( rst_ni                     ),
         .CEN      ( mem_pri_slave[0].csn       ),
         .CEN_scm0 ( scm_data_slave.csn         ),
         .CEN_scm1 ( scm_instr_slave.csn        ),

         .BEN      ( ~mem_pri_slave[0].be       ),
         .BEN_scm0 ( ~scm_data_slave.be         ),
         .WEN      ( mem_pri_slave[0].wen       ),
         .WEN_scm0 ( scm_data_slave.wen         ),
         .WEN_scm1 ( scm_instr_slave.wen        ),

         .A        ( mem_pri_slave[0].add[MEM_ADDR_WIDTH_PRI-1:0] ),
         .A_scm0   ( scm_data_slave.add[MEM_ADDR_WIDTH_PRI-1:2]   ),
         .A_scm1   ( scm_instr_slave.add[MEM_ADDR_WIDTH_PRI-1:2]  ),

         .D        ( mem_pri_slave[0].wdata     ),
         .D_scm0   ( scm_data_slave.wdata       ),

         .Q        ( mem_pri_slave[0].rdata     ),
         .Q_scm0   ( scm_data_slave.rdata       ),
         .Q_scm1   ( scm_instr_slave.rdata      )
      );

      `endif

   `endif

endmodule // l2_ram_multi_bank
