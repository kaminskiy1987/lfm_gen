-- Company: 
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
--library ieee;
--	use ieee.numeric_std.all;
--	use ieee.std_logic_1164.all;
--	use ieee.math_real.all;
	
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use ieee.numeric_std.all;
	--Use ieee.std_logic_arith.all;
	--Use ieee.std_logic_unsigned.all;
	USE ieee.math_real.all;
	--USE std.textio.ALL;
	--USE IEEE.std_logic_textio.ALL; 

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


entity channel_AP1 is
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
      Delay_C2 : integer := 29
	);
	
	Port(
		Clk_96 : in std_logic;

		Ce_F6 : in std_logic;
		
		UAP : in std_logic_vector (data_level - 1 downto 0);
		
		UAP2 : in std_logic_vector (data_level - 1 downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		Sign_LCHM : in std_logic;
		
		DC1 : in std_logic_vector (data_distance downto 1);
		
		DC2 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		rnd_6_un : in std_logic_vector(data_rom-1 downto 0):=(others => '0');
		
		rnd_6_un2 : in std_logic_vector(data_rom-1 downto 0):=(others => '0');
		
		PIAP_is: in std_logic;
		
		piap_imp_is : in std_logic;
		
		PIAP2_is: in std_logic;
		
		piap2_imp_is : in std_logic;
		
		dpp1 : in integer;
		dpp2 : in integer;
		
		k2 : in sfixed(int - 1 downto fract);
    k_ap : in sfixed(int - 1 downto fract);

		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		
		str_sharu : out std_logic;
		UAP_X_sfix : out sfixed(int - 1 downto fract);
		UAP2_X_sfix : out sfixed(int - 1 downto fract);
		uap_p1 : out sfixed(int - 1 downto fract);
		uap_p2 : out sfixed(int - 1 downto fract);
		UAP_out : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end channel_AP1;

architecture Behavioral of channel_AP1 is

	Signal UAP_r, UAP2_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal RND_X_EN, RND_X_EN2, RND_mult, RND_mult2, rnd_6_un_str_100, rnd_6_un_str_200 : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	--Signal RND_6_un : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	Signal RND_X : std_logic_vector(9 downto 0):=(others => '0');
	Signal UAP_X, UAP2_X, rnd_100, rnd_200, UAP_p1_slv, UAP_p2_slv, UAP_p1_slv_pi, UAP_p2_slv_pi_2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal EN_AP , EN_IMP ,  EN_DNP_AP, EN_DNP_AP2, str_d, str_s, EN_DNP2: std_logic := '0';
	Signal EN_AP2 : std_logic := '0';
	Signal EN_IMP2 : std_logic := '0';
	constant inn_distance_range : integer := data_distance + 5;  
	--constant DC2 	: std_logic_vector(13 downto 0)	:= "00001111101000";
	--constant UC2 : std_logic_vector(5 downto 0)	:= "010100";
	signal uap_ampl, uap_ampl2  : std_logic_vector (data_level downto 0):=(others => '0');
	--signal rnd_r : std_logic_vector(rnd_6_x'range) := (others => '0');
	Signal UAP_cos_sfixed, UAP2_cos_sfixed, RND_mult_sfixed, RND_mult_sfixed2, UAP_p1_sfix, UAP_p2_sfix : sfixed(int - 1 downto fract) := (others => '0');
	signal str_sh_A  : std_logic := '0';
	signal str_lg_od  : std_logic := '0';
	--signal EN_DNP_AP1 : std_logic := '1';
	signal EN_DNP_AP_dist : std_logic := '1';
	--signal EN_DNP_AP2 : std_logic := '1';
	--constant ap_delay : integer := 100;
	constant ap_delay : integer := 330;
	constant ap2_delay : integer := 130;
	constant ampl : integer := 8191;
	
	signal delay1, delay2 : std_logic_vector (inn_distance_range - 1  downto 0):= (others => '0');
	
	signal N_rec : integer := 0;

--function recalculationDpp( a : std_logic_vector) return integer is
--		--variable res : std_logic_vector(size - 1 downto 0) ;
--	begin	 
--		--return to_integer(to_unsigned(a)) * 10;
--		return conv_integer(a) * 960;
--	--	return conv_std_logic_vector(conv_integer(a) * 16 - 1000 , size);
----		return res;
--    --   return a;		
--	end recalculationDpp;
	
	--attribute keep : string;
	--attribute keep of UAP_r : signal is "true";
	--attribute keep of  EN_DNP_AP  : signal is "true";
	--attribute keep of  EN_DNP_AP1 : signal is "true";
	--attribute keep of  str_sh_A  : signal is "true";
	--attribute keep of  str_lg_od : signal is "true";
	--attribute keep of  RND_X_EN : signal is "true";
	--attribute keep of UAP_cos_sfixed  : signal is "true";

begin

--N_rec  <= recalculationDpp(dpp1);
	---------------------------------------------------
	---------------------------------------------------
	 process (PIAP_is, piap_imp_is)
		begin
			if  piap_imp_is = '1' and PIAP_is = '0' then
				EN_AP <= '0';
				EN_IMP <= '1';
			elsif piap_imp_is = '0' and PIAP_is = '1' then
				EN_AP <= '1';
				EN_IMP <= '0';
			elsif piap_imp_is = '0' and PIAP_is = '0' then
				EN_AP <= '0';
				EN_IMP <= '0';
			elsif piap_imp_is = '1' and PIAP_is = '1' then
				EN_AP <= '0';
				EN_IMP <= '1';
			end if;
		end process;
		
		 process (PIAP2_is, piap2_imp_is)
		begin
			if  piap2_imp_is = '1' and PIAP2_is = '0' then
				EN_AP2 <= '0';
				EN_IMP2 <= '1';
			elsif piap2_imp_is = '0' and PIAP2_is = '1' then
				EN_AP2 <= '1';
				EN_IMP2 <= '0';
			elsif piap2_imp_is = '0' and PIAP2_is = '0' then
				EN_AP2 <= '0';
				EN_IMP2 <= '0';
			elsif piap2_imp_is = '1' and PIAP2_is = '1' then
				EN_AP2 <= '0';
				EN_IMP2 <= '1';
			end if;
		end process;
--	-------------------------Ampl---------   ( -> )
uap_ampl <= '0' & UAP;

	Amplitude_signal_AP: entity work.Amplitude_signal_ap

		generic map( 
					int => int,
					data_level => data_level + 1,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					U => uap_ampl,--in
					U_r => UAP_r 	--out		
					);
	-------------------------------str_sh---------------------
	
	p_str_sh_A: process (clk_96, ti) is
			variable count_gen: integer := 0;
		begin
			if (ti = '1') then
				count_gen := 0;
			elsif(rising_edge(Clk_96)) then
	--			if (24 <= count_gen and count_gen <= 324) then
	--			if (0 <= count_gen and count_gen <= 5184) then--324) then
	--			if (0 <= count_gen and count_gen <= 7877) then--324) then
				if (0 <= count_gen and count_gen <= 9894) then--324) then
					str_sh_A <= '1';
				else
					str_sh_A <= '0';
				end if;
				count_gen := count_gen + 1;	
			end if;		
		end process	p_str_sh_A;	
