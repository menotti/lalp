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
-- Generated at Wed Dec 12 13:48:46 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity sobel is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(15 downto 0)
	);
end sobel;

architecture behavior of sobel is

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

signal s0	: std_logic;
signal s89	: std_logic_vector(15 downto 0);
signal s15	: std_logic_vector(15 downto 0);
signal s119	: std_logic_vector(15 downto 0);
signal s104	: std_logic_vector(15 downto 0);
signal s45	: std_logic_vector(15 downto 0);
signal s34	: std_logic_vector(15 downto 0);
signal s123	: std_logic_vector(15 downto 0);
signal s121	: std_logic_vector(0 downto 0);
signal s125	: std_logic_vector(15 downto 0);
signal s66	: std_logic_vector(0 downto 0);
signal s13	: std_logic_vector(0 downto 0);
signal s17	: std_logic_vector(15 downto 0);
signal s87	: std_logic_vector(15 downto 0);
signal s28	: std_logic_vector(15 downto 0);
signal s102	: std_logic_vector(15 downto 0);
signal s117	: std_logic_vector(15 downto 0);
signal s32	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(15 downto 0);
signal s51	: std_logic_vector(15 downto 0);
signal s49	: std_logic_vector(15 downto 0);
signal s47	: std_logic_vector(15 downto 0);
signal s136	: std_logic_vector(15 downto 0);
signal s138	: std_logic_vector(0 downto 0);
signal s140	: std_logic_vector(0 downto 0);
signal s142	: std_logic_vector(0 downto 0);
signal s81	: std_logic_vector(15 downto 0);
signal s83	: std_logic_vector(15 downto 0);
signal s22	: std_logic_vector(15 downto 0);
signal s96	: std_logic_vector(15 downto 0);
signal s37	: std_logic_vector(15 downto 0);
signal s111	: std_logic_vector(15 downto 0);
signal s126	: std_logic_vector(15 downto 0);
signal s41	: std_logic_vector(0 downto 0);
signal s115	: std_logic_vector(0 downto 0);
signal s60	: std_logic_vector(0 downto 0);
signal s147	: std_logic;
signal s7	: std_logic_vector(15 downto 0);
signal s5	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s149	: std_logic;
signal s90	: std_logic_vector(15 downto 0);
signal s92	: std_logic_vector(15 downto 0);
signal s109	: std_logic_vector(15 downto 0);
signal s98	: std_logic_vector(15 downto 0);
signal s20	: std_logic_vector(15 downto 0);
signal s24	: std_logic_vector(15 downto 0);
signal s94	: std_logic_vector(15 downto 0);
signal s128	: std_logic_vector(15 downto 0);
signal s113	: std_logic_vector(15 downto 0);
signal s54	: std_logic_vector(0 downto 0);
signal s43	: std_logic_vector(15 downto 0);
signal s132	: std_logic_vector(15 downto 0);
signal s130	: std_logic_vector(15 downto 0);
signal s134	: std_logic_vector(15 downto 0);
signal s18	: std_logic_vector(0 downto 0);
signal s75	: std_logic_vector(0 downto 0);
signal s79	: std_logic_vector(15 downto 0);
signal s63	: std_logic_vector(0 downto 0);
signal s122	: std_logic_vector(15 downto 0);
signal s107	: std_logic_vector(15 downto 0);
signal s29	: std_logic_vector(15 downto 0);
signal s103	: std_logic_vector(15 downto 0);
signal s27	: std_logic_vector(15 downto 0);
signal s86	: std_logic_vector(15 downto 0);
signal s135	: std_logic_vector(15 downto 0);
signal s50	: std_logic_vector(0 downto 0);
signal s124	: std_logic_vector(15 downto 0);
signal s31	: std_logic_vector(15 downto 0);
signal s35	: std_logic_vector(15 downto 0);
signal s105	: std_logic_vector(15 downto 0);
signal s46	: std_logic_vector(15 downto 0);
signal s10	: std_logic_vector(15 downto 0);
signal s12	: std_logic_vector(15 downto 0);
signal s101	: std_logic_vector(15 downto 0);
signal s99	: std_logic_vector(15 downto 0);
signal s69	: std_logic_vector(0 downto 0);
signal s144	: std_logic_vector(0 downto 0);
signal s40	: std_logic_vector(15 downto 0);
signal s44	: std_logic_vector(15 downto 0);
signal s129	: std_logic_vector(15 downto 0);
signal s25	: std_logic_vector(0 downto 0);
signal s21	: std_logic_vector(15 downto 0);
signal s110	: std_logic_vector(15 downto 0);
signal s108	: std_logic_vector(15 downto 0);
signal s74	: std_logic_vector(15 downto 0);
signal s80	: std_logic_vector(15 downto 0);
signal s78	: std_logic_vector(15 downto 0);
signal s146	: std_logic_vector(0 downto 0);
signal s72	: std_logic_vector(0 downto 0);
signal s131	: std_logic_vector(0 downto 0);
signal s57	: std_logic_vector(0 downto 0);
signal s38	: std_logic_vector(15 downto 0);
signal s116	: std_logic_vector(15 downto 0);
signal s36	: std_logic_vector(15 downto 0);
signal s95	: std_logic_vector(15 downto 0);
signal s93	: std_logic_vector(15 downto 0);
signal s91	: std_logic_vector(15 downto 0);
signal s150	: std_logic_vector(0 downto 0);
signal s148	: std_logic_vector(0 downto 0);
signal s8	: std_logic_vector(0 downto 0);
signal s2	: std_logic_vector(15 downto 0);

