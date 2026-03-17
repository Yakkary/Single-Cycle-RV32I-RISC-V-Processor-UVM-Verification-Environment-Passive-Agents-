class instruction_seq_item extends uvm_sequence_item;
`uvm_object_utils(instruction_seq_item);

logic [31:0] read_address;
logic [31:0] instruction;

function new(string name = "instruction_seq_item");
super.new(name);
endfunction

endclass