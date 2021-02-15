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
    input logic  sys_clk_i,  // 800 Mhz
    input logic  ref_clk_i,  // guaranteed 100 Mhz
    input logic  test_clk_i,
    input logic  rstn_glob_i,
    input logic  test_mode_i,
    input logic  sel_clk_i,
    input logic  shift_enable_i,

    output logic rstn_soc_sync_o,
    output logic rstn_cluster_sync_o,

    APB_BUS.Slave apb_slave,  // TODO: shrink

    output logic clk_soc_o,
    output logic clk_per_o,
    output logic clk_cluster_o,
    output logic clk_slow_o  // 32 Khz reference for timer
);

    logic s_clk_soc;
    logic s_clk_per;
    logic s_clk_cluster;
    logic s_clk_slow;

    logic s_clk_for_soc;
    logic s_clk_for_per;
    logic s_clk_for_cluster;

    logic s_rstn_soc;

    logic s_rstn_soc_sync;
    logic s_rstn_cluster_sync;

`ifndef SYNTHESIS
    //synopsys translate_off
    freq_meter #(.FLL_NAME("SOC_FLL"),     .MAX_SAMPLE(4096)) SOC_METER (.clk(s_clk_for_soc));
    freq_meter #(.FLL_NAME("PER_FLL"),     .MAX_SAMPLE(4096)) PER_METER (.clk(s_clk_for_per));
    freq_meter #(.FLL_NAME("CLUSTER_FLL"), .MAX_SAMPLE(4096)) CLUSTER_METER (.clk(s_clk_for_cluster));
    //synopsys translate_on
`endif


`ifndef SYNTHESIS
    assert property (@(posedge sys_clk_i)
        !(apb_slave.psel == 1'b1
         && apb_slave.penable == 1'b1
         && (apb_slave.paddr[11:0] >= 12'h0 && apb_slave.paddr[11:0] <= 12'h30)))
        else $info("[soc_clk_rst_gen]  %t - Detected legacy FLL program request", $time);
`endif

