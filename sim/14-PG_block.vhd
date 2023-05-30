library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PG_block is
	port (
		A :		in	std_logic;
		B :		in	std_logic;
		G :	out	std_logic;
		P :	out	std_logic );
end PG_block;

architecture BEHAVIORAL of PG_block is
begin
	process(A,B)
	begin
		P<=A xor B;
		G<=A and B;
	end process;
end BEHAVIORAL;