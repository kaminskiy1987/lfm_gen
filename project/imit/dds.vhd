library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dds is
port(
	      Clk_96 : in std_logic;
	      LG : in std_logic;
	    --  ti : in std_logic;
	      en : in std_logic;
      --   DV : in std_logic_vector(2 downto 1);
       --   D : in std_logic_vector(14 downto 1);
        lchm_type : in std_logic_vector(8 downto 0);
   -- Sign_LCHM : in std_logic;
	    Rom_DDS : out std_logic_vector(13 downto 0)
	 );
end dds;

architecture dds_a of dds is
-------------------------------------------------------------------------------
--	Сигналы
-------------------------------------------------------------------------------
signal LG_r           : std_logic := '0';
signal LG_rr          : std_logic := '0';
signal Sign_LCHM_r    : std_logic := '0';
signal lchm_type_r    : std_logic_vector(8 downto 0):=(others => '0');
signal count_addr     : std_logic_vector (12 downto 0) := (others => '0'); 

signal PI           : std_logic := '0';
signal PI_r           : std_logic := '0';
signal PI_rr          : std_logic := '0';
signal pf_PI          : std_logic := '0';

--signal EN             : std_logic := '0';
signal EN_r           : std_logic := '0';
signal EN_rr          : std_logic := '0';
signal EN_rrr         : std_logic := '0';
signal EN_rrrr        : std_logic := '0';

signal pf_EN          : std_logic := '0';
signal pf_EN_r        : std_logic := '0';

signal KodFmin        : std_logic_vector (31 downto 0) := (others => '0'); 
signal KodDF          : std_logic_vector (31 downto 0) := (others => '0');

signal dds_rst        : std_logic := '0';
signal dds_we         : std_logic := '1';
signal dds_ce         : std_logic := '0';
signal dds_fmin       : std_logic_vector (31 downto 0) := (others => '0'); 
signal dds_fstep      : std_logic_vector (31 downto 0) := (others => '0');
signal dds_sine, dds_cosine       : std_logic_vector (13 downto 0) := (others => '0'); 
signal dds_sine_rdy   : std_logic_vector (13 downto 0) := (others => '0'); 
signal dds_rdy        : std_logic := '0';
signal phase_out      : std_logic_vector (31 downto 0) := (others => '0');
--constant lchm_type : std_logic_vector (2 downto 0) := "000"; 
signal en_out         : std_logic := '1';
-------------------------------------------------------------------------------
component dds_example
port(
           ce : in std_logic;
          clk : in std_logic;
         sclr : in std_logic;
           we : in std_logic;
         data : in std_logic_vector(31 downto 0);
          rdy : out std_logic;
			 cosine : out std_logic_vector(13 downto 0);
			 sine : out std_logic_vector(13 downto 0);
    phase_out : out std_logic_vector(31 downto 0)
  );
END COMPONENT;
-------------------------------------------------------------------------------
--	Аттрибуты
-------------------------------------------------------------------------------
attribute KEEP : string;
attribute KEEP of LG_r        : signal is "true"; 
attribute KEEP of LG_rr       : signal is "true";
attribute KEEP of EN_r        : signal is "true"; 
attribute KEEP of Sign_LCHM_r : signal is "true";
attribute KEEP of lchm_type_r : signal is "true";
attribute KEEP of count_addr  : signal is "true";
attribute KEEP of dds_sine    : signal is "true";
-------------------------------------------------------------------------------
BEGIN
-------------------------------------------------------------------------------
process (Clk_96)
begin
  if Clk_96'event and Clk_96 = '1' then
  	  LG_r <= LG;
  	  LG_rr <= LG_r;
    -- Sign_LCHM_r <= Sign_LCHM;
	  if (LG_r = '1' and LG_rr = '0') then 
        count_addr <= (others => '0');		
	  elsif EN = '1' then
			count_addr <= count_addr+1;
     end if;
   end if;
end process;

