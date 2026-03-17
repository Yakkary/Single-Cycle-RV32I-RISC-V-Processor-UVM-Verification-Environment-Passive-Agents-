`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 18:48:38
// Design Name: 
// Module Name: controller
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


module controller(
    input [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg [1:0] aluop,
    output reg alu_src,
    output reg reg_write
    );
    
always@(*) begin
case (opcode)
// load
7'b0000011 : {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, aluop} <=  8'b11110000; 
// store
7'b0100011 : {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, aluop} <=  8'b10001000;
// I - type
7'b0010011 : {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, aluop} <=  8'b10100011;
// branch
7'b1100011 : {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, aluop} <=  8'b00000101;
// R - type
7'b0110011 : {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, aluop} <=  8'b00100010;
endcase
end
endmodule
