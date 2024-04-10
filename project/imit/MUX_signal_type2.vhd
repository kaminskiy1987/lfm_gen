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
	--Use ieee.std_logic_arith.all;
	Use ieee.std_logic_unsigned.all;
   use ieee.math_real.all;
	--USE ieee.math_real.sin;
	--USE ieee.math_real.cos;
	--USE ieee.math_real.math_pi;
	--USE std.textio.ALL;
	--USE IEEE.std_logic_textio.ALL;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	
library ieee_proposed;
   	use ieee_proposed.fixed_float_types.all;
    use ieee_proposed.fixed_pkg.all;
    
    library sincos;
	use sincos.all; 

entity MUX_signal_type2 is
generic(
	   --pts_code : int_array := (6, 22, 0, 56);
		--pts_code : int_array := (50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800);
		pts_code : int_array := (0, 140, 652, 180, 692, 156, 668, 164, 676, 132, 644);
		data_ppz : integer := 5;
		dopler: real := 0.011;
		data_pft: integer := 6;
		data_rom : integer := 14
	); 
	Port(
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		En : in std_logic;
		En2 : in std_logic;
		--pt : in std_logic;
		OD : in std_logic;		
	  LG : in std_logic;		
	  TI : in std_logic;
		fdop	  : in std_logic_vector (3 downto 0);
		fdop2	  : in std_logic_vector (3 downto 0);
		fdev	: in std_logic_vector (2 downto 0);
      ppz_new : in std_logic_vector (6 downto 0);
    --dpp2 : in integer;		
		ppz_m : in std_logic_vector (4 downto 0);
		PFT : in std_logic_vector (data_pft - 1 downto 0);
		pipp : in std_logic;
		pipp2 : in std_logic;
		--P2 : in std_logic_vector (1 downto 0);

		--NT_PPZ : in std_logic_vector (data_ppz downto 1);----------?
		Sign_LCHM : in std_logic;

		Rom_sin : out std_logic_vector (data_rom-1 downto 0);
		Rom_sin2 : out std_logic_vector (data_rom-1 downto 0)
		);
		
end MUX_signal_type2;

architecture Behavioral of MUX_signal_type2 is

   constant int : integer := 16;
	constant fract : integer := -20;
	
	constant angle_int : integer := 20;
	constant angle_fract : integer := -20;
	
	--constant intermed_int : integer := 30;
	constant intermed_int : integer := 30;
	constant intermed_fract : integer := -20;

	
	constant sfx_2_pi 			: sfixed(int - 1 downto fract) := to_sfixed(math_2_pi, int - 1, fract);	
	constant sfx_pi 				: sfixed(int - 1 downto fract) := to_sfixed(ieee.math_real.math_pi, int - 1, fract);	

	
	signal cnt : natural := 0;
	signal cnt_r : natural := 0;
	signal cnt2 : natural := 0;
	signal cnt2_r : natural := 0;
	signal angle, angle2 : sfixed(angle_int - 1 downto angle_fract) := to_sfixed(0.0, angle_int - 1, angle_fract);
	
	signal inn_strob, inn_strob2 : std_logic := '0';
	signal inn_strob_r,  inn_strob_r2 : std_logic := '0';	
	
	--constant strob_delay : natural := 14;
	constant strob_delay : natural := 4;
	--constant strob_delay : natural := 5;
	
	signal a : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	signal b : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	signal c, c2 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	signal p : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	signal d, d2 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	signal d_pow_2 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	
	signal m1 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	signal m2 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	signal m3, m32 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	
	signal m1_r : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	signal m2_r : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	
	signal m3_r, m3_r2 : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);	

  signal cos1, angle_slv :  std_logic_vector (13 downto 0) := (others => '0');
  signal sin1 :  std_logic_vector (13 downto 0) := (others => '0');
  signal phase_out :  std_logic_vector (13 downto 0) := (others => '0');
  signal phase_in :  std_logic_vector (13 downto 0) := (others => '0');
  signal rdy : STD_LOGIC:= '0';

	subtype count_int is natural range 0 to 7;
	--signal cnt : count_int := 0;
