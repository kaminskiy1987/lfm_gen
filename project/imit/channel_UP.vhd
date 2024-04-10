

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	
library ieee_proposed;
	use ieee_proposed.fixed_pkg.all;

entity channel_UP is

	generic (
	
	  int : integer := 11;
		fract : integer := -15;
		data_width: integer := 14;
		data_level: integer := 6;
		data_pft: integer := 6;
		data_rom: integer := 14;
		data_distance : integer := 13;
		data_ppz : integer := 5;
		pft_widht : integer:= 8
		--pft_code : int_array := (0, 4, 6, 10, 12, 14, 21, 23, 25, 27);
		--length_array: int_array :=  (4195, 1959, 2439, 3359, 5607, 7719, 1633, 2113, 2563, 3043 ); 
    --  Delay_pp : integer := 8719;
   --   Delay : integer := 253;
      --Delay_C2 : integer := 8191
		--Delay_C22 : integer := 500000
	 --  Delay_C22 : integer := 16000
				);
	Port(
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		En :  in std_logic_vector (data_distance downto 1);
		OD : in std_logic;		
	   LG : in std_logic;		
	   TI : in std_logic;
		up : in std_logic;
		k_ap : in sfixed(int - 1 downto fract);
		Rom_UP_out : out std_logic_vector (data_rom-1 downto 0);
		Rom_UP_out_sfix : out sfixed(int - 1 downto fract)
	);

end channel_UP;

architecture Behavioral of channel_UP is

--Signal P1_P2_PFT : std_logic_vector(5 downto 1):=(others => '0');
	signal P2_PFT : std_logic_vector(data_pft downto 1):=(others => '0');
	
	signal Rom_cos_L7C3_i : integer;
	signal Rom_cos_L7C4_i : integer;
	signal Rom_cos_L11C3_i : integer;
	signal Rom_cos_L11C4_i : integer;
	signal Rom_cos_L15C3_i : integer;
   signal Rom_cos_L15C4_i : integer;
   signal Rom_cos_L19C3_i : integer;
	signal Rom_cos_L23C3_i : integer;
   signal Rom_cos_L23C4_i : integer;
	signal Rom_cos_L11_i : integer;
	signal Rom_cos_L15_i : integer;
	signal Rom_cos_L23_i : integer;
	signal Rom_cos_L30_i : integer;
	signal Rom_cos_L3_plus : integer;
	signal Rom_cos_L3_minus : integer;
	signal Rom_cos_L60_i : integer;
	signal Rom_sin_L60_i : integer;
	
	signal Rom_cos_L60_i2 : integer;
	signal Rom_sin_L60_i2 : integer;

  signal Rom_cos_out : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_out : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  
  signal Rom_cos_rg, Rom_up : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_rg : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_cos_rg2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_rg2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
--Signal Rom_sin_i : integer range -64 to 64;
--Signal Rom_cos_i : integer range -64 to 64;
	signal Rom_cos_i : integer;
	signal Rom_sin_i : integer;
	signal Rom_cos_i2 : integer;
	signal Rom_sin_i2 : integer;
	
	signal Rom_UP_sfixed  : sfixed(int - 1 downto fract):=(others => '0');
  signal EN_DNP1 : std_logic:= '0';
  constant inn_distance_range : integer := data_distance + 5;
  signal delay1 : std_logic_vector (inn_distance_range - 1  downto 0):= (others => '0');
begin



