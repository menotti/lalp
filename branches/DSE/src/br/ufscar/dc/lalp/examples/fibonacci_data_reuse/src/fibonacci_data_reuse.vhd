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
-- Generated at Tue Dec 11 14:58:52 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity fibonacci_data_reuse is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end fibonacci_data_reuse;

architecture behavior of fibonacci_data_reuse is

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

signal s0	: std_logic_vector(5 downto 0);
signal s10	: std_logic;
signal s11	: std_logic_vector(0 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s7	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(5 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(5 downto 0);
signal s2	: std_logic;

begin

	\c13\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s10,
		a_delayed => s11,
		clk => \clk\,
		reset => \reset\
	);

	\v\: block_ram
	generic map (
		address_width => 3,
		data_width => 32
	)
	port map (
		address(2 downto 0) => s4(2 downto 0),
		clk => \clk\,
		data_in => s7,
		data_out => s9,
		we => s3(0)
	);

	\b\: add_reg_op_s
	generic map (
		initial => 1,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s8,
		I1 => s7,
		O0 => s8,
		clk => \clk\,
		reset => \reset\
	);

	\i\: counter
	generic map (
		bits => 6,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		clk => \clk\,
		clk_en => s2,
		done => s10,
		input => s0,
		output => s4,
		reset => \reset\,
		termination => s1
	);

	\a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s8,
		O0 => s7,
		clk => \clk\,
		reset => \reset\
	);

	\done\ <= s11(0);
	s0 <= conv_std_logic_vector(0, 6);
	s3 <= conv_std_logic_vector(1, 32);
	s1 <= conv_std_logic_vector(32, 6);
	\output\ <= s9;
	s2 <= \init\;

end behavior;

