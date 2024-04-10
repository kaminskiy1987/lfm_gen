--library IEEE;
--	USE ieee.std_logic_1164.all;
--	USE ieee.std_logic_unsigned.all;
--	
--library ieee_proposed;
--	use ieee_proposed.fixed_pkg.all;
--	
--library elementary;
--	use elementary.s274types_pkg.all;
--	use elementary.utility.all;
--	use elementary.all;
--library modul_fir_filter;
--	use modul_fir_filter.all;
	
--library modul_awgn;
--	use modul_awgn.all;

library IEEE;
	USE ieee.std_logic_1164.all;
--	USE ieee.std_logic_unsigned.all;
--	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	USE ieee.std_logic_unsigned.all;
	USE ieee.numeric_std.all;
		 use ieee.math_real.all;

--use IEEE.NUMERIC_STD.ALL;
--use ieee.math_real.all;
	
library ieee_proposed;
	use ieee_proposed.fixed_pkg.all;
	use ieee_proposed.fixed_float_types.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;

--library modul_awgn;
--	use modul_awgn.all;  
-- library modul_fir_filter;
--	use modul_fir_filter.all;

entity Generator is

	generic (
	
		--int : integer := 11;
		--fract : integer := -15;
		int : integer := 16;
		fract : integer := -26;
		data_width: integer := 16;
	   data_rom : integer := 14;
		magic : integer := 0
		
				);
	port(
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		--ZMRSH : in std_logic;
    k : in sfixed(int - 1 downto fract);
    k_str_sh1 : in sfixed(int - 1 downto fract);
		rst : in std_logic;
		RND_str_sh1 : out std_logic_vector(data_rom-1 downto 0);
		RND_sin_out : out std_logic_vector(data_rom-1 downto 0);
		RND_cos_out : out std_logic_vector(data_rom-1 downto 0);
		RND_cos_out2 : out std_logic_vector(data_rom-1 downto 0);
		RND_sin_out2 : out std_logic_vector(data_rom-1 downto 0)
		--RND_6_Imp : out std_logic_vector(data_rom-1 downto 0);
		--RND_6_X : out std_logic_vector(9 downto 0)
		--RND_6_Imp : out std_logic_vector(9 downto 0);

		--tt : in std_logic_vector(3 downto 0)

		);
end Generator;

architecture Behavioral of Generator is

	signal Set : std_logic := '0';

	signal RND_6, RND_6_cos, RND_6_2, RND_6_cos_2  : std_logic_vector (15 downto 0):=(others => '0');
	--signal RND_6  : std_logic_vector (13 downto 0):=(others => '0');
	signal RND_6_Y_ram : std_logic_vector (9 downto 0):= "0000000000";
	signal RND_6_x_mult : std_logic_vector (9 downto 0):= "0000000000";
	Signal RND_6_un_cos, RND_6_un_reg_cos, RND_6_un_sin, RND_6_un_reg_sin, rnd_6_un_sin2, rnd_6_un_cos2 : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	signal RND_6_reg_cos, RND_6_reg_sin  : std_logic_vector (15 downto 0):=(others => '0');
	Signal RND_6_reg_sin2, RND_6_reg_cos2 : std_logic_vector(15 downto 0):=(others => '0');
	Signal RND_6_un1 : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	Signal bandpass_out : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	--Signal bandpass_out : std_logic_vector(data_width-1 downto 0):=(others => '0');
	--constant ku_bandpass : real := 2.4;
	constant ku_bandpass : real := 8.4;
	--signal ADDR_RND_XY  : std_logic_vector (5 downto 0) := (others => '0');
	Signal UC1_cos, UC2_cos, UC1_sin, UC1_sin2, UC1_cos2, sin_str_sh1 :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal UC1_cos_sfixed, UC1_sin_sfixed, UC1_cos_sfixed2, UC1_sin_sfixed2, str_sh1_sfixed : sfixed(int - 1 downto fract) := (others => '0'); 
	signal rst1, rst2 : std_logic := '0';
	--type ram_type is array (59 downto 0) of std_logic_vector (9 downto 0);--++++++
	--signal RAM: ram_type:= (others => "0000000000");
    constant t_48 : time := 20.833 ns;
	--signal RND_6 : std_logic_vector (data_rom-1 downto 0):= "00000000000000"; 
	--signal RND_6_Y_ram : std_logic_vector (data_rom-1 downto 0):= "00000000000000";
	signal ADDR_RND_XY  : std_logic_vector (5 downto 0) := (others => '0');
	  
	--type ram_type is array (59 downto 0) of std_logic_vector (data_rom-1 downto 0);--++++++
	--signal RAM: ram_type:= (others => "00000000000000");
	
	function calc( rnd	: std_logic_vector; size : integer) return std_logic_vector is
	variable res : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	--variable gamma : real := real(amax)/real(nnominal);
	begin
		 return conv_std_logic_vector((conv_integer(rnd) - 127) , size);
	end function;

