----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:45:16 08/09/2019 
-- Design Name: 
-- Module Name:    channel_modul_g - Behavioral 
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
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use ieee.numeric_std.all;
--	Use ieee.std_logic_arith.all;
--	Use ieee.std_logic_unsigned.all;
	USE ieee.math_real.all;
--	USE std.textio.ALL;
--	USE IEEE.std_logic_textio.ALL;

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

entity channel_modul_g is
generic(

		int : integer := 11;
		fract : integer := -15;
		data_width: integer := 14;
		data_level: integer := 6;
		data_pft: integer := 8;
		data_rom: integer := 14;
		data_distance : integer := 13;
		data_ppz : integer := 5;
		pft_widht : integer:= 8;
		pft_code : int_array := (0, 4, 6, 10, 12, 14, 21, 23, 25, 27);
		length_array: int_array :=  (4195, 1959, 2439, 3359, 5607, 7719, 1633, 2113, 2563, 3043 ); 
		--Delay : integer := 157;
		Delay : integer := 253;
      --Delay_C2 : integer := 8191
	   Delay_C2 : integer := 13500
	);
	
	Port(
		Clk_96 : in std_logic;

		Ce_F6 : in std_logic;
		
		UC1 : in std_logic_vector (data_level downto 0);
		
		UPP : in std_logic_vector (data_level-1 downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		Sign_LCHM : in std_logic;
		
		DC1 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		PIPP : in std_logic;
		
		PCC : in std_logic;
		
		PIC : in std_logic;
		
		PIC2_is : in std_logic;
		
		PIMP_is : in std_logic;
		
		ppz_m : in std_logic_vector (4 downto 0);
		
		
		--RND_X : in std_logic_vector(data_width - 1 downto 0)
      lfm_g : in std_logic_vector (data_rom-1 downto 0);
		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		uc2_out : out std_logic_vector (data_rom-1 downto 0);
		upp_cos_sfix : out sfixed(int - 1 downto fract);
		mp1_modg_sfix : out sfixed(int - 1 downto fract);
		uc1_modg_sfix : out sfixed(int - 1 downto fract);
		uc1_modg : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end channel_modul_g;

architecture Behavioral of channel_modul_g is
	Signal C1_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal lfm_g_reg, lfm_g_reg_reg :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal out_mult, UPP_cos :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC2_cos :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_r, UPP_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal out_mult_sfixed,  UPP_cos_sfixed : sfixed(int - 1 downto fract) := (others => '0');
	signal upp_ampl : std_logic_vector (data_level downto 0):= (others => '0');
	Signal EN_DC1 : std_logic := '0';
	Signal pi2 : std_logic := '0';
	Signal pi_pp : std_logic := '0';
	Signal enable : std_logic := '0';
	Signal str_d : std_logic := '0';
	Signal C_in , C_out, C_out_PP : std_logic := '0';
	signal out_ram, out_ram_pp : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal x_cos_address : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal x_in : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal y_in : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal x_dis : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal y_dis : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal UX_cos_sfixed : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal UY_cos_sfixed : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	--constant inn_distance_range : integer := data_distance + 5;
	constant inn_distance_range : integer := data_distance + 5;
	---------------------------phasa-------------------------------
	signal out_mult_p, out_mult_mp  :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	signal ppz :  std_logic_vector (2 downto 0) := (others => '0');
		constant c12 :  std_logic_vector (2 downto 0) := ('0', '1', '0');
	--constant c3 :  std_logic_vector (2 downto 0) := ('0', '0', '1');
	constant c3 :  std_logic_vector (2 downto 0) := ('1', '0', '0');
	constant a :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
	signal phase_mask :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	subtype count_int is natural range 0 to 7;
	--signal cnt : count_int := 0;
	signal cnt : integer range 0 to 7 := 0;
	Signal adress_sdc : std_logic := '0';
	
	constant ADDRESS_WIDTH : integer := 14;
	constant D : integer := 1;
	constant dis : INTEGER := 415;
	constant del : INTEGER := 4159;
	constant ampl : real := 16.0;
	
	-------------------
	signal sdc_flag : boolean := false;
	-------------------
	
--	function recalculation( a : std_logic_vector; size : integer) return std_logic_vector is
--		variable res : std_logic_vector(size - 1 downto 0) ;
--	begin	 
--		return conv_std_logic_vector(conv_integer(a) * 32 , size);
----		return res;
--    --   return a;		
--	end recalculation;
		
	--Signal UC1_sfix : sfixed(int - 1 downto fract):=(others => '0');
	--attribute keep : string;
	--attribute keep of cnt : signal is "true";
	--attribute keep of out_mult : signal is "true";
	--attribute keep of adress_sdc : signal is "true";
	--attribute keep of phase_mask : signal is "true";
	--attribute keep of out_mult_p : signal is "true";
	--attribute keep of out_mult_mp : signal is "true";
	

begin


	lfm_g_reg  <= lfm_g when rising_edge(clk_96);
	
	lfm_g_reg_reg  <= lfm_g_reg when rising_edge(clk_96);
--------------------------------------------------------

	str_d1 : process (ti, lg, od , kd) is
		variable first_p : boolean := False;
	begin
		--if ti = '1' then
		--	first_p := False;
	--	elsif first_p = True then
		
			if (od = '1') then
				str_d <= '1';
				first_p := True;
			elsif first_p = True then	
			--	cnt := 1;
			--end if;
			
				if (kd = '1') then
					str_d <= '0';
					first_p := False;
				end if;
			end if;
		
	end process str_d1;
	
	---------------------------------------------------------
	enable1 : process (ti, lg, od ) is
		variable first_p : boolean := False;
	begin
--		if ti = '1' then
--			first_p := True;
--		elsif first_p = True then
		
			if (lg = '1') then
				enable <= '1';
				first_p := True;
			elsif first_p = True then
			
				if (od = '1') then
				enable <= '0';
				first_p := False;
		--	else
		--		enable <= '0';
			
				end if;
    		end if;
		
	end process enable1;
----------------------------------------------------------

	-----------------------------------------------------
  MUX_signal_type_X: entity work.MUX_signal_ram

		generic map( 
					--data_ppz => data_ppz,
					--data_pft => data_pft,
					del => del ,
					delay  => Delay_C2 ,
					DATA_WIDTH => data_rom
					)

		port map ( 
					Clock => Clk_96,
					--Ce_F6 => '1',
					PIC => '1',
					PIPP => PIPP ,
					readEn =>  C_out,
					WriteEn => C_in  , 
					--WriteEn => enable  ,
					readEnPP => C_out_PP, 
					Reset => '0',
					Enable => '1',
					--PFT => PFT,--in
					--P2 => P2,
					--NT_PPZ => NT_PPZ, --in
					--DataIn => lfm_g_reg,
					DataIn => lfm_g_reg_reg,
					DataOut_PP => out_ram_pp,--out
					DataOut => out_ram--out			
					 );


	--------------------------------   ( -> )
	--Amplitude_signal_g: entity work.Amplitude_signal1
	Amplitude_signal_g: entity work.ampl


		generic map( 
					int => int,
					data_level => data_level + 1,
					nnominal => ampl,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					PCC =>PCC,
					U => UC1,--in
					U_r => UC1_r 	--out		
					);
	-----------------------------
	

	MULT_x: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
--					Ce_F6 => '1',
					K_mult => UC1_r,
					--K_mult =>to_sfixed( D, int - 1, fract),
					D_mult => out_ram, --in
					Q_mult => out_mult,	--out
					Q_mult_sfixed => out_mult_sfixed
					 );
	------------------------------------------------------
	pi2 <=  PIC or PIMP_is;
	
	Distance_g_out: entity work.Distance2

		generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht,
					pft_code => pft_code,
					data_pft => data_pft
					
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					--PI => '1',--in
					PI => pi2,
					--P2 => P2,
					D => DC1,--in
					PFT => PFT, --in
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => C_out--out
					);
					--------------------------------------------
	--Distance_g_in: entity work.Distance2
	Distance_g_in: entity work.Distance_pp3

		generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht,
					pft_code => pft_code,
					data_pft => data_pft
					
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					PI => '1',--in
					ti => ti,
					D => std_logic_vector( to_unsigned( dis, inn_distance_range)),--in
					PFT => PFT, --in
					LG => LG,--in
					-------------------
					sdc_flag => sdc_flag,
					-------------------
					EN_Signal_D => C_in--out
					);
