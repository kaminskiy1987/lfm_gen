
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	Use ieee.std_logic_arith.all;
	USE ieee.std_logic_unsigned.all;
	USE ieee.numeric_std.all;
--USE std.textio.ALL;
--USE IEEE.std_logic_textio.ALL;

library elementary;
	use elementary.s274types_pkg.all;
	use elementary.all;

entity Distance is

	generic (
	
	   data_pft: integer := 6;
		pft_widht : integer:= 6;
		length_array: int_array :=  (4195, 1959, 2439, 3359, 5607, 7719, 1633, 2113, 2563, 3043 );--  96
		--length_array: int_array :=  (793, 713 );
		--length_array: int_array :=  (210, 190 );
      pft_code : int_array := (0, 4, 6, 10, 12, 14, 21, 23, 25, 27);		
		data_distance : integer := 13
		
				);
	Port(
		Ce_F6 : in std_logic;
		Clk_96 : in std_logic;
		PFT  : in std_logic_vector (data_pft downto 1);

		PI : in std_logic;
		D : in std_logic_vector (data_distance  downto 1);
		--D : in std_logic_vector (14 downto 1);-------?
		OD : in std_logic;
		--P2 : in std_logic_vector (1 downto 0);

		EN_Signal_D : out std_logic:='0'

		);

end Distance;

architecture Behavioral of Distance is

	Signal D_rec : std_logic_vector (data_distance downto 1):=(others => '0');
	Signal D_count : std_logic_vector (data_distance  downto 1):=(others => '0');
	--Signal N : std_logic_vector(9 downto 1):=(others => '0');
	--Signal N : std_logic_vector(13 downto 1):=(others => '0');
	--Signal N : std_logic_vector(14 downto 1):=(others => '0');------?
	Signal N : std_logic_vector(data_distance  downto 1):=(others => '0');
	Signal P2_PFT : std_logic_vector(data_pft downto 1):=(others => '0');
	Signal OD_latch : std_logic :='0';

--------------     ( 1 = 50 )
  function recalculation( a : std_logic_vector) return std_logic_vector is
		 variable res : std_logic_vector(a'range) ;
	begin
	 
			res :=  conv_std_logic_vector(conv_integer(a) / 50 , a'length);
		return res;
		--return a;
	end recalculation;
	
begin

	--P2_PFT <= P2 & PFT;

---
---------------------------------------------------------------------
--Decoders_N : process (P2_PFT)
--begin
--   case P2_PFT is
----	   when "0100" => N <= "101100111"; -- 359 L60
----      when "0000" => N <= "011110001"; -- 241 L40
----	   when "1001" => N <= "011001001"; -- 201 L33	               
----	   when "0001" => N <= "011000001"; -- 193 L32	
----	   when "1010" => N <= "010001001"; -- 137 L22    
---- 	   when "0010" => N <= "010000001"; -- 129 L21
----	   when "1011" => N <= "001100001"; -- 97  L16  
----   	when "0000" => N <= "000111110"; -- 62  L7C3 
--   	  when "0000" => N <= "0001111011101"; -- 62 , 989 L7C3 -   96    6 ?
--        when "0001" => N <= "0110001100101"; -- 199 , 3173 L23 
--        when others => N <= (others => '0');
--		              
--   end case;
--end process;
-------------- pft-----------------------------------------------
	pft1 : process (PFT, Clk_96, Ce_F6 ) 
		variable index : integer ;
	begin
		--if Clk_96'event and Clk_96 = '1' then
		  --    if Ce_F6 = '1' then
					for index in pft_code'range loop
							if (conv_std_logic_vector(pft_code(index), pft_widht) = PFT) then
								N <= conv_std_logic_vector(length_array(index),data_distance);
								exit;
							end if;
					end loop;
		--		end if;
	--	end if;
	end process;

------     ()
------------------------------------------------------------------------
	u_OD_latch : process (OD)
	begin
			  if OD'event and OD = '1' then
						 OD_latch <='1';
			  end if;
	 end process;



	u_D_count : process (Clk_96, Ce_F6, OD, OD_latch)
	   variable latch : boolean := False;
	begin
			  if OD = '1' then
				  D_count <= recalculation(D);
				  EN_Signal_D <= '0';
				  latch := True;
			  elsif Clk_96'event and Clk_96 = '1' then
					  if Ce_F6 = '1' then --and OD_latch = '1' then 
					   if D_count < N and PI = '1' and latch = True then     
						  D_count <= D_count + 1;
						  EN_Signal_D <= '1';
						 else
						   EN_Signal_D <= '0';
						   latch := False;
						 end if;
					  end if; 
			  end if;
	end process;
		 
		
		 
	--u_EN_Signal_D : process (Clk_96, D_count, N, D_rec, PI)
--	begin
--			if PI = '1' then
--			  if Clk_96'event and Clk_96 = '1' then
--				  if Ce_F6 = '1' then
--					  if D_count >= D and  not(D_count >= D +N) then
--					  --if  (D_count <= D ) then
--						  EN_Signal_D <= '1';
--					  else EN_Signal_D <= '0';
--					  end if;
--					end if;
--			  end if;
--			end if;  
--	end process;
	

---------------------------------------------------	


end Behavioral;

