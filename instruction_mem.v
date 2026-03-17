`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2026 17:30:59
// Design Name: 
// Module Name: instruction_mem
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


module instruction_mem(input clk,
                       input rst_n,
                       input [31:0] read_address,
                       output [31:0] instruction
                       );
                       
reg [31:0] I_mem [0:63];
integer i;

   initial begin
        $readmemh("imem.mem", I_mem);
    end

    assign instruction = I_mem[read_address[7:2]];

endmodule
