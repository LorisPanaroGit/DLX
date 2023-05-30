library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_shift is
end tb_shift;

architecture tb of tb_shift is

	signal r1, r2, data_out : std_logic_vector(31 downto 0);
	signal log : std_logic;

	component shifter_dx
		generic(nbit : integer := 32);
		port(r1 	  : in std_logic_vector(nbit-1 downto 0);
			 r2 	  : in std_logic_vector(nbit-1 downto 0);
			 log	  : in std_logic;
			 data_out : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	begin

		r1 <= x"80004531", x"8023A560" after 2 ns;
		r2 <= x"00000001", x"00000003" after 1 ns;
		log <= '1', '0' after 0.5 ns, '1' after 1.5 ns;

		sh: shifter_dx 
		generic map(nbit => 32)
		port map(r1 => r1, r2 => r2, data_out => data_out, log => log);
end tb;
