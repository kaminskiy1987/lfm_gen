library ieee;
	use ieee.numeric_std.all;
	use ieee.std_logic_1164.all;
	use ieee.math_real.all; 

library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;


library ieee_proposed;
	use ieee_proposed.fixed_pkg.all;
--use elementary.s274types_pkg.all;

--use work.local_types_pkg.all;
  


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--Use ieee.std_logic_unsigned.all;




entity TOP_signal is
	generic(

		--int : integer := 11;
		--int : integer := 14;
		--fract : integer := -15;
		int : integer := 16;
		fract : integer := -26;
		data_width: integer := 14;
		data_width16: integer := 16;
		--data_level: integer := 6;
		data_level: integer := 7;
		data_pft: integer := 5;
		data_rom: integer := 14;
		data_rom16: integer := 16;
		data_distance : integer := 14;
		data_ppz : integer := 5;
		pft_widht : integer:= 4;
		--pft_code : int_array := (0, 4, 6, 10, 12, 14, 21, 23, 25, 27);
		--length_array: int_array :=  (4195, 1959, 2439, 3359, 5607, 7719, 1633, 2113, 2563, 3043 ); 
      Delay_C2 : integer := 29
	);

	Port(
		Clk_96 : in std_logic;
		
      Clk_192 : in std_logic;
		
		Ce_F6 : in std_logic;
		tt : in std_logic_vector (3 downto 0);
		rst :  in std_logic;
		--* 6-�� ������- ���� ��������� �/�: 1 - �/� < 1, 0 - �/� > 1
		---������� ������� �������� � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		UMP : in std_logic_vector (data_level downto 0);
		UMP2 : in std_logic_vector (data_level downto 0);
		---������� ������� ���� � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		UC1 : in std_logic_vector (data_level downto 0);
		---������� ������� ���� � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		UC2 : in std_logic_vector (data_level downto 0);
		---������� ������� �������� ������ � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		UAP : in std_logic_vector (data_level -1 downto 0);
		UAP2 : in std_logic_vector (data_level -1 downto 0);
		UAP_p1 : in std_logic_vector (data_level -1 downto 0);
		UAP_p2 : in std_logic_vector (data_level -1 downto 0);
		---������� ������� ��������� ������ � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		UPP : in std_logic_vector (data_level - 1 downto 0);
		UPP2 : in std_logic_vector (data_level - 1 downto 0);

		-- ����� ���� ��� �������
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		--str_sharu : in std_logic;
		
		--SH_FLAG : in std_logic_vector(data_width - 1 downto 0);
		
		--lfm_g : in std_logic_vector(data_width - 1 downto 0);
		
		--PCC  : in std_logic;
		--pt: in std_logic;
		---P1 : in std_logic;
		--P2 : in std_logic_vector (1 downto 0);

		-- C1-001 (0-pi-0), C2-010 (0-pi-0), C3-100 (0-0-pi) 
		ppz : in std_logic_vector ( 4 downto 0);
		ppz_new : in std_logic_vector ( 6 downto 0);
		-- ���� ������� ��� ������� (0- ������� �� /, 1- ����. �� \)
		Sign_LCHM : in std_logic;

		---��������� �������� �������� � ������ ��
		VKL_IS1  : in std_logic;
		---��������� �������� �������� � ������ ���
		VKL_IS2  : in std_logic;
		
		VKL_IS_p1  : in std_logic;
		---��������� �������� ��������� ��������� 
		
		VKL_IS_p2  : in std_logic;
		--������� �������� ���� "1" - ���.03, "0" - ��������)
		PIMSH : in std_logic;
		--������� �������� ���� "1" - ���� �, "0" - ��� �)
		P_vikl_SH : in std_logic;
		-- ������������� ���
		ZMRSH : in std_logic;

     -- pr_channel : in std_logic;
		-- ������� �������� �������� �������� �� ��������� �1 ("1" - ���� ��, "0" - ��� ��)
		PIMP : in std_logic;
		--������� �������� ������� (������) �� �� ��������� DC+Delay_C2 ("1" - ���� �, "0" - ��� �)
		PIMP2 : in std_logic;
		-- ��������� 1 �.�.�.= 50 �
		DC2 : in std_logic_vector (data_distance downto 1);
		--DMP1 : in std_logic_vector (14 downto 1);

		-- ������� �������� ���� �� ��������� ��1 ("1" - ���� �, "0" - ��� �)
		PIC1 : in std_logic;
		--������� �������� ������  ���� �� ��������� DC+Delay_C2 ("1" - ���� �, "0" - ��� �)
		PIC2 : in std_logic;
		PIC2_PC : in std_logic;
		-- ��������� 1 �.�.�.= 50 �
		DC1 : in std_logic_vector (data_distance downto 1);
		--DC1 : in std_logic_vector (14 downto 1);

		-- ������� �������� ��������� ������ �� ��������� DPP ("1" - ���� , "0" - ��� )
		PIPP : in std_logic;
		--������� �������� ������ ��������� ������ �� ��������� DPP+Delay_PP2 ("1" - ���� ��2, "0" - ��� ��2)
		PIPP2 : in std_logic;
		-- ��������� 1 �.�.�.= 50 �
		DNP1 : in std_logic_vector (data_distance downto 1);
		-- ��������� 1 �.�.�.= 50 �
		DNP2 : in std_logic_vector (data_distance downto 1);

      DNP_p1 : in std_logic_vector (data_distance downto 1);
		-- ��������� 1 �.�.�.= 50 �
		DNP_p2 : in std_logic_vector (data_distance downto 1);
		-- ������� �������� �� ("1" - ���� ��, "0" - ��� ��)
		PIAP : in std_logic;
		--������� �������� ������ �������� ������ �� ��������� �P+Delay ("1" - ���� ��2, "0" - ��� ��2)
		PIAP2 : in std_logic;
		PIAP_p1 : in std_logic;
		--������� �������� ������ �������� ������ �� ��������� �P+Delay ("1" - ���� ��2, "0" - ��� ��2)
		PIAP_p2 : in std_logic;
		piap_imp : in std_logic;
		piap2_imp : in std_logic;
		piap_p1_imp  : in std_logic;
		piap_p2_imp  : in std_logic;
