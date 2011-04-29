--
-- Copyright (c) 2010 Ricardo Menotti, All Rights Reserved.
--
-- Permission to use, copy, modify, and distribute this software and its
-- documentation for NON-COMERCIAL purposes and without fee is hereby granted 
-- provided that this copyright notice appears in all copies.
--
-- RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
-- OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
-- NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES
-- SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
-- SOFTWARE OR ITS DERIVATIVES.
--
-- Generated at Fri Apr 29 18:24:03 BRT 2011
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_sobel_alt is
end t_sobel_alt;

architecture behavior of t_sobel_alt is

component sobel_alt
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\d_H_O0\	: out	std_logic_vector(15 downto 0);
		\d_H_if_lt_op_s_0_O0\	: out	std_logic_vector(0 downto 0);
		\d_H_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_Hpos_O0\	: out	std_logic_vector(15 downto 0);
		\d_Hpos_add_op_s_Vpos_O0\	: out	std_logic_vector(15 downto 0);
		\d_O_O0\	: out	std_logic_vector(15 downto 0);
		\d_O_if_gt_op_s_255_O0\	: out	std_logic_vector(0 downto 0);
		\d_Otrunk_O0\	: out	std_logic_vector(15 downto 0);
		\d_V_O0\	: out	std_logic_vector(15 downto 0);
		\d_V_if_lt_op_s_0_O0\	: out	std_logic_vector(0 downto 0);
		\d_V_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_Vpos_O0\	: out	std_logic_vector(15 downto 0);
		\d_c106_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_c107_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c108_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c109_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c110_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c111_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c112_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c113_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c114_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c115_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c116_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c117_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c118_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c119_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c120_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c121_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c122_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c123_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c124_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c125_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c126_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c127_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c128_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c129_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_c130_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_i00_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00_neg_op_s__O0\	: out	std_logic_vector(15 downto 0);
		\d_i00h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00h_add_op_s_i01h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00hi01h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00hi01h_add_op_s_i02h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00hi01h_add_op_s_i02h_delay_op_1_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_i00hi01hi02h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00hi01hi02h_add_op_s_i20hi21hi22h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00v_add_op_s_i10v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00vi10v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00vi10v_add_op_s_i20v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00vi10v_add_op_s_i20v_delay_op_1_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_i00vi10vi20v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i00vi10vi20v_add_op_s_i02vi12vi22v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i01_O0\	: out	std_logic_vector(15 downto 0);
		\d_i01_add_op_s_i01_O0\	: out	std_logic_vector(15 downto 0);
		\d_i01_add_op_s_i01_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_i01h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02v_add_op_s_i12v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02vi12v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02vi12v_add_op_s_i22v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i02vi12v_add_op_s_i22v_delay_op_1_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_i02vi12vi22v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i03_O0\	: out	std_logic_vector(15 downto 0);
		\d_i04_O0\	: out	std_logic_vector(15 downto 0);
		\d_i05_O0\	: out	std_logic_vector(15 downto 0);
		\d_i06_O0\	: out	std_logic_vector(15 downto 0);
		\d_i07_O0\	: out	std_logic_vector(15 downto 0);
		\d_i08_O0\	: out	std_logic_vector(15 downto 0);
		\d_i09_O0\	: out	std_logic_vector(15 downto 0);
		\d_i10_O0\	: out	std_logic_vector(15 downto 0);
		\d_i10_add_op_s_i10_O0\	: out	std_logic_vector(15 downto 0);
		\d_i10_add_op_s_i10_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_i10v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i11_O0\	: out	std_logic_vector(15 downto 0);
		\d_i12_O0\	: out	std_logic_vector(15 downto 0);
		\d_i12_add_op_s_i12_O0\	: out	std_logic_vector(15 downto 0);
		\d_i12v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i13_O0\	: out	std_logic_vector(15 downto 0);
		\d_i14_O0\	: out	std_logic_vector(15 downto 0);
		\d_i15_O0\	: out	std_logic_vector(15 downto 0);
		\d_i16_O0\	: out	std_logic_vector(15 downto 0);
		\d_i17_O0\	: out	std_logic_vector(15 downto 0);
		\d_i18_O0\	: out	std_logic_vector(15 downto 0);
		\d_i19_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20_neg_op_s_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20h_add_op_s_i21h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20hi21h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20hi21h_add_op_s_i22h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20hi21h_add_op_s_i22h_delay_op_1_a_delayed\	: out	std_logic_vector(15 downto 0);
		\d_i20hi21hi22h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i20v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i21_O0\	: out	std_logic_vector(15 downto 0);
		\d_i21_add_op_s_i21_O0\	: out	std_logic_vector(15 downto 0);
		\d_i21h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i22_O0\	: out	std_logic_vector(15 downto 0);
		\d_i22h_O0\	: out	std_logic_vector(15 downto 0);
		\d_i22v_O0\	: out	std_logic_vector(15 downto 0);
		\d_i_done\	: out	std_logic;
		\d_i_output\	: out	std_logic_vector(15 downto 0);
		\d_i_step\	: out	std_logic;
		\d_i_step_delay_op_25____________a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25___________a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25__________a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25_________a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25________a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25_______a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25______a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25_____a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25____a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25___a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25__a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_i_step_delay_op_25_a_delayed\	: out	std_logic_vector(0 downto 0);
		\d_input_data_out\	: out	std_logic_vector(15 downto 0);
		\d_output_data_out\	: out	std_logic_vector(15 downto 0);
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(15 downto 0)
	);
