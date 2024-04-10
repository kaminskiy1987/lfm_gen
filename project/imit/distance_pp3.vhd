-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:47 11/11/2019 
-- Design Name: 
-- Module Name:    distance_pp2 - Behavioral 
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
	USE ieee.std_logic_unsigned.all;
	USE ieee.numeric_std.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity distance_pp3 is
generic (
	
	   data_pft: integer := 8;
		pft_widht : integer:= 8;		
		length_array: int_array :=  ( 1441,1441,1441,1441,1441,1441,1441,1441,1441,1441,
                                      1565,1565,1565,1565,
		                              2073,2073,2073,2073,2073,2073,2073,2073,2073,2073,     
                                      2209,2209,2209,2209,
		                              3101,3101,3101,3101,3101,3101,3101,3101,3101,3101,
		                              3217,3217,3217,3217,
		                              3869,3869,3869,3869,3869,3869,3869
		                            );
		
		pft_code : int_array := (96, 99, 97, 98, 102, 103, 113, 114, 118, 119,
                                 105, 106, 110, 111,
                                 64, 67, 65, 66, 70, 71, 81, 82, 86, 87,
                                 73, 74, 78, 79, 
                                 32, 35, 33, 34, 38, 39, 49, 50, 54, 55,
                                 41, 42, 46, 47,
                                 0, 3, 192, 1, 2, 6, 7);
		data_distance : integer := 13
		
				);
	Port(
		Ce_F6 : in std_logic;
		Clk_96 : in std_logic;
		PFT  : in std_logic_vector (pft_widht - 1 downto 0);
		ti : in std_logic;
		PI : in std_logic;
		D : in std_logic_vector ( 18  downto 0);
		
		LG : in std_logic;		
		--------------------------
		sdc_flag : in boolean := false;
		--------------------------
    --  EN_Signal_D2 : out std_logic := '0';
		EN_Signal_D : out std_logic := '0'

		);

end distance_pp3;

architecture Behavioral of distance_pp3 is
constant inn_distance_range : integer := data_distance + 7;

--	Signal D_rec : std_logic_vector (data_distance downto 1) := (others => '0');
	Signal D_count : std_logic_vector (inn_distance_range - 1  downto 0) := (others => '0');
	Signal N : std_logic_vector(inn_distance_range - 1  downto 0) := (others => '0');
	Signal D_count2 : std_logic_vector (inn_distance_range - 1  downto 0) := (others => '0');
	Signal N2 : std_logic_vector(inn_distance_range - 1  downto 0) := (others => '0');
	Signal P2_PFT : std_logic_vector(data_pft downto 1) := (others => '0');
	Signal OD_latch : std_logic :='0';
	signal NNN : std_logic_vector(inn_distance_range - 1 downto 0) := (others => '0');

  function recalculation( a : std_logic_vector; size : integer) return std_logic_vector is
		variable res : std_logic_vector(size - 1 downto 0) ;
	begin	 
		return conv_std_logic_vector(conv_integer(a) * 32 , size);
--		return res;
    --   return a;		
	end recalculation;
	
--	function recalculation1( a : std_logic_vector; size : integer) return std_logic_vector is
--		variable res : std_logic_vector(size - 1 downto 0) ;
--	begin	 
--		return conv_std_logic_vector(conv_integer(a) * 32 , size);
----		return res;
--    --   return a;		
--	end recalculation1;

	------------------
	signal its_first_lg : std_logic := '0';
	------------------

	
	--attribute keep : string;
	--attribute keep of its_first_lg : signal is "true";
	--attribute keep of EN_Signal_D : signal is "true";
--	attribute keep of N2 : signal is "true";
--	attribute keep of D_count2 : signal is "true";
begin
	process(PFT)
	begin
--	  if  pft = "00100000" or pft = "00100011" then
			 -- N <= std_logic_vector(to_unsigned(3869, inn_distance_range ));
			--  N <= std_logic_vector(to_unsigned(8319, inn_distance_range ));
	 if pft = "00110"  then
        N <= std_logic_vector(to_unsigned(2079, inn_distance_range ));
    elsif pft = "10110" then
        N <= std_logic_vector(to_unsigned(2079, inn_distance_range ));
    elsif pft = "00000" then
        N <= std_logic_vector(to_unsigned(4159, inn_distance_range ));
    elsif pft = "11000"  then
        N <= std_logic_vector(to_unsigned(4159, inn_distance_range ));
    elsif pft = "00010"  then
        N <= std_logic_vector(to_unsigned(8319, inn_distance_range ));
--	  elsif pft = "00100001" or pft = "00100010" or pft = "00100110" or pft = "00100111" or pft = "00110001" or pft = "00110010" or pft = "00110110" or pft = "00110111" then
--			  N <= std_logic_vector(to_unsigned(3101, inn_distance_range ));
	  end if; 
	end process;
	
--	lg_counter : process (lg, sdc_flag) is
--		variable cnt : integer := 0;
--	begin
--		if rising_edge(lg) then
--			if cnt = 3 then
--				cnt := 0;
--			end if;
--			if cnt = 0 then
--				its_first_lg <= '1';
--			else				
--				its_first_lg <= '0';
--			end if;
--			
--			cnt := cnt + 1;
--		end if;
--	end process;
	
--	lg_counter : process (ti, lg, sdc_flag) is
--		variable cnt : integer := 0;
--	begin
--		if ti = '1' then
--			cnt := 0;
--			its_first_lg <= '0';
--		elsif rising_edge(lg) then
--			if cnt = 3 then
--				cnt := 0;
--			end if;
--			if cnt = 0 then
--				its_first_lg <= '1';
--			else				
--				its_first_lg <= '0';
--			end if;
--			
--			cnt := cnt + 1;
--		end if;
--	end process;
	
	u_D_count : process (Clk_96, LG, its_first_lg)
	   variable latch : boolean := False;
--		variable NNN : std_logic_vector(D_count'range);
	begin
		if LG = '1' then
			--NNN <= recalculation(D, inn_distance_range);
			--NNN <= (D, inn_distance_range);
			D_count <= (others => '0');
			EN_Signal_D <= '0';
			--EN_Signal_D2 <= '0';
			latch := True;
		elsif Clk_96'event and Clk_96 = '1' then
			if Ce_F6 = '1' then --and OD_latch = '1' then 
				if (D_count < N + D  ) and  PI = '1' and latch = True then
--					if (D_count > D  and its_first_lg = '1') then
					if (D_count > D) then
						EN_Signal_D <= '1';
					end if;
					D_count <= D_count + 1;
				else
					EN_Signal_D <= '0';
					latch := False;
				end if;
			end if; 
		end if;
	end process;
	
	
--   u_D_count : process (Clk_96, LG)
--	   variable latch : boolean := False;
----		variable NNN : std_logic_vector(D_count'range);
--	begin
--		if LG = '1' then
--			--NNN <= recalculation(D, inn_distance_range);
--			--NNN <= (D, inn_distance_range);
--			D_count <= (others => '0');
--			EN_Signal_D <= '0';
--			--EN_Signal_D2 <= '0';
--			latch := True;
--		elsif Clk_96'event and Clk_96 = '1' then
--			if Ce_F6 = '1' then --and OD_latch = '1' then 
--				if (D_count < N + D  ) and  PI = '1' and latch = True then
--					if (D_count > D  ) then					
--						EN_Signal_D <= '1';
--					end if;
--					D_count <= D_count + 1;
--				else
--					EN_Signal_D <= '0';
--					latch := False;
--				end if;
--			end if; 
--		end if;
--	end process;
	

end Behavioral;





