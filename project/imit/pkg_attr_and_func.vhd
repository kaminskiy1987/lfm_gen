library IEEE;
use IEEE.std_logic_1164.all;

PACKAGE   pkg_attr_and_func IS

  attribute INIT   		: string;
  attribute RLOC   		: string;
  attribute RLOC_ORIGIN : string;
  attribute LOC    		: string;
  attribute IOB    		: string;
  attribute HU_SET 		: string;
  attribute KEEP_HIERARCHY : string;
  attribute BOX_TYPE 	: string ;

FUNCTION str2slv (str : string) return bit_vector;

END pkg_attr_and_func;

PACKAGE BODY pkg_attr_and_func IS

-- функция перевода параметра INIT в 16-ричный код для LUT4 

 FUNCTION str2slv (str : string) return bit_vector is
    variable result : bit_vector (str'length*4-1 downto 0);
  begin
    for i in 0 to str'length-1 loop
      case str(str'high-i) is
        when '0'       => result(i*4+3 downto i*4) := x"0";
        when '1'       => result(i*4+3 downto i*4) := x"1";
        when '2'       => result(i*4+3 downto i*4) := x"2";
        when '3'       => result(i*4+3 downto i*4) := x"3";
        when '4'       => result(i*4+3 downto i*4) := x"4";
        when '5'       => result(i*4+3 downto i*4) := x"5";
        when '6'       => result(i*4+3 downto i*4) := x"6";
        when '7'       => result(i*4+3 downto i*4) := x"7";
        when '8'       => result(i*4+3 downto i*4) := x"8";
        when '9'       => result(i*4+3 downto i*4) := x"9";
        when 'a' | 'A' => result(i*4+3 downto i*4) := x"A";
        when 'b' | 'B' => result(i*4+3 downto i*4) := x"B";
        when 'c' | 'C' => result(i*4+3 downto i*4) := x"C";
        when 'd' | 'D' => result(i*4+3 downto i*4) := x"D";
        when 'e' | 'E' => result(i*4+3 downto i*4) := x"E";
        when 'f' | 'F' => result(i*4+3 downto i*4) := x"F";
        when others => result(i*4+3 downto i*4) := "0000";
      end case;
    end loop;

    return result;
  end str2slv;

end;

