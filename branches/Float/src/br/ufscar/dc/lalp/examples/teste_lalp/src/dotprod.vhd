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
-- Generated at Wed Apr 17 15:02:16 WEST 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity dotprod is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0)
	);
end dotprod;

architecture behavior of dotprod is

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

component div_op_fl
generic (
	w_in1	: integer := 32;
	w_in2	: integer := 32;
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

signal s0	: std_logic_vector(15 downto 0);
signal s10	: std_logic;
signal s11	: std_logic_vector(0 downto 0);
signal s9	: std_logic;
signal s7	: std_logic;
signal s5	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(31 downto 0);

begin

	\c13\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s10,
		a_delayed => s11,
		clk => \clk\,
		reset => \reset\
	);

	\x_div_op_fl_y\: div_op_fl
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s4,
		I1 => s5,
		O0 => s6
	);

	\acc\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s6,
		O0 => s8,
		clk => \clk\,
		reset => \reset\,
		we => s7
	);

	\x\: block_ram_x
	generic map (
		address_width => 3,
		data_width => 32
	)
	port map (
		address(2 downto 0) => s3(2 downto 0),
		clk => \clk\,
		data_out => s4
	);

	\y\: block_ram_y
	generic map (
		address_width => 3,
		data_width => 32
	)
	port map (
		address(2 downto 0) => s3(2 downto 0),
		clk => \clk\,
		data_out => s5
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
		clk_en => s9,
		done => s10,
		input => s0,
		output => s3,
		reset => \reset\,
		step => s7,
		termination => s1
	);

	\done\ <= s11(0);
	s1 <= conv_std_logic_vector(5, 16);
	s0 <= conv_std_logic_vector(0, 16);
	\sum\ <= s8;
	s9 <= \init\;

end behavior;

