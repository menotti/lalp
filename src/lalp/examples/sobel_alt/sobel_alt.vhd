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
entity sobel_alt is
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
end sobel_alt;

architecture behavior of sobel_alt is

component add_op_s
generic (
	w_in1	: integer := 8;
	w_in2	: integer := 8;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component block_ram
generic (
	data_width		: integer := 8;
	address_width	: integer := 8
);
port (
	clk			: in	std_logic;
	we			: in	std_logic := '0';
	oe			: in	std_logic := '1';
	address		: in	std_logic_vector(address_width-1 downto 0);
	data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0');
	data_out	: out	std_logic_vector(data_width-1 downto 0)
);
end component;

component block_ram_input
generic (
	data_width		: integer := 8;
	address_width	: integer := 8
);
port (
	clk			: in	std_logic;
	we			: in	std_logic := '0';
	oe			: in	std_logic := '1';
	address		: in	std_logic_vector(address_width-1 downto 0);
	data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0');
	data_out	: out	std_logic_vector(data_width-1 downto 0)
);
end component;

component counter
generic (
	bits		: integer := 8;
	steps		: integer := 1;
	increment	: integer := 1;
	down	: integer := 0;
	condition : integer := 0
);
port (
	input		: in	std_logic_vector(bits-1 downto 0);
	termination	: in	std_logic_vector(bits-1 downto 0);
	clk			: in	std_logic;
	clk_en		: in	std_logic := '1';
	reset		: in	std_logic;
	load		: in	std_logic := '0';
	step		: out	std_logic;
	done		: out	std_logic;
	output		: out	std_logic_vector(bits-1 downto 0)
);
end component;

component delay_op
generic (
	bits	: integer := 8;
	delay	: integer := 1
);
port (
	a			: in	std_logic_vector(bits-1 downto 0);
	clk			: in	std_logic;
	reset		: in	std_logic;
	a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0')
);
end component;

component if_gt_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component if_lt_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component mux_m_op
generic (
	w_in	: integer := 32;
	N_ops	: integer := 32;
	N_sels	: integer := 31
);
port (
	I0	: in	std_logic_vector((w_in*N_ops)-1 downto 0);
	Sel	: in	std_logic_vector(N_sels-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;
component neg_op_s
generic (
	w_in	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component reg_mux_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	Sel1	: in	std_logic_vector(0 downto 0);
	I0	: in	std_logic_vector(w_in-1 downto 0);
	I1	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

component reg_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	I0	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

signal s0	: std_logic_vector(15 downto 0);
signal s466	: std_logic_vector(0 downto 0);
signal s462	: std_logic_vector(15 downto 0);
signal s411	: std_logic_vector(15 downto 0);
signal s407	: std_logic_vector(0 downto 0);
signal s441	: std_logic_vector(15 downto 0);
signal s445	: std_logic_vector(15 downto 0);
signal s386	: std_logic_vector(15 downto 0);
signal s390	: std_logic_vector(15 downto 0);
signal s394	: std_logic_vector(15 downto 0);
signal s479	: std_logic_vector(15 downto 0);
signal s424	: std_logic_vector(0 downto 0);
signal s369	: std_logic_vector(15 downto 0);
signal s428	: std_logic_vector(0 downto 0);
signal s373	: std_logic_vector(0 downto 0);
signal s458	: std_logic_vector(15 downto 0);
signal s403	: std_logic_vector(0 downto 0);
signal s399	: std_logic_vector(0 downto 0);
signal s111	: std_logic_vector(15 downto 0);
signal s433	: std_logic_vector(15 downto 0);
signal s378	: std_logic_vector(15 downto 0);
signal s437	: std_logic_vector(0 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s382	: std_logic_vector(0 downto 0);
signal s467	: std_logic_vector(15 downto 0);
signal s475	: std_logic_vector(0 downto 0);
signal s471	: std_logic_vector(0 downto 0);
signal s128	: std_logic_vector(15 downto 0);
signal s420	: std_logic_vector(15 downto 0);
signal s416	: std_logic_vector(15 downto 0);
signal s450	: std_logic_vector(15 downto 0);
signal s365	: std_logic_vector(15 downto 0);
signal s454	: std_logic_vector(15 downto 0);
signal s395	: std_logic_vector(15 downto 0);
signal s429	: std_logic_vector(0 downto 0);
signal s425	: std_logic_vector(0 downto 0);
signal s480	: std_logic_vector(15 downto 0);
signal s404	: std_logic_vector(15 downto 0);
signal s463	: std_logic_vector(0 downto 0);
signal s459	: std_logic_vector(15 downto 0);
signal s374	: std_logic_vector(15 downto 0);
signal s370	: std_logic_vector(15 downto 0);
signal s442	: std_logic_vector(15 downto 0);
signal s412	: std_logic_vector(15 downto 0);
signal s408	: std_logic_vector(0 downto 0);
signal s179	: std_logic;
signal s476	: std_logic_vector(15 downto 0);
signal s391	: std_logic_vector(15 downto 0);
signal s387	: std_logic;
signal s446	: std_logic_vector(15 downto 0);
signal s366	: std_logic_vector(0 downto 0);
signal s362	: std_logic_vector(15 downto 0);
signal s451	: std_logic_vector(15 downto 0);
signal s421	: std_logic_vector(0 downto 0);
signal s417	: std_logic_vector(15 downto 0);
signal s400	: std_logic_vector(0 downto 0);
signal s396	: std_logic_vector(15 downto 0);
signal s455	: std_logic_vector(0 downto 0);
signal s438	: std_logic_vector(15 downto 0);
signal s434	: std_logic_vector(15 downto 0);
signal s472	: std_logic_vector(15 downto 0);
signal s413	: std_logic_vector(0 downto 0);
signal s468	: std_logic_vector(15 downto 0);
signal s383	: std_logic_vector(15 downto 0);
signal s379	: std_logic_vector(15 downto 0);
signal s477	: std_logic_vector(0 downto 0);
signal s392	: std_logic_vector(15 downto 0);
signal s388	: std_logic_vector(15 downto 0);
signal s422	: std_logic_vector(15 downto 0);
signal s481	: std_logic_vector(15 downto 0);
signal s443	: std_logic_vector(15 downto 0);
signal s447	: std_logic_vector(0 downto 0);
signal s464	: std_logic_vector(0 downto 0);
signal s405	: std_logic_vector(15 downto 0);
signal s117	: std_logic_vector(15 downto 0);
signal s409	: std_logic_vector(15 downto 0);
signal s426	: std_logic_vector(15 downto 0);
signal s430	: std_logic_vector(15 downto 0);
signal s371	: std_logic_vector(0 downto 0);
signal s375	: std_logic_vector(0 downto 0);
signal s460	: std_logic_vector(15 downto 0);
signal s473	: std_logic_vector(0 downto 0);
signal s414	: std_logic_vector(0 downto 0);
signal s418	: std_logic_vector(0 downto 0);
signal s435	: std_logic_vector(15 downto 0);
signal s439	: std_logic_vector(0 downto 0);
signal s380	: std_logic_vector(15 downto 0);
signal s384	: std_logic_vector(15 downto 0);
signal s469	: std_logic_vector(15 downto 0);
signal s401	: std_logic_vector(0 downto 0);
signal s397	: std_logic_vector(0 downto 0);
signal s431	: std_logic_vector(15 downto 0);
signal s452	: std_logic_vector(15 downto 0);
signal s367	: std_logic_vector(15 downto 0);
signal s363	: std_logic_vector(15 downto 0);
signal s456	: std_logic_vector(0 downto 0);
signal s440	: std_logic_vector(15 downto 0);
signal s410	: std_logic_vector(15 downto 0);
signal s465	: std_logic_vector(15 downto 0);
signal s406	: std_logic_vector(15 downto 0);
signal s461	: std_logic_vector(0 downto 0);
signal s376	: std_logic_vector(0 downto 0);
signal s372	: std_logic_vector(0 downto 0);
signal s427	: std_logic_vector(15 downto 0);
signal s368	: std_logic_vector(15 downto 0);
signal s423	: std_logic_vector(15 downto 0);
signal s482	: std_logic_vector(15 downto 0);
signal s389	: std_logic_vector(15 downto 0);
signal s393	: std_logic_vector(15 downto 0);
signal s478	: std_logic_vector(15 downto 0);
signal s444	: std_logic_vector(15 downto 0);
signal s448	: std_logic_vector(0 downto 0);
signal s377	: std_logic_vector(15 downto 0);
signal s436	: std_logic_vector(15 downto 0);
signal s432	: std_logic_vector(15 downto 0);
signal s398	: std_logic_vector(15 downto 0);
signal s402	: std_logic_vector(15 downto 0);
signal s453	: std_logic_vector(15 downto 0);
signal s457	: std_logic_vector(15 downto 0);
signal s449	: std_logic_vector(0 downto 0);
signal s364	: std_logic_vector(15 downto 0);
signal s419	: std_logic_vector(15 downto 0);
signal s127	: std_logic_vector(15 downto 0);
signal s474	: std_logic_vector(15 downto 0);
signal s415	: std_logic_vector(15 downto 0);
signal s470	: std_logic_vector(0 downto 0);
signal s385	: std_logic;
signal s381	: std_logic_vector(15 downto 0);

begin

	\i02vi12v_add_op_s_i22v_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s435,
		a_delayed => s363,
		clk => \clk\,
		reset => \reset\
	);

	\i20hi21h_add_op_s_i22h_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s434,
		a_delayed => s365,
		clk => \clk\,
		reset => \reset\
	);

	\c119\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s387,
		a_delayed => s366,
		clk => \clk\,
		reset => \reset\
	);

	\output\: block_ram
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s384(6 downto 0),
		clk => \clk\,
		data_in => s379,
		data_out => s368,
		we => s429(0)
	);

	\i08\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s431,
		O0 => s369,
		clk => \clk\,
		reset => \reset\
	);

	\i21_add_op_s_i21\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s481,
		I1 => s481,
		O0 => s370
	);

	\c123\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s387,
		a_delayed => s371,
		clk => \clk\,
		reset => \reset\
	);

	\i00hi01hi02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s392,
		O0 => s374,
		clk => \clk\,
		reset => \reset\,
		we => s437(0)
	);

	\i_step_delay_op_25______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s375,
		clk => \clk\,
		reset => \reset\
	);

	\O\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s409,
		O0 => s378,
		clk => \clk\,
		reset => \reset\,
		we => s413(0)
	);

	\Otrunk\: mux_m_op
	generic map (
		N_ops => 2,
		N_sels => 1,
		w_in => 16
	)
	port map (
		I0(31 downto 16) => s378(15 downto 0),
		I0(15 downto 0) => s128(15 downto 0),
		O0 => s379,
		Sel(0 downto 0) => s447(0 downto 0)
	);

	\c106\: delay_op
	generic map (
		bits => 16,
		delay => 28
	)
	port map (
		a => s386,
		a_delayed => s384,
		clk => \clk\,
		reset => \reset\
	);

	\i\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		clk => \clk\,
		clk_en => s179,
		done => s385,
		input => s0,
		output => s386,
		reset => \reset\,
		step => s387,
		termination => s1
	);

	\i02vi12vi22v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s363,
		O0 => s390,
		clk => \clk\,
		reset => \reset\,
		we => s371(0)
	);

	\i02v_add_op_s_i12v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s415,
		I1 => s438,
		O0 => s391
	);

	\i14\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s460,
		O0 => s393,
		clk => \clk\,
		reset => \reset\
	);

	\i11\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s459,
		O0 => s394,
		clk => \clk\,
		reset => \reset\
	);

	\c111\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s397,
		clk => \clk\,
		reset => \reset\
	);

	\c115\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s400,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s401,
		clk => \clk\,
		reset => \reset\
	);

	\i00_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s416,
		O0 => s404
	);

	\i00hi01hi02h_add_op_s_i20hi21hi22h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s374,
		I1 => s367,
		O0 => s406
	);

	\Hpos_add_op_s_Vpos\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s411,
		I1 => s479,
		O0 => s409
	);

	\Hpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s364,
		I1 => s478,
		O0 => s411,
		Sel1 => s407,
		clk => \clk\,
		reset => \reset\,
		we => s399(0)
	);

	\c128\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s387,
		a_delayed => s413,
		clk => \clk\,
		reset => \reset\
	);

	\i00\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s474,
		O0 => s416,
		clk => \clk\,
		reset => \reset\
	);

	\i00v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s450,
		O0 => s417,
		clk => \clk\,
		reset => \reset\,
		we => s375(0)
	);

	\i_step_delay_op_25________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s418,
		clk => \clk\,
		reset => \reset\
	);

	\i18\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s445,
		O0 => s420,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25___________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s421,
		clk => \clk\,
		reset => \reset\
	);

	\i22h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s457,
		O0 => s426,
		clk => \clk\,
		reset => \reset\,
		we => s376(0)
	);

	\i00h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s404,
		O0 => s427,
		clk => \clk\,
		reset => \reset\,
		we => s470(0)
	);

	\c107\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s387,
		a_delayed => s429,
		clk => \clk\,
		reset => \reset\
	);

	\i10\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s394,
		O0 => s432,
		clk => \clk\,
		reset => \reset\,
		we => s475(0)
	);

	\i00vi10v_add_op_s_i20v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s412,
		I1 => s381,
		O0 => s433
	);

	\i00hi01h_add_op_s_i02h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s444,
		I1 => s446,
		O0 => s436
	);

	\c120\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s387,
		a_delayed => s437,
		clk => \clk\,
		reset => \reset\
	);

	\c124\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s387,
		a_delayed => s439,
		clk => \clk\,
		reset => \reset\
	);

	\i10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s377,
		O0 => s440,
		clk => \clk\,
		reset => \reset\,
		we => s449(0)
	);

	\i07\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s369,
		O0 => s441,
		clk => \clk\,
		reset => \reset\
	);

	\i21h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s370,
		O0 => s443,
		clk => \clk\,
		reset => \reset\,
		we => s448(0)
	);

	\i00hi01h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s467,
		O0 => s444,
		clk => \clk\,
		reset => \reset\,
		we => s473(0)
	);

	\O_if_gt_op_s_255\: if_gt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s378,
		I1 => s127,
		O0 => s447
	);

	\i_step_delay_op_25____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s448,
		clk => \clk\,
		reset => \reset\
	);

	\i10_add_op_s_i10\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s432,
		I1 => s432,
		O0 => s451
	);

	\i03\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s472,
		O0 => s453,
		clk => \clk\,
		reset => \reset\
	);

	\i02vi12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s391,
		O0 => s454,
		clk => \clk\,
		reset => \reset\,
		we => s366(0)
	);

	\c129\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s385,
		a_delayed => s455,
		clk => \clk\,
		reset => \reset\
	);

	\i17\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s420,
		O0 => s458,
		clk => \clk\,
		reset => \reset\
	);

	\i13\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s393,
		O0 => s462,
		clk => \clk\,
		reset => \reset\,
		we => s397(0)
	);

	\c108\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s387,
		a_delayed => s463,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s466,
		clk => \clk\,
		reset => \reset\
	);

	\i00h_add_op_s_i01h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s427,
		I1 => s430,
		O0 => s467
	);

	\i02_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s398,
		O0 => s469
	);

	\i_step_delay_op_25\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s470,
		clk => \clk\,
		reset => \reset\
	);

	\c116\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s387,
		a_delayed => s473,
		clk => \clk\,
		reset => \reset\
	);

	\c112\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s387,
		a_delayed => s475,
		clk => \clk\,
		reset => \reset\
	);

	\i06\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s441,
		O0 => s476,
		clk => \clk\,
		reset => \reset\,
		we => s414(0)
	);

	\V_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s362,
		I1 => s117,
		O0 => s477
	);

	\i00vi10vi20v_add_op_s_i02vi12vi22v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s389,
		I1 => s390,
		O0 => s480
	);

	\i21\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s457,
		O0 => s481,
		clk => \clk\,
		reset => \reset\,
		we => s463(0)
	);

	\V\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s480,
		O0 => s362,
		clk => \clk\,
		reset => \reset\,
		we => s373(0)
	);

	\H\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s406,
		O0 => s364,
		clk => \clk\,
		reset => \reset\,
		we => s439(0)
	);

	\i20hi21hi22h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s365,
		O0 => s367,
		clk => \clk\,
		reset => \reset\,
		we => s372(0)
	);

	\c121\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s387,
		a_delayed => s372,
		clk => \clk\,
		reset => \reset\
	);

	\c125\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s387,
		a_delayed => s373,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s376,
		clk => \clk\,
		reset => \reset\
	);

	\i10_add_op_s_i10_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s451,
		O0 => s377
	);

	\i00vi10v_add_op_s_i20v_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s433,
		a_delayed => s380,
		clk => \clk\,
		reset => \reset\
	);

	\i20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s468,
		O0 => s381,
		clk => \clk\,
		reset => \reset\,
		we => s418(0)
	);

	\i20h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s405,
		O0 => s383,
		clk => \clk\,
		reset => \reset\,
		we => s424(0)
	);

	\c117\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s387,
		a_delayed => s382,
		clk => \clk\,
		reset => \reset\
	);

	\i20hi21h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s465,
		O0 => s388,
		clk => \clk\,
		reset => \reset\,
		we => s428(0)
	);

	\i00vi10vi20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s380,
		O0 => s389,
		clk => \clk\,
		reset => \reset\,
		we => s425(0)
	);

	\i00hi01h_add_op_s_i02h_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s436,
		a_delayed => s392,
		clk => \clk\,
		reset => \reset\
	);

	\V_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s362,
		O0 => s395
	);

	\i05\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s476,
		O0 => s396,
		clk => \clk\,
		reset => \reset\
	);

	\i02\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s453,
		O0 => s398,
		clk => \clk\,
		reset => \reset\
	);

	\c126\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s387,
		a_delayed => s399,
		clk => \clk\,
		reset => \reset\
	);

	\i01_add_op_s_i01\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s474,
		I1 => s474,
		O0 => s402
	);

	\i_step_delay_op_25__\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s403,
		clk => \clk\,
		reset => \reset\
	);

	\i20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s481,
		O0 => s405,
		clk => \clk\,
		reset => \reset\
	);

	\H_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s364,
		I1 => s111,
		O0 => s407
	);

	\c109\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s408,
		clk => \clk\,
		reset => \reset\
	);

	\i16\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s458,
		O0 => s410,
		clk => \clk\,
		reset => \reset\
	);

	\i00vi10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s423,
		O0 => s412,
		clk => \clk\,
		reset => \reset\,
		we => s382(0)
	);

	\c113\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s414,
		clk => \clk\,
		reset => \reset\
	);

	\i02v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s398,
		O0 => s415,
		clk => \clk\,
		reset => \reset\,
		we => s466(0)
	);

	\c130\: delay_op
	generic map (
		bits => 16,
		delay => 2
	)
	port map (
		a => s398,
		a_delayed => s419,
		clk => \clk\,
		reset => \reset\
	);

	\i12_add_op_s_i12\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s459,
		I1 => s459,
		O0 => s422
	);

	\i00v_add_op_s_i10v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s417,
		I1 => s440,
		O0 => s423
	);

	\i_step_delay_op_25___\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s424,
		clk => \clk\,
		reset => \reset\
	);

	\c122\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s387,
		a_delayed => s425,
		clk => \clk\,
		reset => \reset\
	);

	\c118\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s387,
		a_delayed => s428,
		clk => \clk\,
		reset => \reset\
	);

	\i01h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s452,
		O0 => s430,
		clk => \clk\,
		reset => \reset\,
		we => s401(0)
	);

	\i09\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s432,
		O0 => s431,
		clk => \clk\,
		reset => \reset\
	);

	\i20hi21h_add_op_s_i22h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s388,
		I1 => s426,
		O0 => s434
	);

	\i02vi12v_add_op_s_i22v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s454,
		I1 => s442,
		O0 => s435
	);

	\i12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s422,
		O0 => s438,
		clk => \clk\,
		reset => \reset\,
		we => s464(0)
	);

	\i22v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s457,
		O0 => s442,
		clk => \clk\,
		reset => \reset\,
		we => s421(0)
	);

	\i19\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s405,
		O0 => s445,
		clk => \clk\,
		reset => \reset\,
		we => s408(0)
	);

	\i02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s469,
		O0 => s446,
		clk => \clk\,
		reset => \reset\,
		we => s403(0)
	);

	\i_step_delay_op_25_______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s449,
		clk => \clk\,
		reset => \reset\
	);

	\i00_neg_op_s_\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s416,
		O0 => s450
	);

	\i01_add_op_s_i01_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s402,
		O0 => s452
	);

	\c114\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s456,
		clk => \clk\,
		reset => \reset\
	);

	\i22\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s482,
		O0 => s457,
		clk => \clk\,
		reset => \reset\
	);

	\i12\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s462,
		O0 => s459,
		clk => \clk\,
		reset => \reset\
	);

	\i15\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s410,
		O0 => s460,
		clk => \clk\,
		reset => \reset\,
		we => s461(0)
	);

	\c110\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s387,
		a_delayed => s461,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25__________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s387,
		a_delayed => s464,
		clk => \clk\,
		reset => \reset\
	);

	\i20h_add_op_s_i21h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s383,
		I1 => s443,
		O0 => s465
	);

	\i20_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s405,
		O0 => s468
	);

	\c127\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s387,
		a_delayed => s471,
		clk => \clk\,
		reset => \reset\
	);

	\i04\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s396,
		O0 => s472,
		clk => \clk\,
		reset => \reset\,
		we => s456(0)
	);

	\i01\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s419,
		O0 => s474,
		clk => \clk\,
		reset => \reset\,
		we => s400(0)
	);

	\H_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s364,
		O0 => s478
	);

	\Vpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s362,
		I1 => s395,
		O0 => s479,
		Sel1 => s477,
		clk => \clk\,
		reset => \reset\,
		we => s471(0)
	);

	\input\: block_ram_input
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s386(6 downto 0),
		clk => \clk\,
		data_out => s482
	);

	\d_i20_O0\ <= s405;
	\d_i_step_delay_op_25___________a_delayed\ <= s464;
	\d_Hpos_add_op_s_Vpos_O0\ <= s409;
	\d_c124_a_delayed\ <= s439;
	\d_i21h_O0\ <= s443;
	\d_c106_a_delayed\ <= s384;
	\d_i20hi21h_O0\ <= s388;
	\d_V_if_lt_op_s_0_O0\ <= s477;
	\d_i00hi01h_add_op_s_i02h_delay_op_1_a_delayed\ <= s392;
	s111 <= conv_std_logic_vector(0, 16);
	\d_i21_O0\ <= s481;
	\d_i12_add_op_s_i12_O0\ <= s422;
	\d_i22h_O0\ <= s426;
	\d_i20hi21hi22h_O0\ <= s367;
	\d_c114_a_delayed\ <= s456;
	\d_i15_O0\ <= s460;
	\d_c123_a_delayed\ <= s371;
	\d_i_step_delay_op_25__a_delayed\ <= s401;
	\d_i09_O0\ <= s431;
	\d_i02vi12v_add_op_s_i22v_O0\ <= s435;
	\d_i_step_delay_op_25______a_delayed\ <= s376;
	\d_i20h_add_op_s_i21h_O0\ <= s465;
	s179 <= \init\;
	\d_i02_neg_op_s_O0\ <= s469;
	\d_i00vi10v_add_op_s_i20v_delay_op_1_a_delayed\ <= s380;
	\d_c113_a_delayed\ <= s414;
	\d_c116_a_delayed\ <= s473;
	\d_i_step_delay_op_25_________a_delayed\ <= s418;
	\d_i_step_delay_op_25_____a_delayed\ <= s448;
	\d_i02vi12v_add_op_s_i22v_delay_op_1_a_delayed\ <= s363;
	\d_i01_add_op_s_i01_neg_op_s_O0\ <= s452;
	\d_i14_O0\ <= s393;
	\d_c111_a_delayed\ <= s397;
	\d_i00h_O0\ <= s427;
	\d_output_data_out\ <= s368;
	\d_input_data_out\ <= s482;
	\d_i00v_add_op_s_i10v_O0\ <= s423;
	s117 <= conv_std_logic_vector(0, 16);
	\d_i01_add_op_s_i01_O0\ <= s402;
	\d_i00hi01hi02h_add_op_s_i20hi21hi22h_O0\ <= s406;
	\d_c121_a_delayed\ <= s372;
	\d_i22_O0\ <= s457;
	\d_c110_a_delayed\ <= s461;
	\d_i10v_O0\ <= s440;
	\d_i16_O0\ <= s410;
	\d_i01_O0\ <= s474;
	\d_H_neg_op_s_O0\ <= s478;
	\d_i00vi10vi20v_O0\ <= s389;
	\d_i00hi01h_O0\ <= s444;
	\d_i_done\ <= s385;
	\d_H_O0\ <= s364;
	\d_i_step_delay_op_25________a_delayed\ <= s449;
	\d_c130_a_delayed\ <= s419;
	\d_i02_O0\ <= s398;
	\d_i03_O0\ <= s453;
	\d_i11_O0\ <= s394;
	\d_i00hi01h_add_op_s_i02h_O0\ <= s436;
	\d_i10_add_op_s_i10_neg_op_s_O0\ <= s377;
	\d_i10_O0\ <= s432;
	\d_Hpos_O0\ <= s411;
	\d_i02v_O0\ <= s415;
	\d_i20v_O0\ <= s381;
	\d_i_step_delay_op_25__________a_delayed\ <= s466;
	\d_i_step_delay_op_25_a_delayed\ <= s470;
	\d_i02vi12vi22v_O0\ <= s390;
	s0 <= conv_std_logic_vector(0, 16);
	\d_Vpos_O0\ <= s479;
	\d_c112_a_delayed\ <= s475;
	s127 <= conv_std_logic_vector(255, 16);
	\d_i_step_delay_op_25____a_delayed\ <= s424;
	\d_i18_O0\ <= s420;
	\d_i07_O0\ <= s441;
	\d_i_output\ <= s386;
	\d_i19_O0\ <= s445;
	\d_i_step_delay_op_25___a_delayed\ <= s403;
	\d_i13_O0\ <= s462;
	\d_H_if_lt_op_s_0_O0\ <= s407;
	\d_c118_a_delayed\ <= s428;
	\d_i08_O0\ <= s369;
	\d_i17_O0\ <= s458;
	\d_c125_a_delayed\ <= s373;
	\d_i00vi10v_O0\ <= s412;
	\d_c127_a_delayed\ <= s471;
	\d_i00_O0\ <= s416;
	\d_c120_a_delayed\ <= s437;
	\d_O_O0\ <= s378;
	\result\ <= s368;
	\d_i00h_add_op_s_i01h_O0\ <= s467;
	\d_c117_a_delayed\ <= s382;
	\d_c126_a_delayed\ <= s399;
	\d_i00vi10v_add_op_s_i20v_O0\ <= s433;
	\d_c107_a_delayed\ <= s429;
	\d_i00_neg_op_s__O0\ <= s450;
	\d_i20hi21h_add_op_s_i22h_delay_op_1_a_delayed\ <= s365;
	\d_V_neg_op_s_O0\ <= s395;
	\d_i02vi12v_O0\ <= s454;
	\d_i22v_O0\ <= s442;
	\d_i12v_O0\ <= s438;
	\d_c109_a_delayed\ <= s408;
	\d_i00_neg_op_s_O0\ <= s404;
	\d_c108_a_delayed\ <= s463;
	\d_i12_O0\ <= s459;
	\d_i00hi01hi02h_O0\ <= s374;
	\d_i21_add_op_s_i21_O0\ <= s370;
	\d_c119_a_delayed\ <= s366;
	\d_c122_a_delayed\ <= s425;
	\d_i_step_delay_op_25____________a_delayed\ <= s421;
	s128 <= conv_std_logic_vector(255, 16);
	\d_i00vi10vi20v_add_op_s_i02vi12vi22v_O0\ <= s480;
	\d_i06_O0\ <= s476;
	\d_i02v_add_op_s_i12v_O0\ <= s391;
	s1 <= conv_std_logic_vector(78, 16);
	\d_i02h_O0\ <= s446;
	\d_i_step\ <= s387;
	\d_i_step_delay_op_25_______a_delayed\ <= s375;
	\d_i20hi21h_add_op_s_i22h_O0\ <= s434;
	\d_i01h_O0\ <= s430;
	\d_c115_a_delayed\ <= s400;
	\d_c129_a_delayed\ <= s455;
	\d_i05_O0\ <= s396;
	\d_V_O0\ <= s362;
	\d_i10_add_op_s_i10_O0\ <= s451;
	\d_O_if_gt_op_s_255_O0\ <= s447;
	\d_i00v_O0\ <= s417;
	\d_c128_a_delayed\ <= s413;
	\d_i04_O0\ <= s472;
	\d_i20_neg_op_s_O0\ <= s468;
	\d_i20h_O0\ <= s383;
	\d_Otrunk_O0\ <= s379;
	\done\ <= s455(0);

end behavior;

