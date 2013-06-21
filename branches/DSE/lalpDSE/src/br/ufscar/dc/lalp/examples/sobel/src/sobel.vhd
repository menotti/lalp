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
-- Generated at Fri Jun 21 16:26:31 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity sobel is
	port (
		\done\	: out	std_logic;
		\init\	: in	std_logic;
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

signal s0	: std_logic;
signal s22	: std_logic_vector(15 downto 0);
signal s26	: std_logic_vector(0 downto 0);
signal s48	: std_logic_vector(0 downto 0);
signal s15	: std_logic_vector(15 downto 0);
signal s40	: std_logic_vector(0 downto 0);
signal s45	: std_logic;
signal s44	: std_logic_vector(0 downto 0);
signal s30	: std_logic_vector(0 downto 0);
signal s34	: std_logic_vector(0 downto 0);
signal s21	: std_logic_vector(15 downto 0);
signal s7	: std_logic_vector(15 downto 0);
signal s5	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s17	: std_logic_vector(15 downto 0);
signal s20	: std_logic_vector(15 downto 0);
signal s24	: std_logic_vector(0 downto 0);
signal s28	: std_logic_vector(0 downto 0);
signal s38	: std_logic_vector(0 downto 0);
signal s32	: std_logic_vector(0 downto 0);
signal s42	: std_logic_vector(0 downto 0);
signal s46	: std_logic_vector(0 downto 0);
signal s36	: std_logic_vector(0 downto 0);
signal s16	: std_logic_vector(15 downto 0);
signal s47	: std_logic;
signal s18	: std_logic_vector(15 downto 0);
signal s6	: std_logic_vector(15 downto 0);
signal s2	: std_logic_vector(15 downto 0);

begin

	\c26\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s26
	);

	\output\: block_ram
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s22(6 downto 0),
		data_in => s18,
		data_out => s20,
		we => s24(0)
	);

	\i12\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s34(0)
	);

	\c37\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s47,
		a_delayed => s48
	);

	\c30\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s34
	);

	\c34\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s42
	);

	\c29\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s32
	);

	\c33\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s40
	);

	\c27\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s28
	);

	\c25\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s45,
		a_delayed => s24
	);

	\i_add_op_s_1\: add_op_s
	generic map (
		w_in1 => 16,
		w_in2 => 16,
		w_out => 16
	)
	port map (
		I0 => s21,
		I1 => s5,
		O0 => s6
	);

	\i01\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s28(0)
	);

	\O\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		O0 => s16,
		we => s46(0)
	);

	\i20\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s36(0)
	);

	\i22\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s40(0)
	);

	\H\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		we => s42(0)
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
		clk_en => s0,
		done => s47,
		input => s1,
		output => s21,
		step => s45,
		termination => s2
	);

	\c24\: delay_op
	generic map (
		bits => 16,
		delay => 3
	)
	port map (
		a => s21,
		a_delayed => s22
	);

	\c31\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s36
	);

	\c28\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s30
	);

	\c35\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s44
	);

	\c32\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s38
	);

	\input\: block_ram_input
	generic map (
		address_width => 7,
		data_width => 16
	)
	port map (
		address(6 downto 0) => s7(6 downto 0),
		data_out => s15
	);

	\c36\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s45,
		a_delayed => s46
	);

	\addr\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 16
	)
	port map (
		I0(127 downto 112) => s21(15 downto 0),
		I0(111 downto 96) => s6(15 downto 0),
		O0 => s7
	);

	\i10\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s32(0)
	);

	\i00\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s26(0)
	);

	\Otrunk\: mux_m_op
	generic map (
		N_ops => 2,
		N_sels => 1,
		w_in => 16
	)
	port map (
		I0(31 downto 16) => s16(15 downto 0),
		I0(15 downto 0) => s17(15 downto 0),
		O0 => s18
	);

	\i02\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s30(0)
	);

	\V\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		we => s44(0)
	);

	\i21\: reg_op
	generic map (
		initial => 0,
		w_in => 16
	)
	port map (
		I0 => s15,
		we => s38(0)
	);

	\result\ <= s20;
	s5 <= conv_std_logic_vector(1, 16);
	s2 <= conv_std_logic_vector(78, 16);
	s17 <= conv_std_logic_vector(255, 16);
	\done\ <= s48(0);
	s1 <= conv_std_logic_vector(0, 16);
	s0 <= \init\;

end behavior;

