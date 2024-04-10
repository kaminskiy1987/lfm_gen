--- Company: 
-- Engineer: 
-- 
-- Create Date:    10:36:14 07/05/2019 
-- Design Name: 
-- Module Name:    channel_c - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
	--use ieee.numeric_std.all;
	--use ieee.std_logic_1164.all;
	--use ieee.math_real.all;
	
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	Use ieee.std_logic_unsigned.all;
	USE ieee.math_real.all;
	USE std.textio.ALL;
	USE IEEE.std_logic_textio.ALL;  

library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;


library ieee_proposed;
	use ieee_proposed.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity channel_PP is
generic(

		int : integer := 11;
		fract : integer := -15;
		data_width: integer := 14;
		data_level: integer := 6;
		data_pft: integer := 6;
		data_rom: integer := 14;
		data_distance : integer := 13;
		data_ppz : integer := 5;
		pft_widht : integer:= 8;
		pft_code : int_array := (0, 4, 6, 10, 12, 14, 21, 23, 25, 27);
		length_array: int_array :=  (4195, 1959, 2439, 3359, 5607, 7719, 1633, 2113, 2563, 3043 ); 
      Delay_pp : integer := 8719;
      Delay : integer := 253;
      --Delay_C2 : integer := 8191
		--Delay_C22 : integer := 500000
	   Delay_C22 : integer := 16000
	);
	
	Port(
		Clk_96 : in std_logic;

		Ce_F6 : in std_logic;
		
		UPP : in std_logic_vector (data_level-1 downto 0);
		
		UPP2 : in std_logic_vector (data_level-1 downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		Sign_LCHM : in std_logic;
		
		fdev : in std_logic_vector (2 downto 0);
		
		fdop : in std_logic_vector (3 downto 0);
		
		fdop2 : in std_logic_vector (3 downto 0);
		
		DC1 : in std_logic_vector (data_distance downto 1);
		
		DC2 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		ppz_new : in std_logic_vector (6 downto 0);
		 
		PIPP_is : in std_logic;
		
		PIPP2_is : in std_logic;
		
		ppz_m : in std_logic_vector (4 downto 0);
		
		dpp1 : in integer;
      dpp2 : in integer;
		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		upp_cos_sfix : out sfixed(int - 1 downto fract);
		upp2_cos_sfix : out sfixed(int - 1 downto fract);
		PP : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end channel_PP;

architecture Behavioral of channel_PP is
	Signal UMP_r, UC1_r,UC2_r, UAP_r, UPP_r, UPP2_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal UPP_r1, UPP_r2 : std_logic_vector (data_level downto 0):=(others => '0');
	Signal PP_cos, PP_sin, PP_ram, PP_cos_r, PP_cos2, PP_cos_un,  PP_cos_r2, PP_cos_r1, PP_sin_r1 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UPP_cos :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UPP2_cos :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal EN_DNP1, EN_DNP_AP, nakl, EN_DNP2, C1, R : std_logic := '0';
	--constant DC2 	: std_logic_vector(13 downto 0)	:= "00001111101000";
	--constant UC2 : std_logic_vector(5 downto 0)	:= "010100";
	Signal UPP_cos_sfixed, UPP2_cos_sfixed : sfixed(int - 1 downto fract) := (others => '0');
	constant phasa : real := ieee.math_real.math_pi;
	constant	dopler: real := 0.000207;
	signal cnt : natural := 0;
	signal inn_strob : std_logic := '0';
	--constant inn_distance_range : integer := data_distance + 7;  
	constant inn_distance_range : integer := data_distance + 5; 
	signal delay1, delay2, delay3 : std_logic_vector (inn_distance_range - 1  downto 0):= (others => '0');
	constant N_const : integer := 7531;
	signal count: integer:= 0;
	signal N_out : integer:= 1;
	signal dpp_r : integer:= 0;
	signal en_loop, lg_delay, enable, pipp_un : std_logic := '0';
	
	--type str_int_array is array (natural range <>) of integer;
--	constant par_ti 	: str_int_array := (2880, 2912);
--	constant par_lg0 	: str_int_array := (510, 512); 
--	constant par_lg 	: str_int_array := (34582, 34614);
--	constant par_lg2 	: str_int_array := (69228, 69260);
--	constant par_lg3 	: str_int_array := (138520, 138552);
	
	--attribute keep : string;
	--attribute keep of UPP_cos_sfixed : signal is "true";
	--attribute keep of EN_DNP1 : signal is "true";
	--attribute keep of EN_DNP2 : signal is "true";

begin
-------------------------------------------
--pipp_un <= PIPP_is or PIPP2_is;

  process (PIPP_un)
		begin
			if  PIPP_un= '1'  then
				nakl <= not Sign_LCHM;			
			else
				nakl <=  Sign_LCHM;				
			end if;
		end process;
		
		---------------------------noise(3,0)-----------------
		 
	  --MUX_signal_type_C: entity work.mux_pp
		MUX_signal_type_PP: entity work.MUX_signal_type2
		generic map( 
					data_ppz => data_ppz,
					data_pft => data_pft,
					--phasa => phasa,
			      --dopler => dopler,
					data_rom => data_rom
					)

		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					OD => OD ,
					LG => lg , 
					TI => TI,
					PFT => PFT,
					fdev => fdev,
					--dpp1 => dpp1,
					--dpp2 => dpp2,
					fdop2  => fdop2,
					fdop => fdop,--in
					PIPP => PIPP_is,
					PIPP2 => PIPP2_is,
					ppz_new => ppz_new,
					ppz_m => ppz_m, --in
					Sign_LCHM => nakl, --in
					--Sign_LCHM => Sign_LCHM,
					EN  =>  EN_DNP1,
					EN2 =>  EN_DNP2,--in
					Rom_sin => PP_cos,
					Rom_sin2 => PP_sin--out			
					 );
					 
	--------------------------------ampl---------------------------

	UPP_r1 <= '0' & UPP;
	
	--Amplitude_signal_PP: entity work.Amplitude_signal1
	Amplitude_signal_PP: entity work.Amplitude_signal_ap

		generic map( 
			int => int,
			data_level => data_level +1,
			ap => false,
			fract => fract
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			U => UPP_r1,--in
			U_r => UPP_r 	--out		
		);
		
--	---------------------------------mult---------------------

	MULT_UPP: entity elementary.sfixed_mult
		generic map( 
			int => int,
			fract=>fract,
			data_width=>data_width
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => UPP_r,
			--D_mult => PP_cos_r1, --in
			D_mult => PP_cos, --in
			--D_mult =>  PP_cos_r, --in
			Q_mult => UPP_cos,
			Q_mult_sfixed => UPP_cos_sfixed			--out
		);
		
	----------------------------------dist--------------------
	delay1 <= conv_std_logic_vector(dpp1, inn_distance_range);
	
	Distance_PP: entity work.Distance_ap
		generic map( 
			data_distance => data_distance,
			pft_widht => pft_widht,
			pft_code => pft_code,
			data_pft => data_pft				
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			PI => PIPP_is,--in
			--dpp1 => dpp1,
			D_delay => delay1,
			D => DC1 ,--in
			PFT => PFT, --in
			--OD => OD,--in
			OD => LG,--in
			--EN_Signal_D2 => EN_DNP2,
			EN_Signal_D => EN_DNP1--out
		);
	
------------------------------------------------------------ 2 Target-----------------
--	d <= std_logic_vector( to_unsigned( dc2, dc1'length));
  delay2 <= conv_std_logic_vector(  dpp2, inn_distance_range);
  
	--Distance_PP2: entity work.Distance_pp
	Distance_PP2: entity work.Distance_ap
	--Distance_PP2: entity work.mux_phasa

		generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht,
					pft_code => pft_code,
					data_pft => data_pft
					
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					PI => PIPP2_is,--in
					--dpp1 => dpp2,
					D_delay => delay2,
					D => dc2,--in
					PFT => PFT, --in
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => EN_DNP2--out
					);
--					
--------------ampl2-----------------------------------------------
					
UPP_r2 <= '0' & UPP2;
						
	Amplitude_signal_PP2: entity work.Amplitude_signal_ap

		generic map( 
			int => int,
			data_level => data_level + 1,
			ap => false,
			fract => fract
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			U => UPP_r2,--in
			U_r => UPP2_r 	--out		
		);

--	------------------------------mult2-------------------------------

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
					K_mult => UPP2_r,
					D_mult => PP_sin, --in
					--D_mult => PP_ram, --in
					Q_mult => UPP2_cos,	--out
					Q_mult_sfixed => UPP2_cos_sfixed
					 );
	
	--------------------------------Out-------------
		process (clk_96) is
	begin
		if rising_edge(clk_96) then
		--	pp <=  UPP_cos ;
		  pp <= PP_sin;
			upp_cos_sfix <=  UPP_cos_sfixed;-- to_sfixed(PP_cos, int - 1, fract);
			upp2_cos_sfix <=  UPP2_cos_sfixed;
		end if;
	end process;

end Behavioral;
 