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
-- Generated at Fri Jun 21 16:47:12 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity dotprod6 is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0)
	);
end dotprod6;

architecture behavior of dotprod6 is

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

signal s50	: std_logic_vector(15 downto 0);
signal s59	: std_logic_vector(31 downto 0);
signal s194	: std_logic_vector(0 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s192	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s193	: std_logic;
signal s190	: std_logic;
signal s55	: std_logic_vector(31 downto 0);
signal s191	: std_logic;
signal s51	: std_logic_vector(15 downto 0);
signal s53	: std_logic_vector(15 downto 0);

begin

	\x_mult_op_s_p_y_1\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s54,
		I1 => s55,
		O0 => s57,
		clk => \clk\
	);

	\c141\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s193,
		a_delayed => s194,
		clk => \clk\,
		reset => \reset\
	);

	\acc\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s59,
		I1 => s57,
		O0 => s59,
		clk => \clk\,
		reset => \reset\,
		we => s194(0)
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
		clk_en => s190,
		done => s191,
		input => s50,
		output => s53,
		reset => \reset\,
		step => s193,
		termination => s51
	);

	\c140\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s191,
		a_delayed => s192,
		clk => \clk\,
		reset => \reset\
	);

	\x\: block_ram_x
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s53(10 downto 0),
		clk => \clk\,
		data_out => s54
	);

	\y\: block_ram_y
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s53(10 downto 0),
		clk => \clk\,
		data_out => s55
	);

	s50 <= conv_std_logic_vector(0, 16);
	s51 <= conv_std_logic_vector(2048, 16);
	\done\ <= s192(0);
	\sum\ <= s59;
	s190 <= \init\;

end behavior;

