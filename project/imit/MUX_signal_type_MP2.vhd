

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;


entity MUX_signal_type_MP2 is

	generic (
	
	  data_pft: integer := 6;
		data_ppz : integer := 5;
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
		--fdop	  : in std_logic_vector (3 downto 0);
		--fdev	: in std_logic_vector (2 downto 0);
    --  dpp1 : in integer;
    --  dpp2 : in integer;		
		ppz_m : in std_logic_vector (4 downto 0);
		PFT : in std_logic_vector (data_pft - 1 downto 0);
		pipp : in std_logic;
		pipp2 : in std_logic;
		--P2 : in std_logic_vector (1 downto 0);

		--NT_PPZ : in std_logic_vector (data_ppz downto 1);----------?
		Sign_LCHM : in std_logic;

		Rom_cos1 : out std_logic_vector (data_rom-1 downto 0);
		Rom_sin1 : out std_logic_vector (data_rom-1 downto 0);
		Rom_cos2 : out std_logic_vector (data_rom-1 downto 0);
		Rom_sin2 : out std_logic_vector (data_rom-1 downto 0)
	);

end MUX_signal_type_MP2;

architecture Behavioral of MUX_signal_type_MP2 is

--Signal P1_P2_PFT : std_logic_vector(5 downto 1):=(others => '0');
	signal P2_PFT : std_logic_vector(data_pft downto 1):=(others => '0');
	
	signal Rom_cos_L7C3_i : integer;
	signal Rom_cos_L7C4_i : integer;
	signal Rom_cos_L11C3_i : integer;
	signal Rom_cos_L11C4_i : integer;
	signal Rom_cos_L15C3_i : integer;
   signal Rom_cos_L15C4_i : integer;
   signal Rom_cos_L19C3_i : integer;
	signal Rom_cos_L23C3_i : integer;
   signal Rom_cos_L23C4_i : integer;
	signal Rom_cos_L11_i : integer;
	signal Rom_cos_L15_i : integer;
	signal Rom_cos_L23_i : integer;
	signal Rom_cos_L30_i : integer;
	signal Rom_cos_L3_plus : integer;
	signal Rom_cos_L3_minus : integer;
	signal Rom_cos_L60_i : integer;
	signal Rom_sin_L60_i : integer;
	
	signal Rom_cos_L60_i2 : integer;
	signal Rom_sin_L60_i2 : integer;

  signal Rom_cos_out : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_out : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  
  signal Rom_cos_rg : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_rg : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_cos_rg2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
  signal Rom_sin_rg2 : std_logic_vector (data_rom-1 downto 0):=(others => '0');
--Signal Rom_sin_i : integer range -64 to 64;
--Signal Rom_cos_i : integer range -64 to 64;
	signal Rom_cos_i : integer;
	signal Rom_sin_i : integer;
	signal Rom_cos_i2 : integer;
	signal Rom_sin_i2 : integer;

begin