`ifndef PULP_FPGA_EMUL
    // global address map
    // CLK_CTRL_START_ADDR      32'h1A10_0000
    // CLK_CTRL_END_ADDR        32'h1A10_0FFF
    // register offsets
    // 12'f00 - soc clk div value
    // 12'f08 - cluster clk div value
    // 12'f10 - periph clk div value

    logic soc_div_access, soc_div_valid, soc_div_ready;
    logic cluster_div_access, cluster_div_valid, cluster_div_ready;
    logic periph_div_access, periph_div_valid, periph_div_ready;
    logic dummy_access;

    typedef enum logic [1:0] {
         IDLE, ACCESS, WRITE_ACK
    } state_e;

    state_e state_q, state_d;

    // address decoder
    always_comb begin
        soc_div_access = 1'b0;
        cluster_div_access = 1'b0;
        periph_div_access = 1'b0;

        dummy_access = 1'b0;

        if (apb_slave.psel && apb_slave.penable) begin
            unique case(apb_slave.paddr[11:0])
                12'hf00: soc_div_access = 1'b1;
                12'hf08: cluster_div_access = 1'b1;
                12'hf10: periph_div_access = 1'b1;
                default: dummy_access = 1'b1; // slverr is not supported so we
                                              // have to complete any write
                                              // request.
            endcase // unique case (apb_slave.paddr)
        end
    end


    // Combinatorial response from/to clock dividers
    //
    // The apb requests that are incoming are not fully apb compliant: they
    // raise penable concurrently with psel/pwrite/pwdata instead of delying it
    // by one cycle. This forces us to start or logic only when psel and penable
    // are concurrently asserted.
    always_comb begin
        soc_div_valid = 1'b0;
        cluster_div_valid = 1'b0;
        periph_div_valid = 1'b0;

        apb_slave.pready = 1'b0;

        state_d = state_q;

        unique case(state_q)
            IDLE: begin
                apb_slave.pready = 1'b0;

                if (soc_div_access || cluster_div_access || periph_div_access || dummy_access)
                    state_d = ACCESS;

                if (apb_slave.pwrite) begin
                    if (soc_div_access)
                        soc_div_valid = 1'b1;
                    if (cluster_div_access)
                        cluster_div_valid = 1'b1;
                    if (periph_div_access)
                        periph_div_valid = 1'b1;
                end
            end
            ACCESS: begin
                if (apb_slave.pwrite) begin
                    // handle writes
                    apb_slave.pready = 1'b0;

                    if (soc_div_access)
                        soc_div_valid = 1'b1;
                    if (cluster_div_access)
                        cluster_div_valid = 1'b1;
                    if (periph_div_access)
                        periph_div_valid = 1'b1;

                    if (soc_div_ready || cluster_div_ready || periph_div_ready || dummy_access)
                        state_d = WRITE_ACK;
                end else begin // if (apb_slave.pwrite)
                    // handle reads
                    apb_slave.pready = 1'b1;
                    state_d = IDLE;
                end
            end
            WRITE_ACK: begin
                apb_slave.pready = 1'b1;

                soc_div_valid = 1'b0;
                cluster_div_valid = 1'b0;
                periph_div_valid  = 1'b0;

                if (!apb_slave.penable) begin // deasserted at end of a transfer
                    apb_slave.pready = 1'b0;
                    state_d = IDLE;
                end
            end
            default:;
        endcase // unique case (state_q)
    end

    // We just return garbage data on read
    assign apb_slave.prdata = 32'hdeadda7a;

    // We don't support pslverr. At some point this should be routed to an
    // interrupt.
    assign apb_slave.pslverr = 1'b0;


    // sys_clk -> divider -> soc
    clock_divider #(
        .DIV_INIT   (0),
        .BYPASS_INIT(1)
    ) i_soc_clk_divider (
        .clk_i (sys_clk_i),
        .rstn_i (rstn_glob_i),
        .test_mode_i (test_mode_i),
        .clk_gate_async_i(1'b1), // TODO: maybe we can map this to reg
        .clk_div_data_i(apb_slave.pwdata[7:0]),
        .clk_div_valid_i(soc_div_valid),
        .clk_div_ack_o(soc_div_ready),
        .clk_o(s_clk_for_soc)
    );

    // sys_clk -> divider -> cluster
    clock_divider #(
        .DIV_INIT   (0),
        .BYPASS_INIT(1)
    ) i_cluster_clk_divider (
        .clk_i (sys_clk_i),
        .rstn_i (rstn_glob_i),
        .test_mode_i (test_mode_i),
        .clk_gate_async_i(1'b1), // TODO: maybe we map this to reg
        .clk_div_data_i(apb_slave.pwdata[7:0]),
        .clk_div_valid_i(cluster_div_valid),
        .clk_div_ack_o(cluster_div_ready),
        .clk_o(s_clk_for_cluster)
    );

    // ref_clk -> divider -> peripherals
    clock_divider #(
        .DIV_INIT   (0),
        .BYPASS_INIT(1)
    ) i_periph_clk_divider (
        .clk_i (ref_clk_i),
        .rstn_i (rstn_glob_i),
        .test_mode_i (test_mode_i),
        .clk_gate_async_i(1'b1), // TODO: maybe we map this to reg
        .clk_div_data_i(apb_slave.pwdata[7:0]), // 8 bit might not be enough for periph
        .clk_div_valid_i(periph_div_valid),
        .clk_div_ack_o(periph_div_ready),
        .clk_o(s_clk_for_per)
    );

    // ref_clk -> divider -> 32 Khz timer clock
    // fixed division by integer factor
    clk_div #(
        .RATIO (3125) // TODO: ADJUST RATIO to match ref clk
                      // 100 Mhz / 32 Khz = 3125
    ) i_clk_div_timer (
        .clk_i(ref_clk_i),
        .rst_ni(rstn_glob_i),
        .testmode_i(test_mode_i),
        .en_i(1'b1), // TODO: maybe we can map this to reg
        .clk_o(s_clk_slow)
    );

    always_ff @(posedge sys_clk_i, negedge rstn_glob_i) begin
        if (!rstn_glob_i) begin
            state_q <= IDLE;
        end else begin
            state_q <= state_d;
        end
    end

    pulp_clock_mux2 clk_mux_fll_soc_i (
`ifdef TEST_FLL
        .clk0_i    ( 1'bz           ),
`else
        .clk0_i    ( s_clk_for_soc  ),
`endif
        .clk1_i    ( ref_clk_i      ),
        .clk_sel_i ( sel_clk_i      ),
        .clk_o     ( s_clk_soc      )
    );

    pulp_clock_mux2 clk_mux_fll_per_i (
`ifdef TEST_FLL
        .clk0_i    ( 1'bz           ),
`else
        .clk0_i    ( s_clk_for_per  ),
`endif
        .clk1_i    ( ref_clk_i      ),
        .clk_sel_i ( sel_clk_i      ),
        .clk_o     ( s_clk_per      )
    );

    pulp_clock_mux2 clk_mux_fll_cluster_i (
`ifdef TEST_FLL
        .clk0_i    ( 1'bz               ),
`else
        .clk0_i    ( s_clk_for_cluster  ),
`endif
        .clk1_i    ( ref_clk_i          ),
        .clk_sel_i ( sel_clk_i          ),
        .clk_o     ( s_clk_cluster      )
    );

`else // !`ifndef PULP_FPGA_EMUL

    // Use FPGA dependent clock generation module for both clocks
    // For the FPGA port we remove the clock multiplexers since it doesn't make
    // much sense to clock the circuit directly with the board reference clock
    // (e.g. 200MHz for genesys2 board).

    fpga_clk_gen i_fpga_clk_gen (
        .ref_clk_i,
        .rstn_glob_i,
        .test_mode_i,
        .shift_enable_i,
        .soc_clk_o(s_clk_for_soc),
        .per_clk_o(s_clk_for_per),
        .cluster_clk_o(s_clk_cluster),
        .soc_cfg_lock_o(soc_fll_slave_lock_o),
        .soc_cfg_req_i(soc_fll_slave_req_i),
        .soc_cfg_ack_o(soc_fll_slave_ack_o),
        .soc_cfg_add_i(soc_fll_slave_add_i),
        .soc_cfg_data_i(soc_fll_slave_data_i),
        .soc_cfg_r_data_o(soc_fll_slave_r_data_o),
        .soc_cfg_wrn_i(soc_fll_slave_wrn_i),
        .per_cfg_lock_o(per_fll_slave_lock_o),
        .per_cfg_req_i(per_fll_slave_req_i),
        .per_cfg_ack_o(per_fll_slave_ack_o),
        .per_cfg_add_i(per_fll_slave_add_i),
        .per_cfg_data_i(per_fll_slave_data_i),
        .per_cfg_r_data_o(per_fll_slave_r_data_o),
        .per_cfg_wrn_i(per_fll_slave_wrn_i),
        .cluster_cfg_lock_o(cluster_fll_slave_lock_o),
        .cluster_cfg_req_i(cluster_fll_slave_req_i),
        .cluster_cfg_ack_o(cluster_fll_slave_ack_o),
        .cluster_cfg_add_i(cluster_fll_slave_add_i),
        .cluster_cfg_data_i(cluster_fll_slave_data_i),
        .cluster_cfg_r_data_o(cluster_fll_slave_r_data_o),
        .cluster_cfg_wrn_i(cluster_fll_slave_wrn_i)
    );

    //Don't use the supplied clock directly for the FPGA target. On some boards
    //the reference clock is a very fast (e.g. 200MHz) clock that cannot be used
    //directly as the "slow_clk". Therefore we slow it down if a FPGA/board
    //dependent module fpga_slow_clk_gen. Dividing the fast reference clock
    //internally instead of doing so in the toplevel prevents unecessary clock
    //division just to generate a faster clock once again in the SoC and
    //Peripheral clock PLLs in soc_domain.sv. Instead all PLL use directly the
    //board reference clock as input.

    fpga_slow_clk_gen i_slow_clk_gen (
        .rst_ni(s_rstn_sync),
        .ref_clk_i(ref_clk_i),
        .slow_clk_o(s_clk_slow)
    );


    assign s_clk_soc     = s_clk_for_soc;
    assign s_clk_cluster = s_clk_for_soc; //s_clk_fll_cluster
    assign s_clk_per     = s_clk_for_per;

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
    assign s_rstn_cluster_sync = s_rstn_soc;
`endif

    assign clk_soc_o       = s_clk_soc;
    assign clk_per_o       = s_clk_per;
    assign clk_cluster_o   = s_clk_cluster;
    assign clk_slow_o      = s_clk_slow;

    assign rstn_soc_sync_o = s_rstn_soc_sync;
    assign rstn_cluster_sync_o = s_rstn_cluster_sync;

endmodule

// Local Variables:
// verilog-cexp-indent: 4
// verilog-case-indent: 4
// verilog-indent-level-behavioral: 4
// verilog-indent-level-declaration: 4
// verilog-indent-level-module: 4
// verilog-indent-level: 4
// End:
