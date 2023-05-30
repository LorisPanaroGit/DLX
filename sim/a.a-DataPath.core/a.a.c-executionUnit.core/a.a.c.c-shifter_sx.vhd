library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity shifter_sx is
	generic(nbit : integer := 32);
	port(r1 	  : in std_logic_vector(nbit-1 downto 0);
		 r2 	  : in std_logic_vector(nbit-1 downto 0);
		 data_out : out std_logic_vector(nbit-1 downto 0)
	);
end shifter_sx;

architecture beh of shifter_sx is
	begin
		sh: process(r1, r2)
		begin
			if r2 < nbit then
				if r2 = 0 then
					data_out <= r1;
				elsif r2 = 1 then
					data_out <= r1(nbit-2 downto 0) & '0';
				else
					for i in 2 to nbit-1 loop
						if i = r2 then
							data_out(nbit-1 downto i) <= r1(nbit-1-i downto 0);
							data_out(i-1 downto 0) <= (others => '0'); 
						end if;
					end loop;
				end if;
			else
				data_out <= (others => '0');
			end if;
		end process;
end beh;
