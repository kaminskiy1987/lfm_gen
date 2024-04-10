----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
USE std.textio.ALL;
USE IEEE.std_logic_textio.ALL;

library elementary, ieee_proposed;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	use ieee_proposed.fixed_float_types.all;
	use ieee_proposed.fixed_pkg.all;
	

entity UC2 is

	generic (
		data_rom : integer := 14;
		delay : natural := 480
				);
	Port(

		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		PI : in std_logic;

		--Delay : in integer  range 1 to 30;--*******
--      Delay : in integer ;
		U_cos : in std_logic_vector (data_rom-1 downto 0);
		U_cos_delay : out std_logic_vector (data_rom-1 downto 0)
		);
end UC2;

architecture Behavioral of UC2 is

	--Signal ADDR : std_logic_vector (4 downto 0):= "00001";
	
	--constant addr_width : natural := natural(ieee.math_real.round(ieee.math_real.log2(real(Delay))));
	constant addr_width : integer := integer(round(log2(real(Delay)) + 0.5));
	--constant addr_width : integer := 9;
	Signal ADDR : std_logic_vector (addr_width - 1 downto 0):= (others => '0');

	Signal Delay_b : std_logic_vector (addr_width - 1  downto 0) := conv_std_logic_vector(delay, addr_width);

	type ram_c is array (natural(real(2)**real(addr_width)) - 1 downto 0) of std_logic_vector (data_rom-1 downto 0);
	signal RAM_cos: ram_c;
	--attribute keep : string;
	--attribute keep of ADDR : signal is "true";


	

begin

	--Delay_b <= conv_std_logic_vector(Delay, 5);

---------------------------Àäðåñà äëÿ ÎÇÓ 
	Count_Delay : process (Clk_96, Ce_F6) 
	begin
			if Clk_96'event and Clk_96='1' then
				if Ce_F6='1' then
					if ADDR = Delay_b then
					--	ADDR <= "00001";
						ADDR <= (others => '0');
					else 
						ADDR <= ADDR + 1; 
					
					end if;
				end if;
			end if;
	end process;
	-----------------------------------
	RAM_Delay_C : process (Clk_96, Ce_F6, PI)
	begin
			  if Clk_96'event and Clk_96 = '1' then
					if Ce_F6 = '1' then
						 if PI = '1' then
							U_cos_delay <= RAM_cos(conv_integer(ADDR));
							RAM_cos(conv_integer(ADDR)) <= U_cos;							 
						 else 
							 U_cos_delay <= (others => '0');
							 
						 end if;
					end if;
			  end if;
	end process;
-----------------------------------
end Behavioral;

