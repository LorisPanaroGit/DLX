library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity a_DLX_tb is
end a_DLX_tb;

architecture BEH of a_DLX_tb is

component DLX is
  generic ( nbit     : integer := 32);      
  port (
    Clk : in std_logic;
    Rst : in std_logic;                -- Active Low
    dlx_data_out : out std_logic_vector(nbit-1 downto 0)
   );
end component;

------------------------------------------------------------------------------------
	signal clk_s 		  : std_logic;  --Clock
	signal rst_s          : std_logic;  --Reset
	signal dlx_data_out_s : std_logic_vector(31 downto 0);
	
------------------------------------------------------------------------------------
	begin

	clk_process : process
	begin
		clk_s <= '0';
		wait for 1 ns;
		clk_s <= '1';
		wait for 1 ns;
	end process;

	test_p: process
	begin
		rst_s <= '0';
		wait for 4 ns;	
		rst_s <= '1';
		wait;

	end process test_p;



	dlx_uut: DLX
	port map(
	       Clk => clk_s,
		   Rst => rst_s,               -- Active Low
           dlx_data_out => dlx_data_out_s
	);

------------------------------------------------------------------------------------
end BEH;
