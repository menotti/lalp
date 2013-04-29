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
-- Generated at Wed Dec 12 13:38:55 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_addsub is
end t_addsub;

architecture behavior of t_addsub is

component addsub
	port (
		\a\	: out	std_logic_vector(31 downto 0);
		\s\	: out	std_logic_vector(31 downto 0);
		\x\	: in	std_logic_vector(31 downto 0);
		\y\	: in	std_logic_vector(31 downto 0)
	);
end component;

signal \a\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \s\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \x\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \y\	: std_logic_vector(31 downto 0)	:= (others => '0');

begin

uut: addsub
port map (
	\a\ => \a\,
	\s\ => \s\,
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
	\y\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\y\ <= conv_std_logic_vector('X', 32);
wait;
end process y_atribution;

process

begin

	wait for 10 ns;

	wait on \s\;
	assert \a\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \a\" severity note;

wait;
end process;

process

begin

	wait for 10 ns;

	wait on \s\;
	assert \s\ = conv_std_logic_vector(-2,32)
		report "value different from the expected" severity error;

	wait on \s\;
	assert \s\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait on \s\;
	assert \s\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \s\" severity note;

wait;
end process;

process

begin

	wait for 10 ns;

	wait on \a\;
	assert \a\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait for 12 ns;
	assert \a\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \a\ = conv_std_logic_vector(4,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \a\" severity note;

wait;
end process;

process

begin

	wait for 10 ns;

	wait on \s\;
	assert \s\ = conv_std_logic_vector(-2,32)
		report "value different from the expected" severity error;

	wait for 12 ns;
	assert \s\ = conv_std_logic_vector(0,32)
		report "value different from the expected" severity error;

	wait for 10 ns;
	assert \s\ = conv_std_logic_vector(2,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \s\" severity note;

wait;
end process;

end behavior;