--------------------------------  L_cos наклон '+'
up_1: entity work.LHM_ALL_single
generic map(

		rom_cos =>		
(
-8, -5, 6, -4, -8, -4, 12, 0, -8, 
-3, 11, 0, -9, -3, 7, 0, -7, -2, 
9, -5, -9, -2, 8, 3, -7, -3, 9, 
-1, -10, 0, 5, -3, -7, 0, 6, 1, 
-9, 0, 7, 0, -3, 0, 10, 1, -3, 
0, 5, 0, -4, -2, 3, -3, -7, -4, 
3, 1, -3, -2, 6, 1, -4, -1, 5, 
2, -2, -2, 2, 2, -4, -5, 4, 4, 
-3, 1, 1, 0, -1, 0, 3, 0, -2, 
0, 3, 2, 0, 1, 3, -1, -2, 0, 
0, 2, -2, 0, 2, 3, 0, -1, 0, 
-3, 0, 1, 1, -2, -2, 5, -5, -2, 
2, 4, 0, 0, 3, 2, -1, -5, 3, 
6, -5, -1, 4, 4, -3, -3, 4, 4, 
-8, -3, 3, 0, -3, -4, 5, 2, -4, 
-7, 5, 8, -9, -9, 2, 8, -4, -5, 
7, 8, -3, -7, 4, 8, -3, -7, 5, 
7, -2, -11, 5, 4, -1, -7, 0, 8, 
-5, -5, 3, 10, -4, -10, 0, 9, 1, 
-11, 1, 8, 1, -11, -2, 13, 4, -12, 
-3, 10, 4, -10, -6, 7, 5, -10, -5, 
14, 6, -12, -6, 14, 10, -11, -9, 11, 
13, -11, -9, 12, 11, -12, -10, 12, 14, 
-13, -13, 10, 15, -8, -11, 12, 14, -11, 
-13, 14, 10, -15, -12, 11, 15, -11, -14, 
8, 17, -12, -12, 9, 15, -7, -15, 7, 
11, -8, -16, 9, 13, -16, -16, 8, 17, 
-8, -14, 5, 15, -3, -10, 4, 9, -5, 
-8, 5, 8, -4, -10, 3, 7, -6, -8, 
2, 4, -2, -5, 3, 2, -3, -2, 1, 
1, -2, -2, -2, 0, -1, 0, 0, 0, 
1, 2, -3, -3, 6, 6, -3, -5, 0, 
6, -5, -6, 4, 4, -5, -5, 7, 6, 
-5, -7, 2, 5, -5, -10, 6, 11, -9, 
-10, 3, 8, -6, -10, 5, 8, -11, -5, 
5, 11, -7, -7, 10, 8, -3, -7, 4, 
9, -3, -8, 3, 3, -3, -7, 3, 5, 
-1, -5, 5, 8, -1, -7, 4, 2, -1, 
-4, 3, 6, -3, -1, 2, 3, 0, -2, 
4, -3, 2, 0, -3, 0, 1, 0, 1, 
-4, 0, 0, -4, -1, 1, 4, -4, -8, 
5, 1, -4, -4, 3, 5, -3, -1, 6, 
5, -3, -10, 4, 5, -7, -4, 3, 7, 
-2, -5, 1, 7, -3, -6, 1, 1, 1, 
-6, 3, 9, 0, -3, 1, 4, 0, -4, 
-1, 2, -1, -4, 0, 1, 2, 0, -1, 
0, 2, -6, -4, -1, 5, -1, -3, 0, 
3, -3, -1, 2, 4, 0, -6, 0, 3, 
0, -2, 0, 3, 0, -5, 0, 5, 5, 
-4, 0, 3, 1, -4, 0, 4, 4, -6, 
0, 4, 2, -6, -2, 6, 3, -2, -4, 
1, 4, -2, -6, 4, 5, -2, -2, 0, 
5, -3, -6, 4, 6, 0, -3, 1, 7, 
0, -8, 0, 6, -1, -5, 0, 7, 0, 
-8, 2, 12, 2, -6, -1, 8, 1, -7, 
-1, 7, 2, -10, -2, 8, 5, -7, -1, 
9, 4, -8, 0, 8, 0, -6, 0, 12, 
4, -6, 0, 8, 0, -4, -2, 9, 1, 
-10, 0, 12, -2, -7, 0, 10, -2, -7, 
0, 5, -3, -10, 1, 5, -1, -4, 4, 
9, -3, -2, 8, 1, -9, -8, 6, 5, 
-10, -5, 5, 4, -6, 0, 9, 2, -5, 
0, 10, 3, -6, -3, 9, 1, -12, -1, 
13, -2, -14, -2, 10, 0, -10, 3, 12, 
-2, -13, 5, 12, -4, -14, 3, 13, 0, 
-15, 5, 12, -8, -14, 7, 15, -6, -13, 
8, 9, -9, -10, 5, 16, -6, -10, 2, 
7, -6, -11, 7, 8, -9, -9, 7, 10, 
-5, -8, 6, 6, -3, -11, 7, 7, -5, 
-9, 9, 6, -4, -5, 7, 5, -3, -4, 
0, 2, -2, -2, 5, 3, -1, -1, 3, 
0, -5, -1, 3, -4, 1, 0, 2, -1, 
0, 0, 1, 0, 3, -3, -1, 0, 2, 
-1, -6, 1, 3, 0, -1, 1, 4, 0, 
-11, 0, 4, -1, -6, -2, 2, -4, -4, 
0, 4, 0, -5, 4, 5, -2, -7, 3, 
9, 4, -4, 2, 6, -4, -4, 5, 5, 
-3, -8, 5, 4, -1, -4, 4, 7, 0, 
-5, 0, 6, -6, -2, 3, 4, -1, 0, 
1, 4, -2, -1, 2, 4, -1, -4, 2, 
2, -3, -1, 2, 0, -7, -2, 3, 0, 
-2, 0, 1, 1, -4, 0, 3, -2, -8, 
1, 5, -5, -6, 3, 1, -6, -4, 4, 
0, -9, -3, 4, 4, -5, -1, 5, -1, 
-3, 2, 7, 2, -8, -1, 6, 1, -6, 
-1, 9, 1, -3, 1, 6, -1, -7, 0, 
12, 0, -9, 1, 12, 0, -8, 0, 10, 
0, -12, 3, 13, 0, -9, 1, 9, 0, 
-16, -2, 12, 0, -10, 0, 10, 2, -12, 
0, 11, -1, -10, 1, 10, -2, -7, 4, 
12, -2, -8, 2, 6, -5, -12, 4, 3, 
-5, -5, 6, 9, 0, -3, 7, 5, -5, 
-4, 4, 2, -5, -1, 5, 1, -5, 1, 
3, -2, -5, 0, 6, -3, -9, 2, 6, 
0, -9, 7, 3, -6, -12, 5, 6, -6, 
-6, 7, 10, -3, -6, 6, 11, -5, -12, 
11, 9, -15, -11, 6, 11, -12, -11, 10, 
8, -12, -6, 9, 11, -13, -8, 10, 11, 
-13, -9, 9, 11, -11, -9, 12, 8, -9, 
-5, 13, 3, -12, -7, 10, 6, -9, -5, 
7, 6, -10, -6, 10, 4, -9, -6, 5, 
6, -6, -3, 6, 4, -7, -6, 3, 5, 
-7, -4, 2, 5, -2, -4, 6, 5, 0, 
0, 1, 0, -1, -3, -1, 2, 1, 0, 
-1, 0, 4, 1, -1, 2, 8, 0, -4, 
0, 5, 1, -5, 0, 6, 0, -6, 6, 
2, 1, -8, -2, 4, 1, 
0, 0, 0, 0, 0
)
)
 port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => Ce_F6,
			EN => EN_DNP1,
			Rom_cos_all => Rom_cos_L60_i--out
			 );
