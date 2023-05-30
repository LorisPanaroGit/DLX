library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity xor_gate is
	generic(nbit : integer := numBit);
	port(A, B : in std_logic_vector(nbit-1 downto 0);
		 Y    : out std_logic_vector(nbit-1 downto 0)
	);
end xor_gate;

architecture beh of xor_gate is
	begin
		Y <= A xor B;
end beh;
