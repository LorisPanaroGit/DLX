library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity tb_branch is
end tb_branch;

architecture beh of tb_branch is
	component branch_block is
		generic(nbit : integer := numBit);
		port(branch_op   : in std_logic;							--comes from CU
			 branch_cond : in std_logic;							--LSB of ALU out
			 PC 	   	 : in std_logic_vector(nbit-1 downto 0);	--normal PC
			 label_PC 	 : in std_logic_vector(nbit-1 downto 0);	--label of branch
	    	 next_PC 	 : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	signal branch_op_s, branch_cond_s : std_logic;
	signal PC_s, label_PC_s, next_PC_s : std_logic_vector(31 downto 0);

	begin
	branch_op_s <= '1', '0' after 5 ns, '1' after 10 ns, '0' after 20 ns;
	branch_cond_s <= '1', '0' after 12 ns;
	PC_s <= x"12345678";
	label_PC_s <= x"98765432";

	dut: branch_block
	port map(branch_op => branch_op_s, branch_cond => branch_cond_s, PC => PC_s, label_PC => label_PC_s, next_PC => next_PC_s);

end beh;