------------------------------------str_lg_od----------------------------		
		p_lg_od: process (lg, od) is
		begin
			if (falling_edge(lg)) then
				str_lg_od <= '1';	
			end if;	
			if (od = '1') then
				str_lg_od <= '0';
			end if;			
		end process	p_lg_od;	
		
--		EN_DNP_AP1 <= not(ti or str_sh_A or str_lg_od);
		str_sharu <= str_sh_A;
		EN_DNP_AP_dist <= not(str_sh_A);
		--strob_not_noise <= not(str_lg_od);
	--	rnd_6_un_str <= rnd_6_un when not(str_lg_od) = '1' else (others => '0');
	-----------------------------------
	--EN_DNP_AP1 <= str_s or str_d when rising_edge(clk_96) ;
	----------------------------distance/length-------
	--delay1 <= conv_std_logic_vector(dpp1, inn_distance_range);
	delay1 <= std_logic_vector(to_signed(dpp1, inn_distance_range));
	Distance_AP: entity work.Distance_ap

			generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht,
					pft_code => pft_code,
					data_pft => data_pft
					
					)
			port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					--PI1 => EN_AP,--in
					--PI2 => EN_IMP,
					PI => EN_IMP,
					--P2 => P2,
					D => DC1,--in
					--D_delay => dpp1,
					D_delay => delay1,
					PFT => PFT, --in
					--KD => KD,
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => EN_DNP_AP--out
				);
	--------------------------------delay_noise--------------------------			
