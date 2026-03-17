class dmem_monitor extends uvm_monitor;
`uvm_component_utils(dmem_monitor);

uvm_analysis_port#(data_seq_item) ap;

virtual dmem_intf vif;

function new(string name = "dmem_monitor", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual dmem_intf)::get(this,"","vif",vif)) begin
    `uvm_fatal("DMEM_MONITOR","debug interface is not set for dmem_monitor");
end
endfunction

task run_phase(uvm_phase phase);
data_seq_item tr;

tr = data_seq_item::type_id::create("tr");

forever begin
    @(posedge vif.clk)

tr.address      = vif.address;
tr.write_data   = vif.write_data;
tr.mem_read     = vif.mem_read;
tr.mem_write    = vif.mem_write;
tr.mem_data_out = vif.mem_data_out;

    ap.write(tr);
end
endtask
endclass