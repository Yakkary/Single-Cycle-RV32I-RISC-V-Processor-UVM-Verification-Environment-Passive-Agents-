# Single-Cycle RV32I RISC-V Processor with UVM Verification

A complete RTL + UVM project implementing a single-cycle 32-bit RV32I RISC-V CPU and a passive-monitor UVM verification environment.

## Project Highlights

- Single-cycle RV32I CPU datapath + controller in Verilog
- UVM environment with:
  - Passive instruction/data memory agents
  - Dedicated monitors for ALU, control, PC, register file, and immediate generator
  - Central scoreboard with golden memory/register mirroring
- Functional checks for:
  - Controller decode correctness
  - ALU control mapping and operation consistency
  - Register file read/write behavior (including x0 protection)
  - Instruction fetch/data memory consistency vs golden models
- Built-in end-of-test mechanisms:
  - Sentinel instruction (`0xDEAD_BEEF`)
  - Instruction-count guard
- Basic functional coverage with opcode/ALU control cross

## Repository Structure

- `top_cpu.v`: DUT top-level CPU
- `top.sv`: testbench top, interface hookup, UVM launch
- `test.sv`: UVM test (`my_test`)
- `environment.sv`: UVM environment assembly
- `scoreboard.sv`: checking, mirroring, and coverage
- `*_monitor.sv`, `*_agent.sv`, `*_seq_item.sv`: monitor/agent/transaction classes
- `imem.mem`, `dmem.mem`, `regfile.mem`: initialization memories
- `transcript`: sample simulation log

## Toolchain

- Mentor QuestaSim / Questa (UVM)
- SystemVerilog + Verilog RTL

## How to Run (example)

From the project directory:

```powershell
vlib work
vlog top.sv
vsim -coverage -voptargs="+acc" tb_top
run -all
```

If you use waveform script:

```tcl
do mywaves.do
```

## Evidence of Successful Run

From `transcript`:

- `UVM_ERROR : 0`
- `UVM_FATAL : 0`
- `Errors: 0, Warnings: 0`

## What This Project Demonstrates

- RTL design and integration for a complete RV32I single-cycle core
- Practical UVM architecture design with reusable monitors/agents
- Scoreboard-driven functional verification using golden models
- Debug-driven validation flow in Questa

## Next Improvements

- Expand ISA coverage and directed/random test programs
- Add branch-focused corner-case tests and coverage goals
- Add CI-style regression scripts for repeatable runs
