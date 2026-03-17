class alu_monitor extends uvm_monitor;
`uvm_component_utils(alu_monitor)

uvm_analysis_port#(alu_seq_item) ap;
virtual debug_if vif;

function new(string name = "alu_monitor", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
if (!uvm_config_db#(virtual debug_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("ALU_MONITOR", "debug interface is not set for alu_monitor");
end
endfunction

task run_phase(uvm_phase phase);
alu_seq_item tr;

tr = alu_seq_item::type_id::create("tr");

forever begin
    @(posedge vif.clk) begin
   tr.a = vif.a;    
   tr.b = vif.b;
   tr.alu_ctrl = vif.alu_ctrl;   
   tr.less_signed = vif.less_signed;
   tr.less_unsigned = vif.less_unsigned;
   tr.result = vif.result;
   tr.zero = vif.zero;
   tr.opcode = vif.opcode;
   tr.funct3 = vif.funct3;
   tr.funct7b5 = vif.funct7b5;

   ap.write(tr); 

    end
end
endtask

endclass