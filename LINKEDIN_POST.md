# LinkedIn Post Draft

I’m excited to share a project I recently completed:

**Single-Cycle RV32I RISC-V Processor + UVM Verification Environment**

### What I built
- A 32-bit single-cycle RV32I CPU in Verilog
- A full UVM testbench in SystemVerilog with passive agents, dedicated monitors, and a scoreboard
- Golden model mirroring for instruction memory, data memory, and register file checks

### Verification focus
- Controller signal correctness per instruction type
- ALU control decode and operation validation
- Register-file read/write consistency (including x0 behavior)
- IMEM/DMEM consistency checks against golden memory
- Functional coverage with opcode × ALU-control cross coverage

### Result
- From the simulation transcript, monitors + scoreboard observed and checked:
  - 64 instructions executed (`Reached 64 instructions, stopping`)
  - Sentinel end condition detected (`0xDEAD_BEEF`)
  - Continuous PC, ALU, control, register-file, IMEM, and DMEM activity checks per cycle
  - Final summary: `UVM_ERROR : 0`, `UVM_FATAL : 0`, `Errors: 0, Warnings: 0`

This project strengthened my skills in **RISC-V microarchitecture, RTL design, UVM-based verification, and debug in Questa**.

I’d love feedback from verification and CPU design engineers on how to push this further (multi-cycle pipeline, constrained-random expansion, and coverage closure).

#RISCV #SystemVerilog #UVM #DigitalDesign #ASIC #VLSI #Verification #RTL #QuestaSim
