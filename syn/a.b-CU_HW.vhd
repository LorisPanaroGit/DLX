library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;
--use ieee.numeric_std.all;
--use work.all;

entity dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer := 45;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    -- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 13);  -- Control Word Size
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-Low
    En                 : in  std_logic;  -- Enable
    -- Instruction Register
    IR_opcode          : in std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
    IR_func            : in std_logic_vector(FUNC_SIZE-1 downto 0);   -- Func part of IR when Rtype
    
    -- IF Control Signal
	PC_OP              : out std_logic;
  	EN_REG_IF          : out std_logic;
	
    -- ID Control Signals
	EN_REG_ID          : out std_logic;
	RD1,RD2            : out std_logic;

    -- EX Control Signals
    SEL_EX	           : out std_logic; --I-immediate/read_data_2 selector
    EN_REG_EX          : out std_logic; --enables output registers of the execution unit
    SEL_MUX_RW         : out std_logic; --select the right RW according if there is a R-Type or I-Type
    -- ALU Operation Code
    ALU_OPCODE         : out std_logic_vector(ALU_SEL_SIZE -1 downto 0);
    
    -- MEM Control Signals
	EN_REG_MEM         : out std_logic; --enables output register of the memory stage
	MEM_EN_MEM         : out std_logic; --enables memstage data memory
	RD_MEM   	       : out std_logic;
	WR_MEM	           : out std_logic;
	B_OP_MEM	       : out std_logic;
	J_OP_MEM           : out std_logic;
	JAL_OP_MEM         : out std_logic;

    -- WB Control signals
    MEM_TO_REG_WB      : out std_logic;
    WR                 : out std_logic); --write signal for RegisterFile 

end dlx_cu;

architecture dlx_cu_hw of dlx_cu is
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := ("0001000000011", -- R type (ADD,SUB,AND,OR,SGE,SLE,SLL,SNE,SRL,XOR)
                                "0000000000000", --
                                "0001000101010", -- J 
                                "0001000111001", -- JAL 
                                "0101001001010", -- BEQZ 
                                "0101001001010", -- BNEZ
                                "0000000000000", -- 
                                "0000000000000", --
                                "1101000000011", -- ADDI
                                "0000000000000", -- 
                                "1101000000011", -- SUBI
                                "0000000000000", -- 
                                "1101000000011", -- ANDI
                                "1101000000011", -- ORI
                                "1101000000011", -- XORI
                                "0000000000000", -- 
                                "0000000000000", --
                                "0000000000000", -- 
                                "0000000000000", --
                                "0000000000000", -- 
                                "1101000000011", -- SLLI
                                "0011000000100", -- NOP
                                "1101000000011", -- SRLI
                                "0000000000000", -- 
                                "0000000000000", --
                                "1101000000011", -- SNEI
                                "0000000000000", --
                                "0000000000000", -- 
                                "1101000000011", -- SLEI
                                "1101000000011", -- SGEI
                                "0000000000000", --
                                "0000000000000", -- 
                                "0000000000000", --
                                "0000000000000", -- 
                                "0000000000000", --
                                "1100100000001", -- LW
                                "0000000000000", --
                                "0000000000000", -- 
                                "0000000000000", --
                                "0000000000000", --
                                "0000000000000", -- 
                                "0000000000000", --
                                "0000000000000", --
                                "1100010000010", -- SW
                                "0000000000000");
                                
                                
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem


  -- control word is shifted to the correct stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 downto 0); -- EX stage
  signal cw4 : std_logic_vector(CW_SIZE - 1 - 3 downto 0); -- MEM stage
  signal cw5 : std_logic_vector(CW_SIZE - 1 - 11 downto 0); -- WB stage


  signal aluOpcode_i: std_logic_vector(ALU_SEL_SIZE -1 downto 0) := NOP; -- ALUOP defined in package
  signal aluOpcode_3: std_logic_vector(ALU_SEL_SIZE -1 downto 0) := NOP; --ALUOP of EX stage

 