--	signal cnt : integer range 0 to 7 := 0;
	signal phase : integer := 0;
	--constant N : sfixed(int - 1 downto fract) := to_sfixed(961.0, int - 1, fract);
	constant N2 : integer := 1922;
	constant N : integer := 2883;
	constant N_const : integer := 961;

    constant sfx_pi_c : sfixed(int - 1 downto fract) := to_sfixed(1.0, int - 1, fract);
    constant sfx_pi_s : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);

	signal  sfx_null : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	
	signal eleven_k_herz : sfixed(int - 1 downto fract) := to_sfixed(dopler, int - 1, fract); -- 11E3
	
	signal t, t2, t3, k2, k3, k4 : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal k1: sfixed(angle_int - 1 downto angle_fract) := to_sfixed(0.0, angle_int - 1, angle_fract);
	---signal t, t2 : real := 0.0;
	constant f0 : sfixed(int - 1 downto fract) := to_sfixed(23.978, int - 1, fract);
	--constant fd : sfixed(int - 1 downto fract) := to_sfixed(96.0, int - 1, fract);
	constant fd : sfixed(int - 1 downto fract) := to_sfixed(95.912, int - 1, fract);
	--constant ampl : integer := 8191;
	constant al : real := 1441.0;
	constant ampl : integer := 1;
	signal pft_dev  : std_logic_vector (6 downto 0) := (others => '0');
	
	signal strob, strob2 : std_logic := '0';
	Signal UPP1_cos_sfixed, UPP2_cos_sfixed, UPP, UPP1_cos_sfixed2, UPP2_cos_sfixed2, UPP2: sfixed(angle_int - 1 downto angle_fract) := (others => '0');
	Signal UPP1_cos, UPP2_cos, UPP3_cos, UPP4_cos, PP_sin, PP_cos, PP_sin2, PP_cos2,
	 UPP1_cos2, UPP2_cos2, PP_cos_strob, PP_sin_strob, PP2_cos_strob, PP2_sin_strob  :  std_logic_vector (data_rom-1 downto 0):=(others => '0');
	
	Signal out_data_cos, out_data_sin, out_data_cos2, out_data_sin2: sfixed(angle_int - 1 downto angle_fract) := (others => '0');
	Signal ret :  std_logic_vector ( 13 downto 0):=(others => '0');
	Signal second :  std_logic_vector ( 15 downto 0):=(others => '0');
	
	signal tp : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	
	signal fdop_r, fdop_r2 : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdop_n1 : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	signal fdop_n2 : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	 signal fdop11, fdop22 : sfixed(int - 1 downto fract) := to_sfixed(0.0, int - 1, fract);
	 
	 signal dop1 : sfixed(int - 1 downto fract) := to_sfixed(11000.0, int - 1, fract);
	 
	 signal index1 :  integer:= 0;
	 
	 signal pft1 :  std_logic_vector (data_pft-1 downto 0):= (others => '0');
	signal en_t1, en_t2 : std_logic := '0';
	signal ppz :  std_logic_vector (2 downto 0) := (others => '0');
	signal pt_pft_dev, pt_pft_dev_r  : std_logic_vector (9 downto 0) := (others => '0');
	
	constant c12 :  std_logic_vector (2 downto 0) := ('0', '1', '0');
	--constant c3 :  std_logic_vector (2 downto 0) := ('0', '0', '1');
	constant c3 :  std_logic_vector (2 downto 0) := ('1', '0', '0');
--	constant a :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
	signal phase_mask :  std_logic_vector (2 downto 0) := ('0', '0', '0');
	
	type t_45 is record
	 --  t : sfixed(int - 1 downto fract);
		t1 : sfixed(int - 1 downto fract);
		t2 : sfixed(int - 1 downto fract);
		t3: sfixed(int - 1 downto fract);
	--	t4: sfixed(int - 1 downto fract);
	end record;
	
	type tt_tp45 is array (natural range <>) of t_45;

	
	constant tp45 : tt_tp45 := (
	
--------------------------------------------------------------------------------------------------------------

   (to_sfixed(0.0, int-1, fract), to_sfixed(0.0, int-1, fract), to_sfixed(0.0, int-1, fract)), -- for ampl signal
	
   (to_sfixed(0.0, int-1, fract), to_sfixed(796.06, int-1, fract),to_sfixed(1692.21, int-1, fract)),--SL7(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(800.23, int-1, fract),to_sfixed(1634.49, int-1, fract)),--SL7(34); T2; 
	
	(to_sfixed(0.0, int-1, fract), to_sfixed(967.22, int-1, fract),to_sfixed(2034.53, int-1, fract)),--SL10(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(967.22, int-1, fract),to_sfixed(1968.47, int-1, fract)),--SL10(1); T2;
	
	(to_sfixed(0.0, int-1, fract), to_sfixed(1142.88, int-1, fract),to_sfixed(2385.85, int-1, fract)),--SL12(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(1143.38, int-1, fract),to_sfixed(2320.79, int-1, fract)),--SL12(34); T2; 
	
	(to_sfixed(0.0, int-1, fract), to_sfixed(1325.21, int-1, fract),to_sfixed(2750.52, int-1, fract)),--SL15(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(1321.88, int-1, fract),to_sfixed(2677.79, int-1, fract)),--SL15(34); T2; 
	
	(to_sfixed(0.0, int-1, fract), to_sfixed(1495.87, int-1, fract),to_sfixed(3091.83, int-1, fract)),--SL17(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(1502.54, int-1, fract),to_sfixed(3039.12, int-1, fract)),--SL17(34); T2; 
	
	(to_sfixed(0.0, int-1, fract), to_sfixed(1672.03, int-1, fract),to_sfixed(3444.15, int-1, fract)),--SL20(100); T1; 
	(to_sfixed(0.0, int-1, fract), to_sfixed(1672.03, int-1, fract),to_sfixed(3378.09, int-1, fract))--SL20(34); T2;
	
	);
