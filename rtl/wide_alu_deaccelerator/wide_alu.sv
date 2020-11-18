//-----------------------------------------------------------------------------
// Title         : Wide-ALU Sample IP for PULP-Training IP Integration Exercise
//-----------------------------------------------------------------------------
// File          : wide_alu.sv
// Author        : Manuel Eggimann  <meggimann@iis.ee.ethz.ch>
// Created       : 17.11.2020
//-----------------------------------------------------------------------------
// Description :
//
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

module wide_alu
    import wide_alu_pkg::optype_e;
    import wide_alu_pkg::status_e;
    #(
      localparam ALU_WIDTH=256,
      localparam DEACCEL_COUNTER_WIDTH = 8
    )(
     input logic                              clk_i,
     input logic                              rst_ni,
     input logic                              trigger_i,
     input logic                              clear_err_i,
     input logic [ALU_WIDTH-1:0]              op_a_i,
     input logic [ALU_WIDTH-1:0]              op_b_i,
     output logic [2*ALU_WIDTH-1:0]           result_o,
     input logic                              deaccel_factor_we_i,
     input logic [DEACCEL_COUNTER_WIDTH-1:0]  deaccel_factor_i,
     output logic [DEACCEL_COUNTER_WIDTH-1:0] deaccel_factor_o,
     input logic                              op_sel_we_i,
     input                                    optype_e op_sel_i,
     output                                   optype_e op_sel_o,
     output                                   status_e status_o
     );

    status_e state_d, state_q;
    logic [2*ALU_WIDTH-1:0]           result_d, result_q;
    logic [DEACCEL_COUNTER_WIDTH-1:0] delay_cntr_d, delay_cntr_q;
    logic [DEACCEL_COUNTER_WIDTH-1:0] deaccel_factor_d, deaccel_factor_q;
    optype_e op_sel_q;

    assign result_o         = result_q;
    assign status_o         = state_q;
    assign deaccel_factor_o = deaccel_factor_q;
    assign op_sel_o         = op_sel_q;

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            op_sel_q         <= wide_alu_pkg::ADD;
            deaccel_factor_q <= 1;
            result_q         <= '0;
            state_q          <= wide_alu_pkg::IDLE;
            delay_cntr_q     <= '0;
        end else begin
            op_sel_q         <= (op_sel_we_i)? op_sel_i : op_sel_q;
            deaccel_factor_q <= (deaccel_factor_we_i)? deaccel_factor_i : deaccel_factor_q;
            result_q        <= result_d;
            state_q <= state_d;
            delay_cntr_q    <= delay_cntr_d;
        end
    end // always_ff @ (posedge clk_i, negedge rst_ni)

    always_comb begin
        result_d = result_q;
        case (state_q)
            wide_alu_pkg::IDLE: begin
                if (trigger_i) begin
                    state_d = wide_alu_pkg::PENDING;
                    delay_cntr_d = delay_cntr_q + 1;
                end else begin
                    state_d = wide_alu_pkg::IDLE;
                    delay_cntr_d = delay_cntr_q;
                end
            end
            wide_alu_pkg::PENDING: begin
                if (deaccel_factor_we_i|op_sel_we_i) begin
                    state_d               = wide_alu_pkg::ERROR_WRITE;
                    delay_cntr_d          = delay_cntr_q;
                end else if (delay_cntr_q == deaccel_factor_q) begin
                    state_d               = wide_alu_pkg::IDLE;
                    delay_cntr_d          = 0;
                    case (op_sel_q)
                        wide_alu_pkg::ADD:
                            result_d = op_a_i + op_b_i;
                        wide_alu_pkg::SUB:
                            result_d = op_a_i - op_b_i;
                        wide_alu_pkg::MUL:
                            result_d = op_a_i * op_b_i;
                        wide_alu_pkg::XOR:
                            result_d = op_a_i ^ op_b_i;
                        wide_alu_pkg::AND:
                            result_d = op_a_i & op_b_i;
                        wide_alu_pkg::OR:
                            result_d = op_a_i | op_b_i;
                        default: begin
                            state_d = wide_alu_pkg::ERROR_OPCODE;
                            delay_cntr_d          = delay_cntr_q;
                        end
                    endcase
                end else begin // if (delay_cntr_q == deaccel_factor_q)
                    state_d               = wide_alu_pkg::PENDING;
                    delay_cntr_d          = delay_cntr_q+1;
                end
            end // case: wide_alu_pkg::PENDING
            wide_alu_pkg::ERROR_WRITE, wide_alu_pkg::ERROR_OPCODE: begin
                delay_cntr_d = delay_cntr_q;
                state_d      = state_q;
                if (clear_err_i) begin
                    state_d      = wide_alu_pkg::IDLE;
                    delay_cntr_d = 0;
                end
            end
            default: begin
                state_d      = wide_alu_pkg::IDLE;
                delay_cntr_d = 0;
            end
        endcase
    end

    endmodule : wide_alu
