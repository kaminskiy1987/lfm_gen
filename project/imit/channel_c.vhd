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
--library IEEE;
--	use IEEE.STD_LOGIC_1164.ALL;
--	Use ieee.std_logic_arith.all;
--	Use ieee.std_logic_unsigned.all;
--	USE ieee.math_real.all;
--	USE std.textio.ALL;
--	USE IEEE.std_logic_textio.ALL;
--
--library elementary, ieee_proposed;
--	use elementary.s274types_pkg.all;
--	use elementary.utility.all;
--	use elementary.all;
--	
--	use ieee_proposed.fixed_pkg.all;

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

entity channel_c is
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
		Delay_c2 : integer := 513;
		Delay : integer := 253;
      --Delay_C2 : integer := 8191
	   Delay_C22 : integer := 13500
	);
	
	Port(
		Clk_96 : in std_logic;
		
		Clk_192 : in std_logic;

		Ce_F6 : in std_logic;
		
		--pt : in std_logic;
		
		UC1 : in std_logic_vector (data_level downto 0);
		
		UC2 : in std_logic_vector (data_level downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		Sign_LCHM : in std_logic;
		
		DC1 : in std_logic_vector (data_distance downto 1);
		
		DC2 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		en_noise : in std_logic;
		
		PIC1_is : in std_logic;
		
		PIC2_is : in std_logic;
		
		PIC2_PC : in std_logic;
		
		--en_gen : in std_logic;
		
		EN_MP1 : in std_logic;
		
		EN_MP2 : in std_logic;
		
		PIPP : in std_logic;
		
		fdev : in std_logic_vector (2 downto 0);
		
		fdop : in std_logic_vector (7 downto 0);
		
		fdop2 : in std_logic_vector (7 downto 0);
		
		ppz_m : in std_logic_vector (4 downto 0);
		
		ppz_new : in std_logic_vector (6 downto 0);

		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		
		UC1_sfix : out sfixed(int - 1 downto fract);
		UC2_sfix : out sfixed(int - 1 downto fract);
		UC2_out : out std_logic_vector (data_rom-1 downto 0);
		UC1_out : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end channel_c;

architecture Behavioral of channel_c is

	Signal C1_cos, C1_sin, C1_ram, C1_cos_r, rom_dds : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_cos, UC2_cos, UC1_sin, UC2_sin :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_r, UC2_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal UC1_cos_sfixed, UC1_sin_sfixed : sfixed(int - 1 downto fract) := (others => '0');
	Signal EN_DC1, EN_MP_un : std_logic := '0';
	Signal C1 , C2 : std_logic := '0';
	signal pi_dis, pi2_dis : std_logic := '0';
	signal pic_gen : std_logic := '0';
	constant phasa : real := ieee.math_real.math_pi;
	constant	dopler: real := 0.011;
	constant Delay_l1 : integer := 128;
	constant	Delay_l2 : integer := 256;
	constant	Delay_l3 : integer := 513;
	signal Delay_ppc : integer := 0;
	Signal dp: std_logic_vector (7 downto 0):="01000000";
	Signal dp_t : sfixed(int - 1 downto fract) := (others => '0');
	--signal pft_dev  : std_logic_vector (8 downto 0) := (others => '0');
	signal pft_dev  : std_logic_vector (6 downto 0) := (others => '0');
	signal fdop_dds1 : std_logic_vector (7 downto 0) := (others => '0');
	
	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);	
	
----------------------------------------------------------------------------------------------
signal out_mult_p, out_mult_mp, out_mult_p2  :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
  constant c12 :  std_logic_vector (2 downto 0) := ('0', '1', '0');
	constant c3 :  std_logic_vector (2 downto 0) := ('1', '0', '0');
	constant a :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	signal phase_mask :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	subtype count_int is natural range 0 to 7;
	--signal cnt : count_int := 0;
	signal cnt : integer range 0 to 7 := 0;
	Signal adress_sdc : std_logic := '0';
	signal sdc_flag : boolean := false;
	
	attribute keep : string;
	attribute keep of UC1_cos : signal is "true";
	
	
begin

	EN_MP_un <= EN_MP1 or EN_MP2;
   
	 pft_dev <= pft & fdev;
   
-------------------------LHM_calc---------------------------------	
--	  MUX_signal_type_C: entity work.MUX_signal_type4
--
--		generic map( 
--					data_ppz => data_ppz,
--					data_pft => data_pft,
--					phasa => phasa,
--			      dopler => dopler,
--					data_rom => data_rom
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Clk_192 => Clk_192,
--					Ce_F6 => '1',
--					OD => OD ,
--					LG => LG , 
--					TI => TI,
--					PFT => PFT,
--					fdev => fdev,
--					fdop => fdop,--in
--					fdop2 => fdop2,
--					EN_MP1 => EN_MP_un,
--					PIC1_is => PIC1_is,
--					PIC2_is => PIC2_is,
--					PIPP => PIPP,
--					ppz_m => ppz_m,
--					ppz_new => ppz_new,
----					pt => pt, --in
--					Sign_LCHM => Sign_LCHM, --in
--					EN => C1,--in
--					EN2 => C2,--in
--					Rom_cos => C1_cos,--out
--					Rom_sin => C1_sin--out			
--					 );
				 
				 
--				 MUX_signal_type_C: entity work.dds
--			port map ( 
--					Clk_96 => Clk_96,					
--					lg => lg,
--					lchm_type => pft_dev,--in
--				   en => c1,
--					Sign_LCHM => Sign_LCHM,
--					rom_dds => rom_dds--out		
--					);
	---------------------------------------DDS_example------------------
--		process (ti, PIPP) is
--   begin
--		if falling_edge(ti) then
--			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or 
--			ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" or (ppz_m(4 downto 3) = "10" and pipp = '1') or (ppz_m(4 downto 3) = "11" and pipp = '1') then 
--				--phase_mask <=  c12;
--				fdop_dds1 <= "00000110";
--				--sdc_flag <= true;
--			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" or (ppz_m(4 downto 3) = "10" and pipp = '0') or (ppz_m(4 downto 3) = "11" and pipp = '0') then
--				--phase_mask <=  c3;
--				--sdc_flag <= true;
--			--elsif ppz_m  = "00000" then
--				--phase_mask <=  a;
--				--sdc_flag <= false;
--			----------------------
--			fdop_dds1 <= "11011100";
--			else
--			   fdop_dds1 <= "00000000";
--				--sdc_flag <= false;
--			end if;
--		end if;
--	end process;	
--------------------------------------LHM_DDS----------------------------------------
 MUX_signal_type_C: entity work.mux_signal_lhm

		generic map( 
					data_ppz => data_ppz,
					data_pft => data_pft,
					--phasa => phasa,
			      dopler => dopler,
					data_rom => data_rom
					)

		port map ( 
					Clk_96 => Clk_96,
					--Clk_192 => Clk_192,
					Ce_F6 => '1',
					OD => OD ,
					LG => LG , 
					TI => TI,
					PFT => PFT,
					fdev => fdev,
					fdop => fdop,--in
					fdop2 => fdop2,--in
					EN_MP1 => EN_MP_un,
					PIC1_is => PIC1_is,
					PIC2_is => PIC2_is,
					PIPP => PIPP,
					ppz_m => ppz_m,
					ppz_new => ppz_new,
					--pt => pt, --in
					Sign_LCHM => Sign_LCHM, --in
					EN => C1,--in
					EN2 => C2,--in
					Rom_cos => C1_cos,--out
					Rom_sin => C1_sin--out			
					 );
					
	--------------------------------Ampl--------------------------------
	--Amplitude_signal_C: entity work.Amplitude_signal1
	Amplitude_signal_C: entity work.ampl

		generic map( 
					int => int,
					data_level => data_level + 1,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
				   en_noise => en_noise,
					U => UC1,--in
					U_r => UC1_r 	--out		
					);

	------------------------------Mult-------------------------------

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
					K_mult => UC1_r,
					D_mult => C1_cos, --in
					--D_mult => C1_cos_r, --in
					Q_mult => UC1_cos,	--out
					Q_mult_sfixed => UC1_cos_sfixed
					 );
					 
	-------------------------Distance--------------------------------------
	pi_dis <= PIC1_is or  EN_MP1;
	
	Distance_C: entity work.Distance2

		generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht + 3,
					--pft_code => pft_code,
					data_pft => data_pft
					
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					PI => pi_dis,--in
					--P2 => P2,
					D => DC1,--in
					PFT => pft_dev, --in
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => C1--out
					);

	---------------------------------------------------------- 2 Target-----------------
   pi2_dis <= PIC2_is or  EN_MP2;
	
