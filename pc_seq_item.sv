class pc_seq_item extends uvm_sequence_item;
`uvm_object_utils(pc_seq_item);

logic [31:0] PC_in;
logic [31:0] PC_out;

function new(string name = "pc_seq_item");
super.new(name);
endfunction

endclass