-----------------------------------------------------------------------------------------------------
	---------------------------------phasa--------------------------------------
--	--process (ppz_m, ti, lg ) is
--	process (ti) is
--   begin
--		if falling_edge(ti) then
--			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or  ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" then 
--				phase_mask <=  c12;
--				sdc_flag <= true;
--			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" then
--				phase_mask <=  c3;
--				sdc_flag <= true;
--			elsif ppz_m  = "00000" then
--				phase_mask <=  a;
--				sdc_flag <= false;
--			----------------------	
--			else
--				sdc_flag <= false;
--			----------------------	
--			end if;
--		end if;
--	end process;	
	
	--process (ppz_m, ti, lg ) is
	process (ti, PIPP) is
   begin
		if falling_edge(ti) then
			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or 
			ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" or (ppz_m(4 downto 3) = "10" and pipp = '1') or (ppz_m(4 downto 3) = "11" and pipp = '1') then 
				phase_mask <=  c12;
				sdc_flag <= true;
			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" or (ppz_m(4 downto 3) = "10" and pipp = '0') or (ppz_m(4 downto 3) = "11" and pipp = '0') then
				phase_mask <=  c3;
				sdc_flag <= true;
			elsif ppz_m  = "00000" then
				phase_mask <=  a;
				sdc_flag <= false;
			----------------------	
			else
				sdc_flag <= false;
			end if;
		end if;
	end process;	
	---------------------------------------------------------------------------------
	--lg_counter : process (Clk_96, lg, ti, phase_mask, cnt, od ) is
	lg_counter : process (lg, ti) is
	--	variable cnt : count_int := 0;
		variable c : std_logic := '0';
	begin
	--if pft(2 downto 0) = "001" or "111" then
		if ti = '1' then
			cnt <= 0;
	--		tp <= sfx_null;