------------------------------------------------------------------------------------------------------------------------	
	function calc_dop(fdop	: sfixed) return sfixed is
	begin
		return resize(50.0*fdop/1000000.0, int - 1, fract);
	end function;
	
	function calc_out(UPP1, UPP2 : sfixed) return sfixed is
	begin
		return resize(UPP1 + UPP2, angle_int - 1, angle_fract);
	end function;
	
	-- math_2_pi*fdop*tp
	function calc_T(fdop : sfixed; tp : sfixed) return sfixed is
	--variable res : sfixed(int - 1 downto fract);
	begin
		--return resize(sfx_2_pi * fdop * tp , int - 1, fract);
		return resize(2.0 * ieee.math_real.math_pi * tp * fdop, int - 1, fract);
		--return res;		
	end function;
	
	-- math_2_pi*fdop/fd
	function calc_C(fdop, fd : sfixed) return sfixed is
	begin
		return resize(sfx_2_pi*fdop/fd, intermed_int - 1, intermed_fract);
	end function;
	
	-- n_sfx/2.0
	function calc_P(N : integer) return sfixed is
		variable n_sfx : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	begin
		n_sfx := to_sfixed(N, n_sfx'high, n_sfx'low);
		return resize(n_sfx/2.0, intermed_int - 1, intermed_fract);
	end function;
	
	-- (ii_sfx - P)
	function calc_D(ii : integer; P : sfixed) return sfixed is
		variable ii_sfx : sfixed(intermed_int - 1 downto intermed_fract) := to_sfixed(0.0, intermed_int - 1, intermed_fract);
	begin
		ii_sfx := to_sfixed(ii, ii_sfx'high, ii_sfx'low);
		return resize(ii_sfx - P, intermed_int - 1, intermed_fract);
	end function;	
	
--	signal cos :  std_logic_vector (13 downto 0) := (others => '0');
--	signal phase :  std_logic_vector (27 downto 0) := (others => '0');
	signal cnt_slv : std_logic_vector (47 downto 0):= (others => '0');
	 
  --signal cos :  std_logic_vector (13 downto 0) := (others => '0');
  signal cos, cos2 :  sfixed(angle_int - 1 downto angle_fract) := to_sfixed(0.0, angle_int - 1, angle_fract);
  signal sin, sin2 :  sfixed(angle_int - 1 downto angle_fract) := to_sfixed(0.0, angle_int - 1, angle_fract);
  
