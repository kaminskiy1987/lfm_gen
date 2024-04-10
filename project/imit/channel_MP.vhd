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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity channel_MP is
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
		
		UMP : in std_logic_vector (data_level downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		Sign_LCHM : in std_logic;
		
		fdev : in std_logic_vector (2 downto 0);
		
		fdop : in std_logic_vector (7 downto 0);
		
		DC1 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		PIMP_is : in std_logic;

		ppz_m : in std_logic_vector (4 downto 0);
		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		
		UMP_cos_sfix : out sfixed(int - 1 downto fract);
		
		MP : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end channel_MP;

architecture Behavioral of channel_MP is

	Signal UMP_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal MP_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UMP_cos : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal EN_MP1, EN_MP2: std_logic_vector (data_distance downto 1):=(others => '0') ;
	Signal MP1 , MP2, str_pilot : std_logic := '0';
	Signal UMP_cos_sfixed : sfixed(int - 1 downto fract) := (others => '0');
	constant phasa : real := 0.0;
	constant	dopler: real := 0.0;
	
	--attribute keep : string;
	--attribute keep of UMP_cos_sfix : signal is "true";
	--attribute keep of  str_pilot  : signal is "true";
	

begin

--MUX_signal_type_MP: entity work.MUX_signal_type_MP2
--
--		generic map( 
--					data_ppz => data_ppz,
--					data_pft => data_pft,
--					data_rom => data_rom
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => '1',
--					PFT => PFT,
--					OD => OD,
--					LG => LG,
--					TI => TI ,--in
--					--P2 => P2,
--					--NT_PPZ => NT_PPZ, --in
--					Sign_LCHM => Sign_LCHM, --in
--					EN => MP1,--in
--					Rom_cos => MP_cos--out			
--					 );
--MUX_signal_type_C: entity work.MUX_signal_type4
MUX_signal_type_C: entity work.mux_phasa

		generic map( 
					data_ppz => data_ppz,
					data_pft => data_pft,
					phasa => phasa,
			      dopler => dopler,
					data_rom => data_rom
					)

		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					OD => OD ,
					LG => LG , 
					TI => TI,
					PFT => PFT,
					fdev => fdev,
					fdop => fdop,--in
					--P2 => P2,
					ppz_m => ppz_m, --in
					Sign_LCHM => Sign_LCHM, --in
					EN => str_pilot,--in
					Rom_cos =>  MP_cos--out			
					 );
	----------------------------------
	----------------------------------  ( -> )
	Amplitude_signal_MP: entity work.Amplitude_signal1

		generic map( 
					int => int,
					data_level => data_level + 1,
					fract => fract
					)
		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					--U => UMP,--in
					U => "0101000",--in
					U_r => UMP_r 	--out		
					);
	--------------------------------
	-------------------------------- ()
	MULT_MP: entity elementary.sfixed_mult

		 generic map( 
					int => int,
					fract => fract,
					data_width => data_width
					)
		  port map (
					R => '0',
					Clk => Clk_96,
	--				Ce_F6 => '1',
					K_mult => UMP_r ,
					D_mult => MP_cos, --in
					Q_mult => UMP_cos,	--out
					Q_mult_sfixed => UMP_cos_sfixed
					);
	------------------------------------------------------
	 distance_pilot_signal: process (Ce_F6, ti) is
			variable count_gen: integer := 0;
		begin
			if (ti = '1') then
				count_gen := 0;
			elsif(rising_edge(Ce_F6)) then
			--	if (24 <= count_gen and count_gen <= 324) then
				if (162 <= count_gen and count_gen <= 324) then
					 str_pilot <= '1';
				else
					 str_pilot <= '0';
				end if;
			count_gen := count_gen + 1;	
			end if;		
		end process	distance_pilot_signal;	
	---------------------------    (..  50)
--	Distance_MP: entity work.Distance2
--   --Distance_MP: entity work.distance_mp
--		generic map( 
--					data_distance => data_distance,
--					pft_widht => pft_widht,
--					pft_code => pft_code,
--					data_pft => data_pft
--					
--					)
--
--		port map ( 
--					Clk_96 => Clk_96,
--					Ce_F6 => '1',
--					PI => PIMP_is,--in
--					--P2 => P2,
--					D => DC1,--in
--					PFT => PFT, --in
--					--OD => OD,--in
--					OD => LG,--in
--					EN_Signal_D => MP1--out
--					);
-------------------------------------------------					
	process (clk_96) is
	begin
		if rising_edge(clk_96) then
			UMP_cos_sfix <=  UMP_cos_sfixed; --to_sfixed(ump_cos, int - 1, fract);
			mp <= ump_cos;
		end if;
	end process;

end Behavioral;

