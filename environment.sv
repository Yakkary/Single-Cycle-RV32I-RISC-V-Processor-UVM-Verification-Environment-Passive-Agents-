class my_env extends uvm_env;

`uvm_component_utils(my_env);

imem_agent instr_agt;
dmem_agent data_agt;

alu_monitor alu_mon;
control_monitor ctrl_mon;
reg_file_monitor reg_mon;
pc_monitor pc_mon;
imm_monitor imm_mon;

my_scoreboard scb;
virtual debug_if vif;


function new(string name = "my_env", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
instr_agt = imem_agent::type_id::create("instr_agt",this);
data_agt = dmem_agent::type_id::create("data_agt",this);

scb = my_scoreboard::type_id::create("scb",this);

pc_mon = pc_monitor::type_id::create("pc_mon",this);
alu_mon = alu_monitor::type_id::create("alu_mon",this);
ctrl_mon = control_monitor::type_id::create("ctrl_mon",this);
reg_mon = reg_file_monitor::type_id::create("reg_mon",this);
imm_mon = imm_monitor::type_id::create("imm_mon",this);

if (!uvm_config_db#(virtual debug_if)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", "debug_if not set at env level");

uvm_config_db#(virtual debug_if)::set(this, "pc_mon", "vif", vif);
uvm_config_db#(virtual debug_if)::set(this, "alu_mon", "vif", vif);
uvm_config_db#(virtual debug_if)::set(this, "reg_mon", "vif", vif);
uvm_config_db#(virtual debug_if)::set(this, "ctrl_mon", "vif", vif);
uvm_config_db#(virtual debug_if)::set(this, "imm_mon", "vif", vif);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
instr_agt.mon.ap.connect(scb.instr_imp);
data_agt.mon.ap.connect(scb.data_imp);
pc_mon.ap.connect(scb.pc_imp);
alu_mon.ap.connect(scb.alu_imp);
ctrl_mon.ap.connect(scb.ctrl_imp);
reg_mon.ap.connect(scb.regfile_imp);
imm_mon.ap.connect(scb.imm_imp);
endfunction


endclass