--function calc1( rnd	: std_logic_vector; size : integer) return std_logic_vector is
--	variable res : std_logic_vector (data_rom-1 downto 0):=(others => '0');
--	--variable gamma : real := real(amax)/real(nnominal);
--	begin
--		 return std_logic_vector(real(to_integer(signed(rnd)) * 32.12) , size);
--	end function;

--	component modul_awgn is	
--		port(
--			Clk_96 : in std_logic;
--			Ce_F6 : in std_logic;
--			rst : in std_logic;
--			--RND_6_X : out std_logic_vector(15 downto 0)
--			RND_6_X : out std_logic_vector(13 downto 0)
--		);
--	end component;
	
	component modul_awgn is	
		port(
			Clk_96 : in std_logic;
			Ce_F6 : in std_logic;
			rst : in std_logic;
			urng_seed1 : in std_logic_vector(31 downto 0);
		  urng_seed2 : in std_logic_vector(31 downto 0);
		  urng_seed3 : in std_logic_vector(31 downto 0);
		  urng_seed4 : in std_logic_vector(31 downto 0);
		  urng_seed5 : in std_logic_vector(31 downto 0);
		  urng_seed6 : in std_logic_vector(31 downto 0);
			RND_6_X_cos : out std_logic_vector(15 downto 0);
			RND_6_X : out std_logic_vector(15 downto 0)

		);
	end component;
	
begin

--    rst1 <= '1', '0' after t_48 * 150, '1' after t_48 * 180 ;
--	 rst2 <= not(rst1);
--------------------------Генератор шума
	RND : modul_awgn
		port map(
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			rst => rst,
			urng_seed1 => "00000000000000000000000000000111",
			urng_seed2 => "00000000000000000000000000000111",
			urng_seed3 => "00000000000000000000000000000111",
			urng_seed4 => "00000000000000000000000000111000",
			urng_seed5 => "00000000000000000000000000111000",
			urng_seed6 => "00000000000000000000000000111000",
			RND_6_X_cos => RND_6_cos,
			RND_6_X => RND_6
		);
		
--		RND2 : modul_awgn
--		port map(
--			Clk_96 => Clk_96,
--			Ce_F6 => '1',
--			rst => rst,
--			urng_seed1 => "00000000000000000000001111111111",
--			urng_seed2 => "00000000000000000000001111111111",
--			urng_seed3 => "00000000000000000000001111111111",
--			urng_seed4 => "00000000000000000111111000000000",
--			urng_seed5 => "00000000000000000111111000000000",
--			urng_seed6 => "00000000000000000111111000000000",
--			RND_6_X_cos => RND_6_cos_2,
--			RND_6_X => RND_6_2
--		);
--	RND : modul_awgn
--		port map(
--			Clk_96 => Clk_96,
--			Ce_F6 => '1',
--			rst => rst,
--			RND_6_X => RND_6
--		);
		
		
	--	RND : entity modul_awgn.modul_awgn
--		port map(
--			Clk_96 => Clk_96,
--			Ce_F6 => '1',
--			rst => rst,
--			RND_6_X => RND_6
--		); 
--------------------------------------



