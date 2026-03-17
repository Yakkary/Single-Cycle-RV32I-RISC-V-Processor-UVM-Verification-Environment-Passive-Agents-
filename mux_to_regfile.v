`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 13:47:56
// Design Name: 
// Module Name: mux_to_regfile
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


module mux_to_regfile(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] mux_out
    );
    
    assign mux_out = (sel)? a : b;
endmodule
