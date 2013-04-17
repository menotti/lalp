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
-- Generated at Wed Dec 12 13:46:22 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity t_fir is
end t_fir;

architecture behavior of t_fir is

component fir
	port (
		\a\	: in	std_logic_vector(31 downto 0);
		\b\	: in	std_logic_vector(31 downto 0);
		\c\	: in	std_logic_vector(31 downto 0);
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\d\	: in	std_logic_vector(31 downto 0);
		\e\	: in	std_logic_vector(31 downto 0);
		\init\	: in	std_logic;
		\reset\	: in	std_logic;
		\result\	: out	std_logic_vector(31 downto 0)
	);
end component;

signal \a\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \b\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \c\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \clear\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \d\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \e\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \init\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \result\	: std_logic_vector(31 downto 0)	:= (others => '0');

begin

uut: fir
port map (
	\a\ => \a\,
	\b\ => \b\,
	\c\ => \c\,
	\clear\ => \clear\,
	\clk\ => \clk\,
	\d\ => \d\,
	\e\ => \e\,
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

b_atribution: process
begin

	wait until \init\ = '1';

	wait for 10 ns;
	\b\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\b\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\b\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\b\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\b\ <= conv_std_logic_vector('X', 32);
wait;
end process b_atribution;

a_atribution: process
begin

	wait until \init\ = '1';

	wait for 10 ns;
	\a\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\a\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\a\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\a\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\a\ <= conv_std_logic_vector('X', 32);
wait;
end process a_atribution;

e_atribution: process
begin

	wait until \init\ = '1';

	wait for 10 ns;
	\e\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\e\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\e\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\e\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\e\ <= conv_std_logic_vector('X', 32);
wait;
end process e_atribution;

d_atribution: process
begin

	wait until \init\ = '1';

	wait for 10 ns;
	\d\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\d\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\d\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\d\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\d\ <= conv_std_logic_vector('X', 32);
wait;
end process d_atribution;

c_atribution: process
begin

	wait until \init\ = '1';

	wait for 10 ns;
	\c\ <= conv_std_logic_vector(1,32);
	wait for 10 ns;
	\c\ <= conv_std_logic_vector(2,32);
	wait for 10 ns;
	\c\ <= conv_std_logic_vector(3,32);
	wait for 10 ns;
	\c\ <= conv_std_logic_vector(4,32);
	wait for 10 ns;
	\c\ <= conv_std_logic_vector('X', 32);
wait;
end process c_atribution;

process

begin

	wait for 10 ns;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(35,32)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(70,32)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(105,32)
		report "value different from the expected" severity error;

	wait on \result\;
	assert \result\ = conv_std_logic_vector(140,32)
		report "value different from the expected" severity error;

	assert false report "end of test of \result\" severity note;

wait;
end process;

end behavior;
