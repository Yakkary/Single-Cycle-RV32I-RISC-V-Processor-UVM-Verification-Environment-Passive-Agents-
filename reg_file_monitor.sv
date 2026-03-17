class reg_file_monitor extends uvm_monitor;
`uvm_component_utils(reg_file_monitor);

uvm_analysis_port#(reg_file_seq_item) ap;

virtual debug_if vif;

function new(string name = "reg_file_monitor", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual debug_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("REG_FILE_MONITOR", "debug interface is not set for reg_file_monitor");
end
endfunction

task run_phase(uvm_phase phase);
reg_file_seq_item tr;
tr = reg_file_seq_item::type_id::create("reg_file_seq_item");
forever begin
    @(posedge vif.clk) begin
        tr.rd         = vif.rd;
        tr.rs1        = vif.rs1;
        tr.rs2        = vif.rs2;
        tr.reg_write  = vif.reg_write;
        tr.write_data = vif.write_data;
        tr.read_data1 = vif.read_data1;
        tr.read_data2 = vif.read_data2;
        ap.write(tr);
    end
end
endtask
endclass