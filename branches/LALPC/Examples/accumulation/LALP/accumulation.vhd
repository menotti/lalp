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
-- Generated at Thu May 16 16:47:21 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity accumulation is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0);
	data_in_1 : in std_logic_vector(31 downto 0); 
	address_1 : in std_logic_vector(3 downto 0); 
	we_1 : in std_logic
	);
end accumulation;

architecture behavior of accumulation is

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

component block_ram_mult_a 
generic( 
	data_width : integer := 8; 
	address_width : integer := 8 
); 
port( 
	data_in_0 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_0 : in std_logic_vector(address_width-1 downto 0); 
	we_0 : in std_logic := '0'; 
	oe_0 : in std_logic := '1'; 
	data_out_0 : out std_logic_vector(data_width-1 downto 0); 
	data_in_1 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_1 : in std_logic_vector(address_width-1 downto 0); 
	we_1 : in std_logic := '0'; 
	oe_1 : in std_logic := '1'; 
	data_out_1 : out std_logic_vector(data_width-1 downto 0); 
	clk : in std_logic); 
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

signal s0	: std_logic_vector(31 downto 0);
signal s13	: std_logic_vector(0 downto 0);
signal s11	: std_logic_vector(0 downto 0);
signal s15	: std_logic_vector(31 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s10	: std_logic;
signal s12	: std_logic;
signal s9	: std_logic;
signal s3	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(31 downto 0);
signal s8	: std_logic_vector(31 downto 0);

begin

	\c14\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s14,
		a_delayed => s15,
		clk => \clk\,
		reset => \reset\
	);

	\c13\: delay_op
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

	\c12\: delay_op
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

	\acc\: add_reg_op_s
	generic map (
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s8,
		I1 => s6,
		O0 => s8,
		clk => \clk\,
		reset => \reset\,
		we => s13(0)
	);

	\x\: block_ram_mult_a
	generic map (
		address_width => 4,
		data_width => 32
	)
	port map (
		address_0(3 downto 0) => s14(3 downto 0),
		clk => \clk\,
		data_out_0 => s3,
	data_in_1 => data_in_1,
	address_1 => address_1,
	we_1 => we_1
	);

	\x_add_op_s_i\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s3,
		I1 => s15,
		O0 => s6
	);

	\i\: counter
	generic map (
		bits => 32,
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
		output => s14,
		reset => \reset\,
		step => s12,
		termination => s1
	);

	\done\ <= s11(0);
	s0 <= conv_std_logic_vector(0, 32);
	s1 <= conv_std_logic_vector(10, 32);
	\sum\ <= s8;
	s9 <= \init\;

end behavior;

