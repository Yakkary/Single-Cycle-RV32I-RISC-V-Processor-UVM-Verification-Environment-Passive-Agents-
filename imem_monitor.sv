class imem_monitor extends uvm_monitor;
`uvm_component_utils(imem_monitor);

uvm_analysis_port#(instruction_seq_item) ap;

virtual imem_intf vif;

function new(string name = "imem_monitor", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual imem_intf)::get(this,"","vif",vif)) begin
    `uvm_fatal("IMEM_MONITOR","debug interface is not set for imem_monitor");
end
endfunction

task run_phase(uvm_phase phase);

instruction_seq_item tr;

tr = instruction_seq_item::type_id::create("tr");

forever begin
    @(posedge vif.clk)
    tr.read_address = vif.read_address;
    tr.instruction = vif.instruction;

    ap.write(tr);
end

endtask
endclass
