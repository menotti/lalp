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
entity t_fibonacci_data_reuse is
end t_fibonacci_data_reuse;

architecture behavior of t_fibonacci_data_reuse is

component fibonacci_data_reuse
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end component;

signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \init\	: std_logic	:= '0';
signal \output\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \reset\	: std_logic	:= '0';

begin

uut: fibonacci_data_reuse
port map (
	\clear\ => \clear\,
	\clk\ => \clk\,
	\done\ => \done\,
	\init\ => \init\,
	\output\ => \output\,
	\reset\ => \reset\
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

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(5,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(21,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(34,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(55,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(89,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(144,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(233,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(377,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(610,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(987,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1597,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2584,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(4181,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6765,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10946,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17711,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(28657,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(46368,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(75025,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(121393,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(196418,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(317811,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(514229,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(832040,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \output\" severity note;

wait;
end process;

end behavior;