--		if rising_edge(clk)  then
		elsif rising_edge(lg)  then
	--			cnt <= cnt + 1;
				c:= phase_mask(cnt);
				--cnt <= cnt + 1;
					if c = '0' then
						adress_sdc <= '0';
					else 
						adress_sdc <= '1';
					end if;
				cnt <= cnt + 1;	
--				else
--					cnt := 0;
--				   tp <= sfx_null;
		end if;
--	end if;
	end process;
	---------------------------------------------------------------------------------------
   process (Clk_96, adress_sdc , out_mult , PIC , PIMP_is) is
	--	variable cnt : count_int := 0;
		variable c : std_logic := '0';
	begin
		if rising_edge(Clk_96)  then
			if  PIC = '1' then
				if adress_sdc = '0' then
					out_mult_p <= out_mult;
				else 
					out_mult_p <= std_logic_vector(unsigned(not out_mult) + 1);
				end if;
			elsif PIMP_is = '1' then
				out_mult_p <= out_mult;
			else
				out_mult_p <= out_mult;
			end if;
			
		end if;
	end process;
	----------------------------------------------------------------------------------------
--	 process (Clk_96, PIMP_is ) is
--	--	variable cnt : count_int := 0;
--		variable c : std_logic := '0';
--	begin
--					if rising_edge(Clk_96)  then
--						if PIMP_is = '1' then 
--							out_mult_mp <= out_mult;
--						else
--							out_mult_mp <= (others => '0');
--						end if;
--					end if;
--	end process;
---------------------------------------- PP -------------------------------------------------------------
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
			--K_mult =>to_sfixed( D, int - 1, fract),
			D_mult =>  out_ram_pp, --in
			Q_mult => UPP_cos,
			Q_mult_sfixed => UPP_cos_sfixed			--out
		);
	------------------------------------------------------
	-------------------------  (..  50)
	pi_pp <= PIPP or PIC;
	--Distance_PP: entity work.Distance2
	Distance_PP: entity work.Distance_pp2
		generic map( 
			data_distance => data_distance,
			pft_widht => pft_widht,
			pft_code => pft_code,
			data_pft => data_pft				
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			PI => pi_pp ,--in
			--P2 => P2,
			D => DC1 ,--in
			PFT => PFT, --in
			--OD => OD,--in
			OD => LG,--in
			EN_Signal_D => C_out_PP--out
		);					
-----------------------------------------------------------
upp_ampl <=  '0' & UPP;
--Amplitude_signal_PP: entity work.Amplitude_signal1
	Amplitude_signal_PP:entity work.ampl 

		generic map( 
			int => int,
			data_level => data_level +1,
			nnominal => ampl,
			fract => fract
		)
		port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => '1',
			PCC =>PCC,
			U => upp_ampl,--in
			U_r => UPP_r 	--out		
		);
--------------------------------------------------------------------------------------------------	
--------------------------------------------------Парная цель-------------------------------------
	UC2_PC: entity work.UC2
	
		generic map( 
					data_rom => data_rom,
					delay => delay
					)
		port map ( 
				Clk_96 => Clk_96,
				Ce_F6 => '1',
				PI => PIC2_is,
--				Delay => Delay_C2,
				U_cos =>  out_mult,	--in
				--U_cos =>  uc1_modg,
				U_cos_delay => UC2_cos	--out
				 );


--------------------------------------------------------------------------------------------------	
		process (clk_96) is
	begin
		if rising_edge(clk_96) then		
			--uc1_modg_sfix <= out_mult_sfixed; --to_sfixed(UC1_cos, int - 1, fract);		
			uc1_modg_sfix <= to_sfixed(signed( out_mult_p), int - 1, fract);
		--	mp1_modg_sfix <= to_sfixed(signed( out_mult_mp), int - 1, fract);
			uc1_modg <= out_mult ;
			
			uc2_out <= uc2_cos ;
			
			upp_cos_sfix <=  UPP_cos_sfixed;
		end if;
	end process;

end Behavioral;



