----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:29 05/31/2019 
-- Design Name: 
-- Module Name:    phase_shifter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phase_shifter is
    Port ( 
           Bus2IP_Clk          : in  STD_LOGIC;                     -- частота работы логики
           Bus2IP_Reset        : in  STD_LOGIC;                     -- сброс
           Clk_in              : in  STD_LOGIC;                     -- входной сигнал
           Shift_reg           : in  STD_LOGIC_VECTOR (7 downto 0); -- знчение задержки в тактах Bus2IP_Clk
           counter_reg_test    : out STD_LOGIC_VECTOR (7 downto 0); -- тестовый счетчик
           Clk_out             : out STD_LOGIC                      -- выходной сигнал
          );
end phase_shifter;

architecture Behavioral of phase_shifter is

type state_type is (set_level, wait_high_low, wait_low_high); -- описание машины состояний
signal current_stage  : state_type;                            
signal counter_shift  : STD_LOGIC_VECTOR (7 downto 0); -- внутренний счетчик

begin
shift_fsm : process (Bus2IP_Reset, Bus2IP_Clk, Clk_in, Shift_reg)
begin
        if Shift_reg = x"00" or Bus2IP_Reset = '1' then    -- если задержка нулевая или подан reset
                Clk_out       <= Clk_in;
                counter_shift <= x"01";
                counter_reg_test <= x"01";                      -- тестовый счетчик
                current_stage <= set_level;  
        elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
                case current_stage is
                        when set_level =>  
                                if counter_shift = Shift_reg   then        -- после выставленной задержки, подаём на выход 0 или 1
                                        if Clk_in = '1' then
                                                Clk_out       <= '1';
                                                current_stage <= wait_high_low; 
                                        else
                                                Clk_out       <= '0';
                                                current_stage <= wait_low_high; 
                                        end if;
                                        counter_shift    <= x"01";
                                        counter_reg_test <= x"01";              -- тестовый счетчик
                                elsif counter_shift < Shift_reg   then
                                        counter_shift    <= counter_shift + 1;
                                        counter_reg_test <= counter_shift + 1;  -- тестовый счетчик
                                        current_stage    <= set_level;
                                end if;
                        when wait_high_low =>                   -- ждем переключения 1 на 0 и возвращаемся в set_level
                                if Clk_in = '1' then
                                        current_stage <= wait_high_low;
                                else    
                                        current_stage <= set_level; 
                                end if;
                        when wait_low_high =>                   -- ждем переключения 0 на 1 и возвращаемся в set_level
                                if Clk_in = '0' then
                                        current_stage <= wait_low_high;
                                else    
                                        current_stage <= set_level; 
                                end if;
                        when others => 
                                current_stage    <= set_level;
                end case;
        end if;
end process shift_fsm;


end Behavioral;

