// Copyright 2021 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Convert handshaked events to level sensitive interrupt, cleared by an reading
// the event data register. This register used to be called REG_FIFO in
// apb_interrupt_cntrl, though there the event data could be overwritten by an
// incoming event because it wasn't waiting for a read to REG_FIFO. This was
// mitigated (because overflow could still happen) by putting a fifo buffering
// incoming events.

module event_to_level_int #(
  parameter int unsigned EVENT_WIDTH = 8
)(
  input logic                    clk_i,
  input logic                    rst_ni,

  // apb access
  APB_BUS.Slave                  ctrl,

  // event input
  input logic [EVENT_WIDTH-1:0]  event_data_i,
  input logic                    event_valid_i,
  output logic                    event_ready_o,

  // interrupt output
  output logic                   int_lvl_o
);

  // we only have one memory mapped register
  localparam logic [7:0]         REG_EVENT_DATA = 8'h0;

  logic [EVENT_WIDTH-1:0]        event_data;
  logic                          event_ready;
  logic                          event_data_read; // whether the programmer has read the event data
  logic                          int_lvl;

  assign int_lvl_o = int_lvl;
  assign event_ready_o = event_ready;

  // combinatorial apb response because this seems to be not critical
  assign ctrl.pready  = 1'b1; // always ready to handle read
  assign ctrl.pslverr = 1'b0; // never fail

  always_comb begin
    ctrl.prdata = '0;
    event_data_read = 1'b0;

    if (ctrl.psel && ctrl.penable) begin
      if (!ctrl.pwrite) begin
        // read
        unique case (ctrl.paddr[7:0])
          REG_EVENT_DATA: begin
            ctrl.prdata = event_data;
            event_data_read = 1'b1;
          end
          default:
            ctrl.prdata = '0;
        endcase
      end else begin
        // write
        // we just ignore it
      end
    end
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      event_data  <= '0;
      event_ready <= 1'b1; // we are immediately ready to accept an event
      int_lvl     <= 1'b0;
    end else begin

      // latch and signal interrupt
      if (event_valid_i && event_ready_o) begin
        event_data  <= event_data_i; // latch event id
        event_ready <= 1'b0;  // become busy
        int_lvl     <= 1'b1;
      end else if (event_data_read) begin
        event_ready <= 1'b1;  // become ready again
        int_lvl     <= 1'b0;
      end
    end
  end

endmodule // event_to_level_int
