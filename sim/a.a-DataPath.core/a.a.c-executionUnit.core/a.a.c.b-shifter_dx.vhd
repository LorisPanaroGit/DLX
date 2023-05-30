library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity shifter_dx is
	generic(nbit : integer := 32);
	port(r1 	  : in std_logic_vector(nbit-1 downto 0);
		 r2 	  : in std_logic_vector(nbit-1 downto 0);
		 log      : in std_logic;
		 data_out : out std_logic_vector(nbit-1 downto 0)
	);
end shifter_dx;

architecture beh of shifter_dx is
	begin
		sh: process(r1, r2, log)
		begin
			if r2 < nbit then 
				if r2 = 0 then
					data_out <= r1;
				elsif r2 = 1 then
					if log = '1' then
						data_out <= '0' & r1(nbit-1 downto 1);
					else
						data_out <= r1(nbit-1) & r1(nbit-1 downto 1);
					end if;
				else
					if log = '1' then
						for i in 2 to nbit-1 loop
							if i = r2 then
								data_out(nbit-1 downto nbit-i) <= (others => '0');
								data_out(nbit-1-i downto 0) <= r1(nbit-1 downto i);
							end if;
						end loop;
					else
						for i in 2 to nbit-1 loop
							if i = r2 then
								data_out(nbit-1 downto nbit-i) <= (others => r1(nbit-1));
								data_out(nbit-1-i downto 0) <= r1(nbit-1 downto i);
							end if;
						end loop;
					end if;
				end if;			
			else
				data_out <= (others => '0'); --maybe MSB od r1
			end if;	
		end process;
end beh;
