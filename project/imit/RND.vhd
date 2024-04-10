library IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;


entity RND is
Port( Clk_96 : in std_logic;
      Ce_F6 : in std_logic;

		Set : in std_logic;

      RND_6 : out std_logic_vector (9 downto 0);

		tt : in std_logic_vector (3 downto 0)

);		

end RND;

architecture Behavioral of RND is

signal psp_1 : std_logic_vector (31 downto 0) := "11100111110111011110100000111001" ;
signal psp_2 : std_logic_vector (31 downto 0) := "10110010000111110010101100110000" ;
signal psp_3 : std_logic_vector (31 downto 0) := "00101111101100111010010100100011" ;
signal psp_4 : std_logic_vector (31 downto 0) := "00111001110001100110100110010011" ;
signal psp_5 : std_logic_vector (31 downto 0) := "01001010011110101011010010110010" ;
signal psp_6 : std_logic_vector (31 downto 0) := "11001001101110010100100100111011" ;



signal minus_zero : std_logic_vector (5 downto 0):= (others => '0');
signal m_zero : std_logic_vector (5 downto 0):= (others => '0');

signal R : std_logic_vector (9 downto 0):= (others => '0');
signal RND_96 : std_logic_vector (9 downto 0):= (others => '0');


--signal Ce_U : std_logic := '0';
--signal Ce_D : std_logic := '0';
--signal Ce_O : std_logic := '0';
----------------------------------------------------------------------

BEGIN



-------------------------------- ЛСРсОС 
---------------------------------------1
process (Clk_96, Ce_F6, Set)
begin
	if Clk_96'event and Clk_96='1' then  
   if Set = '1' and Ce_F6 = '1'  then
      psp_1 <= "11100111110111011110100000111001" ;
--17.03.17:
--        psp_1 <= "10011011010010011011100100100000" ;
	else
			psp_1(31 downto 1) <= psp_1(30 downto 0);
         psp_1(0) <= not(psp_1(31) xor psp_1(22) xor psp_1(2) xor psp_1(1));
      end if; 
   end if;
end process;

---------------------------------------2
process (Clk_96, Ce_F6, Set)
begin
   if Clk_96'event and Clk_96='1' then
   if Set = '1' and Ce_F6 = '1'  then
      psp_2 <= "10110010000111110010101100110000" ;
--17.03.17:
--        psp_2 <= "10001001100100010100100100000000" ;

	else
		   psp_2(31 downto 1) <= psp_2(30 downto 0);
         psp_2(0) <= not(psp_2(31) xor psp_2(22) xor psp_2(2) xor psp_2(1));
      end if; 
   end if;
end process;

---------------------------------------3
process (Clk_96, Ce_F6, Set)
begin
   if Clk_96'event and Clk_96='1' then
   if Set = '1' and Ce_F6 = '1'  then
      psp_3 <= "00101111101100111010010100100011" ;
--17.03.17:
--        psp_3 <= "11111001100011010111111110000000";
	else
		   psp_3(31 downto 1) <= psp_3(30 downto 0);
         psp_3(0) <= not(psp_3(31) xor psp_3(22) xor psp_3(2) xor psp_3(1));
      end if; 
   end if;
end process;

---------------------------------------4
process (Clk_96, Ce_F6, Set)
begin
   if Clk_96'event and Clk_96='1' then
   if Set = '1' and Ce_F6 = '1'  then
      psp_4 <= "00111001110001100110100110010011" ;
--17.03.17:
--        psp_4 <= "1111110110000101101110111100000";
	else
		 	psp_4(31 downto 1) <= psp_4(30 downto 0);
         psp_4(0) <= not(psp_4(31) xor psp_4(22) xor psp_4(2) xor psp_4(1));
      end if; 
   end if;
end process;
------------------------------------------

---------------------------------------5
process (Clk_96, Ce_F6, Set)
begin
   if Clk_96'event and Clk_96='1' then
   if Set = '1' and Ce_F6 = '1'  then
      psp_5 <= "01001010011110101011010010110010" ;
--17.03.17:
--        psp_5 <= "100100000000101111101010011000000";
	else
		 	psp_5(31 downto 1) <= psp_5(30 downto 0);
         psp_5(0) <= not(psp_5(31) xor psp_5(22) xor psp_5(2) xor psp_5(1));
      end if; 
   end if;
end process;
------------------------------------------

---------------------------------------6
process (Clk_96, Ce_F6, Set)
begin
   if Clk_96'event and Clk_96='1' then
   if Set = '1' and Ce_F6 = '1'  then
      psp_6 <= "11001001101110010100100100111011" ;
		--17.03.17:
	--	  psp_6 <= "11110000110000101101001110100000";
	else
		 	psp_6(31 downto 1) <= psp_6(30 downto 0);
         psp_6(0) <= not(psp_6(31) xor psp_6(22) xor psp_6(2) xor psp_6(1));
      end if; 
   end if;
end process;
------------------------------------------


----------------Формирование Clk_3 (3МГц)

--process (Clk_96) 
--begin 
--     if (Clk_96'event and Clk_96='1') then 
--         t <= t+1; 
--      end if; 
--end process; 

---tt<=t;

--s <= '1' when t(3 downto 0) = "0001" else '0'; 
---ss <=Ce_O;


--process (Clk_96) 
--begin 
--     if (Clk_96'event and Clk_96='1') then 
--         Clk_3 <=s;
--     end if; 
--end process;
 
---Clk_44 <=Clk_3;
-----------------------------------------------

----------------------Синхр для обнуления сумматора

--Ce_U <= Clk_4 when (Clk_96 = '1' and Clk_96'event);

--Ce_O <= Clk_4 when (Clk_96 = '1' and Clk_96'event);

--Ce_O <= Ce_U AND not(Clk_96); 
-----------------------------------------

 ----------------------- компенсирование  (-0) minus_zero (выкарывание)
m_zero <= psp_1(31) & psp_2(31) & psp_3(31) & psp_4(31) & psp_5(31) & psp_6(31);
 
process (m_zero,psp_1(30), psp_2(30), psp_3(30), psp_4(30),psp_5(30), psp_6(30))
begin
	  Case m_zero is
	       when "100000" => minus_zero <= psp_1(30) & psp_2(30) & psp_3(30) & psp_4(30) & psp_5(30) & psp_6(30);  
	       when OTHERS => minus_zero <= m_zero;																					
	  end case;
end process; 
-------------------------------


------------------- Сумматор СП (ПСП -> СП), случайная последовательность с норм. распределением
process (Clk_96)
begin
  
   if Clk_96'event and Clk_96='1' then 
	   RND_96 <=(minus_zero(5) & minus_zero(5) & minus_zero(5) & minus_zero(5) & minus_zero ) ;
   end if;
end process;


	
ADD_RND : process (Clk_96, Ce_F6)
begin
if Clk_96'event and Clk_96='1' then 
   if Ce_F6='1'  then
      R <= "0000000000";
   elsif tt <= "1100" then --else 
	      R <= R + RND_96;
   else 
	      R <= R ;
   end if;
end if;
end process;
-----------------------------------------------------


------------------- Выходной регистр на частоте 6 МГц
RG_OUT_RND : process (Clk_96, Ce_F6)
begin
   if Clk_96'event and Clk_96='1' then 
	   if Ce_F6 = '1' then
	      RND_6 <= R;
       end if;
	end if;
end process;
-----------------------------------------------------




END Behavioral;