--------------------------------  L_cos ������ '+'
LHM_PP_L60_cos: entity work.LHM_ALL
generic map(

		rom_cos =>		
(
6,
7,
-4,
-6,
4,
6,
-1,
-5,
1,
6,
1,
-4,
-1,
5,
3,
-4,
-3,
4,
5,
-3,
-5,
4,
7,
-2,
-7,
3,
9,
-2,
-9,
2,
11,
-1,
-11,
2,
13,
-1,
-13,
1,
14,
0,
-14,
1,
15,
0,
-15,
0,
16,
1,
-15,
0,
17,
1,
-16,
0,
16,
1,
-15,
0,
16,
1,
-14,
0,
15,
1,
-13,
0,
14,
1,
-12,
0,
12,
1,
-11,
1,
11,
0,
-9,
1,
9,
0,
-7,
2,
7,
-1,
-5,
3,
6,
-2,
-4,
4,
4,
-3,
-2,
5,
2,
-5,
0,
6,
0,
-6,
2,
8,
-2,
-7,
4,
9,
-3,
-8,
5,
10,
-5,
-9,
6,
11,
-6,
-10,
7,
12,
-6,
-11,
8,
13,
-7,
-12,
8,
14,
-7,
-13,
8,
14,
-7,
-14,
9,
15,
-8,
-14,
9,
15,
-8,
-14,
9,
15,
-8,
-13,
9,
14,
-8,
-13,
9,
13,
-8,
-12,
10,
12,
-9,
-11,
10,
12,
-9,
-10,
10,
11,
-9,
-9,
10,
10,
-10,
-8,
11,
8,
-10,
-7,
12,
7,
-11,
-6,
13,
6,
-13,
-4,
14,
5,
-14,
-3,
16,
4,
-15,
-2,
17,
3,
-17,
-1,
19,
2,
-18,
0,
20,
1,
-19,
0,
21,
0,
-21,
1,
22,
0,
-21,
2,
23,
-1,
-22,
2,
23,
-2,
-22,
3,
24,
-2,
-23,
3,
23,
-3,
-22,
4,
23,
-3,
-22,
4,
22,
-3,
-21,
4,
21,
-3,
-20,
4,
20,
-3,
-18,
4,
19,
-3,
-17,
4,
17,
-2,
-15,
3,
15,
-2,
-13,
3,
13,
-2,
-11,
3,
11,
-1,
-9,
2,
9,
-1,
-7,
2,
7,
0,
-5,
1,
5,
0,
-3,
1,
3,
1,
-2,
0,
2,
1,
0,
0,
1,
2,
0,
-1,
0,
2,
1,
-1,
0,
2,
1,
-1,
0,
3,
1,
-2,
0,
3,
1,
-2,
0,
3,
0,
-2,
1,
3,
0,
-2,
1,
3,
0,
-2,
2,
3,
-1,
-2,
2,
3,
-1,
-2,
2,
3,
-2,
-2,
3,
3,
-2,
-2,
3,
3,
-1,
-2,
2,
3,
-1,
-2,
2,
3,
0,
-2,
0,
3,
1,
-2,
-1,
4,
3,
-3,
-3,
4,
5,
-3,
-5,
4,
7,
-4,
-7,
5,
9,
-4,
-9,
5,
11,
-4,
-11,
5,
13,
-4,
-14,
5,
16,
-4,
-16,
6,
18,
-5,
-18,
6,
20,
-5,
-20,
6,
22,
-5,
-22,
6,
24,
-5,
-23,
6,
25,
-4,
-24,
5,
26,
-4,
-25,
5,
26,
-3,
-25,
4,
26,
-3,
-25,
4,
25,
-2,
-24,
3,
24,
-2,
-23,
3,
23,
-2,
-21,
3,
21,
-1,
-19,
2,
19,
-1,
-17,
2,
17,
-1,
-15,
2,
15,
-1,
-12,
2,
12,
-2,
-10,
3,
10,
-2,
-7,
3,
7,
-3,
-5,
4,
5,
-3,
-3,
5,
3,
-4,
-1,
6,
1,
-5,
1,
7,
0,
-6,
2,
8,
-2,
-7,
3,
9,
-3,
-8,
4,
9,
-3,
-9,
5,
10,
-4,
-10,
5,
11,
-4,
-10,
5,
11,
-4,
-10,
5,
11,
-4,
-10,
5,
11,
-3,
-10,
4,
11,
-3,
-10,
3,
11,
-2,
-9,
2,
10,
-1,
-8,
1,
9,
0,
-7,
0,
8,
1,
-6,
-1,
6,
2,
-5,
-1,
5,
3,
-3,
-2,
3,
3,
-1,
-2,
1,
4,
1,
-3,
-1,
4,
3,
-3,
-3,
4,
5,
-3,
-5,
4,
7,
-3,
-7,
4,
8,
-3,
-8,
4,
10,
-3,
-10,
4,
11,
-3,
-11,
4,
12,
-3,
-12,
4,
13,
-3,
-13,
4,
14,
-3,
-13,
4,
14,
-3,
-13,
4,
14,
-3,
-13,
4,
14,
-3,
-12,
4,
13,
-2,
-12,
3,
12,
-2,
-11,
3,
11,
-2,
-10,
3,
10,
-2,
-8,
3,
9,
-1,
-7,
2,
7,
-1,
-5,
2,
6,
-1,
-4,
2,
4,
-1,
-3,
2,
3,
0,
-1,
1,
2,
0,
0,
1,
1,
0,
1,
0,
-1,
1,
2,
0,
-1,
1,
3,
0,
-2,
2,
4,
-1,
-3,
2,
4,
-1,
-4,
2,
5,
-1,
-4,
3,
6,
-2,
-5,
3,
6,
-2,
-5,
3,
6,
-2,
-5,
2,
7,
-1,
-6,
2,
7,
-1,
-6,
2,
7,
0,
-6,
1,
7,
0,
-6,
1,
6,
1,
-5,
0,
6,
2,
-4,
-1,
5,
2,
-4,
-2,
4,
3,
-3,
-3,
3,
4,
-2,
-4,
2,
5,
-1,
-4,
1,
6,
0,
-5,
0,
6,
2,
-6,
-2,
7,
3,
-6,
-3,
8,
5,
-7,
-4,
8,
6,
-7,
-6,
8,
7,
-7,
-7,
8,
9,
-7,
-8,
8,
10,
-7,
-9,
8,
11,
-7,
-10,
8,
12,
-6,
-11,
7,
12,
-5,
-11,
6,
13,
-4,
-12,
5,
13,
-3,
-12,
4,
12,
-2,
-11,
2,
12,
-1,
-10,
1,
11,
0,
-9,
0,
10,
1,
-8,
-1,
9,
3,
-7,
-2,
8,
3,
-6,
-3,
6,
4,
-4,
-4,
5,
5,
-3,
-4,
3,
5,
-1,
-4,
1,
5,
1,
-4,
0,
5,
2,
-4,
-2,
5,
4,
-4,
-3,
4,
5,
-3,
-5,
3,
6,
-2,
-6,
2,
7,
-1,
-6,
1,
8,
1,
-7,
0,
8,
2,
-7,
-2,
8,
4,
-7,
-4,
8,
5,
-6,
-5,
7,
7,
-6,
-7,
6,
9,
-5,
-9,
5,
11,
-3,
-10,
4,
12,
-2,
-12,
2,
14,
0,
-13,
0,
15,
2,
-14,
-2,
16,
4,
-16,
-4,
17,
6,
-17,
-6,
18,
8,
-17,
-8,
19,
10,
-18,
-9,
20,
11,
-19,
-11,
20,
13,
-19,
-12,
21,
14,
-20,
-13,
21,
14,
-20,
-14,
21,
15,
-20,
-14,
21,
15,
-20,
-14,
21,
14,
-20,
-13,
21,
14,
-20,
-12,
21,
13,
-20,
-11,
20,
11,
-19,
-10,
20,
10,
-19,
-8,
19,
8,
-18,
-6,
19,
6,
-18,
-5,
18,
5,
-17,
-3,
18,
3,
-17,
-1,
17,
1,
-16,
1,
16,
-1,
-15,
3,
15,
-3,
-14,
4,
15,
-4,
-13,
5,
14,
-5,
-12,
6,
13,
-6,
-11,
7,
12,
-6,
-11,
8,
11,
-7,
-10,
0, 0, 0, 0, 0
)
)
 port map ( 
			Clk_96 => Clk_96,
			Ce_F6 => Ce_F6,
			Sign_LCHM => Sign_LCHM,
			EN =>EN,
			EN2 =>EN2,
			Rom_cos_all => Rom_cos_L60_i,--out
			Rom_cos_all2 => Rom_cos_L60_i2--out
			 );
