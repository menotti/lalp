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
-- Generated at Wed May 22 16:28:21 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_accumulation is
end t_accumulation;

architecture behavior of t_accumulation is

component accumulation
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\sum\	: out	std_logic_vector(31 downto 0)
	);
end component;

signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \init\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \sum\	: std_logic_vector(31 downto 0)	:= (others => '0');

begin

uut: accumulation
port map (
	\clear\ => \clear\,
	\clk\ => \clk\,
	\done\ => \done\,
	\init\ => \init\,
	\reset\ => \reset\,
	\sum\ => \sum\
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

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(9,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(49,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(64,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(81,32)
		report "value different from the expected" severity error;

	wait on \sum\;
	assert \sum\ = conv_std_logic_vector(100,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \sum\" severity note;

wait;
end process;

end behavior;
