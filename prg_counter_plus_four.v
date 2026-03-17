`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 17:29:29
// Design Name: 
// Module Name: prg_counter_plus_four
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


module prg_counter_plus_four(
  //  input clk,
  input rst_n,
    input [31:0]  fromPC,
  output [31:0] nextPC
    );
    assign nextPC = fromPC + 32'd4;
endmodule
