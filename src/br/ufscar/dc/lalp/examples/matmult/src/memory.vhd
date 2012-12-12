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
-- Generated at Wed Dec 12 13:47:07 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity block_ram_a is
generic(
	data_width : integer := 8;
	address_width : integer := 8
);
port(
	data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0');
	address : in std_logic_vector(address_width-1 downto 0);
	we: in std_logic := '0';
	oe: in std_logic := '1';
	clk : in std_logic;
	data_out : out std_logic_vector(data_width-1 downto 0));
end block_ram_a;

architecture rtl of block_ram_a is

constant mem_depth : integer := 2**address_width;
type ram_type is array (mem_depth-1 downto 0)
of std_logic_vector (data_width-1 downto 0);

signal read_a : std_logic_vector(address_width-1 downto 0);
signal RAM : ram_type := ram_type'(
	 ("0000000000000000"),	 -- 31	0
	 ("0000000000000000"),	 -- 30	0
	 ("0000000000000000"),	 -- 29	0
	 ("0000000000000000"),	 -- 28	0
	 ("0000000000000000"),	 -- 27	0
	 ("0000000000000000"),	 -- 26	0
	 ("0000000000000000"),	 -- 25	0
	 ("0000000000000101"),	 -- 24	5
	 ("0000000000000010"),	 -- 23	2
	 ("0000000000001000"),	 -- 22	8
	 ("0000000000000111"),	 -- 21	7
	 ("0000000000000101"),	 -- 20	5
	 ("0000000000000100"),	 -- 19	4
	 ("0000000000000011"),	 -- 18	3
	 ("0000000000001000"),	 -- 17	8
	 ("0000000000000011"),	 -- 16	3
	 ("0000000000000001"),	 -- 15	1
	 ("0000000000001001"),	 -- 14	9
	 ("0000000000001001"),	 -- 13	9
	 ("0000000000000100"),	 -- 12	4
	 ("0000000000000110"),	 -- 11	6
	 ("0000000000000010"),	 -- 10	2
	 ("0000000000001000"),	 -- 9	8
	 ("0000000000000011"),	 -- 8	3
	 ("0000000000000101"),	 -- 7	5
	 ("0000000000000001"),	 -- 6	1
	 ("0000000000000110"),	 -- 5	6
	 ("0000000000000110"),	 -- 4	6
	 ("0000000000000100"),	 -- 3	4
	 ("0000000000000011"),	 -- 2	3
	 ("0000000000000010"),	 -- 1	2
	 ("0000000000000001"));	 -- 0	1

begin
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (we = '1') then
        RAM(conv_integer(address)) <= data_in;
        data_out <= RAM(conv_integer(read_a));
      elsif (oe = '1') then
        data_out <= RAM(conv_integer(read_a));
      end if;
      read_a <= address;
    end if;
  end process;
end rtl;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity block_ram_b is
generic(
	data_width : integer := 8;
	address_width : integer := 8
);
port(
	data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0');
	address : in std_logic_vector(address_width-1 downto 0);
	we: in std_logic := '0';
	oe: in std_logic := '1';
	clk : in std_logic;
	data_out : out std_logic_vector(data_width-1 downto 0));
end block_ram_b;

architecture rtl of block_ram_b is

constant mem_depth : integer := 2**address_width;
type ram_type is array (mem_depth-1 downto 0)
of std_logic_vector (data_width-1 downto 0);

signal read_a : std_logic_vector(address_width-1 downto 0);
signal RAM : ram_type := ram_type'(
	 ("0000000000000000"),	 -- 31	0
	 ("0000000000000000"),	 -- 30	0
	 ("0000000000000000"),	 -- 29	0
	 ("0000000000000000"),	 -- 28	0
	 ("0000000000000000"),	 -- 27	0
	 ("0000000000000000"),	 -- 26	0
	 ("0000000000000000"),	 -- 25	0
	 ("0000000000000011"),	 -- 24	3
	 ("0000000000000010"),	 -- 23	2
	 ("0000000000001000"),	 -- 22	8
	 ("0000000000000100"),	 -- 21	4
	 ("0000000000000011"),	 -- 20	3
	 ("0000000000000001"),	 -- 19	1
	 ("0000000000000101"),	 -- 18	5
	 ("0000000000000000"),	 -- 17	0
	 ("0000000000000100"),	 -- 16	4
	 ("0000000000000001"),	 -- 15	1
	 ("0000000000000010"),	 -- 14	2
	 ("0000000000000001"),	 -- 13	1
	 ("0000000000000101"),	 -- 12	5
	 ("0000000000000010"),	 -- 11	2
	 ("0000000000000000"),	 -- 10	0
	 ("0000000000000011"),	 -- 9	3
	 ("0000000000001000"),	 -- 8	8
	 ("0000000000000100"),	 -- 7	4
	 ("0000000000000010"),	 -- 6	2
	 ("0000000000000010"),	 -- 5	2
	 ("0000000000000111"),	 -- 4	7
	 ("0000000000001000"),	 -- 3	8
	 ("0000000000000000"),	 -- 2	0
	 ("0000000000000101"),	 -- 1	5
	 ("0000000000000011"));	 -- 0	3

begin
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (we = '1') then
        RAM(conv_integer(address)) <= data_in;
        data_out <= RAM(conv_integer(read_a));
      elsif (oe = '1') then
        data_out <= RAM(conv_integer(read_a));
      end if;
      read_a <= address;
    end if;
  end process;
end rtl;
