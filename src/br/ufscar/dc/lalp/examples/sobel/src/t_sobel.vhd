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
-- Generated at Wed Dec 12 13:48:46 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_sobel is
end t_sobel;

architecture behavior of t_sobel is

component sobel
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

uut: sobel
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
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(78,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(140,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(196,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(228,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(212,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(28,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(76,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(142,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(236,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(138,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(172,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(236,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(112,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(76,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(86,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(116,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(186,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(220,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(216,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(188,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(232,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(212,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(126,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(156,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(226,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(92,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(132,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(128,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(108,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(68,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(92,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(74,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(160,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(136,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(118,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(158,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(204,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(88,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(228,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(68,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(92,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(60,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(44,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(92,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(78,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(144,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(32,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(148,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(12,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(102,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(162,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(118,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(98,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(146,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(132,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(208,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(116,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(232,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(52,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(226,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(254,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(130,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(82,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(132,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(192,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(208,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(112,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(255,16)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(172,16)
		report "value different from the expected" severity error;

	assert false report "end of test of \result\" severity note;

wait;
end process;

end behavior;
