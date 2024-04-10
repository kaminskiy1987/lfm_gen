----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:23 10/17/2019 
-- Design Name: 
-- Module Name:    phasa - Behavioral 
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
	Use ieee.std_logic_arith.all;
	Use ieee.std_logic_unsigned.all;
	USE ieee.math_real.all;
	USE std.textio.ALL;
	USE IEEE.std_logic_textio.ALL;

library elementary, ieee_proposed;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	
	use ieee_proposed.fixed_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phasa is
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
		
		--UC1 : in std_logic_vector (data_level downto 0);
		
		PFT : in std_logic_vector (data_pft-1 downto 0);
		
		--Sign_LCHM : in std_logic;
		
		--DC1 : in std_logic_vector (data_distance downto 1);
		
		OD : in std_logic;
		
		--PIC1_is : in std_logic;
		
		--PIC2_is : in std_logic;
		
		fdev : in std_logic_vector (2 downto 0);
		
		fdop : in std_logic_vector (7 downto 0);
		
		--RND_X : in std_logic_vector(data_width - 1 downto 0)

		-- ----
		LG : in std_logic;
		TI : in std_logic;
		KD : in std_logic;
		
		--x_in : in std_logic_vector (data_rom-1 downto 0);
		--y_in : in std_logic_vector (data_rom-1 downto 0);
		
		x_out : out std_logic_vector (data_rom-1 downto 0);
		y_out : out std_logic_vector (data_rom-1 downto 0)
		
		);		
end phasa;

architecture Behavioral of phasa is


Signal C1_cos,  C1_sin : std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_cos, UC2_cos :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	Signal UC1_r : sfixed(int - 1 downto fract):=(others => '0');
	Signal UC1_cos_sfixed, UC1_sin_sfixed : sfixed(int - 1 downto fract) := (others => '0');
	Signal EN_DC1 : std_logic := '0';
	Signal C1 , C2 : std_logic := '0';
	constant phasa : real := ieee.math_real.math_pi;
	constant	dopler: real := 0.011;
	--Signal UC1_sfix : sfixed(int - 1 downto fract):=(others => '0');

begin

	--MUX_signal_type_C: entity work.MUX_signal_type2
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
					--NT_PPZ => NT_PPZ, --in
					--Sign_LCHM => Sign_LCHM, --in
					--EN => C1,--in
					Rom_cos => C1_cos--out
				--	Rom_sin => C1_sin
					 );
					 -------------------------------
					 
	process (clk_96) is
	begin
		if rising_edge(clk_96) then		
			x_out <= C1_cos ; --to_sfixed(UC1_cos, int - 1, fract);	

			--y_out <= C1_sin * y_in;			
					
			--uc1_out <= uc1_cos ;
		end if;
	end process;

end Behavioral;

