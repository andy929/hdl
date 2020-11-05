// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

`include "utils.svh"

module system_tb();

  reg mng_clk = 1'b0;
  reg dma_clk = 1'b0;
  reg device_clk = 1'b0;
  reg mng_rst_n = 1'b0;
  reg mng_rst = 1'b1;
  reg dma_rst_n = 1'b0;
  reg dma_rst = 1'b1;

  `TEST_PROGRAM test();

  test_harness `TH (
    .mng_rst        (mng_rst),
    .mng_rst_n      (mng_rst_n),
    .mng_clk        (mng_clk),
    .dma_rst        (dma_rst),
    .dma_rst_n      (dma_rst_n),
    .dma_clk        (dma_clk),
    .device_clk     (device_clk)
  );

  always #5 mng_clk <= ~mng_clk;        // 100 MHz
  always #2 device_clk <= ~device_clk;  // 250 MHz
  always #2 dma_clk <= ~dma_clk;        // 250 MHz

  initial begin
    mng_rst_n = 1'b0;
    mng_rst = 1'b1;
    dma_rst_n = 1'b0;
    dma_rst = 1'b1;
    #2us;
    mng_rst_n = 1'b1;
    mng_rst = 1'b0;
    dma_rst_n = 1'b1;
    dma_rst = 1'b0;
  end

endmodule