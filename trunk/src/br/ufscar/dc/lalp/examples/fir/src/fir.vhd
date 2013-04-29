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
-- Generated at Wed Dec 12 13:46:22 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity fir is
	port (
		\a\	: in	std_logic_vector(31 downto 0);
		\b\	: in	std_logic_vector(31 downto 0);
		\c\	: in	std_logic_vector(31 downto 0);
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\d\	: in	std_logic_vector(31 downto 0);
		\e\	: in	std_logic_vector(31 downto 0);
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(31 downto 0)
	);
end fir;

architecture behavior of fir is

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

component mult_op_s
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

signal s0	: std_logic_vector(31 downto 0);
signal s22	: std_logic_vector(31 downto 0);
signal s26	: std_logic_vector(31 downto 0);
signal s11	: std_logic_vector(31 downto 0);
signal s15	: std_logic_vector(31 downto 0);
signal s25	: std_logic_vector(0 downto 0);
signal s19	: std_logic_vector(31 downto 0);
signal s21	: std_logic_vector(31 downto 0);
signal s23	: std_logic;
signal s9	: std_logic_vector(31 downto 0);
signal s7	: std_logic_vector(31 downto 0);
signal s5	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(31 downto 0);
signal s13	: std_logic_vector(31 downto 0);
signal s17	: std_logic_vector(31 downto 0);
signal s20	: std_logic_vector(31 downto 0);
signal s24	: std_logic_vector(31 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s10	: std_logic_vector(31 downto 0);
signal s16	: std_logic_vector(31 downto 0);
signal s12	: std_logic_vector(31 downto 0);
signal s18	: std_logic_vector(31 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(31 downto 0);
signal s2	: std_logic_vector(31 downto 0);

begin

	\init_delay_op_1\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s23,
		a_delayed => s25,
		clk => \clk\,
		reset => \reset\
	);

	\d1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s11,
		O0 => s19,
		clk => \clk\,
		reset => \reset\
	);

	\c_mult_op_s_7\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s6,
		I1 => s7,
		O0 => s8
	);

	\a1_add_op_s_b1_add_op_s_c1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s17,
		I1 => s18,
		O0 => s21
	);

	\a1_add_op_s_b1_add_op_s_c1_add_op_s_d1_add_op_s_e1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s21,
		I1 => s22,
		O0 => s24
	);

	\sum\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s24,
		O0 => s26,
		clk => \clk\,
		reset => \reset\,
		we => s25(0)
	);

	\a1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s2,
		O0 => s15,
		clk => \clk\,
		reset => \reset\
	);

	\a_mult_op_s_3\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s0,
		I1 => s1,
		O0 => s2
	);

	\e_mult_op_s_11\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s12,
		I1 => s13,
		O0 => s14
	);

	\d1_add_op_s_e1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s19,
		I1 => s20,
		O0 => s22
	);

	\b_mult_op_s_5\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s3,
		I1 => s4,
		O0 => s5
	);

	\c1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s8,
		O0 => s18,
		clk => \clk\,
		reset => \reset\
	);

	\d_mult_op_s_9\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s9,
		I1 => s10,
		O0 => s11
	);

	\e1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s14,
		O0 => s20,
		clk => \clk\,
		reset => \reset\
	);

	\a1_add_op_s_b1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s15,
		I1 => s16,
		O0 => s17
	);

	\b1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s5,
		O0 => s16,
		clk => \clk\,
		reset => \reset\
	);

	\result\ <= s26;
	s1 <= conv_std_logic_vector(3, 32);
	s13 <= conv_std_logic_vector(11, 32);
	s10 <= conv_std_logic_vector(9, 32);
	s4 <= conv_std_logic_vector(5, 32);
	s23 <= \init\;
	s12 <= \e\;
	s3 <= \b\;
	s7 <= conv_std_logic_vector(7, 32);
	s6 <= \c\;
	s9 <= \d\;
	s0 <= \a\;

end behavior;

