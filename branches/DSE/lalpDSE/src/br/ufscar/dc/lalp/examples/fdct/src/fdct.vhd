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
-- Generated at Fri Jun 21 16:26:00 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity fdct is
	port (
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0)
	);
end fdct;

architecture behavior of fdct is

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

component block_ram_dct_io_ptr
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

signal s0	: std_logic_vector(9 downto 0);
signal s233	: std_logic_vector(0 downto 0);
signal s89	: std_logic_vector(0 downto 0);
signal s85	: std_logic_vector(0 downto 0);
signal s119	: std_logic_vector(0 downto 0);
signal s30	: std_logic_vector(31 downto 0);
signal s34	: std_logic_vector(31 downto 0);
signal s64	: std_logic_vector(31 downto 0);
signal s123	: std_logic_vector(0 downto 0);
signal s9	: std_logic;
signal s153	: std_logic_vector(0 downto 0);
signal s17	: std_logic_vector(9 downto 0);
signal s157	: std_logic_vector(0 downto 0);
signal s161	: std_logic_vector(0 downto 0);
signal s191	: std_logic_vector(0 downto 0);
signal s51	: std_logic_vector(31 downto 0);
signal s195	: std_logic_vector(0 downto 0);
signal s225	: std_logic_vector(0 downto 0);
signal s229	: std_logic_vector(0 downto 0);
signal s81	: std_logic_vector(0 downto 0);
signal s111	: std_logic_vector(0 downto 0);
signal s115	: std_logic_vector(0 downto 0);
signal s60	: std_logic_vector(31 downto 0);
signal s56	: std_logic_vector(31 downto 0);
signal s145	: std_logic_vector(0 downto 0);
signal s5	: std_logic_vector(9 downto 0);
signal s1	: std_logic_vector(9 downto 0);
signal s149	: std_logic_vector(0 downto 0);
signal s183	: std_logic_vector(0 downto 0);
signal s187	: std_logic_vector(0 downto 0);
signal s39	: std_logic_vector(9 downto 0);
signal s73	: std_logic_vector(0 downto 0);
signal s217	: std_logic_vector(0 downto 0);
signal s221	: std_logic_vector(0 downto 0);
signal s18	: std_logic;
signal s77	: std_logic_vector(0 downto 0);
signal s137	: std_logic_vector(0 downto 0);
signal s52	: std_logic_vector(31 downto 0);
signal s48	: std_logic_vector(31 downto 0);
signal s107	: std_logic_vector(0 downto 0);
signal s103	: std_logic_vector(0 downto 0);
signal s27	: std_logic_vector(31 downto 0);
signal s171	: std_logic_vector(0 downto 0);
signal s175	: std_logic_vector(0 downto 0);
signal s141	: std_logic_vector(0 downto 0);
signal s209	: std_logic_vector(0 downto 0);
signal s31	: std_logic_vector(31 downto 0);
signal s35	: std_logic_vector(31 downto 0);
signal s179	: std_logic_vector(0 downto 0);
signal s243	: std_logic_vector(0 downto 0);
signal s14	: std_logic_vector(9 downto 0);
signal s247	: std_logic_vector(0 downto 0);
signal s10	: std_logic_vector(0 downto 0);
signal s99	: std_logic_vector(0 downto 0);
signal s65	: std_logic;
signal s213	: std_logic_vector(0 downto 0);
signal s69	: std_logic_vector(0 downto 0);
signal s133	: std_logic_vector(0 downto 0);
signal s40	: std_logic_vector(9 downto 0);
signal s129	: std_logic_vector(0 downto 0);
signal s19	: std_logic_vector(9 downto 0);
signal s167	: std_logic_vector(0 downto 0);
signal s163	: std_logic_vector(0 downto 0);
signal s205	: std_logic_vector(0 downto 0);
signal s61	: std_logic_vector(31 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s201	: std_logic_vector(0 downto 0);
signal s36	: std_logic_vector(31 downto 0);
signal s95	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(0 downto 0);
signal s235	: std_logic_vector(0 downto 0);
signal s6	: std_logic_vector(9 downto 0);
signal s239	: std_logic_vector(0 downto 0);
signal s159	: std_logic_vector(0 downto 0);
signal s11	: std_logic_vector(0 downto 0);
signal s248	: std_logic;
signal s15	: std_logic_vector(9 downto 0);
signal s193	: std_logic_vector(0 downto 0);
signal s189	: std_logic_vector(0 downto 0);
signal s121	: std_logic_vector(0 downto 0);
signal s125	: std_logic_vector(0 downto 0);
signal s155	: std_logic_vector(0 downto 0);
signal s87	: std_logic_vector(0 downto 0);
signal s231	: std_logic_vector(0 downto 0);
signal s28	: std_logic_vector(31 downto 0);
signal s32	: std_logic_vector(31 downto 0);
signal s117	: std_logic_vector(0 downto 0);
signal s49	: std_logic_vector(31 downto 0);
signal s53	: std_logic_vector(31 downto 0);
signal s197	: std_logic_vector(0 downto 0);
signal s227	: std_logic_vector(0 downto 0);
signal s83	: std_logic_vector(0 downto 0);
signal s181	: std_logic_vector(0 downto 0);
signal s37	: std_logic_vector(9 downto 0);
signal s185	: std_logic_vector(0 downto 0);
signal s58	: std_logic_vector(31 downto 0);
signal s62	: std_logic_vector(31 downto 0);
signal s147	: std_logic_vector(0 downto 0);
signal s7	: std_logic_vector(9 downto 0);
signal s151	: std_logic_vector(0 downto 0);
signal s109	: std_logic_vector(0 downto 0);
signal s113	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s219	: std_logic_vector(0 downto 0);
signal s223	: std_logic_vector(0 downto 0);
signal s75	: std_logic_vector(0 downto 0);
signal s79	: std_logic_vector(0 downto 0);
signal s63	: std_logic_vector(31 downto 0);
signal s211	: std_logic_vector(0 downto 0);
signal s207	: std_logic_vector(0 downto 0);
signal s177	: std_logic_vector(0 downto 0);
signal s29	: std_logic_vector(31 downto 0);
signal s33	: std_logic_vector(31 downto 0);
signal s173	: std_logic_vector(0 downto 0);
signal s143	: std_logic_vector(0 downto 0);
signal s139	: std_logic_vector(0 downto 0);
signal s50	: std_logic_vector(31 downto 0);
signal s135	: std_logic_vector(0 downto 0);
signal s105	: std_logic_vector(0 downto 0);
signal s249	: std_logic_vector(0 downto 0);
signal s16	: std_logic_vector(9 downto 0);
signal s12	: std_logic;
signal s245	: std_logic_vector(0 downto 0);
signal s101	: std_logic_vector(0 downto 0);
signal s71	: std_logic_vector(0 downto 0);
signal s67	: std_logic_vector(0 downto 0);
signal s215	: std_logic_vector(0 downto 0);
signal s59	: std_logic_vector(31 downto 0);
signal s203	: std_logic_vector(0 downto 0);
signal s199	: std_logic_vector(0 downto 0);
signal s55	: std_logic_vector(31 downto 0);
signal s169	: std_logic_vector(0 downto 0);
signal s165	: std_logic_vector(0 downto 0);
signal s131	: std_logic_vector(0 downto 0);
signal s127	: std_logic_vector(0 downto 0);
signal s38	: std_logic_vector(9 downto 0);
signal s241	: std_logic_vector(0 downto 0);
signal s93	: std_logic_vector(0 downto 0);
signal s97	: std_logic_vector(0 downto 0);
signal s237	: std_logic_vector(0 downto 0);
signal s8	: std_logic;
signal s148	: std_logic;
signal s4	: std_logic_vector(9 downto 0);

begin

	\c174\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s177
	);

	\P_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s30,
		we => s123(0)
	);

	\Q_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s129(0)
	);

	\c119\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s67
	);

	\c178\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s185
	);

	\f4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s75(0)
	);

	\f0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s67(0)
	);

	\xf1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s153(0)
	);

	\c208\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s245
	);

	\c123\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s75
	);

	\xF3r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s58,
		we => s241(0)
	);

	\dct_io_ptr\: block_ram_dct_io_ptr
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address => s19,
		data_out => s27
	);

	\c153\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s135
	);

	\xh2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s50,
		we => s169(0)
	);

	\dct_o\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		data_in => s63,
		data_out => s64
	);

	\c157\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s148,
		a_delayed => s143
	);

	\c161\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s151
	);

	\xQ_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s213(0)
	);

	\xi\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		done => s65,
		input => s37,
		termination => s38
	);

	\c191\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s211
	);

	\xq0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s197(0)
	);

	\xF_2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s53,
		we => s231(0)
	);

	\c195\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s219
	);

	\c136\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s101
	);

	\c140\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s109
	);

	\R_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s32,
		we => s119(0)
	);

	\F_3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s141(0)
	);

	\q0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s113(0)
	);

	\c170\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s169
	);

	\c200\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s229
	);

	\q0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s117(0)
	);

	\xf6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s163(0)
	);

	\c204\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s237
	);

	\c145\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s119
	);

	\g2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s28,
		we => s97(0)
	);

	\c149\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s127
	);

	\j_plus_64\: reg_op
	generic map (
		initial => 0,
		w_in => 10
	)
	port map (
		I0 => s15,
		O0 => s17
	);

	\c183\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s195
	);

	\xR_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s53,
		we => s203(0)
	);

	\h2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s29,
		we => s85(0)
	);

	\c128\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s85
	);

	\c187\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s203
	);

	\xF_4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s52,
		we => s229(0)
	);

	\r1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s105(0)
	);

	\p1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s103(0)
	);

	\c132\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s93
	);

	\xh0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s179(0)
	);

	\xq0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s199(0)
	);

	\c162\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s153
	);

	\c166\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s161
	);

	\c196\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s221
	);

	\c137\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s103
	);

	\xs1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s50,
		we => s193(0)
	);

	\xg0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s167(0)
	);

	\c192\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s213
	);

	\i_add_op_s_8\: add_op_s
	generic map (
		w_in1 => 10,
		w_in2 => 10,
		w_out => 10
	)
	port map (
		I0 => s6,
		I1 => s4,
		O0 => s5
	);

	\xP_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s52,
		we => s209(0)
	);

	\f7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s81(0)
	);

	\xp1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s187(0)
	);

	\c171\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s171
	);

	\c175\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s179
	);

	\R_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s33,
		we => s121(0)
	);

	\c141\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s111
	);

	\c120\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s69
	);

	\c209\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s247
	);

	\c124\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s77
	);

	\f3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s73(0)
	);

	\xF2r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s57,
		we => s239(0)
	);

	\c179\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s187
	);

	\s0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s111(0)
	);

	\s1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s29,
		we => s109(0)
	);

	\c158\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s148,
		a_delayed => s145
	);

	\xR_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s54,
		we => s205(0)
	);

	\xf0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s151(0)
	);

	\xr1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s189(0)
	);

	\c154\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s137
	);

	\c133\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s95
	);

	\xF_5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s223(0)
	);

	\xg2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s49,
		we => s181(0)
	);

	\c129\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s87
	);

	\c188\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s205
	);

	\F_6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s33,
		we => s149(0)
	);

	\c167\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s163
	);

	\F_2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s32,
		we => s147(0)
	);

	\i_done_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0(0) => s8,
		O0 => s10
	);

	\p0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s99(0)
	);

	\S_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s131(0)
	);

	\c163\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s155
	);

	\c205\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s239
	);

	\c146\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s121
	);

	\xf3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s157(0)
	);

	\xf5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s161(0)
	);

	\c201\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s231
	);

	\xs0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s195(0)
	);

	\xS_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s217(0)
	);

	\c180\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s189
	);

	\c184\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s197
	);

	\i_plus_8\: reg_op
	generic map (
		initial => 0,
		w_in => 10
	)
	port map (
		I0 => s5,
		O0 => s7
	);

	\c150\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s129
	);

	\g1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s87(0)
	);

	\c159\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s148,
		a_delayed => s147
	);

	\xF4r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s59,
		we => s243(0)
	);

	\xh3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s173(0)
	);

	\xh1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s175(0)
	);

	\xP_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s51,
		we => s207(0)
	);

	\xF_3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s225(0)
	);

	\c193\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s215
	);

	\c189\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s207
	);

	\c210\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s249
	);

	\c121\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s71
	);

	\c125\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s79
	);

	\c155\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s139
	);

	\j\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 9
	)
	port map (
		clk_en => s11(0),
		input => s6,
		load => s12,
		output => s16,
		step => s18,
		termination => s7
	);

	\xr0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s185(0)
	);

	\xp0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s183(0)
	);

	\c172\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s173
	);

	\f6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s79(0)
	);

	\f2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s71(0)
	);

	\c176\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s181
	);

	\xF_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s219(0)
	);

	\xs0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s201(0)
	);

	\c197\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s223
	);

	\c138\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s105
	);

	\c142\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s113
	);

	\mf\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 32
	)
	port map (
		I0(255 downto 224) => s34(31 downto 0),
		I0(223 downto 192) => s35(31 downto 0),
		O0 => s36
	);

	\h1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s91(0)
	);

	\c181\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s191
	);

	\xF_7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s221(0)
	);

	\xg3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s177(0)
	);

	\c126\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s81
	);

	\c185\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s199
	);

	\q1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s28,
		we => s107(0)
	);

	\xf2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s155(0)
	);

	\c206\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s241
	);

	\c147\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s123
	);

	\i_1\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 8,
		steps => 1
	)
	port map (
		input => s16,
		load => s18,
		output => s19,
		step => s148,
		termination => s17
	);

	\xmf\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 32
	)
	port map (
		I0(255 downto 224) => s55(31 downto 0),
		I0(223 downto 192) => s56(31 downto 0),
		I0(191 downto 160) => s57(31 downto 0),
		I0(159 downto 128) => s58(31 downto 0),
		I0(127 downto 96) => s59(31 downto 0),
		I0(95 downto 64) => s60(31 downto 0),
		I0(63 downto 32) => s61(31 downto 0),
		I0(31 downto 0) => s62(31 downto 0),
		O0 => s63
	);

	\c151\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s131
	);

	\h3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s89(0)
	);

	\c168\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s165
	);

	\init_and_op_i_done_not_op\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0(0) => s9,
		I1 => s10,
		O0 => s11
	);

	\F_5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s139(0)
	);

	\F_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s135(0)
	);

	\xf7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s165(0)
	);

	\c202\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s233
	);

	\c198\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s225
	);

	\c130\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s89
	);

	\c134\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s97
	);

	\c164\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s157
	);

	\xF6r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s61,
		we => s247(0)
	);

	\S_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s133(0)
	);

	\xF7r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s62,
		we => s249(0)
	);

	\c122\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s73
	);

	\c207\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s243
	);

	\c177\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s183
	);

	\f5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s77(0)
	);

	\f1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		we => s69(0)
	);

	\c173\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s175
	);

	\Q_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s127(0)
	);

	\P_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s31,
		we => s125(0)
	);

	\c143\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s115
	);

	\c139\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s107
	);

	\xF_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s51,
		we => s227(0)
	);

	\c135\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s99
	);

	\c194\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s217
	);

	\c190\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s209
	);

	\xj\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 8,
		steps => 8
	)
	port map (
		input => s39,
		step => s248,
		termination => s40
	);

	\xg1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s171(0)
	);

	\F_7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s137(0)
	);

	\s0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s115(0)
	);

	\c160\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s148,
		a_delayed => s149
	);

	\xQ_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s211(0)
	);

	\dct_io_tmp\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		data_in => s36,
		data_out => s48
	);

	\i\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 64,
		steps => 72
	)
	port map (
		clk_en => s9,
		done => s8,
		input => s0,
		output => s6,
		step => s12,
		termination => s1
	);

	\c156\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s141
	);

	\c144\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s117
	);

	\xf4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		we => s159(0)
	);

	\c203\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s235
	);

	\c199\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s248,
		a_delayed => s227
	);

	\xF1r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s56,
		we => s237(0)
	);

	\F_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s30,
		O0 => s34,
		we => s143(0)
	);

	\F_4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s31,
		O0 => s35,
		we => s145(0)
	);

	\c169\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s167
	);

	\j_add_op_s_64\: add_op_s
	generic map (
		w_in1 => 10,
		w_in2 => 10,
		w_out => 10
	)
	port map (
		I0 => s16,
		I1 => s14,
		O0 => s15
	);

	\xq1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s49,
		we => s191(0)
	);

	\xF5r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s60,
		we => s245(0)
	);

	\c165\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s248,
		a_delayed => s159
	);

	\xF0r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		O0 => s55,
		we => s235(0)
	);

	\c131\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s91
	);

	\c127\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s148,
		a_delayed => s83
	);

	\c186\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s201
	);

	\xF_6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s54,
		we => s233(0)
	);

	\r0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s101(0)
	);

	\c182\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s248,
		a_delayed => s193
	);

	\xS_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s215(0)
	);

	\h0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s95(0)
	);

	\c152\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s133
	);

	\g0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s83(0)
	);

	\c148\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s148,
		a_delayed => s125
	);

	\g3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		we => s93(0)
	);

	\done\ <= s65;
	s0 <= conv_std_logic_vector(0, 10);
	s37 <= conv_std_logic_vector(0, 10);
	\output\ <= s64;
	s38 <= conv_std_logic_vector(640, 10);
	s1 <= conv_std_logic_vector(640, 10);
	s9 <= \init\;
	s39 <= conv_std_logic_vector(0, 10);
	s4 <= conv_std_logic_vector(8, 10);
	s40 <= conv_std_logic_vector(640, 10);
	s14 <= conv_std_logic_vector(64, 10);

end behavior;

