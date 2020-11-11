// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2020 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/1ps

module util_pulse_gen_offset #(

  parameter   PULSE_WIDTH = 7,
  parameter   PULSE_OFFSET = 0)(         // t_period * clk_freq

  input               clk,
  input               rstn,

  input       [31:0]  pulse_width,
  input       [31:0]  pulse_offset,
  input       [31:0]  pulse_counter,
  input               load_config,

  output  reg         pulse
);

  // internal registers

  reg     [31:0]               pulse_offset_cnt = 32'h0;
  reg     [31:0]               pulse_offset_read = 32'b0;
  reg     [31:0]               pulse_width_read = 32'b0;
  reg     [31:0]               pulse_offset_d = 32'b0;
  reg     [31:0]               pulse_width_d = 32'b0;

  wire                         end_of_pulse;

  // flop the desired offset

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      pulse_offset_d <= PULSE_OFFSET;
      pulse_width_d <= PULSE_WIDTH;
      pulse_offset_read <= PULSE_OFFSET;
      pulse_width_read <= PULSE_WIDTH;
    end else begin
      // latch the input offset/width values
      if (load_config) begin
        pulse_offset_read <= pulse_offset;
        pulse_width_read <= pulse_width;
      end
      // update the current offset/width at the end of the offset
      if (end_of_pulse) begin
        pulse_offset_d <= pulse_offset_read;
        pulse_width_d <= pulse_width_read;
      end
    end
  end

  always @(posedge clk) begin
    if (pulse_offset_d == pulse_counter) begin
      pulse_offset_cnt <= pulse_offset_d;
    end else if (pulse_offset_cnt != 32'd0) begin
      pulse_offset_cnt <= pulse_offset_cnt - 1'b1;
    end else begin
      pulse_offset_cnt <= pulse_offset_cnt;
    end
  end

  assign end_of_pulse = (pulse_offset_cnt == 32'b0) ? 1'b1 : 1'b0;

  // generate pulse with a specified width

  always @ (posedge clk) begin
    if ((end_of_pulse == 1'b1) || (rstn == 1'b0)) begin
      pulse <= 1'b0;
    end else if (pulse_offset_cnt == pulse_width_d) begin
      pulse <= 1'b1;
    end
  end

endmodule
