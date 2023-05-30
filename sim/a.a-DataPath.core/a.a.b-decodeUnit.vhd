library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity decodeUnit is
	generic(nbit : integer := numBit);
	port(Clk,Rst,en_reg,RD1,RD2      : in std_logic;
		 --IF signals
		 IRAM_instr 		 : in std_logic_vector(nbit-1 downto 0);
		 PC_Next 			 : in std_logic_vector(nbit-1 downto 0);
         --WB signals
		 WR                  : in std_logic;
		 ADD_RW 			 : in std_logic_vector(4 downto 0); --address_write of the WB stage
		 DATA_RW 			 : in std_logic_vector(nbit-1 downto 0); --data_write of the WB stage
		 --output for EX
		 RW_R_out 		     : out std_logic_vector(nbit-1 downto 0);
		 RW_I_out 		     : out std_logic_vector(nbit-1 downto 0);
		 Jump_address 		 : out std_logic_vector(nbit-1 downto 0);
		 I_immediate_ext_out : out std_logic_vector(nbit-1 downto 0);
		 RD_data_1_out 		 : out std_logic_vector(nbit-1 downto 0);
		 RD_data_2_out		 : out std_logic_vector(nbit-1 downto 0);
		 PC_Next_out 		 : out std_logic_vector(nbit-1 downto 0);
		 --output for CU
		 Opcode              : out std_logic_vector(5 downto 0);
		 Func                : out std_logic_vector(10 downto 0)
	);
end decodeUnit;

architecture Behavioral of decodeUnit is

	component register_file is
		generic(nbit_reg  : integer := 32;
	 		n_reg         : integer := 32;
	  		nbit_addr     : integer := 5);
		port ( reset   : 	IN std_logic;
	    	   enable  : 	IN std_logic;
	    	   rd1     : 	IN std_logic;
	    	   rd2     : 	IN std_logic;
	    	   wr      : 	IN std_logic;
	    	   add_wr  : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	    	   add_rd1 : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	   		   add_rd2 : 	IN std_logic_vector(nbit_addr - 1 downto 0);
	   		   datain  : 	IN std_logic_vector(nbit_reg  - 1 downto 0);
        	   out1    : 	OUT std_logic_vector(nbit_reg - 1 downto 0);
	       	   out2    : 	OUT std_logic_vector(nbit_reg - 1 downto 0));
	end component;

	component sign_extension is
		generic(sign_init  : integer := 16;
			    sign_ext   : integer := 32);
		port(data_in  : in std_logic_vector(sign_init - 1 downto 0);
			 data_out : out std_logic_vector(sign_ext - 1 downto 0));
	end component;

	component REG_GEN is
    	Generic(NBIT     : integer := 32);
		Port(D           : in	std_logic_vector(NBIT - 1 downto 0);
			 CK,Enable_n : in	std_logic;   
			 RESET_n     : in	std_logic;   
			 Q           : out	std_logic_vector(NBIT - 1 downto 0));
	end component;

--INSTRUCTION signals
	signal RA          : std_logic_vector(4 downto 0); --register address to be read, ADD_RD1
	signal RB          : std_logic_vector(4 downto 0); --register address to be read, ADD_RD2
	signal RW_R,RW_I   : std_logic_vector(nbit-1 downto 0); --register address to be written ADD_WR
	signal I_immediate : std_logic_vector(15 downto 0);
	signal J_immediate : std_logic_vector(25 downto 0);
--JUMP signals
	signal Jump_addr      : std_logic_vector(nbit-1 downto 0); --final jump address
--I-Immediate signals
	signal I_immediate_ext : std_logic_vector(nbit-1 downto 0); --Immediate I-instr sign extended
--REGISTER_FILE signals
	signal RD_data_1 : std_logic_vector(nbit-1 downto 0);
    signal RD_data_2 : std_logic_vector(nbit-1 downto 0);

begin

-----------------------------------------ID STAGE--------------------------------------------------

--INSTRUCTION MANAGEMENT
		Opcode <= IRAM_instr(31 downto 26);
		Func <= IRAM_instr(10 downto 0);
		RA <= IRAM_instr(25 downto 21);
		RB <= IRAM_instr(20 downto 16);
		RW_I <= (nbit-1 downto 5 => '0') & IRAM_instr(20 downto 16);
		RW_R <= (nbit-1 downto 5 => '0') & IRAM_instr(15 downto 11);
		I_immediate <= IRAM_instr(15 downto 0);
		J_immediate <= IRAM_instr(25 downto 0);

--JUMP ADDRESS
		--J_ADDR:	Jump_addr <=  PC_Next_reg(31 downto 28) & IRAM_out_reg(25 downto 0) & "00";
		SIGN_EXT_immediate_J: sign_extension 
		generic map(sign_init => 26, sign_ext => 32)
		port map(data_in => J_immediate, data_out => Jump_addr);

--REGISTERS FILE
		REGISTERS: register_file 
		port map(reset => Rst, enable => '0', rd1 => RD1, rd2 => RD2, wr => WR, add_wr => ADD_RW, add_rd1 => RA, add_rd2 => RB, 
                  datain => DATA_RW, out1 => RD_data_1, out2 => RD_data_2);

--SIGNED EXTENDED
		SIGN_EXT_immediate_I: sign_extension 
		port map(data_in => I_immediate, data_out => I_immediate_ext);

--ID Registers
		ID_reg_RW_R: REG_GEN 
		port map(D => RW_R, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => RW_R_out);  
		
		ID_reg_RW_I: REG_GEN 
		port map(D => RW_I, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => RW_I_out); 

		ID_reg_I_imm: REG_GEN
	    port map(D => I_immediate_ext, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => I_immediate_ext_out);
	    
	    ID_reg_J_imm: REG_GEN
	    port map(D => Jump_Addr, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => Jump_address);

		ID_reg_RD_data_1: REG_GEN
	    port map(D => RD_data_1, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => RD_data_1_out);

		ID_reg_RD_data_2: REG_GEN
	    port map(D => RD_data_2, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => RD_data_2_out);

		ID_reg_PC_next: REG_GEN
	    port map(D => PC_Next, CK => Clk, Enable_n => en_reg, RESET_n => Rst, Q => PC_Next_out);


end Behavioral;
