//-----------------------------------------------------------------------------
// Title         : Wide ALU Package
//-----------------------------------------------------------------------------
// File          : wide_alu_pkg.sv
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
package wide_alu_pkg;
    typedef enum logic[2:0] {
                             ADD = 0,
                             SUB = 1,
                             MUL = 2,
                             XOR = 3,
                             AND = 4,
                             OR  = 5
                             } optype_e;

    typedef enum logic[1:0] {IDLE         = 0,
                             PENDING      = 1,
                             ERROR_WRITE  = 2,
                             ERROR_OPCODE = 3} status_e;
endpackage : wide_alu_pkg
