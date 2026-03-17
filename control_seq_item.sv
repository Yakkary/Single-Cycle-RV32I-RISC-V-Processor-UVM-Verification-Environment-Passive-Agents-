class control_seq_item extends uvm_sequence_item;
`uvm_object_utils(control_seq_item);

logic [6:0] opcode;
logic alu_src,branch,mem_read,mem_to_reg,mem_write,reg_write;
logic [1:0] aluop;

function new(string name = "control_seq_item");
super.new(name);
endfunction

endclass