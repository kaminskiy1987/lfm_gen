
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_signed.all;

entity ADD_rnd is
Port(
Clk_6 : in std_logic;
Clk_96 : in std_logic;
RND_6_X : in std_logic_vector (9 downto 0);
RND_6_Y : in std_logic_vector (9 downto 0);
U_sin : in std_logic_vector (16 downto 0);
U_cos : in std_logic_vector (16 downto 0);

UC1_sin : in std_logic_vector (16 downto 0);
UC1_cos : in std_logic_vector (16 downto 0);

U_rnd_sin : out std_logic_vector (16 downto 0);
U_rnd_cos : out std_logic_vector (16 downto 0)
);

end ADD_rnd;

architecture Behavioral of ADD_rnd is

Signal U_rnd_sin_16 : std_logic_vector (16 downto 0):=(others => '0');
Signal U_rnd_cos_16 : std_logic_vector (16 downto 0):=(others => '0');

begin
------------------------------
process(U_cos, RND_6_X)
begin
        U_rnd_cos_16 <= UC1_cos + U_cos + (RND_6_X(9) & RND_6_X(9) & RND_6_X(9) & RND_6_X(9) & RND_6_X(9) & RND_6_X(9) & RND_6_X(9)  & RND_6_X);
end process;

U_rnd_cos <= U_rnd_cos_16 (16 downto 0);
-------------------------------------------

-----------------------------------------
process(U_sin, RND_6_Y)
begin
        U_rnd_sin_16 <= UC1_cos + U_sin + (RND_6_Y(9) & RND_6_Y(9) & RND_6_Y(9) & RND_6_Y(9) & RND_6_Y(9) & RND_6_Y(9) & RND_6_Y(9)  & RND_6_Y);
end process;

U_rnd_sin <= U_rnd_sin_16 (16 downto 0);
-----------------------------------------
end Behavioral;

