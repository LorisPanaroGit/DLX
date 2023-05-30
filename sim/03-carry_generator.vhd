library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity CARRY_GENERATOR is
	generic (
		NBIT :	integer := NumBit;
		NBIT_PER_BLOCK: integer := BitperBlock);
	port (
		A :		in	std_logic_vector(NBIT-1 downto 0);
		B :		in	std_logic_vector(NBIT-1 downto 0);
		Cin :	in	std_logic;
		Co :	out	std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
end CARRY_GENERATOR;

architecture STRUCTURAL of CARRY_GENERATOR is

	component PG_block 
	port (
		A :	in	std_logic;
		B :	in	std_logic;
		G :	out	std_logic;
		P :	out	std_logic );
   end component;
	
	component GENERAL_G 
	port (
		G_in,P_in,G_in_prev :		in	std_logic;
		G_out :	out	std_logic );
	end component;
	
	component GENERAL_PG 
	port (
		G_in,P_in,G_in_prev,P_in_prev :		in	std_logic;
		G_out,P_out :	out	std_logic );
   end component;

	type SignalVector is array (NBIT-1 downto 0) of std_logic_vector(NBIT-1 downto 0);
	signal g_vett : SignalVector;
	signal p_vett : SignalVector;
	signal first_generate : std_logic;

begin

	PGblock_first: PG_block port map (A=>A(0),B=>B(0),G=>first_generate,P=>p_vett(0)(0));
	G_first: GENERAL_G port map (G_in=>first_generate,P_in=>p_vett(0)(0),G_in_prev=>Cin,G_out=>g_vett(0)(0));
	
	PG_network: for i in 1 to NBIT-1 generate
		PG_0: PG_block port map (A=>A(i),B=>B(i),G=>g_vett(0)(i),P=>p_vett(0)(i));
	end generate;
	
	steps: for step in 0 to 2 generate
		step0: if step = 0 generate
			stages0: for stage in 0 to 7 generate
				first_stage0: if stage = 0 generate
					G_0: GENERAL_G port map (G_in=>g_vett(0)(1),P_in=>p_vett(0)(1),G_in_prev=>g_vett(0)(0),G_out=>g_vett(1)(0));
					PG_1: GENERAL_PG port map (G_in=>g_vett(0)(3),P_in=>p_vett(0)(3),G_in_prev=>g_vett(0)(2),P_in_prev=>p_vett(0)(2),G_out=>g_vett(1)(1),P_out=>p_vett(1)(1));
					G_1: GENERAL_G port map (G_in=>g_vett(1)(1),P_in=>p_vett(1)(1),G_in_prev=>g_vett(1)(0),G_out=>g_vett(2)(0));  --seconda riga
				end generate first_stage0;
				next_stage0: if stage > 0 generate
				   PG_2: GENERAL_PG port map (G_in=>g_vett(0)(1+4*stage),P_in=>p_vett(0)(1+4*stage),G_in_prev=>g_vett(0)(4*stage),P_in_prev=>p_vett(0)(4*stage),G_out=>g_vett(1)(2*stage),P_out=>p_vett(1)(2*stage));
					PG_3: GENERAL_PG port map (G_in=>g_vett(0)(3+4*stage),P_in=>p_vett(0)(3+4*stage),G_in_prev=>g_vett(0)(2+4*stage),P_in_prev=>p_vett(0)(2+4*stage),G_out=>g_vett(1)(1+2*stage),P_out=>p_vett(1)(1+2*stage));
					PG_4: GENERAL_PG port map (G_in=>g_vett(1)(1+2*stage),P_in=>p_vett(1)(1+2*stage),G_in_prev=>g_vett(1)(2*stage),P_in_prev=>p_vett(1)(2*stage),G_out=>g_vett(2)(stage),P_out=>p_vett(2)(stage));  --seconda riga
			   end generate next_stage0;
			end generate stages0;
		end generate step0;
		step1: if step = 1 generate
			stages1: for stage in 0 to 1 generate
				first_stage1: if stage = 0 generate
					G_2: GENERAL_G port map (G_in=>g_vett(2)(1),P_in=>p_vett(2)(1),G_in_prev=>g_vett(2)(0),G_out=>g_vett(3)(0));  --terza riga
					PG_5: GENERAL_PG port map (G_in=>g_vett(2)(3),P_in=>p_vett(2)(3),G_in_prev=>g_vett(2)(2),P_in_prev=>p_vett(2)(2),G_out=>g_vett(3)(1),P_out=>p_vett(3)(1));  --terza riga
					G_3: GENERAL_G port map (G_in=>g_vett(2)(2),P_in=>p_vett(2)(2),G_in_prev=>g_vett(3)(0),G_out=>g_vett(4)(0));  --quarta riga
					G_4: GENERAL_G port map (G_in=>g_vett(3)(1),P_in=>p_vett(3)(1),G_in_prev=>g_vett(3)(0),G_out=>g_vett(4)(1));  --quarta riga
				end generate first_stage1;
				next_stage1: if stage=1 generate
					PG_6: GENERAL_PG port map (G_in=>g_vett(2)(5),P_in=>p_vett(2)(5),G_in_prev=>g_vett(2)(4),P_in_prev=>p_vett(2)(4),G_out=>g_vett(3)(2),P_out=>p_vett(3)(2));  --terza riga
					PG_7: GENERAL_PG port map (G_in=>g_vett(2)(7),P_in=>p_vett(2)(7),G_in_prev=>g_vett(2)(6),P_in_prev=>p_vett(2)(6),G_out=>g_vett(3)(3),P_out=>p_vett(3)(3));  --terza riga
					PG_8: GENERAL_PG port map (G_in=>g_vett(2)(6),P_in=>p_vett(2)(6),G_in_prev=>g_vett(3)(2),P_in_prev=>p_vett(3)(2),G_out=>g_vett(4)(2),P_out=>p_vett(4)(2));  --quarta riga
					PG_9: GENERAL_PG port map (G_in=>g_vett(3)(3),P_in=>p_vett(3)(3),G_in_prev=>g_vett(3)(2),P_in_prev=>p_vett(3)(2),G_out=>g_vett(4)(3),P_out=>p_vett(4)(3));  --quarta riga
			   end generate next_stage1;
			end generate stages1;
		end generate step1;
		step2: if step = 2 generate
			stages2: for stage in 0 to 3 generate
				first_stage2: if stage = 0 generate
					G_5: GENERAL_G port map (G_in=>g_vett(2)(4),P_in=>p_vett(2)(4),G_in_prev=>g_vett(4)(1),G_out=>g_vett(5)(0));
				end generate first_stage2;
				second_stage2: if stage = 1 generate
					G_6: GENERAL_G port map (G_in=>g_vett(3)(2),P_in=>p_vett(3)(2),G_in_prev=>g_vett(4)(1),G_out=>g_vett(5)(1));
				end generate second_stage2;
				third_stage2: if stage = 2 generate
					G_7: GENERAL_G port map (G_in=>g_vett(4)(2),P_in=>p_vett(4)(2),G_in_prev=>g_vett(4)(1),G_out=>g_vett(5)(2));
				end generate third_stage2;
				fourth_stage2: if stage = 3 generate
					G_8: GENERAL_G port map (G_in=>g_vett(4)(3),P_in=>p_vett(4)(3),G_in_prev=>g_vett(4)(1),G_out=>g_vett(5)(3));
				end generate fourth_stage2;
			end generate stages2;
		end generate step2;
	end generate steps;	
	
	Co(0) <= Cin;
	Co(1) <= g_vett(2)(0);
	Co(2) <= g_vett(3)(0);
	Co(3) <= g_vett(4)(0);
	Co(4) <= g_vett(4)(1);
	Co(5) <= g_vett(5)(0);
	Co(6) <= g_vett(5)(1);
	Co(7) <= g_vett(5)(2);
	--Co(8) <= g_vett(5)(3);
	

end STRUCTURAL;
