`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 14:19:29
// Design Name: 
// Module Name: branch_comaparator
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


module branch_comaparator(
    input        branch,
    input        zero,
    input        less_signed,
    input        less_unsigned,
    input  [2:0] funct3,
    output reg   take_branch
    );
    
initial take_branch = 1'b0;

always @(*) begin
if (!branch) begin
    take_branch = 1'b0;
end else begin
    case (funct3)
        3'b000: take_branch = zero;                 // BEQ
        3'b001: take_branch = ~zero;                // BNE
        3'b100: take_branch = less_signed;          // BLT
        3'b101: take_branch = ~less_signed;         // BGE
        3'b110: take_branch = less_unsigned;        // BLTU
        3'b111: take_branch = ~less_unsigned;       // BGEU
        default: take_branch = 1'b0;
    endcase
end
end 

endmodule
