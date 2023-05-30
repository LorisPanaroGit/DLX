library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity memoryUnit is
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
		 addr_mem : out std_logic_vector(nbit-1 downto 0);			--address to be sent to external memory
		 datain_mem : out std_logic_vector(nbit-1 downto 0);		--data to be sent to external memory (STORE)
		 next_PC  : out std_logic_vector(nbit-1 downto 0);
		 alu_out_mem  : out std_logic_vector(nbit-1 downto 0);
		 rw_mem	  : out std_logic_vector(nbit-1 downto 0);
		 data_out : out std_logic_vector(nbit-1 downto 0)
	);
end memoryUnit;

architecture struct of memoryUnit is
---------------------------------------------------------------------
	signal rf_out, branch_pc : std_logic_vector(nbit-1 downto 0);
	signal data_mem_out : std_logic_vector(nbit-1 downto 0);  --output of Data Memory
	signal rw_out   : std_logic_vector(nbit-1 downto 0); --output of mux_r31 (for JAL)

	component branch_block is
		generic(nbit     : integer := numBit);
		port(branch_op   : in std_logic;							--comes from CU
			 cmp_out     : in std_logic_vector(nbit-1 downto 0);	--out of comparator(alu)
			 PC 	   	 : in std_logic_vector(nbit-1 downto 0);	--normal PC
			 label_PC 	 : in std_logic_vector(nbit-1 downto 0);	--label of branch
	    	 next_PC 	 : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

--	component DataMemory is
--		port(rst     : in std_logic;
--			 en      : in std_logic;
--		     wr      : in std_logic;
--		     rd      : in std_logic;
--		     address : in std_logic_vector(31 downto 0);
--		     datain  : in std_logic_vector(31 downto 0);
--		     dataout : out std_logic_vector(31 downto 0)
--		);	     
--	end component;

	component reg_gen is
    	Generic(NBIT     : integer := numBit);
		Port(D           : in	std_logic_vector(NBIT - 1 downto 0);
			 CK,Enable_n : in	std_logic;   
			 RESET_n     : in	std_logic;   
			 Q           : out	std_logic_vector(NBIT - 1 downto 0)
		);
	end component;

	component mux21_generic is
		generic(NBIT : integer := numBit);
		port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     	B	 : in std_logic_vector(NBIT - 1 downto 0);
	     	SEL : in std_logic;
	     	Y   : out std_logic_vector(NBIT - 1 downto 0)
	 	);
	end component;
---------------------------------------------------------------------
	begin 

	br_unit: branch_block
	port map(branch_op => b_op, cmp_out => alu_out,  PC => PC, label_PC => lab_b, next_PC => branch_pc);

	jmp_unit: mux21_generic
	port map(A => branch_pc, B => lab_j, SEL => j_op, Y => next_PC);

--	mem: DataMemory
--	port map(rst => rst, en => mem_en, wr => wr, rd => rd, address => alu_out, datain => r2_out, dataout => data_mem_out);
	addr_mem <= alu_out;
	data_mem_out <= dataout_from_mem;
	datain_mem <= r2_out;
	
    mux_jal_pc: mux21_generic  --for JAL
	port map(A => data_mem_out, B => PC, SEL => jal_op, Y => rf_out );
	
	mux_jal_r31: mux21_generic  --for JAL
	port map(A => rw_exe, B => "00000000000000000000000000011111" , SEL => jal_op, Y => rw_out );

	mem_reg: reg_gen
	port map(D => rf_out, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => data_out);
	
	rw_reg: reg_gen
	port map(D => rw_out, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => rw_mem);
	
	alu_reg: reg_gen
	port map(D => alu_out, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => alu_out_mem);
	
	

end struct;
