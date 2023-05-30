library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;
----------------------------------------------------------------------------------
entity branch_block is
	generic(nbit : integer := numBit);
	port(branch_op   : in std_logic;							--comes from CU
		 cmp_out     : in std_logic_vector(nbit-1 downto 0);	--out of comparator(alu)
		 PC 	   	 : in std_logic_vector(nbit-1 downto 0);	--normal PC
		 label_PC 	 : in std_logic_vector(nbit-1 downto 0);	--label of branch
	     next_PC 	 : out std_logic_vector(nbit-1 downto 0)
	);
end branch_block;
----------------------------------------------------------------------------------
architecture struct of branch_block is
----------------------------------------------------------------------------------
	signal branch_taken, branch_cond : std_logic;

	component mux21_generic is
		generic(nbit : integer := numBit);
		port(A	 : in std_logic_vector(nbit - 1 downto 0);
	    	 B	 : in std_logic_vector(nbit - 1 downto 0);
	    	 SEL : in std_logic;
	     	 Y   : out std_logic_vector(nbit - 1 downto 0)
	 	);
	end component;
----------------------------------------------------------------------------------
	begin	
	branch_cond <= cmp_out(0);
	branch_taken <= branch_op and branch_cond;

	next_pc_mux: mux21_generic
	port map(A => PC, B => label_PC, SEL => branch_taken, Y => next_PC);	--branch not taken: PC; otherwise branch to label

end struct;