-------------------------------Distance2--------------------------------					
		Distance_C1: entity work.Distance2

		generic map( 
					data_distance => data_distance,
					pft_widht => pft_widht + 3,
					--en => false,
					--pft_code => pft_code,
					data_pft => data_pft
					
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					PI => pi2_dis,--in
					--P2 => P2,
					D => dc2,--in
					PFT => pft_dev, --in
					--OD => OD,--in
					OD => LG,--in
					EN_Signal_D => C2--out
					);
	--------------Ampl2--------------------------------------------------------------
					
	--Amplitude_signal_C1: entity work.Amplitude_signal1
	Amplitude_signal_C1: entity work.ampl

		generic map( 
					int => int,
					data_level => data_level + 1,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					en_noise => en_noise,
					U => uc2,--in
					U_r => UC2_r 	--out		
					);
	
	------------------------------MULT2------------------------------

	MULT_UC2: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
					--Ce_F6 => '1',
					K_mult => UC2_r,
					D_mult => C1_sin, --in
					--D_mult => C1_ram, --in
					Q_mult => UC1_sin,	--out
					Q_mult_sfixed => UC1_sin_sfixed
					 );
---------------------------PR_PZ_OK------------------------------------
--UC2_PC: entity work.UC2
--	
--		generic map( 
--					data_rom => data_rom,
--					delay => delay_c2
--					)
--		port map ( 
--				Clk_96 => Clk_96,
--				Ce_F6 => '1',
--				PI => PIC2_PC,
----				Delay => Delay_C2,
--				U_cos => UC1_cos,	--in
--				--U_cos =>  uc1_modg,
--				U_cos_delay => UC2_cos	--out
--				 );
				 
