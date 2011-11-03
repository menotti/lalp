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
-- Generated at Thu Nov 03 12:20:04 BRST 2011
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_matmult is
end t_matmult;

architecture behavior of t_matmult is

component matmult
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(15 downto 0)
	);
end component;

signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \init\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \result\	: std_logic_vector(15 downto 0)	:= (others => '0');

begin

uut: matmult
port map (
	\clear\ => \clear\,
	\clk\ => \clk\,
	\done\ => \done\,
	\init\ => \init\,
	\reset\ => \reset\,
	\result\ => \result\
);

clock: process
begin
	wait for 5 ns;
	\clk\  <= not \clk\;
end process clock;

stimulus: process
begin
	\reset\  <= '1';
	wait for 50 ns;
	\reset\  <= '0';
	wait for 50 ns;
	\init\  <= '1';
	wait;
end process stimulus;

process

begin

	wait for 10 ns;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(29,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(55,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(71,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(59,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(41,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(47,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(86,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(93,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(92,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(82,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(54,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(102,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(116,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(131,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(76,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(24,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(55,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(84,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(63,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(47,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(46,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(83,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(108,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(124,16)
		report "value differente from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(89,16)
		report "value differente from the expected" severity error;

	assert false report "end of test" severity note;

wait;
end process;

end behavior;
