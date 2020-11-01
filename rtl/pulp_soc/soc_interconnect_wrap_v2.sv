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
      parameter int  AXI_IN_USER_WIDTH = 6,
      // Axi Output Plug
      localparam int AXI_OUT_ADDR_WIDTH = 32, // All addresses in the SoC must be 32-bit
      localparam int AXI_OUT_DATA_WIDTH = 32, // The internal TCDM->AXI protocol converter does not support any other
      // datawidths than 32-bit
      parameter int  AXI_OUT_ID_WIDTH = 6,
      parameter int  AXI_OUT_USER_WIDTH = 6
    ) (
       logic clk_i,
       logic rst_ni,
       logic test_en_i,
       XBAR_TCDM_BUS.Slave      tcdm_fc_data, //Data Port of the Fabric Controller
       XBAR_TCDM_BUS.Slave      tcdm_fc_instr, //Instruction Port of the Fabric Controller
       XBAR_TCDM_BUS.Slave      tcdm_udma_tx, //TX Channel for the uDMA
       XBAR_TCDM_BUS.Slave      tcdm_udma_rx, //RX Channel for the uDMA
       XBAR_TCDM_BUS.Slave      tcdm_debug, //Debug access port from either the legacy or the riscv-debug unit
       XBAR_TCDM_BUS.Slave      tcdm_hwpe[NR_HWPE_PORTS], //Hardware Processing Element ports
       AXI_BUS.Slave            axi_master_plug, // Normaly used for cluster -> SoC communication
       AXI_BUS.Master           axi_slave_plug, // Normaly used for SoC -> cluster communication
       APB_BUS.Master           apb_peripheral_bus, // Connects to all the SoC Peripherals
       XBAR_TCDM_BUS.Master     l2_interleaved_slaves[NR_L2_PORTS], // Connects to the interleaved memory banks
       XBAR_TCDM_BUS.Master     l2_private_slaves[2], // Connects to core-private memory banks
       XBAR_TCDM_BUS.Master     boot_rom_slave //Connects to the bootrom
     );

    //**Do not change these values unles you verified that all downstream IPs are properly parametrized and support it**
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;


    //////////////////////////////////////////////////////////////
    // 64-bit AXI to TCDM Bridge (Cluster to SoC communication) //
    //////////////////////////////////////////////////////////////
    TCDM_BUS axi_bridge_2_interconnect[4](); //We need 4 32-bit TCDM ports to achieve fullbandwidth with one 64-bit AXI
                                             //port

    axi64_2_lint32 #(
                     .AXI_USER_WIDTH(AXI_IN_USER_WIDTH),
                     .AXI_ID_WIDTH(AXI_IN_ID_WIDTH)
                     ) i_axi64_to_lint32(
                                         .clk_i,
                                         .rst_ni,
                                         .test_en_i,
                                         .axi_master(axi_master_plug),
                                         .tcdm_slaves(axi_bridge_2_interconnect)
                                         );



    ////////////////////////////////////////
    // Address Rules for the interconnect //
    ////////////////////////////////////////
    localparam NR_RULES_L2_DEMUX = 4;
    //Everything that is not routed to port 1 or 2 ends up in port 0 by default
    localparam addr_map_rule_t [NR_RULES_L2_DEMUX-1:0] L2_DEMUX_RULES = '{
       '{ idx: 1 , start_addr: SOC_MEM_MAP_PRIVATE_BANK0_START_ADDR , end_addr: SOC_MEM_MAP_PRIVATE_BANK1_END_ADDR} , //Both , bank0 and bank1 are in the  same address block
       '{ idx: 1 , start_addr: SOC_MEM_MAP_BOOT_ROM_START_ADDR      , end_addr: SOC_MEM_MAP_BOOT_ROM_END_ADDR}      ,
       '{ idx: 2 , start_addr: SOC_MEM_MAP_TCDM_START_ADDR          , end_addr: SOC_MEM_MAP_TCDM_END_ADDR }         ,
       '{ idx: 2 , start_addr: SOC_MEM_MAP_TCDM_ALIAS_START_ADDR    , end_addr: SOC_MEM_MAP_TCDM_ALIAS_END_ADDR}};

    localparam NR_RULES_CONTIG_CROSSBAR = 3;
    localparam addr_map_rule_t [NR_RULES_CONTIG_CROSSBAR-1:0] CONTIGUOUS_CROSSBAR_RULES = '{
        '{ idx: 0 , start_addr: SOC_MEM_MAP_PRIVATE_BANK0_START_ADDR , end_addr: SOC_MEM_MAP_PRIVATE_BANK0_END_ADDR} ,
        '{ idx: 1 , start_addr: SOC_MEM_MAP_PRIVATE_BANK1_START_ADDR , end_addr: SOC_MEM_MAP_PRIVATE_BANK1_END_ADDR} ,
        '{ idx: 2 , start_addr: SOC_MEM_MAP_BOOT_ROM_START_ADDR      , end_addr: SOC_MEM_MAP_BOOT_ROM_END_ADDR}};

    localparam NR_RULES_AXI_CROSSBAR = 2;
    localparam addr_map_rule_t [NR_RULES_AXI_CROSSBAR-1:0] AXI_CROSSBAR_RULES = '{
       '{ idx: 0, start_addr: SOC_MEM_MAP_AXI_PLUG_START_ADDR,    end_addr: SOC_MEM_MAP_AXI_PLUG_END_ADDR},
       '{ idx: 1, start_addr: SOC_MEM_MAP_PERIPHERALS_START_ADDR, end_addr: SOC_MEM_MAP_PERIPHERALS_END_ADDR}};

    //////////////////////////////
    // Instantiate Interconnect //
    //////////////////////////////

    //Internal wiring to APB protocol converter
    AXI_BUS #(.AXI_ADDR_WIDTH(32),
              .AXI_DATA_WIDTH(32),
              .AXI_ID_WIDTH(AXI_OUT_ID_WIDTH),
              .AXI_USER_WIDTH(AXI_OUT_USER_WIDTH)
              ) axi_to_axi_lite_bridge();


    soc_interconnect #(
                       .NR_MASTER_PORTS(5), // FC instructions, FC data, uDMA RX, uDMA TX, debug access
                       .NR_MASTER_PORTS_INTERLEAVED_ONLY(NR_HWPE_PORTS), // HWPEs (PULP accelerators) only have access
                                                                         // to the interleaved memory region
                       .NR_ADDR_RULES_L2_DEMUX(NR_RULES_L2_DEMUX),
                       .NR_SLAVE_PORTS_INTERLEAVED(NR_L2_PORTS), // Number of interleaved memory banks
                       .NR_SLAVE_PORTS_CONTIG(NR_L2_PRIVATE_PORTS), // Number of private memory banks (normally 1 for
                                                                    // programm instructions and 1 for programm stack )
                       .NR_ADDR_RULES_SLAVE_PORTS_CONTIG(NR_RULES_CONTIG_CROSSBAR),
                       .NR_AXI_SLAVE_PORTS(2), // 1 for AXI to cluster, 1 for SoC peripherals (converted to APB)
                       .NR_ADDR_RULES_AXI_SLAVE_PORTS(NR_RULES_AXI_CROSSBAR)
                       ) i_soc_interconnect (
                                             .clk_i,
                                             .rst_ni,
                                             .test_en_i,
                                             .master_ports('{tcdm_fc_data, tcdm_fc_instr, tcdm_udma_tx, tcdm_udma_rx, tcdm_debug}),
                                             .slave_ports(tcdm_hwpe),
                                             .addr_space_l2_demux(L2_DEMUX_RULES),
                                             .interleaved_slaves(l2_interleaved_slaves),
                                             .addr_space_contiguous(CONTIGUOUS_CROSSBAR_RULES),
                                             .contiguous_slaves('{l2_private_slaves[0], l2_private_slaves[1], boot_rom_slave}),
                                             .addr_space_axi(AXI_CROSSBAR_RULES),
                                             .axi_slaves('{axi_slave_plug, axi_to_axi_lite_bridge})
                                             );


    ////////////////////////
    // AXI4 to APB Bridge //
    ///////////////////////////////////////////////////////////////////////////////////////////
    // We do the conversion in two steps: We convert AXI4 to AXI4 lite and from there to APB //
    ///////////////////////////////////////////////////////////////////////////////////////////

    AXI_LITE #(
               .AXI_ADDR_WIDTH(32),
               .AXI_DATA_WIDTH(32)) axi_lite_to_apb_bridge();

    axi_to_axi_lite_intf #(
                           .AXI_ADDR_WIDTH(32),
                           .AXI_DATA_WIDTH(32),
                           .AXI_ID_WIDTH(AXI_OUT_ID_WIDTH),
                           .AXI_USER_WIDTH(AXI_OUT_USER_WIDTH),
                           .AXI_MAX_WRITE_TXNS(1),
                           .AXI_MAX_READ_TXNS(1),
                           .FALL_THROUGH(1)
                           ) i_axi_to_axi_lite (
                                                .clk_i,
                                                .rst_ni,
                                                .testmode_i(test_en_i),
                                                .slv(axi_to_axi_lite_bridge),
                                                .mst(axi_lite_to_apb_bridge)
                                                );

    // The AXI-Lite to APB bridge is capable of connecting one AXI to multiple APB ports using address mapping rules.
    // We do not use this feature and just supply a default rule that matches everything in the peripheral region

    localparam addr_map_rule_t APB_BRIDGE_RULES = '{
        '{ idx: 0, start_addr: SOC_MEM_MAP_PERIPHERALS_START_ADDR, end_addr: SOC_MEM_MAP_PERIPHERALS_END_ADDR}};

    axi_lite_to_apb_intf #(
                           .NoApbSlaves(1),
                           .NoRules(1),
                           .AddrWidth(32),
                           .DataWidth(32),
                           .rule_t(addr_map_rule_t)
                           ) i_axi_lite_to_apb (
                                                .clk_i,
                                                .rst_ni,
                                                .slv(axi_lite_to_apb_bridge),
                                                .paddr_o(apb_periph_bus.paddr),
                                                .pprot_o(),
                                                .pselx_o(apb_periph_bus.psel),
                                                .penable_o(apb_periph_bus.penable),
                                                .pwrite_o(apb_periph_bus.pwrite),
                                                .pwdata_o(apb_periph_bus.pwdata),
                                                .pstrb_o(),
                                                .pready_i(apb_periph_bus.pready),
                                                .prdata_i(apb_periph_bus.prdata),
                                                .pslverr_i(apb_periph_bus.pslverr),
                                                .addr_map_i(APB_BRIDGE_RULES)
                                                );


endmodule : soc_interconnect_wrap
