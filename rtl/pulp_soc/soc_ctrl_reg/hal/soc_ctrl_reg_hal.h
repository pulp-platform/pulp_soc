// Generated register defines for soc_ctrl

#ifndef _SOC_CTRL_REG_DEFS_
#define _SOC_CTRL_REG_DEFS_

#ifdef __cplusplus
extern "C" {
#endif
// Register width
#define SOC_CTRL_PARAM_REG_WIDTH 32

// Contains information about the current SoC architecture. Present for
// legacy reasons.
#define SOC_CTRL_INFO_REG_OFFSET 0x0
#define SOC_CTRL_INFO_NCLUSTERS_MASK 0xffff
#define SOC_CTRL_INFO_NCLUSTERS_OFFSET 0
#define SOC_CTRL_INFO_NCLUSTERS_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_INFO_NCLUSTERS_MASK, .index = SOC_CTRL_INFO_NCLUSTERS_OFFSET })
#define SOC_CTRL_INFO_NCORES_MASK 0xffff
#define SOC_CTRL_INFO_NCORES_OFFSET 16
#define SOC_CTRL_INFO_NCORES_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_INFO_NCORES_MASK, .index = SOC_CTRL_INFO_NCORES_OFFSET })

// The boot address of the FC upon hard reset.
#define SOC_CTRL_FC_BOOTADDR_REG_OFFSET 0x4

// Enable instruction fetching on the fabric controller. By default this is
// enabled and has
#define SOC_CTRL_FC_FETCH_EN_REG_OFFSET 0x8
#define SOC_CTRL_FC_FETCH_EN_FC_FETCH_EN_BIT 1

// Contains additional information about this SoC including version and
// parametrization.
#define SOC_CTRL_SOC_INFO_REG_OFFSET 0xc
#define SOC_CTRL_SOC_INFO_VERSION_MASK 0xffff
#define SOC_CTRL_SOC_INFO_VERSION_OFFSET 0
#define SOC_CTRL_SOC_INFO_VERSION_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_SOC_INFO_VERSION_MASK, .index = SOC_CTRL_SOC_INFO_VERSION_OFFSET })
#define SOC_CTRL_SOC_INFO_CORE_TYPE_MASK 0x7
#define SOC_CTRL_SOC_INFO_CORE_TYPE_OFFSET 16
#define SOC_CTRL_SOC_INFO_CORE_TYPE_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_SOC_INFO_CORE_TYPE_MASK, .index = SOC_CTRL_SOC_INFO_CORE_TYPE_OFFSET })
#define SOC_CTRL_SOC_INFO_CORE_TYPE_VALUE_CV32E40P 0x0
#define SOC_CTRL_SOC_INFO_CORE_TYPE_VALUE_IBEX_RV32IMC 0x1
#define SOC_CTRL_SOC_INFO_CORE_TYPE_VALUE_IBEX_RV32EC 0x2
#define SOC_CTRL_SOC_INFO_FPU_PRESENT_BIT 19
#define SOC_CTRL_SOC_INFO_ZFINX_BIT 20
#define SOC_CTRL_SOC_INFO_HWPE_PRESENT_BIT 21

// A collection of general purpose registers that software/external test
// equipment can use
#define SOC_CTRL_GP_TESTREG_GP_TESTREG_FIELD_WIDTH 32
#define SOC_CTRL_GP_TESTREG_GP_TESTREG_FIELDS_PER_REG 1
#define SOC_CTRL_GP_TESTREG_MULTIREG_COUNT 4

// A collection of general purpose registers that software/external test
// equipment can use
#define SOC_CTRL_GP_TESTREG_0_REG_OFFSET 0x10

// A collection of general purpose registers that software/external test
// equipment can use
#define SOC_CTRL_GP_TESTREG_1_REG_OFFSET 0x14

// A collection of general purpose registers that software/external test
// equipment can use
#define SOC_CTRL_GP_TESTREG_2_REG_OFFSET 0x18

// A collection of general purpose registers that software/external test
// equipment can use
#define SOC_CTRL_GP_TESTREG_3_REG_OFFSET 0x1c

// This is a legacy register that provides r/w access to put an external
#define SOC_CTRL_CLUSTER_CTRL_REG_OFFSET 0x70
#define SOC_CTRL_CLUSTER_CTRL_RESETN_BIT 0

// A control register that is exposed directly via the PULP legacy
#define SOC_CTRL_JTAGREG_REG_OFFSET 0x74
#define SOC_CTRL_JTAGREG_CONFREG_OUT_MASK 0xff
#define SOC_CTRL_JTAGREG_CONFREG_OUT_OFFSET 0
#define SOC_CTRL_JTAGREG_CONFREG_OUT_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_JTAGREG_CONFREG_OUT_MASK, .index = SOC_CTRL_JTAGREG_CONFREG_OUT_OFFSET })
#define SOC_CTRL_JTAGREG_CONFREG_IN_MASK 0xff
#define SOC_CTRL_JTAGREG_CONFREG_IN_OFFSET 8
#define SOC_CTRL_JTAGREG_CONFREG_IN_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_JTAGREG_CONFREG_IN_MASK, .index = SOC_CTRL_JTAGREG_CONFREG_IN_OFFSET })

// A register used by the software runtime to indicate the return code of the
#define SOC_CTRL_CORESTATUS_REG_OFFSET 0xa0
#define SOC_CTRL_CORESTATUS_EXIT_CODE_MASK 0x7fffffff
#define SOC_CTRL_CORESTATUS_EXIT_CODE_OFFSET 0
#define SOC_CTRL_CORESTATUS_EXIT_CODE_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_CORESTATUS_EXIT_CODE_MASK, .index = SOC_CTRL_CORESTATUS_EXIT_CODE_OFFSET })
#define SOC_CTRL_CORESTATUS_EOC_BIT 31

// Ready-only mirror of the CORESTATUS register
#define SOC_CTRL_CORESTATUS_READ_ONLY_REG_OFFSET 0xc0
#define SOC_CTRL_CORESTATUS_READ_ONLY_EXIT_CODE_MASK 0x7fffffff
#define SOC_CTRL_CORESTATUS_READ_ONLY_EXIT_CODE_OFFSET 0
#define SOC_CTRL_CORESTATUS_READ_ONLY_EXIT_CODE_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_CORESTATUS_READ_ONLY_EXIT_CODE_MASK, .index = SOC_CTRL_CORESTATUS_READ_ONLY_EXIT_CODE_OFFSET })
#define SOC_CTRL_CORESTATUS_READ_ONLY_EOC_BIT 31

// Allows software to determine the bootmode that was used. I.e. it gives
#define SOC_CTRL_BOOTSEL_REG_OFFSET 0xc4
#define SOC_CTRL_BOOTSEL_BOOTSEL_MASK 0x3
#define SOC_CTRL_BOOTSEL_BOOTSEL_OFFSET 0
#define SOC_CTRL_BOOTSEL_BOOTSEL_FIELD \
  ((bitfield_field32_t) { .mask = SOC_CTRL_BOOTSEL_BOOTSEL_MASK, .index = SOC_CTRL_BOOTSEL_BOOTSEL_OFFSET })

// The legacy PULP JTAG TAP contains a control bit that is supposed control
// the
#define SOC_CTRL_CLKSEL_REG_OFFSET 0xc8
#define SOC_CTRL_CLKSEL_CLKSEL_BIT 0

#ifdef __cplusplus
}  // extern "C"
#endif
#endif  // _SOC_CTRL_REG_DEFS_
// End generated register defines for soc_ctrl