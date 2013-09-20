-- ###############################
-- Behavioral description of the LalpFloat Library
--
-- Revision 2013, March 27th
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
	   w_out  : integer := 32;
           w_exp  : integer :=  8;
           w_man  : integer := 23);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end add_op_fl;

architecture behav of add_op_fl is
  Signal a, b :  float (w_exp downto -w_man);
begin
--  a <= to_float (I0, a);
--  b <= to_float (I1, b);
--  S <= a + b;
--  O0 <= to_slv (S);
  O0 <= to_slv (to_float (I0, a) + to_float (I1, b));
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
	   w_out  : integer := 32;
           w_exp  : integer :=  8;
           w_man  : integer := 23);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end sub_op_fl;

architecture behav of sub_op_fl is
  Signal a, b :  float (w_exp downto -w_man);
begin
--  a <= to_float (I0, a);
--  b <= to_float (I1, b);
--  S <= a - b;
--  O0 <= to_slv (S);
  O0 <= to_slv (to_float (I0, a) - to_float (I1, b));
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
	   w_out  : integer := 32;
           w_exp  : integer :=  8;
           w_man  : integer := 23);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end mult_op_fl;

architecture behav of mult_op_fl is
  Signal a, b :  float (w_exp downto -w_man);
begin
--  a <= to_float (I0, a);
--  b <= to_float (I1, b);
--  S <= a * b;
  O0 <= to_slv (to_float (I0, a) * to_float (I1, b));
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
	   w_out  : integer := 32;
           w_exp  : integer :=  8;
           w_man  : integer := 23);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end div_op_fl;

architecture behav of div_op_fl is
  Signal a, b :  float (w_exp downto -w_man);
begin
--  a <= to_float (I0, a);
--  b <= to_float (I1, b);
--  S <= a / b;
--  O0 <= to_slv (S);
  O0 <= to_slv (to_float (I0, a) / to_float (I1, b));
end behav;


--
-- registered add with signed operands (Floating point implementation missing)
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity add_reg_op_fl is
	generic (
		w_in1	: integer	:= 16;
  		w_in2  	: integer	:= 16;
		w_out 	: integer	:= 32;
		initial	: integer	:= 0
	);
  	port (
  	    clk	: in    std_logic;
  	    reset	: in    std_logic;
    	we  : in    std_logic := '1';
--	    Sel1	: in	std_logic_vector(0 downto 0) := "1";
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0	: out	std_logic_vector(w_out-1 downto 0) 
  	);
end add_reg_op_fl;

architecture behav of add_reg_op_fl is

begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_out);
	  	elsif (clk'event and clk = '1') then
			if (we = '1') then
		--		if (Sel1(0) = '1') then
					O0 <= to_slv(to_float(I0) + to_float(I1));
		--		else
		--			O0 <= I0;
		--		end if;
	  		end if;
		end if;
  	end process;
end behav;

--
-- registered sub with signed operands (Floating point implementation missing)
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;


entity sub_reg_op_fl is  
	generic (
		w_in1	: integer	:= 16;
  		w_in2  	: integer 	:= 16;
		w_out 	: integer 	:= 32;
		initial	: integer	:= 0
	);
  	port (
  	    clk	: in    std_logic;	 
  	    reset	: in    std_logic;
    	we  : in    std_logic := '1';
	    Sel1	: in	std_logic_vector(0 downto 0) := "1";
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0	: out	std_logic_vector(w_out-1 downto 0) 
  	);
end sub_reg_op_fl;

architecture behav of sub_reg_op_fl is

begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_out);
		elsif (clk'event and clk = '1') then
			if (we = '1') then
				if (Sel1(0) = '1') then
					O0 <= to_slv(to_float(I0) - to_float(I1));
				else
					O0 <= I0;
				end if;
			end if;
		end if;
	end process;
end behav;


--
-- multiplier with unsigned operands and a number of pipeline stages
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;


entity mult_op_p_fl is
	generic (
		w_in1	: integer := 16;
  		w_in2	: integer := 16;
		w_out	: integer := 32;
                w_exp   : integer :=  8;
                w_man   : integer := 23;
                k: integer := 5 -- number of pipeline stages
	);
	port (
	clk	: in	std_logic;
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0  : out	std_logic_vector(w_out-1 downto 0) 
	);
end mult_op_p_fl;

architecture behav of mult_op_p_fl is
	type intermediate is array (k-1 downto 0) of std_logic_vector(w_out-1 downto 0);
	signal int : intermediate;
        Signal a, b:  float (w_exp downto -w_man);
begin
  process(clk)
  begin
    if(clk'event and clk = '1') then

	if k=1 then
          O0 <= to_slv (to_float (I0, a)*to_float (I1, b));
	else
          int(0) <= to_slv (to_float (I0, a)*to_float (I1, b));

          for i in 1 to k-2 loop
            int(i) <= int(i-1);
          end loop;
         
          O0 <= int(k-2);
	end if;

    end if;
  end process;
end behav;




-- FIXED POINT OPERATORS

--  Flixed Point Multiplier

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity mult_op_fx_s is  
  generic (w_in1  : integer := 32;
	   w_in2  : integer := 32;
	   w_out  : integer := 32;
           w_int  : integer := 16;
           w_dec  : integer := 16);
  port (
    I0             : in std_logic_vector(w_in1-1 downto 0);
    I1             : in std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end mult_op_fx_s;

architecture behav of mult_op_fx_s is
  Signal a, b :  sfixed (w_int-1 downto -w_dec);
  signal S : sfixed(w_int+w_int-1 downto -(w_dec+w_dec));

begin
  a <= to_sfixed (I0, a);
  b <= to_sfixed (I1, b);
  S <= a * b;
  O0 <= to_slv (resize(S, w_int-1 , -w_dec));
end behav;


------------------------------------------------------------------------


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
-- Generated at Tue Jun 25 15:54:56 WEST 2013
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity mult_lalp_fl32 is
       generic (
	  w_in1	: integer := 16;
	  w_in2	: integer := 16;
	  w_out	: integer := 32
        );
	port (
		\I0\	: in	std_logic_vector(31 downto 0);
		\I1\	: in	std_logic_vector(31 downto 0);
		\O0\	: out	std_logic_vector(31 downto 0);
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\reset\	: in	std_logic
	);
end mult_lalp_fl32;

architecture behavior of mult_lalp_fl32 is

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

component and_op
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component delay_op
generic (
	bits	: integer := 8;
	delay	: integer := 1
);
port (
	a			: in	std_logic_vector(bits-1 downto 0);
	clk			: in	std_logic;
	reset		: in	std_logic;
	a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0')
);
end component;

component if_eq_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component if_ge_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component mult_op_s
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

component or_op
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component reg_mux_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	Sel1	: in	std_logic_vector(0 downto 0);
	I0	: in	std_logic_vector(w_in-1 downto 0);
	I1	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

component reg_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	I0	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

component shl_c_op_s
generic (
	w_in1	: integer := 16;
	w_out	: integer := 15;
	s_amount	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component shr_c_op_s
generic (
	w_in1	: integer := 16;
	w_out	: integer := 15;
	s_amount	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
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

component xor_op
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

signal s0	: std_logic_vector(0 downto 0);
signal s100	: std_logic_vector(0 downto 0);
signal s85	: std_logic_vector(31 downto 0);
signal s119	: std_logic_vector(31 downto 0);
signal s104	: std_logic_vector(31 downto 0);
signal s45	: std_logic_vector(31 downto 0);
signal s30	: std_logic_vector(31 downto 0);
signal s34	: std_logic_vector(0 downto 0);
signal s64	: std_logic_vector(31 downto 0);
signal s123	: std_logic_vector(31 downto 0);
signal s121	: std_logic_vector(0 downto 0);
signal s125	: std_logic_vector(31 downto 0);
signal s9	: std_logic_vector(31 downto 0);
signal s68	: std_logic_vector(0 downto 0);
signal s70	: std_logic_vector(31 downto 0);
signal s13	: std_logic_vector(31 downto 0);
signal s17	: std_logic_vector(31 downto 0);
signal s87	: std_logic_vector(31 downto 0);
signal s117	: std_logic_vector(31 downto 0);
signal s32	: std_logic_vector(31 downto 0);
signal s106	: std_logic_vector(31 downto 0);
signal s51	: std_logic_vector(31 downto 0);
signal s47	: std_logic_vector(31 downto 0);
signal s81	: std_logic_vector(31 downto 0);
signal s83	: std_logic_vector(31 downto 0);
signal s22	: std_logic_vector(31 downto 0);
signal s26	: std_logic_vector(31 downto 0);
signal s96	: std_logic_vector(31 downto 0);
signal s37	: std_logic_vector(31 downto 0);
signal s126	: std_logic_vector(31 downto 0);
signal s41	: std_logic_vector(31 downto 0);
signal s115	: std_logic_vector(31 downto 0);
signal s58	: std_logic_vector(31 downto 0);
signal s56	: std_logic_vector(31 downto 0);
signal s62	: std_logic_vector(0 downto 0);
signal s7	: std_logic_vector(31 downto 0);
signal s3	: std_logic_vector(31 downto 0);
signal s90	: std_logic_vector(31 downto 0);
signal s109	: std_logic_vector(31 downto 0);
signal s94	: std_logic_vector(31 downto 0);
signal s113	: std_logic_vector(31 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s43	: std_logic_vector(31 downto 0);
signal s39	: std_logic_vector(31 downto 0);
signal s73	: std_logic_vector(31 downto 0);
signal s18	: std_logic_vector(31 downto 0);
signal s77	: std_logic_vector(31 downto 0);
signal s75	: std_logic_vector(31 downto 0);
signal s79	: std_logic_vector(31 downto 0);
signal s63	: std_logic_vector(31 downto 0);
signal s122	: std_logic_vector(0 downto 0);
signal s52	: std_logic_vector(31 downto 0);
signal s48	: std_logic_vector(31 downto 0);
signal s107	: std_logic_vector(0 downto 0);
signal s29	: std_logic_vector(31 downto 0);
signal s103	: std_logic_vector(31 downto 0);
signal s33	: std_logic_vector(0 downto 0);
signal s27	: std_logic_vector(31 downto 0);
signal s86	: std_logic_vector(0 downto 0);
signal s88	: std_logic_vector(31 downto 0);
signal s82	: std_logic_vector(31 downto 0);
signal s120	: std_logic;
signal s124	: std_logic_vector(31 downto 0);
signal s31	: std_logic_vector(31 downto 0);
signal s35	: std_logic_vector(0 downto 0);
signal s46	: std_logic_vector(0 downto 0);
signal s14	: std_logic_vector(31 downto 0);
signal s12	: std_logic_vector(31 downto 0);
signal s65	: std_logic_vector(31 downto 0);
signal s71	: std_logic_vector(31 downto 0);
signal s67	: std_logic_vector(31 downto 0);
signal s69	: std_logic_vector(31 downto 0);
signal s59	: std_logic_vector(31 downto 0);
signal s40	: std_logic_vector(31 downto 0);
signal s114	: std_logic_vector(31 downto 0);
signal s55	: std_logic_vector(0 downto 0);
signal s19	: std_logic_vector(31 downto 0);
signal s110	: std_logic_vector(0 downto 0);
signal s108	: std_logic_vector(31 downto 0);
signal s23	: std_logic_vector(31 downto 0);
signal s76	: std_logic_vector(31 downto 0);
signal s74	: std_logic_vector(0 downto 0);
signal s80	: std_logic_vector(0 downto 0);
signal s61	: std_logic_vector(31 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s116	: std_logic_vector(31 downto 0);
signal s112	: std_logic_vector(31 downto 0);
signal s42	: std_logic_vector(31 downto 0);
signal s36	: std_logic_vector(31 downto 0);
signal s95	: std_logic_vector(31 downto 0);
signal s93	: std_logic_vector(31 downto 0);
signal s97	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(0 downto 0);
signal s8	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(31 downto 0);
signal s2	: std_logic_vector(31 downto 0);

begin

	\O0_exp_tmp2_shl_c_op_s_23\: shl_c_op_s
	generic map (
		s_amount => 23,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s95,
		O0 => s123
	);

	\c100\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s123,
		a_delayed => s124,
		clk => \clk\,
		reset => \reset\
	);

	\init_delay_op_2_\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s120,
		a_delayed => s74,
		clk => \clk\,
		reset => \reset\
	);

	\I1_mant_tmp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s73,
		O0 => s81,
		clk => \clk\,
		reset => \reset\,
		we => s74(0)
	);

	\I0_mant_or_op_8388608_shl_c_op_s_7\: shl_c_op_s
	generic map (
		s_amount => 7,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s65,
		O0 => s67
	);

	\zero\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s40,
		O0 => s117,
		clk => \clk\,
		reset => \reset\
	);

	\I0_exp_add_op_s_I1_exp_sub_op_s_128\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s58,
		I1 => s59,
		O0 => s61
	);

	\I0_and_op_8388607\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s29,
		I1 => s22,
		O0 => s23
	);

	\I1_shr_c_op_s_23_and_op_255\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s17,
		I1 => s18,
		O0 => s19
	);

	\I0_if_eq_op_s_0_or_op_I1_if_eq_op_s_0\: or_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s33,
		I1 => s34,
		O0 => s35
	);

	\I1_if_eq_op_s_0\: if_eq_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s31,
		I1 => s32,
		O0 => s34
	);

	\O0_exp_tmp1_shl_c_op_s_23\: shl_c_op_s
	generic map (
		s_amount => 23,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s96,
		O0 => s125
	);

	\I0_shr_c_op_s_23_and_op_255\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s12,
		I1 => s13,
		O0 => s14
	);

	\I0_mant_tmp2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s79,
		O0 => s87,
		clk => \clk\,
		reset => \reset\,
		we => s80(0)
	);

	\O0_mant_tmp_shl_c_op_s_1_if_ge_op_s_0_\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s103,
		I1 => s104,
		O0 => s107
	);

	\init_delay_op_5\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s120,
		a_delayed => s100,
		clk => \clk\,
		reset => \reset\
	);

	\O0_mant_tmp_shr_c_op_s_7\: shr_c_op_s
	generic map (
		s_amount => 7,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s106,
		O0 => s109
	);

	\O0_sign_tmp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s45,
		O0 => s47,
		clk => \clk\,
		reset => \reset\,
		we => s46(0)
	);

	\O0_mant_tmp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s90,
		O0 => s106,
		clk => \clk\,
		reset => \reset\,
		we => s91(0)
	);

	\I1_mant_or_op_8388608\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s69,
		I1 => s70,
		O0 => s71
	);

	\I1_shr_c_op_s_23\: shr_c_op_s
	generic map (
		s_amount => 23,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s31,
		O0 => s17
	);

	\I1_and_op_8388607\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s31,
		I1 => s26,
		O0 => s27
	);

	\zero_tmp\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s37,
		I1 => s36,
		O0 => s39,
		Sel1 => s35,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\I0_if_eq_op_s_0\: if_eq_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s29,
		I1 => s30,
		O0 => s33
	);

	\init_delay_op_1__\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s120,
		a_delayed => s62,
		clk => \clk\,
		reset => \reset\
	);

	\O0_exp_tmp2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s61,
		O0 => s95,
		clk => \clk\,
		reset => \reset\,
		we => s62(0)
	);

	\I1_mant_or_op_8388608_shl_c_op_s_8\: shl_c_op_s
	generic map (
		s_amount => 8,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s71,
		O0 => s73
	);

	\init_delay_op_2\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s120,
		a_delayed => s68,
		clk => \clk\,
		reset => \reset\
	);

	\O0_exp_tmp1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s54,
		O0 => s96,
		clk => \clk\,
		reset => \reset\,
		we => s55(0)
	);

	\I1_mant_tmp2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s85,
		O0 => s88,
		clk => \clk\,
		reset => \reset\,
		we => s86(0)
	);

	\I0_mant_tmp_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s75,
		O0 => s76
	);

	\I0_exp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s14,
		O0 => s56,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\I0_mant_or_op_8388608\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s63,
		I1 => s64,
		O0 => s65
	);

	\c101\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s125,
		a_delayed => s126,
		clk => \clk\,
		reset => \reset\
	);

	\O0_mant\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s109,
		I1 => s108,
		O0 => s113,
		Sel1 => s107,
		clk => \clk\,
		reset => \reset\,
		we => s110(0)
	);

	\O0_exp\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s126,
		I1 => s124,
		O0 => s112,
		Sel1 => s97,
		clk => \clk\,
		reset => \reset\,
		we => s100(0)
	);

	\O0_mant_tmp_shl_c_op_s_1_\: shl_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s106,
		O0 => s103
	);

	\O0_mant_tmp_shr_c_op_s_6\: shr_c_op_s
	generic map (
		s_amount => 6,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s106,
		O0 => s108
	);

	\I0_shr_c_op_s_31\: shr_c_op_s
	generic map (
		s_amount => 31,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s29,
		O0 => s2
	);

	\I0_shr_c_op_s_23\: shr_c_op_s
	generic map (
		s_amount => 23,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s29,
		O0 => s12
	);

	\I0_mant_tmp2_mult_op_s_I1_mant_tmp2\: mult_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s87,
		I1 => s88,
		O0 => s90
	);

	\I0_sign_xor_op_I1_sign\: xor_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s41,
		I1 => s42,
		O0 => s43
	);

	\O0_sign_tmp_delay_op_2\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s47,
		a_delayed => s48,
		clk => \clk\,
		reset => \reset\
	);

	\I0_exp_add_op_s_I1_exp_\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s56,
		I1 => s57,
		O0 => s58
	);

	\I0_exp_add_op_s_I1_exp\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s56,
		I1 => s57,
		O0 => s51
	);

	\init_delay_op_3\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s120,
		a_delayed => s80,
		clk => \clk\,
		reset => \reset\
	);

	\init_delay_op_4\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s120,
		a_delayed => s91,
		clk => \clk\,
		reset => \reset\
	);

	\init_delay_op_3_\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s120,
		a_delayed => s86,
		clk => \clk\,
		reset => \reset\
	);

	\I0_mant\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s23,
		O0 => s63,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\I1_shr_c_op_s_31_and_op_1\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s7,
		I1 => s8,
		O0 => s9
	);

	\O0_mant_tmp_shl_c_op_s_1_if_ge_op_s_0\: if_ge_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map (
		I0 => s93,
		I1 => s94,
		O0 => s97
	);

	\I1_mant_tmp_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s81,
		O0 => s82
	);

	\I0_sign\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s4,
		O0 => s41,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\I0_shr_c_op_s_31_and_op_1\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s2,
		I1 => s3,
		O0 => s4
	);

	\init_delay_op_5__\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s120,
		clk => \clk\,
		reset => \reset\
	);

	\O0_sign\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		O0 => s114,
		clk => \clk\,
		reset => \reset\
	);

	\I1_mant\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s27,
		O0 => s69,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\O0_sign_or_op_O0_exp_add_op_s_O0_mant\: or_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s114,
		I1 => s115,
		O0 => s116
	);

	\init_delay_op_5_\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s120,
		a_delayed => s110,
		clk => \clk\,
		reset => \reset\
	);

	\I0_mant_tmp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s67,
		O0 => s75,
		clk => \clk\,
		reset => \reset\,
		we => s68(0)
	);

	\O0_mant_tmp_shl_c_op_s_1\: shl_c_op_s
	generic map (
		s_amount => 1,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s106,
		O0 => s93
	);

	\I1_mant_tmp_shr_c_op_s_16_and_op_65535\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s82,
		I1 => s83,
		O0 => s85
	);

	\I1_shr_c_op_s_31\: shr_c_op_s
	generic map (
		s_amount => 31,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s31,
		O0 => s7
	);

	\I0_mant_tmp_shr_c_op_s_16_and_op_65535\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s76,
		I1 => s77,
		O0 => s79
	);

	\I0_sign_xor_op_I1_sign_shl_c_op_s_31\: shl_c_op_s
	generic map (
		s_amount => 31,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s43,
		O0 => s45
	);

	\init_delay_op_1_\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s120,
		a_delayed => s55,
		clk => \clk\,
		reset => \reset\
	);

	\I0_exp_add_op_s_I1_exp_sub_op_s_127\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s51,
		I1 => s52,
		O0 => s54
	);

	\init_delay_op_1\: delay_op
	generic map (
		bits => 1,
		delay => 1
	)
	port map (
		a(0) => s120,
		a_delayed => s46,
		clk => \clk\,
		reset => \reset\
	);

	\O0_exp_add_op_s_O0_mant\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s112,
		I1 => s113,
		O0 => s115
	);

	\zero_tmp_delay_op_3\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s39,
		a_delayed => s40,
		clk => \clk\,
		reset => \reset\
	);

	\done_ok\: reg_op
	generic map (
		initial => 0,
		w_in => 1
	)
	port map (
		I0 => s121,
		O0 => s0,
		clk => \clk\,
		reset => \reset\,
		we => s122(0)
	);

	\init_delay_op_5___\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s120,
		a_delayed => s122,
		clk => \clk\,
		reset => \reset\
	);

	\O0_sign_or_op_O0_exp_add_op_s_O0_mant_and_op_zero\: and_op
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s116,
		I1 => s117,
		O0 => s119
	);

	\I1_exp\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s19,
		O0 => s57,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\I1_sign\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s9,
		O0 => s42,
		clk => \clk\,
		reset => \reset\,
		we => s120
	);

	\done\ <= s0(0);
	s36 <= conv_std_logic_vector(0, 32);
	s22 <= conv_std_logic_vector(8388607, 32);
	s26 <= conv_std_logic_vector(8388607, 32);
	s18 <= conv_std_logic_vector(255, 32);
	s32 <= conv_std_logic_vector(0, 32);
	s8 <= conv_std_logic_vector(1, 32);
	s30 <= conv_std_logic_vector(0, 32);
	s121 <= conv_std_logic_vector(1, 1);
	s3 <= conv_std_logic_vector(1, 32);
	s13 <= conv_std_logic_vector(255, 32);
	s83 <= conv_std_logic_vector(65535, 32);
	s120 <= \init\;
	s31 <= \I1\;
	s37 <= conv_std_logic_vector(-1, 32);
	s59 <= conv_std_logic_vector(128, 32);
	s104 <= conv_std_logic_vector(0, 32);
	s70 <= conv_std_logic_vector(8388608, 32);
	s77 <= conv_std_logic_vector(65535, 32);
	s64 <= conv_std_logic_vector(8388608, 32);
	s94 <= conv_std_logic_vector(0, 32);
	s52 <= conv_std_logic_vector(127, 32);
	\O0\ <= s119;
	s29 <= \I0\;

end behavior;


