----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:44:18 07/19/2019 
-- Design Name: 
-- Module Name:    Amplitude_signal_ap - Behavioral 
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
library IEEE, ieee_proposed;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use ieee_proposed.fixed_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Amplitude_signal_ap is
generic (
		--amax : integer := 8191;
		amax1 : integer := 34;
		--amax1 : integer := 91;
		amax : integer := 32767;
		dbmax : integer := 70;
		dbmin : integer := 0;
		--nnominal : integer := 16;--real 13.3
		--nnominal : real := 20.0;
		--nnominal : real := 5.2;
		nnominal : real := 7.0;
		ap : boolean := true;
		--nnominal : real := 13.3;
	   data_level: integer := 6;
		int : integer := 11;
		fract : integer := -15
	);
	
	port(
		---��������
		Clk_96 : in std_logic;
		Ce_F6 : in std_logic;
		---������� ������� � �� (0-63 ��), ����� ��� ��� ��-> ���� 
		U : in std_logic_vector ( data_level - 1 downto 0);

		---������� ������� � �����
		U_r : out sfixed(int - 1 downto fract)-- (17 downto 0)
	);
end Amplitude_signal_ap;

architecture Behavioral of Amplitude_signal_ap is
  Signal U_r_i : integer;
  Signal U_r_p : sfixed(int - 1 downto fract);
	--Signal U_r_p : std_logic_vector ( data_level - 1 downto 0);
	Signal U_threshold : std_logic_vector ( data_level - 1 downto 0);
	
    
	type int_array is array (natural range <>) of integer;
	
	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);	

	function kkk(k : integer) return sfixed is
		variable res : sfixed(int - 1 downto fract);
		--variable gamma : real := 2.97;
		--variable gamma : real := 1.0;
		variable gamma : real := real(amax1)/real(nnominal);
	begin
		  res := to_sfixed(((1.4142 * 10.0 ** (real(k)/20.0))) , int - 1, fract);
		 --  res := to_sfixed((10.0 ** (real(k)/20.0)) , int - 1, fract);
		return res;
	end function;
	
	function kkk_pp(k : integer) return sfixed is
		variable res : sfixed(int - 1 downto fract);
		variable gamma : real := real(amax)/real(nnominal);
		--variable gamma : real := 1.0;
	begin
		  res := to_sfixed(((1.4142 * 10.0 ** (real(k)/20.0))), int - 1, fract);
		return res;
	end function;
	
	function make_amplf_table(begin_dB : integer; end_dB : integer) return sfixed_array is
		variable table : sfixed_array(begin_dB to end_dB);
	begin
		for d in begin_dB to end_dB loop
			if  ap = true then
				table(d) := kkk(d);
			else
				table(d) := kkk_pp(d);
			end if;
		end loop;
		return table;
	end function;
	
	
	constant amplf_table : sfixed_array := make_amplf_table(dbmin, dbmax);
	
	--attribute keep : string;
	--attribute keep of U_threshold : signal is "true";
	
begin
  
--  process (Clk_96, Ce_F6)		
--	begin	
--		if Clk_96'event and Clk_96 = '1' then
--			if Ce_F6 = '1' then
--				U_r_p <= amplf_table(to_integer(signed(U)));
--			end if; 
--		end if;
--  end process;

--	process(U)		
--	begin
--		if (U > std_logic_vector(to_unsigned(50, 7))) then
--			U_threshold <= std_logic_vector(to_unsigned(50, 7));
--		else
--			U_threshold <= U;
--		end if;
--	end process;
  
	process (Clk_96, Ce_F6)		
	begin	
		if Clk_96'event and Clk_96 = '1' then
			if Ce_F6 = '1' then
				if U(data_level-1) = '1' then
					U_r <= amplf_table(to_integer(signed( u(data_level - 1) & not(U(data_level - 2 downto 0)))) + 1);
				else
					U_r <= amplf_table(to_integer(signed(U)));
				end if;
			end if; 
		end if;
  end process;

--U_r_p <= to_sfixed(1.77 , int - 1, fract) when ap = true else to_sfixed(1.0 , int - 1, fract) ;

--process (Clk_96, Ce_F6)		
--	begin	
--		if Clk_96'event and Clk_96 = '1' then
--			if Ce_F6 = '1' then
--				if U(data_level-1) = '1' then
--					U_r <= resize (amplf_table(to_integer(signed(U(data_level - 1)  & not(U(data_level - 2 downto 0)))) + 1)* U_r_p , int - 1, fract) ;
--				else
--					U_r <= resize ( amplf_table(to_integer(signed(U))) * U_r_p, int - 1, fract);
--				end if;
--			end if; 
--		end if;
--  end process;
  
--process (Clk_96, Ce_F6, U_threshold)		
--	begin	
--		if Clk_96'event and Clk_96 = '1' then
--			if Ce_F6 = '1' then
--				if U_threshold(data_level-1) = '1' then
--					U_r <= amplf_table(to_integer(signed( U_threshold(data_level - 1) & not(U_threshold(data_level - 2 downto 0)))) + 1);
--				else
--					U_r <= amplf_table(to_integer(signed(U_threshold)));
--				end if;
--			end if; 
--		end if;
--  end process;


end Behavioral;

