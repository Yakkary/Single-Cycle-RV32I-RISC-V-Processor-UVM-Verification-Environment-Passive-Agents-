`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 18:32:18
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,
    input rst_n,
    input mem_write,
    input mem_read,
    input [31:0] write_data,
    output [31:0] mem_data_out,
    input [31:0] address
    );
    
reg [31:0] d_mem[0:63];
integer i;
initial $readmemh("dmem.mem", d_mem);

always@(posedge clk or negedge rst_n) begin
if (!rst_n) begin
for (i = 0; i<64; i=i+1) begin
d_mem[i] <= 'b0;
end 
end else if (mem_write) begin
d_mem[address[7:2]] <= write_data;
end 
end

assign mem_data_out = (mem_read)? d_mem[address[7:2]] : 32'bx;

endmodule
