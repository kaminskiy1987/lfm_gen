----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:21 11/28/2019 
-- Design Name: 
-- Module Name:    mux_phasa - Behavioral 
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

library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	
library all_signals;
	use all_signals.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_phasa is
 generic (
	
	   data_pft: integer := 6;
		data_ppz : integer := 5;
		pft_widht : integer:= 6;
		pft_code : int_array := (10,27);
		phasa : real := ieee.math_real.math_pi;
		dopler: real := 0.011;
		data_rom : integer := 12
				);
	Port(
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		En : in std_logic;      
		OD : in std_logic;		
	   LG : in std_logic;		
	   TI : in std_logic;
		fdop	  : in std_logic_vector (7 downto 0);
		fdev	: in std_logic_vector (2 downto 0);  
		PFT : in std_logic_vector (data_pft-1 downto 0);		
		Sign_LCHM : in std_logic;
		ppz_m : in std_logic_vector (4 downto 0);
		--Rom_sin : out std_logic_vector (13 downto 0);	
		Rom_cos : out std_logic_vector (13 downto 0)		
	);
end mux_phasa;

architecture Behavioral of mux_phasa is

signal Rom_cos_i : std_logic_vector (data_rom-1 downto 0):=(others => '0');
begin

	--all_signals_inst : entity lfm_gen_m3
	all_signals_inst :entity all_signals.all_signals_mp
		generic map(
			phasa => phasa,
			dopler => dopler,
			data_pft => data_pft,
			width => 14
		)
		port map(
			clk => clk_96,
			ce => ce_F6,
			en => en,
			od => od,
			lg => lg,
			ti => ti,
			pft => pft,
			dop => fdop,
			ppz_m => ppz_m,
			dev => fdev,
			sign_lchm => Sign_LCHM,
			--out_data_sin => Rom_sin,
			out_data_cos => Rom_cos_i
		);
	
	Rom_cos <= Rom_cos_i and en when rising_edge(clk_96);
	
end Behavioral;



