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
entity addsub is
	port (
		\a\	: out	std_logic_vector(31 downto 0);
		\s\	: out	std_logic_vector(31 downto 0);
		\x\	: in	std_logic_vector(31 downto 0);
		\y\	: in	std_logic_vector(31 downto 0)
	);
end addsub;

architecture behavior of addsub is

component add_op_s
generic (
	w_in1	: integer := 8;
	w_in2	: integer := 8;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component sub_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

signal s5	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(31 downto 0);
signal s2	: std_logic_vector(31 downto 0);

begin

	\x_sub_op_s_y\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s3,
		I1 => s4,
		O0 => s5
	);

	\x_add_op_s_y\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s3,
		I1 => s4,
		O0 => s2
	);

	s3 <= \x\;
	s4 <= \y\;
	\a\ <= s2;
	\s\ <= s5;

end behavior;

