# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


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
