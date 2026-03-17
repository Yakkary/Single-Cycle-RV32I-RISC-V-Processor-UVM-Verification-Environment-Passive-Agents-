class imm_seq_item extends uvm_sequence_item;
    logic [31:0] instruction;
    logic [31:0] imm;

    `uvm_object_utils(imm_seq_item)

    function new(string name = "imm_seq_item");
        super.new(name);
    endfunction
endclass