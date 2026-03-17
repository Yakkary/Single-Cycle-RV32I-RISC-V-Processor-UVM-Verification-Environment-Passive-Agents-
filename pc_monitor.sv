class pc_monitor extends uvm_monitor;
`uvm_component_utils(pc_monitor);

uvm_analysis_port#(pc_seq_item) ap;

virtual debug_if vif;

function new(string name = "pc_monitor", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual debug_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("PC_MONITOR","debug interface is not set for PC_monitor");
end
endfunction

task run_phase(uvm_phase phase);

pc_seq_item tr;

tr = pc_seq_item::type_id::create("tr");

forever begin
    @(posedge vif.clk) begin
        tr.PC_in = vif.PC_in;
        tr.PC_out = vif.PC_out;

        ap.write(tr);
    end
end
endtask
endclass
