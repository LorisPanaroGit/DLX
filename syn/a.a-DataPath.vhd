library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;
----------------------------------------------------------------------------
entity datapath is
	generic(nbit     : integer := 32);
	port(Clk 		 : in std_logic;  --Clock
		 Rst         : in std_logic;  --Reset
		
		------IF STAGE------
	 	 PC_op       : in std_logic;
	 	 en_reg_if   : in std_logic;
	 	 RD1,RD2     : in std_logic;
		 dout_IRAM	 : in std_logic_vector(nbit-1 downto 0);
		 addr_IRAM 	 : out std_logic_vector(nbit-1 downto 0);
		------ID STAGE------
		 en_reg_id   : in std_logic;
	     WR          : in std_logic; --write signal for RegisterFile 
		 Opcode      : out std_logic_vector(5 downto 0);
	     Func        : out std_logic_vector(10 downto 0);
		------EX STAGE------
		 sel_ex	     : in std_logic; --I-immediate/read_data_2 selector
		 sel_mux_rw  : in std_logic; --0 if R-type, 1 if I-type
		 en_reg_ex   : in std_logic; --enables output registers of the execution unit
		 alu_sel	 : in std_logic_vector(3 downto 0); --selects alu operation
		------MEM STAGE-----
		 en_reg_mem  : in std_logic; --enables output register of the memory stage
--		 mem_en_mem  : in std_logic; --enables memstage data memory
--		 rd_mem	   	 : in std_logic;
--		 wr_mem 	 : in std_logic;
		 dataout_from_mem : in std_logic_vector(nbit-1 downto 0);	--data sent to datapath from external memory (LOAD)
		 addr_mem : out std_logic_vector(nbit-1 downto 0);	--address to be sent to external memory
		 datain_mem : out std_logic_vector(nbit-1 downto 0);	--data to be sent to external memory (STORE)
		 b_op_mem	 : in std_logic;
		 j_op_mem    : in std_logic;
		 jal_op_mem   : in std_logic;	
		------WB STAGE------
		 MemtoReg_wb : in std_logic;
		 pipe_out    : out std_logic_vector(nbit-1 downto 0)
	);
