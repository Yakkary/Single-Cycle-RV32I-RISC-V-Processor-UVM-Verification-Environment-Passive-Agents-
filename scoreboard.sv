// Declare custom analysis implementations for each seq_item type
`uvm_analysis_imp_decl(_alu)
`uvm_analysis_imp_decl(_pc)
`uvm_analysis_imp_decl(_control)
`uvm_analysis_imp_decl(_data)
`uvm_analysis_imp_decl(_instruction)
`uvm_analysis_imp_decl(_reg_file)
`uvm_analysis_imp_decl(_imm)

class my_scoreboard extends uvm_scoreboard;
`uvm_component_utils(my_scoreboard);

//------------------------
// Analysis ports / imp
//------------------------
uvm_analysis_imp_pc #(pc_seq_item,       my_scoreboard) pc_imp;
uvm_analysis_imp_alu #(alu_seq_item,      my_scoreboard) alu_imp;
uvm_analysis_imp_reg_file #(reg_file_seq_item,  my_scoreboard) regfile_imp;
uvm_analysis_imp_control #(control_seq_item,     my_scoreboard) ctrl_imp;
uvm_analysis_imp_data #(data_seq_item,     my_scoreboard) data_imp;
uvm_analysis_imp_instruction #(instruction_seq_item, my_scoreboard) instr_imp;
uvm_analysis_imp_imm #(imm_seq_item, my_scoreboard) imm_imp;

//------------------------
// Queues to store items
//------------------------
pc_seq_item        pc_q[$];
alu_seq_item       alu_q[$];
reg_file_seq_item   regfile_q[$];
control_seq_item      ctrl_q[$];
data_seq_item      data_q[$];
instruction_seq_item instr_q[$];
imm_seq_item       imm_q[$];

//------------------------
// Mirror register file
//------------------------
logic [31:0] mirror_regs[0:31];

//------------------------
// Current instruction state
//------------------------
bit [6:0] opcode;
bit [2:0] funct3;
bit       funct7b5;
bit [4:0] rs1, rs2, rd;
bit [3:0] alu_ctrl;

//------------------------
// Golden memories
//------------------------
bit [31:0] golden_instr_mem[0:63]; // Preload with program
bit [31:0] golden_data_mem [0:63]; // Preload with data