begin
------------------------------noise------------------------------------------------
MUX_signal_type_PP: entity work.MUX_signal_type_MP2
		generic map( 
					data_ppz => data_ppz,
					data_pft => data_pft,
					--phasa => phasa,
			      --dopler => dopler,
					data_rom => data_rom
					)

		port map ( 
					Clk_96 => Clk_96,
					Ce_F6 => '1',
					OD => OD ,
					LG => lg , 
					TI => TI,
					PFT => PFT,
					--fdev => fdev,
					--dpp1 => dpp1,
					--dpp2 => dpp2,
					--fdop => fdop,--in
					PIPP => pipp,
					PIPP2 => pipp2,
					--pt => pt,
					ppz_m => ppz_m, --in
					Sign_LCHM => Sign_LCHM, --in
					--Sign_LCHM => Sign_LCHM,
					EN  => EN,
					EN2 => EN2,--in
					Rom_sin1 => PP_sin,
					Rom_cos1 => PP_cos,--out
					Rom_sin2 => PP_sin2,
					Rom_cos2 => PP_cos2			
		);
	-------------------------------------------Fdop--------------------------
 fdop11 <= to_sfixed(to_integer(unsigned(fdop)), int - 1, fract);
 fdop22 <= to_sfixed(to_integer(unsigned(fdop2)), int - 1, fract);
 
  recDop_process : process (ti, fdop11) is
	begin
		if falling_edge(ti) then
			fdop_r <= calc_dop(fdop11);
			fdop_r2 <= calc_dop(fdop22);
		end if;
	end process;
	
	
	process (Clk_96, pipp, fdop_r, ppz_new) is
    begin
		if rising_edge(Clk_96) then
			if ppz_new(1 downto 0) = "01"  or  ppz_new(1 downto 0) = "10"  then
			--if pft(4) = '1'  then
				if pipp  = '1' then
					fdop_n1 <= fdop_r;
					fdop_n2 <= fdop_r2;
				else
					fdop_n1 <= sfx_null;
					fdop_n2 <= sfx_null;
				end if;
			else 
					fdop_n1 <= sfx_null;
					fdop_n2 <= sfx_null;
			end if;
		end if;
	end process;	
--------------------------------------Tper------------------------------------------------	
	
	 pft_dev <= pft & fdev;
	  
 process (ti, ppz_new ) is
    begin
		if falling_edge(ti) then
			if ppz_new(1 downto 0) = "01"  then 
				en_t1 <= '1';
				en_t2 <= '0';
			elsif  ppz_new(1 downto 0) = "10"  then 
				en_t1 <= '0';
				en_t2 <= '1';
			else
				en_t1 <= '0';
				en_t2 <= '0';
			end if;
		end if;
	end process;	

	process (Clk_96, ti) is
    begin
    if ti = '1' then
		index1 <= 0;
	 elsif rising_edge(Clk_96) then
		    if pft_dev = "0010011" and en_t1 = '1' then --SL7 - T1
				index1 <= 1;
			 elsif pft_dev = "0010011" and en_t2 = '1' then --SL7 - T2
			   index1 <= 2;
				--------------------------------------------
			 elsif pft_dev = "0011011" and en_t1 = '1' then --SL10 - T1
			   index1 <= 3;
			 elsif pft_dev = "0011011" and en_t2 = '1' then --SL10 - T2
			   index1 <= 4;
				----------------------------------------
			 elsif pft_dev = "0100011" and en_t1 = '1' then --SL12 - T1
			   index1 <= 5;
			 elsif pft_dev = "0100011" and en_t2 = '1' then --SL12 - T2
			   index1 <= 6;
				----------------------------------------------
			 elsif pft_dev = "0101011" and en_t1 = '1' then --SL15 - T1
			   index1 <= 7;
			 elsif pft_dev = "0101011" and en_t2 = '1' then --SL15 - T2
			   index1 <= 8;
				------------------------------------------------
			 elsif pft_dev = "0110011" and en_t1 = '1' then --SL17 - T1
			   index1 <= 9;
			 elsif pft_dev = "0110011" and en_t2 = '1' then --SL17 - T2
			   index1 <= 10;
				------------------------------------------------------
			elsif pft_dev = "0111011" and en_t1 = '1' then --SL20 - T1
			   index1 <= 11;
			 elsif pft_dev = "0111011" and en_t2 = '1' then --SL20 - T2
			   index1 <= 12;
			 else
			   index1 <= 0;
			 end if;
	 end if;
	end process;	
	

	
	lg_counter : process (lg, ti) is
		variable count : count_int := 0;
		variable c : integer range 0 to 3 := 0;
	--	variable c : std_logic := '0';
	begin
	  
		      if ti = '1' then
			       count := 0;
		      elsif rising_edge(lg)  then
		            if pipp = '1' or pipp2 = '1' then
							     if  count = 0 then  
								    tp <= sfx_null;
							     elsif count = 1 then   
									 tp <= tp45(index1).t2;
							     elsif count = 2 then   
									 tp <= tp45(index1).t3;
							     else
								    tp <= sfx_null;
							     end if;
		          else  
						  tp <= sfx_null;
		          end if;
							count := count + 1; 
		        end if;
end process;
	
		T_process : process (Clk_96, fdop_n1, tp, lg) is
--T_process : process (fdop_n1, tp, lg) is
	begin
		if falling_edge(lg) then
			t <= calc_T(fdop_n1, tp);
			t2 <= calc_T(fdop_n2, tp);
		end if;
	end process;
	
	-----------------------------------------------------offset Fdop-----------------
