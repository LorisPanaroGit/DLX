library IEEE;
use IEEE.std_logic_1164.all; 

entity REG_GEN is
    Generic(NBIT     : integer := 32);
	Port(D           : in	std_logic_vector(NBIT - 1 downto 0);
		 CK,Enable_n : in	std_logic;   
		 RESET_n     : in	std_logic;   
		 Q           : out	std_logic_vector(NBIT - 1 downto 0));
end REG_GEN;

architecture REG_ASYNCH of REG_GEN is 

begin
	
	PASYNCH: process(CK,RESET_n)
	begin
		if RESET_n='0' then
	    	Q <= (others =>'0');
	  	elsif CK'event and CK = '1' then 
			if Enable_n = '0' then
	   	 		Q <= D; 
			end if;
	  	end if;
	end process;

end REG_ASYNCH;
