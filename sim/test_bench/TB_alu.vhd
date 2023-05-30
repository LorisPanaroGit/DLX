library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity alu_tb is

end alu_tb;

architecture BEH of alu_tb is	
------------------------------------------------------------------------------------
	component alu is
		port(data_in1 : in std_logic_vector(31 downto 0);
			 data_in2 : in std_logic_vector(31 downto 0);
			 op_sel   : in std_logic_vector(3 downto 0); 
			 data_out : out std_logic_vector(31 downto 0)
		);
	end component;
------------------------------------------------------------------------------------
	signal data_in1_s   : std_logic_vector(31 downto 0);
	signal data_in2_s   : std_logic_vector(31 downto 0);
	signal op_sel_s     : std_logic_vector(3 downto 0); 
	signal data_out_s   : std_logic_vector(31 downto 0);
------------------------------------------------------------------------------------
	
	begin
	
	--add = 0000
	--sub = 0001
	--and = 0010
	--or  = 0011
	--xor = 0100
	--lsl = 0101
	--lsr = 0110
	--mul = 0111
	--div = 1000
	--seq = 1001
	--sne = 1010


	--data_in1_s <=	X"800F030A";
	
	--data_in2_s <=	X"00C0D009",
	--				X"00000004" after 25 ns;
	
	--op_sel_s <=	"0001",
	--			"0000" after 5 ns,
	--			"0010" after 10 ns,
	--			"0011" after 15 ns,
	--			"0100" after 20 ns,
	--			"0101" after 25 ns,
	--			"0110" after 30 ns,	
	--			"0111" after 35 ns;

	test_p: process
	begin

		data_in1_s <= X"800F030A";
		
		
		--lsl
		data_in2_s <= X"00000004";
		op_sel_s <= "0101";		
		wait for 1 ns;
		assert data_out_s = X"00F030A0" report "logical shift left error";
		wait for 4 ns;

		--add
		data_in2_s <= X"00C0D009";
		op_sel_s <= "0000";
		wait for 1 ns;
		assert data_out_s = X"80CFD313" report "sum error";
		wait for 4 ns;
		
		--sub
		op_sel_s <= "0001";
		wait for 1 ns;
		assert data_out_s = X"7F4E3301" report "subtraction error";
		wait for 4 ns;
		
		--and
		op_sel_s <= "0010";
		wait for 1 ns;
		assert data_out_s = X"00000008" report "and operation error";
		wait for 4 ns;

		--or
		op_sel_s <= "0011";
		wait for 1 ns;
		assert data_out_s = X"80CFD30B" report "or operation error";
		wait for 4 ns;

		--xor
		op_sel_s <= "0100";
		wait for 1 ns;
		assert data_out_s = X"80CFD303" report "xor operation error";
		wait for 4 ns;

		--lsl
		data_in2_s <= X"00000004";
		op_sel_s <= "0101";
		wait for 1 ns;
		assert data_out_s = X"00F030A0" report "logical shift left error";
		wait for 4 ns;

		--lsr
		op_sel_s <= "0110";
		wait for 1 ns;
		assert data_out_s = X"0800F030" report "logical shift right error";
		wait for 4 ns;

		--mult
		data_in2_s <= X"0000000A";
		op_sel_s <= "1001";		
		wait for 1 ns;
		assert data_out_s = X"00001E64" report "multiplication error";
		wait for 4 ns;


		--asr
		data_in1_s <= X"8000000D";
		data_in2_s <= X"00000004";
		op_sel_s <= "1000";		
		wait for 1 ns;
		assert data_out_s = X"F8000000" report "arithmetic shift right error";
		wait for 4 ns;

		--beqz
		data_in1_s <= X"8000000D";
		data_in2_s <= X"00000000";
		op_sel_s <= "1010";		
		wait for 1 ns;
		assert data_out_s = X"00000000" report "branch equal zero that must be false error";
		wait for 4 ns;

		--beqz
		data_in1_s <= X"00000000";
		data_in2_s <= X"00000000";
		op_sel_s <= "1010";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "branch equal zero that must be true error";
		wait for 4 ns;

		--bnez
		data_in1_s <= X"00000000";
		data_in2_s <= X"00000000";
		op_sel_s <= "1011";		
		wait for 1 ns;
		assert data_out_s = X"00000000" report "branch not equal zero that must be false error";
		wait for 4 ns;

		--bnez
		data_in1_s <= X"00000001";
		data_in2_s <= X"00000000";
		op_sel_s <= "1011";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "branch not equal zero that must be true error";
		wait for 4 ns;

		--sge
		data_in1_s <= X"00000009";
		data_in2_s <= X"00000008";
		op_sel_s <= "1100";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set greater equal with grater value error";
		wait for 4 ns;

		--sge
		data_in1_s <= X"00000009";
		data_in2_s <= X"00000009";
		op_sel_s <= "1100";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set greater equal with equal value error";
		wait for 4 ns;

		--sge
		data_in1_s <= X"00000008";
		data_in2_s <= X"00000009";
		op_sel_s <= "1100";		
		wait for 1 ns;
		assert data_out_s = X"00000000" report "set greater equal with lower value error";
		wait for 4 ns;


		--sle
		data_in1_s <= X"00000008";
		data_in2_s <= X"00000009";
		op_sel_s <= "1101";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set lower equal with lower value error";
		wait for 4 ns;


		--sle
		data_in1_s <= X"00000008";
		data_in2_s <= X"00000008";
		op_sel_s <= "1101";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set lower equal with equal value error";
		wait for 4 ns;


		--sle
		data_in1_s <= X"00000009";
		data_in2_s <= X"00000008";
		op_sel_s <= "1101";		
		wait for 1 ns;
		assert data_out_s = X"00000000" report "set lower equal with greater value error";
		wait for 4 ns;


		--sne
		data_in1_s <= X"00000009";
		data_in2_s <= X"00000008";
		op_sel_s <= "1110";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set lower equal with not equal value value error";
		wait for 4 ns;

		--sne
		data_in1_s <= X"00000009";
		data_in2_s <= X"00000009";
		op_sel_s <= "1110";		
		wait for 1 ns;
		assert data_out_s = X"00000001" report "set lower equal with equal value value error";
		wait for 4 ns;
	
		wait;

	end process test_p;
	
	--add port map for the clock
	alu_uut1: alu 
	port map(data_in1 => data_in1_s, data_in2 => data_in2_s, op_sel => op_sel_s, data_out => data_out_s);

	

end BEH;
