library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory  is
	port(rst     : in std_logic;
		 en      : in std_logic;
	     wr      : in std_logic;
	     rd      : in std_logic;
	     address : in std_logic_vector(31 downto 0); --32 bits because alu register out is on 32 bit (actually needed: 5)
	     datain  : in std_logic_vector(31 downto 0);
	     dataout : out std_logic_vector(31 downto 0)
	);	     
end DataMemory;

architecture BEH of DataMemory is

	type type_reg is array(0 to 31) of std_logic_vector(31 downto 0);
	signal registers : type_reg;

	begin
	rf: process(rst,en, wr, rd, address, datain)
	begin
		if rst = '0' then
			registers <= (others => (others => '0'));
		else  
			if en = '0' then
				if wr = '1' then
					registers(to_integer(unsigned(address))) <= datain;
				end if;
				if rd = '1' then
					dataout <= registers(to_integer(unsigned(address)));
				end if;
			else
				dataout <= (others => '0');
			end if;
		end if;
	end process;	
	
end BEH;
