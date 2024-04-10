--------------------------------------------------------------------------------
--    This file is owned and controlled by Xilinx and must be used solely     --
--    for design, simulation, implementation and creation of design files     --
--    limited to Xilinx devices or technologies. Use with non-Xilinx          --
--    devices or technologies is expressly prohibited and immediately         --
--    terminates your license.                                                --
--                                                                            --
--    XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY    --
--    FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY    --
--    PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE             --
--    IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS      --
--    MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY      --
--    CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY       --
--    RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY       --
--    DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE   --
--    IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR          --
--    REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF         --
--    INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A   --
--    PARTICULAR PURPOSE.                                                     --
--                                                                            --
--    Xilinx products are not intended for use in life support appliances,    --
--    devices, or systems.  Use in such applications are expressly            --
--    prohibited.                                                             --
--                                                                            --
--    (c) Copyright 1995-2022 Xilinx, Inc.                                    --
--    All rights reserved.                                                    --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must compile the wrapper file dds_example.vhd when simulating
-- the core, dds_example. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
LIBRARY XilinxCoreLib;
-- synthesis translate_on
ENTITY dds_example IS
  PORT (
    ce : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    we : IN STD_LOGIC;
    data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    poff_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rdy : OUT STD_LOGIC;
    cosine : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    sine : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    phase_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END dds_example;

ARCHITECTURE dds_example_a OF dds_example IS
-- synthesis translate_off
COMPONENT wrapped_dds_example
  PORT (
    ce : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    we : IN STD_LOGIC;
    data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    poff_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rdy : OUT STD_LOGIC;
    cosine : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    sine : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    phase_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

-- Configuration specification
  FOR ALL : wrapped_dds_example USE ENTITY XilinxCoreLib.dds_compiler_v4_0(behavioral)
    GENERIC MAP (
      c_accumulator_width => 32,
      c_amplitude => 0,
      c_channels => 1,
      c_has_ce => 1,
      c_has_channel_index => 0,
      c_has_phase_out => 1,
      c_has_phasegen => 1,
      c_has_rdy => 1,
      c_has_rfd => 0,
      c_has_sclr => 1,
      c_has_sincos => 1,
      c_latency => -1,
      c_mem_type => 1,
      c_negative_cosine => 0,
      c_negative_sine => 0,
      c_noise_shaping => 0,
      c_optimise_goal => 0,
      c_output_width => 16,
      c_outputs_required => 2,
      c_phase_angle_width => 16,
      c_phase_increment => 1,
      c_phase_increment_value => "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0",
      c_phase_offset => 3,
      c_phase_offset_value => "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0",
      c_por_mode => 0,
      c_use_dsp48 => 0,
      c_xdevicefamily => "virtex7"
    );
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_dds_example
  PORT MAP (
    ce => ce,
    clk => clk,
    sclr => sclr,
    we => we,
    data => data,
    poff_in => poff_in,
    rdy => rdy,
    cosine => cosine,
    sine => sine,
    phase_out => phase_out
  );
-- synthesis translate_on

END dds_example_a;