end datapath;
----------------------------------------------------------------------------
architecture Behavioral of datapath is
	component fetchUnit is
		generic(nbit : integer := numBit);
		port(Clk,Rst,en_reg : in std_logic;
			PC_branch_jump	: in std_logic_vector(nbit-1 downto 0); --PC if thre is a branch or jump
			dout_IRAM		: in std_logic_vector(nbit-1 downto 0);
			--CU signal
			PC_op          : in std_logic;
			--output
			PC_Next_out 	: out std_logic_vector(nbit-1 downto 0);
			addr_IRAM 		: out std_logic_vector(nbit-1 downto 0);
			IRAM_reg_out 	: out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component decodeUnit is
		generic(nbit : integer := numBit);
		port(Clk,Rst,en_reg,RD1,RD2      : in std_logic;
			
			 --IF signals
			 IRAM_instr 		 : in std_logic_vector(nbit-1 downto 0);
			 PC_Next 			 : in std_logic_vector(nbit-1 downto 0);
        	 --WB signals
			 WR                  : in std_logic;
			 ADD_RW 			 : in std_logic_vector(4 downto 0); --address_register_write of the MEM/WB stage
			 DATA_RW 			 : in std_logic_vector(nbit-1 downto 0); --data_register_write of the WB stage
			 --output for EX
	     	 RW_R_out 		     : out std_logic_vector(nbit-1 downto 0);
		     RW_I_out 		     : out std_logic_vector(nbit-1 downto 0);
			 Jump_address 		 : out std_logic_vector(nbit-1 downto 0);
			 I_immediate_ext_out : out std_logic_vector(nbit-1 downto 0);
			 RD_data_1_out 		 : out std_logic_vector(nbit-1 downto 0);
			 RD_data_2_out		 : out std_logic_vector(nbit-1 downto 0);
			 PC_Next_out 		 : out std_logic_vector(nbit-1 downto 0);
			 --output for CU
			 Opcode              : out std_logic_vector(5 downto 0);
			 Func                : out std_logic_vector(10 downto 0)
		);
	end component;

	component executionUnit is
		generic(nbit 	 : integer := numbit);
		port(r1      	 : in std_logic_vector(nbit-1 downto 0);	--data 1 from register file
			 r2      	 : in std_logic_vector(nbit-1 downto 0);	--data 2 from register file
			 imm     	 : in std_logic_vector(nbit-1 downto 0);	--immediate for immediate and branch
			 j_lab   	 : in std_logic_vector(nbit-1 downto 0);	--jump label
		 	 pc	     	 : in std_logic_vector(nbit-1 downto 0);	--current program counter
		     RW_R        : in std_logic_vector(nbit-1 downto 0);
		     RW_I        : in std_logic_vector(nbit-1 downto 0);
		     s2	     	 : in std_logic;                            --selector for mux (r1 or immediate)
		     s3	     	 : in std_logic;							--selector for mux RW
		 	 rst     	 : in std_logic;							--reset
		 	 clk	 	 : in std_logic;							--clock
	     	 en_reg  	 : in std_logic;							--register enable
		 	 alu_sel 	 : in std_logic_vector(3 downto 0);			--encoded signal for ALU operation
		 	 alu_out 	 : out std_logic_vector(nbit-1 downto 0);	--ALU result (out of the register)
			 alu_fw_out	 : out std_logic_vector(nbit-1 downto 0);	--ALU result forwarded
		 	 r2_out      : out std_logic_vector(nbit-1 downto 0);	--r2 forward, data for memory register file
		 	 b_lab_out   : out std_logic_vector(nbit-1 downto 0);	--computed label for a branch (PC + b_lab)
		 	 pc_exe_out  : out std_logic_vector(nbit-1 downto 0);
		 	 rw_exe		 : out std_logic_vector(nbit-1 downto 0);
		 	 j_lab_out   : out std_logic_vector(nbit-1 downto 0)	--computed label for a jump (PC + j_lab)
		);
	end component;

	component memoryUnit is
		generic(nbit : integer := numBit);
		port(rst 	  : in std_logic;
			clk	  : in std_logic;
			en_reg   : in std_logic;
			b_op     : in std_logic;	--from CU
			j_op     : in std_logic;	--from CU
			jal_op   : in std_logic;	--from CU
			alu_out  : in std_logic_vector(nbit-1 downto 0);
			r2_out   : in std_logic_vector(nbit-1 downto 0);
			PC		  : in std_logic_vector(nbit-1 downto 0);
			lab_b    : in std_logic_vector(nbit-1 downto 0);
			lab_j    : in std_logic_vector(nbit-1 downto 0);
			rw_exe   : in std_logic_vector(nbit-1 downto 0);
			dataout_from_mem : in std_logic_vector(nbit-1 downto 0);	--data sent to datapath from external memory (LOAD)
			addr_mem : out std_logic_vector(nbit-1 downto 0);	--address to be sent to external memory
			datain_mem : out std_logic_vector(nbit-1 downto 0);	--data to be sent to external memory (STORE)
			next_PC  : out std_logic_vector(nbit-1 downto 0);
			alu_out_mem  : out std_logic_vector(nbit-1 downto 0);
			rw_mem	  : out std_logic_vector(nbit-1 downto 0);
			data_out : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component writeBackUnit is
		generic(nbit : integer := numbit);
		port(--rst : in std_logic;
			--clk : in std_logic;
			--en_reg : in std_logic;
			MemtoReg		:	in std_logic;	--control signal
			ReadData		:	in std_logic_vector(nbit - 1 downto 0);
			--rw_from_exe    : 	in std_logic_vector(nbit - 1 downto 0);
			AluResult		:	in std_logic_vector(nbit -1 downto 0);
			WriteData		:	out std_logic_vector(nbit -1 downto 0)
		);
	end component;

---------------------------------------------------------------------------------------------------
--IF signals
	signal pc_from_mem_to_fetch : std_logic_vector(nbit-1 downto 0); --PC from MEM stage
	signal PC_Next_fetch     : std_logic_vector(nbit-1 downto 0); --PC_Next for ID stage
	signal IRAM           : std_logic_vector(nbit-1 downto 0); 
--ID signals
	signal ADD_RW         : std_logic_vector (nbit-1 downto 0);  --Address of the register to be written in RegisterFile (RW from MEM/WB stage)
	signal RW_R_decode, RW_I_decode      : std_logic_vector (nbit-1 downto 0); --Address of the register to be written in RegisterFile (RW, extended 32 bit, for EX stage)
	signal J_imm 	      : std_logic_vector(nbit-1 downto 0); --immediate J-instruction for EX stage
    signal I_imm 		  : std_logic_vector(nbit-1 downto 0); --immediate I-instruction for EX stage
	signal RD_data_1	  : std_logic_vector(nbit-1 downto 0); --RegisterFile output data_1 for EX stage
    signal RD_data_2	  : std_logic_vector(nbit-1 downto 0); --RegisterFile output data_2 for EX stage
	signal PC_Next_decode : std_logic_vector(nbit-1 downto 0); --PC_Next for EX stage 
--EXECUTION signals
	signal alu_out 		     : std_logic_vector(nbit-1 downto 0);
	signal alu_forward	     : std_logic_vector(nbit-1 downto 0);
	signal aluR2_to_mem      : std_logic_vector(nbit-1 downto 0);  
	signal b_from_ex_to_mem  : std_logic_vector(nbit-1 downto 0);
	signal j_from_ex_to_mem  : std_logic_vector(nbit-1 downto 0);
	signal pc_from_ex_to_mem : std_logic_vector(nbit-1 downto 0);
--MEMORY signals
	signal rw_from_ex_to_mem    : std_logic_vector(nbit-1 downto 0);
	signal data_from_mem_to_wb  : std_logic_vector(nbit-1 downto 0);
	signal alu_out_mem          : std_logic_vector(nbit-1 downto 0);
--WB signals
    signal WriteData_wb   : std_logic_vector (nbit-1 downto 0); --data to write in RegisterFile in ID stage
    --signal rw_from_mem_to_wb    : std_logic_vector(nbit-1 downto 0);
---------------------------------------------------------------------------------------------------
	begin
-----------------------------------------IF STAGE--------------------------------------------------
	IFU: fetchUnit
	port map(Clk => Clk, Rst => Rst ,en_reg => en_reg_if, PC_branch_jump => pc_from_mem_to_fetch, PC_op => PC_op, PC_Next_out => PC_Next_fetch, IRAM_reg_out => IRAM, dout_IRAM => dout_IRAM, addr_IRAM => addr_IRAM);
-----------------------------------------ID STAGE--------------------------------------------------
	IDU: decodeUnit
	port map(Clk => Clk, Rst => Rst, en_reg => en_reg_id, RD1 => RD1, RD2 => RD2, IRAM_instr => IRAM, PC_Next => PC_Next_fetch, WR => WR, ADD_RW => ADD_RW(4 downto 0), DATA_RW => WriteData_wb, RW_R_out => RW_R_decode, RW_I_out => RW_I_decode, 
			Jump_address => J_imm, I_immediate_ext_out => I_imm, RD_data_1_out => RD_data_1, RD_data_2_out => RD_data_2, PC_Next_out => PC_Next_decode, Opcode => Opcode, Func => Func );
-----------------------------------------EX STAGE--------------------------------------------------
        EXE: executionUnit
        port map(r1 => RD_data_1, r2 => RD_data_2, imm => I_imm, j_lab => J_imm, pc => PC_Next_decode, RW_R => RW_R_decode, RW_I => RW_I_decode, s2 => sel_ex, s3 => sel_mux_rw, rst => Rst, clk => Clk, en_reg => en_reg_ex, alu_sel => alu_sel, alu_out => alu_out, 
				 alu_fw_out => alu_forward, r2_out => aluR2_to_mem, b_lab_out => b_from_ex_to_mem, pc_exe_out => pc_from_ex_to_mem, rw_exe => rw_from_ex_to_mem, j_lab_out => j_from_ex_to_mem);
-----------------------------------------MEM STAGE-------------------------------------------------
		MMU: memoryUnit
		port map(rst => rst, clk => clk, en_reg => en_reg_mem, b_op => b_op_mem, j_op => j_op_mem, jal_op => jal_op_mem, alu_out => alu_out, dataout_from_mem => dataout_from_mem, addr_mem => addr_mem, datain_mem => datain_mem,
				 r2_out => aluR2_to_mem, PC => pc_from_ex_to_mem, lab_b => b_from_ex_to_mem, lab_j => j_from_ex_to_mem, rw_exe => rw_from_ex_to_mem, next_PC => pc_from_mem_to_fetch, alu_out_mem => alu_out_mem, rw_mem => ADD_RW,
				 data_out => data_from_mem_to_wb);
-----------------------------------------WB STAGE--------------------------------------------------
		WBU: writeBackUnit
		port map( MemtoReg => MemtoReg_wb, ReadData => data_from_mem_to_wb, AluResult => alu_out_mem, WriteData => WriteData_wb);
		
		pipe_out <= WriteData_wb;
		

end Behavioral;
