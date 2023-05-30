library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use WORK.all;
-----------------------------------------------------------------------------
entity register_file is
	generic(nbit_reg  : integer := 32;
	 	n_reg     : integer := 32;
	  	nbit_addr : integer := 5);

	port ( reset   : 	IN std_logic;
	       enable  : 	IN std_logic;
	       rd1     : 	IN std_logic;
	       rd2     : 	IN std_logic;
	       wr      : 	IN std_logic;
	       add_wr  : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	       add_rd1 : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	       add_rd2 : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	       datain  : 	IN std_logic_vector(nbit_reg  - 1 downto 0);
           out1    : 	OUT std_logic_vector(nbit_reg - 1 downto 0);
	       out2    : 	OUT std_logic_vector(nbit_reg - 1 downto 0));

end register_file;
-----------------------------------------------------------------------------

architecture BEHAVIORAL of register_file is
-----------------------------------------------------------------------------
        -- suggested structures
        subtype reg_addr is natural range 0 to n_reg - 1; -- using natural type
	type reg_array is array(reg_addr) of std_logic_vector(nbit_reg - 1 downto 0); 
	signal registers : reg_array; 

	
begin 
-----------------------------------------------------------------------------
	beh : process(enable, reset,rd1,rd2,wr,add_rd1,add_rd2,add_wr, datain)
	begin

		if reset = '0' then
	 		res_loop: for i in 0 to n_reg - 1 loop
					registers(i) <= (others => '0');
			end loop;
			
		elsif enable = '0' then
			if wr = '1' then --
				if to_integer(unsigned(add_wr)) /= 0 then 
				  registers(to_integer(unsigned(add_wr))) <= datain;
				end if;
			end if;
			
			if rd1 = '1' then
				out1 <= registers(to_integer(unsigned(add_rd1)));
			else
				out1 <= (others => 'X');
			end if;
			
			if rd2 = '1' then
				out2 <= registers(to_integer(unsigned(add_rd2)));
			else
				out2 <= (others => 'X');
			end if;	
		end if;	  	
	end process;

-----------------------------------------------------------------------------
end BEHAVIORAL;

-----------------------------------------------------------------------------
--configuration CFG_RF_BEH of register_file is
--  for BEHAVIORAL
--  end for;
--end configuration;
