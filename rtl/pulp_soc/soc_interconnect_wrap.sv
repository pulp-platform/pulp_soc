//-----------------------------------------------------------------------------
// Title         : SoC Interconnect Wrapper
//-----------------------------------------------------------------------------
// File          : soc_interconnect_wrap_v2.sv
// Author        : Manuel Eggimann  <meggimann@iis.ee.ethz.ch>
// Created       : 30.10.2020
//-----------------------------------------------------------------------------
// Description :
// This module instantiates the SoC interconnect and attaches the various SoC
// ports. Furthermore, the wrapper also instantiates the required protocol converters
// (AXI, APB).
//-----------------------------------------------------------------------------
// Copyright (C) 2013-2020 ETH Zurich, University of Bologna
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//-----------------------------------------------------------------------------

`include "soc_mem_map.svh"
`include "tcdm_macros.svh"
`include "axi/assign.svh"


module soc_interconnect_wrap
  import pkg_soc_interconnect::addr_map_rule_t;
  #(
    parameter int  NR_HWPE_PORTS = 0,
    parameter int  NR_L2_PORTS = 4,
    // AXI Input Plug
    localparam int AXI_IN_ADDR_WIDTH = 32, // All addresses in the SoC must be 32-bit
    localparam int AXI_IN_DATA_WIDTH = 64, // The internal AXI->TCDM protocol converter does not support any other
                       // datawidths than 64-bit
    parameter int  AXI_IN_ID_WIDTH = 6,
    parameter int  AXI_USER_WIDTH = 6,
    // Axi Output Plug
    localparam int AXI_OUT_ADDR_WIDTH = 32, // All addresses in the SoC must be 32-bit
    localparam int AXI_OUT_DATA_WIDTH = 32  // The internal TCDM->AXI protocol converter does not support any other
                        // datawidths than 32-bit
  ) (
     input logic clk_i,
     input logic rst_ni,
     input logic test_en_i,
     XBAR_TCDM_BUS.Slave      tcdm_fc_data,                       // Data Port of the Fabric Controller
     XBAR_TCDM_BUS.Slave      tcdm_fc_instr,                      // Instruction Port of the Fabric Controller
     XBAR_TCDM_BUS.Slave      tcdm_udma_tx,                       // TX Channel for the uDMA
     XBAR_TCDM_BUS.Slave      tcdm_udma_rx,                       // RX Channel for the uDMA
     XBAR_TCDM_BUS.Slave      tcdm_debug,                         // Debug access port from either the legacy or the riscv-debug unit
     XBAR_TCDM_BUS.Slave      tcdm_hwpe[NR_HWPE_PORTS],           // Hardware Processing Element ports
     AXI_BUS.Slave            axi_master_plug,                    // Normally used for cluster -> SoC communication
     AXI_BUS.Master           axi_slave_plug,                     // Normally used for SoC -> cluster communication
     AXI_LITE.Master          axi_lite_peripheral_bus,            // Connects to all the SoC Peripherals
     XBAR_TCDM_BUS.Master     l2_interleaved_slaves[NR_L2_PORTS], // Connects to the interleaved memory banks
     XBAR_TCDM_BUS.Master     l2_private_slaves[2],               // Connects to core-private memory banks
     XBAR_TCDM_BUS.Master     boot_rom_slave                      // Connects to the bootrom
   );

  //**Do not change these values unles you verified that all downstream IPs are properly parametrized and support it**
  localparam ADDR_WIDTH = 32;
  localparam DATA_WIDTH = 32;


  //////////////////////////////////////////////////////////////
  // 64-bit AXI to TCDM Bridge (Cluster to SoC communication) //
  //////////////////////////////////////////////////////////////
  // We need 4 32-bit TCDM ports to achieve full bandwidth with one 64-bit AXI port
  XBAR_TCDM_BUS axi_bridge_2_interconnect[pkg_soc_interconnect::NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS]();
  `TCDM_EXPLODE_ARRAY_DECLARE(axi_bridge_2_interconnect, pkg_soc_interconnect::NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS)
  logic [pkg_soc_interconnect::NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS-1:0] axi_bridge_2_interconnect_we;
  for (genvar i = 0; i < pkg_soc_interconnect::NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS; i++) begin
    `TCDM_SLAVE_EXPLODE(axi_bridge_2_interconnect[i], axi_bridge_2_interconnect, [i])
    assign axi_bridge_2_interconnect_wen[i] = ~axi_bridge_2_interconnect_we[i];
  end

  axi_to_mem_split_intf #(
    .AXI_ID_WIDTH   ( AXI_IN_ID_WIDTH  ),
    .AXI_ADDR_WIDTH ( AXI_IN_ADDR_WIDTH),
    .AXI_DATA_WIDTH ( AXI_IN_DATA_WIDTH),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH   ),
    .MEM_DATA_WIDTH ( 32               ),
    .BUF_DEPTH      ( 2                ),
    .HIDE_STRB      ( 1'b1             ),
    .OUT_FIFO_DEPTH ( 2                )
  ) i_axi64_to_lint32 (
    .clk_i,
    .rst_ni,
    .test_i       ( test_en_i                         ),
    .busy_o       (                                   ),
    .axi_bus      ( axi_master_plug                   ),
    .mem_req_o    ( axi_bridge_2_interconnect_req     ),
    .mem_gnt_i    ( axi_bridge_2_interconnect_gnt     ),
    .mem_addr_o   ( axi_bridge_2_interconnect_add     ),
    .mem_wdata_o  ( axi_bridge_2_interconnect_wdata   ),
    .mem_strb_o   ( axi_bridge_2_interconnect_be      ),
    .mem_atop_o   (                                   ), // unsupported
    .mem_we_o     ( axi_bridge_2_interconnect_we      ),
    .mem_rvalid_i ( axi_bridge_2_interconnect_r_valid ),
    .mem_rdata_i  ( axi_bridge_2_interconnect_r_rdata )
  );

  ////////////////////////////////////////
  // Address Rules for the interconnect //
  ////////////////////////////////////////
  localparam NR_RULES_L2_DEMUX = 3;
  //Everything that is not routed to port 1 or 2 ends up in port 0 by default
  localparam addr_map_rule_t [NR_RULES_L2_DEMUX-1:0] L2_DEMUX_RULES = '{
    '{ idx: 1 , start_addr: `SOC_MEM_MAP_PRIVATE_BANK0_START_ADDR , end_addr: `SOC_MEM_MAP_PRIVATE_BANK1_END_ADDR} , //Both , bank0 and bank1 are in the  same address block
    '{ idx: 1 , start_addr: `SOC_MEM_MAP_BOOT_ROM_START_ADDR      , end_addr: `SOC_MEM_MAP_BOOT_ROM_END_ADDR}      ,
    '{ idx: 2 , start_addr: `SOC_MEM_MAP_TCDM_START_ADDR          , end_addr: `SOC_MEM_MAP_TCDM_END_ADDR }};

  localparam NR_RULES_INTERLEAVED_REGION = 1;
  localparam addr_map_rule_t [NR_RULES_INTERLEAVED_REGION-1:0] INTERLEAVED_ADDR_SPACE = '{
    '{ idx: 1 , start_addr: `SOC_MEM_MAP_TCDM_START_ADDR          , end_addr: `SOC_MEM_MAP_TCDM_END_ADDR }};

  localparam NR_RULES_CONTIG_CROSSBAR = 3;
  localparam addr_map_rule_t [NR_RULES_CONTIG_CROSSBAR-1:0] CONTIGUOUS_CROSSBAR_RULES = '{
    '{ idx: 0 , start_addr: `SOC_MEM_MAP_PRIVATE_BANK0_START_ADDR , end_addr: `SOC_MEM_MAP_PRIVATE_BANK0_END_ADDR} ,
    '{ idx: 1 , start_addr: `SOC_MEM_MAP_PRIVATE_BANK1_START_ADDR , end_addr: `SOC_MEM_MAP_PRIVATE_BANK1_END_ADDR} ,
    '{ idx: 2 , start_addr: `SOC_MEM_MAP_BOOT_ROM_START_ADDR      , end_addr: `SOC_MEM_MAP_BOOT_ROM_END_ADDR}};

  localparam NR_RULES_AXI_CROSSBAR = 2;
  localparam addr_map_rule_t [NR_RULES_AXI_CROSSBAR-1:0] AXI_CROSSBAR_RULES = '{
    '{ idx: 0, start_addr: `SOC_MEM_MAP_AXI_PLUG_START_ADDR,    end_addr: `SOC_MEM_MAP_AXI_PLUG_END_ADDR},
    '{ idx: 1, start_addr: `SOC_MEM_MAP_PERIPHERALS_START_ADDR, end_addr: `SOC_MEM_MAP_PERIPHERALS_END_ADDR}};

  //For legacy reasons, the fc_data port can alias the address prefix 0x000 to 0x1c0. E.g. an access to 0x00001234 is
  //mapped to 0x1c001234. The following lines perform this remapping.
  XBAR_TCDM_BUS tcdm_fc_data_addr_remapped();
  assign tcdm_fc_data_addr_remapped.req = tcdm_fc_data.req;
  assign tcdm_fc_data_addr_remapped.wen = tcdm_fc_data.wen;
  assign tcdm_fc_data_addr_remapped.wdata = tcdm_fc_data.wdata;
  assign tcdm_fc_data_addr_remapped.be = tcdm_fc_data.be;
  assign tcdm_fc_data.gnt = tcdm_fc_data_addr_remapped.gnt;
  assign tcdm_fc_data.r_opc = tcdm_fc_data_addr_remapped.r_opc;
  assign tcdm_fc_data.r_rdata = tcdm_fc_data_addr_remapped.r_rdata;
  assign tcdm_fc_data.r_valid = tcdm_fc_data_addr_remapped.r_valid;
  //Remap address prefix 1c0 to 000
  always_comb begin
    tcdm_fc_data_addr_remapped.add = tcdm_fc_data.add;
    if (tcdm_fc_data.add[31:20] == 12'h000)
      tcdm_fc_data_addr_remapped.add[31:20] = 12'h1c0;
  end

  //////////////////////////////
  // Instantiate Interconnect //
  //////////////////////////////

  //Internal wiring to APB protocol converter
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( 32                                     ),
    .AXI_DATA_WIDTH ( 32                                     ),
    .AXI_ID_WIDTH   ( pkg_soc_interconnect::AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH                         )
  ) axi_to_axi_lite_bridge();

  //Wiring signals to interconncet. Unfortunately Synopsys-2019.3 does not support assignment patterns in port lists
  //directly
  XBAR_TCDM_BUS master_ports[pkg_soc_interconnect::NR_TCDM_MASTER_PORTS](); //increase the package localparma as well
                //if you want to add new master ports. The parameter is used by other IPs to calcualte
                //the required AXI ID width.

  //Assign Master Ports to array
  `TCDM_ASSIGN_INTF(master_ports[0], tcdm_fc_data_addr_remapped)
  `TCDM_ASSIGN_INTF(master_ports[1], tcdm_fc_instr)
  `TCDM_ASSIGN_INTF(master_ports[2], tcdm_udma_tx)
  `TCDM_ASSIGN_INTF(master_ports[3], tcdm_udma_rx)
  `TCDM_ASSIGN_INTF(master_ports[4], tcdm_debug)

  //Assign the 4 master ports from the AXI plug to the interface array

  //Synopsys 2019.3 has a bug; It doesn't handle expressions for array indices on the left-hand side of assignments.
  // Using a macro instead of a package parameter is an ugly but necessary workaround.
  // E.g. assign a[param+i] = b[i] doesn't work, but assign a[i] = b[i-param] does.
  `define NR_SOC_TCDM_MASTER_PORTS 5
  for (genvar i = 0; i < 4; i++) begin
    `TCDM_ASSIGN_INTF(master_ports[`NR_SOC_TCDM_MASTER_PORTS + i], axi_bridge_2_interconnect[i])
  end

  XBAR_TCDM_BUS contiguous_slaves[3]();
  `TCDM_ASSIGN_INTF(l2_private_slaves[0], contiguous_slaves[0])
  `TCDM_ASSIGN_INTF(l2_private_slaves[1], contiguous_slaves[1])
  `TCDM_ASSIGN_INTF(boot_rom_slave, contiguous_slaves[2])

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( 32                                     ),
    .AXI_DATA_WIDTH ( 32                                     ),
    .AXI_ID_WIDTH   ( pkg_soc_interconnect::AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH                         )
  ) axi_slaves[2]();

  `AXI_ASSIGN(axi_slave_plug, axi_slaves[0])
  `AXI_ASSIGN(axi_to_axi_lite_bridge, axi_slaves[1])

  //Interconnect instantiation
  soc_interconnect #(
    // FC instructions, FC data, uDMA RX, uDMA TX, debug access, 4 four 64-bit
    // axi plug
    .NR_MASTER_PORTS                  ( pkg_soc_interconnect::NR_TCDM_MASTER_PORTS ),
    // HWPEs ( PULP accelerators ) only have access to the interleaved memory
    // region
    .NR_MASTER_PORTS_INTERLEAVED_ONLY ( NR_HWPE_PORTS                              ),
    .NR_ADDR_RULES_L2_DEMUX           ( NR_RULES_L2_DEMUX                          ),
    // Number of interleaved memory banks
    .NR_SLAVE_PORTS_INTERLEAVED       ( NR_L2_PORTS                                ),
    .NR_ADDR_RULES_SLAVE_PORTS_INTLVD ( NR_RULES_INTERLEAVED_REGION                ),
    // Bootrom + number of private memory banks
    // ( normally 1 for programm instructions and 1 for programm stack )
    .NR_SLAVE_PORTS_CONTIG            ( 3                                          ),
    .NR_ADDR_RULES_SLAVE_PORTS_CONTIG ( NR_RULES_CONTIG_CROSSBAR                   ),
    // 1 for AXI to cluster, 1 for SoC peripherals ( converted to APB )
    .NR_AXI_SLAVE_PORTS               ( 2                                          ),
    .NR_ADDR_RULES_AXI_SLAVE_PORTS    ( NR_RULES_AXI_CROSSBAR                      ),
    // Doesn't need to be changed. All axi masters in the current interconnect
    // come from a TCDM protocol converter and thus do not have and AXI ID.
    // However, the unerlaying IPs do not support an ID lenght of 0, thus we
    // use 1.
    .AXI_MASTER_ID_WIDTH              ( 1                                          ),
    .AXI_USER_WIDTH                   ( AXI_USER_WIDTH                             )
  ) i_soc_interconnect (
    .clk_i,
    .rst_ni,
    .test_en_i,
    .master_ports                  ( master_ports              ),
    .master_ports_interleaved_only ( tcdm_hwpe                 ),
    .addr_space_l2_demux           ( L2_DEMUX_RULES            ),
    .addr_space_interleaved        ( INTERLEAVED_ADDR_SPACE    ),
    .interleaved_slaves            ( l2_interleaved_slaves     ),
    .addr_space_contiguous         ( CONTIGUOUS_CROSSBAR_RULES ),
    .contiguous_slaves             ( contiguous_slaves         ),
    .addr_space_axi                ( AXI_CROSSBAR_RULES        ),
    .axi_slaves                    ( axi_slaves                )
  );


  ////////////////////////
  // AXI4 to APB Bridge //
  //////////////////////////////////////////////////////////////////////////////
  // We do the conversion in two steps: We convert AXI4 to AXI4 lite and from //
  // there to APB within the soc_peripherals module                           //
  //////////////////////////////////////////////////////////////////////////////

  axi_to_axi_lite_intf #(
    .AXI_ADDR_WIDTH     ( 32                                     ),
    .AXI_DATA_WIDTH     ( 32                                     ),
    .AXI_ID_WIDTH       ( pkg_soc_interconnect::AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH     ( AXI_USER_WIDTH                         ),
    .AXI_MAX_WRITE_TXNS ( 1                                      ),
    .AXI_MAX_READ_TXNS  ( 1                                      ),
    .FALL_THROUGH       ( 1                                      )
  ) i_axi_to_axi_lite (
    .clk_i,
    .rst_ni,
    .testmode_i ( test_en_i               ),
    .slv        ( axi_to_axi_lite_bridge  ),
    .mst        ( axi_lite_peripheral_bus )
  );

endmodule : soc_interconnect_wrap
