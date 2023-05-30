library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity fetchUnit is
	generic(nbit : integer := numBit);
	port(Clk,Rst,en_reg : in std_logic;
	     PC_branch_jump			: in std_logic_vector(nbit-1 downto 0); --PC if thre is a branch or jump
	     --CU signal
	     PC_op          : in std_logic;
		 --output
		 PC_Next_out 	: out std_logic_vector(nbit-1 downto 0);
		 IRAM_reg_out 	: out std_logic_vector(nbit-1 downto 0)
	);
end fetchUnit;

architecture Behavioral of fetchUnit is

	component IRAM is
  		generic (
    		RAM_DEPTH : integer := 48;
    		I_SIZE    : integer := 32);
  		port (
    		Rst  : in  std_logic;
    		Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    		Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    	);
	end component;

	--component PC is
		--port(rst    : in std_logic;
			-- CK    : in std_logic;
			 --en 	: in std_logic;
			 --datain : in std_logic_vector(31 downto 0);
		     --PC     : out std_logic_vector(31 downto 0)
		--);
	--end component;

	component P4_ADDER is
		generic(NBIT           : integer := numBit;
			    NBIT_PER_BLOCK : integer := BitperBlock
		);
		port(A    : in std_logic_vector(NBIT - 1 downto 0);
		     B    : in std_logic_vector(NBIT - 1 downto 0);
		     Cin  : in std_logic;
		     Cout : out std_logic;
		     Y    : out std_logic_vector(NBIT - 1 downto 0)
		);
	end component;
	
		component REG_GEN is
    	Generic(NBIT     : integer := 32);
		Port(D           : in	std_logic_vector(NBIT - 1 downto 0);
			 CK,Enable_n : in	std_logic;   
			 RESET_n     : in	std_logic;   
			 Q           : out	std_logic_vector(NBIT - 1 downto 0));
	end component;
	
	component mux21_generic is
		generic(NBIT : integer := numBit);
		port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     	B	 : in std_logic_vector(NBIT - 1 downto 0);
	     	SEL : in std_logic;
	     	Y   : out std_logic_vector(NBIT - 1 downto 0)
	 	);
	end component;

--PC signals
	signal PC_in 		  : std_logic_vector(nbit-1 downto 0); --output of mux
	signal PC_out         : std_logic_vector(nbit-1 downto 0);  --output of PC
	signal PC_Next        : std_logic_vector(nbit-1 downto 0); --output of PC+4
	signal Cout_PC_add    : std_logic; --NON SERVE 

--IRAM signals
	signal IRAM_out       : std_logic_vector(nbit-1 downto 0); --output of IRAM

begin

-----------------------------------------IF STAGE--------------------------------------------------
--MUX
	mux_PC: mux21_generic
	port map(A => PC_Next, B =>PC_branch_jump , SEL => PC_op, Y => PC_in);
--PC
		PC_block: REG_GEN
		port map(D => PC_in, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => PC_out);
		--port map(rst => Rst, CK => Clk, en => en_reg, datain =>PC_in , PC => PC_out);  

--IRAM
		IRAM_block: IRAM
	    port map(Rst => Rst, Addr => PC_out, Dout => IRAM_out); 

--PC_Next
		PC_ADD: P4_ADDER 
		port map(A => PC_out, B => std_logic_vector(to_unsigned(4,PC_out'length)), Cin => '0', Cout => Cout_PC_add, Y => PC_Next);

--IF Registers
--PC_Next_out <= PC_Next;
--IRAM_reg_out <= IRAM_out;
		IF_reg_PC_Next: REG_GEN 
		port map(D => PC_Next, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => PC_Next_out);  

		IF_reg_IRAM_out: REG_GEN
	    port map(D => IRAM_out, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => IRAM_reg_out);

end Behavioral;
