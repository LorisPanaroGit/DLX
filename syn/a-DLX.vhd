library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity DLX is
  generic ( nbit     : integer := 32);      
  port (
    Clk : in std_logic;
    Rst : in std_logic;                -- Active Low
    
    --IF output signal for external IRAM
    dout_IRAM	 : in std_logic_vector(nbit-1 downto 0);
	addr_IRAM 	 : out std_logic_vector(nbit-1 downto 0);
	--MEM output signals for external memory
	MEM_EN_MEM         : out std_logic; --enables memstage data memory
	RD_MEM   	       : out std_logic;
	WR_MEM	           : out std_logic;
	dataout_from_mem : in std_logic_vector(nbit-1 downto 0);	--data sent to datapath from external memory (LOAD)
	addr_mem : out std_logic_vector(nbit-1 downto 0);	--address to be sent to external memory
	datain_mem : out std_logic_vector(nbit-1 downto 0);	--data to be sent to external memory (STORE)
    dlx_data_out : out std_logic_vector(nbit-1 downto 0)
   );
end DLX;


architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------

component datapath is
	generic(nbit     : integer := 32);
	port(Clk 		 : in std_logic;  --Clock
		 Rst         : in std_logic;  --Reset
		
		------IF STAGE------
	 	 PC_op       : in std_logic;
	 	 en_reg_if   : in std_logic;
	 	 RD1,RD2     : in std_logic;
		 dout_IRAM	 : in std_logic_vector(nbit-1 downto 0);
		 addr_IRAM 	 : out std_logic_vector(nbit-1 downto 0);
		------ID STAGE------
		 en_reg_id   : in std_logic;
	     WR          : in std_logic; --write signal for RegisterFile 
		 Opcode      : out std_logic_vector(5 downto 0);
	     Func        : out std_logic_vector(10 downto 0);
		------EX STAGE------
		 sel_ex	     : in std_logic; --I-immediate/read_data_2 selector
		 sel_mux_rw  : in std_logic; --0 if R-type, 1 if I-type
		 en_reg_ex   : in std_logic; --enables output registers of the execution unit
		 alu_sel	 : in std_logic_vector(3 downto 0); --selects alu operation
		------MEM STAGE-----
		 en_reg_mem  : in std_logic; --enables output register of the memory stage
--		 mem_en_mem  : in std_logic; --enables memstage data memory
--		 rd_mem	   	 : in std_logic;
--		 wr_mem 	 : in std_logic;
		 dataout_from_mem : in std_logic_vector(nbit-1 downto 0);	--data sent to datapath from external memory (LOAD)
		 addr_mem : out std_logic_vector(nbit-1 downto 0);	--address to be sent to external memory
		 datain_mem : out std_logic_vector(nbit-1 downto 0);	--data to be sent to external memory (STORE)
		 b_op_mem	 : in std_logic;
		 j_op_mem    : in std_logic;
		 jal_op_mem   : in std_logic;	
		------WB STAGE------
		 MemtoReg_wb : in std_logic;
		 pipe_out    : out std_logic_vector(nbit-1 downto 0)
	);
end component;
  
  -- Control Unit
component dlx_cu is
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

end component;

component flip_flop is
	Port(D           : in	std_logic;
		 CK,Enable_n : in	std_logic;   
		 RESET_n     : in	std_logic;   
		 Q           : out	std_logic);
