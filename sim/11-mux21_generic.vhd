library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;



entity MUX21_GENERIC is
	generic(NBIT : integer := numBit);
	port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     B	 : in std_logic_vector(NBIT - 1 downto 0);
	     SEL : in std_logic;
	     Y   : out std_logic_vector(NBIT - 1 downto 0)
	 );
end MUX21_GENERIC;

architecture BEHAVIORAL of MUX21_GENERIC is
	begin
          with SEL select
			Y <= A when '0',
				 B when others;
end BEHAVIORAL;


