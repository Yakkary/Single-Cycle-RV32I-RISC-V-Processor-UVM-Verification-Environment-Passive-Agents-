`include"uvm_macros.svh"
import uvm_pkg::*;

class my_test extends uvm_test;
`uvm_component_utils(my_test);

my_env env;
virtual imem_intf ivif;
virtual dmem_intf dvif;
virtual debug_if deb_vif;

function new(string name = "my_test", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
//seq = my_sequence::type_id::create("seq",this);
env = my_env::type_id::create("env",this);
  // Fetch the virtual interfaces provided by tb_top
  if (!uvm_config_db#(virtual imem_intf)::get(null, "uvm_test_top.env.instr_agt.mon", "vif", ivif)) begin
    `uvm_fatal("TEST", "imem_intf not found in config_db")
  end
  if (!uvm_config_db#(virtual dmem_intf)::get(null, "uvm_test_top.env.data_agt.mon", "vif", dvif)) begin
    `uvm_fatal("TEST", "dmem_intf not found in config_db")
  end
  if (!uvm_config_db#(virtual debug_if)::get(null, "uvm_test_top.env", "vif", deb_vif)) begin
    `uvm_fatal("TEST", "debug_if not found in config_db")
  end

  // Pass the interfaces down to the env/agents
  uvm_config_db#(virtual imem_intf)::set(this,"env.instr_agt.mon","vif",ivif);
  uvm_config_db#(virtual dmem_intf)::set(this,"env.data_agt.mon","vif",dvif);
  uvm_config_db#(virtual debug_if)::set(this,"env.alu_mon","vif",deb_vif);
  uvm_config_db#(virtual debug_if)::set(this,"env.ctrl_mon","vif",deb_vif);
  uvm_config_db#(virtual debug_if)::set(this,"env.reg_mon","vif",deb_vif);
  uvm_config_db#(virtual debug_if)::set(this,"env.pc_mon","vif",deb_vif);
  uvm_config_db#(virtual debug_if)::set(this,"env.imm_mon","vif",deb_vif);
  
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
endfunction

 task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      env.scb.done_ev.wait_trigger();  // Wait for scoreboard to trigger done
    phase.drop_objection(this);
  endtask

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction

endclass
