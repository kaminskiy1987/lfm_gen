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


entity Amplitude_signal1 is

	generic (
		amax : integer := 8191;
		dbmax : integer := 60;
		dbmin : integer := -30;
		--nnominal : integer := 16;--real 13.3
		--nnominal : real := 14.0;
		nnominal : real := 20.0; --used
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
end Amplitude_signal1;

architecture Behavioral of Amplitude_signal1 is

	Signal U_r_i : integer;
	Signal U_r_p : std_logic_vector ( data_level - 1 downto 0);
	Signal U_threshold : std_logic_vector ( data_level - 1 downto 0);
	
    
	type int_array is array (natural range <>) of integer;
	
	type sfixed_array is array (integer range <>) of sfixed(int - 1 downto fract);	

--	function kkk(k : integer) return sfixed is
--		variable res : sfixed(int - 1 downto fract);
--		variable gamma : real := real(amax)/real(nnominal);
--	begin
--		
--		  res := to_sfixed(((10.0 ** (real(k)/20.0))/gamma), int - 1, fract);
--		return res;
--	end function;
	
	function kkk(k : integer) return sfixed is
		variable res : sfixed(int - 1 downto fract);
		variable gamma : real := real(amax)/real(nnominal);
	begin
		res := to_sfixed(((10.0 ** (real(k)/20.0))/gamma), int - 1, fract);
		return res;
	end function;
	
	function make_amplf_table(begin_dB : integer; end_dB : integer) return sfixed_array is
		variable table : sfixed_array(begin_dB to end_dB);
	begin
		for d in begin_dB to end_dB loop
		   table(d) := kkk(d);
		end loop;
		return table;
	end function;
	
	
	constant amplf_table : sfixed_array := make_amplf_table(dbmin, dbmax);
	
	--attribute keep : string;
	--attribute keep of U_r : signal is "true";	
	--attribute keep of U_threshold : signal is "true";
	
begin
  
 -- process(U)		
--	begin	
			--if (U > std_logic_vector(to_unsigned(89, 7))) then
--				U_threshold <= std_logic_vector(to_unsigned(89, 7));
--			else
--			  U_threshold <= U;
--			end if; 
--  end process;
  
 -- process(U)		
--	begin
--	  if (U >= std_logic_vector(to_unsigned(65, 7))) then
--	     if (U > std_logic_vector(to_unsigned(89, 7))) then
--				  U_threshold <= std_logic_vector(to_unsigned(89, 7));
--			 else 
--			    U_threshold <= U;
--			 end if;
--		 elsif (U = std_logic_vector(to_unsigned(64, 7))) then
--		      U_threshold <= U;
--	   else 
--	     if (U > std_logic_vector(to_unsigned(50, 7))) then
--			   U_threshold <= std_logic_vector(to_unsigned(50, 7));
--			 else
--			   U_threshold <= U;
--			 end if;
--			end if; 
--  end process;
  
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
  
 -- process (Clk_96, Ce_F6, U_threshold)		
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

