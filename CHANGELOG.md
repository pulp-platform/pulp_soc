# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [4.4.0] - 2022-06-10
- Bump cv32e40p to pulpissimo-v4.1.0 (Unlock all interrupts and increases fpu latency)

## [4.3.0] - 2022-06-09
### Fixed
- Update jtag_pulp to v0.2.0

## [4.2.0] - 2022-06-09
### Changed
- Use PULP Platform IDCODE

## [4.1.0] - 2022-05-05
### Fixed
- tcdm_err_slave: stall r_opc for 1 cycle
- Various synthesis fixes
- Add obi adapter also to core data path

## [4.0.1] - 2022-04-15
### Fixed
- Fix debug module addresses

## [4.0.0] - 2022-04-08
### Changed
- Update RI5CY to CV32E40P
- Remove PULP_TRAINING references
### Fixed
- Wire up uart char and error events

## [3.3.0] - 2022-04-04
## Changed
- Update riscv-dbg to v0.5.0 (synchronous jtag reset and bus error signaling)

## [3.2.0] - 2022-04-01
## Changed
- Update bender dependency link for udma components, ibex, cv32e40p
- Update interface for udma_i2c with unconnected `nack`
## Fixed
- Fix ibex register file for FPGA

## [3.1.1] - 2022-03-11
### Fixed
- Fix cdc reset signal for cluster

## [3.1.0] - 2022-03-09
### Changed
- Added simulation stdout (replacing the hierarchical access in the tb hack)
### Removed
- Removed apb_timer (duplicate)

## [3.0.1] - 2021-09-08
### Fixed
- `ips_list.yml` has missing domain tags causing trouble with the FPGA flow
- Bumped fpnew for `common_cells` deps

## [3.0.0] - 2021-06-25
### Added
- Added support for Hyperbus. pulp_soc now supports booting from HyperFlash memory
### Changed
- Increase size of boot_mode signal to 2-bit to accomodate the new Hyperbus bootmode
- Bumped riscv_dbg IP Version to 0.4.1
- Switched to new AXI CDC IPs between SoC and Cluster
- Switched to common cells CDC for cluster event exchange
- Bumped axi IP Version to 0.29.1
- Reduced latency of APB and AXI transactions
- Bumped register interface IP Version to 0.3.1
- Bumped cv32e40p IP Version to pulpissimo-v3.4.0-rev3
- Bumped udma_core IP version to 1.1.0
- Switched to new I2C peripheral version with command stream interface
### Removed
- Removed APB Bus interface from repository. The identical version defined in the APB depedency is now used 
- Removed dependency to archived legacy axi_slice_dc
- Removed ifdef for separate FPGA RAM instantiation. This is now supposed to be handled by tc_sram wrapping a Xilinx XPM.
### Fixed
- Fixed Genus SystemVerilog incompatibility in soc_interconnect

## [2.1.0] - 2021-02-02
### Added
- Added `Bender.yml` file for bender compatibility
- Added `obi_pulp_adapter`

### Changed
- updated `ibex`
- change from deprecated `generic_memory` to `tc_sram` tech cell, bump `tech_cells_generic` accordingly
- Expose L2 Bank sizes to improve consistency
- updated `apb_fll_if`, removed local interface definition to use the one defined externally
- updated `hwpe-mac-engine`

### Removed
### Fixed

## [2.0.1] - 2021-01-11
### Added
### Changed
- Changed address aliasing rules to be identical to the behavior of the legacy
  interconnect.
### Removed
### Fixed
- Fix wrong address part select in SRAM wrappers that caused part of the
  memories to be inaccessible and alias into lower address ranges.


