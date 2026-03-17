`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 12:41:33
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control_in,
    output reg zero,
    output reg    less_signed,
    output reg    less_unsigned,
    output reg [31:0] result
    );
    
always@(*) begin
// Default values
result = 32'b0;
zero   = 1'b0;
less_signed   = 1'b0;
less_unsigned   = 1'b0;
case(alu_control_in)
4'b0000: result = a + b;                     // ADD, ADDI, address calc
4'b0001: result = a - b;                     // SUB, branch compare
4'b0010: result = a & b;                     // AND, ANDI
4'b0011: result = a | b;                     // OR, ORI
4'b0100: result = a ^ b;                     // XOR, XORI
4'b0101: result = ($signed(a) < $signed(b)); // SLT, SLTI
4'b0110: result = (a < b);                   // SLTU, SLTIU
4'b0111: result = a << b[4:0];               // SLL, SLLI
4'b1000: result = a >> b[4:0];               // SRL, SRLI
4'b1001: result = $signed(a) >>> b[4:0];     // SRA, SRAI
default: result = 32'b0;
endcase
// Compute flags
zero          = (a == b);
less_signed   = ($signed(a) < $signed(b));
less_unsigned = (a < b);
end
endmodule
