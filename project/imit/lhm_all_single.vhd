

library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	--use IEEE.std_logic_signed.all;
	Use ieee.std_logic_unsigned.all;
	
library elementary;
	use elementary.s274types_pkg.all;
	use elementary.all;


entity LHM_ALL_single is

	generic (
			rom_cos : rom_c := (0,0,0) 
        );
	Port(
			Clk_96 : in std_logic;
			Ce_F6 : in std_logic;
			En : in std_logic;
			Rom_cos_all : out integer
			);
end LHM_ALL_single;

architecture Behavioral of LHM_ALL_single is

		--Signal Data_cos : integer range -64 to 64;
		signal Data_cos, Data_cos_plus, Data_cos_minus, Data_cos_plus2, Data_cos_minus2 : integer;
		signal Rom_cos1, Rom_cos2 : integer;
		signal count_addr : integer := 0;
		--signal count_addr2 : integer := 7526;
		signal count_addr2 : integer := 961;
		signal count_addr3 : integer := 0;
		--signal count_addr4 : integer := 7526;
		signal count_addr4 : integer := 1787;
		--Signal count_addr : std_logic_vector (8 downto 0) := "000000000";
		--signal count_addr : std_logic_vector (12 downto 0) := "0000000000000";------------? 
BEGIN

----------------------------------------------------------L11-------------------------------------------------	
process (Clk_96, EN)
	 -- variable count_addr : integer := 0;
	begin
	      if en = '0' then
	        count_addr <= 0;
	        Data_cos_plus <= 0;
			  elsif rising_edge(clk_96) then
	--		   if Sign_LCHM = '1' then
			    if(count_addr < 961) then
			  --  if(count_addr < 16346) then
				    Data_cos_plus <= rom_cos(conv_integer(count_addr));
						 if count_addr < ( rom_cos'length-1) then
								count_addr <= count_addr + 1;
						 end if;		   
					else
			        count_addr <= 0;
			        Data_cos_plus <= rom_cos(conv_integer(count_addr));
						 if count_addr < ( rom_cos'length-1) then
								count_addr <= count_addr + 1;
						 end if;		   
          end if;	
--				end if;
				end if;
	      end process;
	
	      

process (Clk_96, Data_cos_plus)
	begin
	 if rising_edge(clk_96) then
   --  if Sign_LCHM = '1' then
       Rom_cos1 <= Data_cos_plus;
    end if;	
--  end if;	
   end process;
	--Rom_cos_all<=Data_cos;
	
	
	Rom_cos_all <= Rom_cos1 when rising_edge(Clk_96);
-----------------------------------------------------
end Behavioral;

