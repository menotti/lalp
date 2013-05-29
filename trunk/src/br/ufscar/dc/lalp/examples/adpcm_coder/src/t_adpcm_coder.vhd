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
-- Generated at Tue May 28 15:50:43 BRT 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_adpcm_coder is
end t_adpcm_coder;

architecture behavior of t_adpcm_coder is

component adpcm_coder
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

uut: adpcm_coder
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
	assert \output\ = conv_std_logic_vector(68,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(53,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(35,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(52,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(51,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(52,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(255,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(161,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(240,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(224,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(176,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(254,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(176,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(224,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(33,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(47,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(240,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(160,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(253,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(192,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(253,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(240,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(251,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(17,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(253,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(31,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(192,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(16,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(1,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(18,32)
		report "value different from the expected" severity error;

	wait on \output\;
	assert \output\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \output\" severity note;

wait;
end process;

end behavior;
