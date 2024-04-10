----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:39:16 08/14/2019 
-- Design Name: 
-- Module Name:    mux_signal_ram - Behavioral 
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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:27 08/09/2019 
-- Design Name: 
-- Module Name:    mux_signal_ram - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
USE std.textio.ALL;
USE IEEE.std_logic_textio.ALL;

library elementary, ieee_proposed;
	use elementary.s274types_pkg.all;
	use elementary.utility.all;
	use elementary.all;
	use ieee_proposed.fixed_float_types.all;
	use ieee_proposed.fixed_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_signal_ram is
Generic (
		DATA_WIDTH		: integer := 8;
		delay : natural := 4000;
		del	: integer := 4000 
	);
	Port ( 
		Clock 	: in  STD_LOGIC;
      Reset 	: in  STD_LOGIC;
		PIPP		: in  STD_LOGIC;
		PIC		: in  STD_LOGIC;
		DataIn 	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		--Address	: in  STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
		WriteEn	: in  STD_LOGIC;
		readEn	: in  STD_LOGIC;
		readEnPP	: in  STD_LOGIC;
		Enable 	: in  STD_LOGIC;
		DataOut_PP	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		DataOut 	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
	);

end mux_signal_ram;

architecture Behavioral of mux_signal_ram is

	constant addr_width : integer := integer(round(log2(real(Delay)) + 0.5));
	type ram_c is array (natural(real(2)**real(addr_width)) - 1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
	signal RAM_cos: ram_c;
	
	--constant addr_width : integer := integer(round(log2(real(Delay)) + 0.5));
	--constant addr_width : integer := 9;
	Signal ADDR_r : std_logic_vector (addr_width - 1 downto 0):= (others => '0');--(others => '0');
	Signal ADDR_w : std_logic_vector (addr_width - 1 downto 0):= (others => '0');
	Signal ADDR_PP : std_logic_vector (addr_width - 1 downto 0):= conv_std_logic_vector(del, addr_width);

	Signal Delay_b : std_logic_vector (addr_width - 1  downto 0) := conv_std_logic_vector(delay, addr_width);
	Signal DataOut_i 	: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0):= (others => '0');
	
	--attribute keep : string;
	--attribute keep of ADDR_r : signal is "true";
	--attribute keep of DataOut : signal is "true";
	

begin

--Count_Delay : process (Clock) 
--	begin
--			if rising_edge(Clock) then
--				--if Ce_F6='1' then
--					if ADDR = Delay_b then
--					--	ADDR <= "00001";
--						ADDR <= (others => '0');
--					else 
--						ADDR <= ADDR + 1; 
--					
--					end if;
--				end if;
----			end if;
--	end process;
	
	
-- Read process UC1
	process (Clock)
	begin
		if rising_edge(Clock) then
--			if Reset = '1' then
----				-- Clear DataOut on Reset
--				DataOut <= (others => '0');
			 if Enable = '1' then
				if readEn = '1' and PIC = '1' then
--					 If WriteEn then pass through DIn
--					DataOut <= DataIn;
--				else
--					 Otherwise Read Memory
					ADDR_r <= ADDR_r + 1;
				--	DataOut <= RAM_cos(conv_integer(ADDR_r));
				else
					ADDR_r <= (others => '0');
				--	DataOut <= (others => '0');
				end if;
			end if;
		end if;
	end process;
-- -- Read process UC1
--	process (Clock)
--	begin
--		if rising_edge(Clock) then
----			if Reset = '1' then
----				-- Clear DataOut on Reset
----				DataOut <= (others => '0');
--			 if Enable = '1' then
----				if readEn = '1' and PIC = '1' then
--				if readEn = '1' then
--					If ADDR_r < Delay_b then 
--					 ADDR_r <= ADDR_r + 1;
--					elsif ADDR_r = Delay_b then
--					 ADDR_r <= (others => '0');
--					elsif ADDR_r > Delay_b then
--					ADDR_r <= ADDR_r + 1;
--					end if;
--				--	DataOut <= RAM_cos(conv_integer(ADDR_r));
--				else
--					ADDR_r <= (others => '0');
--				--	DataOut <= (others => '0');
--				end if;
--			end if;
--		end if;
--	end process;
 -- Read process PP
	process (Clock)
	begin
		if rising_edge(Clock) then
