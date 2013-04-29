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
-- Generated at Wed Dec 12 13:55:14 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity vecsum is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(31 downto 0)
	);
end vecsum;

architecture behavior of vecsum is

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

signal s0	: std_logic_vector(15 downto 0);
signal s13	: std_logic_vector(0 downto 0);
signal s11	: std_logic_vector(15 downto 0);
signal s15	: std_logic_vector(0 downto 0);
signal s14	: std_logic;
signal s10	: std_logic_vector(15 downto 0);
signal s12	: std_logic;
signal s7	: std_logic_vector(31 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(15 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s2	: std_logic;

begin

	\c13\: delay_op
	generic map (
		bits => 16,
		delay => 2
	)
	port map (
		a => s10,
		a_delayed => s11,
		clk => \clk\,
		reset => \reset\
	);

	\c15\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s14,
		a_delayed => s15,
		clk => \clk\,
		reset => \reset\
	);

	\c14\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s12,
		a_delayed => s13,
		clk => \clk\,
		reset => \reset\
	);

	\x_add_op_s_y\: add_op_s
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

	\z\: block_ram
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s11(10 downto 0),
		clk => \clk\,
		data_in => s8,
		data_out => s9,
		we => s13(0)
	);

	\x\: block_ram_x
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s10(10 downto 0),
		clk => \clk\,
		data_out => s6
	);

	\y\: block_ram_y
	generic map (
		address_width => 11,
		data_width => 32
	)
	port map (
		address(10 downto 0) => s10(10 downto 0),
		clk => \clk\,
		data_out => s7
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
		clk_en => s2,
		done => s14,
		input => s0,
		output => s10,
		reset => \reset\,
		step => s12,
		termination => s1
	);

	\result\ <= s9;
	s0 <= conv_std_logic_vector(0, 16);
	s1 <= conv_std_logic_vector(2048, 16);
	\done\ <= s15(0);
	s2 <= \init\;

end behavior;

