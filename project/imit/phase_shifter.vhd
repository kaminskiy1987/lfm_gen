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
           Bus2IP_Clk          : in  STD_LOGIC;                     -- ������� ������ ������
           Bus2IP_Reset        : in  STD_LOGIC;                     -- �����
           Clk_in              : in  STD_LOGIC;                     -- ������� ������
           Shift_reg           : in  STD_LOGIC_VECTOR (7 downto 0); -- ������� �������� � ������ Bus2IP_Clk
           counter_reg_test    : out STD_LOGIC_VECTOR (7 downto 0); -- �������� �������
           Clk_out             : out STD_LOGIC                      -- �������� ������
          );
end phase_shifter;

architecture Behavioral of phase_shifter is

type state_type is (set_level, wait_high_low, wait_low_high); -- �������� ������ ���������
signal current_stage  : state_type;                            
signal counter_shift  : STD_LOGIC_VECTOR (7 downto 0); -- ���������� �������

begin
shift_fsm : process (Bus2IP_Reset, Bus2IP_Clk, Clk_in, Shift_reg)
begin
        if Shift_reg = x"00" or Bus2IP_Reset = '1' then    -- ���� �������� ������� ��� ����� reset
                Clk_out       <= Clk_in;
                counter_shift <= x"01";
                counter_reg_test <= x"01";                      -- �������� �������
                current_stage <= set_level;  
        elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
                case current_stage is
                        when set_level =>  
                                if counter_shift = Shift_reg   then        -- ����� ������������ ��������, ����� �� ����� 0 ��� 1
                                        if Clk_in = '1' then
                                                Clk_out       <= '1';
                                                current_stage <= wait_high_low; 
                                        else
                                                Clk_out       <= '0';
                                                current_stage <= wait_low_high; 
                                        end if;
                                        counter_shift    <= x"01";
                                        counter_reg_test <= x"01";              -- �������� �������
                                elsif counter_shift < Shift_reg   then
                                        counter_shift    <= counter_shift + 1;
                                        counter_reg_test <= counter_shift + 1;  -- �������� �������
                                        current_stage    <= set_level;
                                end if;
                        when wait_high_low =>                   -- ���� ������������ 1 �� 0 � ������������ � set_level
                                if Clk_in = '1' then
                                        current_stage <= wait_high_low;
                                else    
                                        current_stage <= set_level; 
                                end if;
                        when wait_low_high =>                   -- ���� ������������ 0 �� 1 � ������������ � set_level
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

