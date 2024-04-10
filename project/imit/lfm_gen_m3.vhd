----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:11 10/22/2019 
-- Design Name: 
-- Module Name:    lfm_gen_m3 - Behavioral 
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
	 
library sincos;
	use sincos.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lfm_gen_m3 is
generic(
		width : integer := 14;
		int : integer := 8;
		fract : integer := -10
	);
	port ( 
		clk : in std_logic;
		ce : in std_logic;
		enable : in std_logic;
		fix : in std_logic; -- save a input parameters
		-- parameters
		ampl : in integer;
		fdev : in sfixed(int - 1 downto fract);
		fdop : in sfixed(int - 1 downto fract);
		f0 : in sfixed(int - 1 downto fract);
		fd : in sfixed(int - 1 downto fract);
		tp : in sfixed(int - 1 downto fract);
		N : in integer;
		sign_lchm : in std_logic;
		out_data_cos : out std_logic_vector(width - 1 downto 0);
		--out_data_sin : out std_logic_vector(width - 1 downto 0);
		strob : out std_logic := '0';
		-- debug
		debug_out_0 : out sfixed(19 downto -20);
		debug_out_1 : out sfixed(19 downto -20);
		debug_out_2 : out sfixed(19 downto -20)
	);
end lfm_gen_m3;

architecture Behavioral of lfm_gen_m3 is
constant int : integer := 8;
	constant fract : integer := -10;
--	constant width : integer := 14;

	subtype count_int is natural range 0 to 7;
	--signal cnt : count_int := 0;
	signal cnt : integer range 0 to 7 := 0;
--	subtype count_int is natural range 0 to 2;
	--constant sfx_pi : sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi, int - 1, fract);
--	constant sfx_pi : sfixed(int - 1 downto fract) := to_sfixed(phasa, int - 1, fract);
--	constant sfx_null : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal  sfx_pi : sfixed(int - 1 downto fract) := to_sfixed(phasa, int - 1, fract);
	signal  sfx_null : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	--constant eleven_k_herz : sfixed(int - 1 downto fract) := to_sfixed(0.011, int - 1, fract); -- 11E3
	signal eleven_k_herz : sfixed(int - 1 downto fract) := to_sfixed(dopler, int - 1, fract); -- 11E3
	
	constant f0 : sfixed(int - 1 downto fract) := to_sfixed(24.0, int - 1, fract);
	constant fd : sfixed(int - 1 downto fract) := to_sfixed(96.0, int - 1, fract);
	constant ampl : integer := 8191;
	
--	signal strob : std_logic := '0';
	
	signal N : integer := 0;
	signal tp : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdev : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdop : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	
	signal ppz :  std_logic_vector (2 downto 0) := (others => '0');
	
	constant c12 :  std_logic_vector (2 downto 0) := ('0', '1', '0');
	--constant c3 :  std_logic_vector (2 downto 0) := ('0', '0', '1');
	constant c3 :  std_logic_vector (2 downto 0) := ('1', '0', '0');
	constant a :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
	signal phase_mask :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
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
		(2079, to_sfixed(3.0, int-1, fract), sfx_null),--L1-3
	--	(4159, to_sfixed(3, int-1, fract), sfx_null),--L2-3
		(4159, to_sfixed(1.5, int-1, fract), sfx_null),--L2-1.5
	--	(8319, to_sfixed(3, int-1, fract), sfx_null),--L3-3
		(8319, to_sfixed(0.75, int-1, fract), sfx_null),--L3-0.75
		(2079, to_sfixed(3.0, int-1, fract), eleven_k_herz),--L1C
		(4159, to_sfixed(1.5, int-1, fract), eleven_k_herz)
		--(11000, to_sfixed(0.75, int-1, fract), sfx_null)--L2C
	);
	--attribute keep : string;
	--attribute keep of tp : signal is "true";
	--attribute keep of cnt : signal is "true";
	--attribute keep of  ppz : signal is "true";
	--attribute keep of phase_mask : signal is "true";


begin

