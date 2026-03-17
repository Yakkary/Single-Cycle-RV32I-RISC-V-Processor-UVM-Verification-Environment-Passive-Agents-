`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 17:13:01
// Design Name: 
// Module Name: prg_counter
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


module prg_counter(
    input clk,
    input rst_n,
    input [31:0] PC_in,
    output reg [31:0] PC_out
    );

initial begin
PC_out = 32'b0;
end
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
PC_out <= 32'b0;
end else begin
PC_out <= PC_in;
end
end
endmodule
