
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	USE ieee.std_logic_unsigned.all;
	USE ieee.numeric_std.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;

entity Distance_pp is

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

		PI : in std_logic;
		D : in std_logic_vector (data_distance - 1  downto 0);
		dpp1 : in integer;
		OD : in std_logic;		
    --  EN_Signal_D2 : out std_logic := '0';
		EN_Signal_D : out std_logic := '0'

		);

end Distance_pp;

architecture Behavioral of Distance_pp is

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
	--	return conv_std_logic_vector(conv_integer(a) * 16 , size);
--		return res;
    --   return a;		
	end recalculation;
	
	function recalculation1( a : std_logic_vector; size : integer) return std_logic_vector is
		variable res : std_logic_vector(size - 1 downto 0) ;
	begin	 
		return conv_std_logic_vector(conv_integer(a) * 32 - 1000 , size);
	--	return conv_std_logic_vector(conv_integer(a) * 16 - 1000 , size);
--		return res;
    --   return a;		
	end recalculation1;
	
	--attribute keep : string;
--	attribute keep of NNN : signal is "true";
	--attribute keep of EN_Signal_D : signal is "true";
--	attribute keep of N2 : signal is "true";
--	attribute keep of D_count2 : signal is "true";
	

begin

--	process(PFT)
--	begin
--	  if  pft = "00100000" or pft = "00100011" then
			 -- N <= std_logic_vector(to_unsigned(3869, inn_distance_range ));
			 
			  N <= std_logic_vector(to_unsigned(16346, inn_distance_range ));
			   --N <= std_logic_vector(to_unsigned(dpp1, inn_distance_range ));
			  
			--  N <= std_logic_vector(to_unsigned(16346, inn_distance_range ));
			--  N <= std_logic_vector(to_unsigned(13000, inn_distance_range ));
--	  elsif pft = "00100001" or pft = "00100010" or pft = "00100110" or pft = "00100111" or pft = "00110001" or pft = "00110010" or pft = "00110110" or pft = "00110111" then
--			  N <= std_logic_vector(to_unsigned(3101, inn_distance_range ));
--	  end if; 
--	end process;

   u_D_count : process (Clk_96, OD)
	   variable latch : boolean := False;
--		variable NNN : std_logic_vector(D_count'range);
	begin
		if OD = '1' then
			NNN <= recalculation1(D, inn_distance_range);
			D_count <= (others => '0');
			EN_Signal_D <= '0';
			--EN_Signal_D2 <= '0';
			latch := True;
		elsif Clk_96'event and Clk_96 = '1' then
			if Ce_F6 = '1' then --and OD_latch = '1' then 
				if (D_count < N + NNN) and  PI = '1' and latch = True then
					if (D_count > NNN) then					
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
	
--	 u_D_count2 : process (Clk_96, OD)
--	   variable latch : boolean := False;
----		variable NNN : std_logic_vector(D_count'range);
--	begin
--		if OD = '1' then
--			NNN <= recalculation(D, inn_distance_range);
--			D_count2 <= (others => '0');
--			EN_Signal_D2 <= '0';
--			latch := True;
--		elsif Clk_96'event and Clk_96 = '1' then
--			if Ce_F6 = '1' then --and OD_latch = '1' then 
--				if D_count2 < N2 + NNN and PI = '1' and latch = True then
--					if (D_count2 > NNN) then					
--						EN_Signal_D2 <= '1';
--					end if;
--					D_count2 <= D_count2 + 1;
--				else
--					EN_Signal_D2 <= '0';
--					latch := False;
--				end if;
--			end if; 
--		end if;
--	end process;
end Behavioral;

