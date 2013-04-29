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
-- Generated at Wed Dec 12 13:54:50 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_vecsum_asynchronous is
end t_vecsum_asynchronous;

architecture behavior of t_vecsum_asynchronous is

component vecsum_asynchronous
	port (
		\result\	: out	std_logic_vector(31 downto 0);
		\x\	: in	std_logic_vector(31 downto 0);
		\y\	: in	std_logic_vector(31 downto 0)
	);
end component;

signal \result\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \x\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \y\	: std_logic_vector(31 downto 0)	:= (others => '0');

begin

uut: vecsum_asynchronous
port map (
	\result\ => \result\,
	\x\ => \x\,
	\y\ => \y\
);

x_atribution: process
begin

	wait for 10 ns;

	wait for 10 ns;
	\x\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\x\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\x\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\x\ <= conv_std_logic_vector('X', 32);
wait;
end process x_atribution;

y_atribution: process
begin

	wait for 10 ns;

	wait for 10 ns;
	\y\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector(5,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector(6,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector('X', 32);
wait;
end process y_atribution;

process

begin

	wait for 10 ns;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(5,32)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(7,32)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(9,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \result\" severity note;

wait;
end process;

end behavior;