begin

	\c100\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s147,
		a_delayed => s142,
		clk => \clk\,
		reset => \reset\
	);

	\output\: block_ram
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s136(6 downto 0),
		clk => \clk\,
		data_in => s132,
		data_out => s134,
		we => s138(0)
	);

	\i12\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s101,
		clk => \clk\,
		reset => \reset\,
		we => s66(0)
	);

	\c104\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s149,
		a_delayed => s150,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_8\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s147,
		a_delayed => s72,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_5\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s147,
		a_delayed => s32,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_6\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s147,
		a_delayed => s41,
		clk => \clk\,
		reset => \reset\
	);

	\i20_neg_op_s_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s105,
		I1 => s106,
		O0 => s108
	);

	\i01\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s79,
		clk => \clk\,
		reset => \reset\,
		we => s57(0)
	);

	\H_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s117,
		O0 => s116
	);

	\i00_neg_op_s_add_op_s_i02_add_op_s_i10_neg_op_s_sub_op_s_i10_add_op_s_i12_add_op_s_i12_add_op_s_i20_neg_op_s_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s109,
		I1 => s110,
		O0 => s111
	);

	\V_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s123,
		I1 => s119,
		O0 => s121
	);

	\H\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s93,
		O0 => s117,
		clk => \clk\,
		reset => \reset\,
		we => s140(0)
	);

	\i\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 8
	)
	port map (
		clk => \clk\,
		clk_en => s0,
		done => s149,
		input => s1,
		output => s135,
		reset => \reset\,
		step => s147,
		termination => s2
	);

	\i_add_op_s_COLS__\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s27,
		O0 => s28
	);

	\c102\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s147,
		a_delayed => s146,
		clk => \clk\,
		reset => \reset\
	);

	\i_add_op_s_COLS_add_op_s_COLS_\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s35,
		I1 => s36,
		O0 => s37
	);

	\i02_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s96,
		O0 => s83
	);

	\i01_neg_op_s_sub_op_s_i01\: sub_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s78,
		I1 => s79,
		O0 => s81
	);

	\i00_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s94,
		O0 => s80
	);

	\i21_add_op_s_i21\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s86,
		I1 => s86,
		O0 => s87
	);

	\i_step_delay_op_2\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s147,
		a_delayed => s13,
		clk => \clk\,
		reset => \reset\
	);

	\i_add_op_s_COLS_add_op_s_2\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s21,
		I1 => s22,
		O0 => s24
	);

	\i_add_op_s_COLS_add_op_s_COLS_add_op_s_2\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s46,
		I1 => s47,
		O0 => s49
	);

	\i_step_delay_op_4_\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s147,
		a_delayed => s60,
		clk => \clk\,
		reset => \reset\
	);

	\i10_neg_op_s_sub_op_s_i10\: sub_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s98,
		I1 => s99,
		O0 => s102
	);

	\i00_neg_op_s_add_op_s_i02\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s95,
		I1 => s96,
		O0 => s109
	);

	\i00_neg_op_s_add_op_s_i01_neg_op_s_sub_op_s_i01_add_op_s_i02_neg_op_s_add_op_s_i20_add_op_s_i21_add_op_s_i21_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s91,
		I1 => s92,
		O0 => s93
	);

	\i10_neg_op_s_sub_op_s_i10_add_op_s_i12_add_op_s_i12\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s102,
		I1 => s103,
		O0 => s107
	);

	\O\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s126,
		O0 => s128,
		clk => \clk\,
		reset => \reset\,
		we => s148(0)
	);

	\i20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s104,
		clk => \clk\,
		reset => \reset\,
		we => s69(0)
	);

	\i22\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s106,
		clk => \clk\,
		reset => \reset\,
		we => s75(0)
	);

	\i_step_delay_op_1\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s147,
		a_delayed => s8,
		clk => \clk\,
		reset => \reset\
	);

	\c98\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s147,
		a_delayed => s138,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_3\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s147,
		a_delayed => s18,
		clk => \clk\,
		reset => \reset\
	);

	\i21_add_op_s_i21_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s87,
		I1 => s106,
		O0 => s90
	);

	\i_step_delay_op_6_\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s147,
		a_delayed => s66,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_2_\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s147,
		a_delayed => s54,
		clk => \clk\,
		reset => \reset\
	);

	\Hpos_add_op_s_Vpos\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s124,
		I1 => s125,
		O0 => s126
	);

	\Otrunk\: mux_m_op
	generic map (
		N_ops => 2,
		N_sels => 1,
		w_in => 16
	)
	port map (
		I0(31 downto 16) => s128(15 downto 0),
		I0(15 downto 0) => s130(15 downto 0),
		O0 => s132,
		Sel(0 downto 0) => s131(0 downto 0)
	);

	\i20_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s104,
		O0 => s105
	);

	\i02_neg_op_s_add_op_s_i20\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s83,
		I1 => s104,
		O0 => s89
	);

	\i01_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s79,
		O0 => s78
	);

	\i_add_op_s_COLS_add_op_s_COLS\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s28,
		I1 => s29,
		O0 => s31
	);

	\c103\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s147,
		a_delayed => s148,
		clk => \clk\,
		reset => \reset\
	);

	\i_add_op_s_COLS_add_op_s_COLS_add_op_s_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s37,
		I1 => s38,
		O0 => s40
	);

	\i_step_delay_op_4\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s147,
		a_delayed => s25,
		clk => \clk\,
		reset => \reset\
	);

	\i00_neg_op_s_add_op_s_i01_neg_op_s_sub_op_s_i01\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s80,
		I1 => s81,
		O0 => s91
	);

	\i_add_op_s_COLS___\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s34,
		O0 => s35
	);

	\i_add_op_s_COLS____\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s43,
		O0 => s44
	);

	\i_step_delay_op_9\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s147,
		a_delayed => s75,
		clk => \clk\,
		reset => \reset\
	);

	\input\: block_ram_input
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s51(6 downto 0),
		clk => \clk\,
		data_out => s74
	);

	\addr\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 16
	)
	port map (
		I0(127 downto 112) => s135(15 downto 0),
		I0(111 downto 96) => s7(15 downto 0),
		I0(95 downto 80) => s12(15 downto 0),
		I0(79 downto 64) => s17(15 downto 0),
		I0(63 downto 48) => s24(15 downto 0),
		I0(47 downto 32) => s31(15 downto 0),
		I0(31 downto 16) => s40(15 downto 0),
		I0(15 downto 0) => s49(15 downto 0),
		O0 => s51,
		Sel(6 downto 6) => s8(0 downto 0),
		Sel(5 downto 5) => s13(0 downto 0),
		Sel(4 downto 4) => s18(0 downto 0),
		Sel(3 downto 3) => s25(0 downto 0),
		Sel(2 downto 2) => s32(0 downto 0),
		Sel(1 downto 1) => s41(0 downto 0),
		Sel(0 downto 0) => s50(0 downto 0)
	);

	\i10\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s99,
		clk => \clk\,
		reset => \reset\,
		we => s63(0)
	);

	\i00\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s94,
		clk => \clk\,
		reset => \reset\,
		we => s54(0)
	);

	\c101\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s147,
		a_delayed => s144,
		clk => \clk\,
		reset => \reset\
	);

	\c99\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s147,
		a_delayed => s140,
		clk => \clk\,
		reset => \reset\
	);

	\i10_neg_op_s_sub_op_s_i10_add_op_s_i12_add_op_s_i12_add_op_s_i20_neg_op_s_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s107,
		I1 => s108,
		O0 => s110
	);

	\V_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s123,
		O0 => s122
	);

	\H_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s117,
		I1 => s113,
		O0 => s115
	);

	\Hpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s117,
		I1 => s116,
		O0 => s124,
		Sel1 => s115,
		clk => \clk\,
		reset => \reset\,
		we => s144(0)
	);

	\i10_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s99,
		O0 => s98
	);

	\i_step_delay_op_3_\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s147,
		a_delayed => s57,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_7_\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s147,
		a_delayed => s69,
		clk => \clk\,
		reset => \reset\
	);

	\i02_neg_op_s_add_op_s_i20_add_op_s_i21_add_op_s_i21_add_op_s_i22\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s89,
		I1 => s90,
		O0 => s92
	);

	\i_add_op_s_COLS_\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s20,
		O0 => s21
	);

	\i_add_op_s_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s5,
		O0 => s7
	);

	\i_add_op_s_2\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s10,
		O0 => s12
	);

	\i_add_op_s_COLS\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s135,
		I1 => s15,
		O0 => s17
	);

	\O_if_gt_op_s_255\: if_gt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s128,
		I1 => s129,
		O0 => s131
	);

	\Vpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s123,
		I1 => s122,
		O0 => s125,
		Sel1 => s121,
		clk => \clk\,
		reset => \reset\,
		we => s146(0)
	);

	\i12_add_op_s_i12\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s101,
		I1 => s101,
		O0 => s103
	);

	\i00_neg_op_s_\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s94,
		O0 => s95
	);

	\i_step_delay_op_7\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s147,
		a_delayed => s50,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_5_\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s147,
		a_delayed => s63,
		clk => \clk\,
		reset => \reset\
	);

	\i_add_op_s_COLS_add_op_s_COLS__\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s44,
		I1 => s45,
		O0 => s46
	);

	\c97\: delay_op
	generic map (
		bits => 16,
		delay => 13
	)
	port map (
		a => s135,
		a_delayed => s136,
		clk => \clk\,
		reset => \reset\
	);

	\i02\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s96,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\V\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s111,
		O0 => s123,
		clk => \clk\,
		reset => \reset\,
		we => s142(0)
	);

	\i21\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s86,
		clk => \clk\,
		reset => \reset\,
		we => s72(0)
	);

	\result\ <= s134;
	s38 <= conv_std_logic_vector(1, 16);
	s27 <= conv_std_logic_vector(10, 16);
	s34 <= conv_std_logic_vector(10, 16);
	s10 <= conv_std_logic_vector(2, 16);
	s20 <= conv_std_logic_vector(10, 16);
	s130 <= conv_std_logic_vector(255, 16);
	\done\ <= s150(0);
	s43 <= conv_std_logic_vector(10, 16);
	s47 <= conv_std_logic_vector(2, 16);
	s119 <= conv_std_logic_vector(0, 16);
	s2 <= conv_std_logic_vector(78, 16);
	s29 <= conv_std_logic_vector(10, 16);
	s22 <= conv_std_logic_vector(2, 16);
	s36 <= conv_std_logic_vector(10, 16);
	s15 <= conv_std_logic_vector(10, 16);
	s5 <= conv_std_logic_vector(1, 16);
	s1 <= conv_std_logic_vector(0, 16);
	s129 <= conv_std_logic_vector(255, 16);
	s113 <= conv_std_logic_vector(0, 16);
	s45 <= conv_std_logic_vector(10, 16);
	s0 <= \init\;

end behavior;

