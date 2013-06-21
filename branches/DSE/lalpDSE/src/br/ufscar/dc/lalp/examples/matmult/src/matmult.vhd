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
-- Generated at Fri Jun 21 16:26:05 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity matmult is
	port (
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\result\	: out	std_logic_vector(15 downto 0)
	);
end matmult;

architecture behavior of matmult is

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

component block_ram_a
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

component block_ram_b
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
signal s26	: std_logic_vector(15 downto 0);
signal s15	: std_logic_vector(15 downto 0);
signal s40	: std_logic_vector(15 downto 0);
signal s37	: std_logic_vector(0 downto 0);
signal s41	: std_logic_vector(15 downto 0);
signal s30	: std_logic_vector(15 downto 0);
signal s34	: std_logic_vector(15 downto 0);
signal s29	: std_logic;
signal s33	: std_logic_vector(15 downto 0);
signal s27	: std_logic_vector(15 downto 0);
signal s25	: std_logic;
signal s19	: std_logic_vector(15 downto 0);
signal s21	: std_logic_vector(15 downto 0);
signal s23	: std_logic_vector(15 downto 0);
signal s7	: std_logic_vector(15 downto 0);
signal s3	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s13	: std_logic_vector(15 downto 0);
signal s17	: std_logic_vector(15 downto 0);
signal s20	: std_logic_vector(15 downto 0);
signal s24	: std_logic;
signal s31	: std_logic_vector(15 downto 0);
signal s28	: std_logic_vector(15 downto 0);
signal s35	: std_logic_vector(15 downto 0);
signal s38	: std_logic;
signal s39	: std_logic_vector(0 downto 0);
signal s36	: std_logic;
signal s10	: std_logic_vector(15 downto 0);
signal s16	: std_logic_vector(0 downto 0);
signal s18	: std_logic_vector(15 downto 0);
signal s4	: std_logic_vector(15 downto 0);

begin

	\i\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		clk_en => s24,
		done => s38,
		input => s26,
		load => s25,
		output => s30,
		step => s36,
		termination => s23
	);

	\a\: block_ram_a
	generic map (
		address_width => 5,
		data_width => 16
	)
	port map (
		address(4 downto 0) => s33(4 downto 0)
	);

	\c33\: delay_op
	generic map (
		bits => 16,
		delay => 2
	)
	port map (
		a => s40,
		a_delayed => s41
	);

	\reg\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s18,
		I1 => s17,
		O0 => s10,
		Sel1 => s16
	);

	\m_add_op_s_5\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s26,
		I1 => s27,
		O0 => s28
	);

	\j\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 5,
		steps => 1
	)
	port map (
		clk_en => s24,
		input => s19,
		load => s25,
		output => s31,
		termination => s7
	);

	\addra\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s30,
		O0 => s33
	);

	\addrb\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s31,
		O0 => s34
	);

	\m_plus_5\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s28,
		O0 => s23,
		we => s29
	);

	\sum\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		we => s37(0)
	);

	\l_if_gt_op_s_3\: if_gt_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 1
	)
	port map (
		I0 => s19,
		I1 => s13,
		O0 => s16
	);

	\l_add_op_s_20\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s19,
		I1 => s20,
		O0 => s21
	);

	\c31\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s36,
		a_delayed => s37
	);

	\c32\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s38,
		a_delayed => s39
	);

	\b\: block_ram_b
	generic map (
		address_width => 5,
		data_width => 16
	)
	port map (
		address(4 downto 0) => s34(4 downto 0)
	);

	\l_plus_20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s21,
		O0 => s7
	);

	\s\: block_ram
	generic map (
		address_width => 5,
		data_width => 16
	)
	port map (
		data_out => s35
	);

	\addrs\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s41
	);

	\l_add_op_s_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s19,
		I1 => s15,
		O0 => s18
	);

	\k\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 6
	)
	port map (
		clk_en => s24,
		input => s3,
		output => s40,
		step => s25,
		termination => s4
	);

	\l\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s10,
		O0 => s19,
		we => s25
	);

	\m\: counter
	generic map (
		bits => 16,
		condition => 0,
		down => 0,
		increment => 5,
		steps => 30
	)
	port map (
		clk_en => s24,
		input => s0,
		output => s26,
		step => s29,
		termination => s1
	);

	\result\ <= s35;
	s0 <= conv_std_logic_vector(0, 16);
	s13 <= conv_std_logic_vector(3, 16);
	s27 <= conv_std_logic_vector(5, 16);
	s20 <= conv_std_logic_vector(20, 16);
	s15 <= conv_std_logic_vector(1, 16);
	s4 <= conv_std_logic_vector(25, 16);
	s1 <= conv_std_logic_vector(25, 16);
	\done\ <= s39(0);
	s3 <= conv_std_logic_vector(0, 16);
	s17 <= conv_std_logic_vector(0, 16);
	s24 <= \init\;

end behavior;

