library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;
--------------------------------------------------------------------------
entity CSblock is
	generic(NBIT : integer := BitperBlock);
	port(A   : in std_logic_vector(NBIT - 1 downto 0);
	     B   : in std_logic_vector(NBIT - 1 downto 0);
	     cin : in std_logic;
	     Y   : out std_logic_vector(NBIT - 1 downto 0);
	     Co  : out std_logic
	);
end CSblock;
--------------------------------------------------------------------------
architecture structural of CSblock is
--------------------------------------------------------------------------
	signal c0 : std_logic := '0';
	signal c1 : std_logic := '1';
	signal out0, out1, outMux, cout0, cout1, Co_out : std_logic_vector(NBIT - 1 downto 0);
--------------------------------------------------------------------------
	component RCA is
		generic(NBIT  : integer := numBit);
		port(A  : in std_logic_vector(NBIT - 1 downto 0);
		     B  : in std_logic_vector(NBIT - 1 downto 0);
		     Ci : in std_logic;
	 	     S  : out std_logic_vector(NBIT - 1 downto 0);
		     Co : out std_logic
		);
	end component;

	component MUX21_GENERIC is
		generic(NBIT : integer := numBit);
		port(A : in std_logic_vector(NBIT - 1 downto 0);
		     B : in std_logic_vector(NBIT - 1 downto 0);
		     SEL : in std_logic;
		     Y : out std_logic_vector(NBIT - 1 downto 0)
		);
	end component;
--------------------------------------------------------------------------
	begin
	
	add0 : RCA 
		generic map(NBIT => BitperBlock)
		port map(A => A, B => B, Ci => c0, S => out0, Co => cout0(0));
	add1 : RCA
		generic map(NBIT => BitperBlock)
		port map(A => A, B => B, Ci => c1, S => out1, Co => cout1(0));
	muxSum : MUX21_GENERIC
		generic map(NBIT => BitperBlock)
		port map(A => out0, B => out1, SEL => cin, Y => outMux);
	muxCout : MUX21_GENERIC
		generic map(NBIT => BitperBlock)
		port map(A => cout0, B => cout1, SEL => cin, Y => Co_out);

		Y <= outMux; 
		Co <= Co_out(0);
--------------------------------------------------------------------------
end structural;


