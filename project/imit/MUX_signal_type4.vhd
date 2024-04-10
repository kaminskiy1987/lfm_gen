

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
    
entity MUX_signal_type4 is
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
		Clk_192 : in std_logic;
		Ce_F6 : in std_logic;
		En : in std_logic;  
		En2 : in std_logic;     
		OD : in std_logic;		
	   LG : in std_logic;		
	   TI : in std_logic;
		fdop	  : in std_logic_vector (7 downto 0);
		fdop2	  : in std_logic_vector (7 downto 0);
		fdev	: in std_logic_vector (2 downto 0);  
		PFT : in std_logic_vector (data_pft-1 downto 0);
      EN_MP1	: in std_logic;
      PIC1_is	: in std_logic;
		PIC2_is	: in std_logic;
		PIPP		: in std_logic;
		Sign_LCHM : in std_logic;
		ppz_new : in std_logic_vector (6 downto 0);
		ppz_m : in std_logic_vector (4 downto 0);
		Rom_sin : out std_logic_vector (15 downto 0);	
		Rom_cos : out std_logic_vector (15 downto 0)		
		--Rom_sin : out std_logic_vector (13 downto 0);	
		--Rom_cos : out std_logic_vector (13 downto 0)		
	);

end MUX_signal_type4;

architecture Behavioral of MUX_signal_type4 is
 signal Rom_cos_i : std_logic_vector (data_rom-1 downto 0):=(others => '0');
 signal Rom_sin_i : std_logic_vector (data_rom-1 downto 0):=(others => '0');
begin

	all_signals_inst : entity all_signals.all_signals
		generic map(
			phasa => phasa,
			dopler => dopler,
			data_pft => data_pft,
			--width => 14
			width => 16
		)
		port map(
			clk => clk_96,
			clk_192 => clk_192,
			ce => ce_F6,
			en => en,
			en2 => en2,
			od => od,
			lg => lg,
			ti => ti,
			pft => pft,
			EN_MP1 => EN_MP1,
			PIC1_is => PIC1_is,
			PIPP => PIPP,
			dop => fdop,
			dop2 => fdop2,
			ppz_m => ppz_m,
			ppz_new => ppz_new,
			dev => fdev,
			sign_lchm => Sign_LCHM,
			out_data_sin => Rom_sin_i,
			out_data_cos => Rom_cos_i
		);
	
	Rom_cos <= Rom_cos_i and en when rising_edge(clk_96);
	Rom_sin <= Rom_sin_i and en2 when rising_edge(clk_96);
	
end Behavioral;