--			if Reset = '1' then
--				-- Clear DataOut on Reset
--				DataOut <= (others => '0');
			 if Enable = '1' then
				if readEnPP = '1' and PIPP = '1' then
					
						ADDR_PP <= ADDR_PP - 1;
						DataOut_PP <= RAM_cos(conv_integer(ADDR_PP));
				else
						ADDR_PP <= conv_std_logic_vector(del, addr_width);
						DataOut_PP <= (others => '0');
				end if;
				
			 end if;
			
		end if;
	end process;
	
--	-- Read process
--	process (Clock)
--	begin
--		if rising_edge(Clock) then
----			if Reset = '1' then
----				-- Clear DataOut on Reset
----				DataOut <= (others => '0');
--			 if Enable = '1' then
--				if readEn = '1' then
--					 If PIPP = '1' then
--							ADDR_r <= ADDR_r - 1;
--					 else
--					-- Otherwise Read Memory
--					      ADDR_r <= ADDR_r + 1;
--					 end if;
--					DataOut <= RAM_cos(conv_integer(ADDR_r));
--				else
--					--ADDR_r <= (others => '0');
--					ADDR_r <= conv_std_logic_vector(delay, addr_width);
--					DataOut <= (others => '0');
--				end if;
--			end if;
--		end if;
--	end process;

	-- Write process LFM_modul_g
	process (Clock)
	begin
		if rising_edge(Clock) then
--			if Reset = '1' then
--				-- Clear Memory on Reset
--				for i in Memory'Range loop
--					Memory(i) <= (others => '0');
--				end loop;
			if Enable = '1' then
				if WriteEn = '1' then
					-- Store DataIn to Current Memory Address
					ADDR_w <= ADDR_w + 1;
				--	RAM_cos(conv_integer(ADDR_w)) <= DataIn;
				else
					--RAM_cos(conv_integer(ADDR)) <= (others => '0');
					ADDR_w <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	
--	-- Read process UC1
--	process (Clock)
--	begin
--		if rising_edge(Clock) then
----			if Reset = '1' then
------				-- Clear DataOut on Reset
----				DataOut <= (others => '0');
--			 if Enable = '1' then
--				if readEn = '1' and PIC = '1' then
----					 If WriteEn then pass through DIn
----					DataOut <= DataIn;
----				else
----					 Otherwise Read Memory
--					ADDR_r <= ADDR_r + 1;
--				--	DataOut <= RAM_cos(conv_integer(ADDR_r));
--				else
--					ADDR_r <= (others => '0');
--				--	DataOut <= (others => '0');
--				end if;
--			end if;
--		end if;
--	end process;

rw: process (ADDR_w, ADDR_r, clock, DataIn) is
	begin
		if rising_edge(clock) then
			RAM_cos(conv_integer(ADDR_w)) <= DataIn;
			DataOut_i <= RAM_cos(conv_integer(ADDR_r));
		--	DataOut_PP <= RAM_cos(conv_integer(ADDR_PP));
		end if;
	end process rw;
	
	DataOut <= DataOut_i and readEn when rising_edge(clock);
-- Read process
--	process (Clock)
--	begin
--		if rising_edge(Clock) then
----			if Reset = '1' then
----				-- Clear DataOut on Reset
----				DataOut <= (others => '0');
--			 if Enable = '1' then
--				if readEn = '1' then
--					-- If WriteEn then pass through DIn
----					DataOut <= DataIn;
----				else
--					-- Otherwise Read Memory
--					ADDR <= ADDR + 1;
--					DataOut <= RAM_cos(conv_integer(ADDR));
--				else
--					ADDR <= (others => '0');
--					DataOut <= (others => '0');
--				end if;
--			end if;
--		end if;
--	end process;

end Behavioral;




