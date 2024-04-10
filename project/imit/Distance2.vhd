
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	USE ieee.std_logic_unsigned.all;
	USE ieee.numeric_std.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;

entity Distance2 is

	generic (
	
	   data_pft: integer := 8;
		pft_widht : integer:= 8;		
		data_distance : integer := 13
		
				);
	Port(
		Ce_F6 : in std_logic;
		Clk_96 : in std_logic;
		PFT  : in std_logic_vector (pft_widht - 1 downto 0);

		PI : in std_logic;
		D : in std_logic_vector (data_distance - 1  downto 0);
		
		OD : in std_logic;
		

		EN_Signal_D : out std_logic:='0'

		);

end Distance2;

architecture Behavioral of Distance2 is

	constant inn_distance_range : integer := data_distance + 7;

--	Signal D_rec : std_logic_vector (data_distance downto 1) := (others => '0');
	Signal D_count : std_logic_vector (inn_distance_range - 1  downto 0) := (others => '0');
	Signal N : std_logic_vector(inn_distance_range - 1  downto 0) := (others => '0');
	Signal P2_PFT : std_logic_vector(data_pft downto 1) := (others => '0');
	Signal OD_latch : std_logic :='0';
	signal NNN : std_logic_vector(inn_distance_range - 1 downto 0) := (others => '0');

  function recalculation( a : std_logic_vector; size : integer) return std_logic_vector is
		variable res : std_logic_vector(size - 1 downto 0) ;
	begin	 
--		return conv_std_logic_vector(conv_integer(a) * 32 , size);
		return conv_std_logic_vector(conv_integer(a) * 16 - 224 , size);
--		return res;
    --   return a;		
	end recalculation;

begin
process(PFT)
begin
    if pft = "0001011" or pft = "1100011"  then --L5, LPS1
        N <= std_logic_vector(to_unsigned(3012,inn_distance_range ));
    elsif pft = "0010011" then --L7
        N <= std_logic_vector(to_unsigned(3830,inn_distance_range ));
    elsif pft = "0011011" then --L10
        N <= std_logic_vector(to_unsigned(4647,inn_distance_range ));
    elsif pft = "0100011"  then --L12
        N <= std_logic_vector(to_unsigned(5497,inn_distance_range ));
    elsif pft = "0101011"  then --L15
        N <= std_logic_vector(to_unsigned(6346,inn_distance_range ));
	 elsif pft = "0110011"  then --L17
        N <= std_logic_vector(to_unsigned(7195,inn_distance_range ));
	 elsif pft = "0111011"  then --L20
        N <= std_logic_vector(to_unsigned(8044,inn_distance_range ));
	 elsif pft = "1000011"  then --L25
        N <= std_logic_vector(to_unsigned(9727,inn_distance_range ));
	 elsif pft = "1001011"  then --L32
        N <= std_logic_vector(to_unsigned(12259,inn_distance_range ));
	 elsif pft = "1010011"  then --L40
        N <= std_logic_vector(to_unsigned(14791,inn_distance_range ));
	 elsif pft = "1011011" or pft = "1101100"  then --L50, LPS2
        N <= std_logic_vector(to_unsigned(18137,inn_distance_range ));
    end if; 
 end process;

process(PFT, D)
begin
     if pft = "1101100" or pft = "1100011" then 
        NNN <= (others => '0');
     else 
        NNN <= recalculation(D, inn_distance_range);
     end if; 
end process;

    	 u_D_count : process (Clk_96, OD, N, NNN)
	   variable latch : boolean := False;
--		variable NNN : std_logic_vector(D_count'range);
	begin
		if OD = '1' then
			--NNN <= (others => '0') when pft = "1101100" or pft = "1100011" else recalculation(D, inn_distance_range);
			D_count <= (others => '0');
			EN_Signal_D <= '0';
			latch := True;
		elsif Clk_96'event and Clk_96 = '1' then
			if Ce_F6 = '1' then --and OD_latch = '1' then 
				if D_count < N + NNN and PI = '1' and latch = True then
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
end Behavioral;