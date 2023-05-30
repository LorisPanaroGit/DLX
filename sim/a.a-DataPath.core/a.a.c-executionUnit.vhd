library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity executionUnit is
	generic(nbit 	 : integer := numbit);
	port(r1      	 : in std_logic_vector(nbit-1 downto 0);
		 r2      	 : in std_logic_vector(nbit-1 downto 0);
		 imm     	 : in std_logic_vector(nbit-1 downto 0);
		 j_lab   	 : in std_logic_vector(nbit-1 downto 0);
		 pc	       	 : in std_logic_vector(nbit-1 downto 0);
		 RW_R        : in std_logic_vector(nbit-1 downto 0);
		 RW_I        : in std_logic_vector(nbit-1 downto 0);
		 s2	     	 : in std_logic;
		 s3	     	 : in std_logic;
		 rst     	 : in std_logic;
		 clk	 	 : in std_logic;
	     en_reg  	 : in std_logic;
		 alu_sel 	 : in std_logic_vector(3 downto 0);
		 alu_out 	 : out std_logic_vector(nbit-1 downto 0);
		 alu_fw_out  : out std_logic_vector(nbit-1 downto 0);
		 r2_out 	 : out std_logic_vector(nbit-1 downto 0);
		 b_lab_out   : out std_logic_vector(nbit-1 downto 0);
		 pc_exe_out  : out std_logic_vector(nbit-1 downto 0);
		 rw_exe		 : out std_logic_vector(nbit-1 downto 0);
		 j_lab_out   : out std_logic_vector(nbit-1 downto 0)
	);
end executionUnit;

architecture struct of executionUnit is
-------------------------------------------------------------------------------
	signal mux_out, alu_out_s, pc_b, pc_j, rw_s : std_logic_vector(nbit-1 downto 0);
	signal c_out_b, c_out_j : std_logic;
	
	component mux21_generic is
		generic(NBIT : integer := numBit);
		port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     	 B	 : in std_logic_vector(NBIT - 1 downto 0);
	     	 SEL : in std_logic;
	     	 Y   : out std_logic_vector(NBIT - 1 downto 0)
	 	);
	end component;

	component reg_gen is
    	Generic(NBIT     : integer := numBit);
		Port(D           : in	std_logic_vector(NBIT - 1 downto 0);
			 CK,Enable_n : in	std_logic;   
			 RESET_n     : in	std_logic;   
			 Q           : out	std_logic_vector(NBIT - 1 downto 0)
		);
	end component;

	component alu is 
		port(data_in1 : in std_logic_vector(31 downto 0);
			 data_in2 : in std_logic_vector(31 downto 0);
			 op_sel   : in std_logic_vector(3 downto 0); 
		 	 data_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component P4_ADDER is
		generic(nbit : integer := numBit;
				nbit_per_block : integer := BitperBlock
		);
		port(A    : in std_logic_vector(nbit-1 downto 0);
			 B    : in std_logic_vector(nbit-1 downto 0);
			 Cin  : in std_logic;
			 Cout : out std_logic;
			 Y    : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

-------------------------------------------------------------------------------
	begin
	
	lo_mux: mux21_generic
	port map(A => r2, B => imm, SEL => s2, Y => mux_out);
	
	RW_mux: mux21_generic
	port map(A => RW_R, B => RW_I, SEL => s3, Y => rw_s);

	alu_dut: alu
	port map(data_in1 => r1, data_in2 => mux_out, op_sel => alu_sel, data_out => alu_out_s);

	reg_alu: reg_gen
	port map(D => alu_out_s, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => alu_out);

	ls_reg: reg_gen
	port map(D => r2, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => r2_out);

	pc_br: P4_adder
	port map(A => imm, B => pc, Cin => '0', Cout => c_out_b, Y => pc_b);

	pc_jp: P4_adder
	port map(A => j_lab, B => pc, Cin => '0', Cout => c_out_j, Y => pc_j);

	pc_reg_b: reg_gen
	port map(D => pc_b, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => b_lab_out);

	pc_reg_j: reg_gen
	port map(D => pc_j, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => j_lab_out);
	
	pc_reg: reg_gen
	port map(D => pc, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => pc_exe_out);
	
	rw_reg: reg_gen
	port map(D => rw_s, CK => clk, Enable_n => en_reg, RESET_n => rst, Q => rw_exe);

	alu_fw_out <= alu_out_s;

end struct; 
