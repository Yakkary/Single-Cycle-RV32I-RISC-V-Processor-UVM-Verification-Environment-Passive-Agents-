class reg_file_seq_item extends uvm_sequence_item;
`uvm_object_utils(reg_file_seq_item);

logic [4:0] rd,rs1,rs2;
logic reg_write;
logic [31:0] write_data,read_data1,read_data2;

function new(string name = "reg_file_seq_item");
super.new(name);
endfunction

endclass