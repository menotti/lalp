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
-- Generated at Tue May 28 15:32:42 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity adpcm_decoder is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end adpcm_decoder;

architecture behavior of adpcm_decoder is

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

component add_reg_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	Sel1	: in	std_logic_vector(0 downto 0) := "1";
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component and_op
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
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

component block_ram_indata
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

component block_ram_indexTable
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

component block_ram_stepSizeTable
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

component not_op
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

component shr_c_op_s
generic (
	w_in1	: integer := 16;
	w_out	: integer := 15;
	s_amount	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component sub_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

signal s0	: std_logic_vector(10 downto 0);
signal s100	: std_logic_vector(31 downto 0);
signal s11	: std_logic_vector(31 downto 0);
signal s85	: std_logic_vector(31 downto 0);
signal s104	: std_logic_vector(10 downto 0);
signal s45	: std_logic_vector(31 downto 0);
signal s30	: std_logic_vector(31 downto 0);
signal s64	: std_logic_vector(31 downto 0);
signal s9	: std_logic_vector(0 downto 0);
signal s70	: std_logic_vector(31 downto 0);
signal s13	: std_logic_vector(31 downto 0);
signal s17	: std_logic_vector(31 downto 0);
signal s87	: std_logic_vector(31 downto 0);
signal s102	: std_logic;
signal s32	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(0 downto 0);
signal s47	: std_logic_vector(31 downto 0);
signal s53	: std_logic_vector(31 downto 0);
signal s136	: std_logic_vector(0 downto 0);
signal s138	: std_logic_vector(0 downto 0);
signal s140	: std_logic_vector(0 downto 0);
signal s142	: std_logic_vector(0 downto 0);
signal s81	: std_logic_vector(31 downto 0);
signal s22	: std_logic_vector(8 downto 0);
signal s26	: std_logic_vector(31 downto 0);
signal s96	: std_logic_vector(0 downto 0);
signal s37	: std_logic_vector(31 downto 0);
signal s126	: std_logic_vector(0 downto 0);
signal s41	: std_logic_vector(31 downto 0);
signal s62	: std_logic_vector(31 downto 0);
signal s145	: std_logic_vector(31 downto 0);
signal s7	: std_logic_vector(0 downto 0);
signal s1	: std_logic_vector(10 downto 0);
signal s90	: std_logic_vector(31 downto 0);
signal s92	: std_logic_vector(31 downto 0);
signal s98	: std_logic_vector(31 downto 0);
signal s20	: std_logic_vector(0 downto 0);
signal s24	: std_logic_vector(0 downto 0);
signal s128	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s43	: std_logic_vector(31 downto 0);
signal s39	: std_logic_vector(31 downto 0);
signal s73	: std_logic_vector(31 downto 0);
signal s132	: std_logic_vector(0 downto 0);
signal s130	: std_logic_vector(0 downto 0);
signal s134	: std_logic_vector(0 downto 0);
signal s75	: std_logic_vector(31 downto 0);
signal s79	: std_logic_vector(31 downto 0);
signal s137	: std_logic_vector(0 downto 0);
signal s63	: std_logic_vector(31 downto 0);
signal s122	: std_logic_vector(0 downto 0);
signal s52	: std_logic_vector(31 downto 0);
signal s48	: std_logic_vector(31 downto 0);
signal s118	: std_logic_vector(0 downto 0);
signal s29	: std_logic_vector(31 downto 0);
signal s103	: std_logic_vector(10 downto 0);
signal s33	: std_logic_vector(0 downto 0);
signal s27	: std_logic_vector(31 downto 0);
signal s88	: std_logic_vector(31 downto 0);
signal s143	: std_logic_vector(0 downto 0);
signal s141	: std_logic_vector(0 downto 0);
signal s139	: std_logic_vector(0 downto 0);
signal s120	: std_logic_vector(0 downto 0);
signal s135	: std_logic;
signal s50	: std_logic_vector(31 downto 0);
signal s124	: std_logic_vector(0 downto 0);
signal s31	: std_logic_vector(31 downto 0);
signal s35	: std_logic_vector(31 downto 0);
signal s46	: std_logic_vector(0 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s16	: std_logic_vector(31 downto 0);
signal s12	: std_logic_vector(31 downto 0);
signal s101	: std_logic_vector(31 downto 0);
signal s71	: std_logic_vector(31 downto 0);
signal s67	: std_logic_vector(31 downto 0);
signal s69	: std_logic_vector(31 downto 0);
signal s144	: std_logic_vector(0 downto 0);
signal s59	: std_logic_vector(31 downto 0);
signal s40	: std_logic_vector(0 downto 0);
signal s114	: std_logic_vector(0 downto 0);
signal s21	: std_logic_vector(0 downto 0);
signal s110	: std_logic_vector(0 downto 0);
signal s108	: std_logic_vector(0 downto 0);
signal s23	: std_logic_vector(8 downto 0);
signal s76	: std_logic_vector(31 downto 0);
signal s74	: std_logic_vector(31 downto 0);
signal s80	: std_logic_vector(31 downto 0);
signal s146	: std_logic_vector(31 downto 0);
signal s72	: std_logic_vector(31 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s116	: std_logic_vector(0 downto 0);
signal s112	: std_logic_vector(0 downto 0);
signal s42	: std_logic_vector(31 downto 0);
signal s36	: std_logic_vector(31 downto 0);
signal s95	: std_logic_vector(31 downto 0);
signal s93	: std_logic_vector(31 downto 0);
signal s97	: std_logic_vector(31 downto 0);
signal s91	: std_logic_vector(0 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(0 downto 0);
signal s2	: std_logic;

begin

	\c100\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a => s139,
		a_delayed => s140,
		clk => \clk\,
		reset => \reset\
	);

	\delta2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s31,
		O0 => s71,
		clk => \clk\,
		reset => \reset\,
		we => s112(0)
	);

	\c89\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s135,
		a_delayed => s118,
		clk => \clk\,
		reset => \reset\
	);

	\sign\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		O0 => s80,
		clk => \clk\,
		reset => \reset\,
		we => s110(0)
	);

	\c85\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s135,
		a_delayed => s110,
		clk => \clk\,
		reset => \reset\
	);

	\delta2_and_op_4\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s71,
		I1 => s72,
		O0 => s73
	);

	\index2_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s42,
		I1 => s39,
		O0 => s40
	);

	\step_shr_c_op_s_3\: shr_c_op_s
	generic map (
		s_amount => 3,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s76,
		O0 => s50
	);

	\indata\: block_ram_indata
	generic map (
		address_width => 9,
		data_width => 32
	)
	port map (
		address => s22,
		clk => \clk\,
		data_out => s8
	);

	\i\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 9,
		w_in2 => 9,
		w_out => 9
	)
	port map (
		I0 => s22,
		I1 => s23,
		O0 => s22,
		clk => \clk\,
		reset => \reset\,
		we => s24(0)
	);

	\len_step_delay_op_1\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s135,
		a_delayed => s7,
		clk => \clk\,
		reset => \reset\
	);

	\c87\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s135,
		a_delayed => s114,
		clk => \clk\,
		reset => \reset\
	);

	\bufferstep_not_op__\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s32,
		O0 => s33
	);

	\c102\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a => s143,
		a_delayed => s144,
		clk => \clk\,
		reset => \reset\
	);

	\index3_if_gt_op_s_88\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s48,
		I1 => s45,
		O0 => s46
	);

	\valpred_add_op_s_vpdiff4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s100,
		I1 => s85,
		O0 => s88
	);

	\sign_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s80,
		I1 => s81,
		O0 => s143
	);

	\vpdiff_add_op_s_step\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s75,
		I1 => s76,
		O0 => s145
	);

	\valpred2_if_gt_op_s_32767\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s93,
		I1 => s90,
		O0 => s91
	);

	\c83\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s135,
		a_delayed => s106,
		clk => \clk\,
		reset => \reset\
	);

	\delta\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s17,
		I1 => s16,
		O0 => s29,
		Sel1 => s32,
		clk => \clk\,
		reset => \reset\,
		we => s108(0)
	);

	\delta_and_op_8\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s29,
		I1 => s26,
		O0 => s27
	);

	\c96\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s135,
		a_delayed => s132,
		clk => \clk\,
		reset => \reset\
	);

	\step_shr_c_op_s_2\: shr_c_op_s
	generic map (
		s_amount => 2,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s76,
		O0 => s57
	);

	\delta2_and_op_2_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s63,
		I1 => s64,
		O0 => s137
	);

	\valpred\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s98,
		I1 => s97,
		O0 => s100,
		Sel1 => s96,
		clk => \clk\,
		reset => \reset\,
		we => s136(0)
	);

	\stepSizeTable\: block_ram_stepSizeTable
	generic map (
		address_width => 7,
		data_width => 32
	)
	port map (
		address(6 downto 0) => s37(6 downto 0),
		clk => \clk\,
		data_out => s43
	);

	\index2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s36,
		O0 => s42,
		clk => \clk\,
		reset => \reset\,
		we => s116(0)
	);

	\vpdiff\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s50,
		O0 => s75,
		clk => \clk\,
		reset => \reset\,
		we => s124(0)
	);

	\c90\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s135,
		a_delayed => s120,
		clk => \clk\,
		reset => \reset\
	);

	\c92\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s135,
		a_delayed => s124,
		clk => \clk\,
		reset => \reset\
	);

	\inputbuffer_shr_c_op_s_4\: shr_c_op_s
	generic map (
		s_amount => 4,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s12,
		O0 => s13
	);

	\c98\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s135,
		a_delayed => s136,
		clk => \clk\,
		reset => \reset\
	);

	\len_step_delay_op_2\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s135,
		a_delayed => s21,
		clk => \clk\,
		reset => \reset\
	);

	\c94\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s135,
		a_delayed => s128,
		clk => \clk\,
		reset => \reset\
	);

	\valpred3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s93,
		I1 => s92,
		O0 => s98,
		Sel1 => s91,
		clk => \clk\,
		reset => \reset\,
		we => s134(0)
	);

	\vpdiff_add_op_s_step_shr_c_op_s_1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s75,
		I1 => s67,
		O0 => s69
	);

	\vpdiff2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s75,
		I1 => s59,
		O0 => s70,
		Sel1 => s140,
		clk => \clk\,
		reset => \reset\,
		we => s126(0)
	);

	\bufferstep_not_op_and_op_len_step_delay_op_1\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s6,
		I1 => s7,
		O0 => s9
	);

	\valpred2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s88,
		I1 => s87,
		O0 => s93,
		Sel1 => s144,
		clk => \clk\,
		reset => \reset\,
		we => s132(0)
	);

	\vpdiff4\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s79,
		I1 => s146,
		O0 => s85,
		Sel1 => s142,
		clk => \clk\,
		reset => \reset\,
		we => s130(0)
	);

	\index_add_op_s_indexTable_data_out\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s37,
		I1 => s35,
		O0 => s36
	);

	\c103\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s145,
		a_delayed => s146,
		clk => \clk\,
		reset => \reset\
	);

	\index\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		I1 => s47,
		O0 => s37,
		Sel1 => s46,
		clk => \clk\,
		reset => \reset\,
		we => s122(0)
	);

	\delta_and_op_7\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s29,
		I1 => s30,
		O0 => s31
	);

	\c86\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s135,
		a_delayed => s112,
		clk => \clk\,
		reset => \reset\
	);

	\c84\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s135,
		a_delayed => s108,
		clk => \clk\,
		reset => \reset\
	);

	\c88\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s135,
		a_delayed => s116,
		clk => \clk\,
		reset => \reset\
	);

	\c82\: delay_op
	generic map (
		bits => 11,
		delay => 15
	)
	port map (
		a => s103,
		a_delayed => s104,
		clk => \clk\,
		reset => \reset\
	);

	\valpred_sub_op_s_vpdiff4\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s100,
		I1 => s85,
		O0 => s87
	);

	\index3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s42,
		I1 => s41,
		O0 => s48,
		Sel1 => s40,
		clk => \clk\,
		reset => \reset\,
		we => s118(0)
	);

	\delta2_and_op_1\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s71,
		I1 => s52,
		O0 => s53
	);

	\delta2_and_op_4_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s73,
		I1 => s74,
		O0 => s141
	);

	\len\: counter
	generic map (
		bits => 11,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 3
	)
	port map (
		clk => \clk\,
		clk_en => s2,
		done => s102,
		input => s0,
		output => s103,
		reset => \reset\,
		step => s135,
		termination => s1
	);

	\bufferstep\: reg_op
	generic map (
		initial => 1,
		w_in => 1
	)
	port map (
		I0 => s33,
		O0 => s32,
		clk => \clk\,
		reset => \reset\,
		we => s114(0)
	);

	\bufferstep_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s32,
		O0 => s6
	);

	\outdata\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address(9 downto 0) => s104(9 downto 0),
		clk => \clk\,
		data_in => s100,
		data_out => s101,
		we => s106(0)
	);

	\c101\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a => s141,
		a_delayed => s142,
		clk => \clk\,
		reset => \reset\
	);

	\c99\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a => s137,
		a_delayed => s138,
		clk => \clk\,
		reset => \reset\
	);

	\delta2_and_op_2\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s71,
		I1 => s62,
		O0 => s63
	);

	\vpdiff3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s70,
		I1 => s69,
		O0 => s79,
		Sel1 => s138,
		clk => \clk\,
		reset => \reset\,
		we => s128(0)
	);

	\valpred3_if_lt_op_s_-32768\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s98,
		I1 => s95,
		O0 => s96
	);

	\bufferstep_not_op_and_op_len_step_delay_op_2\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s20,
		I1 => s21,
		O0 => s24
	);

	\inputbuffer_and_op_15\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s12,
		I1 => s11,
		O0 => s16
	);

	\inputbuffer_shr_c_op_s_4_and_op_15\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s13,
		I1 => s14,
		O0 => s17
	);

	\bufferstep_not_op_\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s32,
		O0 => s20
	);

	\vpdiff_add_op_s_step_shr_c_op_s_2\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s75,
		I1 => s57,
		O0 => s59
	);

	\step_shr_c_op_s_1\: shr_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s76,
		O0 => s67
	);

	\delta2_and_op_1_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s53,
		I1 => s54,
		O0 => s139
	);

	\c95\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s135,
		a_delayed => s130,
		clk => \clk\,
		reset => \reset\
	);

	\c93\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s135,
		a_delayed => s126,
		clk => \clk\,
		reset => \reset\
	);

	\c97\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s135,
		a_delayed => s134,
		clk => \clk\,
		reset => \reset\
	);

	\c91\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s135,
		a_delayed => s122,
		clk => \clk\,
		reset => \reset\
	);

	\indexTable\: block_ram_indexTable
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address(3 downto 0) => s29(3 downto 0),
		clk => \clk\,
		data_out => s35
	);

	\step\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s43,
		O0 => s76,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\inputbuffer\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s8,
		O0 => s12,
		clk => \clk\,
		reset => \reset\,
		we => s9(0)
	);

	\done\ <= s102;
	s23 <= conv_std_logic_vector(1, 9);
	s41 <= conv_std_logic_vector(0, 32);
	s30 <= conv_std_logic_vector(7, 32);
	s47 <= conv_std_logic_vector(88, 32);
	s97 <= conv_std_logic_vector(-32768, 32);
	s0 <= conv_std_logic_vector(0, 11);
	s11 <= conv_std_logic_vector(15, 32);
	\output\ <= s101;
	s62 <= conv_std_logic_vector(2, 32);
	s81 <= conv_std_logic_vector(0, 32);
	s72 <= conv_std_logic_vector(4, 32);
	s92 <= conv_std_logic_vector(32767, 32);
	s14 <= conv_std_logic_vector(15, 32);
	s26 <= conv_std_logic_vector(8, 32);
	s52 <= conv_std_logic_vector(1, 32);
	s39 <= conv_std_logic_vector(0, 32);
	s45 <= conv_std_logic_vector(88, 32);
	s74 <= conv_std_logic_vector(0, 32);
	s64 <= conv_std_logic_vector(0, 32);
	s95 <= conv_std_logic_vector(-32768, 32);
	s90 <= conv_std_logic_vector(32767, 32);
	s54 <= conv_std_logic_vector(0, 32);
	s1 <= conv_std_logic_vector(1024, 11);
	s2 <= \init\;

end behavior;

