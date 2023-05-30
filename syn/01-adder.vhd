library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use work.constants.all;

entity adder is
	generic(N: integer := numBit);
	port(
		A: in std_logic_vector(N*2-2 downto 0);
		B: in std_logic_vector(N*2-2 downto 0);
		Y: out std_logic_vector(N*2-2 downto 0)
	);
end adder;

architecture Behavioral of adder is

begin
	Y <= A + B;
end Behavioral;
