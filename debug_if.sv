interface debug_if(input clk, rst_n);

//ALU
logic [31:0] a,b;
logic [31:0] alu_ctrl;
logic less_signed,less_unsigned,zero;
logic [31:0] result;

//ALU control
logic [2:0] funct3;
logic funct7b5;

//Controller
logic [6:0] opcode;
logic alu_src,branch,mem_read,mem_to_reg,mem_write,reg_write;
logic [1:0] aluop;

//PC
logic [31:0] PC_in;
logic [31:0] PC_out;

//Register file
logic [4:0] rd,rs1,rs2;

//logic reg_write;
logic [31:0] write_data,read_data1,read_data2;

//immediate value
logic [31:0] imm;
logic [31:0] instruction;

 modport monitor (
    input clk, rst_n, a, b, alu_ctrl, less_signed, less_unsigned, zero, result,
           opcode, alu_src, branch, mem_read, mem_to_reg, mem_write, reg_write, aluop,
           PC_in, PC_out, rd, rs1, rs2, write_data, read_data1, read_data2, imm, instruction, funct3, funct7b5  
  );
endinterface