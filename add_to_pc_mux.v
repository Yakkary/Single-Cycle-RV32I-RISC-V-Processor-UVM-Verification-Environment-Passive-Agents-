`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 13:51:12
// Design Name: 
// Module Name: add_ to _pc_mux
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


module add_to_pc_mux(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] mux_out
    );
    assign mux_out = (sel === 1'b1) ? b : a;  // assign mux_out = (!sel)? a : b;
endmodule
