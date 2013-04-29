-- ###############################
-- Behavioral description of the LalpFloat Library
--
-- Revision 2013, January 27th
-- by Cristiano B. de Oliveira
-- email: cbacelar@icmc.usp.br
-- Related to Fixed/Floating Point componentes for LALP.
--
-- #############################



-- FLOATING POINT OPERATORS



--  Floating Point Adder


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity add_op_fl is  
  generic (w_in1  : integer := 32;
	   w_in2  : integer := 32;
	   w_out : integer :=32);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end add_op_fl;

architecture behav of add_op_fl is
  Signal a, b, S :  float (8 downto -23);
begin
  a <= to_float (I0, a'high, -a'low);
  b <= to_float (I1, b);
  S <= a + b;
  O0 <= to_slv (S);
end behav;

--  Floating Point Sub

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity sub_op_fl is  
  generic (w_in1  : integer := 32;
	   w_in2  : integer := 32;
	   w_out : integer :=32);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end sub_op_fl;

architecture behav of sub_op_fl is
  Signal a, b, S :  float (8 downto -23);
begin
  a <= to_float (I0, a'high, -a'low);
  b <= to_float (I1, b);
  S <= a - b;
  O0 <= to_slv (S);
end behav;


--  Floating Point Multiplier

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity mult_op_fl is  
  generic (w_in1  : integer := 32;
	   w_in2  : integer := 32;
	   w_out : integer :=32);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end mult_op_fl;

architecture behav of mult_op_fl is
  Signal a, b, S :  float (8 downto -23);
begin
  a <= to_float (I0, a'high, -a'low);
  b <= to_float (I1, b);
  S <= a * b;
  O0 <= to_slv (S);
end behav;


--  Floating Point Divider

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity div_op_fl is  
  generic (w_in1  : integer := 32;
	   w_in2  : integer := 32;
	   w_out : integer :=32);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end div_op_fl;

architecture behav of div_op_fl is
  Signal a, b, S :  float (8 downto -23);
begin
  a <= to_float (I0, a'high, -a'low);
  b <= to_float (I1, b);
  S <= a / b;
  O0 <= to_slv (S);
end behav;