--  -- fix
--	A_process : process (f0, fd, fix) is
--	begin
--		if rising_edge(fix) then
--			a <= calc_A(f0, fd);
--		end if;
--	end process;
--	
--	B_process : process (fd, fdev, N, fix,sign_lchm) is
--	begin
--		if rising_edge(fix) then
--			b <= calc_B(fdev, fd, N,sign_lchm);
--		end if;
--	end process;
	
	C_process : process (fdop, fd, fix) is
	begin
		if rising_edge(fix) then
			c <= calc_C(fdop, fd);
		end if;
	end process;
	
	P_process : process (N, fix) is
	begin
		if rising_edge(fix) then
			p <= calc_P(N);
		end if;
	end process;	
	
	-- clk

	gen_p : process (clk, ce, enable, ampl, fdev, fdop, f0, tp, N) is		
--		variable d : sfixed(angle'range) := to_sfixed(0.0, angle'high, angle'low);
	begin
		if enable = '0' then
			cnt <= 0;
		elsif rising_edge_ce(clk, ce) then
			if (cnt < N) then				
--				angle <= resize(a*d + b*d*d + c*d + tp, angle_int - 1, angle_fract);
--				d <= calc_D(cnt, p);
--				d_pow_2 <= 
				inn_strob <= '1';
--				cnt <= cnt + 1;
			else
				inn_strob <= '0';
			end if;
			cnt <= cnt + 1;
		end if;
	end process;
	
	cnt_r <= cnt when rising_edge_ce(clk, ce);
	d <= calc_D(cnt_r, p) when rising_edge_ce(clk, ce);
	--d_pow_2 <= resize(d*d, intermed_int  - 1, intermed_fract) when rising_edge_ce(clk, ce);
	
--	m1_p : process (clk, a, d, ce) is
--	begin
--		if rising_edge_ce(clk, ce) then
--			m1 <= resize(a*d, intermed_int  - 1, intermed_fract);
--		end if;
--	end process;
--	
--	m2_p : process (clk, b, d, ce) is
--	begin
--		if rising_edge_ce(clk, ce) then
--			m2 <= resize(b*d_pow_2, intermed_int  - 1, intermed_fract);
--		end if;
--	end process;
	
	m3_p : process (clk, c, d, ce) is
	begin
		if rising_edge_ce(clk, ce) then
			m3 <= resize(c*d, intermed_int  - 1, intermed_fract);
		end if;
	end process;
	
	--m1_r <= m1 when rising_edge_ce(clk, ce);
	--m3_r <= m3 when rising_edge_ce(clk, ce);
	m2_r <= m2 when rising_edge_ce(clk, ce);
	
	gen_p_1 : process (clk, ce, tp, m1_r, m2, m3_r) is
	begin
		if rising_edge_ce(clk, ce) then
--			angle <= resize(a*d + b*d*d + c*d + tp, angle_int - 1, angle_fract);
--			angle <= resize(m1_r + m2_r + m3_r + tp, angle_int - 1, angle_fract);
			angle <= resize( m3_r + tp, angle_int - 1, angle_fract);
		end if;
	end process;
	
	sincos_inst : entity sincos.sincos
		generic map(
			int => angle_int,
			fract => angle_fract,
			out_width => width
	   )
	   port map(
			clk => clk,
			ce => ce, 
			angle => angle,
			ampl => ampl,
			sin => sin,
			cos => cos,
			--
			debug_out_0 => debug_out_0,
			debug_out_1 => debug_out_1,
			debug_out_2 => debug_out_2
	   );

	strob <= inn_strob when rising_edge_ce(clk, ce);		
	
	strob_delay_p : process (clk, ce, inn_strob) is
		variable cnt : natural := 0;
		variable storage : std_logic_vector(strob_delay - 1 downto 0) := (others => '0');
	begin
		if rising_edge_ce(clk, ce) then
			if cnt = strob_delay then
				cnt := 0;				
			end if;
			inn_strob_r <= storage(cnt);
			storage(cnt) := inn_strob;
			
			cnt := cnt + 1;
		end if;
	end process;
	
--	inn_strob_r <= inn_strob when rising_edge_ce(clk, ce);		
	out_data_cos <= cos and inn_strob_r;
	--out_data_sin <= sin and inn_strob_r;
end Behavioral;

