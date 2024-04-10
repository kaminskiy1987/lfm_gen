
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_signed.all;

entity MULT_U is
Port(
Ce_F6 : in std_logic;
Clk_96 : in std_logic;
Rom_cos : in std_logic_vector (7 downto 0);
U_r : in std_logic_vector (17 downto 0);
U_cos : out std_logic_vector (17 downto 0)

);

end MULT_U;

architecture Behavioral of MULT_U is

Signal U_cos_30 : std_logic_vector (25 downto 0):=(others => '0');

begin
---------------------------------
process (Clk_96, Ce_F6)
   begin
        if Clk_96'event and Clk_96 = '1' then
           if Ce_F6 = '1' then
                U_cos_30 <= U_r *  Rom_cos;					 
				end if; 
        end if;
    end process;


-------------------------------------------

process (Clk_96, Ce_F6)
   begin
        if Clk_96'event and Clk_96 = '1' then
           if Ce_F6 = '1' then
--				 U_cos <= U_cos_30(22 downto 6);
--25.03.17
             U_cos <= U_cos_30(23 downto 6);
			  end if; 
        end if;
    end process;


----------------------------------------------
end Behavioral;

