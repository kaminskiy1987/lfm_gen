library IEEE, ieee_proposed;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use ieee_proposed.fixed_pkg.all;


entity ampl  is

	generic (
		--amax : integer := 8191;
		amax : integer := 32766;
		dbmax : integer := 70;
		dbmin : integer := -30;
		--nnominal : real := 5.2;--real 13.3
		nnominal_7 : real := 7.0;--real 13.3
		nnominal_11 : real := 11.0;
		nnominal_14 : real := 14.0;
		nnominal_63 : real := 63.0;
	   data_level: integer := 6;
		int : integer := 11;
		fract : integer := -15
	);
	
	port(
		---тактова€
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		en_noise : in std_logic;
		---”ровень сигнала в ƒб (0-63 ƒб), адрес дл€ ѕ«” ƒб-> разы 
		--U : in std_logic_vector ( data_level - 1 downto 0);
		U : in std_logic_vector ( data_level - 1 downto 0);

		---”ровень сигнала в разах
		U_r : out sfixed(int - 1 downto fract)-- (17 downto 0)
	);
end ampl ;

architecture Behavioral of ampl  is

	Signal U_r_i : integer;
	Signal U_r_p : sfixed(int - 1 downto fract);
	Signal U_threshold : std_logic_vector ( data_level - 1 downto 0);
	
    
	type int_array is array (natural range <>) of integer;
	
	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);	

	
	function kkk(k : integer) return sfixed is
		variable res : sfixed(int - 1 downto fract);
		variable gamma : real := real(amax)/real(nnominal_11);
		constant a_g : real  := 8.0;
		constant a_d : real := 1.0;
	begin
		res := to_sfixed(((1.4142 * 10.0 ** (real(k)/20.0))/gamma), int - 1, fract);
		return res;
	end function;
	
	function make_amplf_table(begin_dB : integer; end_dB : integer) return sfixed_array is
		variable table : sfixed_array(begin_dB to end_dB);
	begin
		for d in begin_dB to end_dB loop
		   table(d) := kkk(d);
		end loop;
		return table;
	end function;
	
	
	constant amplf_table : sfixed_array := make_amplf_table(dbmin, dbmax);
	
	attribute keep : string;
	attribute keep of U : signal is "true";
	attribute keep of U_r : signal is "true";
	
begin
  
	--U_r_p <= to_sfixed(3.5 , int - 1, fract) when pcc = '1' else to_sfixed(3.5 , int - 1, fract) ;
	U_r_p <= to_sfixed(1.00 , int - 1, fract) ;
			
  
	process (Clk_96, Ce_F6)		
	begin	
		if Clk_96'event and Clk_96 = '1' then
			if Ce_F6 = '1' then
				if U(data_level - 1) = '1' then
					U_r <= resize (amplf_table(to_integer(signed(U(data_level - 1)  & not(U(data_level - 2 downto 0)))) + 1)* U_r_p , int - 1, fract) ;
				else
					U_r <= resize ( amplf_table(to_integer(signed(U))) * U_r_p, int - 1, fract);
				end if;
			end if; 
		end if;
  end process;
  


end Behavioral;