## [2.0.0] - 2020-12-11
### Added
- Completely replaced `soc_interconnect` with a new parametric version
- Added AXI Crossbar to `soc_interconnect` to attach custom IPs
- Added new `pulp_soc` parameter to isolate the axi plug CDC fifo in case it is not needed
- Add `register_interface` as dependency to simplify integration of custom ip using reggen
- Properly assert `r_opc` signal in new interconnect to indicate bus errors
- Add error checking for illegal access on HWPE ports which only have access to L2 interleaved memory
### Changed
- AXI ID width of cluster plugs are now set to actually required width instead of a hardcoded one
- TCDM protocol to SRAM specific protocol is moved from interconnect to memory bank module
### Removed
- obsolete `axi_node` dependency
- obsolete header files

## [1.4.2] - 2020-11-04
### Fixed
- Propagate `ZFINX` parameter

## [1.4.1] - 2020-10-28
### Changed
- Bump `fpnew` to `v0.6.4`

### Fixed
- Fix bad dependency of fpnew

## [1.4.0] - 2020-10-02
### Changed
- Bump `fpnew` to `v0.6.3`

### Fixed
- Fix drive input address in bootrom

## [1.3.0] - 2020-07-30
### Changed
- Bump `udma_i2s` to `v1.1.0`

### Removed
- `axi_slice_dc_master_wrap` and `axi_slice_dc_slave_wrap`. These are already
  provided by the `axi_slice_dc` ip.

## [1.2.0] - 2020-05-18
### Added
- Make number of I2C and SPI parametrizable
- Allow external fc_fetch signal to control booting

### Changed
- Prefer for loop over for gen for hartinfo

### Removed
- Quentin specific SCM code

### Fixed
- Elaboration issue when using constant function before declaration
- Style issue
- Missing signals for jtag
- Parameter propagation of `NBIT_CFG`, `NPAD` and `NUM_GPIO`
- Name generate statements

## [1.1.1] - 2020-01-24
### Fixed
- Fix wrong ID WIDTH in soc/cluster AXI bus

## [1.1.0] - 2020-01-20

### Changed
- Propagate cluster debug signals
- Make selectable harts/hartinfo/cluster debug signals parametrizable according
  to NB_CORES
- Rewrite generate blocks to for-genvar loops
- Annotate ips in `ips_list.yml` with usage domain

### Removed
- `axi_mem_if`

## [1.0.1] - 2019-11-21

### Changed
- Bump `axi` to `v0.7.1`
- Bump `axi_node` to `v1.1.4`

### Fixed
- Remove `axi_test.sv` from synthesized files

## [1.0.0] - 2019-11-18

### Added
- ibex support
- FPGA support (`PULP_FPGA_EMUL`) macros
- CHANGELOD.md
- `axi` with version `v0.7.0`

### Changed
- Bump `tech_cells_generic` to `v0.1.6`
- Bump `riscv` (RI5CY) to `pulpissimo-3.4.0`
- Keep `udma_i2c` on `vega_v1.0.0`
- Bump `udma*` to `v1.0.0` (except `udma_i2c`)
- Bump `apb_gpio` to `v0.2.0`
- Bump `jtag_pulp` to `v0.1`
- Bump `hwpe` to `v1.2`
- Bump `axi_node` to `v1.1.3`
- Bump `axi_slice` to `v1.1.4`
- Bump `axi_slice_dc` to `v1.1.3`
- Bump `common_cells` to `v1.13.1`
- Bump `fpnew` to `v0.6.1`
- Bump `riscv-dbg` to `v0.2`
- Bump `apb_interrupt_cntrl` to `v0.0.1`
- Bump `apb_node` to `v0.1.1`
- Bump `apb_adv_timer` to `v1.0.2`
- Bump `apb2per` to `v0.0.1`
- Bump `adv_dbg_if` to `v0.0.1`
- Bump `timer_unit` to `v1.0.2`
- Tag `generic_FLL` with `v0.1`
- Tag `axi_mem_if` with `v0.2.0`

### Fixed
- udma connection issues
- various synthesis issues
- Remove parasitic latches in TCDM bus
- bad signal names
- typo in cluster reset signal

### Removed
- zero-riscy support

## [0.0.1] - 2018-02-08

### Added
- Initial release
