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
-- Generated at Tue Dec 11 15:01:25 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity max is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\maxval\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end max;

architecture behavior of max is

component block_ram_v
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

signal s0	: std_logic_vector(11 downto 0);
signal s13	: std_logic_vector(0 downto 0);
signal s11	: std_logic;
signal s10	: std_logic_vector(0 downto 0);
signal s12	: std_logic;
signal s7	: std_logic_vector(0 downto 0);
signal s9	: std_logic;
signal s3	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(11 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s2	: std_logic_vector(11 downto 0);

begin

	\c14\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s12,
		a_delayed => s13,
		clk => \clk\,
		reset => \reset\
	);

	\c13\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s9,
		a_delayed => s10,
		clk => \clk\,
		reset => \reset\
	);

	\a_if_gt_op_s_b\: if_gt_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s6,
		I1 => s8,
		O0 => s7
	);

	\v\: block_ram_v
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s2(10 downto 0),
		clk => \clk\,
		data_out => s3
	);

	\b\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s6,
		O0 => s8,
		clk => \clk\,
		reset => \reset\,
		we => s7(0)
	);

	\i\: counter
	generic map (
		bits => 12,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		clk => \clk\,
		clk_en => s11,
		done => s12,
		input => s0,
		output => s2,
		reset => \reset\,
		step => s9,
		termination => s1
	);

	\a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s3,
		O0 => s6,
		clk => \clk\,
		reset => \reset\,
		we => s10(0)
	);

	\done\ <= s13(0);
	s1 <= conv_std_logic_vector(2048, 12);
	s0 <= conv_std_logic_vector(0, 12);
	\maxval\ <= s8;
	s11 <= \init\;

end behavior;

