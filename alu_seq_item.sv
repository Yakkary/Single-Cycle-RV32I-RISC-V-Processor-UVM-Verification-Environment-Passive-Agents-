class alu_seq_item extends uvm_sequence_item;
`uvm_object_utils(alu_seq_item);

logic [31:0] a,b;
logic [31:0] alu_ctrl;
logic less_signed,less_unsigned,zero;
logic [31:0] result;
logic [6:0] opcode;
logic [2:0] funct3;
logic funct7b5;

function new(string name = "alu_seq_item");
super.new(name);
endfunction


endclass