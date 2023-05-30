library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
-------------------------------------------------------------------
entity SUMGEN is
	generic(NBIT : integer := numBit;
		    NBLOCKS : integer := Blocks
	);
	port(A        :  in std_logic_vector(NBIT - 1 downto 0);
	     B	      :  in std_logic_vector(NBIT - 1 downto 0);
	     cin_vect :  in std_logic_vector(NBLOCKS - 1 downto 0);
		 Co       : out std_logic;
	     SUM      : out std_logic_vector(NBIT - 1 downto 0)
	);
end SUMGEN;
-------------------------------------------------------------------
architecture STRUCTURAL of SUMGEN is
-------------------------------------------------------------------

	constant nBitBlock : integer := numBit/Blocks;

	component CSblock is
		generic(NBIT : integer := numBit);
		port(A   :  in std_logic_vector(NBIT - 1 downto 0);
		     B   :  in std_logic_vector(NBIT - 1 downto 0);
		     cin :  in std_logic;
		     Y   : out std_logic_vector(NBIT - 1 downto 0);
			 Co  : out std_logic
		);
	end component;
-------------------------------------------------------------------

	signal Co_out : std_logic_vector( NBLOCKS-1 downto 0);
	begin
	
	genloop : for i in 0 to  NBLOCKS - 1 generate
			block_i : CSblock 
				generic map(NBIT => numBit/Blocks)
				port map(A => A((i*nBitBlock + nBitBlock) - 1 downto i*nBitBlock), B => B((i*nBitBlock + nBitBlock) - 1 downto i*nBitBlock), cin => cin_vect(i), Y => SUM((i*nBitBlock + nBitBlock) - 1 downto i*nBitBlock), Co => Co_out(i));
	end generate;	
    Co <= Co_out( NBLOCKS - 1);
end STRUCTURAL;

