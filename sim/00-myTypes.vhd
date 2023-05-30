library ieee;
use ieee.std_logic_1164.all;

package myTypes is

-- Control unit input sizes
    constant ALU_SEL_SIZE : integer :=  4; 

-- R-Type instruction -> FUNC field
    constant SLL_R : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0101";    -- SLL
    constant SRL_R : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0110";    -- SRL
    constant ADD   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0000";    -- ADD
    constant SUB_R : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0001";    -- SUB
    constant AND_R : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0010";    -- AND
    constant OR_R  : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0011";    -- OR
    constant XOR_R : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0100";    -- XOR
    constant SNE   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1110";    -- SNE
    constant SLE   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1101";    -- SLE
    constant SGE   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1100";    -- SGE
    constant BEQZ  : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1010";    -- BEQZ
    constant BNEZ  : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1011";    -- BNEZ
    constant MULT  : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1001";    -- MULT
    constant ASL   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0111";	-- ASL
	constant ASR   : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "1000";	-- ASR
    

    constant NOP : std_logic_vector(ALU_SEL_SIZE - 1 downto 0) :=  "0000";    -- NOP
   
end myTypes;