begin 

  cw <= cw_mem(conv_integer(IR_opcode));
  
  -- stage EX control signals
  SEL_EX     <= cw3(CW_SIZE - 1);
  SEL_MUX_RW <= cw3(CW_SIZE -2 ); 
   EN_REG_EX  <= cw3(CW_SIZE - 3);
  
  -- stage MEM control signals
  MEM_EN_MEM    <= cw4(CW_SIZE - 4);
  RD_MEM        <= cw4(CW_SIZE - 5);
  WR_MEM        <= cw4(CW_SIZE - 6);
  B_OP_MEM      <= cw4(CW_SIZE - 7);
  J_OP_MEM      <= cw4(CW_SIZE - 8);
  JAL_OP_MEM    <= cw4(CW_SIZE - 9);
    PC_OP      <= cw4(CW_SIZE -10); --control signal to IF stage
    EN_REG_MEM    <= cw4(CW_SIZE - 11); --control signal to IF stage
    
    
  -- stage WB control signals
  MEM_TO_REG_WB       <= cw5(CW_SIZE - 12);
  WR                  <= cw5(CW_SIZE - 13);


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '0' then                   -- asynchronous reset (active low)
      EN_REG_IF   <= '1';
      EN_REG_ID   <= '1';
	  RD1         <= '0';
	  RD2         <= '0';
  
      cw3 <= "0011000000110";
      cw4 <= "1000000110";
      cw5 <= "10";
     
      aluOpcode_3 <= "0000";

    elsif Clk'event and Clk = '1' then  -- rising clock edge
      EN_REG_IF   <= '0';
      EN_REG_ID   <= '0';
	  RD1         <= '1';
	  RD2         <= '1';
   
	  if En = '0' then
       cw3 <= cw;
      cw4 <= cw3(CW_SIZE - 1 - 3 downto 0);
      cw5 <= cw4(CW_SIZE -1 - 11 downto 0);

      aluOpcode_3 <= aluOpcode_i;
	  end if;

    end if;
  end process CW_PIPE;

  ALU_OPCODE <= aluOpcode_3;

  -- purpose: Generation of ALU OpCode
  -- type   : combinational
  -- inputs : IR_i
  -- outputs: aluOpcode
   ALU_OP_CODE_P : process (IR_opcode, IR_func)
   begin  -- process ALU_OP_CODE_P
	case conv_integer(unsigned(IR_opcode)) is
	        -- case of R type requires analysis of FUNC
		when 0 =>
			case conv_integer(unsigned(IR_func)) is
				when 4 => aluOpcode_i  <= SLL_R; -- SLL
				when 6 => aluOpcode_i  <= SRL_R; -- SRL
				when 32 => aluOpcode_i <= ADD; -- ADD
				when 34 => aluOpcode_i <= SUB_R; -- SUB
				when 36 => aluOpcode_i <= AND_R; -- AND
				when 37 => aluOpcode_i <= OR_R; -- OR
				when 38 => aluOpcode_i <= XOR_R; -- XOR
				when 41 => aluOpcode_i <= SNE; -- SNE
				when 44 => aluOpcode_i <= SLE; -- SLE
				when 45 => aluOpcode_i <= SGE; -- SGE
				when others => aluOpcode_i <= NOP;
			end case;
		when 2 => aluOpcode_i <= NOP; -- J
		when 3 => aluOpcode_i <= NOP; -- JAL
		when 4 => aluOpcode_i <= BEQZ; -- BEQZ
		when 5 => aluOpcode_i <= BNEZ; -- BENZ
		when 8 => aluOpcode_i <= ADD; -- ADDI
	    when 10 => aluOpcode_i <= SUB_R; -- SUBI
	    when 12 => aluOpcode_i <= AND_R; -- ANDI
	    when 13 => aluOpcode_i <= OR_R; -- ORI
	    when 14 => aluOpcode_i <= XOR_R; -- XORI
	    when 20 => aluOpcode_i <= SLL_R; -- SLLI
	    when 21 => aluOpcode_i <= NOP; -- NOP
	    when 22 => aluOpcode_i <= SRL_R; -- SRLI
	    when 25 => aluOpcode_i <= SNE; -- SNEI
	    when 28 => aluOpcode_i <= SLE; -- SLEI
	    when 29 => aluOpcode_i <= SGE; -- SGEI
	    when 35 => aluOpcode_i <= ADD; -- LW
	    when 43 => aluOpcode_i <= ADD; -- SW
		when others => aluOpcode_i <= NOP;
	 end case;
	end process ALU_OP_CODE_P;


end dlx_cu_hw;
