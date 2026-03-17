`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 12:51:39
// Design Name: 
// Module Name: alu_control
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


module alu_control(input [1:0] aluop,
                   input [2:0] funct3,
                   input funct7b5,
                   output reg [3:0] alu_ctrl 
                   );
               
always@(*) begin
case(aluop)
//load or store -> add
2'b00: alu_ctrl = 4'b0000;
//branch -> sub
2'b01: alu_ctrl <= 4'b0001;
//R - type
2'b10: begin
    case(funct3)
    3'b000: alu_ctrl = (funct7b5 ? 4'b0001 : 4'b0000); // SUB : ADD
    3'b111: alu_ctrl = 4'b0010; // AND
    3'b110: alu_ctrl = 4'b0011; // OR
    3'b100: alu_ctrl = 4'b0100; // XOR
    3'b010: alu_ctrl = 4'b0101; // SLT
    3'b011: alu_ctrl = 4'b0110; // SLTU
    3'b001: alu_ctrl = 4'b0111; // SLL
    3'b101: alu_ctrl = (funct7b5 ? 4'b1001 : 4'b1000); // SRA : SRL
    default: alu_ctrl = 4'b0000;
    endcase
end 
//I - type
2'b11: begin   
    case(funct3)
    3'b000: alu_ctrl = 4'b0000; // ADDI
    3'b111: alu_ctrl = 4'b0010; // ANDI
    3'b110: alu_ctrl = 4'b0011; // ORI
    3'b100: alu_ctrl = 4'b0100; // XORI
    3'b010: alu_ctrl = 4'b0101; // SLTI
    3'b011: alu_ctrl = 4'b0110; // SLTIU
    3'b001: alu_ctrl = 4'b0111; // SLLI
    3'b101: alu_ctrl = (funct7b5 ? 4'b1001 : 4'b1000); // SRAI : SRLI
    default: alu_ctrl = 4'b0000;
    endcase
end
    default: alu_ctrl = 4'b0000;
endcase
end
endmodule