----------------------------------
  Rom_cos_i <= Rom_cos_L60_i when rising_edge(Clk_96);

 ------------------------------------------------------------- 
	process (Clk_96, up, EN_DNP1, Rom_cos_i)
	begin
	  if rising_edge(Clk_96) then
		if up = '1'  then
			if EN_DNP1 = '1' then
				Rom_cos_rg <= conv_std_logic_vector(Rom_cos_i, data_rom);
			else
				Rom_cos_rg <= (others => '0');
			end if;
		else
		  Rom_cos_rg <= (others => '0');
		end if;
	  end if;
   end process;
	
	delay1 <= conv_std_logic_vector(2888, inn_distance_range);
	
	Distance_PP: entity work.Distance_ap
		generic map( 
			data_distance => data_distance,
			pft_widht => pft_widht,
		--	pft_code => pft_code,
			data_pft => data_pft				
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			PI => up,--in
			--dpp1 => dpp1,
			D_delay => delay1,
			D => en ,--in
			PFT => (others => '0'), --in
			--OD => OD,--in
			OD => LG,--in
			--EN_Signal_D2 => EN_DNP2,
			EN_Signal_D => EN_DNP1--out
		);
		
	MULT_UP: entity elementary.sfixed_mult
		generic map( 
			int => int,
			fract=>fract,
			data_width=>data_width
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => k_ap,
			--D_mult => PP_cos_r1, --in
			D_mult =>  Rom_cos_rg, --in
			--D_mult =>  PP_cos_r, --in
			Q_mult => Rom_UP,
			Q_mult_sfixed => Rom_UP_sfixed			--out
		);

--------------------------------Out-------------
		process (clk_96) is
	begin
		if rising_edge(clk_96) then
		  Rom_UP_out <= Rom_UP;
		  Rom_UP_out_sfix <= Rom_UP_sfixed;-- to_sfixed(PP_cos, int - 1, fract);
		end if;
	end process;

end Behavioral;
