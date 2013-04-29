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
-- Generated at Wed Dec 12 13:45:23 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_fdct is
end t_fdct;

architecture behavior of t_fdct is

component fdct
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

uut: fdct
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
	assert \output\ = conv_std_logic_vector(-1856,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-9,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-54,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(14,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(75,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-14,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-90,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(99,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-29,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-39,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-184,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(20,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(38,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(62,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(113,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(124,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-165,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-53,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-100,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(111,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-9,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(5,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-5,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1840,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(26,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(20,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-66,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-23,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-38,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-70,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(89,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(26,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(23,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(32,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(77,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(169,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-109,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-32,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-95,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(7,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(121,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(54,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(41,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(87,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(56,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(159,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(295,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-222,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-27,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-121,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(67,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-196,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(91,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-365,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(410,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(460,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-30,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-73,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-48,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-100,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-87,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-520,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(133,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(48,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(28,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-66,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1896,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-120,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(30,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(156,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-29,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-39,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-195,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-194,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(254,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-7,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-39,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-53,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-267,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-54,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(26,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-119,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(23,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-194,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-359,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(130,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(469,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-195,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-267,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1341,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(20,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(130,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(156,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(9,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(254,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(469,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(99,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-613,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(26,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(130,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(40,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1832,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-44,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(39,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-60,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(73,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-296,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-90,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(29,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(35,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(27,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(57,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(37,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(193,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-139,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(39,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-71,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(63,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-97,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(117,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-481,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-144,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(48,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(78,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(50,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(144,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(260,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-192,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-24,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(66,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-134,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(107,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-183,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(200,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-907,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-247,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(90,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(279,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(129,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(454,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(176,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(837,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(931,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1109,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-84,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-127,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(155,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-205,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(213,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-382,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1050,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(480,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-22,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-20,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-28,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-144,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(87,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1816,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(50,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(68,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(119,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(346,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-160,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-59,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-95,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-175,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(120,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(226,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(80,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(106,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(110,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(194,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(560,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-262,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-53,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-79,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(26,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-129,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(35,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-239,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(168,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(309,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(126,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(146,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(204,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(200,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(375,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1018,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-505,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-97,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-362,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(184,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-588,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1088,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1217,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1406,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-125,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-124,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-210,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-201,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-288,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-369,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1465,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(502,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(140,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(40,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(66,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-14,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(122,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-157,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(7,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1944,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-143,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-264,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(30,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(344,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-63,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-86,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-430,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-143,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-232,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-428,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(559,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-7,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-85,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-117,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-588,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-54,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(57,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-263,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(23,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-428,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-791,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(130,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1033,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-430,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-588,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2956,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(20,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(288,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(344,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(9,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(559,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1034,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(99,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1350,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(57,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(287,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(40,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-28,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1808,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-79,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(78,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-108,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(145,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-537,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-184,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(53,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(70,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(44,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(114,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(60,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(210,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(310,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-277,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-29,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(77,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-128,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(126,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-175,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(234,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-873,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-297,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(86,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(96,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(60,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(156,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(82,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(288,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(420,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-380,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-40,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(138,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-239,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(224,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-327,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(416,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1630,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-529,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(160,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(521,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(246,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(845,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(337,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1560,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1739,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2055,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-162,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-221,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(293,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-358,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(400,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-664,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1995,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(848,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-197,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-45,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-32,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-73,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-43,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-136,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-222,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(179,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(21,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1792,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(85,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(104,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(116,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(191,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(587,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-254,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-56,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-93,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(35,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-151,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(48,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-280,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(237,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(364,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-24,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(104,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(137,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(169,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(188,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(311,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(952,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-415,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-91,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-128,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(49,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-207,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(67,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-382,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(328,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(496,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(198,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(321,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(344,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(591,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1741,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-787,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-167,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-603,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(302,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-979,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(412,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1811,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2024,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2350,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-203,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-218,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-348,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-354,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-476,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-651,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2409,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(871,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(232,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(64,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-22,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(104,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-29,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(192,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-143,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-249,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1992,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(6,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-221,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(8,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-408,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(30,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(533,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-96,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-132,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(36,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-665,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-42,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(64,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-221,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(10,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-358,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(13,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-662,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(864,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-7,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(15,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-132,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(25,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-181,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-909,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-54,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(88,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-407,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(23,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-662,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1223,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(130,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1598,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-665,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(3,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-909,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4570,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(19,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(444,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(532,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(9,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(865,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(12,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1598,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(99,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2087,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-4,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-11,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(65,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(88,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(444,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(40,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-43,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1784,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-114,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(117,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-156,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(217,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-778,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-278,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(76,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(105,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(61,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(171,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(84,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(315,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(428,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-414,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-41,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(116,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-185,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(189,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-253,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(351,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-1264,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-450,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(124,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(144,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(83,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(234,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(114,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(432,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(581,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-568,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-55,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(210,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-345,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(341,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-471,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(632,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-2353,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-811,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(231,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(761,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(363,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1237,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(497,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2283,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2546,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-3000,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-241,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-315,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(430,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-511,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(589,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-946,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(2940,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1217,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-288,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-69,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-43,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-112,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-59,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-206,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(-301,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(271,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(28,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \output\" severity note;

wait;
end process;

end behavior;
