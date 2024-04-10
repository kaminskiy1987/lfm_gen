----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:27:33 11/01/2019 
-- Design Name: 
-- Module Name:    all_signals_pp - Behavioral 
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
	use IEEE.NUMERIC_STD.ALL;
   use ieee.math_real.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	
library ieee_proposed;
	use ieee_proposed.fixed_float_types.all;
    use ieee_proposed.fixed_pkg.all;
	 
library lfm_generator;
	use lfm_generator.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity all_signals_pp is
generic(
	   phasa : real := ieee.math_real.math_pi;
		dopler: real := 0.011;
		data_pft: integer := 6;
		width : integer := 14
	);
	port ( 
		clk : in  std_logic;
		ce : in  std_logic;
		en : in std_logic;
		od : in std_logic;
		lg : in std_logic;
	   ti : in std_logic;
		pft : in std_logic_vector (data_pft-1 downto 0);
		dop : in std_logic_vector (7 downto 0) := (others => '0');
      dev : in std_logic_vector (2 downto 0) := (others => '0');
		sign_lchm : in std_logic := '0';
		ppz_m : in std_logic_vector (4 downto 0);
		out_data_cos : out std_logic_vector (width - 1 downto 0);
		out_data_sin : out std_logic_vector (width - 1 downto 0);
		strob : out std_logic;
		-- debug
		debug_out_0 : out sfixed(19 downto -20);
		debug_out_1 : out sfixed(19 downto -20);
		debug_out_2 : out sfixed(19 downto -20)
	);
end all_signals_pp;

architecture Behavioral of all_signals_pp is
	constant int : integer := 8;
	--constant fract : integer := -10;
	constant fract : integer := -20;
--	constant width : integer := 14;

	subtype count_int is natural range 0 to 3;
	signal cnt : integer range 0 to 3 := 0;
	--constant sfx_pi : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi, int - 1, fract);
	constant sfx_pi_2 : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi / 2.0, int - 1, fract);
	constant sfx_pi_4 : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi / 4.0, int - 1, fract);
	constant sfx_null : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	constant sfx_pi   : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi, int - 1, fract);
	--constant sfx_pi_4 : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi / 4.0, int - 1, fract);
	--constant eleven_k_herz : sfixed(int - 1 downto fract) := to_sfixed(0.011, int - 1, fract); -- 11E3
	signal eleven_k_herz : sfixed(int - 1 downto fract) := to_sfixed( 0.000414, int - 1, fract); -- 11E3
	
	constant f0 : sfixed(int - 1 downto fract) := to_sfixed(24.0, int - 1, fract);
	constant fd : sfixed(int - 1 downto fract) := to_sfixed(96.0, int - 1, fract);
	constant ampl : integer := 8191;
	
--	signal strob : std_logic := '0';
	
	signal N : integer := 0;
	signal tp : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdev : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdop : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	
	signal ppz :  std_logic_vector (2 downto 0) := (others => '0');
	
	constant c12 :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	constant c3 :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
	type local_int_array is array (integer range <>) of count_int;
	
	signal a :  local_int_array (2 downto 0):= (0, 1, 2);
	
	signal phase_mask : local_int_array (2 downto 0) := (others => 0);
	
	type t_SIGNAL is record
		N : integer;
		fdev : sfixed(int - 1 downto fract);
		fdop : sfixed(int - 1 downto fract);
	end record;
	
	type tt_SIGNALS is array (natural range <>) of t_SIGNAL;

	constant signals : tt_SIGNALS := (
--		(1440, to_sfixed(2.5, int-1, fract), sfx_null),
--		(2073, to_sfixed(2.5, int-1, fract), sfx_null),
--		(3100, to_sfixed(2.5, int-1, fract), sfx_null),
--		(3868, to_sfixed(2.5, int-1, fract), sfx_null),
--		(1440, to_sfixed(2.5, int-1, fract), eleven_k_herz),
--		(2073, to_sfixed(2.5, int-1, fract), eleven_k_herz),
--		(3100, to_sfixed(2.5, int-1, fract), eleven_k_herz),
--		(3868, to_sfixed(2.5, int-1, fract), eleven_k_herz)
--	);
	--	(2079, to_sfixed(3.0, int-1, fract), sfx_null),--L1-3
	--	(4159, to_sfixed(3, int-1, fract), sfx_null),--L2-3
	--	(4159, to_sfixed(1.5, int-1, fract), sfx_null),--L2-1.5
	--	(8319, to_sfixed(3, int-1, fract), sfx_null),--L3-3
	--	(16346, to_sfixed(0.75, int-1, fract), sfx_null),--L3-0.75
		(16346, to_sfixed(1.5, int-1, fract),  sfx_null),
		(16346, to_sfixed(1.5, int-1, fract), sfx_null)
	--	(2079, to_sfixed(3.0, int-1, fract), eleven_k_herz),--L1C
	--	(4159, to_sfixed(1.5, int-1, fract), eleven_k_herz)--L2C
	);
	--attribute keep : string;
	--attribute keep of N : signal is "true";
	--attribute keep of fdop : signal is "true";
	--attribute keep of phase_mask : signal is "true";
