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
-- Generated at Thu Jul 24 15:12:28 BRT 2014
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
signal s100	: std_logic_vector(0 downto 0);
signal s11	: std_logic_vector(31 downto 0);
signal s89	: std_logic_vector(31 downto 0);
signal s85	: std_logic_vector(0 downto 0);
signal s104	: std_logic_vector(0 downto 0);
signal s30	: std_logic_vector(31 downto 0);
signal s34	: std_logic_vector(0 downto 0);
signal s64	: std_logic_vector(31 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s68	: std_logic_vector(31 downto 0);
signal s66	: std_logic_vector(31 downto 0);
signal s70	: std_logic_vector(31 downto 0);
signal s13	: std_logic_vector(31 downto 0);
signal s17	: std_logic_vector(8 downto 0);
signal s87	: std_logic_vector(31 downto 0);
signal s102	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(0 downto 0);
signal s51	: std_logic_vector(31 downto 0);
signal s47	: std_logic_vector(31 downto 0);
signal s53	: std_logic_vector(31 downto 0);
signal s136	: std_logic_vector(0 downto 0);
signal s138	: std_logic_vector(0 downto 0);
signal s140	: std_logic_vector(31 downto 0);
signal s81	: std_logic_vector(31 downto 0);
signal s26	: std_logic_vector(0 downto 0);
signal s96	: std_logic;
signal s37	: std_logic_vector(31 downto 0);
signal s126	: std_logic_vector(0 downto 0);
signal s41	: std_logic_vector(31 downto 0);
signal s58	: std_logic_vector(31 downto 0);
signal s56	: std_logic_vector(31 downto 0);
signal s5	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(10 downto 0);
signal s90	: std_logic_vector(0 downto 0);
signal s92	: std_logic_vector(31 downto 0);
signal s98	: std_logic_vector(10 downto 0);
signal s20	: std_logic_vector(31 downto 0);
signal s24	: std_logic_vector(31 downto 0);
signal s94	: std_logic_vector(31 downto 0);
signal s128	: std_logic_vector(0 downto 0);
signal s39	: std_logic_vector(31 downto 0);
signal s73	: std_logic_vector(31 downto 0);
signal s132	: std_logic_vector(0 downto 0);
signal s130	: std_logic_vector(0 downto 0);
signal s134	: std_logic_vector(0 downto 0);
signal s18	: std_logic_vector(0 downto 0);
signal s75	: std_logic_vector(31 downto 0);
signal s79	: std_logic_vector(31 downto 0);
signal s137	: std_logic_vector(0 downto 0);
signal s63	: std_logic_vector(31 downto 0);
signal s122	: std_logic_vector(0 downto 0);
signal s48	: std_logic_vector(31 downto 0);
signal s118	: std_logic_vector(0 downto 0);
signal s29	: std_logic_vector(31 downto 0);
signal s33	: std_logic_vector(31 downto 0);
signal s27	: std_logic_vector(0 downto 0);
signal s86	: std_logic_vector(31 downto 0);
signal s84	: std_logic_vector(31 downto 0);
signal s82	: std_logic_vector(31 downto 0);
signal s139	: std_logic_vector(31 downto 0);
signal s120	: std_logic_vector(0 downto 0);
signal s135	: std_logic_vector(0 downto 0);
signal s124	: std_logic_vector(0 downto 0);
signal s31	: std_logic_vector(31 downto 0);
signal s35	: std_logic_vector(31 downto 0);
signal s46	: std_logic_vector(31 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s10	: std_logic_vector(31 downto 0);
signal s16	: std_logic_vector(8 downto 0);
signal s65	: std_logic_vector(31 downto 0);
signal s67	: std_logic_vector(31 downto 0);
signal s69	: std_logic_vector(31 downto 0);
signal s133	: std_logic_vector(0 downto 0);
signal s40	: std_logic_vector(0 downto 0);
signal s44	: std_logic_vector(31 downto 0);
signal s129	: std_logic;
signal s114	: std_logic_vector(0 downto 0);
signal s25	: std_logic_vector(31 downto 0);
signal s21	: std_logic_vector(31 downto 0);
signal s110	: std_logic_vector(0 downto 0);
signal s108	: std_logic_vector(0 downto 0);
signal s23	: std_logic_vector(31 downto 0);
signal s74	: std_logic_vector(31 downto 0);
signal s131	: std_logic_vector(0 downto 0);
signal s61	: std_logic_vector(31 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s116	: std_logic_vector(0 downto 0);
signal s112	: std_logic_vector(0 downto 0);
signal s42	: std_logic_vector(31 downto 0);
signal s36	: std_logic_vector(31 downto 0);
signal s95	: std_logic_vector(31 downto 0);
signal s97	: std_logic_vector(10 downto 0);
signal s91	: std_logic_vector(31 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(0 downto 0);
signal s2	: std_logic;

begin

	\delta2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s25,
		O0 => s65,
		clk => \clk\,
		reset => \reset\,
		we => s106(0)
	);

	\c89\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s129,
		a_delayed => s120,
		clk => \clk\,
		reset => \reset\
	);

	\sign\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s21,
		O0 => s74,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\c85\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s129,
		a_delayed => s112,
		clk => \clk\,
		reset => \reset\
	);

	\sign_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s74,
		I1 => s75,
		O0 => s137
	);

	\step_shr_c_op_s_3\: shr_c_op_s
	generic map (
		s_amount => 3,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s70,
		O0 => s44
	);

	\vpdiff_add_op_s_step_shr_c_op_s_2\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s69,
		I1 => s51,
		O0 => s53
	);

	\indata\: block_ram_indata
	generic map (
		address_width => 9,
		data_width => 32
	)
	port map (
		address => s16,
		clk => \clk\,
		data_out => s5
	);

	\i\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 9,
		w_in2 => 9,
		w_out => 9
	)
	port map (
		I0 => s16,
		I1 => s17,
		O0 => s16,
		clk => \clk\,
		reset => \reset\,
		we => s18(0)
	);

	\inputbuffer_and_op_15\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s9,
		I1 => s8,
		O0 => s13
	);

	\c87\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s129,
		a_delayed => s116,
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
		I0 => s42,
		I1 => s39,
		O0 => s40
	);

	\delta2_and_op_1_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s47,
		I1 => s48,
		O0 => s133
	);

	\valpred3_if_lt_op_s_-32768\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s92,
		I1 => s89,
		O0 => s90
	);

	\valpred2_if_gt_op_s_32767\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s87,
		I1 => s84,
		O0 => s85
	);

	\valpred_add_op_s_vpdiff4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s94,
		I1 => s79,
		O0 => s82
	);

	\c81\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s129,
		a_delayed => s104,
		clk => \clk\,
		reset => \reset\
	);

	\c83\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s129,
		a_delayed => s108,
		clk => \clk\,
		reset => \reset\
	);

	\delta_and_op_8\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s23,
		I1 => s20,
		O0 => s21
	);

	\index2_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s36,
		I1 => s33,
		O0 => s34
	);

	\c96\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a => s133,
		a_delayed => s134,
		clk => \clk\,
		reset => \reset\
	);

	\delta2_and_op_2_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s57,
		I1 => s58,
		O0 => s131
	);

	\delta2_and_op_4\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s65,
		I1 => s66,
		O0 => s67
	);

	\stepSizeTable\: block_ram_stepSizeTable
	generic map (
		address_width => 7,
		data_width => 32
	)
	port map (
		address(6 downto 0) => s31(6 downto 0),
		clk => \clk\,
		data_out => s37
	);

	\index2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s30,
		O0 => s36,
		clk => \clk\,
		reset => \reset\,
		we => s110(0)
	);

	\vpdiff\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s69,
		clk => \clk\,
		reset => \reset\,
		we => s118(0)
	);

	\c90\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s129,
		a_delayed => s122,
		clk => \clk\,
		reset => \reset\
	);

	\c92\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s129,
		a_delayed => s126,
		clk => \clk\,
		reset => \reset\
	);

	\delta\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s14,
		I1 => s13,
		O0 => s23,
		Sel1 => s26,
		clk => \clk\,
		reset => \reset\,
		we => s102(0)
	);

	\c98\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a => s137,
		a_delayed => s138,
		clk => \clk\,
		reset => \reset\
	);

	\bufferstep_not_op__\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s26,
		O0 => s27
	);

	\c94\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s129,
		a_delayed => s130,
		clk => \clk\,
		reset => \reset\
	);

	\vpdiff_add_op_s_step\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s69,
		I1 => s70,
		O0 => s139
	);

	\vpdiff_add_op_s_step_shr_c_op_s_1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s69,
		I1 => s61,
		O0 => s63
	);

	\inputbuffer_shr_c_op_s_4\: shr_c_op_s
	generic map (
		s_amount => 4,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s9,
		O0 => s10
	);

	\c79\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s129,
		a_delayed => s100,
		clk => \clk\,
		reset => \reset\
	);

	\valpred\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s92,
		I1 => s91,
		O0 => s94,
		Sel1 => s90,
		clk => \clk\,
		reset => \reset\,
		we => s130(0)
	);

	\valpred2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s82,
		I1 => s81,
		O0 => s87,
		Sel1 => s138,
		clk => \clk\,
		reset => \reset\,
		we => s126(0)
	);

	\index\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s42,
		I1 => s41,
		O0 => s31,
		Sel1 => s40,
		clk => \clk\,
		reset => \reset\,
		we => s116(0)
	);

	\step_shr_c_op_s_2\: shr_c_op_s
	generic map (
		s_amount => 2,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s70,
		O0 => s51
	);

	\index3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s36,
		I1 => s35,
		O0 => s42,
		Sel1 => s34,
		clk => \clk\,
		reset => \reset\,
		we => s112(0)
	);

	\c86\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s129,
		a_delayed => s114,
		clk => \clk\,
		reset => \reset\
	);

	\c84\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s129,
		a_delayed => s110,
		clk => \clk\,
		reset => \reset\
	);

	\c88\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s129,
		a_delayed => s118,
		clk => \clk\,
		reset => \reset\
	);

	\c82\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s129,
		a_delayed => s106,
		clk => \clk\,
		reset => \reset\
	);

	\valpred3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s87,
		I1 => s86,
		O0 => s92,
		Sel1 => s85,
		clk => \clk\,
		reset => \reset\,
		we => s128(0)
	);

	\delta2_and_op_1\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s65,
		I1 => s46,
		O0 => s47
	);

	\vpdiff2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s69,
		I1 => s53,
		O0 => s64,
		Sel1 => s134,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\valpred_sub_op_s_vpdiff4\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s94,
		I1 => s79,
		O0 => s81
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
		done => s96,
		input => s0,
		output => s97,
		reset => \reset\,
		step => s129,
		termination => s1
	);

	\bufferstep\: reg_op
	generic map (
		initial => 1,
		w_in => 1
	)
	port map (
		I0 => s27,
		O0 => s26,
		clk => \clk\,
		reset => \reset\,
		we => s108(0)
	);

	\bufferstep_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s26,
		O0 => s6
	);

	\outdata\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address(9 downto 0) => s98(9 downto 0),
		clk => \clk\,
		data_in => s94,
		data_out => s95,
		we => s100(0)
	);

	\c99\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s139,
		a_delayed => s140,
		clk => \clk\,
		reset => \reset\
	);

	\vpdiff3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s64,
		I1 => s63,
		O0 => s73,
		Sel1 => s132,
		clk => \clk\,
		reset => \reset\,
		we => s122(0)
	);

	\vpdiff4\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s73,
		I1 => s140,
		O0 => s79,
		Sel1 => s136,
		clk => \clk\,
		reset => \reset\,
		we => s124(0)
	);

	\index_add_op_s_indexTable_data_out\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s31,
		I1 => s29,
		O0 => s30
	);

	\inputbuffer_shr_c_op_s_4_and_op_15\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s10,
		I1 => s11,
		O0 => s14
	);

	\bufferstep_not_op_\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s26,
		O0 => s18
	);

	\delta_and_op_7\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s23,
		I1 => s24,
		O0 => s25
	);

	\c80\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s129,
		a_delayed => s102,
		clk => \clk\,
		reset => \reset\
	);

	\c78\: delay_op
	generic map (
		bits => 11,
		delay => 15
	)
	port map (
		a => s97,
		a_delayed => s98,
		clk => \clk\,
		reset => \reset\
	);

	\step_shr_c_op_s_1\: shr_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s70,
		O0 => s61
	);

	\delta2_and_op_4_if_gt_op_s_0\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s67,
		I1 => s68,
		O0 => s135
	);

	\delta2_and_op_2\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s65,
		I1 => s56,
		O0 => s57
	);

	\c95\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a => s131,
		a_delayed => s132,
		clk => \clk\,
		reset => \reset\
	);

	\c93\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s129,
		a_delayed => s128,
		clk => \clk\,
		reset => \reset\
	);

	\c97\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a => s135,
		a_delayed => s136,
		clk => \clk\,
		reset => \reset\
	);

	\c91\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s129,
		a_delayed => s124,
		clk => \clk\,
		reset => \reset\
	);

	\indexTable\: block_ram_indexTable
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address(3 downto 0) => s23(3 downto 0),
		clk => \clk\,
		data_out => s29
	);

	\step\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s37,
		O0 => s70,
		clk => \clk\,
		reset => \reset\,
		we => s114(0)
	);

	\inputbuffer\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s5,
		O0 => s9,
		clk => \clk\,
		reset => \reset\,
		we => s6(0)
	);

	\done\ <= s96;
	s35 <= conv_std_logic_vector(0, 32);
	s48 <= conv_std_logic_vector(0, 32);
	s41 <= conv_std_logic_vector(88, 32);
	s58 <= conv_std_logic_vector(0, 32);
	s17 <= conv_std_logic_vector(1, 9);
	s8 <= conv_std_logic_vector(15, 32);
	s0 <= conv_std_logic_vector(0, 11);
	s24 <= conv_std_logic_vector(7, 32);
	\output\ <= s95;
	s75 <= conv_std_logic_vector(0, 32);
	s91 <= conv_std_logic_vector(-32768, 32);
	s86 <= conv_std_logic_vector(32767, 32);
	s33 <= conv_std_logic_vector(0, 32);
	s39 <= conv_std_logic_vector(88, 32);
	s66 <= conv_std_logic_vector(4, 32);
	s46 <= conv_std_logic_vector(1, 32);
	s56 <= conv_std_logic_vector(2, 32);
	s11 <= conv_std_logic_vector(15, 32);
	s89 <= conv_std_logic_vector(-32768, 32);
	s84 <= conv_std_logic_vector(32767, 32);
	s68 <= conv_std_logic_vector(0, 32);
	s20 <= conv_std_logic_vector(8, 32);
	s1 <= conv_std_logic_vector(1024, 11);
	s2 <= \init\;

end behavior;

