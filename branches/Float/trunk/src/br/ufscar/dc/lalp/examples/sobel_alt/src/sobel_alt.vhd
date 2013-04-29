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
-- Generated at Wed Dec 12 13:50:17 BRST 2012
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

signal s174	: std_logic_vector(0 downto 0);
signal s0	: std_logic_vector(15 downto 0);
signal s100	: std_logic_vector(15 downto 0);
signal s11	: std_logic_vector(15 downto 0);
signal s89	: std_logic_vector(15 downto 0);
signal s15	: std_logic_vector(15 downto 0);
signal s85	: std_logic_vector(15 downto 0);
signal s119	: std_logic_vector(0 downto 0);
signal s104	: std_logic_vector(15 downto 0);
signal s178	: std_logic_vector(0 downto 0);
signal s34	: std_logic_vector(15 downto 0);
signal s64	: std_logic_vector(0 downto 0);
signal s123	: std_logic_vector(15 downto 0);
signal s121	: std_logic_vector(15 downto 0);
signal s9	: std_logic_vector(15 downto 0);
signal s66	: std_logic_vector(15 downto 0);
signal s13	: std_logic_vector(15 downto 0);
signal s17	: std_logic_vector(15 downto 0);
signal s172	: std_logic_vector(0 downto 0);
signal s87	: std_logic_vector(15 downto 0);
signal s28	: std_logic_vector(15 downto 0);
signal s102	: std_logic_vector(15 downto 0);
signal s117	: std_logic_vector(15 downto 0);
signal s32	: std_logic_vector(15 downto 0);
signal s176	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(15 downto 0);
signal s51	: std_logic_vector(15 downto 0);
signal s47	: std_logic_vector(0 downto 0);
signal s53	: std_logic_vector(15 downto 0);
signal s136	: std_logic_vector(0 downto 0);
signal s138	: std_logic_vector(0 downto 0);
signal s140	: std_logic_vector(0 downto 0);
signal s142	: std_logic_vector(0 downto 0);
signal s81	: std_logic_vector(15 downto 0);
signal s83	: std_logic_vector(15 downto 0);
signal s22	: std_logic_vector(15 downto 0);
signal s96	: std_logic_vector(15 downto 0);
signal s181	: std_logic_vector(0 downto 0);
signal s170	: std_logic_vector(0 downto 0);
signal s111	: std_logic_vector(15 downto 0);
signal s126	: std_logic_vector(15 downto 0);
signal s115	: std_logic_vector(15 downto 0);
signal s60	: std_logic_vector(0 downto 0);
signal s56	: std_logic_vector(15 downto 0);
signal s7	: std_logic_vector(15 downto 0);
signal s3	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s90	: std_logic_vector(15 downto 0);
signal s92	: std_logic_vector(15 downto 0);
signal s168	: std_logic_vector(0 downto 0);
signal s109	: std_logic_vector(15 downto 0);
signal s98	: std_logic_vector(15 downto 0);
signal s20	: std_logic_vector(15 downto 0);
signal s94	: std_logic_vector(15 downto 0);
signal s128	: std_logic_vector(15 downto 0);
signal s113	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(0 downto 0);
signal s39	: std_logic_vector(0 downto 0);
signal s132	: std_logic_vector(15 downto 0);
signal s130	: std_logic_vector(15 downto 0);
signal s134	: std_logic_vector(15 downto 0);
signal s18	: std_logic_vector(15 downto 0);
signal s164	: std_logic_vector(0 downto 0);
signal s162	: std_logic_vector(0 downto 0);
signal s77	: std_logic_vector(15 downto 0);
signal s75	: std_logic_vector(0 downto 0);
signal s166	: std_logic_vector(0 downto 0);
signal s79	: std_logic_vector(15 downto 0);
signal s63	: std_logic_vector(15 downto 0);
signal s122	: std_logic_vector(15 downto 0);
signal s177	: std_logic;
signal s107	: std_logic_vector(15 downto 0);
signal s29	: std_logic_vector(0 downto 0);
signal s103	: std_logic_vector(15 downto 0);
signal s86	: std_logic_vector(15 downto 0);
signal s84	: std_logic_vector(15 downto 0);
signal s88	: std_logic_vector(15 downto 0);
signal s82	: std_logic_vector(15 downto 0);
signal s120	: std_logic_vector(15 downto 0);
signal s50	: std_logic_vector(0 downto 0);
signal s124	: std_logic_vector(15 downto 0);
signal s31	: std_logic_vector(15 downto 0);
signal s35	: std_logic_vector(0 downto 0);
signal s105	: std_logic_vector(15 downto 0);
signal s179	: std_logic;
signal s46	: std_logic_vector(15 downto 0);
signal s10	: std_logic_vector(15 downto 0);
signal s12	: std_logic_vector(15 downto 0);
signal s158	: std_logic_vector(0 downto 0);
signal s160	: std_logic_vector(0 downto 0);
signal s101	: std_logic_vector(15 downto 0);
signal s99	: std_logic_vector(15 downto 0);
signal s71	: std_logic_vector(15 downto 0);
signal s67	: std_logic_vector(0 downto 0);
signal s156	: std_logic_vector(0 downto 0);
signal s154	: std_logic_vector(0 downto 0);
signal s69	: std_logic_vector(15 downto 0);
signal s144	: std_logic_vector(0 downto 0);
signal s59	: std_logic_vector(15 downto 0);
signal s133	: std_logic_vector(15 downto 0);
signal s44	: std_logic_vector(15 downto 0);
signal s129	: std_logic_vector(0 downto 0);
signal s114	: std_logic_vector(15 downto 0);
signal s19	: std_logic_vector(15 downto 0);
signal s21	: std_logic_vector(15 downto 0);
signal s108	: std_logic_vector(15 downto 0);
signal s23	: std_logic_vector(15 downto 0);
signal s76	: std_logic_vector(15 downto 0);
signal s74	: std_logic_vector(15 downto 0);
signal s80	: std_logic_vector(15 downto 0);
signal s78	: std_logic_vector(15 downto 0);
signal s146	: std_logic_vector(0 downto 0);
signal s72	: std_logic_vector(0 downto 0);
signal s61	: std_logic_vector(15 downto 0);
signal s57	: std_logic_vector(15 downto 0);
signal s127	: std_logic_vector(15 downto 0);
signal s38	: std_logic_vector(15 downto 0);
signal s42	: std_logic_vector(0 downto 0);
signal s180	: std_logic;
signal s95	: std_logic_vector(15 downto 0);
signal s93	: std_logic_vector(15 downto 0);
signal s97	: std_logic_vector(15 downto 0);
signal s152	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(15 downto 0);
signal s150	: std_logic_vector(0 downto 0);
signal s148	: std_logic_vector(0 downto 0);
signal s8	: std_logic_vector(15 downto 0);