--fifo_rnd1 : entity elementary.fifo
--	  generic map(
--	     data_width => 16,
--		  fifo_deep => 4095, 
--		  init => 0
--	  )
--	  port map(
--	     reset => '0', 
--		  input => rnd_6_un,
--		  clk => clk_96, 
--		  output => rnd_100
--	  );
	  
	 rnd_6_un_str_100 <= rnd_6_un when not(str_lg_od) = '1' else (others => '0'); 
	--------------------------------------AP/IMP-----------------	
	process (Clk_96, Ce_F6, EN_IMP, EN_AP, EN_DNP_AP, EN_DNP_AP_dist, rnd_6_un_str_100 )
		begin
		 if rising_edge(clk_96) then
			if EN_IMP = '1' then 
				if EN_DNP_AP = '1' then
					RND_X_EN <=  rnd_6_un_str_100;
				else
					RND_X_EN <=(others => '0');
				end if;
			elsif EN_AP  = '1' then
			   if EN_DNP_AP_dist  = '1' then 
					RND_X_EN <=  rnd_6_un_str_100;
				else
					RND_X_EN <=(others => '0');
				end if;
			else
				RND_X_EN <=(others => '0');
			end if;
      end if;			
		end process;
		
		-------------------------------bandpass--------
			MULT_URND_k: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k2 ,
					--D_mult => RND_6_X (9 downto 0),
					D_mult =>  RND_X_EN  ,			--in
					Q_mult => RND_mult,					--out
					Q_mult_sfixed => RND_mult_sfixed 
					 );		
	
-------------------------------mult---------------------------		
	MULT_URND: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => UAP_r ,
					--D_mult => RND_6_X (9 downto 0),
					D_mult =>  RND_mult  ,			--in
					Q_mult => UAP_X,					--out
					Q_mult_sfixed => UAP_cos_sfixed 
					 );		
--------------------------------------------------2 target-----------------------
uap_ampl2 <= '0' & UAP2;
--	-------------------------Ampl--------- 
	Amplitude_signal_AP2: entity work.Amplitude_signal_ap

		generic map( 
					int => int,
					data_level => data_level + 1,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					U => uap_ampl2,--in
					U_r => UAP2_r 	--out		
					);
----------------------------distance/length-------
--delay2 <= conv_std_logic_vector( dpp2, inn_distance_range);
delay2 <= std_logic_vector(to_signed(dpp2, inn_distance_range));
	Distance_AP2: entity work.Distance_ap

			generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht,
					pft_code => pft_code,
					data_pft => data_pft
					
					)
			port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					--PI1 => EN_AP2,--in
					--PI2 => EN_IMP2,
					PI => EN_IMP2,
					--P2 => P2,
					D => DC2,--in
					--D_delay => dpp1,
					D_delay => delay2,
					PFT => PFT, --in
		      --KD => KD,
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => EN_DNP_AP2--out
				);
	--------------------------------delay_noise2--------------------------			
