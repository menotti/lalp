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
-- Generated at Thu Apr 28 23:40:12 BRT 2011
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
signal s119	: std_logic_vector(15 downto 0);
signal s104	: std_logic_vector(15 downto 0);
signal s34	: std_logic_vector(15 downto 0);
signal s123	: std_logic_vector(15 downto 0);
signal s125	: std_logic_vector(0 downto 0);
signal s9	: std_logic_vector(15 downto 0);
signal s68	: std_logic_vector(0 downto 0);
signal s13	: std_logic_vector(15 downto 0);
signal s17	: std_logic_vector(15 downto 0);
signal s172	: std_logic_vector(0 downto 0);
signal s87	: std_logic_vector(15 downto 0);
signal s28	: std_logic_vector(15 downto 0);
signal s102	: std_logic_vector(15 downto 0);
signal s117	: std_logic_vector(15 downto 0);
signal s32	: std_logic_vector(15 downto 0);
signal s176	: std_logic;
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
signal s170	: std_logic_vector(0 downto 0);
signal s111	: std_logic_vector(15 downto 0);
signal s126	: std_logic_vector(15 downto 0);
signal s115	: std_logic_vector(0 downto 0);
signal s60	: std_logic_vector(15 downto 0);
signal s56	: std_logic_vector(15 downto 0);
signal s62	: std_logic_vector(15 downto 0);
signal s7	: std_logic_vector(15 downto 0);
signal s3	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s90	: std_logic_vector(15 downto 0);
signal s92	: std_logic_vector(15 downto 0);
signal s168	: std_logic_vector(0 downto 0);
signal s109	: std_logic_vector(0 downto 0);
signal s98	: std_logic_vector(15 downto 0);
signal s20	: std_logic_vector(15 downto 0);
signal s94	: std_logic_vector(15 downto 0);
signal s128	: std_logic_vector(15 downto 0);
signal s113	: std_logic_vector(15 downto 0);
signal s54	: std_logic_vector(0 downto 0);
signal s39	: std_logic_vector(0 downto 0);
signal s132	: std_logic_vector(0 downto 0);
signal s130	: std_logic_vector(15 downto 0);
signal s134	: std_logic_vector(0 downto 0);
signal s18	: std_logic_vector(15 downto 0);
signal s164	: std_logic_vector(0 downto 0);
signal s162	: std_logic_vector(0 downto 0);
signal s77	: std_logic_vector(15 downto 0);
signal s75	: std_logic_vector(0 downto 0);
signal s166	: std_logic_vector(0 downto 0);
signal s79	: std_logic_vector(15 downto 0);
signal s63	: std_logic_vector(0 downto 0);
signal s122	: std_logic_vector(15 downto 0);
signal s118	: std_logic_vector(15 downto 0);
signal s177	: std_logic_vector(0 downto 0);
signal s107	: std_logic_vector(15 downto 0);
signal s29	: std_logic_vector(0 downto 0);
signal s103	: std_logic_vector(15 downto 0);
signal s173	: std_logic;
signal s86	: std_logic_vector(15 downto 0);
signal s84	: std_logic_vector(15 downto 0);
signal s175	: std_logic;
signal s88	: std_logic_vector(15 downto 0);
signal s82	: std_logic_vector(15 downto 0);
signal s120	: std_logic_vector(15 downto 0);
signal s50	: std_logic_vector(0 downto 0);
signal s124	: std_logic_vector(15 downto 0);
signal s31	: std_logic_vector(15 downto 0);
signal s35	: std_logic_vector(0 downto 0);
signal s105	: std_logic_vector(15 downto 0);
signal s46	: std_logic_vector(15 downto 0);
signal s10	: std_logic_vector(15 downto 0);
signal s12	: std_logic_vector(15 downto 0);
signal s158	: std_logic_vector(0 downto 0);
signal s160	: std_logic_vector(0 downto 0);
signal s101	: std_logic_vector(15 downto 0);
signal s99	: std_logic_vector(15 downto 0);
signal s65	: std_logic_vector(15 downto 0);
signal s71	: std_logic_vector(15 downto 0);
signal s67	: std_logic_vector(15 downto 0);
signal s156	: std_logic_vector(0 downto 0);
signal s154	: std_logic_vector(0 downto 0);
signal s69	: std_logic_vector(15 downto 0);
signal s144	: std_logic_vector(0 downto 0);
signal s59	: std_logic_vector(15 downto 0);
signal s44	: std_logic_vector(15 downto 0);
signal s129	: std_logic_vector(15 downto 0);
signal s19	: std_logic_vector(15 downto 0);
signal s21	: std_logic_vector(15 downto 0);
signal s110	: std_logic_vector(15 downto 0);
signal s23	: std_logic_vector(15 downto 0);
signal s76	: std_logic_vector(15 downto 0);
signal s74	: std_logic_vector(15 downto 0);
signal s80	: std_logic_vector(15 downto 0);
signal s78	: std_logic_vector(15 downto 0);
signal s146	: std_logic_vector(0 downto 0);
signal s72	: std_logic_vector(0 downto 0);
signal s57	: std_logic_vector(0 downto 0);
signal s38	: std_logic_vector(15 downto 0);
signal s116	: std_logic_vector(15 downto 0);
signal s42	: std_logic_vector(0 downto 0);
signal s95	: std_logic_vector(15 downto 0);
signal s93	: std_logic_vector(15 downto 0);
signal s97	: std_logic_vector(15 downto 0);
signal s152	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(15 downto 0);
signal s150	: std_logic_vector(0 downto 0);
signal s148	: std_logic_vector(0 downto 0);
signal s8	: std_logic_vector(15 downto 0);

