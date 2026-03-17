`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 17:43:35
// Design Name: 
// Module Name: registers_file
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


module registers_file(
    input clk,
    input rst_n,
    input reg_write,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output  [31:0] read_data1,
    output  [31:0] read_data2
    );
 
reg [31:0] registers [31:0];
integer i;
initial $readmemh("regfile.mem", registers);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i<32; i=i+1) begin
        registers[i] <= 'b0;
        end
    end else if (reg_write && (rd != 5'd0)) begin
    registers[rd] <= write_data;
    end  
end

     assign read_data1 = registers[rs1];
     assign read_data2 = registers[rs2];

endmodule
