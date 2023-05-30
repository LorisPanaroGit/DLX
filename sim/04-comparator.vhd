library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity comparator is
	port(r1 	  : in std_logic_vector(31 downto 0);
		 r2 	  : in std_logic_vector(31 downto 0);
		 sel 	  : in std_logic_vector(2 downto 0); 
		 data_out : out std_logic_vector(31 downto 0)
	);
end comparator;

architecture beh of comparator is
	--eq  = 000
	--leq = 001
	--gre = 010
	--low = 011
	--neq = 100
	--gr  = 101
	begin

		cmp: process(r1, r2, sel)
		begin
			case sel is
				when "000" =>
					if r1=r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when "001" =>
					if r1<=r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when "010" =>
					if r1>=r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when "011" =>
					if r1<r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when "100" =>
					if r1/=r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when "101" =>
					if r1>r2 then
						data_out <= (0 => '1', others => '0');
					else
						data_out <= (others => '0');
					end if;
				when others =>
						data_out <= (others => '0');
			end case;
		end process;
	
end beh;
