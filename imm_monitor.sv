class imm_monitor extends uvm_monitor;
`uvm_component_utils(imm_monitor);
uvm_analysis_port#(imm_seq_item) ap;

virtual debug_if vif;

function new(string name = "imm_monitor", uvm_component parent = null);
super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual debug_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("IMM_MONITOR","debug interface is not set for imm_monitor");
end
endfunction

task run_phase(uvm_phase phase);
imm_seq_item tr;    
tr = imm_seq_item::type_id::create("tr");
forever begin
    @(posedge vif.clk) begin
        tr.instruction = vif.instruction;
        tr.imm = vif.imm;
        ap.write(tr);
    end
end
endtask
endclass
