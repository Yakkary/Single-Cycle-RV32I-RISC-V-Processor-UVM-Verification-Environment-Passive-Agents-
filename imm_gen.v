`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 17:57:58
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0] instruction,
    output reg [31:0] imm_out
    );
wire [6:0] opcode;
assign opcode = instruction[6:0];
always@(*) begin
case (opcode)
// load
7'b0000011 : imm_out = {{20{instruction[31]}}, instruction[31:20]};
// store
7'b0100011 : imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
// alu imm
7'b0010011 : imm_out = {{20{instruction[31]}}, instruction[31:20]};
// branch
7'b1100011 : imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
default   : imm_out = 32'b0;
endcase
end
endmodule