---------------------------------------------------------------------------------
--l_distance : entity work.Distance
--port map( 
--			Clk_96 => Clk_96,
--			PI => PI,
--         D => D,	--in
--			lchm_type => lchm_type, --in
--			KD => KD,	--in
--			LG => LG,	--in
--			EN_Sign => EN --out
--			);
-------------------------------------------------------------------------------
lchm_type_r <= lchm_type when rising_edge(Clk_96);
EN_r <= EN when rising_edge(Clk_96);
EN_rr <= EN_r when rising_edge(Clk_96); 
EN_rrr <= EN_rr when rising_edge(Clk_96);
EN_rrrr <= EN_rrr when rising_edge(Clk_96);

pf_EN <= not(EN_rr) and EN_r;
pf_EN_r <= pf_EN when rising_edge(Clk_96);

dds_rst <= pf_EN_r;
dds_ce <= EN_rrrr when rising_edge(Clk_96);
-------------------------------------------------------------------------------
Decoders_N : process(Clk_96)
begin
if rising_edge(Clk_96) then
   case lchm_type_r is
	   when "000110100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(49535,32); -- L15 (2.5)
	   when "010110100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(58196,32); -- L15C3
	   when "101110100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(58196,32); -- L15C4 (2.5)
	   when "000000100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(28368,32); -- L30 (2.5)
	   when "000000110" => KodFmin <= conv_std_logic_vector(1040187392,32); KodDF <= conv_std_logic_vector(17020,32); -- L30 (1.5)
	   when "010000100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(30643,32); -- L30C3
	   when "101000100"  => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(30643,32); -- L30C4 (2.5)
	   when "000010100" => KodFmin <= conv_std_logic_vector(1017817770,32); KodDF <= conv_std_logic_vector(14828,32); -- L60 (2.5)
	   when "000010001" => KodFmin <= conv_std_logic_vector(1056964608,32); KodDF <= conv_std_logic_vector(4448,32); -- L60 (0.75)
--	   when "111" => KodFmin <= conv_std_logic_vector(,32); KodDF <= conv_std_logic_vector(,32); -- PP
      when others => KodFmin <= conv_std_logic_vector(1040187392,32); KodDF <= conv_std_logic_vector(17020,32); -- L30 (1.5)              
   end case;
end if;
end process;
-------------------------------------------------------------------------------
p_dds_fstep: process(Clk_96) 
begin
if rising_edge(Clk_96) then
   if pf_EN_r = '1' then
		dds_fstep <= KodFmin;
   elsif dds_ce = '1' then		
		dds_fstep <= dds_fstep + KodDF;
   end if;	
end if;
end process;
-------------------------------------------------------------------------------
l_dds_cos : dds_example
  port map(
    ce => dds_ce,
    clk => Clk_96,
    sclr => dds_rst,
    we => dds_we,
    data => dds_fstep,
    rdy => dds_rdy,
    cosine => dds_cosine,
	 sine => dds_sine,
    phase_out => phase_out
  );		  

-------------------------------------------------------------------------------
pf_PI <= PI_r and (not PI_rr);

u_en_out : process(Clk_96)
   begin
		if rising_edge(Clk_96) then
			if pf_PI = '1' then
				en_out <= '0';
			elsif ((LG_r = '1') and (LG_rr = '0')) then
				en_out <= '1';
			end if;
			
		PI_r <= PI;
		PI_rr <= PI_r;			
			
		end if;
 end process;

dds_sine_rdy <= dds_sine when (dds_rdy = '1' and  en_out = '1' and dds_ce = '1') else (others => '0');
-------------------------------------------------------------------------------
--p_sign_lchm: process(Clk_96)
--begin
--if rising_edge(Clk_96) then
--   if Sign_LCHM_r = '1' then
--		Rom_DDS <= dds_sine_rdy;
--   else		
--	   if count_addr(0) = '1' then 
--			Rom_DDS <= dds_sine_rdy;
--		else
--			Rom_DDS <= not dds_sine_rdy;
--      end if;	
--   end if;	
--end if;
--end process;

--Rom_DDS <= dds_cosine when rising_edge(Clk_96);
Rom_DDS <= dds_cosine when (dds_ce = '1')else (others => '0');
-------------------------------------------------------------------------------
end dds_a;

