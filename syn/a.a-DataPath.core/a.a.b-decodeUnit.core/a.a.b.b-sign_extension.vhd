library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity sign_extension is
	generic(sign_init  : integer := 16;
		    sign_ext   : integer := 32
	);
	port(data_in  : in std_logic_vector(sign_init - 1 downto 0);
		 data_out : out std_logic_vector(sign_ext - 1 downto 0)
	);
end sign_extension;

architecture BEH of sign_extension is

	signal extension : std_logic_vector(sign_ext - sign_init - 1 downto 0);

	begin
		extension <= (others => data_in(sign_init - 1));
		data_out <= extension & data_in;

end BEH;
