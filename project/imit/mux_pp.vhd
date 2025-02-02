----------------------------------------------------------------------------------

-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:08:59 11/01/2019 
-- Design Name: 
-- Module Name:    mux_pp - Behavioral 
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


--  ------  --------
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
    
entity mux_pp is
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
		ppz_m : in std_logic_vector (4 downto 0);
		fdop	  : in std_logic_vector (7 downto 0);
		fdev	: in std_logic_vector (2 downto 0);
		dpp1	: in integer;	
		PFT : in std_logic_vector (data_pft-1 downto 0);
		pipp : in std_logic;			
		Sign_LCHM : in std_logic;
		Rom_sin : out std_logic_vector (13 downto 0);	
		Rom_cos : out std_logic_vector (13 downto 0)		
	);

end mux_pp;

architecture Behavioral of mux_pp is
signal Rom_cos_i : std_logic_vector (data_rom-1 downto 0):=(others => '0');

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

begin
  
--  N_rec  <= recalculationDpp(dpp1);

	--all_signals_inst : entity all_signals.all_signals
	all_signals_inst : entity all_signals.all_signals_pp
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
			dpp1 => dpp1,
      pipp => pipp,
			ppz_m => ppz_m,
			pft => pft,
			dev => "000",
			sign_lchm => Sign_LCHM,
			out_data_sin => Rom_sin,
			out_data_cos => Rom_cos_i
		);
		
		Rom_cos <= Rom_cos_i and en when rising_edge(clk_96);
	
end Behavioral;