end component;

signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \d_H_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_H_if_lt_op_s_0_O0\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_H_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_Hpos_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_Hpos_add_op_s_Vpos_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_O_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_O_if_gt_op_s_255_O0\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_Otrunk_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_V_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_V_if_lt_op_s_0_O0\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_V_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_Vpos_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_c106_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_c107_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c108_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c109_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c110_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c111_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c112_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c113_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c114_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c115_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c116_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c117_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c118_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c119_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c120_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c121_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c122_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c123_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c124_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c125_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c126_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c127_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c128_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c129_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_c130_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00_neg_op_s__O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00h_add_op_s_i01h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00hi01h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00hi01h_add_op_s_i02h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00hi01h_add_op_s_i02h_delay_op_1_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00hi01hi02h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00hi01hi02h_add_op_s_i20hi21hi22h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00v_add_op_s_i10v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00vi10v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00vi10v_add_op_s_i20v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00vi10v_add_op_s_i20v_delay_op_1_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00vi10vi20v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i00vi10vi20v_add_op_s_i02vi12vi22v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i01_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i01_add_op_s_i01_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i01_add_op_s_i01_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i01h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02v_add_op_s_i12v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02vi12v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02vi12v_add_op_s_i22v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02vi12v_add_op_s_i22v_delay_op_1_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i02vi12vi22v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i03_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i04_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i05_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i06_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i07_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i08_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i09_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i10_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i10_add_op_s_i10_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i10_add_op_s_i10_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i10v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i11_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i12_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i12_add_op_s_i12_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i12v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i13_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i14_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i15_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i16_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i17_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i18_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i19_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20_neg_op_s_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20h_add_op_s_i21h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20hi21h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20hi21h_add_op_s_i22h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20hi21h_add_op_s_i22h_delay_op_1_a_delayed\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20hi21hi22h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i20v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i21_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i21_add_op_s_i21_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i21h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i22_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i22h_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i22v_O0\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i_done\	: std_logic	:= '0';
signal \d_i_output\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_i_step\	: std_logic	:= '0';
signal \d_i_step_delay_op_25____________a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25___________a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25__________a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25_________a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25________a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25_______a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25______a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25_____a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25____a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25___a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25__a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_i_step_delay_op_25_a_delayed\	: std_logic_vector(0 downto 0)	:= (others => '0');
signal \d_input_data_out\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \d_output_data_out\	: std_logic_vector(15 downto 0)	:= (others => '0');
signal \done\	: std_logic	:= '0';
signal \init\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \result\	: std_logic_vector(15 downto 0)	:= (others => '0');

begin