--		str_sharu : in std_logic := '0';
		-- ������ ���������
		OD : in std_logic;
		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		--���� ������� ��� ����
		fdop1 : in std_logic_vector (7 downto 0) := (others => '0');
		fdop2 : in std_logic_vector (7 downto 0) := (others => '0');
		fdev : in std_logic_vector (2 downto 0) := (others => '0');
		fdop_pp1  : in std_logic_vector (3 downto 0) := (others => '0');
		fdop_pp2  : in std_logic_vector (3 downto 0) := (others => '0');
		--���� ������� ��
		Fdpp1 : in std_logic_vector (8 downto 0) := (others => '0');
		Fdpp2 : in std_logic_vector (8 downto 0) := (others => '0');
		
		Fdpp_p1 : in std_logic_vector (8 downto 0) := (others => '0');
		Fdpp_p2 : in std_logic_vector (8 downto 0) := (others => '0');
		--�������� ������� � ������ �����
		NS1 : in std_logic;
		strob_sharu1 : in std_logic;
		strob_sharu2 : in std_logic;
		up  : in std_logic := '0';
		ap_o_1 	: in std_logic := '0';
		ap_o_2 : in std_logic := '0';
		ap_o_3 : in std_logic := '0';
		ap_pl_1 : in std_logic := '0';
		ap_pl_2 : in std_logic := '0';

		noise_plus3 : in std_logic := '0';
		noise_minus3 : in std_logic := '0';
		---- -----------------------------------
		--ppz_out : out  std_logic_vector ( 4 downto 0);
		--EN_C  : out std_logic ;
	   awgn_out : out std_logic_vector (data_rom16-1 downto 0);
		U_4 : out std_logic_vector (data_rom16 - 1 downto 0);
		U_3 : out std_logic_vector (data_rom16 - 1 downto 0);
		U_2 : out std_logic_vector (data_rom16 - 1 downto 0);
		U_X : out std_logic_vector (data_rom16 -1 downto 0)
		--U_Y : out std_logic_vector (11 downto 0)
	);

end TOP_signal;

architecture Behavioral of TOP_signal is

--Signal Ce_F6 :  std_logic := '0';

	----------   
	--Signal UMP_r, UC1_r, UAP_r, UPP_r : std_logic_vector (17 downto 0):=(others => '0');
	Signal UMP_r, UC1_r,UC2_r, UAP_r, UPP_r : sfixed(int - 1 downto fract):=(others => '0');
	----------     VKL_IS
	Signal PIMSH_ti, PIMP_ti, PIC1_ti, PIPP_ti, PIAP_ti, PIPP2_ti, PIAP2_ti, PIC2_ti, PIC2_PC_ti, PIMP2_ti, P_vikl_SH_ti : std_logic := '0'; 
	Signal piap_imp_ti, piap2_imp_ti, PCC_ti, Sign_LCHM_ti, VKL_IS1_ti, VKL_IS2_ti, VKL_IS_p1_ti, VKL_IS_p2_ti : std_logic := '0';
	Signal PIAP_p1_ti, PIAP_p2_ti, piap_p1_imp_ti, piap_p2_imp_ti, ap_o_1_ti, ap_o_2_ti, ap_o_3_ti, ap_pl_1_ti, ap_pl_2_ti : std_logic := '0';
	Signal noise_plus3_ti, noise_minus3_ti, up_ti : std_logic := '0';
	Signal UC1_ti, UC2_ti, UMP_ti, UMP2_ti :  std_logic_vector (data_level downto 0):= (others => '0');
	Signal UAP_ti, UPP_ti, UAP2_ti, UPP2_ti, UAP_p1_ti, UAP_p2_ti :  std_logic_vector (data_level - 1 downto 0):= (others => '0');
	Signal PFT_ti : std_logic_vector (data_pft-1 downto 0):= (others => '0');
	signal ppz_ti : std_logic_vector (4 downto 0):= (others => '0');
	signal DC1_ti, DC2_ti, DNP1_ti, DNP2_ti, DNP_p1_ti, DNP_p2_ti : std_logic_vector (data_distance downto 1):= (others => '0');
	signal fdop_ti, fdop2_ti :  std_logic_vector (7 downto 0):= (others => '0');
	signal fdop_pp1_ti, fdop_pp2_ti :  std_logic_vector (3 downto 0):= (others => '0');
	signal fdev_ti :  std_logic_vector (2 downto 0):= (others => '0');
	---------------------
	Signal MP_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UMP2_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UMP_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UMP_cos_sfix, pilot_signal :  sfixed(int - 1 downto fract):=(others => '0');
	
	Signal MP_cos16 : std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal UMP2_cos16 : std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal UMP_cos16 : std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	---------------------
	Signal C1_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal C2_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	--Signal UC1_cos :  std_logic_vector (17 downto 0):=(others => '0');
	Signal UC1_cos, UC1_cos1 :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_cos_sfix, UC1_cos_sfix1, UC2_cos_sfix  :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UC1_cos_sfix_16, UC2_cos_sfix_16  :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UC2_cos_16, UC1_cos_16, U_X_pl, U_X_p1, U_X_p2, U_X_summ1, U_X_summ2 :  std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal UC2_cos, UC2_cos1 :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal lfm_g_16 :  std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	---------------------   
	--Signal RND_6_X : std_logic_vector(9 downto 0):=(others => '0');
	Signal RND_6_X : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	Signal RND_6_un : std_logic_vector(data_rom-1 downto 0):=(others => '0');
	
	Signal RND_6_X_16, RND_sharu_A_16_cos, RND_6_X_16_cos, RND_6_X_16_sin, RND_sharu_A_16_sin, RND_str_sh1  : std_logic_vector(data_rom16-1 downto 0):=(others => '0');
	Signal RND_sharu_A_16_cos2, RND_6_X_16_cos2, RND_6_X_16_sin2, RND_sharu_A_16_sin2, RND_noise_sin2, RND_noise_cos2  : std_logic_vector(data_rom16-1 downto 0):=(others => '0');
	Signal RND_6_un_16, RND_6_un_16_cos, RND_6_un_16_sin, RND_str_sh1_rg  : std_logic_vector(data_rom16-1 downto 0):=(others => '0');
	Signal RND_noise_cos, RND_noise_sin,  RND_X_16_cos, RND_X_16_sin, RND_X_16_cos2, RND_X_16_sin2 : std_logic_vector(data_rom16-1 downto 0):=(others => '0');
	Signal rnd_6_un_16_cos2, rnd_6_un_16_sin2, RND_sh1 : std_logic_vector(data_rom16-1 downto 0):=(others => '0');
	--Signal RND_9_X : std_logic_vector(9 downto 0):=(others => '0');
	--Signal RND_6_Y : std_logic_vector(9 downto 0):=(others => '0');
	-- PIMSH ("1" -  , "0" -  )
	Signal RND_X : std_logic_vector(data_width - 1 downto 0):=(others => '0');
	Signal RND_sharu_F, RND_sharu_A : std_logic_vector(data_width - 1 downto 0):=(others => '0');
	Signal SH_FLAG_16 : std_logic_vector(data_width16 - 1 downto 0):=(others => '0');
	------
	Signal UAP_X : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP_X1 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP_X2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP_X3 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP2_X : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP_Imp : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UAP_X_sfix, U_X_1_summ1, U_X_2_summ1, U_X_3_summ1 :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UAP_X_sfix1, U_X_1_summ2, U_X_2_summ2 :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UAP_X_sfix2, UAP_o_sf, UAP_pl_sf, UAP_p1_sf, UAP_p2_sf, signal_up_sfix :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UAP_X_sfix3 :  sfixed(int - 1 downto fract):=(others => '0');
	constant uap_amp1 : std_logic_vector (5 downto 0) := "000001";
	constant uap_amp2 : std_logic_vector (5 downto 0) := "000100";
	constant uap_amp3 : std_logic_vector (5 downto 0) := "010001";
	Signal UAP_X_sfix_16, UAP_X_sfix2_16, UAP_X_sfix3_16, UAP_X_sfix_p1_16, UAP_X_sfix_p2_16 :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UAP_X_16, UAP_X3_16, UAP_X1_16, UAP_X2_16, UAP_X_p12 : std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	--------------------- 
	Signal PP_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UPP_cos, UPP_cos1 :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UPP2_cos, UPP2_cos1 :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UPP_cos_sfix, UPP_cos_sfix1 :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UPP22_cos_sfix, UPP2_cos_sfix :  sfixed(int - 1 downto fract):=(others => '0');
	Signal UPP_cos_16 :  std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal UPP_cos_sfix_16, UPP22_cos_sfix_16 :  sfixed(int - 1 downto fract):=(others => '0');
	---------------------
   Signal UC2_mod  :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal uc1_modg :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal uc1_modg_sfix, mp1_modg_sfix, uc2_modg_sfix :  sfixed(int - 1 downto fract):=(others => '0');
	
	 Signal UC2_mod_16, signal_up  :  std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal uc1_modg_16 :  std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	Signal uc1_modg_sfix_16, mp1_modg_sfix_16, uc2_modg_sfix_16 :  sfixed(int - 1 downto fract):=(others => '0');
	--Signal U_X_16 : std_logic_vector (17 downto 0):=(others => '0');
	--Signal U_X_16 : std_logic_vector (13 downto 0):=(others => '0');

	--    (1  ,  =   )
	--Signal EN_MP1, EN_MP2: std_logic_vector (data_distance downto 1):=(others => '0') ;
	Signal EN_C1, EN_C2: std_logic_vector (data_distance downto 1):=(others => '0') ;
