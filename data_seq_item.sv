class data_seq_item extends uvm_sequence_item;
`uvm_object_utils(data_seq_item);

logic [31:0] address;
logic [31:0] write_data;
logic mem_read;
logic mem_write;
logic [31:0] mem_data_out;

function new(string name = "data_seq_item");
super.new(name);
endfunction

endclass