end component;
  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------

  -- Control Unit Bus signals
  signal PC_op_i : std_logic;
  signal en_reg_if_i : std_logic;
  signal RD1_i : std_logic;
  signal RD2_i : std_logic; 
  signal en_reg_id_i : std_logic;
  signal WR_i : std_logic;
  signal sel_ex_i : std_logic;
  signal sel_mux_rw_i : std_logic;
  signal en_reg_ex_i : std_logic;
  signal en_reg_mem_i : std_logic;
  signal mem_en_mem_i : std_logic;
  signal rd_mem_i : std_logic;
  signal wr_mem_i : std_logic;
  signal b_op_mem_i : std_logic;
  signal j_op_mem_i : std_logic;
  signal jal_op_mem_i : std_logic;
  signal MemtoReg_wb_i : std_logic;
  signal Opcode_i : std_logic_vector(5 downto 0);
  signal Func_i : std_logic_vector(10 downto 0);
  signal alu_sel_i	 : std_logic_vector(3 downto 0);

  signal CU_en1, not_rst  : std_logic;
  signal CU_en2   : std_logic := '1';

  begin  -- DLX

    -- DataPath
    DataPath_dlx: datapath 
	port map(Clk => Clk,  --Clock
		 Rst => Rst,  --Reset		
		------IF STAGE------
	 	 PC_op => PC_op_i,
	 	 en_reg_if => en_reg_if_i,
	 	 RD1 => RD1_i,
	 	 RD2 => RD2_i,     
	 	 dout_IRAM => dout_IRAM,
	 	 addr_IRAM => addr_IRAM,
		------ID STAGE------
		 en_reg_id => en_reg_id_i,
	     WR => WR_i, --write signal for RegisterFile 
		 Opcode => Opcode_i,
	     Func => Func_i,
		------EX STAGE------
		 sel_ex	=> sel_ex_i, --I-immediate/read_data_2 selector
		 sel_mux_rw => sel_mux_rw_i, --0 if R-type, 1 if I-type
		 en_reg_ex => en_reg_ex_i, --enables output registers of the execution unit
		 alu_sel => alu_sel_i, --selects alu operation
		------MEM STAGE-----
		 en_reg_mem => en_reg_mem_i, --enables output register of the memory stage
--		 mem_en_mem => mem_en_mem_i, --enables memstage data memory
--		 rd_mem	=> rd_mem_i,
--		 wr_mem => wr_mem_i,
		 dataout_from_mem => dataout_from_mem,
		 addr_mem => addr_mem,
		 datain_mem => datain_mem,
		 b_op_mem => b_op_mem_i,
		 j_op_mem => j_op_mem_i,
		 jal_op_mem => jal_op_mem_i,
		------WB STAGE------
		 MemtoReg_wb => MemtoReg_wb_i,
		 pipe_out => dlx_data_out
	);
	
	not_rst <= not(Rst);
	FF1_en: flip_flop
	 port map(
		    D => not_rst,
		    CK => Clk,
		    Enable_n => '0',   
			RESET_n => '1',   
		    Q => CU_en1
	 	 );
    FF2_en: flip_flop
	 port map(
		    D => CU_en1,
			CK => Clk,
			Enable_n => '0',   
			RESET_n => '1',   
			Q => CU_en2
		);

     --Control Unit Instantiation
    CU_I: dlx_cu
      port map (
		  Clk => Clk,
		  Rst => Rst,
		  En => CU_en2,
          IR_opcode => Opcode_i,
          IR_func => Func_i,
          -- IF Control 
          PC_OP => PC_op_i,
          EN_REG_IF => en_reg_if_i,
          -- ID Control 
          EN_REG_ID => en_reg_id_i,
          RD1 => RD1_i,
          RD2 => RD2_i,
          -- EX Control 
          SEL_EX => sel_ex_i,
          EN_REG_EX => en_reg_ex_i,
          SEL_MUX_RW => sel_mux_rw_i,
          -- ALU
          ALU_OPCODE => alu_sel_i,
          -- MEM Control
          EN_REG_MEM => en_reg_mem_i,   
          MEM_EN_MEM => MEM_EN_MEM,  
          RD_MEM => RD_MEM,  	 
          WR_MEM => WR_MEM,	     
          B_OP_MEM => b_op_mem_i,	 
          J_OP_MEM => j_op_mem_i,  
          JAL_OP_MEM => jal_op_mem_i,        
          -- WB Control
          MEM_TO_REG_WB => MemtoReg_wb_i,
          WR => WR_i
       );          
      
end dlx_rtl;
