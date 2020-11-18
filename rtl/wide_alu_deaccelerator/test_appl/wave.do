onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/clk_i
add wave -noupdate -group {Software Debugging} -divider {Instructions at ID stage, sampled half a cycle later}
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/riscv_tracer_i/insn_disas
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/riscv_tracer_i/insn_pc
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/riscv_tracer_i/insn_val
add wave -noupdate -group {Software Debugging} -divider {Program counter at ID and IF stage}
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/pc_id
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/pc_if
add wave -noupdate -group {Software Debugging} -divider {Register File contents}
add wave -noupdate -group {Software Debugging} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/id_stage_i/registers_i/riscv_register_file_i/mem
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/clk_i
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/rst_ni
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/test_en_i
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/addr_space_l2_demux
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/addr_space_contiguous
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/addr_space_axi
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_valid_d
add wave -noupdate -group soc_interconnect /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_valid_q
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/b_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/b_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[0]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/b_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/b_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[1]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/b_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/b_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[2]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/b_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/b_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[3]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/b_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/b_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_id}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_data}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_last}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_user}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_bridge_2_axi_xbar4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_bridge_2_axi_xbar[4]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_data}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_last}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_user}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/b_id}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/b_user}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_id}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_data}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_last}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_user}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[0]/r_ready}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_id}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_addr}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_len}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_size}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_burst}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_lock}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_cache}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_prot}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_qos}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_region}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_atop}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_user}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_valid}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/aw_ready}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_data}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_strb}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_last}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_user}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_valid}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/w_ready}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/b_id}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/b_resp}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/b_user}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/b_valid}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/b_ready}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_id}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_addr}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_len}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_size}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_burst}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_lock}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_cache}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_prot}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_qos}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_region}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_user}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_valid}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/ar_ready}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_id}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_data}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_resp}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_last}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_user}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_valid}
add wave -noupdate -group soc_interconnect -group axi_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/axi_slaves[1]/r_ready}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/req}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/add}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/wen}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/wdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/be}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/gnt}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/r_opc}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/r_rdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[0]/r_valid}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/req}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/add}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/wen}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/wdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/be}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/gnt}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/r_opc}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/r_rdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[1]/r_valid}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/req}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/add}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/wen}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/wdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/be}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/gnt}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/r_opc}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/r_rdata}
add wave -noupdate -group soc_interconnect -group contiguous_slaves_2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/contiguous_slaves[2]/r_valid}
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/req
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/add
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/wen
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/wdata
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/be
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/gnt
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/r_opc
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/r_rdata
add wave -noupdate -group soc_interconnect -group error_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/error_slave/r_valid
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[0]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[1]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[2]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[3]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[4]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters5 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[5]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters6 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[6]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters7 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[7]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/req}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/add}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/be}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_masters8 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_masters[8]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/req}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/add}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/be}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[0]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/req}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/add}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/be}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[1]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/req}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/add}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/be}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[2]/r_valid}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/req}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/add}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/wen}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/wdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/be}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/gnt}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/r_opc}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/r_rdata}
add wave -noupdate -group soc_interconnect -group interleaved_slaves3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/interleaved_slaves[3]/r_valid}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/req}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/add}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/wen}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/wdata}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/be}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/gnt}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/r_opc}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/r_rdata}
add wave -noupdate -group soc_interconnect -group master_ports0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[0]/r_valid}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/req}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/add}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/wen}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/wdata}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/be}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/gnt}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/r_opc}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/r_rdata}
add wave -noupdate -group soc_interconnect -group master_ports1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[1]/r_valid}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/req}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/add}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/wen}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/wdata}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/be}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/gnt}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/r_opc}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/r_rdata}
add wave -noupdate -group soc_interconnect -group master_ports2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[2]/r_valid}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/req}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/add}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/wen}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/wdata}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/be}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/gnt}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/r_opc}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/r_rdata}
add wave -noupdate -group soc_interconnect -group master_ports3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[3]/r_valid}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/req}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/add}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/wen}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/wdata}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/be}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/gnt}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/r_opc}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/r_rdata}
add wave -noupdate -group soc_interconnect -group master_ports4 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/i_soc_interconnect/master_ports[4]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/clk_i
add wave -noupdate -expand -group soc_interconnect_wrap /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/rst_ni
add wave -noupdate -expand -group soc_interconnect_wrap /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/test_en_i
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/AXI_ADDR_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/AXI_DATA_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/AXI_ID_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/AXI_USER_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/AXI_STRB_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_atop
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/aw_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_strb
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/w_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/b_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/b_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/b_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/b_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/b_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/ar_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_master_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_in_bus/r_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/AXI_ADDR_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/AXI_DATA_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/AXI_ID_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/AXI_USER_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/AXI_STRB_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_atop
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/aw_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_strb
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/w_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/b_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/b_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/b_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/b_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/b_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/ar_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_slave_plug /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_data_out_bus/r_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group boot_rom_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_rom_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/APB_ADDR_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/APB_DATA_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/paddr
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/pwdata
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/pwrite
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/psel
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/penable
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/prdata
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/pready
add wave -noupdate -expand -group soc_interconnect_wrap -group apb_peripheral_bus /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_apb_periph_bus/pslverr
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[3]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[2]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[1]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group interleaved_slave3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_bus[0]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[1]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group private_slave1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_mem_l2_pri_bus[0]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_debug_master /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_debug_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_data /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_data_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_fc_instr /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_fc_instr_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_rx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_rx_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/req
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/add
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/wen
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/wdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/be
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/gnt
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/r_opc
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/r_rdata
add wave -noupdate -expand -group soc_interconnect_wrap -group tcdm_udma_tx /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_lint_udma_tx_bus/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/AXI_ADDR_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/AXI_DATA_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/AXI_ID_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/AXI_USER_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/AXI_STRB_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_atop
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/aw_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_strb
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/w_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/b_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/b_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/b_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/b_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/b_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_len
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_size
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_burst
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_lock
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_cache
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_qos
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_region
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/ar_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_id
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_last
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_user
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_to_axi_lite_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_to_axi_lite_bridge/r_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/AXI_ADDR_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/AXI_DATA_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/AXI_STRB_WIDTH
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/aw_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/aw_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/aw_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/aw_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/w_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/w_strb
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/w_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/w_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/b_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/b_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/b_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/ar_addr
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/ar_prot
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/ar_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/ar_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/r_data
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/r_resp
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/r_valid
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_lite_to_apb_bridge /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_lite_to_apb_bridge/r_ready
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect0 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[0]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect1 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[1]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect2 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[2]/r_valid}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/req}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/add}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/wen}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/wdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/be}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/gnt}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/r_opc}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/r_rdata}
add wave -noupdate -expand -group soc_interconnect_wrap -group axi_bridge_2_interconnect3 {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_soc_interconnect_wrap/axi_bridge_2_interconnect[3]/r_valid}
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/AXI_ADDR_WIDTH
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/AXI_DATA_WIDTH
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/AXI_ID_WIDTH
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/AXI_USER_WIDTH
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/clk_i
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/rst_ni
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/test_mode_i
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/reg_file_to_ip
add wave -noupdate -expand -group wide_alu_top -subitemconfig {/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/ip_to_reg_file.ctrl2 -expand} /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/ip_to_reg_file
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/to_reg_file_req
add wave -noupdate -expand -group wide_alu_top /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/from_reg_file_rsp
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/AXI_ADDR_WIDTH
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/AXI_DATA_WIDTH
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/AXI_ID_WIDTH
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/AXI_USER_WIDTH
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/AXI_STRB_WIDTH
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_id
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_addr
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_len
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_size
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_burst
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_lock
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_cache
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_prot
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_qos
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_region
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_atop
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_user
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_valid
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/aw_ready
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_data
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_strb
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_last
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_user
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_valid
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/w_ready
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/b_id
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/b_resp
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/b_user
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/b_valid
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/b_ready
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_id
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_addr
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_len
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_size
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_burst
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_lock
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_cache
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_prot
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_qos
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_region
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_user
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_valid
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/ar_ready
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_id
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_data
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_resp
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_last
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_user
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_valid
add wave -noupdate -expand -group wide_alu_top -group axi_slave /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/s_wide_alu_bus/r_ready
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/AW
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/DW
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/DBW
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/clk_i
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/rst_ni
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile -expand /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_req_i
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_rsp_o
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg2hw
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/hw2reg
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/devmode_i
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_addr
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_wdata
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_be
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_rdata
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_error
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/addrmiss
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/wr_err
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_rdata_next
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_intf_req
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/reg_intf_rsp
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_0_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_0_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_1_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_1_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_2_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_2_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_3_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_3_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_4_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_4_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_5_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_5_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_6_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_6_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_7_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_a_7_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_0_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_0_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_1_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_1_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_2_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_2_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_3_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_3_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_4_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_4_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_5_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_5_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_6_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_6_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_7_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/op_b_7_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_0_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_0_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_1_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_1_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_2_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_2_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_3_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_3_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_4_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_4_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_5_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_5_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_6_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_6_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_7_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/result_7_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl1_trigger_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl1_trigger_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl1_clear_err_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl1_clear_err_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_opsel_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_opsel_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_opsel_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_opsel_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_delay_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_delay_wd
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_delay_we
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/ctrl2_delay_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/status_qs
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/status_re
add wave -noupdate -expand -group wide_alu_top -expand -group i_regfile /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_regfile/addr_hit
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/clk_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/rst_ni
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/trigger_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/clear_err_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_a_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_b_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/result_o
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/deaccel_factor_we_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/deaccel_factor_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/deaccel_factor_o
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_sel_we_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_sel_i
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_sel_o
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/status_o
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/state_d
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/state_q
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/result_d
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/result_q
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/delay_cntr_d
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/delay_cntr_q
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/deaccel_factor_d
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/deaccel_factor_q
add wave -noupdate -expand -group wide_alu_top -group i_wide_alu /tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_wide_alu/i_wide_alu/op_sel_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8230688989 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {8230637207 ps} {8230767107 ps}
