library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;

entity alu is
	port(data_in1 : in std_logic_vector(31 downto 0);
		 data_in2 : in std_logic_vector(31 downto 0);
		 op_sel   : in std_logic_vector(3 downto 0); 
		 data_out : out std_logic_vector(31 downto 0)
	);
end alu;

architecture BEH of alu is
------------------------------------------------------------------------------------
	--add = 0000
	--sub = 0001
	--and = 0010
	--or  = 0011
	--xor = 0100
	--lsl = 0101
	--lsr = 0110
	--asl = 0111
	--asr = 1000
	--mul = 1001
	--beqz = 1010
	--bnez = 1011
	--sge = 1100
	--sle = 1101
	--sne = 1110
------------------------------------------------------------------------------------
	component P4_ADDER is
		generic(nbit : integer := numBit;
				nbit_per_block : integer := BitperBlock
		);
		port(A    : in std_logic_vector(nbit-1 downto 0);
			 B    : in std_logic_vector(nbit-1 downto 0);
			 Cin  : in std_logic;
			 Cout : out std_logic;
			 Y    : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component and_gate is
		generic(nbit : integer := numBit);
		port(A, B : in std_logic_vector(nbit-1 downto 0);
		 	 Y    : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component or_gate is
		generic(nbit : integer := numBit);
		port(A, B : in std_logic_vector(nbit-1 downto 0);
		 	 Y    : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component xor_gate is
		generic(nbit : integer := numBit);
		port(A, B : in std_logic_vector(nbit-1 downto 0);
		 	 Y    : out std_logic_vector(nbit-1 downto 0)
		);
	end component;


--	component BOOTHMUL is
--		generic(N : integer := numBit);
--		port(A : in std_logic_vector(N-1 downto 0);
--			 B : in std_logic_vector(N-1 downto 0);
--			 Y : out std_logic_vector(N*2-1 downto 0)
--		);
--	end component;

	component shifter_sx is
		generic(nbit  : integer := 32);
		port(r1 	  : in std_logic_vector(nbit-1 downto 0);
			 r2 	  : in std_logic_vector(nbit-1 downto 0);
			 data_out : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component shifter_dx is
		generic(nbit  : integer := 32);
		port(r1 	  : in std_logic_vector(nbit-1 downto 0);
			 r2 	  : in std_logic_vector(nbit-1 downto 0);
			 log	  : in std_logic;
			 data_out : out std_logic_vector(nbit-1 downto 0)
		);

	end component;

	component comparator is
		port(r1 	  : in std_logic_vector(31 downto 0);
			 r2 	  : in std_logic_vector(31 downto 0);
			 sel 	  : in std_logic_vector(2 downto 0);
			 data_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component mux11to1 is
		generic(nbit : integer := numBit);
		port(A, B, C, D, E, F, H : in std_logic_vector(nbit-1 downto 0); --levato G per mult
			 sel		   : in std_logic_vector(3 downto 0);
			 Y			   : out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	component mux21_generic is
		generic(NBIT : integer := numBit);
		port(A	 : in std_logic_vector(NBIT - 1 downto 0);
	     	B	 : in std_logic_vector(NBIT - 1 downto 0);
	     	SEL : in std_logic;
	     	Y   : out std_logic_vector(NBIT - 1 downto 0)
	 	);
	end component;
------------------------------------------------------------------------------------
	signal p4_out, and_out, or_out, xor_out, sl_out, sr_out, mul_out, cmp_out : std_logic_vector(31 downto 0);
	signal data_in2_compl, p4_operand : std_logic_vector(31 downto 0);
	signal cmp_sel   : std_logic_vector(2 downto 0);
	signal mux_sel   : std_logic_vector(3 downto 0);
	signal add_sel	 : std_logic;
	signal p4_cin    : std_logic;
	signal p4_cout   : std_logic;
	signal log_shift : std_logic;
------------------------------------------------------------------------------------
	begin

	--add = 0000
	--sub = 0001
	--and = 0010
	--or  = 0011
	--xor = 0100
	--lsl = 0101
	--lsr = 0110
	--asl = 0111
	--asr = 1000
	--mul = 1001
	--beqz = 1010
	--bnez = 1011
	--sge = 1100
	--sle = 1101
	--sne = 1110

	data_in2_compl <= not data_in2;
	
	alu_proc: process(data_in1, data_in2, op_sel)
	begin
		case op_sel is
			when "0000" => --add
				p4_cin <= '0';
				add_sel <= '0';
				mux_sel <= "0000";
			when "0001" => --sub
				p4_cin <= '1';
				add_sel <= '1';
				mux_sel <= "0000";
			when "0010" => --and
				mux_sel <= "0001";
			when "0011" => --or
				mux_sel <= "0010";
			when "0100" => --xor
				mux_sel <= "0011";
			when "0101" => --lsl
				log_shift <= '1';
				mux_sel <= "0100";
			when "0110" => --lsr
				log_shift <= '1';
				mux_sel <= "0101";
			when "0111" => --asl
				log_shift <= '0';
				mux_sel <= "0100";
			when "1000" => --asr
				log_shift <= '0';
				mux_sel <= "0101";
--			when "1001" => --mul
--				mux_sel <= "0110";	
			when "1010" => --beqz
				mux_sel <= "0111";
				cmp_sel <= "000";
			when "1011" => --bnez
				mux_sel <= "0111";
				cmp_sel <= "100";
			when "1100" =>	--sge
				mux_sel <= "0111";
				cmp_sel <= "010";
			when "1101" => --sle
				mux_sel <= "0111";
				cmp_sel <= "001";
			when "1110" => --sne
				mux_sel <= "0111";
				cmp_sel <= "100";
			when others =>
				
		end case;
	end process;	
------------------------------------------------------------------------------------
	mux_p4: mux21_generic
	port map(A => data_in2, B => data_in2_compl, SEL => add_sel, Y => p4_operand);

	add: P4_ADDER
	generic map(nbit => numBit) 
	port map(A => data_in1, B => p4_operand, Cin => p4_cin, Cout => p4_cout, Y => p4_out);

--	mul: BOOTHMUL
--	generic map(N => 16)
--	port map(A => data_in1(15 downto 0), B => data_in2(15 downto 0), Y => mul_out);

	and_m: and_gate
	port map(A => data_in1, B => data_in2, Y => and_out);

	or_m: or_gate
	port map(A => data_in1, B => data_in2, Y => or_out);

	xor_m: xor_gate
	port map(A => data_in1, B => data_in2, Y => xor_out);

	sl: shifter_sx
	port map(r1 => data_in1, r2 => data_in2, data_out => sl_out);

	sr: shifter_dx
	port map(r1 => data_in1, r2 => data_in2, log => log_shift, data_out => sr_out);

	cmp: comparator
	port map(r1 => data_in1, r2 => data_in2, sel => cmp_sel, data_out => cmp_out);

	mux: mux11to1
	port map(A => p4_out, B => and_out, C => or_out, D => xor_out, E => sl_out, F => sr_out, H => cmp_out, sel => mux_sel, Y => data_out); --levato G per mult
------------------------------------------------------------------------------------
end BEH;
