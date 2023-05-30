library IEEE;
use IEEE.std_logic_1164.all; 

entity flip_flop is
	Port(D           : in	std_logic;
		 CK,Enable_n : in	std_logic;   
		 RESET_n     : in	std_logic;   
		 Q           : out	std_logic);
end flip_flop;

architecture FF_ASYNCH of flip_flop is 

begin
	
	PASYNCH: process(CK,RESET_n)
	begin
		if RESET_n='0' then
	    	Q <= '0';
	  	elsif CK'event and CK = '1' then 
			if Enable_n = '0' then
	   	 		Q <= D; 
			end if;
	  	end if;
	end process;

end FF_ASYNCH;
