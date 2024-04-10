library IEEE;
use IEEE.std_logic_1164.all;
USE std.textio.ALL;

PACKAGE pkg_tb_atr_func IS

type stdlogic_to_char_t is array(std_logic) of character;
constant to_char : stdlogic_to_char_t := (
	'U' => 'U',
	'X' => 'X',
	'0' => '0',
	'1' => '1',
	'Z' => 'Z',
	'W' => 'W',
	'L' => 'L',
	'H' => 'H',
	'-' => '-');
------------------------------------------------------------
function TO_INT(S: in std_logic_vector) return integer;
-- ‘ункция преобразовывает std_logic_vector в integer:
-- TO_INT("00101") равно 5
------------------------------------------------------------
function DK_TO_INT(S: in std_logic_vector) return integer;
-- ‘ункция преобразовывает std_logic_vector из дополнительного
-- кода в integer:
-- DK_TO_INT("11110") равно -2;
-- DK_TO_INT("00010") равно +2;
-- вектор S - убывающий S(N downto 0)
------------------------------------------------------------
function DK_TO_INT_LH(S: in std_logic_vector) return integer;
-- ‘ункция преобразовывает std_logic_vector из дополнительного
-- кода в integer:
-- DK_TO_INT("01111") равно -2;
-- DK_TO_INT("01000") равно +2;
-- вектор S - возрастающий S(0 to N)
------------------------------------------------------------
function TO_STL(arg: integer; size: integer) return std_logic_vector;
-- ‘ункция преобразовывает integer в std_logic_vector, 
-- size - задаваемая мантисса со знаком
-- TO_STL(3, 5) равно  00011;
-- TO_STL(-2, 5) равно 11110;
------------------------------------------------------------
function TO_UNSTL(arg: integer; size: integer) return std_logic_vector;
-- ‘ункция преобразовывает integer в std_logic_vector, 
-- size - задаваемая мантисса без знака,
-- TO_UNSTL(3, 5) равно  00011;
------------------------------------------------------------

function TO_STRING(inp : std_logic_vector) return string;
-- ‘ункция преобразовывает std_logic_vector в строковую переменную:
------------------------------------------------------------
function OKR(arg: integer; max: integer; p: integer) return integer;
-- ‘ункция происводит округление arg, в требуемой мантиссе max,
-- с необходимым порядком p;
------------------------------------------------------------
END pkg_tb_atr_func;


PACKAGE BODY pkg_tb_atr_func IS
-----------------------------------------------------------------
function TO_INT(S: in std_logic_vector) return integer 
is
   variable int : integer;
   variable  SLV: std_logic_vector(S'Length-1 downto 0) := S;
   begin
        int := 0;
        for i in SLV'Length-1 downto 0 loop
            int := int * 2;
            if SLV(i) = '1' then
                int := int + 1;
            end if;
        end loop;
        return int;
end TO_INT; 
-----------------------------------------------------------------
function DK_TO_INT(S: in std_logic_vector) return integer 
is
   variable int : integer;
--   variable  SLV: std_logic_vector(S'low to S'high) := S;
   variable  SLV: std_logic_vector(S'Length-1 downto 0) := S;
   begin
        int := 0;
        for i in SLV'Length-1 downto 0 loop
            int := int * 2;
            if SLV(i) = '1' then
                int := int + 1;
            end if;
        end loop;
  
        if SLV(SLV'Length-1) = '1' then
		     int := int - 2**(SLV'Length);
        end if;
      
-- защЄлка от "минус нуля"

       if int = -2**(SLV'Length-1) then
		     int := 0;
        end if;

        return int;

end DK_TO_INT; 
-----------------------------------------------------------------
function DK_TO_INT_LH(S: in std_logic_vector) return integer 
is
   variable int : integer;
   variable  SLV: std_logic_vector(S'low to S'high) := S;
 --variable  SLV: std_logic_vector(S'high downto S'low) := S;
   begin
        int := 0;
        for i in SLV'high-1 downto SLV'low loop
            int := int * 2;
            if SLV(i) = '1' then
                int := int + 1;
            end if;
        end loop;
  
        if SLV(SLV'high) = '1' then 
           int := int - 2**(SLV'high);
        end if;

-- защЄлка от "минус нуля"
      
        if int = - 2**(SLV'high) 
            then int := 0;
        end if;

        return int;
end DK_TO_INT_LH; 
-----------------------------------------------------------------
function TO_STL(arg: integer; size: integer) return std_logic_vector 
is
	variable result: std_logic_vector (size-1 downto 0);
	variable temp: integer;
  begin
	temp := arg;
	for i in 0 to size-1 loop
	    if (temp mod 2) = 1 then
		result(i) := '1';
	    else 
		result(i) := '0';
	    end if;
	    if temp > 0 then
		temp := temp / 2;
	    elsif (temp > integer'low) then
		temp := (temp - 1) / 2; 
	    else
		temp := temp / 2; 
	    end if;
	end loop;
	return result;
end TO_STL;
-----------------------------------------------------------------
function TO_UNSTL(arg: integer; size: integer) return std_logic_vector 
is
	variable result: std_logic_vector (size-1 downto 0);
	variable temp: integer;
  begin
	temp := arg;
	for i in 0 to size-1 loop
	    if (temp mod 2) = 1 then
		result(i) := '1';
	    else 
		result(i) := '0';
	    end if;
	temp := temp / 2;
	end loop;
	return result;
end TO_UNSTL;
-----------------------------------------------------------------
FUNCTION TO_STRING (inp : std_logic_vector) return string
    is
	alias vec : std_logic_vector(1 to inp'length) is inp;
	variable result : string(vec'range);
    begin
	for i in vec'range loop
	    result(i) := to_char(vec(i));
	end loop;
	return result;
end TO_STRING;
-----------------------------------------------------------------
function OKR(arg: integer; max: integer; p: integer) return integer
is

	variable std: std_logic_vector (max-1 downto 0);
	variable std_t: std_logic_vector (max downto 0);
	variable std_norm: std_logic_vector (max-p-1 downto 0);
	variable temp: integer;
  
begin
       
      std := TO_STL(arg,max);
      std_t (max downto 0) := (std (max-1 downto 0)) & ('0');
	    std_norm (max-1-p downto 0) := std (max-1 downto p);
 
      if (std_t(p) = '1') 
             then  temp := DK_TO_INT(std_norm) + 1;
             else  temp := DK_TO_INT(std_norm);          
      end if;


      temp := temp*2**p;

return temp;
end OKR;
-----------------------------------------------------------------
END pkg_tb_atr_func;

