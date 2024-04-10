--synthesis library elementary
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mux_generic is
	generic( width : positive );
	port( 	input_0 : in unsigned ( 0 to width - 1 );
			input_1 : in unsigned ( 0 to width - 1 );
			clk : in std_logic;
			addres : in std_logic;
			output : out unsigned ( 0 to width - 1 ) 
		);
end entity mux_generic;

architecture behav_mux of mux_generic is
	begin
		--mux : process ( clk ) is
		mux : process ( input_1 ) is
		begin
--			output <= input_1;
			if ( clk'event and clk = '1' ) then
				if ( addres = '0' ) then
					output <= input_0;
				else
					output <= input_1;
				end if;
			end if; 
		end process mux;
end architecture behav_mux;