library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;


entity Sinhr is
	port(
	Clk_96 : in std_logic;
	OD : in std_logic;
	Ce_F6 : out std_logic;
	tt : out std_logic_vector
	);
end Sinhr;

architecture Behavioral of Sinhr is

	--signal Latch : std_logic := '0';
	signal Ce_F : std_logic := '0';
	--signal s : std_logic := '0';
	signal t : std_logic_vector (3 downto 0):= (others => '0');
	signal OD_delay : std_logic := '0';
	signal Set_on_OD : std_logic := '0';

begin

--Выделение переднего фронта OD для предустоновки счетчика Ce_F6
	process (Clk_96) 
	begin 
		  if (Clk_96'event and Clk_96='1') then
			 if Ce_F = '1'  then
			 
				OD_delay <= OD; 
				
			 end if;
			 
		   end if;		
	end process; 

Set_on_OD <= OD and not(OD_delay);

--------------------------------Формирование Ce_F6 (6МГц)
	process (Clk_96, Set_on_OD) 
	begin 
		  if Set_on_OD ='1' then
			  t <= "0001";
		  elsif (Clk_96'event and Clk_96='1') then 
				t <= t+1; 
		  end if; 
	end process; 

tt <= t;


	process (Clk_96) 
	begin 
		  if Clk_96'event and Clk_96='1' then 
			  if t = "0001" then
					 Ce_F <= '1';
			  else Ce_F <='0';
			  
			  end if; 
		  end if;
	end process;
	
Ce_F6 <= Ce_F;

--------------------------------------------------------------
end Behavioral;