--	C_process : process (fdop_n1, LG) is
--	begin
--		if rising_edge(LG) then
--			c <= calc_C(fdop_n1, fd);
--		end if;
--	end process;
--	
--	C_process2 : process (fdop_n2, LG) is
--	begin
--		if rising_edge(LG) then
--			c2 <= calc_C(fdop_n2, fd);
--		end if;
--	end process;
--	
--	P_process : process (LG) is
--	begin
--		if rising_edge(LG) then
--			p <= calc_P(N_const);
--		end if;
--	end process;	
--	
--	
	gen_p : process (Clk_96, En) is		
--		variable d : sfixed(angle'range) := to_sfixed(0.0, angle'high, angle'low);
	begin
		if En = '0' then
			cnt <= 0;
			inn_strob <= '0';
		elsif rising_edge(Clk_96) then
			if (cnt < N_const) then
			  inn_strob <= '1';				
			  cnt <= cnt + 1;
			else
			  if (N > N_const) then
			    cnt <= 0;
				  if (cnt < N_const) then
			       inn_strob <= '1';			
			       cnt <= cnt + 1;
				  else
				     inn_strob <= '0';
				  end if;
				--  cnt <= cnt + 1;
			  end if;
			inn_strob <= '0';
		--	cnt <= cnt + 1;
		end if;
	end if;
	end process;
	
	gen_p2 : process (Clk_96, En2) is		
--		variable d : sfixed(angle'range) := to_sfixed(0.0, angle'high, angle'low);
	begin
		if En2 = '0' then
			cnt2 <= 0;
			inn_strob2 <= '0';
		elsif rising_edge(Clk_96) then
			if (cnt2 < N_const) then
			  inn_strob2 <= '1';				
			  cnt2 <= cnt2 + 1;
			else
			  if (N2 > N_const) then
			    cnt2 <= 0;
				  if (cnt2 < N_const) then
			       inn_strob2 <= '1';			
			       cnt2 <= cnt2 + 1;
				  else
				     inn_strob2 <= '0';
				  end if;
				--  cnt <= cnt + 1;
			  end if;
			inn_strob2 <= '0';
		--	cnt <= cnt + 1;
		end if;
	end if;
	end process;
--	
--	cnt_r <= cnt when rising_edge(Clk_96);
--	d <= calc_D(cnt_r, p) when rising_edge(Clk_96);
--	
--	cnt2_r <= cnt2 when rising_edge(Clk_96);
--	d2 <= calc_D(cnt2_r, p) when rising_edge(Clk_96);
--
--   m3_p : process (Clk_96, c, d) is
--	begin
--		if rising_edge(Clk_96) then
--			m3 <= resize(c*d, intermed_int  - 1, intermed_fract);
--		end if;
--	end process;
--
--    m3_r <= m3 when rising_edge(Clk_96);

   gen_p_1 : process (Clk_96) is
	begin
		if rising_edge(Clk_96) then
			angle <= resize(t, angle_int - 1, angle_fract);
		end if;
	end process;	 
	
-------------------------------------------------------------------	
--	 m3_p2 : process (Clk_96, c2, d2) is
--	begin
--		if rising_edge(Clk_96) then
--			m32 <= resize(c2*d2, intermed_int  - 1, intermed_fract);
--		end if;
--	end process;
--
--    m3_r2 <= m32 when rising_edge(Clk_96);

   gen_p_12 : process (Clk_96, t2, m1_r, m2, m3_r2) is
	begin
		if rising_edge(Clk_96) then
			angle2 <= resize(t2, angle_int - 1, angle_fract);
		end if;
	end process;	 	
-----------------------------------------------------sincos-------------------
--sincos_inst : entity sincos.sincos
sincos_inst : entity sincos.ram_sincos
		generic map(
			int => angle_int,
			fract => angle_fract,
			out_width => data_rom
	   )
	   port map(
			clk => Clk_96,
			ce => Ce_F6, 
			angle => angle,
			ampl => ampl,
			sin => sin,
			cos => cos
		
	   );
	   
	   sincos_inst2 : entity sincos.ram_sincos
		generic map(
			int => angle_int,
			fract => angle_fract,
			out_width => data_rom
	   )
	   port map(
			clk => Clk_96,
			ce => Ce_F6, 
			angle => angle2,
			ampl => ampl,
			sin => sin2,
			cos => cos2
			--
	   );
	------------------------------------------------------------------   
	strob <= inn_strob when rising_edge(Clk_96);
	strob2 <= inn_strob2 when rising_edge(Clk_96);		
	
--	inn_strob_r <= strob when rising_edge(Clk_96);
	strob_delay_p : process (Clk_96, inn_strob) is
		variable cnt : natural := 0;
		variable storage : std_logic_vector(strob_delay - 1 downto 0) := (others => '0');
	begin
		if rising_edge(Clk_96) then
			if cnt = strob_delay then
				cnt := 0;				
			end if;
			inn_strob_r <= storage(cnt);
			storage(cnt) := inn_strob;
			
			cnt := cnt + 1;
		end if;
	end process;
	
	strob_delay_p2 : process (Clk_96, inn_strob2) is
		variable cnt : natural := 0;
		variable storage : std_logic_vector(strob_delay - 1 downto 0) := (others => '0');
	begin
		if rising_edge(Clk_96) then
			if cnt = strob_delay then
				cnt := 0;				
			end if;
			inn_strob_r2 <= storage(cnt);
			storage(cnt) := inn_strob2;
			
			cnt := cnt + 1;
		end if;
	end process;
	
	out_data_cos <= cos and inn_strob_r;
	out_data_sin <= sin and inn_strob_r;
	PP_cos_strob <= PP_cos and inn_strob_r;
	PP_sin_strob <= PP_sin and inn_strob_r;
	
	out_data_cos2 <= cos2 and inn_strob_r2;
	out_data_sin2 <= sin2 and inn_strob_r2;
	PP2_cos_strob <= PP_cos2 and inn_strob_r2;
	PP2_sin_strob <= PP_sin2 and inn_strob_r2;
----------------------------------------------------------cosx*cosy and sinx*siny------------------		
--	k1 <= to_sfixed(1.0, angle_int - 1, angle_fract);
	
	MULT_UPP1: entity elementary.sfixed_mult
		generic map( 
			int => angle_int,
			fract=> angle_fract,
			data_width=> data_rom
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => out_data_cos,
        -- K_mult => k1,			
			D_mult => PP_cos_strob, --in
			--D_mult => PP_cos, --in
			--D_mult =>  PP_ram, --in
			Q_mult => UPP1_cos,
			Q_mult_sfixed => UPP1_cos_sfixed			--out
		);
		
		
		MULT_UPP2: entity elementary.sfixed_mult
		generic map( 
			int => angle_int,
			fract=>angle_fract,
			data_width=> data_rom
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => out_data_sin,
			D_mult => PP_sin_strob, --in
			--D_mult => PP_cos, --in
			--D_mult =>  PP_ram, --in
			Q_mult => UPP2_cos,
			Q_mult_sfixed => UPP2_cos_sfixed			--out
		);
		
		
		MULT_UPP3: entity elementary.sfixed_mult
		generic map( 
			int => angle_int,
			fract=>angle_fract,
			data_width=> data_rom
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => out_data_cos2,
			D_mult => PP2_cos_strob, --in
			--D_mult => PP_cos, --in
			--D_mult =>  PP_ram, --in
			Q_mult => UPP3_cos,
			Q_mult_sfixed => UPP1_cos_sfixed2			--out
		);
		
		
		MULT_UPP4: entity elementary.sfixed_mult
		generic map( 
			int => angle_int,
			fract=> angle_fract,
			data_width=> data_rom
		)
		port map (
			R => '0',
			Clk => Clk_96,
--			Ce_F6 => '1',
			K_mult => out_data_cos2,
			D_mult => PP2_sin_strob, --in
			--D_mult => PP_cos, --in
			--D_mult =>  PP_ram, --in
			Q_mult => UPP4_cos,
			Q_mult_sfixed => UPP2_cos_sfixed2			--out
		);
------------------------------------------------cosx*cosy - sinx*siny--------------	
	process (Clk_96) is
	begin
	--	if falling_edge(lg) then
			if rising_edge(Clk_96) then
				UPP <= calc_out(UPP1_cos_sfixed, UPP2_cos_sfixed);
				UPP2 <= calc_out(UPP1_cos_sfixed2, UPP2_cos_sfixed2);
			end if;
	--	end if;
	end process;
------------------------------------------------------Out---------------------------	
	process (Clk_96) is
	begin
			if rising_edge(Clk_96) then
			  
				Rom_sin2 <= std_logic_vector( to_signed(UPP2, data_rom));
				Rom_sin <= std_logic_vector(to_signed(UPP, data_rom));
			--	Rom_sin <= UPP1_cos;
			end if;
	end process;
	
end Behavioral;