--fifo_rnd2 : entity elementary.fifo
--	  generic map(
--	     data_width => 16,
--		  fifo_deep => 6144, 
--		  init => 0
--	  )
--	  port map(
--	     reset => '0', 
--		  input => rnd_6_un,
--		  clk => clk_96, 
--		  output => rnd_200
--	  );
	  
	   rnd_6_un_str_200 <= rnd_6_un2 when not(str_lg_od) = '1' else (others => '0'); 
	--------------------------------------AP/IMP-----------------				
		process (Clk_96, Ce_F6, EN_DNP_AP_dist, EN_DNP_AP2, rnd_6_un_str_200)
		begin
		 if rising_edge(clk_96) then
			if EN_IMP2 = '1' then 
				if EN_DNP_AP2 = '1' then
					RND_X_EN2 <=  rnd_6_un_str_200;
				else
					RND_X_EN2 <=(others => '0');
				end if;
			elsif EN_AP2  = '1' then
			   if EN_DNP_AP_dist  = '1' then 
					RND_X_EN2 <=  rnd_6_un_str_200;
				else
					RND_X_EN2 <=(others => '0');
				end if;
			else
				RND_X_EN2 <=(others => '0');
			end if;
      end if;			
		end process;
			
     MULT_URND_k2: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k2 ,
					--D_mult => RND_6_X (9 downto 0),
					D_mult =>  RND_X_EN2  ,			--in
					Q_mult => RND_mult2,					--out
					Q_mult_sfixed => RND_mult_sfixed2 
					 );					
	-------------------------------bandpass--------			
			MULT_URND2: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => UAP2_r ,
					--D_mult => RND_6_X (9 downto 0),
					D_mult =>  RND_mult2  ,			--in
					Q_mult => UAP2_X,					--out
					Q_mult_sfixed => UAP2_cos_sfixed 
					 );				
-------------------------------------akp_p1/ pi---------------------------------------------
MULT_URND_akp_p1: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => k_ap ,
					--D_mult => RND_6_X (9 downto 0),
					D_mult =>  RND_mult  ,			--in
					Q_mult => UAP_p1_slv,					--out
					Q_mult_sfixed => UAP_p1_sfix 
					 );
					 
			UAP_p1_slv_pi <= std_logic_vector(unsigned(not UAP_p1_slv) + 1) when rising_edge(Clk_96);
			--UAP_p1_slv_pi <= conv_std_logic_vector(conv_integer(unsigned(not UAP_p1_slv) + 1), 14) when rising_edge(Clk_96);		 
--------------------------------------akp_p2/ pi_2--------------------------------------------					 
--MULT_URND_akp_p2: entity elementary.sfixed_mult
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
--					K_mult => k_ap ,
--					--D_mult => RND_6_X (9 downto 0),
--					D_mult =>  RND_mult2  ,			--in
--					Q_mult => UAP_p2_slv,					--out
--					Q_mult_sfixed => UAP_p2_sfix 
--					);
					
				UAP_p2_slv_pi_2 <= UAP_p1_slv when rising_edge(Clk_96);
---------------------------------------out--------------------------------------------					 
	process (clk_96) is
	begin
		if rising_edge(clk_96) then
			uap_out <= uap_x ;
			uap_x_sfix <=  UAP_cos_sfixed ;-- to_sfixed(uap_x, int - 1, fract);
			uap2_x_sfix <=  UAP2_cos_sfixed ;
			
			--uap_p1 <=  UAP_p1_sfix ;-- to_sfixed(uap_x, int - 1, fract);
			--uap_p2 <=  UAP_p2_sfix ;
			
			uap_p1 <=  to_sfixed(signed(UAP_p1_slv_pi), int - 1, fract);
			--uap_p2 <=  UAP_p1_sfix;
			uap_p2 <=  to_sfixed(signed(UAP_p2_slv_pi_2), int - 1, fract);
		end if;
	end process;

end Behavioral;

