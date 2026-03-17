interface regf_intf (input clk,rst_n);
logic [31:0] address, write_data,mem_data_out;
logic mem_read,mem_write;

clocking cb @(posedge clk);
        input address;
        input write_data;
        input mem_read;
        input mem_write;
        output mem_data_out;
    endclocking

endinterface