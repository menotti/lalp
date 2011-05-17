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
-- Generated at Wed May 11 10:00:30 BRT 2011
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity dotprod_alp is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0)
	);
end dotprod_alp;

architecture behavior of dotprod_alp is

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

signal s0	: std_logic_vector(15 downto 0);
signal s13	: std_logic;
signal s11	: std_logic_vector(31 downto 0);
signal s15	: std_logic;
signal s14	: std_logic_vector(0 downto 0);
signal s16	: std_logic_vector(0 downto 0);
signal s12	: std_logic;
signal s7	: std_logic_vector(31 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s5	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(15 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(31 downto 0);

begin

	\y_delay_op_1\: delay_op
	generic map (
		bits => 32,
		delay => 1
	)
	port map (
		a => s5,
		a_delayed => s7,
		clk => \clk\,
		reset => \reset\
	);

	\c15\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s13,
		a_delayed => s14,
		clk => \clk\,
		reset => \reset\
	);

	\c16\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s15,
		a_delayed => s16,
		clk => \clk\,
		reset => \reset\
	);

	\x_delay_op_1\: delay_op
	generic map (
		bits => 32,
		delay => 1
	)
	port map (
		a => s4,
		a_delayed => s6,
		clk => \clk\,
		reset => \reset\
	);

	\x_delay_op_1_mult_op_s_p_y_delay_op_1_5\: mult_op_s_p
	generic map (
		k => 5,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s6,
		I1 => s7,
		O0 => s9,
		clk => \clk\
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
		clk_en => s12,
		done => s13,
		input => s0,
		output => s3,
		reset => \reset\,
		step => s15,
		termination => s1
	);

	\y\: block_ram_y
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address(3 downto 0) => s3(3 downto 0),
		clk => \clk\,
		data_out => s5
	);

	\x\: block_ram_x
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address(3 downto 0) => s3(3 downto 0),
		clk => \clk\,
		data_out => s4
	);

	\acc\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s11,
		I1 => s9,
		O0 => s11,
		clk => \clk\,
		reset => \reset\,
		we => s16(0)
	);

	s0 <= conv_std_logic_vector(0, 16);
	s1 <= conv_std_logic_vector(2048, 16);
	s12 <= \init\;
	\done\ <= s14(0);
	\sum\ <= s11;

end behavior;

