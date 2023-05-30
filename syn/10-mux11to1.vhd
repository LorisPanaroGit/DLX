library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity mux11to1 is
	generic(nbit : integer := numBit);
	port(A, B, C, D, E, F, H : in std_logic_vector(nbit-1 downto 0); --levato G per la mult
		 sel		   : in std_logic_vector(3 downto 0);
		 Y			   : out std_logic_vector(nbit-1 downto 0)
	);
end mux11to1;

architecture beh of mux11to1 is
	begin 
		with sel select
			Y <= A when "0000", B when "0001", C when "0010", D when "0011", E when "0100", F when "0101", H when "0111", (others => '0') when others;
end beh;
