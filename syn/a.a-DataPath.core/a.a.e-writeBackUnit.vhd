library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity writeBackUnit is
	generic(nbit : integer := numbit);
	port(--rst : in std_logic;
		 --clk : in std_logic;
		 --en_reg : in std_logic;
		 MemtoReg		:	in std_logic;	--control signal
		 ReadData		:	in std_logic_vector(nbit - 1 downto 0);
		 --rw_from_exe    : 	in std_logic_vector(nbit - 1 downto 0);
		 AluResult		:	in std_logic_vector(nbit -1 downto 0);
		 WriteData		:	out std_logic_vector(nbit -1 downto 0)
	);
end writeBackUnit;

architecture struct of writeBackUnit is
-------------------------------------------------------------------------------
	component mux21_generic is
		generic(NBIT : integer := numBit);
		port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     	 B	 : in std_logic_vector(NBIT - 1 downto 0);
	     	 SEL : in std_logic;
	     	 Y   : out std_logic_vector(NBIT - 1 downto 0)
	 	);
	
	end component;
	
-------------------------------------------------------------------------------
	begin
	
	mux_writeBack: mux21_generic
	port map(A => ReadData, B => AluResult, SEL => MemtoReg, Y => WriteData);

end struct; 