begin

	\V\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s105,
		O0 => s117,
		clk => \clk\,
		reset => \reset\,
		we => s168(0)
	);

	\H_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s111,
		O0 => s110
	);

	\H\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s102,
		O0 => s111,
		clk => \clk\,
		reset => \reset\,
		we => s166(0)
	);

	\i02vi12v_add_op_s_i22v\: add_op_s
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

	\c119\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s173,
		a_delayed => s164,
		clk => \clk\,
		reset => \reset\
	);

	\c104\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s173,
		a_delayed => s134,
		clk => \clk\,
		reset => \reset\
	);

	\i20hi21hi22h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s93,
		O0 => s101,
		clk => \clk\,
		reset => \reset\,
		we => s160(0)
	);

	\output\: block_ram
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s130(6 downto 0),
		clk => \clk\,
		data_in => s126,
		data_out => s128,
		we => s132(0)
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
		reset => \reset\
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

	\c123\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s173,
		a_delayed => s172,
		clk => \clk\,
		reset => \reset\
	);

	\c121\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s173,
		a_delayed => s168,
		clk => \clk\,
		reset => \reset\
	);

	\c125\: delay_op
	generic map (
		bits => 1,
		delay => 33
	)
	port map (
		a(0) => s176,
		a_delayed => s177,
		clk => \clk\,
		reset => \reset\
	);

	\i00hi01hi02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s90,
		O0 => s100,
		clk => \clk\,
		reset => \reset\,
		we => s158(0)
	);

	\i_step_delay_op_25______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s54,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s50,
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
		I0 => s59,
		I1 => s59,
		O0 => s60
	);

	\O\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s120,
		O0 => s122,
		clk => \clk\,
		reset => \reset\,
		we => s174(0)
	);

	\Otrunk\: mux_m_op
	generic map (
		N_ops => 2,
		N_sels => 1,
		w_in => 16
	)
	port map (
		I0(31 downto 16) => s122(15 downto 0),
		I0(15 downto 0) => s124(15 downto 0),
		O0 => s126,
		Sel(0 downto 0) => s125(0 downto 0)
	);

	\i00vi10vi20v_add_op_s_i02vi12vi22v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s103,
		I1 => s104,
		O0 => s105
	);

	\i20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s71,
		O0 => s95,
		clk => \clk\,
		reset => \reset\,
		we => s72(0)
	);

	\c102\: delay_op
	generic map (
		bits => 16,
		delay => 31
	)
	port map (
		a => s129,
		a_delayed => s130,
		clk => \clk\,
		reset => \reset\
	);

	\c117\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s173,
		a_delayed => s160,
		clk => \clk\,
		reset => \reset\
	);

	\i20h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s69,
		O0 => s82,
		clk => \clk\,
		reset => \reset\,
		we => s42(0)
	);

	\c106\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s173,
		a_delayed => s138,
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
		clk_en => s175,
		done => s176,
		input => s0,
		output => s129,
		reset => \reset\,
		step => s173,
		termination => s1
	);

	\i20hi21h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s84,
		O0 => s91,
		clk => \clk\,
		reset => \reset\,
		we => s154(0)
	);

	\i02vi12vi22v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s99,
		O0 => s104,
		clk => \clk\,
		reset => \reset\,
		we => s164(0)
	);

	\i00vi10vi20v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s96,
		O0 => s103,
		clk => \clk\,
		reset => \reset\,
		we => s162(0)
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

	\i20hi21h_add_op_s_i22h\: add_op_s
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

	\i14\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s11,
		O0 => s12,
		clk => \clk\,
		reset => \reset\
	);

	\i11\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s65,
		O0 => s15,
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

	\c111\: delay_op
	generic map (
		bits => 1,
		delay => 23
	)
	port map (
		a(0) => s173,
		a_delayed => s148,
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
		O0 => s56,
		clk => \clk\,
		reset => \reset\
	);

	\c115\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s173,
		a_delayed => s156,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s35,
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

	\i00_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s51,
		O0 => s28
	);

	\i_step_delay_op_25__\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s39,
		clk => \clk\,
		reset => \reset\
	);

	\i20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s44,
		O0 => s69,
		clk => \clk\,
		reset => \reset\
	);

	\Hpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s111,
		I1 => s110,
		O0 => s118,
		Sel1 => s109,
		clk => \clk\,
		reset => \reset\,
		we => s170(0)
	);

	\V_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s117,
		O0 => s116
	);

	\c109\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s173,
		a_delayed => s144,
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

	\i00vi10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s81,
		O0 => s94,
		clk => \clk\,
		reset => \reset\,
		we => s152(0)
	);

	\Hpos_add_op_s_Vpos\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s118,
		I1 => s119,
		O0 => s120
	);

	\c113\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s173,
		a_delayed => s152,
		clk => \clk\,
		reset => \reset\
	);

	\i02v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s56,
		O0 => s85,
		clk => \clk\,
		reset => \reset\,
		we => s57(0)
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

	\i12_add_op_s_i12\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s65,
		I1 => s65,
		O0 => s67
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

	\i_step_delay_op_25___________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s75,
		clk => \clk\,
		reset => \reset\
	);

	\i20_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s69,
		O0 => s71
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

	\i_step_delay_op_25___\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s42,
		clk => \clk\,
		reset => \reset\
	);

	\c122\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s173,
		a_delayed => s170,
		clk => \clk\,
		reset => \reset\
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

	\c118\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s173,
		a_delayed => s162,
		clk => \clk\,
		reset => \reset\
	);

	\c107\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s173,
		a_delayed => s140,
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

	\c103\: delay_op
	generic map (
		bits => 1,
		delay => 31
	)
	port map (
		a(0) => s173,
		a_delayed => s132,
		clk => \clk\,
		reset => \reset\
	);

	\i09\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s59,
		O0 => s17,
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
		O0 => s59,
		clk => \clk\,
		reset => \reset\,
		we => s142(0)
	);

	\i00hi01hi02h_add_op_s_i20hi21hi22h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s100,
		I1 => s101,
		O0 => s102
	);

	\i00vi10v_add_op_s_i20v\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s94,
		I1 => s95,
		O0 => s96
	);

	\H_if_lt_op_s_0\: if_lt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s111,
		I1 => s107,
		O0 => s109
	);

	\i00hi01h_add_op_s_i02h\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s88,
		I1 => s89,
		O0 => s90
	);

	\c120\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s173,
		a_delayed => s166,
		clk => \clk\,
		reset => \reset\
	);

	\i12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s67,
		O0 => s86,
		clk => \clk\,
		reset => \reset\,
		we => s68(0)
	);

	\c124\: delay_op
	generic map (
		bits => 1,
		delay => 30
	)
	port map (
		a(0) => s173,
		a_delayed => s174,
		clk => \clk\,
		reset => \reset\
	);

	\i10v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s62,
		O0 => s80,
		clk => \clk\,
		reset => \reset\,
		we => s63(0)
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

	\c105\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s173,
		a_delayed => s136,
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
		O0 => s98,
		clk => \clk\,
		reset => \reset\,
		we => s75(0)
	);

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

	\i00hi01h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s78,
		O0 => s88,
		clk => \clk\,
		reset => \reset\,
		we => s150(0)
	);

	\i19\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s69,
		O0 => s7,
		clk => \clk\,
		reset => \reset\,
		we => s136(0)
	);

	\i02h\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s38,
		O0 => s89,
		clk => \clk\,
		reset => \reset\,
		we => s39(0)
	);

	\i_step_delay_op_25____\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s47,
		clk => \clk\,
		reset => \reset\
	);

	\i10_add_op_s_i10_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s60,
		O0 => s62
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

	\i_step_delay_op_25_______\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s57,
		clk => \clk\,
		reset => \reset\
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

	\i02vi12v\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s87,
		O0 => s97,
		clk => \clk\,
		reset => \reset\,
		we => s156(0)
	);

	\c114\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s173,
		a_delayed => s154,
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
		reset => \reset\
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
		reset => \reset\
	);

	\i12\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s13,
		O0 => s65,
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
		reset => \reset\,
		we => s138(0)
	);

	\c110\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s173,
		a_delayed => s146,
		clk => \clk\,
		reset => \reset\
	);

	\c108\: delay_op
	generic map (
		bits => 1,
		delay => 14
	)
	port map (
		a(0) => s173,
		a_delayed => s142,
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
		reset => \reset\,
		we => s140(0)
	);

	\i_step_delay_op_25__________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s72,
		clk => \clk\,
		reset => \reset\
	);

	\i_step_delay_op_25_________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s68,
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

	\i_step_delay_op_25________\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s63,
		clk => \clk\,
		reset => \reset\
	);

	\i02_neg_op_s\: neg_op_s
	generic map (
		w_in => 16,
		w_out => 16
	)
	port map (
		I0 => s56,
		O0 => s38
	);

	\i_step_delay_op_25\: delay_op
	generic map (
		bits => 1,
		delay => 25
	)
	port map (
		a(0) => s173,
		a_delayed => s29,
		clk => \clk\,
		reset => \reset\
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
		we => s146(0)
	);

	\c116\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s173,
		a_delayed => s158,
		clk => \clk\,
		reset => \reset\
	);

	\c112\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s173,
		a_delayed => s150,
		clk => \clk\,
		reset => \reset\
	);

	\i01\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s56,
		O0 => s31,
		clk => \clk\,
		reset => \reset\,
		we => s148(0)
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
		reset => \reset\,
		we => s144(0)
	);

	\O_if_gt_op_s_255\: if_gt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s122,
		I1 => s123,
		O0 => s125
	);

	\Vpos\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s117,
		I1 => s116,
		O0 => s119,
		Sel1 => s115,
		clk => \clk\,
		reset => \reset\,
		we => s172(0)
	);

	\V_if_lt_op_s_0\: if_lt_op_s
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

	\input\: block_ram_input
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s129(6 downto 0),
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
		reset => \reset\,
		we => s134(0)
	);

	s123 <= conv_std_logic_vector(255, 16);
	s0 <= conv_std_logic_vector(0, 16);
	s175 <= \init\;
	\result\ <= s128;
	s107 <= conv_std_logic_vector(0, 16);
	s124 <= conv_std_logic_vector(255, 16);
	s113 <= conv_std_logic_vector(0, 16);
	s1 <= conv_std_logic_vector(78, 16);
	\done\ <= s177(0);

end behavior;