--rnd_6_un <= (RND_6(9) & RND_6(9) & RND_6(9) & RND_6(9)  & RND_6(15 downto 6 )) when rising_edge(clk_96);
--rnd_6_un <= RND_6(15 downto 2 ) when rising_edge(clk_96);
--rnd_6_un_reg <=  "00" &(RND_6)  when rising_edge(clk_96);

 rnd_6_un_sin <=  "00000000" &( RND_6 (7 downto 0)) when rising_edge(clk_96);
 rnd_6_un_cos <=  "00000000" &( RND_6_cos (7 downto 0)) when rising_edge(clk_96);
 
 rnd_6_un_sin2 <=  "00000000" &( RND_6_2 (7 downto 0)) when rising_edge(clk_96);
 rnd_6_un_cos2 <=  "00000000" &( RND_6_cos_2 (7 downto 0)) when rising_edge(clk_96);
 
 --rnd_6_un <=  "000000" &( RND_6 (7 downto 0)) when rising_edge(clk_96);
--rnd_6_un <=  ( RND_6 - 127 ) when rising_edge(clk_96);
--rnd_6_un1 <= rnd_6_un when rising_edge(clk_96);
---------------------------------------------------------------------------------
T_process : process (clk_96, rnd_6_un_sin) is
	begin
		if rising_edge(clk_96) then
			--RND_6_reg <= calc(rnd_6_un, 14);
			RND_6_reg_sin <= calc(rnd_6_un_sin, 16);
		end if;
	end process;
	
T_process2 : process (clk_96, rnd_6_un_cos) is
	begin
		if rising_edge(clk_96) then
			--RND_6_reg <= calc(rnd_6_un, 14);
			RND_6_reg_cos <= calc(rnd_6_un_cos, 16);
		end if;
	end process;
	
--T_process3 : process (clk_96, rnd_6_un_sin2) is
--	begin
--		if rising_edge(clk_96) then
--			--RND_6_reg <= calc(rnd_6_un, 14);
--			RND_6_reg_sin2 <= calc(rnd_6_un_sin2, 16);
--		end if;
--	end process;
--	
--T_process4 : process (clk_96, rnd_6_un_cos2) is
--	begin
--		if rising_edge(clk_96) then
--			--RND_6_reg <= calc(rnd_6_un, 14);
--			RND_6_reg_cos2 <= calc(rnd_6_un_cos2, 16);
--		end if;
--	end process;

--20 ?.?.? - 0,2485
--10 ?.?.? - 0,1233
--8 ?.?.? - 0,0999
--5 ?.?.? - 0,0621

	MULT_UC1: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k,
					D_mult => RND_6_reg_sin, --in
					Q_mult => UC1_sin,	--out
					Q_mult_sfixed => UC1_sin_sfixed
					 );
					 
		MULT_UC2: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k,
					D_mult => RND_6_reg_cos, --in
					Q_mult => UC1_cos,	--out
					Q_mult_sfixed => UC1_cos_sfixed
					 );			 
	
--	MULT_UC3: entity elementary.sfixed_mult
--
--		 generic map( 
--					int => int,
--					fract => fract,
--					data_width => data_width
--					)
--		  port map (
--					R => '0',
--					Clk => Clk_96,
----					Ce_F6 => '1',
--					K_mult => k,
--					D_mult => RND_6_reg_sin2, --in
--					Q_mult => UC1_sin2,	--out
--					Q_mult_sfixed => UC1_sin_sfixed2
--					 );
--					 
--		MULT_UC4: entity elementary.sfixed_mult
--
--		 generic map( 
--					int => int,
--					fract => fract,
--					data_width => data_width
--					)
--		  port map (
--					R => '0',
--					Clk => Clk_96,
----					Ce_F6 => '1',
--					K_mult => k,
--					D_mult => RND_6_reg_cos2, --in
--					Q_mult => UC1_cos2,	--out
--					Q_mult_sfixed => UC1_cos_sfixed2
--					 );
--					 
			MULT_UC5: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k_str_sh1,
					D_mult => RND_6_reg_sin, --in
					Q_mult => sin_str_sh1,	--out
					Q_mult_sfixed => str_sh1_sfixed
					 );			 			 
	
