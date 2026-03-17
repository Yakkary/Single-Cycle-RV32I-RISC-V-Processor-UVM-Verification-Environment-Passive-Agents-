class control_monitor extends uvm_monitor;
`uvm_component_utils(control_monitor);

uvm_analysis_port#(control_seq_item) ap;

virtual debug_if vif;

function new(string name = "control_seq_item", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if(!uvm_config_db#(virtual debug_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("CONTROL_MONITOR","debug interface is not set for control_monitor");
end
endfunction

task run_phase(uvm_phase phase);
control_seq_item tr;

tr = control_seq_item::type_id::create("tr");

forever begin
    @(posedge vif.clk) begin
    
   tr.opcode = vif.opcode;    
   tr.alu_src = vif.alu_src;
   tr.branch = vif.branch;   
   tr.mem_read = vif.mem_read;
   tr.mem_to_reg = vif.mem_to_reg;
   tr.mem_write = vif.mem_write;
   tr.reg_write = vif.reg_write;
   tr.aluop = vif.aluop;

   ap.write(tr); 
   
    end
end
endtask

endclass