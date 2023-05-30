library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity GENERAL_PG is
	port (
		G_in,P_in,G_in_prev,P_in_prev :		in	std_logic;
		G_out,P_out :	out	std_logic );
end GENERAL_PG;

architecture BEHAVIORAL of GENERAL_PG is

begin

	process(G_in,P_in,G_in_prev,P_in_prev)
	begin
		G_out <= G_in or (P_in and G_in_prev);
		P_out <= P_in and P_in_prev;
	end process;
	
end BEHAVIORAL;