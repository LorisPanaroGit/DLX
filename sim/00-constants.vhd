package CONSTANTS is
	constant IVDELAY : time := 0.1 ns;
	constant NDDELAY : time := 0.2 ns;
	constant NDDELAYRISE : time := 0.6 ns;
	constant NDDELAYFALL : time := 0.4 ns;
	constant NRDELAY : time := 0.2 ns;
	constant DRCAS : time := 1 ns;
	constant DRCAC : time := 2 ns;
	constant numBit : integer := 32;
	constant BitperBlock : integer := 4;
	constant Blocks : integer := numBit/BitperBlock;
	constant TP_MUX : time := 0 ns; 	--0.5 ns

	type ALU_OP is (ADD_OP, SUB_OP, MULT_OP, AND_OP, OR_OP, XOR_OP, LSL_OP, LSR_OP);
end CONSTANTS;
