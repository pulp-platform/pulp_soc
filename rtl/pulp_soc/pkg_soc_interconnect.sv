package pkg_soc_interconnect;

    typedef struct packed {
        logic [31:0] idx;
        logic [31:0] start_addr;
        logic [31:0] end_addr;
    } addr_map_rule_t;

    localparam NR_SOC_TCDM_MASTER_PORTS = 5; // FC instructions, FC data, uDMA RX, uDMA TX, debug access
    localparam NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS = 4; //  4 ports for 64-bit axi plug
    localparam NR_TCDM_MASTER_PORTS = NR_SOC_TCDM_MASTER_PORTS + NR_CLUSTER_2_SOC_TCDM_MASTER_PORTS;
    localparam NR_EXTRA_BITS_AXI_ID_OUT = $clog2(NR_TCDM_MASTER_PORTS);

endpackage : pkg_soc_interconnect
