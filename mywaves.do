onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -itemcolor Cyan /tb_top/imem_if/clk
add wave -noupdate -itemcolor Cyan /tb_top/imem_if/rst_n
add wave -noupdate -itemcolor Cyan /tb_top/imem_if/read_address
add wave -noupdate -itemcolor Cyan /tb_top/imem_if/instruction
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/clk
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/rst_n
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/address
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/write_data
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/mem_data_out
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/mem_read
add wave -noupdate -itemcolor {Green Yellow} /tb_top/dmem_if/mem_write
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/clk
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/rst_n
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/a
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/b
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/alu_ctrl
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/less_signed
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/less_unsigned
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/zero
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/result
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/opcode
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/alu_src
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/branch
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/mem_read
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/mem_to_reg
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/mem_write
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/reg_write
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/aluop
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/PC_in
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/PC_out
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/rd
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/rs1
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/rs2
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/write_data
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/read_data1
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/read_data2
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/imm
add wave -noupdate -itemcolor Blue /tb_top/dbg_if/instruction
add wave -noupdate -itemcolor Gold /tb_top/dut/clk
add wave -noupdate -itemcolor Gold /tb_top/dut/rst_n
add wave -noupdate -itemcolor Gold /tb_top/dut/pc_out
add wave -noupdate -itemcolor Gold /tb_top/dut/nextPC
add wave -noupdate -itemcolor Gold /tb_top/dut/pc_in
add wave -noupdate -itemcolor Gold /tb_top/dut/adder_sum
add wave -noupdate -itemcolor Gold /tb_top/dut/instr
add wave -noupdate -itemcolor Gold /tb_top/dut/imm_out_to_adder
add wave -noupdate -itemcolor Gold /tb_top/dut/alu_in1
add wave -noupdate -itemcolor Gold /tb_top/dut/alu_in2
add wave -noupdate -itemcolor Gold /tb_top/dut/regfile_readdata2_to_alu_in2
add wave -noupdate -itemcolor Gold /tb_top/dut/alu_result
add wave -noupdate -itemcolor Gold /tb_top/dut/zero
add wave -noupdate -itemcolor Gold /tb_top/dut/less_signed
add wave -noupdate -itemcolor Gold /tb_top/dut/less_unsigned
add wave -noupdate -itemcolor Gold /tb_top/dut/alu_ctrl_sig
add wave -noupdate -itemcolor Gold /tb_top/dut/mem_data_out_to_mux3
add wave -noupdate -itemcolor Gold /tb_top/dut/mux3_out_to_regf_write_data
add wave -noupdate -itemcolor Gold /tb_top/dut/take_branch_mux2_sel
add wave -noupdate -itemcolor Gold /tb_top/dut/branch
add wave -noupdate -itemcolor Gold /tb_top/dut/mem_read
add wave -noupdate -itemcolor Gold /tb_top/dut/mem_write
add wave -noupdate -itemcolor Gold /tb_top/dut/mem_to_reg
add wave -noupdate -itemcolor Gold /tb_top/dut/alu_src
add wave -noupdate -itemcolor Gold /tb_top/dut/reg_write
add wave -noupdate -itemcolor Gold /tb_top/dut/aluop
add wave -noupdate -itemcolor Gold /tb_top/dut/imm_out_toadder
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {607221 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {36242 ps}
