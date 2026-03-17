`timescale 1ns / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

//------------------------
// DUT Submodules (include BEFORE top_cpu.v)
//------------------------
`include "prg_counter.v"
`include "instruction_mem.v"
`include "prg_counter_plus_four.v"
`include "adder.v"
`include "imm_gen.v"
`include "registers_file.v"
`include "regfile_to_alu_mux.v"
`include "alu.v"
`include "alu_control.v"
`include "branch_comaparator.v"
`include "add_to_pc_mux.v"
`include "controller.v"
`include "data_mem.v"
`include "mux_to_regfile.v"

// Sequence items
`include "alu_seq_item.sv"
`include "control_seq_item.sv"
`include "data_seq_item.sv"
`include "instruction_seq_item.sv"
`include "pc_seq_item.sv"
`include "reg_file_seq_item.sv"
`include "imm_seq_item.sv"

// Monitors
`include "alu_monitor.sv"
`include "control_monitor.sv"
`include "dmem_monitor.sv"
`include "imem_monitor.sv"
`include "pc_monitor.sv"
`include "reg_file_monitor.sv"
`include "imm_monitor.sv"

//Agents
`include "dmem_agent.sv"
`include "imem_agent.sv"

// Scoreboard
`include "scoreboard.sv"

// Environment
`include "environment.sv"

// Test
`include "test.sv"

//Interfaces
`include "debug_if.sv"
`include "interface_imem.sv"
`include "interface_dmem.sv"

//DUT
`include "top_cpu.v"

module tb_top;

    // ------------------------------------------------------------
    // Clock & Reset
    // ------------------------------------------------------------
    logic clk;
    logic rst_n;

    initial begin
        rst_n = 1;
        clk = 0;
                forever #5 clk = ~clk;   // 100 MHz
    end

    /*initial begin
        rst_n = 0;
        #20 
        rst_n = 1; // Release reset after 20ns
    end*/
    // ------------------------------------------------------------
    // Interfaces
    // ------------------------------------------------------------
    debug_if     dbg_if   (clk, rst_n);
    imem_intf    imem_if  (clk, rst_n);
    dmem_intf    dmem_if  (clk, rst_n);

    // ------------------------------------------------------------
    // DUT instantiation
    // ------------------------------------------------------------
    top_cpu dut (
        .clk    (clk),
        .rst_n  (rst_n));

    // ------------------------------------------------------------
    // BIND STATEMENT (NO RTL MODIFICATION)
    // ------------------------------------------------------------
    bind dut debug_if dbg_bind (
        .clk          (clk),
        .rst_n        (rst_n));

        // IMEM interface
        assign imem_if.read_address = dut.pc_out;
        assign imem_if.instruction = dut.instr;

        // DMEM interface
        assign dmem_if.address = dut.alu_result;
        assign dmem_if.write_data = dut.regfile_readdata2_to_alu_in2;
        assign dmem_if.mem_data_out = dut.mem_data_out_to_mux3;
        // mem_read and mem_write are outputs from controller
        assign dmem_if.mem_read = dut.mem_read;
        assign dmem_if.mem_write = dut.mem_write;

        // ALU
        assign dbg_if.a = dut.alu_inst.a;
        assign dbg_if.b = dut.alu_inst.b;
        assign dbg_if.alu_ctrl     = dut.alu_inst.alu_control_in;
        assign dbg_if.less_signed  = dut.alu_inst.less_signed;
        assign dbg_if.less_unsigned = dut.alu_inst.less_unsigned;
        assign dbg_if.zero         = dut.alu_inst.zero;
        assign dbg_if.result       = dut.alu_inst.result;

        // Controller
        assign dbg_if.opcode       = dut.controller_inst.opcode;
        assign dbg_if.alu_src      = dut.controller_inst.alu_src;
        assign dbg_if.branch       = dut.controller_inst.branch;
        assign dbg_if.mem_read     = dut.controller_inst.mem_read;
        assign dbg_if.mem_to_reg   = dut.controller_inst.mem_to_reg;
        assign dbg_if.mem_write    = dut.controller_inst.mem_write;
        assign dbg_if.reg_write    = dut.controller_inst.reg_write;
        assign dbg_if.aluop        = dut.controller_inst.aluop;

        // PC
        assign dbg_if.PC_in        = dut.pc.PC_in;
        assign dbg_if.PC_out       = dut.pc.PC_out;

        // Register file
        assign dbg_if.rd           = dut.reg_file.rd;
        assign dbg_if.rs1          = dut.reg_file.rs1;
        assign dbg_if.rs2          = dut.reg_file.rs2;
        assign dbg_if.write_data   = dut.reg_file.write_data;
        assign dbg_if.read_data1   = dut.reg_file.read_data1;
        assign dbg_if.read_data2   = dut.reg_file.read_data2;

        // Immediate value
        assign dbg_if.imm           = dut.immgen.imm_out;
        assign dbg_if.instruction   = dut.immgen.instruction;

        // alu control
        //assign dbg_if.alu_ctrl = dut.alu_ctrl.alu_ctrl;
        assign dbg_if.funct3 = dut.alu_ctrl.funct3;
        assign dbg_if.funct7b5 = dut.alu_ctrl.funct7b5;

        
   // );


    initial begin
        // Provide virtual interface handles to the UVM config_db
        //uvm_config_db#(virtual imem_intf)::set(null, "uvm_test_top.env.instr_agt", "vif", imem_if);
        uvm_config_db#(virtual imem_intf)::set(null, "uvm_test_top.env.instr_agt.mon", "vif", imem_if);
        //uvm_config_db#(virtual dmem_intf)::set(null, "uvm_test_top.env.data_agt", "vif", dmem_if);
        uvm_config_db#(virtual dmem_intf)::set(null, "uvm_test_top.env.data_agt.mon", "vif", dmem_if);
        uvm_config_db#(virtual debug_if)::set(null, "uvm_test_top.env", "vif", dbg_if);

        // Start UVM
        run_test("my_test");
    end

endmodule