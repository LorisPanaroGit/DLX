library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity and_gate is
	generic(nbit : integer := numBit);
	port(A, B : in std_logic_vector(nbit-1 downto 0);
		 Y    : out std_logic_vector(nbit-1 downto 0)
	);
end and_gate;

architecture beh of and_gate is
	begin
		Y <= A and B;
end beh;