----------------------------------

--------
----------------------------------------L_sin ������ '+'
--------LHM_PP_L60_sin: entity work.LHM_ALL
--------generic map(
--------(
--------4,
---------1,
---------2,
--------3,
--------3,
---------2,
---------1,
--------4,
--------2,
---------3,
--------0,
--------4,
--------1,
---------3,
--------1,
--------4,
--------0,
---------4,
--------2,
--------5,
---------2,
---------4,
--------3,
--------5,
---------3,
---------4,
--------5,
--------5,
---------4,
---------3,
--------6,
--------4,
---------6,
---------3,
--------8,
--------4,
---------7,
---------2,
--------9,
--------3,
---------9,
---------1,
--------10,
--------2,
---------10,
--------0,
--------12,
--------1,
---------11,
--------1,
--------13,
---------1,
---------12,
--------2,
--------14,
---------2,
---------13,
--------3,
--------14,
---------3,
---------14,
--------5,
--------15,
---------4,
---------14,
--------6,
--------15,
---------5,
---------14,
--------7,
--------15,
---------6,
---------14,
--------8,
--------15,
---------7,
---------13,
--------8,
--------14,
---------8,
---------12,
--------9,
--------13,
---------8,
---------11,
--------9,
--------12,
---------8,
---------10,
--------9,
--------10,
---------8,
---------8,
--------9,
--------9,
---------7,
---------7,
--------8,
--------7,
---------7,
---------5,
--------7,
--------6,
---------6,
---------4,
--------6,
--------4,
---------5,
---------2,
--------5,
--------3,
---------4,
---------1,
--------4,
--------1,
---------3,
--------1,
--------3,
---------1,
---------2,
--------2,
--------2,
---------2,
---------1,
--------4,
--------1,
---------3,
--------0,
--------5,
--------0,
---------4,
--------1,
--------5,
---------1,
---------5,
--------2,
--------6,
---------2,
---------5,
--------3,
--------6,
---------2,
---------5,
--------3,
--------6,
---------2,
---------5,
--------3,
--------6,
---------2,
---------5,
--------3,
--------6,
---------1,
---------5,
--------2,
--------6,
---------1,
---------5,
--------1,
--------6,
--------0,
---------5,
--------1,
--------6,
--------1,
---------5,
--------0,
--------6,
--------2,
---------5,
---------1,
--------6,
--------2,
---------5,
---------2,
--------6,
--------3,
---------5,
---------2,
--------6,
--------4,
---------6,
---------3,
--------7,
--------4,
---------7,
---------3,
--------8,
--------5,
---------8,
---------4,
--------10,
--------5,
---------9,
---------4,
--------11,
--------5,
---------11,
---------4,
--------12,
--------5,
---------12,
---------4,
--------13,
--------5,
---------13,
---------4,
--------14,
--------4,
---------14,
---------3,
--------15,
--------4,
---------15,
---------3,
--------16,
--------3,
---------15,
---------2,
--------16,
--------3,
---------16,
---------2,
--------17,
--------3,
---------16,
---------2,
--------17,
--------3,
---------16,
---------1,
--------17,
--------2,
---------15,
---------1,
--------16,
--------2,
---------14,
---------2,
--------15,
--------3,
---------13,
---------2,
--------13,
--------3,
---------12,
---------2,
--------12,
--------3,
---------10,
---------2,
--------10,
--------3,
---------8,
---------2,
--------8,
--------3,
---------6,
---------2,
--------6,
--------3,
---------4,
---------2,
--------5,
--------3,
---------3,
---------2,
--------3,
--------3,
---------1,
---------2,
--------1,
--------3,
--------1,
---------2,
--------0,
--------3,
--------2,
---------2,
---------2,
--------3,
--------3,
---------2,
---------3,
--------3,
--------4,
---------1,
---------4,
--------2,
--------5,
---------1,
---------4,
--------2,
--------5,
---------1,
---------4,
--------1,
--------5,
--------0,
---------4,
--------1,
--------5,
--------1,
---------4,
--------0,
--------5,
--------1,
---------3,
---------1,
--------4,
--------2,
---------3,
---------1,
--------3,
--------2,
---------2,
---------2,
--------3,
--------3,
---------1,
---------2,
--------2,
--------3,
---------1,
---------2,
--------2,
--------4,
---------1,
---------3,
--------1,
--------4,
--------0,
---------3,
--------1,
--------4,
--------0,
---------3,
--------1,
--------4,
--------0,
---------3,
--------1,
--------4,
--------0,
---------3,
--------1,
--------4,
--------0,
---------3,
--------1,
--------4,
--------0,
---------2,
--------2,
--------3,
---------1,
---------2,
--------3,
--------2,
---------2,
---------1,
--------3,
--------2,
---------3,
--------0,
--------5,
--------1,
---------4,
--------0,
--------6,
--------0,
---------5,
--------1,
--------7,
--------0,
---------7,
--------2,
--------8,
---------1,
---------8,
--------2,
--------9,
---------2,
---------9,
--------3,
--------11,
---------2,
---------10,
--------4,
--------11,
---------3,
---------11,
--------4,
--------12,
---------3,
---------11,
--------5,
--------13,
---------4,
---------12,
--------5,
--------13,
---------4,
---------12,
--------5,
--------13,
---------3,
---------12,
--------4,
--------13,
---------3,
---------12,
--------4,
--------13,
---------3,
---------11,
--------4,
--------12,
---------2,
---------11,
--------3,
--------11,
---------2,
---------10,
--------3,
--------10,
---------1,
---------9,
--------2,
--------9,
---------1,
---------7,
--------2,
--------8,
--------0,
---------6,
--------1,
--------6,
--------0,
---------4,
--------1,
--------4,
--------1,
---------3,
--------0,
--------3,
--------1,
---------1,
--------0,
--------1,
--------1,
--------1,
--------0,
---------1,
--------1,
--------3,
--------0,
---------3,
--------1,
--------5,
--------0,
---------5,
--------1,
--------6,
--------0,
---------6,
--------1,
--------8,
--------0,
---------8,
--------1,
--------10,
--------0,
---------9,
--------1,
--------11,
---------1,
---------10,
--------2,
--------12,
---------1,
---------11,
--------2,
--------13,
---------1,
---------12,
--------2,
--------14,
---------1,
---------13,
--------3,
--------14,
---------2,
---------13,
--------3,
--------14,
---------2,
---------13,
--------3,
--------13,
---------2,
---------12,
--------3,
--------12,
---------2,
---------10,
--------3,
--------11,
---------2,
---------9,
--------4,
--------9,
---------3,
---------7,
--------4,
--------7,
---------3,
---------5,
--------4,
--------5,
---------3,
---------2,
--------4,
--------2,
---------4,
--------0,
--------5,
--------0,
---------4,
--------2,
--------5,
---------3,
---------4,
--------5,
--------5,
---------5,
---------4,
--------7,
--------5,
---------7,
---------4,
--------9,
--------5,
---------9,
---------4,
--------11,
--------5,
---------11,
---------4,
--------12,
--------5,
---------12,
---------4,
--------13,
--------5,
---------12,
---------5,
--------14,
--------6,
---------13,
---------5,
--------14,
--------6,
---------12,
---------5,
--------13,
--------7,
---------12,
---------6,
--------12,
--------7,
---------11,
---------7,
--------11,
--------8,
---------10,
---------8,
--------10,
--------9,
---------8,
---------9,
--------8,
--------10,
---------7,
---------10,
--------7,
--------11,
---------5,
---------11,
--------5,
--------12,
---------3,
---------11,
--------3,
--------13,
---------2,
---------12,
--------2,
--------14,
--------0,
---------13,
--------0,
--------14,
--------2,
---------14,
---------1,
--------15,
--------3,
---------14,
---------3,
--------15,
--------5,
---------15,
---------4,
--------16,
--------6,
---------15,
---------5,
--------16,
--------6,
---------16,
---------6,
--------17,
--------7,
---------16,
---------6,
--------17,
--------7,
---------16,
---------6,
--------17,
--------7,
---------16,
---------6,
--------17,
--------7,
---------16,
---------6,
--------17,
--------7,
---------16,
---------6,
--------16,
--------7,
---------15,
---------5,
--------16,
--------6,
---------14,
---------5,
--------15,
--------6,
---------13,
---------4,
--------14,
--------5,
---------12,
---------4,
--------13,
--------4,
---------11,
---------3,
--------12,
--------3,
---------10,
---------2,
--------11,
--------2,
---------9,
---------1,
--------9,
--------1,
---------7,
--------0,
--------7,
--------0,
---------6,
--------1,
--------6,
---------1,
---------4,
--------2,
--------4,
---------1,
---------2,
--------3,
--------3,
---------2,
---------1,
--------4,
--------1,
---------3,
--------1,
--------4,
---------1,
---------4,
--------2,
--------5,
---------2,
---------5,
--------4,
--------6,
---------4,
---------6,
--------5,
--------7,
---------5,
---------7,
--------6,
--------8,
---------6,
---------8,
--------7,
--------9,
---------6,
---------9,
--------8,
--------10,
---------7,
---------9,
--------8,
--------10,
---------7,
---------10,
--------8,
--------11,
---------7,
---------10,
--------7,
--------12,
---------6,
---------11,
--------7,
--------12,
---------5,
---------11,
--------6,
--------13,
---------5,
---------12,
--------5,
--------13,
---------4,
---------12,
--------4,
--------13,
---------3,
---------12,
--------3,
--------13,
---------1,
---------12,
--------2,
--------13,
--------0,
---------11,
--------0,
--------12,
--------1,
---------11,
---------1,
--------12,
--------2,
---------11,
---------2,
--------12,
--------3,
---------11,
---------3,
--------12,
--------4,
---------11,
---------3,
--------12,
--------4,
---------10,
---------3,
--------11,
--------4,
---------10,
---------3,
--------10,
--------4,
---------9,
---------3,
--------9,
--------3,
---------8,
---------2,
--------8,
--------3,
---------7,
---------1,
--------7,
--------2,
---------6,
--------0,
--------6,
--------0,
---------5,
--------2,
--------5,
---------2,
---------4,
--------3,
--------4,
---------3,
---------2,
--------5,
--------3,
---------5,
---------1,
--------7,
--------1,
---------7,
--------0,
--------9,
--------0,
---------9,
--------2,
--------11,
---------1,
---------11,
--------3,
--------13,
---------3,
---------13,
--------4,
--------14,
---------4,
---------14,
--------6,
--------16,
---------5,
---------15,
--------7,
--------17,
---------6,
---------16,
--------7,
--------18,
---------7,
---------17,
--------8,
--------18,
---------7,
---------17,
--------9,
--------18,
---------8,
---------17,
--------9,
--------18,
---------8,
---------17,
--------9,
--------18,
---------8,
---------17,
--------9,
--------18,
---------9,
---------16,
--------10,
--------17,
---------9,
---------15,
--------10,
--------16,
---------9,
---------14,
--------10,
--------14,
---------9,
---------13,
--------9,
--------13,
---------8,
---------11,
--------9,
--------12,
---------8,
---------10,
--------9,
--------10,
---------8,
---------8,
--------8,
--------9,
---------7,
---------7,
--------8,
--------7,
---------7,
---------6,
--------7,
--------6,
---------6,
---------4,
--------7,
--------4,
---------5,
---------2,
--------6,
--------3,
---------5,
---------1,
--------6,
--------1,
---------4,
--------1,
--------5,
---------1,
---------4,
--------2,
--------5,
---------2,
---------3,
--------4,
--------4,
---------3,
---------3,
--------5,
--------4,
---------5,
---------2,
--------6,
--------3,
---------6,
---------2,
--------7,
--------3,
---------7,
---------1,
--------8,
--------2,
---------8,
---------1,
--------9,
--------2,
---------9,
---------1,
--------10,
--------1,
---------9,
--------0,
--------11,
--------1,
---------10,
--------0,
--------11,
--------1,
---------10,
--------0,
--------11,
--------0,
---------10,
--------1,
--------11,
--------0,
--------0, 0, 0, 0, 0
--------)
--------)
-------- port map ( 
--------			Clk_96 => Clk_96,
--------			Ce_F6 => Ce_F6,
--------			EN =>EN,
--------			EN2 =>EN2,
--------			Sign_LCHM => Sign_LCHM,
--------			Rom_cos_all => Rom_sin_L60_i,--out
--------			Rom_cos_all2 => Rom_sin_L60_i2--out
--------			 );
------
------
------	--process (Clk_96, Sign_LCHM, Rom_cos_L3_minus, Rom_cos_L3_plus)
--	begin
--	 if rising_edge(clk_96) then
--    if Sign_LCHM = '1' then
--       Rom_cos_i <= Rom_cos_L3_plus;
--    else
--       Rom_cos_i <= Rom_cos_L3_minus;
--    end if;	
--  end if;	
--   end process;
   
  Rom_cos_i <= Rom_cos_L60_i when rising_edge(Clk_96);
  Rom_sin_i <= Rom_sin_L60_i when rising_edge(Clk_96);
  
   Rom_cos_i2 <= Rom_cos_L60_i2 when rising_edge(Clk_96);
   Rom_sin_i2 <= Rom_sin_L60_i2 when rising_edge(Clk_96);
 ------------------------------------------------------------- 
	process (Clk_96, Ce_F6, EN,  EN2, Rom_cos_i, Rom_sin_i, Rom_cos_i2, Rom_sin_i2 )
	begin
	  if Clk_96'event and Clk_96 = '1' then
		if Ce_F6 = '1'  then
			if EN = '1' then
				Rom_cos_rg <= conv_std_logic_vector(Rom_cos_i, data_rom);
				Rom_sin_rg <= conv_std_logic_vector(Rom_sin_i, data_rom);
			else
				Rom_cos_rg <= (others => '0');
				Rom_sin_rg <= (others => '0');
			end if;
			if EN2 = '1' then
				Rom_cos_rg2 <= conv_std_logic_vector(Rom_cos_i2, data_rom);
				Rom_sin_rg2 <= conv_std_logic_vector(Rom_sin_i2, data_rom);
			else
				Rom_cos_rg2 <= (others => '0');
				Rom_sin_rg2 <= (others => '0');
			end if;
		end if;
	  end if;
   end process;

Rom_cos1 <= Rom_cos_rg  when rising_edge(Clk_96);
Rom_sin1 <= Rom_sin_rg when rising_edge(Clk_96);

Rom_cos2 <= Rom_cos_rg2  when rising_edge(Clk_96);
Rom_sin2 <= Rom_sin_rg2 when rising_edge(Clk_96);

end Behavioral;

