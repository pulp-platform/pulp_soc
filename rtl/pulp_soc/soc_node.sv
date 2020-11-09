// Copyright 2019 ETH Zurich and University of Bologna.
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Author: Robert Balas (balasr@iis.ee.ethz.ch)

`include "axi_soc_node_defines.sv"
`include "cluster_bus_defines.sv"
`include "axi/assign.svh"

package automatic soc_node_pkg;

  localparam int unsigned N_SLAVES_EXT = `AXI_SOC_NODE_SLAVES_EXT; // 4
  localparam int unsigned N_MASTERS_EXT = `AXI_SOC_NODE_MASTERS_EXT; // 1

  localparam int unsigned N_SLAVES_SOC = `AXI_SOC_NODE_SLAVES_SOC;
  localparam int unsigned N_MASTERS_SOC = `AXI_SOC_NODE_MASTERS_SOC;

  // SoC peripherals + l2 map from the point of view of nocr07, c07 and sms (external)
  localparam logic [31:0] SOC_EXT_VIEW_START_ADDR = `MASTER_2_START_ADDR; // 32'h1A00_0000
  localparam logic [31:0] SOC_EXT_VIEW_END_ADDR = `MASTER_2_END_ADDR; // 32'h1FFF_FFFF

  // c07 and nocr07 from the viewpoint of the soc
  localparam logic [31:0] C07_SOC_VIEW_START_ADDR = `AXI_SOC_NODE_C07_START_ADDR; // 32'h2000_0000
  localparam logic [31:0] C07_SOC_VIEW_END_ADDR = `AXI_SOC_NODE_C07_END_ADDR; // 32'h3FFF_FFFF

  localparam logic [31:0] NOCR07_SOC_VIEW_START_ADDR = `AXI_SOC_NODE_NOCR07_START_ADDR; // 32'h4000_0000
  localparam logic [31:0] NOCR07_SOC_VIEW_END_ADDR = `AXI_SOC_NODE_NOCR07_END_ADDR; // 32'hFFFF_FFFF

  // localparam int unsigned AXI_SOC_NODE_AW = 32;
  // localparam int unsigned AXI_SOC_NODE_DW = 64;
  // localparam int unsigned AXI_SOC_NODE_UW = 6;
  // localparam int unsigned AXI_SOC_NODE_IW_INP = 6;
  // localparam int unsigned AXI_SOC_NODE_IW_OUP = AXI_SOC_NODE_IW_INP + $clog2(N_SLAVES_EXT);

  function int unsigned axi_iw_oup_ext(input int unsigned axi_iw);
    return axi_iw + $clog2(N_SLAVES_EXT);
  endfunction // axi_iw_oup

  function int unsigned axi_iw_oup_soc(input int unsigned axi_iw);
    return axi_iw + $clog2(N_SLAVES_SOC);
  endfunction // axi_iw_oup

endpackage // soc_node_pkg

module soc_node #(
  parameter int unsigned AXI_ID_INP_WIDTH_SOC = 0,
  parameter int unsigned AXI_ID_OUP_WIDTH_SOC = 0,
  parameter int unsigned AXI_USER_WIDTH_SOC = 0,
  parameter int unsigned AXI_STRB_WIDTH_SOC = 0,
  parameter int unsigned AXI_ADDR_WIDTH_SOC = 0,
  parameter int unsigned AXI_DATA_WIDTH_SOC = 0,

  parameter int unsigned AXI_ID_INP_WIDTH_CLUSTER = 0,
  parameter int unsigned AXI_ID_OUP_WIDTH_CLUSTER = 0,
  parameter int unsigned AXI_USER_WIDTH_CLUSTER = 0,
  parameter int unsigned AXI_STRB_WIDTH_CLUSTER = 0,
  parameter int unsigned AXI_ADDR_WIDTH_CLUSTER = 0,
  parameter int unsigned AXI_DATA_WIDTH_CLUSTER = 0,

  parameter int unsigned AXI_ID_INP_WIDTH_C07 = 0,
  parameter int unsigned AXI_ID_OUP_WIDTH_C07 = 0,
  parameter int unsigned AXI_USER_WIDTH_C07 = 0,
  parameter int unsigned AXI_STRB_WIDTH_C07 = 0,
  parameter int unsigned AXI_ADDR_WIDTH_C07 = 0,
  parameter int unsigned AXI_DATA_WIDTH_C07 = 0,

  parameter int unsigned AXI_ID_INP_WIDTH_NOCR07 = 0,
  parameter int unsigned AXI_ID_OUP_WIDTH_NOCR07 = 0,
  parameter int unsigned AXI_USER_WIDTH_NOCR07 = 0,
  parameter int unsigned AXI_STRB_WIDTH_NOCR07 = 0,
  parameter int unsigned AXI_ADDR_WIDTH_NOCR07 = 0,
  parameter int unsigned AXI_DATA_WIDTH_NOCR07 = 0,

  parameter int unsigned AXI_ID_INP_WIDTH_SMS = 0,
  parameter int unsigned AXI_USER_WIDTH_SMS = 0,
  parameter int unsigned AXI_STRB_WIDTH_SMS = 0,
  parameter int unsigned AXI_ADDR_WIDTH_SMS = 0,
  parameter int unsigned AXI_DATA_WIDTH_SMS = 0,

  parameter int unsigned AXI_AW = 0, // [bit]
  parameter int unsigned AXI_DW = 0, // [bit]
  parameter int unsigned AXI_UW = 0, // [bit]
  parameter int unsigned AXI_IW_INP_EXT = 0, // [bit]
  parameter int unsigned AXI_IW_INP_SOC = 0, // [bit]
  // parameter int unsigned AXI_IW_OUP = 0, // [bit]
  parameter int unsigned MST_SLICE_DEPTH = 0,
  parameter int unsigned SLV_SLICE_DEPTH = 0
) (
  input  logic   clk_i,
  input  logic   rst_ni,
  AXI_BUS.Slave  cl_slv,
  AXI_BUS.Slave  soc_slv,
  AXI_BUS.Master soc_mst,
  AXI_BUS.Slave  c07_slv,
  AXI_BUS.Master c07_mst,
  AXI_BUS.Slave  nocr07_slv,
  AXI_BUS.Master nocr07_mst,
  AXI_BUS.Slave  sms_slv
);

  localparam int unsigned N_REGIONS = 1;

  // for axi xbar that maps c07, nocr07, sms master to soc
  localparam int unsigned IDX_SOC = 0;

  // for axi xbar that maps soc master to c07, nocr07
  localparam int unsigned IDX_C07 = 0;
  localparam int unsigned IDX_NOCR07 = 1;

  typedef logic [AXI_AW-1:0] addr_t;

  addr_t  [N_REGIONS-1:0][soc_node_pkg::N_MASTERS_EXT-1:0]  ext_view_start_addr,
                                                            ext_view_end_addr;
  addr_t  [N_REGIONS-1:0][soc_node_pkg::N_MASTERS_SOC-1:0]  soc_view_start_addr,
                                                            soc_view_end_addr;

  // logic   [N_REGIONS-1:0][soc_node_pkg::N_MASTERS_EXT-1:0]  valid_rule;

  // output axi id width after xbar
  localparam AXI_IW_OUP_EXT = soc_node_pkg::axi_iw_oup_ext(AXI_IW_INP_EXT);
  localparam AXI_IW_OUP_SOC = soc_node_pkg::axi_iw_oup_soc(AXI_IW_INP_SOC);

  // sanity checks: assert axi id widths
`define ELAB_ASSERT_AXI_ID(node, direction, name)                                          \
  if (AXI_IW_``direction``_``node`` != AXI_ID_``direction``_WIDTH_``name``)                \
    $fatal(0, `"AXI address id width mismatch soc_node: %s, %0d, name: %0d`",              \
            `"node`", AXI_IW_``direction``_``node``, AXI_ID_``direction``_WIDTH_``name``); \

  `ELAB_ASSERT_AXI_ID(EXT,INP,CLUSTER)
  `ELAB_ASSERT_AXI_ID(EXT,INP,C07)
  `ELAB_ASSERT_AXI_ID(EXT,INP,NOCR07)
  `ELAB_ASSERT_AXI_ID(EXT,INP,SMS)
  `ELAB_ASSERT_AXI_ID(EXT,OUP,SOC)

  `ELAB_ASSERT_AXI_ID(SOC,INP,SOC)
  `ELAB_ASSERT_AXI_ID(SOC,OUP,C07)
  `ELAB_ASSERT_AXI_ID(SOC,OUP,NOCR07)

  // axi xbar c07, nocr07, sms, cluster(!) -> soc (l2, periphs)
  // master slave buses
  AXI_BUS #(
    .AXI_ADDR_WIDTH (AXI_AW),
    .AXI_DATA_WIDTH (AXI_DW),
    .AXI_ID_WIDTH   (AXI_IW_OUP_EXT),
    .AXI_USER_WIDTH (AXI_UW)
  ) ext_to_soc_masters [soc_node_pkg::N_MASTERS_EXT-1:0]();

  AXI_BUS #(
    .AXI_ADDR_WIDTH (AXI_AW),
    .AXI_DATA_WIDTH (AXI_DW),
    .AXI_ID_WIDTH   (AXI_IW_INP_EXT),
    .AXI_USER_WIDTH (AXI_UW)
  ) ext_to_soc_slaves [soc_node_pkg::N_SLAVES_EXT-1:0]();

  `AXI_ASSIGN(soc_mst, ext_to_soc_masters[IDX_SOC]);

  `AXI_ASSIGN(ext_to_soc_slaves[0], c07_slv);
  `AXI_ASSIGN(ext_to_soc_slaves[1], nocr07_slv);
  `AXI_ASSIGN(ext_to_soc_slaves[2], sms_slv);
  `AXI_ASSIGN(ext_to_soc_slaves[3], cl_slv);

  // axi xbar soc -> c07, nocr07
  // master slave buses
  AXI_BUS #(
    .AXI_ADDR_WIDTH (AXI_AW),
    .AXI_DATA_WIDTH (AXI_DW),
    .AXI_ID_WIDTH   (AXI_IW_OUP_SOC),
    .AXI_USER_WIDTH (AXI_UW)
  ) soc_to_ext_masters [soc_node_pkg::N_MASTERS_SOC-1:0]();

  AXI_BUS #(
    .AXI_ADDR_WIDTH (AXI_AW),
    .AXI_DATA_WIDTH (AXI_DW),
    .AXI_ID_WIDTH   (AXI_IW_INP_SOC),
    .AXI_USER_WIDTH (AXI_UW)
  ) soc_to_ext_slaves [soc_node_pkg::N_SLAVES_SOC-1:0]();

  AXI_BUS #(
    .AXI_ADDR_WIDTH (AXI_AW),
    .AXI_DATA_WIDTH (AXI_DW),
    .AXI_ID_WIDTH   (AXI_IW_INP_SOC),
    .AXI_USER_WIDTH (AXI_UW)
  ) dummy_slv (); // additional input to xbar because xbar limitations

  `AXI_ASSIGN(c07_mst, soc_to_ext_masters[IDX_C07]);
  `AXI_ASSIGN(nocr07_mst, soc_to_ext_masters[IDX_NOCR07]);

  `AXI_ASSIGN(soc_to_ext_slaves[0], soc_slv);
  `AXI_ASSIGN(soc_to_ext_slaves[1], dummy_slv);

  // Address Map External View
  always_comb begin
    ext_view_start_addr  = '0;
    ext_view_end_addr    = '0;

    // to SoC
    ext_view_start_addr[0][IDX_SOC] = soc_node_pkg::SOC_EXT_VIEW_START_ADDR;
    ext_view_end_addr[0][IDX_SOC]   = soc_node_pkg::SOC_EXT_VIEW_END_ADDR;
    // valid_rule[0][IDX_SOC] = 1'b1;
  end

  // Address Map SoC View
  always_comb begin
    soc_view_start_addr = '0;
    soc_view_end_addr   = '0;

    // to c07
    soc_view_start_addr[0][IDX_C07] = soc_node_pkg::C07_SOC_VIEW_START_ADDR;
    soc_view_end_addr[0][IDX_C07]   = soc_node_pkg::C07_SOC_VIEW_END_ADDR; // NOTE: arbitrarily assigned this range
    // valid_rule[0][IDX_C07] = 1'b1;

    // to NoCr07
    soc_view_start_addr[0][IDX_NOCR07] = soc_node_pkg::NOCR07_SOC_VIEW_START_ADDR;
    soc_view_end_addr[0][IDX_NOCR07]   = soc_node_pkg::NOCR07_SOC_VIEW_END_ADDR; // NOTE: map everything else to global memory
    // valid_rule[0][IDX_NOCR07] = 1'b1;

  end

  // TODO: we use a version that doesn't support region or valid rules. For that
  // we would have to go to the atop branch

  // axi xbar c07, nocr07, sms, cluster (!) -> soc (l2, periphs)
  // external and cluster to soc
  axi_node_wrap_with_slices #(
    .NB_MASTER          (soc_node_pkg::N_MASTERS_EXT),
    .NB_SLAVE           (soc_node_pkg::N_SLAVES_EXT),
    // .NB_REGION          (N_REGIONS),
    .AXI_ADDR_WIDTH     (AXI_AW),
    .AXI_DATA_WIDTH     (AXI_DW),
    .AXI_ID_WIDTH       (AXI_IW_INP_EXT),
    .AXI_USER_WIDTH     (AXI_UW),
    .MASTER_SLICE_DEPTH (MST_SLICE_DEPTH),
    .SLAVE_SLICE_DEPTH  (SLV_SLICE_DEPTH)
  ) i_axi_node_ext_to_soc (
    .clk          (clk_i),
    .rst_n        (rst_ni),
    .test_en_i    (1'b0),
    .slave        (ext_to_soc_slaves),
    .master       (ext_to_soc_masters),
    .start_addr_i (ext_view_start_addr),
    .end_addr_i   (ext_view_end_addr)
    // .valid_rule_i (valid_rule)
  );

  // axi xbar soc -> c07, nocr07
  // soc to external
  // note that axi_node can't handle only one master (N_SLAVES=1) so we add a
  // dummy masters that does nothing.
  axi_node_wrap_with_slices #(
    .NB_MASTER          (soc_node_pkg::N_MASTERS_SOC),
    .NB_SLAVE           (soc_node_pkg::N_SLAVES_SOC),
    // .NB_REGION          (N_REGIONS),
    .AXI_ADDR_WIDTH     (AXI_AW),
    .AXI_DATA_WIDTH     (AXI_DW),
    .AXI_ID_WIDTH       (AXI_IW_INP_SOC),
    .AXI_USER_WIDTH     (AXI_UW),
    .MASTER_SLICE_DEPTH (MST_SLICE_DEPTH),
    .SLAVE_SLICE_DEPTH  (SLV_SLICE_DEPTH)
  ) i_axi_node_soc_to_ext (
    .clk          (clk_i),
    .rst_n        (rst_ni),
    .test_en_i    (1'b0),
    .slave        (soc_to_ext_slaves),
    .master       (soc_to_ext_masters),
    .start_addr_i (soc_view_start_addr),
    .end_addr_i   (soc_view_end_addr)
    // .valid_rule_i (valid_rule)
  );

  // tie off the dummy input to axi xbar (part of workaround)
  assign dummy_slv.aw_id = '0;
  assign dummy_slv.aw_addr = '0;
  assign dummy_slv.aw_len = '0;
  assign dummy_slv.aw_size = '0;
  assign dummy_slv.aw_burst = '0;
  assign dummy_slv.aw_lock = '0;
  assign dummy_slv.aw_cache = '0;
  assign dummy_slv.aw_prot = '0;
  assign dummy_slv.aw_valid = '0;
  // assign dummy_slv.aw_ready

  assign dummy_slv.w_data = '0;
  assign dummy_slv.w_strb = '0;
  assign dummy_slv.w_last = '0;
  assign dummy_slv.w_valid = '0;
  // assign dummy_slv.w_ready

  // assign dummy_slv.b_id
  // assign dummy_slv.b_resp
  // assign dummy_slv.b_valid
  assign dummy_slv.b_ready = '0;

  assign dummy_slv.ar_id = '0;
  assign dummy_slv.ar_addr = '0;
  assign dummy_slv.ar_len = '0;
  assign dummy_slv.ar_size = '0;
  assign dummy_slv.ar_burst = '0;
  assign dummy_slv.ar_lock = '0;
  assign dummy_slv.ar_cache = '0;
  assign dummy_slv.ar_prot = '0;
  assign dummy_slv.ar_valid = '0;
  // assign dummy_slv.ar_ready

  // assign dummy_slv.r_id
  // assign dummy_slv.r_data
  // assign dummy_slv.r_resp
  // assign dummy_slv.r_last
  // assign dummy_slv.r_valid
  assign dummy_slv.r_ready = '0;

endmodule