//------------------------
// Coverage group
//------------------------
covergroup cpu_cg;
  cp_opcode      : coverpoint opcode {
    bins LOAD  = {7'b0000011};
    bins STORE = {7'b0100011};
    bins ITYPE = {7'b0010011};
    bins RTYPE = {7'b0110011};
    bins BRANCH= {7'b1100011};
  }

  cp_alu_ctrl    : coverpoint alu_ctrl {
    bins ADD  ={4'b0000};
    bins SUB  ={4'b0001};
    bins AND  ={4'b0010};
    bins OR   ={4'b0011};
    bins XOR  ={4'b0100};
    bins SLT  ={4'b0101};
    bins SLTU ={4'b0110};
    bins SLL  ={4'b0111};
    bins SRL  ={4'b1000};
    bins SRA  ={4'b1001};
  }

  cp_mem_addr    : coverpoint data_q.size() ? data_q[$].address : 0;
  cp_instr_addr  : coverpoint instr_q.size() ? instr_q[$].read_address : 0;
  cross_opcode_alu : cross cp_opcode, cp_alu_ctrl;
endgroup

//------------------------
// Done event
//------------------------
uvm_event done_ev;

//------------------------
// Constructor
//------------------------
function new(string name="my_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    cpu_cg = new();
    done_ev = new("done_ev");
endfunction

//------------------------
// Build phase
//------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pc_imp      = new("pc_imp", this);
    alu_imp     = new("alu_imp", this);
    regfile_imp = new("regfile_imp", this);
    ctrl_imp    = new("ctrl_imp", this);
    data_imp    = new("data_imp", this);
    instr_imp   = new("instr_imp", this);
    imm_imp     = new("imm_imp", this);
    $readmemh("imem.mem", golden_instr_mem);
    $readmemh("dmem.mem", golden_data_mem);
    $readmemh("regfile.mem", mirror_regs);
endfunction


//------------------------
// Instruction decoding
//------------------------
function void decode_instr(bit [31:0] instr);
  opcode   = instr[6:0];
  rd       = instr[11:7];
  funct3   = instr[14:12];
  rs1      = instr[19:15];
  rs2      = instr[24:20];
  funct7b5 = instr[30];
endfunction

//------------------------
// Controller check
//------------------------
function void check_controller(control_seq_item c);
  case(c.opcode)
    7'b0000011: begin // LOAD
      if(!c.mem_read)  `uvm_error("CTRL","LOAD mem_read=0");
      if(!c.mem_to_reg)`uvm_error("CTRL","LOAD mem_to_reg=0");
      if(!c.reg_write) `uvm_error("CTRL","LOAD reg_write=0");
      if(c.aluop != 2'b00)`uvm_error("CTRL","LOAD aluop!=00");
    end
    7'b0100011: begin // STORE
      if(!c.mem_write) `uvm_error("CTRL","STORE mem_write=0");
      if(c.reg_write)  `uvm_error("CTRL","STORE reg_write=1");
      if(c.aluop != 2'b00)`uvm_error("CTRL","STORE aluop!=00");
    end
    7'b0110011: begin // R-type
      if(!c.reg_write) `uvm_error("CTRL","R reg_write=0");
      if(c.aluop != 2'b10)`uvm_error("CTRL","R aluop!=10");
    end
    7'b0010011: begin // I-type
      if(!c.reg_write) `uvm_error("CTRL","I reg_write=0");
      if(c.aluop != 2'b11)`uvm_error("CTRL","I aluop!=11");
    end
    7'b1100011: begin // BRANCH
      if(!c.branch) `uvm_error("CTRL","BRANCH=0");
      if(c.aluop != 2'b01)`uvm_error("CTRL","BR aluop!=01");
    end
  endcase
endfunction

//------------------------
// ALU control check
//------------------------
function void check_alu_control(alu_seq_item t);
  bit [3:0] expected;
  case(t.opcode)
    7'b0000011, 7'b0100011: expected = 4'b0000; // ADD
    7'b1100011: expected = 4'b0001;              // SUB
    7'b0110011: begin
      case(t.funct3)
        3'b000: expected = (t.funct7b5 ? 4'b0001:4'b0000);
        3'b111: expected = 4'b0010;
        3'b110: expected = 4'b0011;
        3'b100: expected = 4'b0100;
        3'b010: expected = 4'b0101;
        3'b011: expected = 4'b0110;
        3'b001: expected = 4'b0111;
        3'b101: expected = (t.funct7b5 ? 4'b1001:4'b1000);
      endcase
    end
    7'b0010011: begin
      case(t.funct3)
        3'b000: expected = 4'b0000;
        3'b111: expected = 4'b0010;
        3'b110: expected = 4'b0011;
        3'b100: expected = 4'b0100;
        3'b010: expected = 4'b0101;
        3'b011: expected = 4'b0110;
        3'b001: expected = 4'b0111;
        3'b101: expected = (t.funct7b5 ? 4'b1001:4'b1000);
      endcase
    end
    default: expected = t.alu_ctrl;
  endcase

  if(t.alu_ctrl != expected)
    `uvm_error("ALUCTRL", $sformatf("Expected %0b got %0b", expected, t.alu_ctrl));
endfunction

//------------------------
// PC monitor
//------------------------
function void write_pc(pc_seq_item t);
    pc_q.push_back(t);
    `uvm_info("SCOREBOARD", $sformatf("PC update: %0h", t.PC_out), UVM_LOW);
endfunction

//------------------------
// ALU monitor
//------------------------
function void write_alu(alu_seq_item t);
    alu_q.push_back(t);
    alu_ctrl = t.alu_ctrl;
    check_alu_control(t);
    `uvm_info("SCOREBOARD", $sformatf("ALU op: a=%0h b=%0h result=%0h", 
                                       t.a, t.b, t.result), UVM_LOW);
endfunction

//------------------------
// Control monitor
//------------------------
function void write_control(control_seq_item t);
    ctrl_q.push_back(t);
    check_controller(t);
    `uvm_info("SCOREBOARD", $sformatf("CTRL: opcode=%0h branch=%0b mem_read=%0b mem_write=%0b",
                                       t.opcode, t.branch, t.mem_read, t.mem_write), UVM_LOW);
endfunction

//------------------------
// Register file monitor
//------------------------
function void write_reg_file(reg_file_seq_item t);
    regfile_q.push_back(t);
    
    // Verify reads
    if(t.rs1 != 5'd0) begin
        if(t.read_data1 !== mirror_regs[t.rs1])
            `uvm_error("REGFILE", $sformatf("RS1 mismatch at x%0d: expected=%0h got=%0h", t.rs1, mirror_regs[t.rs1], t.read_data1));
    end
    
    if(t.rs2 != 5'd0) begin
        if(t.read_data2 !== mirror_regs[t.rs2])
            `uvm_error("REGFILE", $sformatf("RS2 mismatch at x%0d: expected=%0h got=%0h", t.rs2, mirror_regs[t.rs2], t.read_data2));
    end
    
    // Update mirror on write
    if(t.reg_write) begin
        if(t.rd != 5'd0) begin  // x0 is read-only
            mirror_regs[t.rd] = t.write_data;
            `uvm_info("SCOREBOARD", $sformatf("RegWrite: x%0d = %0h", t.rd, t.write_data), UVM_LOW);
        end
    end else begin
        `uvm_info("SCOREBOARD", $sformatf("RegRead: rs1=x%0d(%0h) rs2=x%0d(%0h)", t.rs1, t.read_data1, t.rs2, t.read_data2), UVM_LOW);
    end
endfunction

//------------------------
// Data memory monitor
//------------------------
function void write_data(data_seq_item t);
    data_q.push_back(t);

    // check memory write/read
    if(t.mem_write) begin
        golden_data_mem[t.address[7:2]] = t.write_data;
    end
    if(t.mem_read) begin
        if(t.mem_data_out !== golden_data_mem[t.address[7:2]])
          `uvm_error("DMEM",$sformatf("Memory mismatch at addr %0h: expected=%0h got=%0h",
                t.address, golden_data_mem[t.address[7:2]], t.mem_data_out));
    end

    `uvm_info("SCOREBOARD",$sformatf("DMEM: addr=%0h w=%0b r=%0b wdata=%0h rdata=%0h",
                                      t.address,t.mem_write,t.mem_read,t.write_data,t.mem_data_out), UVM_LOW);
endfunction

//------------------------
// immediate monitor 
//------------------------
function void write_imm(imm_seq_item t);
    imm_q.push_back(t);
    `uvm_info("SCOREBOARD",$sformatf("IMM: instr=%0h imm=%0h", t.instruction, t.imm), UVM_LOW);
endfunction

//------------------------
// Instruction memory monitor
//------------------------
function void write_instruction(instruction_seq_item t);
    instr_q.push_back(t);

    decode_instr(t.instruction);

    // check fetched instruction matches golden memory
    if(t.instruction !== golden_instr_mem[t.read_address[7:2]])
      `uvm_error("IMEM","Instruction mismatch");
      `uvm_info("SCOREBOARD",$sformatf("GOLDEN_IMEM: addr=%0h instr=%0h",t.read_address, golden_instr_mem[t.read_address[7:2]]), UVM_LOW);

    cpu_cg.sample();

// SENTINEL CHECK: if instruction is 0xDEAD_BEEF, end test
  if(t.instruction == 32'hDEAD_BEEF) begin
    `uvm_info("SCOREBOARD", "Sentinel detected, ending test", UVM_LOW);
    done_ev.trigger();
  end
    `uvm_info("SCOREBOARD",$sformatf("IMEM: addr=%0h instr=%0h", t.read_address,t.instruction), UVM_LOW);
endfunction

//------------------------
// run phase
//------------------------
task run_phase(uvm_phase phase);
    phase.raise_objection(this);
fork
    begin
      wait(instr_q.size() >= 64);  // Wait for 64 instructions
      `uvm_info("SCOREBOARD", "Reached 64 instructions, stopping", UVM_LOW);
    end
    begin
      done_ev.wait_trigger();  // Or wait for sentinel
      `uvm_info("SCOREBOARD", "Sentinel detected, stopping", UVM_LOW);
    end
  join_any
    `uvm_info("SCOREBOARD", $sformatf("Test complete. Instructions: %0d", instr_q.size()), UVM_LOW);
  phase.drop_objection(this);
endtask

endclass
