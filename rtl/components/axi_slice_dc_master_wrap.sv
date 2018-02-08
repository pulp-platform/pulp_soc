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

module axi_slice_dc_master_wrap
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_ID_WIDTH   = 6,
    parameter BUFFER_WIDTH   = 8
    )
   (
    input logic          clk_i,
    input logic          rst_ni,
    input logic          test_cgbypass_i,

    input  logic         clock_down_i,
    input  logic         isolate_i,
    output logic         incoming_req_o,

    AXI_BUS_ASYNC.Slave  axi_slave_async,

    AXI_BUS.Master       axi_master
    );

   logic s_aw_valid;
   logic s_w_valid;
   logic s_ar_valid;
   logic s_aw_ready;
   logic s_ar_ready;
   logic s_r_ready;
   logic s_b_ready;

   assign incoming_req_o = s_aw_valid | s_ar_valid;
   assign s_aw_ready = ~clock_down_i & axi_master.aw_ready;
   assign s_ar_ready = ~clock_down_i & axi_master.ar_ready;
   assign axi_master.aw_valid = ~isolate_i & ~clock_down_i & s_aw_valid;
   assign axi_master.w_valid  = ~isolate_i & ~clock_down_i & s_w_valid;
   assign axi_master.ar_valid = ~isolate_i & ~clock_down_i & s_ar_valid;
   assign axi_master.r_ready  = isolate_i | s_r_ready;
   assign axi_master.b_ready  = isolate_i | s_b_ready;

   axi_slice_dc_master
     #(
       .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
       .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
       .AXI_USER_WIDTH ( AXI_USER_WIDTH ),
       .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
       .BUFFER_WIDTH   ( BUFFER_WIDTH   )
       )
   axi_slice_i
     (
      .clk_i                    ( clk_i                                   ),
      .rst_ni                   ( rst_ni                                  ),

      .test_cgbypass_i          ( test_cgbypass_i                         ),
      .axi_slave_aw_addr        ( axi_slave_async.aw_addr                 ),
      .axi_slave_aw_prot        ( axi_slave_async.aw_prot                 ),
      .axi_slave_aw_region      ( axi_slave_async.aw_region               ),
      .axi_slave_aw_len         ( axi_slave_async.aw_len                  ),
      .axi_slave_aw_size        ( axi_slave_async.aw_size                 ),
      .axi_slave_aw_burst       ( axi_slave_async.aw_burst                ),
      .axi_slave_aw_lock        ( axi_slave_async.aw_lock                 ),
      .axi_slave_aw_cache       ( axi_slave_async.aw_cache                ),
      .axi_slave_aw_qos         ( axi_slave_async.aw_qos                  ),
      .axi_slave_aw_id          ( axi_slave_async.aw_id[AXI_ID_WIDTH-1:0] ),
      .axi_slave_aw_user        ( axi_slave_async.aw_user                 ),
      .axi_slave_aw_writetoken  ( axi_slave_async.aw_writetoken           ),
      .axi_slave_aw_readpointer ( axi_slave_async.aw_readpointer          ),

      .axi_slave_ar_addr        ( axi_slave_async.ar_addr                 ),
      .axi_slave_ar_prot        ( axi_slave_async.ar_prot                 ),
      .axi_slave_ar_region      ( axi_slave_async.ar_region               ),
      .axi_slave_ar_len         ( axi_slave_async.ar_len                  ),
      .axi_slave_ar_size        ( axi_slave_async.ar_size                 ),
      .axi_slave_ar_burst       ( axi_slave_async.ar_burst                ),
      .axi_slave_ar_lock        ( axi_slave_async.ar_lock                 ),
      .axi_slave_ar_cache       ( axi_slave_async.ar_cache                ),
      .axi_slave_ar_qos         ( axi_slave_async.ar_qos                  ),
      .axi_slave_ar_id          ( axi_slave_async.ar_id[AXI_ID_WIDTH-1:0] ),
      .axi_slave_ar_user        ( axi_slave_async.ar_user                 ),
      .axi_slave_ar_writetoken  ( axi_slave_async.ar_writetoken           ),
      .axi_slave_ar_readpointer ( axi_slave_async.ar_readpointer          ),

      .axi_slave_w_data         ( axi_slave_async.w_data                  ),
      .axi_slave_w_strb         ( axi_slave_async.w_strb                  ),
      .axi_slave_w_user         ( axi_slave_async.w_user                  ),
      .axi_slave_w_last         ( axi_slave_async.w_last                  ),
      .axi_slave_w_writetoken   ( axi_slave_async.w_writetoken            ),
      .axi_slave_w_readpointer  ( axi_slave_async.w_readpointer           ),

      .axi_slave_r_data         ( axi_slave_async.r_data                  ),
      .axi_slave_r_resp         ( axi_slave_async.r_resp                  ),
      .axi_slave_r_last         ( axi_slave_async.r_last                  ),
      .axi_slave_r_id           ( axi_slave_async.r_id[AXI_ID_WIDTH-1:0]  ),
      .axi_slave_r_user         ( axi_slave_async.r_user                  ),
      .axi_slave_r_writetoken   ( axi_slave_async.r_writetoken            ),
      .axi_slave_r_readpointer  ( axi_slave_async.r_readpointer           ),

      .axi_slave_b_resp         ( axi_slave_async.b_resp                  ),
      .axi_slave_b_id           ( axi_slave_async.b_id[AXI_ID_WIDTH-1:0]  ),
      .axi_slave_b_user         ( axi_slave_async.b_user                  ),
      .axi_slave_b_writetoken   ( axi_slave_async.b_writetoken            ),
      .axi_slave_b_readpointer  ( axi_slave_async.b_readpointer           ),

      .axi_master_aw_valid      ( s_aw_valid                              ),
      .axi_master_aw_ready      ( s_aw_ready                              ),
      .axi_master_aw_addr       ( axi_master.aw_addr                      ),
      .axi_master_aw_prot       ( axi_master.aw_prot                      ),
      .axi_master_aw_region     ( axi_master.aw_region                    ),
      .axi_master_aw_len        ( axi_master.aw_len                       ),
      .axi_master_aw_size       ( axi_master.aw_size                      ),
      .axi_master_aw_burst      ( axi_master.aw_burst                     ),
      .axi_master_aw_lock       ( axi_master.aw_lock                      ),
      .axi_master_aw_cache      ( axi_master.aw_cache                     ),
      .axi_master_aw_qos        ( axi_master.aw_qos                       ),
      .axi_master_aw_id         ( axi_master.aw_id[AXI_ID_WIDTH-1:0]      ),
      .axi_master_aw_user       ( axi_master.aw_user                      ),

      .axi_master_ar_valid      ( s_ar_valid                              ),
      .axi_master_ar_ready      ( s_ar_ready                              ),
      .axi_master_ar_addr       ( axi_master.ar_addr                      ),
      .axi_master_ar_prot       ( axi_master.ar_prot                      ),
      .axi_master_ar_region     ( axi_master.ar_region                    ),
      .axi_master_ar_len        ( axi_master.ar_len                       ),
      .axi_master_ar_size       ( axi_master.ar_size                      ),
      .axi_master_ar_burst      ( axi_master.ar_burst                     ),
      .axi_master_ar_lock       ( axi_master.ar_lock                      ),
      .axi_master_ar_cache      ( axi_master.ar_cache                     ),
      .axi_master_ar_qos        ( axi_master.ar_qos                       ),
      .axi_master_ar_id         ( axi_master.ar_id[AXI_ID_WIDTH-1:0]      ),
      .axi_master_ar_user       ( axi_master.ar_user                      ),

      .axi_master_w_valid       ( s_w_valid                               ),
      .axi_master_w_ready       ( axi_master.w_ready                      ),
      .axi_master_w_data        ( axi_master.w_data                       ),
      .axi_master_w_strb        ( axi_master.w_strb                       ),
      .axi_master_w_user        ( axi_master.w_user                       ),
      .axi_master_w_last        ( axi_master.w_last                       ),

      .axi_master_r_valid       ( axi_master.r_valid                      ),
      .axi_master_r_ready       ( s_r_ready                               ),
      .axi_master_r_data        ( axi_master.r_data                       ),
      .axi_master_r_resp        ( axi_master.r_resp                       ),
      .axi_master_r_last        ( axi_master.r_last                       ),
      .axi_master_r_id          ( axi_master.r_id[AXI_ID_WIDTH-1:0]       ),
      .axi_master_r_user        ( axi_master.r_user                       ),

      .axi_master_b_valid       ( axi_master.b_valid                      ),
      .axi_master_b_ready       ( s_b_ready                               ),
      .axi_master_b_resp        ( axi_master.b_resp                       ),
      .axi_master_b_id          ( axi_master.b_id[AXI_ID_WIDTH-1:0]       ),
      .axi_master_b_user        ( axi_master.b_user                       )
      );

endmodule