begin

	\i21h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s46,
		O0 => s83,
		clk => \clk\,
		reset => \reset\,
		we => s47(0)
	);

	\H_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s115,
		I1 => s111,
		O0 => s113
	);

	\i18\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s7,
		O0 => s8,
		clk => \clk\,
		reset => \reset\
	);

	\i22v_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s100,
		a_delayed => s102,
		clk => \clk\,
		reset => \reset\
	);

	\c119\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s177,
		a_delayed => s160,
		clk => \clk\,
		reset => \reset\
	);

	\i00h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s28,
		O0 => s76,
		clk => \clk\,
		reset => \reset\,
		we => s29(0)
	);

	\i09\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s56,
		O0 => s17,
		clk => \clk\,
		reset => \reset\
	);

	\i05\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s20,
		O0 => s21,
		clk => \clk\,
		reset => \reset\
	);

	\i00_neg_op_s_\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s51,
		O0 => s53
	);

	\c123\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s177,
		a_delayed => s168,
		clk => \clk\,
		reset => \reset\
	);

	\c121\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s177,
		a_delayed => s164,
		clk => \clk\,
		reset => \reset\
	);

	\c125\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s177,
		a_delayed => s172,
		clk => \clk\,
		reset => \reset\
	);

	\i02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s38,
		O0 => s88,
		clk => \clk\,
		reset => \reset\,
		we => s39(0)
	);

	\i_step_delay_op_25_______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s60,
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
		I0 => s56,
		I1 => s56,
		O0 => s57
	);

	\i_step_delay_op_25________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s64,
		clk => \clk\,
		reset => \reset\
	);

	\i19\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s61,
		O0 => s7,
		clk => \clk\,
		reset => \reset\
	);

	\i16\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s9,
		O0 => s10,
		clk => \clk\,
		reset => \reset\
	);

	\i00hi01hi02h_add_op_s_i20hi21hi22h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s104,
		I1 => s105,
		O0 => s106
	);

	\i10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s59,
		O0 => s80,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\c117\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s177,
		a_delayed => s156,
		clk => \clk\,
		reset => \reset\
	);

	\i07\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s18,
		O0 => s19,
		clk => \clk\,
		reset => \reset\
	);

	\c106\: delay_op
	generic map (
		bits => 16,
		delay => 31
	)
	port map (
		a => s133,
		a_delayed => s134,
		clk => \clk\,
		reset => \reset\
	);

	\i02v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s66,
		O0 => s85,
		clk => \clk\,
		reset => \reset\,
		we => s67(0)
	);

	\i22h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s92,
		clk => \clk\,
		reset => \reset\,
		we => s50(0)
	);

	\i12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s71,
		O0 => s86,
		clk => \clk\,
		reset => \reset\,
		we => s72(0)
	);

	\i00_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s51,
		O0 => s28
	);

	\i22h_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s92,
		a_delayed => s94,
		clk => \clk\,
		reset => \reset\
	);

	\i20v_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s96,
		a_delayed => s98,
		clk => \clk\,
		reset => \reset\
	);

	\i12\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s13,
		O0 => s69,
		clk => \clk\,
		reset => \reset\
	);

	\i01h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s34,
		O0 => s77,
		clk => \clk\,
		reset => \reset\,
		we => s35(0)
	);

	\O_if_gt_op_s_255\: if_gt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s126,
		I1 => s127,
		O0 => s129
	);

	\i03\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s22,
		O0 => s23,
		clk => \clk\,
		reset => \reset\
	);

	\c111\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s177,
		a_delayed => s144,
		clk => \clk\,
		reset => \reset\
	);

	\c126\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s177,
		a_delayed => s174,
		clk => \clk\,
		reset => \reset\
	);

	\i02vi12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s87,
		O0 => s101,
		clk => \clk\,
		reset => \reset\,
		we => s160(0)
	);

	\c115\: delay_op
	generic map (
		bits => 1,
		delay => 22
	)
	port map (
		a(0) => s177,
		a_delayed => s152,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25___\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s42,
		clk => \clk\,
		reset => \reset\
	);

	\i02_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s66,
		O0 => s38
	);

	\i01_add_op_s_i01_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s32,
		O0 => s34
	);

	\i_step_delay_op_25____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s47,
		clk => \clk\,
		reset => \reset\
	);

	\i00hi01h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s78,
		O0 => s89,
		clk => \clk\,
		reset => \reset\,
		we => s154(0)
	);

	\input\: block_ram_input
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s133(6 downto 0),
		clk => \clk\,
		data_out => s3
	);

	\i21\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s44,
		clk => \clk\,
		reset => \reset\
	);

	\H_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s115,
		O0 => s114
	);

	\V_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s121,
		I1 => s117,
		O0 => s119
	);

	\c109\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s177,
		a_delayed => s140,
		clk => \clk\,
		reset => \reset\
	);

	\i13\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s12,
		O0 => s13,
		clk => \clk\,
		reset => \reset\
	);

	\i10\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		O0 => s56,
		clk => \clk\,
		reset => \reset\
	);

	\Vpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s121,
		I1 => s120,
		O0 => s123,
		Sel1 => s119,
		clk => \clk\,
		reset => \reset\,
		we => s176(0)
	);

	\c128\: delay_op
	generic map (
		bits => 1,
		delay => 30
	)
	port map (
		a(0) => s177,
		a_delayed => s178,
		clk => \clk\,
		reset => \reset\
	);

	\c113\: delay_op
	generic map (
		bits => 1,
		delay => 16
	)
	port map (
		a(0) => s177,
		a_delayed => s148,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s29,
		clk => \clk\,
		reset => \reset\
	);

	\i22v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s74,
		O0 => s100,
		clk => \clk\,
		reset => \reset\,
		we => s75(0)
	);

	\i01\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s66,
		O0 => s31,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25__________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s72,
		clk => \clk\,
		reset => \reset\
	);

	\i15\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s10,
		O0 => s11,
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
		I0 => s82,
		I1 => s83,
		O0 => s84
	);

	\i00h_add_op_s_i01h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s76,
		I1 => s77,
		O0 => s78
	);

	\i02h_delay_op_1\: delay_op
	generic map (
		bits => 16,
		delay => 1
	)
	port map (
		a => s88,
		a_delayed => s90,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s50,
		clk => \clk\,
		reset => \reset\
	);

	\c122\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s177,
		a_delayed => s166,
		clk => \clk\,
		reset => \reset\
	);

	\i22\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s3,
		O0 => s74,
		clk => \clk\,
		reset => \reset\,
		we => s138(0)
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
		done => s180,
		input => s0,
		output => s133,
		reset => \reset\,
		step => s177,
		termination => s1
	);

	\c118\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s177,
		a_delayed => s158,
		clk => \clk\,
		reset => \reset\
	);

	\c107\: delay_op
	generic map (
		bits => 1,
		delay => 31
	)
	port map (
		a(0) => s177,
		a_delayed => s136,
		clk => \clk\,
		reset => \reset\
	);

	\i20h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s61,
		O0 => s82,
		clk => \clk\,
		reset => \reset\,
		we => s42(0)
	);

	\i06\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s19,
		O0 => s20,
		clk => \clk\,
		reset => \reset\
	);

	\output\: block_ram
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s134(6 downto 0),
		clk => \clk\,
		data_in => s130,
		data_out => s132,
		we => s136(0)
	);

	\i02vi12v_add_op_s_i22v_delay_op_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s101,
		I1 => s102,
		O0 => s103
	);

	\i00vi10v_add_op_s_i20v_delay_op_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s97,
		I1 => s98,
		O0 => s99
	);

	\i00vi10vi20v_add_op_s_i02vi12vi22v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s107,
		I1 => s108,
		O0 => s109
	);

	\i20hi21h_add_op_s_i22h_delay_op_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s93,
		I1 => s94,
		O0 => s95
	);

	\c120\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s177,
		a_delayed => s162,
		clk => \clk\,
		reset => \reset\
	);

	\i00vi10vi20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s99,
		O0 => s107,
		clk => \clk\,
		reset => \reset\,
		we => s166(0)
	);

	\c124\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s177,
		a_delayed => s170,
		clk => \clk\,
		reset => \reset\
	);

	\i08\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s17,
		O0 => s18,
		clk => \clk\,
		reset => \reset\,
		we => s148(0)
	);

	\i04\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s21,
		O0 => s22,
		clk => \clk\,
		reset => \reset\,
		we => s150(0)
	);

	\i20hi21h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s84,
		O0 => s93,
		clk => \clk\,
		reset => \reset\,
		we => s158(0)
	);

	\Otrunk\: mux_m_op
	generic map (
		N_ops => 2,
		N_sels => 1,
		w_in => 16
	)
	port map (
		I0(31 downto 16) => s126(15 downto 0),
		I0(15 downto 0) => s128(15 downto 0),
		O0 => s130,
		Sel(0 downto 0) => s129(0 downto 0)
	);

	\O\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s124,
		O0 => s126,
		clk => \clk\,
		reset => \reset\,
		we => s178(0)
	);

	\i17\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s8,
		O0 => s9,
		clk => \clk\,
		reset => \reset\,
		we => s142(0)
	);

	\H\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s106,
		O0 => s115,
		clk => \clk\,
		reset => \reset\,
		we => s170(0)
	);

	\i_step_delay_op_25______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s54,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s67,
		clk => \clk\,
		reset => \reset\
	);

	\i10_add_op_s_i10_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s57,
		O0 => s59
	);

	\i20_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s61,
		O0 => s63
	);

	\i_step_delay_op_25__\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s39,
		clk => \clk\,
		reset => \reset\
	);

	\i00\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s31,
		O0 => s51,
		clk => \clk\,
		reset => \reset\
	);

	\i02vi12vi22v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s103,
		O0 => s108,
		clk => \clk\,
		reset => \reset\,
		we => s168(0)
	);

	\c129\: delay_op
	generic map (
		bits => 1,
		delay => 33
	)
	port map (
		a(0) => s180,
		a_delayed => s181,
		clk => \clk\,
		reset => \reset\
	);

	\c114\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s177,
		a_delayed => s150,
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
		I0 => s31,
		I1 => s31,
		O0 => s32
	);

	\i20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s63,
		O0 => s96,
		clk => \clk\,
		reset => \reset\,
		we => s64(0)
	);

	\i14\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s11,
		O0 => s12,
		clk => \clk\,
		reset => \reset\,
		we => s144(0)
	);

	\i00vi10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s81,
		O0 => s97,
		clk => \clk\,
		reset => \reset\,
		we => s156(0)
	);

	\c110\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s177,
		a_delayed => s142,
		clk => \clk\,
		reset => \reset\
	);

	\c108\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s177,
		a_delayed => s138,
		clk => \clk\,
		reset => \reset\
	);

	\i11\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s69,
		O0 => s15,
		clk => \clk\,
		reset => \reset\,
		we => s146(0)
	);

	\i00v_add_op_s_i10v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s79,
		I1 => s80,
		O0 => s81
	);

	\i_step_delay_op_25___________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s75,
		clk => \clk\,
		reset => \reset\
	);

	\i00hi01h_add_op_s_i02h_delay_op_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s89,
		I1 => s90,
		O0 => s91
	);

	\i02v_add_op_s_i12v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s85,
		I1 => s86,
		O0 => s87
	);

	\i12_add_op_s_i12\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s69,
		I1 => s69,
		O0 => s71
	);

	\i21_add_op_s_i21\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s44,
		I1 => s44,
		O0 => s46
	);

	\i_step_delay_op_25_\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s177,
		a_delayed => s35,
		clk => \clk\,
		reset => \reset\
	);

	\c127\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s177,
		a_delayed => s176,
		clk => \clk\,
		reset => \reset\
	);

	\i02\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s23,
		O0 => s66,
		clk => \clk\,
		reset => \reset\,
		we => s152(0)
	);

	\c116\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s177,
		a_delayed => s154,
		clk => \clk\,
		reset => \reset\
	);

	\c112\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s177,
		a_delayed => s146,
		clk => \clk\,
		reset => \reset\
	);

	\i20hi21hi22h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s95,
		O0 => s105,
		clk => \clk\,
		reset => \reset\,
		we => s164(0)
	);

	\i00v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s53,
		O0 => s79,
		clk => \clk\,
		reset => \reset\,
		we => s54(0)
	);

	\Hpos_add_op_s_Vpos\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s122,
		I1 => s123,
		O0 => s124
	);

	\V_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s121,
		O0 => s120
	);

	\Hpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s115,
		I1 => s114,
		O0 => s122,
		Sel1 => s113,
		clk => \clk\,
		reset => \reset\,
		we => s174(0)
	);

	\V\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s109,
		O0 => s121,
		clk => \clk\,
		reset => \reset\,
		we => s172(0)
	);

	\i00hi01hi02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s91,
		O0 => s104,
		clk => \clk\,
		reset => \reset\,
		we => s162(0)
	);

	\i20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s44,
		O0 => s61,
		clk => \clk\,
		reset => \reset\,
		we => s140(0)
	);

	\result\ <= s132;
	s0 <= conv_std_logic_vector(0, 16);
	s127 <= conv_std_logic_vector(255, 16);
	s111 <= conv_std_logic_vector(0, 16);
	\done\ <= s181(0);
	s117 <= conv_std_logic_vector(0, 16);
	s128 <= conv_std_logic_vector(255, 16);
	s1 <= conv_std_logic_vector(78, 16);
	s179 <= \init\;

end behavior;