--	bandpass_fir : entity modul_fir_filter.filter_part
--		generic map(
--			in_size => 16,
--			out_size => 16,
--			ku => ku_bandpass,
--			coefficients => (
----				 2, -4, -4, 4, 4, -6, -6, 7, 7, -8, -7, 8, 7, -7, -6, 5, 3, -2, 0, -1, -3,
----				 5, 6, -8, -8, 9, 8, -9, -7, 7, 5, -3, -1, -1, -4, 7, 8, -11, -12, 14, 13, -14,
----				 -12, 11, 8, -6, -3, -1, -5, 9, 12, -17, -18, 22, 21, -23, -21, 20, 15, -12, -6,
----				 0, -6, 14, 20, -27, -32, 38, 40, -43, -41, 39, 33, -26, -16, 4, -11, 27, 44, -64, -82,
----				 103, 121, -141, -156, 172, 183, -194, -199, 203, 203, -199, -194, 183, 172, -156, -141, 121,
----				 103, -82, -64, 44, 27, -11, 4, -16, -26, 33, 39, -41, -43, 40, 38, -32, -27, 20, 14, -6, 0, -6,
----				 -12, 15, 20, -21, -23, 21, 22, -18, -17, 12, 9, -5, -1, -3, -6, 8, 11, -12, -14, 13, 14, -12, -11,
----				 8, 7, -4, -1, -1, -3, 5, 7, -7, -9, 8, 9, -8, -8, 6, 5, -3, -1, 0, -2, 3, 5, -6, -7, 7, 8, -7, -8,
----				 7, 7, -6, -6, 4, 4, -4, -4, 2
--				 
--                 8, -16, -16, 16, 16, -24, -24, 28, 28, -32, -28, 32, 28, -28, -24, 20, 12, 
--        -8, 0, -4, -12, 20, 24, -32, -32, 36, 32, -36, -28, 28, 20, -12, -4, -4, 
--        -16, 28, 32, -44, -48, 56, 52, -56, -48, 44, 32, -24, -12, -4, -20, 36, 48, 
--        -68, -72, 88, 84, -92, -84, 80, 60, -48, -24, 0, -24, 56, 80, -108, -128, 152, 
--        160, -172, -164, 156, 132, -104, -64, 16, -44, 108, 176, -256, -328, 412, 484, -564, -624, 
--        688, 732, -776, -796, 812, 812, -796, -776, 732, 688, -624, -564, 484, 412, -328, -256, 176, 
--        108, -44, 16, -64, -104, 132, 156, -164, -172, 160, 152, -128, -108, 80, 56, -24, 0, 
--        -24, -48, 60, 80, -84, -92, 84, 88, -72, -68, 48, 36, -20, -4, -12, -24, 32, 
--        44, -48, -56, 52, 56, -48, -44, 32, 28, -16, -4, -4, -12, 20, 28, -28, -36, 
--        32, 36, -32, -32, 24, 20, -12, -4, 0, -8, 12, 20, -24, -28, 28, 32, -28, 
--        -32, 28, 28, -24, -24, 16, 16, -16, -16, 8
--			)
--		)
--		port map (
--			clk => Clk_96,
--         a => UC1_sin,
--			--a => rnd_6_un1,
--         b => bandpass_out
--      );
--------------------------------------------------------
RND_cos_out <= UC1_cos when rising_edge(clk_96);
RND_sin_out <= UC1_sin when rising_edge(clk_96);

RND_cos_out2 <= UC1_cos2 when rising_edge(clk_96);
RND_sin_out2 <= UC1_sin2 when rising_edge(clk_96);

RND_str_sh1 <= sin_str_sh1 when rising_edge(clk_96);

end Behavioral;
