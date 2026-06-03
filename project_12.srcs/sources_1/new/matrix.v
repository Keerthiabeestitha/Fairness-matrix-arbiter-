`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 09:58:52
// Design Name: 
// Module Name: matrix
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module matrix #(
  parameter N = 4,
  parameter W = 4   // width of weight/credit
)(
  input  wire              clk,
  input  wire              rst_n,
  input  wire [N-1:0]      req,
  output reg  [N-1:0]      grant
);

  // --------------------------------------------------
  // Internal Signals
  // --------------------------------------------------

  // Priority matrix
  reg [N-1:0] priority_matrix [N-1:0];

  // Weight and credit
  reg [W-1:0] weight [N-1:0];
  reg [W-1:0] credit [N-1:0];

  integer i, j;

  // --------------------------------------------------
  //  1. SEQUENTIAL BLOCK
  //     - Reset
  //     - Matrix update
  //     - Credit update
  // --------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin

      // Initialize priority matrix (fixed priority)
      for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
          if (i < j)
            priority_matrix[i][j] <= 1;
          else
            priority_matrix[i][j] <= 0;
        end
      end

      //Assign weights (customize here)
      weight[0] <= 3;
      weight[1] <= 1;
      weight[2] <= 2;
      weight[3] <= 1;

      // Initialize credits
      for (i = 0; i < N; i = i + 1)
        credit[i] <= weight[i];

    end 
    else begin

      for (i = 0; i < N; i = i + 1) begin
        if (grant[i]) begin

          //  Reduce credit
          credit[i] <= credit[i] - 1;

          // If last credit → rotate priority
          if (credit[i] == 1) begin

            credit[i] <= weight[i]; // reload

            // Update matrix → push i to lowest
            for (j = 0; j < N; j = j + 1) begin
              if (i != j) begin
                priority_matrix[i][j] <= 0;
                priority_matrix[j][i] <= 1;
              end
            end

          end
        end
      end

    end
  end

  // --------------------------------------------------
  //  2. COMBINATIONAL BLOCK
  //     - Grant logic
  // --------------------------------------------------
  reg win;

  always @(*) begin
    grant = {N{1'b0}};

    for (i = 0; i < N; i = i + 1) begin
      if (req[i] && (credit[i] > 0)) begin   //  weight-aware

        win = 1'b1;

        for (j = 0; j < N; j = j + 1) begin
          if (i != j && req[j] && (credit[j] > 0) && !priority_matrix[i][j]) begin
            win = 1'b0;
          end
        end

        if (win)
          grant[i] = 1'b1;
      end
    end
  end

endmodule