begin
	signal_switch : process (pft) is -- 
	begin
		if rising_edge_ce(clk, ce) then
			if pft = "00110"  then
				N <= signals(0).N;
				fdev <= signals(0).fdev;
				fdop <= signals(0).fdop;
			elsif pft = "00000" then
				N <= signals(0).N;
				fdev <= signals(0).fdev;
				fdop <= signals(0).fdop;
			elsif pft = "00010" then
				N <= signals(0).N;
				fdev <= signals(0).fdev;
				fdop <= signals(0).fdop;
			elsif pft = "10110" then
				N <= signals(0).N;
				fdev <= signals(0).fdev;
				fdop <= signals(0).fdop;
			
			elsif pft = "11000"  then
				N <= signals(0).N;
				fdev <= signals(0).fdev;
				fdop <= signals(0).fdop;
			end if;
		end if;
	end process;
	
	--ppz <= pft(2 downto 0) ;
	
	 process (ppz_m, ti, lg ) is
    begin
		if rising_edge(ti) then
			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or  ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" then 
				phase_mask <=  a;
			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" then
				phase_mask <=  a;
			elsif ppz_m  = "00000" then
				phase_mask <=  a;
			end if;
		end if;
	end process;	
						
--	 process (ppz_m, ti, lg ) is
--    begin
--		if rising_edge( ti) then
--			if ppz_m  = "00001" or  ppz_m  = "01001" or ppz_m  = "00010" or  ppz_m  = "01010" or ppz_m  = "00100" or  ppz_m  = "01100" or ppz_m  = "01101" or  ppz_m  = "00111" or  ppz_m  = "01111" then 
--				phase_mask <=  c12;
--			elsif ppz_m  = "00011" or  ppz_m  = "01011" or ppz_m  = "00110" or  ppz_m  = "01110" then
--				phase_mask <=  c3;
--			elsif ppz_m  = "00000" then
--				phase_mask <=  a;
--			end if;
--		end if;
--	end process;	
						
--		lg_counter : process (clk, ce, lg, ti, sfx_null, sfx_pi, phase_mask, cnt, od ) is
--	--	variable cnt : count_int := 0;
--		variable c : std_logic := '0';
--	begin
--	--if pft(2 downto 0) = "001" or "111" then
--		if ti = '1' then
--			cnt <= 0;
----			tp <= sfx_null;
----		if rising_edge(clk)  then
--		elsif rising_edge(lg)  then
--				cnt <= cnt + 1;
----				c:= phase_mask(cnt);
----				if cnt < 3 then
-----					if c = '0' then
----						tp <= sfx_null;
----					else 
--						tp <= sfx_pi;
----					end if;
----				else
----					cnt := 0;
----				   tp <= sfx_null;
----			 end if;
--		end if;
--	end process;			
	lg_counter : process (lg, ti,phase_mask, cnt) is
	--	variable cnt : count_int := 0;
	   variable c : integer range 0 to 3 := 0;
		--variable c : std_logic_vector (2 downto 0):= (others => '0');
	begin
	--if pft(2 downto 0) = "001" or "111" then
		if ti = '1' then
			cnt <= 0;
--			tp <= sfx_null;
--		if rising_edge(clk)  then
		elsif rising_edge(lg)  then
		--		cnt <= cnt + 1;
				c:= phase_mask(cnt);
				cnt <= cnt + 1;
--				if cnt < 3 then
					if c = 0 then
						tp <= sfx_null;
					elsif c = 1 then 
						tp <= sfx_null;
						--tp <= sfx_pi_2;
					elsif c = 2 then 
						tp <= sfx_null;
						--tp <= sfx_pi;
					elsif c = 3 then 
						tp <= sfx_null;
					end if;
--					cnt <= cnt + 1;
--				else
--					cnt := 0;
--				   tp <= sfx_null;
--			 end if;
		end if;
	end process;
	
	
	
	lfm_instance : entity lfm_generator.lfm_generator
		generic map(
			width => width,
			int => int,
			fract => fract
		)
		port map( 
			clk => clk,
			ce => ce, 
			enable => en,
			fix => lg,
			ampl => ampl,
			fdev => fdev,
			fdop => fdop,
			f0 => f0,
			fd => fd,
			tp => tp,
			N => N,
			sign_lchm => sign_lchm,
			out_data_cos => out_data_cos,
			out_data_sin => out_data_sin,
			strob => strob,
			--
			debug_out_0 => debug_out_0,
			debug_out_1 => debug_out_1,
			debug_out_2 => debug_out_2
		);

end Behavioral;

