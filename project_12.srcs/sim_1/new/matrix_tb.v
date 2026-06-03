`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 09:59:56
// Design Name: 
// Module Name: matrix_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created


module matrix_tb;

  parameter N = 4;
  parameter W = 4;

  reg clk;
  reg rst_n;
  reg [N-1:0] req;
  wire [N-1:0] grant;

  // DUT instantiation (IMPORTANT: both parameters)
  matrix #(
    .N(N),
    .W(W)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .req(req),
    .grant(grant)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    clk = 0;
    rst_n = 0;
    req = 0;

    // Apply reset
    #12;
    rst_n = 1;

    // -----------------------------
    // Test patterns
    // -----------------------------

    // Pattern 1: 1011
    #10 req = 4'b1011;
    #20 req = 4'b1001;
    #20 req = 4'b1111;
    #20 req = 4'b1011;

    // Keep for few cycles to observe weighting
    #20

    // Pattern 2: 1000
    req = 4'b1000;
    #40;

    // Pattern 3: 1010
    req = 4'b1010;
    #60;

    // End simulation
    $finish;
  end

  // Debug printing (VERY IMPORTANT)
  initial begin
    $display("Time   req   grant   c0 c1 c2 c3");
    $monitor("%4t   %b   %b     %0d  %0d  %0d  %0d",
      $time, req, grant,
      dut.credit[0], dut.credit[1],
      dut.credit[2], dut.credit[3]);
  end

endmodule