uut: sobel_alt
port map (
	\clear\ => \clear\,
	\clk\ => \clk\,
	\d_H_O0\ => \d_H_O0\,
	\d_H_if_lt_op_s_0_O0\ => \d_H_if_lt_op_s_0_O0\,
	\d_H_neg_op_s_O0\ => \d_H_neg_op_s_O0\,
	\d_Hpos_O0\ => \d_Hpos_O0\,
	\d_Hpos_add_op_s_Vpos_O0\ => \d_Hpos_add_op_s_Vpos_O0\,
	\d_O_O0\ => \d_O_O0\,
	\d_O_if_gt_op_s_255_O0\ => \d_O_if_gt_op_s_255_O0\,
	\d_Otrunk_O0\ => \d_Otrunk_O0\,
	\d_V_O0\ => \d_V_O0\,
	\d_V_if_lt_op_s_0_O0\ => \d_V_if_lt_op_s_0_O0\,
	\d_V_neg_op_s_O0\ => \d_V_neg_op_s_O0\,
	\d_Vpos_O0\ => \d_Vpos_O0\,
	\d_c106_a_delayed\ => \d_c106_a_delayed\,
	\d_c107_a_delayed\ => \d_c107_a_delayed\,
	\d_c108_a_delayed\ => \d_c108_a_delayed\,
	\d_c109_a_delayed\ => \d_c109_a_delayed\,
	\d_c110_a_delayed\ => \d_c110_a_delayed\,
	\d_c111_a_delayed\ => \d_c111_a_delayed\,
	\d_c112_a_delayed\ => \d_c112_a_delayed\,
	\d_c113_a_delayed\ => \d_c113_a_delayed\,
	\d_c114_a_delayed\ => \d_c114_a_delayed\,
	\d_c115_a_delayed\ => \d_c115_a_delayed\,
	\d_c116_a_delayed\ => \d_c116_a_delayed\,
	\d_c117_a_delayed\ => \d_c117_a_delayed\,
	\d_c118_a_delayed\ => \d_c118_a_delayed\,
	\d_c119_a_delayed\ => \d_c119_a_delayed\,
	\d_c120_a_delayed\ => \d_c120_a_delayed\,
	\d_c121_a_delayed\ => \d_c121_a_delayed\,
	\d_c122_a_delayed\ => \d_c122_a_delayed\,
	\d_c123_a_delayed\ => \d_c123_a_delayed\,
	\d_c124_a_delayed\ => \d_c124_a_delayed\,
	\d_c125_a_delayed\ => \d_c125_a_delayed\,
	\d_c126_a_delayed\ => \d_c126_a_delayed\,
	\d_c127_a_delayed\ => \d_c127_a_delayed\,
	\d_c128_a_delayed\ => \d_c128_a_delayed\,
	\d_c129_a_delayed\ => \d_c129_a_delayed\,
	\d_c130_a_delayed\ => \d_c130_a_delayed\,
	\d_i00_O0\ => \d_i00_O0\,
	\d_i00_neg_op_s_O0\ => \d_i00_neg_op_s_O0\,
	\d_i00_neg_op_s__O0\ => \d_i00_neg_op_s__O0\,
	\d_i00h_O0\ => \d_i00h_O0\,
	\d_i00h_add_op_s_i01h_O0\ => \d_i00h_add_op_s_i01h_O0\,
	\d_i00hi01h_O0\ => \d_i00hi01h_O0\,
	\d_i00hi01h_add_op_s_i02h_O0\ => \d_i00hi01h_add_op_s_i02h_O0\,
	\d_i00hi01h_add_op_s_i02h_delay_op_1_a_delayed\ => \d_i00hi01h_add_op_s_i02h_delay_op_1_a_delayed\,
	\d_i00hi01hi02h_O0\ => \d_i00hi01hi02h_O0\,
	\d_i00hi01hi02h_add_op_s_i20hi21hi22h_O0\ => \d_i00hi01hi02h_add_op_s_i20hi21hi22h_O0\,
	\d_i00v_O0\ => \d_i00v_O0\,
	\d_i00v_add_op_s_i10v_O0\ => \d_i00v_add_op_s_i10v_O0\,
	\d_i00vi10v_O0\ => \d_i00vi10v_O0\,
	\d_i00vi10v_add_op_s_i20v_O0\ => \d_i00vi10v_add_op_s_i20v_O0\,
	\d_i00vi10v_add_op_s_i20v_delay_op_1_a_delayed\ => \d_i00vi10v_add_op_s_i20v_delay_op_1_a_delayed\,
	\d_i00vi10vi20v_O0\ => \d_i00vi10vi20v_O0\,
	\d_i00vi10vi20v_add_op_s_i02vi12vi22v_O0\ => \d_i00vi10vi20v_add_op_s_i02vi12vi22v_O0\,
	\d_i01_O0\ => \d_i01_O0\,
	\d_i01_add_op_s_i01_O0\ => \d_i01_add_op_s_i01_O0\,
	\d_i01_add_op_s_i01_neg_op_s_O0\ => \d_i01_add_op_s_i01_neg_op_s_O0\,
	\d_i01h_O0\ => \d_i01h_O0\,
	\d_i02_O0\ => \d_i02_O0\,
	\d_i02_neg_op_s_O0\ => \d_i02_neg_op_s_O0\,
	\d_i02h_O0\ => \d_i02h_O0\,
	\d_i02v_O0\ => \d_i02v_O0\,
	\d_i02v_add_op_s_i12v_O0\ => \d_i02v_add_op_s_i12v_O0\,
	\d_i02vi12v_O0\ => \d_i02vi12v_O0\,
	\d_i02vi12v_add_op_s_i22v_O0\ => \d_i02vi12v_add_op_s_i22v_O0\,
	\d_i02vi12v_add_op_s_i22v_delay_op_1_a_delayed\ => \d_i02vi12v_add_op_s_i22v_delay_op_1_a_delayed\,
	\d_i02vi12vi22v_O0\ => \d_i02vi12vi22v_O0\,
	\d_i03_O0\ => \d_i03_O0\,
	\d_i04_O0\ => \d_i04_O0\,
	\d_i05_O0\ => \d_i05_O0\,
	\d_i06_O0\ => \d_i06_O0\,
	\d_i07_O0\ => \d_i07_O0\,
	\d_i08_O0\ => \d_i08_O0\,
	\d_i09_O0\ => \d_i09_O0\,
	\d_i10_O0\ => \d_i10_O0\,
	\d_i10_add_op_s_i10_O0\ => \d_i10_add_op_s_i10_O0\,
	\d_i10_add_op_s_i10_neg_op_s_O0\ => \d_i10_add_op_s_i10_neg_op_s_O0\,
	\d_i10v_O0\ => \d_i10v_O0\,
	\d_i11_O0\ => \d_i11_O0\,
	\d_i12_O0\ => \d_i12_O0\,
	\d_i12_add_op_s_i12_O0\ => \d_i12_add_op_s_i12_O0\,
	\d_i12v_O0\ => \d_i12v_O0\,
	\d_i13_O0\ => \d_i13_O0\,
	\d_i14_O0\ => \d_i14_O0\,
	\d_i15_O0\ => \d_i15_O0\,
	\d_i16_O0\ => \d_i16_O0\,
	\d_i17_O0\ => \d_i17_O0\,
	\d_i18_O0\ => \d_i18_O0\,
	\d_i19_O0\ => \d_i19_O0\,
	\d_i20_O0\ => \d_i20_O0\,
	\d_i20_neg_op_s_O0\ => \d_i20_neg_op_s_O0\,
	\d_i20h_O0\ => \d_i20h_O0\,
	\d_i20h_add_op_s_i21h_O0\ => \d_i20h_add_op_s_i21h_O0\,
	\d_i20hi21h_O0\ => \d_i20hi21h_O0\,
	\d_i20hi21h_add_op_s_i22h_O0\ => \d_i20hi21h_add_op_s_i22h_O0\,
	\d_i20hi21h_add_op_s_i22h_delay_op_1_a_delayed\ => \d_i20hi21h_add_op_s_i22h_delay_op_1_a_delayed\,
	\d_i20hi21hi22h_O0\ => \d_i20hi21hi22h_O0\,
	\d_i20v_O0\ => \d_i20v_O0\,
	\d_i21_O0\ => \d_i21_O0\,
	\d_i21_add_op_s_i21_O0\ => \d_i21_add_op_s_i21_O0\,
	\d_i21h_O0\ => \d_i21h_O0\,
	\d_i22_O0\ => \d_i22_O0\,
	\d_i22h_O0\ => \d_i22h_O0\,
	\d_i22v_O0\ => \d_i22v_O0\,
	\d_i_done\ => \d_i_done\,
	\d_i_output\ => \d_i_output\,
	\d_i_step\ => \d_i_step\,
	\d_i_step_delay_op_25____________a_delayed\ => \d_i_step_delay_op_25____________a_delayed\,
	\d_i_step_delay_op_25___________a_delayed\ => \d_i_step_delay_op_25___________a_delayed\,
	\d_i_step_delay_op_25__________a_delayed\ => \d_i_step_delay_op_25__________a_delayed\,
	\d_i_step_delay_op_25_________a_delayed\ => \d_i_step_delay_op_25_________a_delayed\,
	\d_i_step_delay_op_25________a_delayed\ => \d_i_step_delay_op_25________a_delayed\,
	\d_i_step_delay_op_25_______a_delayed\ => \d_i_step_delay_op_25_______a_delayed\,
	\d_i_step_delay_op_25______a_delayed\ => \d_i_step_delay_op_25______a_delayed\,
	\d_i_step_delay_op_25_____a_delayed\ => \d_i_step_delay_op_25_____a_delayed\,
	\d_i_step_delay_op_25____a_delayed\ => \d_i_step_delay_op_25____a_delayed\,
	\d_i_step_delay_op_25___a_delayed\ => \d_i_step_delay_op_25___a_delayed\,
	\d_i_step_delay_op_25__a_delayed\ => \d_i_step_delay_op_25__a_delayed\,
	\d_i_step_delay_op_25_a_delayed\ => \d_i_step_delay_op_25_a_delayed\,
	\d_input_data_out\ => \d_input_data_out\,
	\d_output_data_out\ => \d_output_data_out\,
	\done\ => \done\,
	\init\ => \init\,
	\reset\ => \reset\,
	\result\ => \result\
);

clock: process
begin
	wait for 5 ns;
	\clk\  <= not \clk\;
end process clock;

stimulus: process
begin
	\reset\  <= '1';
	wait for 50 ns;
	\reset\  <= '0';
	wait for 50 ns;
	\init\  <= '1';
	wait;
end process stimulus;

end behavior;
