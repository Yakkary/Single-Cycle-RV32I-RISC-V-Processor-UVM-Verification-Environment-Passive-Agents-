interface imem_intf (input clk,rst_n);
logic [31:0] read_address, instruction;

clocking cb @(posedge clk);
        input read_address;
    input instruction;
    endclocking

endinterface
