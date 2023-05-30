#!/usr/bin/tclsh
rm -r work
vlib work
#files with no dependencies
vcom 00-constants.vhd
vcom 02-and_gate.vhd
vcom 12-or_gate.vhd
vcom 18-xor_gate.vhd
vcom a.a-DataPath.core/a.a.c-executionUnit.core/a.a.c.b-shifter_dx.vhd
vcom a.a-DataPath.core/a.a.c-executionUnit.core/a.a.c.c-shifter_sx.vhd
vcom a.a-DataPath.core/a.a.b-decodeUnit.core/a.a.b.b-sign_extension.vhd
vcom 10-mux11to1.vhd
vcom 11-mux21_generic.vhd
vcom 16-reg_gen.vhd
vcom a.a-DataPath.core/a.a.b-decodeUnit.core/a.a.b.a-registerfile.vhd
vcom 04-comparator.vhd
vcom a.a-DataPath.core/a.a.d-memoryUnit.core/a.a.d.a-branch_block.vhd
vcom a.d-DataMemory.vhd
vcom a.c-IRAM.vhd
vcom 07-flip_flop.vhd
#files with dependencies
#P4
vcom 08-general_G.vhd
vcom 09-general_PG.vhd
vcom 14-PG_block.vhd
vcom 05-CSblock.vhd
vcom 03-carry_generator.vhd
vcom 06-fa.vhd
vcom 15-rca.vhd
vcom 17-sum_generator.vhd
vcom 13-P4_adder.vhd
#BOOTH mul
#vcom adder.vhd
#vcom encoder.vhd
#vcom negCorrector.vhd
#vcom ppCalc.vhd
#vcom BOOTHMUL.vhd
#ALU
vcom a.a-DataPath.core/a.a.c-executionUnit.core/a.a.c.a-alu.vhd
#DATAPATH
vcom a.a-DataPath.core/a.a.c-executionUnit.vhd
vcom a.a-DataPath.core/a.a.d-memoryUnit.vhd
vcom a.a-DataPath.core/a.a.b-decodeUnit.vhd
vcom a.a-DataPath.core/a.a.a-fetchUnit.vhd
vcom a.a-DataPath.core/a.a.e-writeBackUnit.vhd
vcom 00-myTypes.vhd
vcom a.a-DataPath.vhd
vcom a.b-CU_HW.vhd
vcom a.DLX.vhd
#vcom alu_tb.vhd
vcom test_bench/TB_DLX.vhd
#simulation of architecture
vsim work.a_DLX_tb(beh) -t ns -voptargs=+acc
#vsim work.alu_tb(beh) -t ns -voptargs=+acc
add wave *
add wave sim:a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/registers
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/alu_out_mem 
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/WriteData_wb
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/rw_from_ex_to_mem
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/data_from_mem_to_wb
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/alu_out
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/rw_from_ex_to_mem
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/out1 
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/out2
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/IRAM_instr
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/RW_R_out 
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/RW_I_out 
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/RW_R 
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/RW_I
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/RW_R
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/RW_I
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/rw_s
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/alu_dut/op_sel
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/alu_dut/cmp_out
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/EXE/alu_dut/cmp_sel
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/MMU/rw_exe
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/MMU/rw_mem
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/MMU/mem/address 
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/MMU/mem/datain
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/mem_en_mem 
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/wr_mem
add wave sim:/a_dlx_tb/dlx_uut/CU_I/SEL_MUX_RW
add wave sim:/a_dlx_tb/dlx_uut/CU_I/EN_REG_ID
add wave sim:/a_dlx_tb/dlx_uut/CU_I/WR
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/wr
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/add_wr
#add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IDU/REGISTERS/datain
add wave sim:/a_dlx_tb/dlx_uut/CU_I/IR_opcode
add wave sim:/a_dlx_tb/dlx_uut/CU_I/IR_func
add wave sim:/a_dlx_tb/dlx_uut/CU_I/cw3
add wave sim:/a_dlx_tb/dlx_uut/CU_I/cw4
add wave sim:/a_dlx_tb/dlx_uut/CU_I/cw5

add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/MMU/mem/registers

add wave  sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IFU/PC_in 
add wave sim:/a_dlx_tb/dlx_uut/DataPath_dlx/IFU/PC_out
run 100 ns 
