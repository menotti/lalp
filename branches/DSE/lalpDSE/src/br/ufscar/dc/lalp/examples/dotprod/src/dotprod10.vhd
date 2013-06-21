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
-- Generated at Fri Jun 21 16:47:13 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity dotprod10 is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0)
	);
end dotprod10;

architecture behavior of dotprod10 is

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

component block_ram_x
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

component block_ram_y
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

component mult_op_s_p
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32;
	k: integer := 5 -- number of pipeline stages
);
port (
	clk	: in	std_logic;
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

signal s94	: std_logic_vector(31 downto 0);
signal s265	: std_logic;
signal s266	: std_logic_vector(0 downto 0);
signal s263	: std_logic;
signal s262	: std_logic;
signal s264	: std_logic_vector(0 downto 0);
signal s95	: std_logic_vector(31 downto 0);
signal s93	: std_logic_vector(15 downto 0);
signal s97	: std_logic_vector(31 downto 0);
signal s99	: std_logic_vector(31 downto 0);
signal s91	: std_logic_vector(15 downto 0);
signal s90	: std_logic_vector(15 downto 0);

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
		clk => \clk\,
		clk_en => s262,
		done => s263,
		input => s90,
		output => s93,
		reset => \reset\,
		step => s265,
		termination => s91
	);

	\acc\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s99,
		I1 => s97,
		O0 => s99,
		clk => \clk\,
		reset => \reset\,
		we => s266(0)
	);

	\c149\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s265,
		a_delayed => s266,
		clk => \clk\,
		reset => \reset\
	);

	\c148\: delay_op
	generic map (
		bits => 1,
		delay => 13
	)
	port map (
		a(0) => s263,
		a_delayed => s264,
		clk => \clk\,
		reset => \reset\
	);

	\x\: block_ram_x
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s93(10 downto 0),
		clk => \clk\,
		data_out => s94
	);

	\x_mult_op_s_p_y_1\: mult_op_s_p
	generic map (
		k => 10,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s94,
		I1 => s95,
		O0 => s97,
		clk => \clk\
	);

	\y\: block_ram_y
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s93(10 downto 0),
		clk => \clk\,
		data_out => s95
	);

	\sum\ <= s99;
	\done\ <= s264(0);
	s90 <= conv_std_logic_vector(0, 16);
	s262 <= \init\;
	s91 <= conv_std_logic_vector(2048, 16);

end behavior;

