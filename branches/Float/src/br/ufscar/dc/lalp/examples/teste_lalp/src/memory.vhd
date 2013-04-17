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
-- Generated at Wed Apr 17 15:02:16 WEST 2013
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

entity block_ram_x is
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
end block_ram_x;

architecture rtl of block_ram_x is

constant mem_depth : integer := 2**address_width;
type ram_type is array (mem_depth-1 downto 0)
of std_logic_vector (data_width-1 downto 0);

signal read_a : std_logic_vector(address_width-1 downto 0);
signal RAM : ram_type := ram_type'(
	 ("00000000000000000000000000000000"),	 -- 7	0
	 ("00000000000000000000000000000000"),	 -- 6	0
	 ("00000000000000000000000000000000"),	 -- 5	0
	 ("00000000000000000000000000000000"),	 -- 4	0
	 ("00000000000000000000000000000000"),	 -- 3	0
	 ("00000000000000000000000000000011"),	 -- 2	3
	 ("00000000000000000000000000000010"),	 -- 1	2
	 ("01000001010100000000000000000000"));	 -- 0	1095761920

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

entity block_ram_y is
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
end block_ram_y;

architecture rtl of block_ram_y is

constant mem_depth : integer := 2**address_width;
type ram_type is array (mem_depth-1 downto 0)
of std_logic_vector (data_width-1 downto 0);

signal read_a : std_logic_vector(address_width-1 downto 0);
signal RAM : ram_type := ram_type'(
	 ("00000000000000000000000000000000"),	 -- 7	0
	 ("00000000000000000000000000000000"),	 -- 6	0
	 ("00000000000000000000000000000000"),	 -- 5	0
	 ("00000000000000000000000000000000"),	 -- 4	0
	 ("00000000000000000000000000000000"),	 -- 3	0
	 ("00000000000000000000000000000110"),	 -- 2	6
	 ("00000000000000000000000000000101"),	 -- 1	5
	 ("01000000000000000000000000000000"));	 -- 0	1073741824

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