--	Signal EN_PP_DPP : std_logic := '0';
	Signal EN_DC1, EN_DC2 : std_logic := '0';
	Signal EN_MP1, EN_MP2 : std_logic := '0';
	Signal EN_DNP1 , EN_DNP_AP : std_logic := '0';
	Signal EN_DNP2 : std_logic := '0';
	
	Signal MP1 , MP2 : std_logic := '0';
	Signal C1 , C2 : std_logic := '0';
	
	constant dpp1 : std_logic_vector (7 downto 0) := "00000001";
	constant dpp2 : std_logic_vector (7 downto 0) := "00000010";
	
	Signal Fdpp1_ti, Fdpp2_ti, Fdpp_p1_ti, Fdpp_p2_ti : std_logic_vector (8 downto 0):=(others => '0');
	
	signal rnd_r : std_logic_vector(rnd_6_x'range) := (others => '0');
	signal u_x_r : std_logic_vector(u_x'range) := (others => '0');
	signal u_x_r_16, U_X1, U_X2, U_X3, U_X4 : std_logic_vector(15 downto 0) := (others => '0');
	signal u_x_g_16 : std_logic_vector(15 downto 0) := (others => '0');
	signal u_x_g_02_16 : std_logic_vector(15 downto 0) := (others => '0');
	signal u_x_g : std_logic_vector(u_x'range) := (others => '0');
	signal u_x_r_02 : std_logic_vector(u_x'range) := (others => '0');
	signal u_x_g_02 : std_logic_vector(u_x'range) := (others => '0');
	Signal strob_sh : std_logic := '0';
	Signal en_gen : std_logic := '0';
	signal ppz_new_ti : std_logic_vector ( 6 downto 0) := (others => '0');
	signal ppz_m : std_logic_vector ( 4 downto 0);
	constant magic : integer := 0;
	signal str_sharu1, str_sharu2, str_sharu_n, strob_not_noise : std_logic := '0';
	signal str_sharu3 : std_logic := '0';
	
	signal pic_en, pic_g_en, pic2_en, pt_ti : std_logic := '0';
--	constant inn_distance_range : integer := 18;
-----------------------------------------------------------------
	signal noiseAmpl1 : std_logic_vector (data_level-1 downto 0):=(others => '0');
	signal noiseAmpl2 : std_logic_vector (data_level-1 downto 0):=(others => '0');
	signal noiseAmpl3 : std_logic_vector (data_level-1 downto 0):=(others => '0');
----------------------------------------------	
	signal generatorInclusion1 : std_logic := '0';
	signal generatorInclusion2 : std_logic := '0';
	signal generatorInclusion3 : std_logic := '0';
	
	signal noiseOutput1 : std_logic_vector (data_rom16-1 downto 0):=(others => '0');
	
	signal pc1_c, pc2_c, pap1_c, pap2_c, ppp1_c, ppp2_c, pmp1_c, pmp2_c, vkl_ap1_imp_c, vkl_ap2_imp_c: std_logic := '0';
	signal dct1_c, dct2_c : std_logic_vector(14 downto 0):= (others => '0');
	signal dnp1_c, dnp2_c : std_logic_vector(14 downto 0):= (others => '0');
	signal uc1_c, uc2_c: std_logic_vector(6 downto 0):= (others => '0');
	signal up1_c, up2_c : std_logic_vector(5 downto 0):= (others => '0');
	signal fdpp1_c, fdpp2_c : std_logic_vector(8 downto 0):= (others => '0');
	---    lk_6 (Ce_F6)
	--signal tt : std_logic_vector (3 downto 0):= (others => '0');
	signal enable_imit, en_noise : std_logic := '0';
	
  -- constant a : real := 64.5;
	constant sigma_5_2 : real := 0.2598;
	constant sigma_7 : real := 0.4880;--0.3437
	constant sigma_11 : real := 0.7668;--0.6874
	constant sigma_14 : real := 0.9761;--0.6874
	constant sigma_63 : real := 4.4;--0.6874
	constant sigma_plus3 : real := 0.3663;
	constant sigma_minus3 : real := 0.1842;
	--constant a : real := 0.6988;
	--constant a : real := 0.99;
	
	constant b : real := 1.01;
	
	constant c : real := 10.0;	
	--signal NT : std_logic_vector (2 downto 1):= (others => '0');
	--
	--signal NT_PPZ : std_logic_vector (data_ppz downto 1):= (others => '0');
--	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);
	Signal dp: std_logic_vector (7 downto 0):="01000000";
	Signal dp_t : sfixed(int - 1 downto fract) := (others => '0');
	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);	
--	
	
	function recalculation1( a: real ) return sfixed is
		variable res : sfixed(int - 1 downto fract);
		variable gamma : integer := 100;
	begin	 
		return  to_sfixed((real(a)) , int - 1, fract);
--		return res;
    --   return a;		
	end function;

	function "+" (l : STD_LOGIC_VECTOR; r : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is   
		variable add1 : STD_LOGIC_VECTOR (l'range);
	begin   
		add1 := STD_LOGIC_VECTOR (to_signed(to_integer(signed(l)) + to_integer(signed(r)), l'length));
    
    return add1;
  end function "+";

 signal sigma_custom, bandpsss_custom, noise_ampl, k_str_sh1 : sfixed(int - 1 downto fract) :=(others => '0');
	
signal N_rec, N_p1, N_p2 : integer := 0;
signal N2_rec : integer := 0;

 function recalculationDpp( a : std_logic_vector) return integer is
		--variable res : std_logic_vector(size - 1 downto 0) ;
	begin	 
		--return to_integer(to_unsigned(a)) * 10;
		return to_integer(unsigned(a)) * 960;
	--	return conv_std_logic_vector(conv_integer(a) * 16 - 1000 , size);
--		return res;
    --   return a;		
	end recalculationDpp;
	
	function recalculationDpp2( a : std_logic_vector) return integer is
		--variable res : std_logic_vector(size - 1 downto 0) ;
	begin	 
		--return to_integer(to_unsigned(a)) * 10;
		return to_integer(unsigned(a)) * 960 + 1000;
	--	return conv_std_logic_vector(conv_integer(a) * 16 - 1000 , size);
--		return res;
    --   return a;		
	end recalculationDpp2;
	
	attribute keep : string;
	attribute keep of PIC1 : signal is "true";
	attribute keep of PIC1_ti : signal is "true";
	attribute keep of Clk_96 : signal is "true";
	attribute keep of  UC1_ti : signal is "true";
	attribute keep of  UC1 : signal is "true";
	attribute keep of U_X_summ1 : signal is "true";
	attribute keep of UC1_cos_sfix_16 : signal is "true";
	--attribute keep of uc1_modg_sfix : signal is "true";
	--attribute keep of UPP_cos_sfix : signal is "true";
	--attribute keep of u_x_g : signal is "true";
--	attribute keep of str_sharu : signal is "true";

BEGIN
	------------------------------------------------------------Input_RG--------------------------------------------------------------
		
		RG_Process: process (ti)
		begin
			if rising_edge(ti) then
			   UC1_ti <= UC1;
				UMP_ti <= UMP;
				UMP2_ti <= UMP2;
				UC2_ti <= UC2;
				UAP_ti <= UAP;
				UPP_ti <= UPP;
				UAP2_ti <= UAP2;
				UPP2_ti <= UPP2;
				UAP_p1_ti <= UAP_p1;
				UAP_p2_ti <= UAP_p2;
				
				PFT_ti <= PFT;
				ppz_ti <= ppz;
				ppz_new_ti <= ppz_new;
				up_ti <= up;
				Sign_LCHM_ti <= Sign_LCHM;
				
				VKL_IS1_ti <= VKL_IS1;
				VKL_IS2_ti <= VKL_IS2;
				VKL_IS_p1_ti <= VKL_IS_p1;
				VKL_IS_p2_ti <= VKL_IS_p2;
				
	--			PCC_ti <= PCC;	
				PIMSH_ti <= PIMSH;
				PIMP_ti <= PIMP;
				PIMP2_ti <= PIMP2;
				PIC1_ti <= PIC1;
				PIC2_ti <= PIC2;
				PIC2_PC_ti <= PIC2_PC;
				PIPP_ti <= PIPP;
				PIPP2_ti <= PIPP2;
				
				PIAP_ti <=  PIAP;
				PIAP2_ti <=  PIAP2;
				piap_imp_ti <= piap_imp;
				piap2_imp_ti <= piap2_imp;
				PIAP_p1_ti <=  PIAP_p1;
				PIAP_p2_ti <=  PIAP_p2;
				piap_p1_imp_ti <=  piap_p1_imp;
				piap_p2_imp_ti <=  piap_p2_imp;
				
				P_vikl_SH_ti <= P_vikl_SH;

				DC2_ti <= DC2;
				DC1_ti <= DC1;
				DNP1_ti <= DNP1;
				DNP2_ti <= DNP2;
				DNP_p1_ti <= DNP_p1;
				DNP_p2_ti <= DNP_p2;
				
				fdop_ti <= fdop1;
				fdop2_ti <= fdop2;
				fdev_ti <= fdev;
				
				Fdpp1_ti <= Fdpp1;
				Fdpp2_ti <= Fdpp2;
				Fdpp_p1_ti <= Fdpp_p1;
				Fdpp_p2_ti <= Fdpp_p2;
				
				fdop_pp1_ti <= fdop_pp1;
				fdop_pp2_ti <= fdop_pp2;
				
				ap_o_1_ti <= ap_o_1;
				ap_o_2_ti <= ap_o_2;
				ap_o_3_ti <= ap_o_3;
				ap_pl_1_ti <= ap_pl_1;
				ap_pl_2_ti <= ap_pl_2;
				
				noise_plus3_ti <= noise_plus3;
				noise_minus3_ti <= noise_minus3;
			 end if;
		end process;		
	--------------------------------------recalculation length PP---------------------------------------
   
   N_rec  <= recalculationDpp(Fdpp1_ti);
   N2_rec  <= recalculationDpp(Fdpp2_ti);
	
	 N_p1  <= recalculationDpp(Fdpp_p1_ti);
    N_p2  <= recalculationDpp(Fdpp_p2_ti);
-----------------------------------------------noise-----------------------------------------
	 k_str_sh1 <= recalculation1(sigma_5_2);
	 bandpsss_custom <= recalculation1(b);
	 noise_ampl <= recalculation1(c);
	 
	 process ( sigma_custom , noise_plus3_ti, noise_minus3_ti) is
		begin
			if noise_plus3_ti = '1' then
				sigma_custom <= recalculation1(sigma_plus3);
			elsif noise_minus3_ti = '1' then
				sigma_custom <= recalculation1(sigma_minus3);
			else 
				--sigma_custom <= recalculation1(sigma_14);
				sigma_custom <= recalculation1(sigma_11);
				--sigma_custom <= recalculation1(sigma_63);
			end if;
		end process;
		
		
--		process (noise_plus3_ti, noise_minus3_ti, UC1_ti) is
--		begin
--			if noise_plus3_ti = '1' then
--				sigma_custom <= recalculation1(sigma_plus3);
--			elsif noise_minus3_ti = '1' then
--				sigma_custom <= recalculation1(sigma_minus3);
--			else
--				if (std_logic_vector(to_unsigned(50, 8)) <= UC1_ti and UC1_ti <= std_logic_vector(to_unsigned(70, 8))) then
--					sigma_custom <= recalculation1(sigma_7);
--					en_noise <= '1';
--				else
--					sigma_custom <= recalculation1(sigma_21);
--					en_noise <= '0';
--				end if;
--			end if;
--			end process;
	
	-------------------------------------------------C/MP-------------------------------
      process ( PIC1_ti , PIMP_ti) is
		begin
			if  PIMP_ti = '1' and PIC1_ti = '0' then
				EN_DC1 <= '0';
				EN_MP1 <= '1';
			elsif PIMP_ti = '0' and PIC1_ti = '1' then
				EN_DC1 <= '1';
				EN_MP1 <= '0';
			elsif PIMP_ti = '0' and PIC1_ti = '0' then
				EN_DC1 <= '0';
				EN_MP1 <= '0';
			elsif PIMP_ti = '1' and PIC1_ti = '1' then
				EN_DC1 <= '0';
				EN_MP1 <= '1';
			end if;
		end process;

		  process (PIC2_ti, PIMP2_ti) is
		begin
			if  PIMP2_ti = '1' and PIC2_ti = '0' then
				EN_DC2 <= '0';
				EN_MP2 <= '1';
			elsif PIMP2_ti = '0' and PIC2_ti = '1' then
				EN_DC2 <= '1';
				EN_MP2 <= '0';
			elsif PIMP2_ti = '0' and PIC2_ti = '0' then
				EN_DC2 <= '0';
				EN_MP2 <= '0';
			elsif PIMP2_ti = '1' and PIC2_ti = '1' then
				EN_DC2 <= '0';
				EN_MP2 <= '1';
			end if;
		end process;

	-------------------------------------------Compensator-------------------------
--	Compensator : entity work.CompensatorNoise
--
--		generic map(
--		      int => int,
--					data_level => data_level,
--					fract => fract,
--					data_width => data_width16,
--					data_ppz => data_ppz,
--				--	data_pft => data_pft,
--					data_distance => data_distance,
--					pft_widht => pft_widht,
--					pft_code => pft_code,
--					data_pft => data_pft,
--					data_rom => data_rom16
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => Ce_F6,
--					OD => OD,
--					LG => LG, 
--					TI => TI,
--					KD => KD,
--					rst => rst,
--					RND_X => RND_X_16,
--					noiseAmpl1 => "001000",
--					noiseAmpl2 => "001000",
--					noiseAmpl3 => "001000",--in
--					generatorInclusion1 => '1',
--					generatorInclusion2 => '1',
--					generatorInclusion3 => '1',
--					noiseOutput1 => noiseOutput1 --in
--					--noiseOutput2 => noiseOutput2,
--					--noiseOutput3 => noiseOutput3--out			
--					 );
	------------------------------------------------------------------------C_OK and C_PL----------------   
	pic_en <=  EN_DC1 or PIC2_PC_ti;
	------------------------------
	channel_C: entity work.channel_c

		generic map(
		         int => int,
					data_level => data_level,
					fract => fract,
					data_width => data_width16,
					data_ppz => data_ppz,
					data_pft => data_pft,
					data_distance => data_distance,
					pft_widht => pft_widht,
				--	pft_code => pft_code,
			--		data_pft => data_pft,
					data_rom => data_rom16
					)

		port map ( 
					Clk_96 => Clk_96,
					Clk_192 => Clk_192,
					Ce_F6 => '1',
					OD => OD ,
					LG => LG , 
					TI => TI,
					KD => KD,
					en_noise => en_noise,
					fdev => fdev_ti,
					fdop => fdop_ti,
					fdop2 => fdop2_ti,
					PFT => PFT_ti,--in
					PIC1_is =>  pic_en,
					PIC2_is =>  EN_DC2,
					PIC2_PC => PIC2_PC_ti,
					EN_MP1 => EN_MP1,
					EN_MP2 => EN_MP2,
					PIPP => PIPP_ti,
					DC1 => DC1_ti,
					DC2 => DC2_ti,
					UC1 => UC1_ti,
					UC2 => UC2_ti,
					ppz_m => ppz_ti,
					ppz_new => ppz_new_ti,
					Sign_LCHM => Sign_LCHM_ti, --in
					UC1_sfix => UC1_cos_sfix_16,
					UC2_sfix => UC2_cos_sfix_16,
					UC2_out => UC2_cos_16,
					UC1_out => UC1_cos_16--out			
					 );
					 
					 awgn_out <= UC1_cos_16 when rising_edge(Clk_96);

	--------------------------------------Channel_modul_g----------------
	------------------------------   
--	pic_g_en <=  EN_DC1 or PIC2_ti;
--	
--	channel_ram: entity work.channel_modul_g
--
--		generic map(
--		         int => int,
--					data_level => data_level,
--					fract => fract,
--					data_width => data_width,
--					data_ppz => data_ppz,
--				   data_pft => data_pft,
--					data_distance => data_distance,
--					pft_widht => pft_widht,
--					pft_code => pft_code,
--			--		data_pft => data_pft,
--					data_rom => data_rom
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => '1',
--					OD => OD ,
--					LG => LG , 
--					TI => TI,
--					KD => KD,
--					PFT => PFT_ti,--in
--					PIPP => PIPP_ti,
--					PIC => pic_g_en,
--					PIC2_is =>  PIC2_ti,
--					PIMP_is => EN_MP1,
--					UPP => UPP_ti,
--					--PCC => PCC,
--					PCC => PCC_ti,
--					DC1 => DC1_ti,
--					UC1 => UC1_ti,
--					ppz_m => ppz_ti,
--					--ppz_m => ppz_m,
--					lfm_g => lfm_g,--in
--					Sign_LCHM => Sign_LCHM_ti,
--					UC2_out => UC2_mod,
--					UPP_cos_sfix => UPP2_cos_sfix,					
--				   uc1_modg_sfix => uc1_modg_sfix,--out
--					mp1_modg_sfix => mp1_modg_sfix,
--					uc1_modg => uc1_modg--out			
--					 );                                        
	
	------------------------------  
	Generator: entity work.Generator

		generic map( 					
					data_rom => data_rom16,
					magic => magic
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					rst => rst,
					k =>  sigma_custom,
					k_str_sh1 =>  k_str_sh1,
					RND_str_sh1 => RND_str_sh1,
					RND_cos_out => RND_6_X_16_cos,--out
					RND_sin_out => RND_6_X_16_sin,--out
					RND_cos_out2 => RND_6_X_16_cos2,--out
					RND_sin_out2 => RND_6_X_16_sin2--out
					 );
					 
	  rnd_6_un_16_cos <=  RND_6_X_16_cos when rising_edge(clk_96);
	  rnd_6_un_16_sin <=  RND_6_X_16_sin when rising_edge(clk_96);
	  
	  rnd_6_un_16_cos2 <=  RND_6_X_16_cos2 when rising_edge(clk_96);
	  rnd_6_un_16_sin2 <=  RND_6_X_16_sin2 when rising_edge(clk_96);
	  
	  RND_str_sh1_rg <=  RND_str_sh1 when rising_edge(clk_96);
	  
	-------------------------------------PP/AP_OK and PP/AP_PL------------
		
	
	channel_AP_OK: entity work.channel_AP

		generic map(
		         int => int,
					data_level => data_level,
					fract => fract,
					data_width => data_width16,
					data_ppz => data_ppz,
					data_pft => data_pft,
					data_distance => data_distance,
					pft_widht => pft_widht,
--					pft_code => pft_code,
			--		data_pft => data_pft,
					data_rom => data_rom16
					)

		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => Ce_F6,
					OD => OD ,
					LG => LG , 
					TI => TI,
					KD => KD,
					PFT => PFT_ti,--in
					dpp1 => N_rec,
					dpp2 => N2_rec,
               k_ap => noise_ampl,
					--strob_sharu1 => strob_sharu1,
					--strob_sharu2 => strob_sharu1,
					piap_imp_is => piap_imp_ti,
					PIAP_is =>  PIAP_ti,
					piap2_imp_is => piap2_imp_ti,
					PIAP2_is =>  PIAP2_ti,
					rnd_6_un_cos =>   rnd_6_un_16_cos,
					rnd_6_un_sin =>   rnd_6_un_16_sin,
					k2 => bandpsss_custom,
					DC1 => DNP1_ti,
					DC2 => DNP2_ti,
					UAP => UPP_ti,
					UAP2 => UPP2_ti,
					Sign_LCHM => Sign_LCHM_ti,--in
					strob_not_noise => strob_not_noise,
					str_sharu1 => str_sharu1,
					str_sharu2 => str_sharu2,
					UAP_X_sfix => UAP_X_sfix_16,
					UAP2_X_sfix => UAP_X_sfix2_16,
					UAP_o => UAP_o_sf,--out	
					UAP_pl => UAP_pl_sf,--out	
					UAP_out => UAP_X_16--out			
					 );
					 
					 
			channel_PP: entity work.channel_PP

		generic map(
		         int => int,
					data_level => data_level ,
					fract => fract,
					data_width => data_width16,
					data_ppz => data_ppz,
					data_pft => data_pft,
					data_distance => data_distance,
					pft_widht => pft_widht,
--					pft_code => pft_code,
			--		data_pft => data_pft,
					data_rom => data_rom16
					)

		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					OD => OD ,
					LG => LG , 
					TI => TI,
					KD => KD,
					fdev => fdev_ti,
					fdop => fdop_pp1_ti,
					fdop2 => fdop_pp2_ti,
					dpp1 => N_rec,
					dpp2 => N2_rec,
					ppz_new => ppz_new_ti,
					--nakl => pr_nakl,
					--ppz_m => ppz_m,
					ppz_m => ppz_ti,
					PFT => PFT_ti,--in
					PIPP_is => PIPP_ti,
					PIPP2_is => PIPP2_ti,
					DC1 => DNP1_ti,
					DC2 => DNP2_ti,
					UPP => UPP_ti,
					UPP2 => UPP2_ti,
					Sign_LCHM => Sign_LCHM_ti, --in
					--UPP_cos_sfix => UPP_cos_sfix_16,
--					UPP2_cos_sfix => UPP22_cos_sfix_16,
--					PP => UPP_cos_16--out	
					UPP_cos_sfix => UPP_cos_sfix_16,
					UPP2_cos_sfix => UPP22_cos_sfix_16,
      			PP => UPP_cos_16--out			
					 );		 
--
--	---------------------------------------AP_p1 and AP_p2----------
--		
--	

--------channel_AP_p: entity work.channel_AP1
--------
--------		generic map(
--------		         int => int,
--------					data_level => data_level,
--------					fract => fract,
--------					data_width => data_width16,
--------					data_ppz => data_ppz,
--------					data_pft => data_pft,
--------					data_distance => data_distance,
--------					pft_widht => pft_widht,
----------					pft_code => pft_code,
--------			--		data_pft => data_pft,
--------					data_rom => data_rom16
--------					)
--------
--------		port map ( 
--------					Clk_96 => Clk_96,
--------					Ce_F6 => Ce_F6,
--------					OD => OD ,
--------					LG => LG , 
--------					TI => TI,
--------					KD => KD,
--------					PFT => PFT_ti,--in
--------					dpp1 => N_p1,
--------					dpp2 => N_p2,
----------					str_sh_A => str_sharu,
--------					piap_imp_is => piap_p1_imp_ti,
--------					PIAP_is =>  PIAP_p1_ti,
--------					piap2_imp_is => piap_p1_imp_ti,
--------					PIAP2_is => PIAP_p2_ti,
--------					rnd_6_un => rnd_6_un_16_cos2,
--------					rnd_6_un2 => rnd_6_un_16_sin2,
--------					k2 => bandpsss_custom,
--------					k_ap => noise_ampl,
--------					DC1 => DNP_p1_ti,
--------					DC2 => DNP_p2_ti,
--------					UAP => UAP_p1_ti,
--------					UAP2 => UAP_p2_ti,
--------					Sign_LCHM => Sign_LCHM_ti,--in
--------					str_sharu => str_sharu_n,
--------					UAP_X_sfix => UAP_X_sfix_p1_16,
--------					UAP2_X_sfix => UAP_X_sfix_p2_16,
--------					UAP_p1 => UAP_p1_sf,--out	
--------					UAP_p2 => UAP_p2_sf,--out	
--------					UAP_out => UAP_X_p12--out			
--------					 );
------					 
--------	channel_AP_p1: entity work.channel_AP1
--
--		generic map(
--		         int => int,
--					data_level => data_level,
--					fract => fract,
--					data_width => data_width16,
--					data_ppz => data_ppz,
--					data_pft => data_pft,
--					data_distance => data_distance,
--					pft_widht => pft_widht,
----					pft_code => pft_code,
--			--		data_pft => data_pft,
--					data_rom => data_rom16
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => Ce_F6,
--					OD => OD ,
--					LG => LG , 
--					TI => TI,
--					KD => KD,
--					PFT => PFT_ti,--in
--					dpp1 => N_rec,
----					str_sh_A => str_sharu,
--					piap_imp_is => piap_imp_ti,
--					PIAP_is => PIAP_ti,
--					rnd_6_un =>   RND_X_16,
--					DC1 => DC1_ti,
--					UAP => uap_amp1,
--					Sign_LCHM => Sign_LCHM_ti,--in
--					UAP_X_sfix => UAP_X_sfix_p1_16,
--					UAP_out => UAP_X1_16--out			
--					 );
--
---------------------------------------��---------------------------------------------------------
--channel_UP: entity work.channel_UP
--
--		generic map(
--		         int => int,
--					data_level => data_level ,
--					fract => fract,
--					data_width => data_width16,
--					data_ppz => data_ppz,
--					data_pft => data_pft,
--					data_distance => data_distance,
--					pft_widht => pft_widht,
----					pft_code => pft_code,
--			--		data_pft => data_pft,
--					data_rom => data_rom16
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => '1',
--					OD => OD ,
--					LG => LG , 
--					TI => TI,
--					--KD => KD,
--					k_ap => noise_ampl,
--					--dpp1 => N_rec,
--					up => up_ti,
--					en => DNP1_ti,
--					Rom_up_out => signal_up,
--					Rom_up_out_sfix => signal_up_sfix
--					 );		 

	
	------------------------------------------str_sharu2---------------------------------------------
	
	process (Clk_96, str_sharu2 , str_sharu1)
	begin
		if rising_edge(clk_96) then
				if str_sharu2 = '1'  then
						 RND_sharu_A_16_sin <= rnd_6_un_16_sin ; --RND_6_X;
						 RND_sharu_A_16_cos <= rnd_6_un_16_cos ;
						 RND_sharu_A_16_cos2 <= rnd_6_un_16_cos2;
						 RND_sharu_A_16_sin2 <= rnd_6_un_16_sin2; 
					---	 RND_sharu_F <= SH_FLAG; 
			  elsif str_sharu1 = '1'  then
						 RND_sharu_A_16_sin <= RND_str_sh1_rg ; --RND_6_X;
						 RND_sharu_A_16_cos <= RND_str_sh1_rg ;
						 RND_sharu_A_16_cos2 <= RND_str_sh1_rg;
						 RND_sharu_A_16_sin2 <= RND_str_sh1_rg; 
					---	 RND_sharu_F <= SH_FLAG; 
				else          
						RND_sharu_A_16_sin <= (others => '0');
						RND_sharu_A_16_cos <= (others => '0');
						RND_sharu_A_16_sin2 <= (others => '0');
						RND_sharu_A_16_cos2 <= (others => '0');
					--	RND_sharu_F <= (others => '0'); 
				end if;
		end if;
	end process;
	
	------------------------------------------str_sharu1---------------------------------------------
	
--	process (Clk_96, Ce_F6, str_sharu1)
--	begin
--		if rising_edge(clk_96) then
--				if str_sharu1 = '1'  then
--						 RND_sh1  <= RND_str_sh1_rg  ; --RND_6_X;
--				else          
--						 RND_sh1 <= (others => '0');
--				end if;
--		end if;
--	end process;
------------------------------------------str_lg_od---------------------------------------------	
	process (Clk_96, strob_not_noise)
	begin
		if rising_edge(clk_96) then
				if strob_not_noise = '1'   then
						 RND_noise_sin <= rnd_6_un_16_sin;
						 RND_noise_cos <= rnd_6_un_16_cos;
						 RND_noise_sin2 <= rnd_6_un_16_sin2;
						 RND_noise_cos2 <= rnd_6_un_16_cos2;
				else          
						 RND_noise_sin <= (others => '0');
						 RND_noise_cos <= (others => '0');
						 RND_noise_sin2 <= (others => '0');
						 RND_noise_cos2 <= (others => '0');
				end if;
		end if;
	end process;
	
	 RND_sh1 <= (RND_noise_sin + RND_sharu_A_16_sin) when rising_edge(clk_96);
---------------------------------------------pimsh/vikl_sh--------------------------------------------------------
	process (Clk_96, PIMSH_ti, P_vikl_SH_ti )
	begin
		if rising_edge(clk_96) then
				if PIMSH_ti = '1'  then
					 if P_vikl_SH_ti = '0' then
--						 RND_X_16_cos <= (RND_noise_cos or RND_sharu_A_16_cos);
--						 RND_X_16_sin <= (RND_noise_sin or RND_sharu_A_16_sin); --RND_6_X;
--						 RND_X_16_cos2 <= (RND_noise_cos2 or RND_sharu_A_16_cos2);
--						 RND_X_16_sin2 <= (RND_noise_sin2 or RND_sharu_A_16_sin2); --RND_6_X;
						 
						 RND_X_16_cos <= (RND_noise_cos + RND_sharu_A_16_cos);
						 RND_X_16_sin <= (RND_noise_sin + RND_sharu_A_16_sin); --RND_6_X;
						 RND_X_16_cos2 <= (RND_noise_cos2 + RND_sharu_A_16_cos2);
						 RND_X_16_sin2 <= (RND_noise_sin2 + RND_sharu_A_16_sin2); --RND_6_X;
					 else          
						 RND_X_16_cos <= RND_sharu_A_16_cos;
						 RND_X_16_sin <= RND_sharu_A_16_sin;
						 RND_X_16_cos2 <= RND_sharu_A_16_cos2;
						 RND_X_16_sin2 <= RND_sharu_A_16_sin2;
					 end if;
				else 
						 RND_X_16_cos <= (others => '0');
						 RND_X_16_sin <= (others => '0');
						 RND_X_16_cos2 <= (others => '0');
						 RND_X_16_sin2 <= (others => '0');
				end if;
		end if;
		--	end if;
		--end if;
	end process;
	

------------------------------------------OUT---------------------------------------------
--	--process(Clk_96, Ce_F6, PCC )
--	process(Clk_96, Ce_F6, PCC_ti )
--	begin      
--		if rising_edge(clk_96) then 
--			if VKL_IS1_ti = '0' or VKL_IS2_ti = '0' then
--				U_X_r <= SH_FLAG;
--				U_X_g <= SH_FLAG;
--				U_X_r_02 <= SH_FLAG;
--				U_X_g_02 <= SH_FLAG;
--			else 
----				U_X_r <= ( UC1_cos + UMP_cos + UPP_cos  + rnd_x);
--				  U_X_r <= std_logic_vector( 
--						to_signed( 
--							UC1_cos_sfix + UPP_cos_sfix + to_sfixed(signed(UC2_cos), int - 1, fract) + UAP_X_sfix +  to_sfixed(signed(rnd_x), int - 1, fract),
--							data_rom
--						)
--					);
--					
----			elsif PCC = '1' then
----				
--				  U_X_g <= std_logic_vector( 
--						to_signed( 
--							uc1_modg_sfix + to_sfixed(signed( UC2_mod), int - 1, fract) +  UPP_cos_sfix  + UAP_X_sfix +  to_sfixed(signed(rnd_x), int - 1, fract),
--							data_rom
--						)
--					);
--					
--					U_X_r_02 <= std_logic_vector( 
--						to_signed( 
--							UC1_cos_sfix  +  UPP_cos_sfix + to_sfixed(signed(UC2_cos), int - 1, fract) + UAP_X_sfix +  to_sfixed(signed(rnd_x), int - 1, fract),
--							data_rom
--						)
--					);
--					
--					U_X_g_02 <= std_logic_vector( 
--						to_signed( 
--							uc1_modg_sfix + to_sfixed(signed( UC2_mod), int - 1, fract) +  UPP_cos_sfix  + UAP_X_sfix +  to_sfixed(signed(rnd_x), int - 1, fract),
--							data_rom
--						)
--					);
--			end if;
--		end if;
--	end process; 
	
	--------------------------------------------Summ1-------------------
	 process(Clk_96,ap_o_1_ti )
	begin      
		if rising_edge(clk_96) then 
			if ap_o_1_ti= '1' then
			    U_X_1_summ1 <= UAP_p1_sf; 
			else 
         U_X_1_summ1 <= (others => '0');	
			end if;
		end if;
	end process;

 process(Clk_96,ap_o_2_ti )
	begin      
		if rising_edge(clk_96) then 
			if ap_o_2_ti= '1' then
			    U_X_2_summ1 <= UAP_p2_sf; 
			else 
         U_X_2_summ1 <= (others => '0');	
			end if;
		end if;
	end process;
	
	process(Clk_96,ap_o_3_ti )
	begin      
		if rising_edge(clk_96) then 
			if ap_o_3_ti= '1' then
			    U_X_3_summ1 <= UAP_pl_sf; 
			else 
         U_X_3_summ1 <= (others => '0');	
			end if;
		end if;
	end process;
				
	process(Clk_96)
	begin      
		if rising_edge(clk_96) then 
			    U_X_summ1 <= std_logic_vector( 
						to_signed( 
							--UC1_cos_sfix_16 + to_sfixed(signed(UC1_cos_16), int - 1, fract) + UAP_X_sfix_16 + U_X_1_summ1 + U_X_2_summ1 + U_X_3_summ1 + UPP_cos_sfix_16 + signal_up_sfix + to_sfixed(signed(RND_X_16_sin), int - 1, fract),
							UC1_cos_sfix_16 + UAP_X_sfix_16 + UPP_cos_sfix_16 + to_sfixed(signed(RND_X_16_sin), int - 1, fract),
							data_rom16
						)
					);
		end if;
	end process;
	
	----------------------------------------------------------------Summ2--------------------------------------------------------			
 process(Clk_96, ap_pl_1_ti )
	begin      
		if rising_edge(clk_96) then 
			if ap_pl_1_ti= '1' then
			    U_X_1_summ2 <= UAP_p1_sf; 
			else 
         U_X_1_summ2 <= (others => '0');	
			end if;
		end if;
	end process;

 process(Clk_96,ap_pl_2_ti )
	begin      
		if rising_edge(clk_96) then 
			if ap_pl_2_ti= '1' then
			    U_X_2_summ2 <= UAP_p2_sf; 
			else 
         U_X_2_summ2 <= (others => '0');	
			end if;
		end if;
	end process;
	
				
	process(Clk_96)
	begin      
		if rising_edge(clk_96) then 
			    U_X_summ2 <= std_logic_vector(  
						to_signed( 
							UC2_cos_sfix_16 + UAP_X_sfix2_16 + UPP22_cos_sfix_16 + to_sfixed(signed(RND_X_16_cos), int - 1, fract),
							data_rom16
						)
					);
		end if;
	end process;
	
--	------------------------------------------mux channel---------------------------------------------
	--process(Clk_96, Ce_F6, PCC )
	process(Clk_96,VKL_IS1_ti)
	begin      
		if rising_edge(clk_96) then 
			if VKL_IS1_ti = '0' and VKL_IS2_ti = '0' and VKL_IS_p1_ti = '0' and VKL_IS_p2_ti = '0' then
				U_X1 <= (others => '0');
				U_X2 <= (others => '0');
				U_X3 <= (others => '0');
				U_X4 <= (others => '0');
				
			else 
				  U_X1 <= U_X_summ1;	
              --U_X1 <= UC1_cos_16;				  
			     U_X2 <= std_logic_vector( 
						to_signed( 
							 UAP_X_sfix_p1_16 + signal_up_sfix + to_sfixed(signed(RND_X_16_cos2), int - 1, fract),
							data_rom16
						)
					);
					
			     U_X3 <= std_logic_vector( 
						to_signed( 
							UAP_X_sfix_p2_16 + signal_up_sfix + to_sfixed(signed(RND_X_16_sin2), int - 1, fract),
							data_rom16
						)
					);	
					
			      U_X4 <= U_X_summ2; 
			end if;
		end if;
	end process; 
	
	-------------------------------------------OUT2--------------------
	U_X  <= U_X1 when rising_edge(clk_96);
	U_2  <= U_X2 when rising_edge(clk_96);
	U_3  <= U_X3 when rising_edge(clk_96);
	U_4  <= U_X4 when rising_edge(clk_96);

end Behavioral;

