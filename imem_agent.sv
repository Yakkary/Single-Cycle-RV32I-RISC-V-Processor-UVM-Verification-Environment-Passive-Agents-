class imem_agent extends uvm_agent;
`uvm_component_utils(imem_agent);

imem_monitor mon;

function new(string name = "imem_agent", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
uvm_config_int::set(this, "*", "is_active", UVM_PASSIVE);
mon = imem_monitor::type_id::create("mon",this);
endfunction

endclass