--				 ---------------------------PR_PZ_PL------------------------------------
--UC2_PC2: entity work.UC2
--	
--		generic map( 
--					data_rom => data_rom,
--					delay => delay_c2
--					)
--		port map ( 
--				Clk_96 => Clk_96,
--				Ce_F6 => '1',
--				PI => PIC2_PC,
----				Delay => Delay_C2,
--				U_cos =>  UC1_sin,	--in
--				--U_cos =>  uc1_modg,
--				U_cos_delay => UC2_sin	--out
--				 );
--				 
-------------------------------------------------------------------------
--process (ti, PIPP) is
--   begin
--		if falling_edge(ti) then
--			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or 
--			ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" or (ppz_m(4 downto 3) = "10" and pipp = '1') or (ppz_m(4 downto 3) = "11" and pipp = '1') then 
--				phase_mask <=  c12;
--				sdc_flag <= true;
--			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" or (ppz_m(4 downto 3) = "10" and pipp = '0') or (ppz_m(4 downto 3) = "11" and pipp = '0') then
--				phase_mask <=  c3;
--				sdc_flag <= true;
--			elsif ppz_m  = "00000" then
--				phase_mask <=  a;
--				sdc_flag <= false;
--			----------------------	
--			else
--				sdc_flag <= false;
--			end if;
--		end if;
--	end process;	
--	---------------------------------------------------------------------------------
--	--lg_counter : process (Clk_96, lg, ti, phase_mask, cnt, od ) is
--	lg_counter : process (lg, ti) is
--	--	variable cnt : count_int := 0;
--		variable c : std_logic := '0';
--	begin
--	--if pft(2 downto 0) = "001" or "111" then
--		if ti = '1' then
--			cnt <= 0;
--	--		tp <= sfx_null;
----		if rising_edge(clk)  then
--		elsif rising_edge(lg)  then
--	--			cnt <= cnt + 1;
--				c:= phase_mask(cnt);
--				--cnt <= cnt + 1;
--					if c = '0' then
--						adress_sdc <= '0';
--					else 
--						adress_sdc <= '1';
--					end if;
--				cnt <= cnt + 1;	
----				else
----					cnt := 0;
----				   tp <= sfx_null;
--		end if;
----	end if;
--	end process;
--	---------------------------------------------------------------------------------------
--   process (Clk_96, adress_sdc , UC1_cos, UC1_sin ,PIC1_is , EN_MP1) is
--	--	variable cnt : count_int := 0;
--		variable c : std_logic := '0';
--	begin
--		if rising_edge(Clk_96)  then
--			if  PIC1_is = '1' or PIC2_is = '1' then
--				if adress_sdc = '0' then
--					out_mult_p <= UC1_cos;
--					out_mult_p2 <= UC1_sin;
--				else 
--					out_mult_p <= std_logic_vector(unsigned(not UC1_cos) + 1);
--					out_mult_p2 <= std_logic_vector(unsigned(not UC1_sin) + 1);
--				end if;
--			elsif EN_MP1 = '1' or EN_MP2 = '1' then
--				out_mult_p <= UC1_cos;
--				out_mult_p2 <= UC1_sin;
--			else
--				out_mult_p <= UC1_cos;
--				out_mult_p2 <= UC1_sin;
--			end if;
--			
--		end if;
--	end process;
	
-----------------------------------------------------Output-----------	
		process (clk_96) is
	begin
		if rising_edge(clk_96) then		
			uc1_sfix <= UC1_cos_sfixed; --to_sfixed(UC1_cos, int - 1, fract);	
			uc2_sfix <= UC1_sin_sfixed; --to_sfixed(UC1_cos, int - 1, fract);

         --uc1_sfix <= to_sfixed(signed( out_mult_p), int - 1, fract);	
         --uc2_sfix <= to_sfixed(signed( out_mult_p2), int - 1, fract);			

			uc2_out <= UC2_sin ;			
					
			uc1_out <=  C1_cos ;
		end if;
	end process;
		

end Behavioral;
 