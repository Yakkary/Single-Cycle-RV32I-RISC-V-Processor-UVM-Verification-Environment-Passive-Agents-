`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 14:50:54
// Design Name: 
// Module Name: top_cpu
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


module top_cpu(
    input clk,
    input rst_n
    );

// PC and addresses
wire [31:0] pc_out, nextPC, pc_in, adder_sum;

// Instructions, immediates, ALU/regfile signals
wire [31:0] instr, imm_out_to_adder;
wire [31:0] alu_in1, alu_in2, regfile_readdata2_to_alu_in2, alu_result;
wire zero, less_signed, less_unsigned;

// Control / ALU control / muxes
wire [3:0] alu_ctrl_sig;
wire [31:0] mem_data_out_to_mux3, mux3_out_to_regf_write_data;
wire take_branch_mux2_sel;

// Control signals from controller
wire branch, mem_read, mem_write, mem_to_reg, alu_src, reg_write;
wire [1:0] aluop;

//program counter
prg_counter pc(.clk(clk),.rst_n(rst_n),.PC_in(pc_in),.PC_out(pc_out));

//instruction memory
instruction_mem imem(.clk(clk), .rst_n(rst_n), .read_address(pc_out), .instruction(instr));

//pc adder (+4)
prg_counter_plus_four pc_plus_4(/*.clk(clk),*/.rst_n(rst_n),.fromPC(pc_out),.nextPC(nextPC));

//adder
adder add_block(.a(pc_out),.b(imm_out_to_adder),.sum(adder_sum));

//immediate generator
imm_gen immgen(.instruction(instr),.imm_out(imm_out_to_adder));

//register file
registers_file reg_file(.clk(clk), .rst_n(rst_n), .reg_write(reg_write), .rs1(instr[19:15]), .rs2(instr[24:20]), .rd(instr[11:7]), .write_data(mux3_out_to_regf_write_data), .read_data1(alu_in1), .read_data2(regfile_readdata2_to_alu_in2));

//mux from register file or imm gen to alu_in2
regfile_to_alu_mux mux1(.a(regfile_readdata2_to_alu_in2),.b(imm_out_to_adder),.sel(alu_src),.mux_out(alu_in2));

//ALU
alu alu_inst (.a(alu_in1), .b(alu_in2), .alu_control_in(alu_ctrl_sig), .zero(zero), .less_signed(less_signed), .less_unsigned(less_unsigned), .result(alu_result));

//ALU Control
alu_control alu_ctrl (.aluop(aluop), .funct3(instr[14:12]), .funct7b5(instr[30]), .alu_ctrl(alu_ctrl_sig));

//Branch Comparator
branch_comaparator branch_comp (.branch(branch), .zero(zero), .less_signed(less_signed), .less_unsigned(less_unsigned), .funct3(instr[14:12]), .take_branch(take_branch_mux2_sel));

//adder to program counter mux (branch selection)
add_to_pc_mux mux2(.a(nextPC),.b(adder_sum),.sel(take_branch_mux2_sel),.mux_out(pc_in));

//Controller
controller controller_inst (.opcode(instr[6:0]), .branch(branch), .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg), .aluop(aluop), .alu_src(alu_src), .reg_write(reg_write));

//Data memory
data_mem dmem (.clk(clk), .rst_n(rst_n), .mem_write(mem_write), .mem_read(mem_read), .write_data(regfile_readdata2_to_alu_in2), .mem_data_out(mem_data_out_to_mux3), .address(alu_result));

//Alu result or data memory output to regfile mux
mux_to_regfile mux3(.a(mem_data_out_to_mux3),.b(alu_result),.sel(mem_to_reg),.mux_out(mux3_out_to_regf_write_data));

endmodule
