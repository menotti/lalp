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
-- Generated at Fri Oct 21 17:46:15 BRST 2011
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_max is
end t_max;

architecture behavior of t_max is

component max
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\maxval\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end component;

signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \init\	: std_logic	:= '0';
signal \maxval\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \reset\	: std_logic	:= '0';

begin

uut: max
port map (
	\clear\ => \clear\,
	\clk\ => \clk\,
	\done\ => \done\,
	\init\ => \init\,
	\maxval\ => \maxval\,
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

	wait until \maxval\ =  conv_std_logic_vector(1,32);
	assert \maxval\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait for 12 ns;
	assert \maxval\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(5,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(7,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \maxval\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	assert false report "end of test" severity note;

wait;
end process;

end behavior;
