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
-- Generated at Tue May 28 15:50:42 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity adpcm_coder is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end adpcm_coder;

architecture behavior of adpcm_coder is

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

component if_ge_op_s
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

component if_ne_op_s
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

component or_op
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

component shl_c_op_s
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
signal s174	: std_logic_vector(0 downto 0);
signal s89	: std_logic_vector(31 downto 0);
signal s85	: std_logic_vector(31 downto 0);
signal s119	: std_logic_vector(31 downto 0);
signal s178	: std_logic_vector(0 downto 0);
signal s30	: std_logic_vector(0 downto 0);
signal s34	: std_logic_vector(31 downto 0);
signal s64	: std_logic_vector(0 downto 0);
signal s123	: std_logic_vector(0 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s102	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(31 downto 0);
signal s51	: std_logic_vector(31 downto 0);
signal s195	: std_logic_vector(0 downto 0);
signal s136	: std_logic_vector(31 downto 0);
signal s140	: std_logic_vector(0 downto 0);
signal s81	: std_logic_vector(31 downto 0);
signal s170	: std_logic_vector(0 downto 0);
signal s200	: std_logic_vector(31 downto 0);
signal s115	: std_logic_vector(31 downto 0);
signal s56	: std_logic_vector(31 downto 0);
signal s145	: std_logic_vector(31 downto 0);
signal s5	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(10 downto 0);
signal s43	: std_logic_vector(31 downto 0);
signal s73	: std_logic_vector(31 downto 0);
signal s132	: std_logic_vector(31 downto 0);
signal s18	: std_logic_vector(0 downto 0);
signal s77	: std_logic_vector(31 downto 0);
signal s162	: std_logic_vector(0 downto 0);
signal s166	: std_logic_vector(0 downto 0);
signal s196	: std_logic_vector(0 downto 0);
signal s48	: std_logic_vector(0 downto 0);
signal s192	: std_logic_vector(0 downto 0);
signal s107	: std_logic_vector(31 downto 0);
signal s141	: std_logic_vector(31 downto 0);
signal s120	: std_logic_vector(31 downto 0);
signal s124	: std_logic_vector(0 downto 0);
signal s31	: std_logic_vector(31 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s10	: std_logic_vector(0 downto 0);
signal s158	: std_logic_vector(0 downto 0);
signal s65	: std_logic_vector(31 downto 0);
signal s154	: std_logic_vector(0 downto 0);
signal s133	: std_logic_vector(31 downto 0);
signal s40	: std_logic_vector(31 downto 0);
signal s129	: std_logic_vector(31 downto 0);
signal s188	: std_logic_vector(0 downto 0);
signal s23	: std_logic_vector(0 downto 0);
signal s108	: std_logic_vector(31 downto 0);
signal s74	: std_logic_vector(31 downto 0);
signal s78	: std_logic_vector(0 downto 0);
signal s146	: std_logic;
signal s57	: std_logic_vector(31 downto 0);
signal s201	: std_logic_vector(31 downto 0);
signal s112	: std_logic_vector(31 downto 0);
signal s36	: std_logic_vector(31 downto 0);
signal s180	: std_logic_vector(0 downto 0);
signal s184	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(31 downto 0);
signal s150	: std_logic_vector(0 downto 0);
signal s2	: std_logic;
signal s100	: std_logic_vector(0 downto 0);
signal s11	: std_logic_vector(31 downto 0);
signal s104	: std_logic_vector(31 downto 0);
signal s193	: std_logic;
signal s125	: std_logic_vector(8 downto 0);
signal s66	: std_logic_vector(31 downto 0);
signal s70	: std_logic_vector(31 downto 0);
signal s172	: std_logic_vector(0 downto 0);
signal s117	: std_logic_vector(31 downto 0);
signal s176	: std_logic_vector(0 downto 0);
signal s49	: std_logic_vector(31 downto 0);
signal s197	: std_logic_vector(31 downto 0);
signal s142	: std_logic_vector(0 downto 0);
signal s83	: std_logic_vector(31 downto 0);
signal s96	: std_logic_vector(31 downto 0);
signal s41	: std_logic_vector(0 downto 0);
signal s126	: std_logic_vector(8 downto 0);
signal s7	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(10 downto 0);
signal s92	: std_logic_vector(31 downto 0);
signal s168	: std_logic_vector(0 downto 0);
signal s109	: std_logic_vector(31 downto 0);
signal s24	: std_logic_vector(31 downto 0);
signal s113	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s202	: std_logic_vector(31 downto 0);
signal s198	: std_logic_vector(31 downto 0);
signal s130	: std_logic_vector(0 downto 0);
signal s134	: std_logic_vector(31 downto 0);
signal s164	: std_logic_vector(0 downto 0);
signal s79	: std_logic_vector(31 downto 0);
signal s63	: std_logic_vector(31 downto 0);
signal s118	: std_logic_vector(0 downto 0);
signal s88	: std_logic_vector(31 downto 0);
signal s143	: std_logic_vector(0 downto 0);
signal s139	: std_logic_vector(0 downto 0);
signal s135	: std_logic_vector(31 downto 0);
signal s194	: std_logic_vector(0 downto 0);
signal s190	: std_logic_vector(0 downto 0);
signal s105	: std_logic_vector(0 downto 0);
signal s16	: std_logic_vector(31 downto 0);
signal s12	: std_logic_vector(31 downto 0);
signal s160	: std_logic_vector(0 downto 0);
signal s101	: std_logic_vector(31 downto 0);
signal s71	: std_logic_vector(0 downto 0);
signal s67	: std_logic_vector(31 downto 0);
signal s156	: std_logic_vector(0 downto 0);
signal s144	: std_logic_vector(0 downto 0);
signal s59	: std_logic_vector(31 downto 0);
signal s199	: std_logic_vector(31 downto 0);
signal s114	: std_logic_vector(31 downto 0);
signal s55	: std_logic_vector(0 downto 0);
signal s25	: std_logic_vector(31 downto 0);
signal s110	: std_logic_vector(31 downto 0);
signal s80	: std_logic_vector(31 downto 0);
signal s72	: std_logic_vector(31 downto 0);
signal s131	: std_logic_vector(31 downto 0);
signal s127	: std_logic_vector(0 downto 0);
signal s186	: std_logic_vector(0 downto 0);
signal s42	: std_logic_vector(31 downto 0);
signal s182	: std_logic_vector(0 downto 0);
signal s97	: std_logic_vector(31 downto 0);
signal s152	: std_logic_vector(0 downto 0);
signal s148	: std_logic_vector(0 downto 0);
signal s4	: std_logic_vector(31 downto 0);

begin

	\indexTable\: block_ram_indexTable
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address(3 downto 0) => s133(3 downto 0),
		clk => \clk\,
		data_out => s109
	);

	\outdata\: block_ram
	generic map (
		address_width => 9,
		data_width => 32
	)
	port map (
		address => s125,
		clk => \clk\,
		data_in => s141,
		data_out => s145,
		we => s142(0)
	);

	\c119\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s193,
		a_delayed => s180,
		clk => \clk\,
		reset => \reset\
	);

	\c104\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s193,
		a_delayed => s150,
		clk => \clk\,
		reset => \reset\
	);

	\diff3_if_ge_op_s_step2__\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s67,
		I1 => s70,
		O0 => s71
	);

	\step_shr_c_op_s_1\: shr_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s54,
		O0 => s34
	);

	\delta2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s43,
		I1 => s42,
		O0 => s66,
		Sel1 => s41,
		clk => \clk\,
		reset => \reset\,
		we => s166(0)
	);

	\index3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s115,
		I1 => s114,
		O0 => s132,
		Sel1 => s113,
		clk => \clk\,
		reset => \reset\,
		we => s188(0)
	);

	\c123\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s193,
		a_delayed => s188,
		clk => \clk\,
		reset => \reset\
	);

	\c121\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s193,
		a_delayed => s184,
		clk => \clk\,
		reset => \reset\
	);

	\c125\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s193,
		a_delayed => s192,
		clk => \clk\,
		reset => \reset\
	);

	\stepSizeTable\: block_ram_stepSizeTable
	generic map (
		address_width => 7,
		data_width => 32
	)
	port map (
		address(6 downto 0) => s108(6 downto 0),
		clk => \clk\,
		data_out => s14
	);

	\len_step_delay_op_14\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s193,
		a_delayed => s124,
		clk => \clk\,
		reset => \reset\
	);

	\valpred\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s120,
		I1 => s119,
		O0 => s88,
		Sel1 => s118,
		clk => \clk\,
		reset => \reset\,
		we => s190(0)
	);

	\index3_if_gt_op_s_88\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s132,
		I1 => s129,
		O0 => s130
	);

	\indata\: block_ram_indata
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address(9 downto 0) => s3(9 downto 0),
		clk => \clk\,
		data_out => s4
	);

	\len\: counter
	generic map (
		bits => 11,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 12
	)
	port map (
		clk => \clk\,
		clk_en => s2,
		done => s146,
		input => s0,
		output => s3,
		reset => \reset\,
		step => s193,
		termination => s1
	);

	\diff2_sub_op_s_step\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s51,
		I1 => s54,
		O0 => s31
	);

	\c117\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s193,
		a_delayed => s176,
		clk => \clk\,
		reset => \reset\
	);

	\diff3_if_ge_op_s_step2\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s67,
		I1 => s70,
		O0 => s41
	);

	\c106\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s193,
		a_delayed => s154,
		clk => \clk\,
		reset => \reset\
	);

	\delta3_or_op_sign\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s81,
		I1 => s198,
		O0 => s83
	);

	\vpdiff3_add_op_s_step3\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s80,
		I1 => s77,
		O0 => s79
	);

	\vpdiff3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s73,
		I1 => s72,
		O0 => s80,
		Sel1 => s71,
		clk => \clk\,
		reset => \reset\,
		we => s176(0)
	);

	\valpred_sub_op_s_vpdiff4\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s88,
		I1 => s89,
		O0 => s91
	);

	\sign_if_ne_op_s_0\: if_ne_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s197,
		I1 => s16,
		O0 => s18
	);

	\delta\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s25,
		I1 => s24,
		O0 => s43,
		Sel1 => s23,
		clk => \clk\,
		reset => \reset\,
		we => s158(0)
	);

	\diff4\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s67,
		I1 => s49,
		O0 => s74,
		Sel1 => s48,
		clk => \clk\,
		reset => \reset\,
		we => s168(0)
	);

	\c111\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s193,
		a_delayed => s164,
		clk => \clk\,
		reset => \reset\
	);

	\c126\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s193,
		a_delayed => s194,
		clk => \clk\,
		reset => \reset\
	);

	\step2_shr_c_op_s_1\: shr_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s70,
		O0 => s59
	);

	\c115\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s193,
		a_delayed => s172,
		clk => \clk\,
		reset => \reset\
	);

	\valpred2_if_gt_op_s_32767\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s107,
		I1 => s104,
		O0 => s105
	);

	\len_step_delay_op_11\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s193,
		a_delayed => s100,
		clk => \clk\,
		reset => \reset\
	);

	\delta4_shl_c_op_s_4\: shl_c_op_s
	generic map (
		s_amount => 4,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s133,
		O0 => s96
	);

	\index_add_op_s_indexTable_data_out\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s108,
		I1 => s109,
		O0 => s110
	);

	\step\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s14,
		O0 => s54,
		clk => \clk\,
		reset => \reset\,
		we => s154(0)
	);

	\step2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s34,
		O0 => s70,
		clk => \clk\,
		reset => \reset\,
		we => s162(0)
	);

	\step3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s59,
		O0 => s77,
		clk => \clk\,
		reset => \reset\,
		we => s172(0)
	);

	\c109\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s193,
		a_delayed => s160,
		clk => \clk\,
		reset => \reset\
	);

	\diff_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s201,
		I1 => s9,
		O0 => s10
	);

	\diff2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s202,
		I1 => s200,
		O0 => s51,
		Sel1 => s18,
		clk => \clk\,
		reset => \reset\,
		we => s156(0)
	);

	\c128\: delay_op
	generic map (
		bits => 32,
		delay => 5
	)
	port map (
		a => s197,
		a_delayed => s198,
		clk => \clk\,
		reset => \reset\
	);

	\c113\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s193,
		a_delayed => s168,
		clk => \clk\,
		reset => \reset\
	);

	\valpred_add_op_s_vpdiff4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s88,
		I1 => s89,
		O0 => s92
	);

	\delta2_or_op_1\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s66,
		I1 => s63,
		O0 => s65
	);

	\vpdiff_add_op_s_step\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s57,
		I1 => s54,
		O0 => s56
	);

	\delta4_and_op_15_or_op_outputbuffer\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s135,
		I1 => s136,
		O0 => s141
	);

	\c130\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s201,
		a_delayed => s202,
		clk => \clk\,
		reset => \reset\
	);

	\val\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s4,
		O0 => s5,
		clk => \clk\,
		reset => \reset\,
		we => s148(0)
	);

	\bufferstep_not_op__\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s143,
		O0 => s144
	);

	\len_step_delay_op_15\: delay_op
	generic map (
		bits => 1,
		delay => 15
	)
	port map (
		a(0) => s193,
		a_delayed => s140,
		clk => \clk\,
		reset => \reset\
	);

	\index2_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s115,
		I1 => s112,
		O0 => s113
	);

	\c122\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s193,
		a_delayed => s186,
		clk => \clk\,
		reset => \reset\
	);

	\sign_if_ne_op_s_0_\: if_ne_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s197,
		I1 => s85,
		O0 => s195
	);

	\diff4_if_ge_op_s_step3_\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s74,
		I1 => s77,
		O0 => s78
	);

	\c118\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s193,
		a_delayed => s178,
		clk => \clk\,
		reset => \reset\
	);

	\c107\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s193,
		a_delayed => s156,
		clk => \clk\,
		reset => \reset\
	);

	\diff3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s51,
		I1 => s31,
		O0 => s67,
		Sel1 => s30,
		clk => \clk\,
		reset => \reset\,
		we => s160(0)
	);

	\c103\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s193,
		a_delayed => s148,
		clk => \clk\,
		reset => \reset\
	);

	\delta_or_op_2\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s43,
		I1 => s40,
		O0 => s42
	);

	\diff2_if_ge_op_s_step_\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s51,
		I1 => s54,
		O0 => s30
	);

	\c120\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s193,
		a_delayed => s182,
		clk => \clk\,
		reset => \reset\
	);

	\vpdiff4\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s80,
		I1 => s79,
		O0 => s89,
		Sel1 => s78,
		clk => \clk\,
		reset => \reset\,
		we => s178(0)
	);

	\c124\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s193,
		a_delayed => s190,
		clk => \clk\,
		reset => \reset\
	);

	\step_shr_c_op_s_3\: shr_c_op_s
	generic map (
		s_amount => 3,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s54,
		O0 => s36
	);

	\diff3_if_ge_op_s_step2_\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s67,
		I1 => s70,
		O0 => s48
	);

	\c105\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s193,
		a_delayed => s152,
		clk => \clk\,
		reset => \reset\
	);

	\vpdiff2_add_op_s_step2\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s73,
		I1 => s70,
		O0 => s72
	);

	\bufferstep\: reg_op
	generic map (
		initial => 1,
		w_in => 1
	)
	port map (
		I0 => s144,
		O0 => s143,
		clk => \clk\,
		reset => \reset\,
		we => s194(0)
	);

	\diff\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s7,
		O0 => s201,
		clk => \clk\,
		reset => \reset\,
		we => s150(0)
	);

	\i\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 9,
		w_in2 => 9,
		w_out => 9
	)
	port map (
		I0 => s125,
		I1 => s126,
		O0 => s125,
		clk => \clk\,
		reset => \reset\,
		we => s127(0)
	);

	\delta4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s83,
		O0 => s133,
		clk => \clk\,
		reset => \reset\,
		we => s180(0)
	);

	\valpred3_if_lt_op_s_-32768\: if_lt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s120,
		I1 => s117,
		O0 => s118
	);

	\index\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s132,
		I1 => s131,
		O0 => s108,
		Sel1 => s130,
		clk => \clk\,
		reset => \reset\,
		we => s192(0)
	);

	\bufferstep_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s143,
		O0 => s123
	);

	\bufferstep_not_op_and_op_len_step_delay_op_14\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s123,
		I1 => s124,
		O0 => s127
	);

	\bufferstep_and_op_len_step_delay_op_11\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s143,
		I1 => s100,
		O0 => s102
	);

	\vpdiff2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s57,
		I1 => s56,
		O0 => s73,
		Sel1 => s55,
		clk => \clk\,
		reset => \reset\,
		we => s170(0)
	);

	\delta3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s66,
		I1 => s65,
		O0 => s81,
		Sel1 => s64,
		clk => \clk\,
		reset => \reset\,
		we => s174(0)
	);

	\c129\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s199,
		a_delayed => s200,
		clk => \clk\,
		reset => \reset\
	);

	\c114\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s193,
		a_delayed => s170,
		clk => \clk\,
		reset => \reset\
	);

	\valpred2\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s92,
		I1 => s91,
		O0 => s107,
		Sel1 => s196,
		clk => \clk\,
		reset => \reset\,
		we => s182(0)
	);

	\diff2_if_ge_op_s_step\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s51,
		I1 => s54,
		O0 => s23
	);

	\val_sub_op_s_valpred\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s5,
		I1 => s88,
		O0 => s7
	);

	\sign\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s12,
		I1 => s11,
		O0 => s197,
		Sel1 => s10,
		clk => \clk\,
		reset => \reset\,
		we => s152(0)
	);

	\c110\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s193,
		a_delayed => s162,
		clk => \clk\,
		reset => \reset\
	);

	\c108\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s193,
		a_delayed => s158,
		clk => \clk\,
		reset => \reset\
	);

	\diff_neg_op_s\: neg_op_s
	generic map (
		w_in => 32,
		w_out => 32
	)
	port map (
		I0 => s201,
		O0 => s199
	);

	\bufferstep_not_op_and_op_len_step_delay_op_15\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s139,
		I1 => s140,
		O0 => s142
	);

	\bufferstep_not_op_\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0 => s143,
		O0 => s139
	);

	\delta4_and_op_15\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s133,
		I1 => s134,
		O0 => s135
	);

	\valpred3\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s107,
		I1 => s106,
		O0 => s120,
		Sel1 => s105,
		clk => \clk\,
		reset => \reset\,
		we => s184(0)
	);

	\delta4_shl_c_op_s_4_and_op_240\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s96,
		I1 => s97,
		O0 => s101
	);

	\c127\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a => s195,
		a_delayed => s196,
		clk => \clk\,
		reset => \reset\
	);

	\diff2_if_ge_op_s_step__\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s51,
		I1 => s54,
		O0 => s55
	);

	\c116\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s193,
		a_delayed => s174,
		clk => \clk\,
		reset => \reset\
	);

	\c112\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s193,
		a_delayed => s166,
		clk => \clk\,
		reset => \reset\
	);

	\diff4_if_ge_op_s_step3\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s74,
		I1 => s77,
		O0 => s64
	);

	\diff3_sub_op_s_step2\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s67,
		I1 => s70,
		O0 => s49
	);

	\outputbuffer\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s101,
		O0 => s136,
		clk => \clk\,
		reset => \reset\,
		we => s102(0)
	);

	\index2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s110,
		O0 => s115,
		clk => \clk\,
		reset => \reset\,
		we => s186(0)
	);

	\vpdiff\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s36,
		O0 => s57,
		clk => \clk\,
		reset => \reset\,
		we => s164(0)
	);

	\done\ <= s146;
	s129 <= conv_std_logic_vector(88, 32);
	s40 <= conv_std_logic_vector(2, 32);
	s12 <= conv_std_logic_vector(0, 32);
	s24 <= conv_std_logic_vector(4, 32);
	s134 <= conv_std_logic_vector(15, 32);
	s0 <= conv_std_logic_vector(0, 11);
	s9 <= conv_std_logic_vector(0, 32);
	s114 <= conv_std_logic_vector(0, 32);
	\output\ <= s145;
	s63 <= conv_std_logic_vector(1, 32);
	s97 <= conv_std_logic_vector(240, 32);
	s119 <= conv_std_logic_vector(-32768, 32);
	s106 <= conv_std_logic_vector(32767, 32);
	s16 <= conv_std_logic_vector(0, 32);
	s11 <= conv_std_logic_vector(8, 32);
	s25 <= conv_std_logic_vector(0, 32);
	s1 <= conv_std_logic_vector(1024, 11);
	s131 <= conv_std_logic_vector(88, 32);
	s126 <= conv_std_logic_vector(1, 9);
	s112 <= conv_std_logic_vector(0, 32);
	s104 <= conv_std_logic_vector(32767, 32);
	s117 <= conv_std_logic_vector(-32768, 32);
	s85 <= conv_std_logic_vector(0, 32);
	s2 <= \init\;

end behavior;

