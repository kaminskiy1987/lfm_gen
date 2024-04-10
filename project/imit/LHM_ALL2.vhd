library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	--use IEEE.std_logic_signed.all;
	Use ieee.std_logic_unsigned.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.all;


entity LHM_ALL2 is

	generic (
			rom_cos : rom_c := (0,0,0) 
        );
	Port(
			Clk_96 : in std_logic;
			Ce_F6 : in std_logic;
			En : in std_logic;

			Rom_cos_all : out integer
 
			);
end LHM_ALL2;

architecture Behavioral of LHM_ALL2 is

		--Signal Data_cos : integer range -64 to 64;
		signal Data_cos : integer;
		--Signal count_addr : std_logic_vector (8 downto 0) := "000000000";
		--signal count_addr : std_logic_vector (12 downto 0) := "0000000000000";------------? 
BEGIN
------------------------------------------------
	process (Clk_96, Ce_F6, EN)
	  
	  variable count_addr : integer := 0;
	--  constant ddd : integer := rom_cos'length;
	begin
			  if Clk_96'event and Clk_96 = '1' then
					if Ce_F6 = '1' then
						--count_addr := count_addr+1;
							if EN = '1' then
							    Data_cos <= rom_cos(conv_integer(count_addr));
									if count_addr < ( rom_cos'length-1) then
										 count_addr := count_addr+1;
									end if;
							else Data_cos <= 0;
								  count_addr := 0;
							end if;
					 end if;
				end if;
	end process;



	Rom_cos_all <= Data_cos when rising_edge(Clk_96);
-----------------------------------------------------
end Behavioral;