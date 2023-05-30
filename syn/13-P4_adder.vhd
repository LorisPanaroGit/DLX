library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity P4_ADDER is
	generic(NBIT : integer := numBit;
		    NBIT_PER_BLOCK : integer := BitperBlock
	);
	port(A    : in std_logic_vector(NBIT - 1 downto 0);
	     B    : in std_logic_vector(NBIT - 1 downto 0);
	     Cin  : in std_logic;
	     Cout : out std_logic;
	     Y    : out std_logic_vector(NBIT - 1 downto 0)
	);
end P4_ADDER;

architecture STRUCTURAL of P4_ADDER is
	
	signal outCarryGen : std_logic_vector(NBIT/NBIT_PER_BLOCK - 1 downto 0);

	component CARRY_GENERATOR is
		generic(NBIT : integer:= numBit;
			    NBIT_PER_BLOCK : integer := BitperBlock 
		);
		port(A   : in std_logic_vector(NBIT - 1 downto 0);
		     B   : in std_logic_vector(NBIT - 1 downto 0);
		     Cin : in std_logic;
		     Co  : out std_logic_vector(NBIT/NBIT_PER_BLOCK - 1 downto 0)
		);
	end component;

	component SUMGEN is
		generic(NBIT : integer;
			    NBLOCKS : integer
		);
		port(A        :  in std_logic_vector(NBIT - 1 downto 0);
	    	 B	      :  in std_logic_vector(NBIT - 1 downto 0);
	    	 cin_vect :  in std_logic_vector(NBLOCKS - 1 downto 0);
		     Co       :  out std_logic;
	   	     SUM      :  out std_logic_vector(NBIT - 1 downto 0)
		);
		end component;
	
	begin

	CG : CARRY_GENERATOR
	     generic map(NBIT => numBit,
			         NBIT_PER_BLOCK => BitperBlock)
	     port map(A => A, B => B, Cin => Cin, Co => outCarryGen);

	SG : SUMGEN
	     generic map(NBIT => numBit,
			 		 NBLOCKS => numBit/BitperBlock)
	     port map(A => A, B => B, cin_vect => outCarryGen, Co => Cout, SUM => Y);

end STRUCTURAL;

