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

module soc_clk_rst_gen (
    input  logic        ref_clk_i,
    input  logic        test_clk_i,
`ifdef PULP_FPGA_EMUL
    input  logic        zynq_soc_clk_i,
    input  logic        zynq_per_clk_i,
`endif
    input  logic        rstn_glob_i,
    input  logic        test_mode_i,
    input  logic        sel_fll_clk_i,
    input  logic        shift_enable_i,
    input  logic        soc_fll_slave_req_i,
    input  logic        soc_fll_slave_wrn_i,
    input  logic [1:0]  soc_fll_slave_add_i,
    input  logic [31:0] soc_fll_slave_data_i,
    output logic        soc_fll_slave_ack_o,
    output logic [31:0] soc_fll_slave_r_data_o,
    output logic        soc_fll_slave_lock_o,

    input  logic        per_fll_slave_req_i,
    input  logic        per_fll_slave_wrn_i,
    input  logic [1:0]  per_fll_slave_add_i,
    input  logic [31:0] per_fll_slave_data_i,
    output logic        per_fll_slave_ack_o,
    output logic [31:0] per_fll_slave_r_data_o,
    output logic        per_fll_slave_lock_o,

    input  logic        cluster_fll_slave_req_i,
    input  logic        cluster_fll_slave_wrn_i,
    input  logic [1:0]  cluster_fll_slave_add_i,
    input  logic [31:0] cluster_fll_slave_data_i,
    output logic        cluster_fll_slave_ack_o,
    output logic [31:0] cluster_fll_slave_r_data_o,
    output logic        cluster_fll_slave_lock_o,

    output logic        rstn_soc_sync_o,
    output logic        rstn_cluster_sync_o,

    output logic        clk_soc_o,
    output logic        clk_per_o,
    output logic        clk_cluster_o
);

    logic s_clk_soc;
    logic s_clk_per;
    logic s_clk_cluster;

    logic s_clk_fll_soc;
    logic s_clk_fll_per;
    logic s_clk_fll_cluster;

    logic s_rstn_soc;

    logic s_rstn_soc_sync;
    logic s_rstn_cluster_sync;

    //synopsys translate_off
    freq_meter #(.FLL_NAME("SOC_FLL"),     .MAX_SAMPLE(4096)) SOC_METER (.clk(s_clk_fll_soc));
    freq_meter #(.FLL_NAME("PER_FLL"),     .MAX_SAMPLE(4096)) PER_METER (.clk(s_clk_fll_per));
    freq_meter #(.FLL_NAME("CLUSTER_FLL"), .MAX_SAMPLE(4096)) CLUSTER_METER (.clk(s_clk_fll_cluster));
    //synopsys translate_on

    // currently, FLLs are not supported for FPGA emulation
    `ifndef PULP_FPGA_EMUL
        gf22_FLL i_fll_soc
        (
            .FLLCLK ( s_clk_fll_soc            ),
            .FLLOE  ( 1'b1                     ),
            .REFCLK ( ref_clk_i                ),
            .LOCK   ( soc_fll_slave_lock_o     ),
            .CFGREQ ( soc_fll_slave_req_i      ),
            .CFGACK ( soc_fll_slave_ack_o      ),
            .CFGAD  ( soc_fll_slave_add_i[1:0] ),
            .CFGD   ( soc_fll_slave_data_i     ),
            .CFGQ   ( soc_fll_slave_r_data_o   ),
            .CFGWEB ( soc_fll_slave_wrn_i      ),
            .RSTB   ( rstn_glob_i              ),
            .PWD    ( 1'b0                     ),
            .RET    ( 1'b0                     ),
            .TM     ( test_mode_i              ),
            .TE     ( shift_enable_i           ),
            .TD     ( 1'b0                     ), //TO FIX DFT
            .TQ     (                          ), //TO FIX DFT
            .JTD    ( 1'b0                     ), //TO FIX DFT
            .JTQ    (                          )  //TO FIX DFT
        );

        gf22_FLL i_fll_per (
            .FLLCLK ( s_clk_fll_per            ),
            .FLLOE  ( 1'b1                     ),
            .REFCLK ( ref_clk_i                ),
            .LOCK   ( per_fll_slave_lock_o     ),
            .CFGREQ ( per_fll_slave_req_i      ),
            .CFGACK ( per_fll_slave_ack_o      ),
            .CFGAD  ( per_fll_slave_add_i[1:0] ),
            .CFGD   ( per_fll_slave_data_i     ),
            .CFGQ   ( per_fll_slave_r_data_o   ),
            .CFGWEB ( per_fll_slave_wrn_i      ),
            .RSTB   ( rstn_glob_i              ),
            .PWD    ( 1'b0                     ),
            .RET    ( 1'b0                     ),
            .TM     ( test_mode_i              ),
            .TE     ( shift_enable_i           ),
            .TD     ( 1'b0                     ), //TO FIX DFT
            .TQ     (                          ), //TO FIX DFT
            .JTD    ( 1'b0                     ), //TO FIX DFT
            .JTQ    (                          )  //TO FIX DFT
        );

        gf22_FLL i_fll_cluster (
            .FLLCLK ( s_clk_fll_cluster            ),
            .FLLOE  ( 1'b1                         ),
            .REFCLK ( ref_clk_i                    ),
            .LOCK   ( cluster_fll_slave_lock_o     ),
            .CFGREQ ( cluster_fll_slave_req_i      ),
            .CFGACK ( cluster_fll_slave_ack_o      ),
            .CFGAD  ( cluster_fll_slave_add_i[1:0] ),
            .CFGD   ( cluster_fll_slave_data_i     ),
            .CFGQ   ( cluster_fll_slave_r_data_o   ),
            .CFGWEB ( cluster_fll_slave_wrn_i      ),
            .RSTB   ( rstn_glob_i                  ),
            .PWD    ( 1'b0                         ),
            .RET    ( 1'b0                         ),
            .TM     ( test_mode_i                  ),
            .TE     ( shift_enable_i               ),
            .TD     ( 1'b0                         ), //TO FIX DFT
            .TQ     (                              ), //TO FIX DFT
            .JTD    ( 1'b0                         ), //TO FIX DFT
            .JTQ    (                              )  //TO FIX DFT
        );

        pulp_clock_mux2 clk_mux_fll_soc_i (
            `ifdef TEST_FLL
            .clk0_i    ( 1'bz           ),
            `else
            .clk0_i    ( s_clk_fll_soc  ),
            `endif
            .clk1_i    ( ref_clk_i      ),
            .clk_sel_i ( sel_fll_clk_i  ),
            .clk_o     ( s_clk_soc      )
        );

        pulp_clock_mux2 clk_mux_fll_per_i (
            `ifdef TEST_FLL
            .clk0_i    ( 1'bz           ),
            `else
            .clk0_i    ( s_clk_fll_per  ),
            `endif
            .clk1_i    ( ref_clk_i      ),
            .clk_sel_i ( sel_fll_clk_i  ),
            .clk_o     ( s_clk_per      )
        );

        pulp_clock_mux2 clk_mux_fll_cluster_i (
            `ifdef TEST_FLL
            .clk0_i    ( 1'bz               ),
            `else
            .clk0_i    ( s_clk_fll_cluster  ),
            `endif
            .clk1_i    ( ref_clk_i          ),
            .clk_sel_i ( sel_fll_clk_i      ),
            .clk_o     ( s_clk_cluster      )
        );
    `else
        assign s_clk_fll_soc          = zynq_soc_clk_i;
        assign soc_fll_slave_lock_o   = '1;
        assign soc_fll_slave_ack_o    = '1;
        assign soc_fll_slave_r_data_o = '0;

        assign s_clk_fll_per          = zynq_per_clk_i;
        assign per_fll_slave_lock_o   = '1;
        assign per_fll_slave_ack_o    = '1;
        assign per_fll_slave_r_data_o = '0;
    `endif

    assign s_rstn_soc = rstn_glob_i;

    `ifndef PULP_FPGA_EMUL

        rstgen i_soc_rstgen (
            .clk_i       ( clk_soc_o       ),
            .rst_ni      ( s_rstn_soc      ),

            .test_mode_i ( test_mode_i     ),

            .rst_no      ( s_rstn_soc_sync ), //to be used by logic clocked with ref clock in AO domain
            .init_no     (                 )                    //not used
        );
    `else
        assign s_rstn_soc_sync = s_rstn_soc;
    `endif


    `ifndef PULP_FPGA_EMUL
        rstgen i_cluster_rstgen (
            .clk_i       ( clk_cluster_o       ),
            .rst_ni      ( s_rstn_soc          ),

            .test_mode_i ( test_mode_i         ),

            .rst_no      ( s_rstn_cluster_sync ), //to be used by logic clocked with ref clock in AO domain
            .init_no     (                     )                    //not used
        );
    `else
        assign s_rstn_soc_sync = s_rstn_soc;
    `endif

    assign clk_soc_o       = s_clk_soc;
    assign clk_per_o       = s_clk_per;
    assign clk_cluster_o   = s_clk_cluster;

    assign rstn_soc_sync_o = s_rstn_soc_sync;
    assign rstn_cluster_sync_o = s_rstn_cluster_sync;

    `ifdef DO_NOT_USE_FLL
        assert property (
            @(posedge clk) (soc_fll_slave_req_i == 1'b0 && per_fll_slave_req_i == 1'b0)  ) else $display("There should be no FLL request (%t)", $time);
    `endif


endmodule
