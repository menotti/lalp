-- ###############################
-- Behavioral description of the NENYA Library
--
-- Revision 2000, January 27th
-- by Joao M. P. Cardoso
-- email: jmpc@acm.org
--
-- Deep revision on 2004, December 3
-- (related to the new models based on the Functional Units for Hades)
--
-- Revision 2007, September
-- by Ricardo Menotti
-- email: ricardomenotti@acm.org
--
-- Deep revision on 2009, January
-- related to the new components for aggressive loop pipelining
-- #############################

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;

--
--  DELAY
--

entity delay_op is
	generic
	(
		bits	:	integer		:=	8;
		delay	:	integer		:=	1
	);
	port
	(
		a			:	in	std_logic_vector(bits-1 downto 0);
		clk			:	in	std_logic;
		reset			:	in	std_logic;
		a_delayed	:	out	std_logic_vector(bits-1 downto 0) := (others=>'0')
	);
end delay_op;

architecture behav of delay_op is
	type intermediate is array (delay-1 downto 0) of std_logic_vector(bits-1 downto 0);
	signal int	:	intermediate;
begin
	process (clk, reset)
	begin
		if (reset = '1') then
			for i in 0 to delay-1 loop
				int(i) <= (others => '0');
			end loop;
		elsif (rising_edge(clk)) then
			int(0) <= a;
			for i in 1 to delay-1 loop
				int(i) <= int(i-1);
			end loop;
		end if;
	end process;
	a_delayed <= int(delay-1);
end behav;

--
--  DELAY STEP
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity delay_step_op is
	generic
	(
		delay	:	integer		:=	1;
		bits	:	integer		:=	8 -- max delay = 256
	);
	port
	(
		a			:	in	std_logic;
		clk			:	in	std_logic;
		reset		:	in	std_logic;
		a_delayed	:	out	std_logic := '0'
	);
end delay_step_op;

architecture behav of delay_step_op is
	signal cnt: std_logic_vector(bits-1 downto 0) := (others => '0');
begin
	process (clk, reset)
	begin
		if (reset = '1') then
			cnt <= (others => '0');
		elsif (rising_edge(clk)) then
			if (a = '1') then
				cnt <= conv_std_logic_vector(delay-1, bits);
			elsif (cnt > 0) then
				cnt <= cnt - 1;
			end if;
		end if;
	end process;
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (cnt > 0) or (a = '1') then
				a_delayed <= '1';
			else
				a_delayed <= '0';
			end if;
		end if;
	end process;
end behav;

--
-- FOR
--
library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity module_for is  
	generic (
		bits		: integer := 9;
		iterations	: integer := 256;
		steps		: integer := 1;
		w_out		: integer := 8
	);
	port (
    	clk		: in    std_logic;
    	clk_en	: in    std_logic;
	   reset	: in    std_logic;		 				
    	clear	: in    std_logic;				
    	step	: out	std_logic; 
    	done	: out	std_logic;
    	output	: out	std_logic_vector(w_out-1 downto 0) 
  	);
end module_for;

architecture behav of module_for is
	constant nsteps : integer := steps-1;
    signal output1  : std_logic_vector(bits-1 downto 0); 
	signal step1	: std_logic_vector(bits-1 downto 0);
begin
	process(clk, reset)
 	begin
		if (reset = '1') then
			done <= '0';
			step <= '0';
			--output1 <= (others => '0');
			output1 <= conv_std_logic_vector(-1, bits);
			--step1 <= conv_std_logic_vector(nsteps, bits);
			step1 <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (clear = '1') then -- initialize without reset
				--output1 <= (others => '0');
				output1 <= conv_std_logic_vector(-1, bits);
				done <= '0';
				step <= '0';
				step1 <= (others => '0');
			elsif(clk_en = '1') then -- executing
				if (step1 = 0) then
					step <= '1';
					if (signed(output1) < iterations-1) then
						output1 <= output1 + 1;
						done <= '0';
						step1 <= conv_std_logic_vector(nsteps, bits);
					else 					 -- stop
						done <= '1';
						step <= '0';
					end if;
				else
					step <= '0';
					step1 <= step1 - 1;
				end if;
			end if;
		end if;
	end process;
	output(w_out-1 downto 0) <= output1(w_out-1 downto 0);
end behav;

--
-- COUNTER WITH LOAD
--
-- possible conditions are:
-- 0	<
-- 1	<=
-- 2	>
-- 3	>=
-- 4  ==
-- 5  !=

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter is  
	generic (
		bits		: integer := 8;
		steps		: integer := 1;
		increment	: integer := 1;
		down		: integer := 0;
		condition	: integer := 1
	);
	port (
		input	: in	std_logic_vector(bits-1 downto 0);
		termination	: in	std_logic_vector(bits-1 downto 0);
    	clk		: in    std_logic;
    	clk_en	: in    std_logic := '1';
    	reset	: in    std_logic;
 		load	: in	std_logic := '0';
    	step	: out	std_logic;
    	done	: out	std_logic;
    	output	: out	std_logic_vector(bits-1 downto 0)
  	);
end counter;

architecture behav of counter is
	signal shsteps: std_logic_vector(steps-1 downto 0) := conv_std_logic_vector(1, steps);
	signal value: std_logic_vector(bits-1 downto 0) := (others => '0');
	signal init: std_logic := '1';
	signal stepi: std_logic := '0';
	signal cond: boolean;
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			shsteps <= conv_std_logic_vector(1, steps);
			value <= (others => '0');
			init <= '1';
			stepi <= '0';
		elsif (clk'event and clk = '1') then
			if clk_en = '1' then
				stepi <= shsteps(0);
				if steps /= 1 then
					shsteps <= shsteps(0) & shsteps(steps-1 downto 1); --rotate
				end if;
				if load = '1' then
					shsteps <= conv_std_logic_vector(1, steps);
					value <= input;
					init <= '1';
				else
					if shsteps(0) = '1' then
						if init = '1' then
							init <= '0';
						else
							if cond then
								if down = 1 then
									value <= value - increment;
								else
									value <= value + increment;
								end if;
							end if;
						end if;
					end if;
				end if; -- load
			end if; -- clk_en
		end if; --clk'event
	end process;
	
	done <= '0' when cond else '1';
	
	cond <= 
	value < termination when condition = 0 else
	value <= termination when condition = 1 else
	value > termination when condition = 2 else
	value >= termination when condition = 3 else
	value = termination when condition = 4 else
	value /= termination;
	
	--step <= shsteps(steps-1) and clk_en and (not load) when cond else '0';
	step <= stepi and not load when cond else '0';
		
	output <= value;
			
end behav;

--
-- multiplier with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity mult_op_s is
	generic (
		w_in1	: integer := 16;
  		w_in2	: integer := 16;
		w_out	: integer := 32
	);
	port (
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0  : out	std_logic_vector(w_out-1 downto 0) 
	);
end mult_op_s;

architecture behav of mult_op_s is

begin
  process(I0, I1)
  begin
    O0 <= conv_std_logic_vector(signed(I0)*signed(I1), w_out);
  end process;
end behav;

--
-- multiplier with unsigned operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mult_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end mult_op;

architecture behav of mult_op is

begin
  process(I0, I1)
  begin
    O0 <= conv_std_logic_vector(unsigned(I0)*unsigned(I1), w_out);
  end process;
end behav;


--
-- multiplier with signed operands and a number of pipeline stages
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity mult_op_s_p is
	generic (
		w_in1	: integer := 16;
  		w_in2	: integer := 16;
		w_out	: integer := 32;
		k: integer := 5 -- number of pipeline stages
	);
	port (
	clk	: in	std_logic;
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0  : out	std_logic_vector(w_out-1 downto 0) 
	);
end mult_op_s_p;

architecture behav of mult_op_s_p is

	type intermediate is array (k-1 downto 0) of std_logic_vector(w_out-1 downto 0);
	signal int	:	intermediate;

begin
  process(clk)
  begin
    if(clk'event and clk = '1') then
		if k=1 then
			O0 <= conv_std_logic_vector(signed(I0)*signed(I1), w_out);
		else
        int(0) <= conv_std_logic_vector(signed(I0)*signed(I1), w_out);
        for i in 1 to k-2 loop
          int(i) <= int(i-1);
        end loop;
        O0 <= int(k-2);
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

entity mult_op_p is
	generic (
		w_in1	: integer := 16;
  		w_in2	: integer := 16;
		w_out	: integer := 32;
		k: integer := 5 -- number of pipeline stages
	);
	port (
	clk	: in	std_logic;
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0  : out	std_logic_vector(w_out-1 downto 0) 
	);
end mult_op_p;

architecture behav of mult_op_p is

	type intermediate is array (k-1 downto 0) of std_logic_vector(w_out-1 downto 0);
	signal int	:	intermediate;

begin
  process(clk)
  begin
    if(clk'event and clk = '1') then
      int(0) <= conv_std_logic_vector(unsigned(I0)*unsigned(I1), w_out);
      for i in 1 to k-1 loop
        int(i) <= int(i-1);
	  end loop;
      O0 <= int(k-1);
	end if;
  end process;
end behav;

--
-- integer divider with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity div_op_s is  
  generic (w_in1  : integer := 16;
  w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);	
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end div_op_s;

architecture behav of div_op_s is

begin
        process(I0, I1)
        variable aux: std_logic_vector(2*w_in1-1 downto 0); 
        begin
          -- aux := I0 / I1;
          O0 <= aux(w_out-1 downto 0);
        end process;
end behav;


--
-- integer modulus with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity mod_op_s is  
  generic (w_in1  : integer := 16;
  w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);	
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end mod_op_s;

architecture behav of mod_op_s is

begin
        process(I0, I1)
        variable aux: std_logic_vector(2*w_in1-1 downto 0); 
        begin
          -- aux := I0 % I1;
          O0 <= aux(w_out-1 downto 0);
        end process;
end behav;


--
-- integer divider with unsigned operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity div_op is  
  generic (w_in1  : integer := 16;
  w_in2  : integer := 16;
		 w_out : integer :=16);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);	
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end div_op;

architecture behav of div_op is

begin
  process(I0, I1)
  	variable P1: std_logic_vector(w_in1 downto 0);	 
  	variable Paux1: std_logic_vector(w_in1 downto 0);	  
  	variable Aaux1: std_logic_vector(w_in1-1 downto 0);	 
  	variable Baux1: std_logic_vector(w_in1 downto 0);
	variable P2: std_logic_vector(w_in2 downto 0);	 
  	variable Paux2: std_logic_vector(w_in2 downto 0);	  
  	variable Aaux2: std_logic_vector(w_in2-1 downto 0);	 
  	variable Baux2: std_logic_vector(w_in2 downto 0);
  begin
  				 if(w_in1 >= w_in2) then
  			Aaux1 := I0;
			Baux1 := '0' & I1;

  			P1:= (others => '0');

			for i in 1 to w_in1 loop
				P1 := P1(w_in1-1 downto 0) & Aaux1(w_in1-1);
		
				Paux1 := P1 - Baux1;

				if(Paux1(w_in1) = '1') then		-- resultado eh negativo?
					Aaux1 := Aaux1(w_in1-2 downto 0) & '0';
				else				 
					Aaux1 := Aaux1(w_in1-2 downto 0) & '1';
					P1 := Paux1;
				end if;

			end loop;

			O0 <= P1(w_out-1 downto 0);
			else
			Aaux2 := I0;
			Baux2 := '0' & I1;

  			P2:= (others => '0');

			for i in 1 to w_in2 loop
				P2 := P2(w_in2-1 downto 0) & Aaux2(w_in2-1);
		
				Paux2 := P2 - Baux2;

				if(Paux2(w_in2) = '1') then		-- resultado eh negativo?
					Aaux2 := Aaux2(w_in2-2 downto 0) & '0';
				else				 
					Aaux2 := Aaux2(w_in2-2 downto 0) & '1';
					P2 := Paux2;
				end if;

			end loop;

			O0 <= P2(w_out-1 downto 0);
			end if;
  end process;
end behav;

--
-- sub with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity sub_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0);
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end sub_op_s;

architecture behav of sub_op_s is

begin
  process(I0, I1)
  begin										
    O0 <= conv_std_logic_vector(signed(I0(w_in1-1)&I0)-signed(I1(w_in2-1)&I1), w_out);
  end process;
end behav;

--
-- sub with unsigned operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sub_op is  
  generic (w_in1  : integer := 16;
		 w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);
     I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0) 
  );
end sub_op;

architecture behav of sub_op is

begin
        
  process(I0, I1)
  begin
    
    O0 <= conv_std_logic_vector(unsigned(I0) - unsigned(I1), w_out);
    
  end process;
end behav;

--
-- adder with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
--use IEEE.std_logic_signed.all;

entity add_op_s is  
  generic (w_in1  : integer := 16;
  		 w_in2  : integer := 16;
		 w_out : integer :=32);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                : out   std_logic_vector(w_out-1 downto 0) 
  );
end add_op_s;

architecture behav of add_op_s is

begin
  process(I0, I1)
  begin
    if(w_in1 > 1 and w_in2 > 1) then
      O0 <= conv_std_logic_vector(signed(I0(w_in1-1)&I0)+signed(I1(w_in2-1)&I1), w_out);
    elsif(w_in2 = 1) then
      O0 <= conv_std_logic_vector(signed(I0(w_in1-1)&I0)+signed(I1), w_out);
    elsif(w_in1 = 1) then
      O0 <= conv_std_logic_vector(signed(I0)+signed(I1(w_in2-1)&I1), w_out);
    else
      O0 <= conv_std_logic_vector(signed(I0)+signed(I1), w_out);
    end if;
  end process;
end behav;

--
-- adder with unsigned operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity add_op is  
  generic (w_in1  : integer := 8;
  		 w_in2  : integer := 8;
		 w_out : integer :=16);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0);
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                : out   std_logic_vector(w_out-1 downto 0) 
  );
end add_op;

architecture behav of add_op is

begin
  process(I0, I1)
  begin
    O0 <= conv_std_logic_vector(unsigned('0'&I0)+unsigned('0'&I1), w_out);
  end process;
end behav;

--
-- Incrementer by one
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity inc_op is  
  generic (w_in  : integer := 16;
		 w_out : integer :=16);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0              : out   std_logic_vector(w_out-1 downto 0) 
  );
end inc_op;

architecture behav of inc_op is

begin
  process(I0) 
  begin
    O0 <= conv_std_logic_vector(unsigned(I0)+1, w_out);
  end process;
end behav;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity inc_op_s is  
  generic (w_in  : integer := 16;
		 w_out : integer :=16);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0              : out   std_logic_vector(w_out-1 downto 0) 
  );
end inc_op_s;

architecture behav of inc_op_s is

begin
  process(I0) 
  begin
    
    O0 <= conv_std_logic_vector(signed(I0)+1, w_out);
  
  end process;
end behav;

--
-- registered add with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity add_reg_op_s is
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
	    Sel1	: in	std_logic_vector(0 downto 0) := "1";
    	I0	: in	std_logic_vector(w_in1-1 downto 0);
    	I1	: in	std_logic_vector(w_in2-1 downto 0);
    	O0	: out	std_logic_vector(w_out-1 downto 0) 
  	);
end add_reg_op_s;

architecture behav of add_reg_op_s is

begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_out);
	  	elsif (clk'event and clk = '1') then
			if (we = '1') then
				if (Sel1(0) = '1') then
					O0 <= conv_std_logic_vector(signed(I0(w_in1-1)&I0)+signed(I1(w_in2-1)&I1), w_out);
				else
					O0 <= I0;
				end if;
	  		end if;
		end if;
  	end process;
end behav;


--
-- registered sub with signed operands
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity sub_reg_op_s is  
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
end sub_reg_op_s;

architecture behav of sub_reg_op_s is

begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_out);
		elsif (clk'event and clk = '1') then
			if (we = '1') then
				if (Sel1(0) = '1') then
					O0 <= conv_std_logic_vector(signed(I0(w_in1-1)&I0)-signed(I1(w_in2-1)&I1), w_out);
				else
					O0 <= I0;
				end if;
			end if;
		end if;
	end process;
end behav;


--
-- AND
--
library IEEE;
use IEEE.std_logic_1164.all;     
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;  

entity and_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
		w_out  : integer := 16);
  port (
    I0            : in    std_logic_vector(w_in1-1 downto 0);  
    I1            : in    std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0) 
  );
end and_op;

architecture behav of and_op is

begin
  process(I0, I1)
  begin
    O0 <= conv_std_logic_vector(unsigned(I0), w_out) AND conv_std_logic_vector(unsigned(I1), w_out);
  end process;
end behav;

--
-- OR
--
library IEEE;
use IEEE.std_logic_1164.all;    
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity or_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
		w_out  : integer := 16);
  port (
    I0            : in    std_logic_vector(w_in1-1 downto 0);  
    I1            : in    std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0) 
  );
end or_op;

architecture behav of or_op is

begin
  process(I0, I1)
  begin
    
  O0 <= conv_std_logic_vector(unsigned(I0), w_out) OR conv_std_logic_vector(unsigned(I1), w_out);
        end process;
end behav;

--
-- XOR
--
library IEEE;
use IEEE.std_logic_1164.all;	 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity xor_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
		w_out  : integer := 16);
  port (
    I0            : in    std_logic_vector(w_in1-1 downto 0);  
    I1            : in    std_logic_vector(w_in2-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0) 
  );
end xor_op;

architecture behav of xor_op is

begin
  process(I0, I1)
    variable aux2, aux1 : std_logic_vector(w_out-1 downto 0);
  begin
    
    O0 <= conv_std_logic_vector(unsigned(I0), w_out) XOR conv_std_logic_vector(unsigned(I1), w_out);
  end process;
end behav;

--
-- NOT
--
library IEEE;
use IEEE.std_logic_1164.all;     
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;  

entity not_op is  
  generic (w_in  : integer := 16;
		w_out  : integer := 16);
  port (
    I0            : in    std_logic_vector(w_in-1 downto 0);  
    O0             : out   std_logic_vector(w_out-1 downto 0) 
  );
end not_op;

architecture behav of not_op is

begin
  process(I0)
  begin
    O0 <= NOT conv_std_logic_vector(unsigned(I0), w_out);
  end process;
end behav;

--
-- NONE
--
library IEEE;
use IEEE.std_logic_1164.all;     
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;  

entity none_op is  
  generic (w_in  : integer := 16;
		w_out  : integer := 16);
  port (
    I0            : in    std_logic_vector(w_in-1 downto 0);  
    O0             : out   std_logic_vector(w_out-1 downto 0) 
  );
end none_op;

architecture behav of none_op is

begin
    O0 <= I0;
end behav;

--
-- NEG
--
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity neg_op is  
	generic (
		w_in	: integer	:= 16;
		w_out	: integer	:= 16
	);
	port (
    	I0	: in	std_logic_vector(w_in-1 downto 0);
		O0	: out	std_logic_vector(w_out-1 downto 0)
	);
end neg_op;

architecture behav of neg_op is

begin
  process(I0)
    begin  
    O0 <= conv_std_logic_vector(-conv_integer(unsigned(I0)), w_out);
  end process;
end behav;


--
-- NEG
--
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity neg_op_s is  
	generic (
		w_in	: integer	:= 16;
		w_out	: integer	:= 16
	);
	port (
		I0	: in	std_logic_vector(w_in-1 downto 0);
		O0	: out	std_logic_vector(w_out-1 downto 0) 
	);
end neg_op_s;

architecture behav of neg_op_s is

begin
  process(I0)
  begin
    
     O0 <= conv_std_logic_vector(-conv_integer(SXT(I0,w_out)), w_out);
  end process;
end behav;

--
-- EQ
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_eq_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 16);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0); 
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_eq_op;

architecture behav of if_eq_op is

begin
  process(I0, I1)
  begin
    
    if(unsigned(I0) = unsigned(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
    
  end process;
end behav;

--
-- EQ
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_eq_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0); 
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0)
  );
end if_eq_op_s;

architecture behav of if_eq_op_s is

begin
  process(I0, I1)
  begin
    
    if(signed(I0) = signed(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- NEQ
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_ne_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0); 
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_ne_op;

architecture behav of if_ne_op is

begin
  process(I0, I1)
  begin
    if(unsigned(I0) = unsigned(I1)) then
      O0(0) <= '0';
    else
      O0(0) <= '1';
    end if;
  end process;
end behav;


--
-- NEQ
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_ne_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in1-1 downto 0); 
    I1             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0)
  );
end if_ne_op_s;

architecture behav of if_ne_op_s is

begin
  process(I0, I1)
  begin
    if(signed(I0) = signed(I1)) then
      O0(0) <= '0';
    else
      O0(0) <= '1';
    end if;
  end process;
end behav;

--
-- GEQ withsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity if_ge_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0);
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_ge_op_s;

architecture behav of if_ge_op_s is

begin
  process(I0, I1)
  begin
    if(signed(I0) >= signed(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GTH withsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity if_gt_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0); 
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_gt_op_s;

architecture behav of if_gt_op_s is

begin
        process(I0, I1)
        begin
		if(signed(I0) > signed(I1)) then
            O0(0) <= '1';
          else
            O0(0) <= '0';
          end if;
        end process;
end behav;

--
-- LEQ withunsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_le_op_s is  
  generic (w_in1  : integer := 16; 
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0);
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(w_out-1 downto 0)
  );
end if_le_op_s;

architecture behav of if_le_op_s is

begin
  process(I0, I1)
  begin  
    if(signed(I0) <= signed(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;
--
-- GEQ withunsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_ge_op is  
  generic (w_in1  : integer := 16; 
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0);
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_ge_op;

architecture behav of if_ge_op is

begin
  process(I0, I1)
  begin  
    if(unsigned(I0) >= unsigned(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GTH withunsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_gt_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	            : in    std_logic_vector(w_in1-1 downto 0); 
    I1	            : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_gt_op;

architecture behav of if_gt_op is

begin
  process(I0, I1)
  begin
    if(unsigned(I0) > unsigned(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- LTH withunsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;	  
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity if_lt_op is  
  generic (w_in1  : integer := 16;
  		w_in2  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	           : in    std_logic_vector(w_in1-1 downto 0);	 
    I1	           : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_lt_op;

architecture behav of if_lt_op is

begin
  process(I0, I1)
  begin
    if(unsigned(I0) < unsigned(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- LTH withsigned 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity if_lt_op_s is  
  generic (w_in1  : integer := 16;
  		w_in2 : integer := 16;
  		w_out  : integer := 1);
  port (
    I0	             : in    std_logic_vector(w_in1-1 downto 0);
    I1	             : in    std_logic_vector(w_in2-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end if_lt_op_s;

architecture behav of if_lt_op_s is

begin
  process(I0, I1)
  begin
    
    if(signed(I0) < signed(I1)) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- REGisTER with a load signal synchronous
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity reg_op is  
  generic (
  	w_in  : integer := 16;
  	initial: integer := 0
  );
  port (
    clk             : in    std_logic;	 
    reset             : in    std_logic;	 
    we            : in    std_logic := '1';
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(w_in-1 downto 0) 
  );
end reg_op;

architecture behav of reg_op is
  
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_in);
		elsif (clk'event and clk = '1') then
			if(we = '1') then
				O0 <= I0;
			end if;
		end if;
	end process;
end behav;


--
-- REGisTER with a load signal synchronous and 2 inputs
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity reg_mux_op is  
  generic (
  	w_in  : integer := 16;
  	initial	: integer := 0
  );
  port (
    clk             : in    std_logic;	 
    reset             : in    std_logic;	 
    we            : in    std_logic := '1';
    Sel1            : in    std_logic_vector(0 downto 0);
    I0             : in    std_logic_vector(w_in-1 downto 0);
    I1             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(w_in-1 downto 0) 
  );
end reg_mux_op;

architecture behav of reg_mux_op is

begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= conv_std_logic_vector(initial, w_in);
		elsif (clk'event and clk = '1') then
			if(we = '1') then
				if(Sel1(0) = '0') then
					O0 <= I0;
				else
					O0 <= I1;
				end if;
			end if;
		end if;
	end process;
end behav;

--
-- REGisTER with a range check 
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity range_op_s is  
  generic (
  	w_in  : integer := 16;
  	min	: integer := 0;
  	max : integer := 255	
  );
  port (
    clk             : in    std_logic;	 
    reset             : in    std_logic;	 
    we            : in    std_logic := '1';
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(w_in-1 downto 0) 
  );
end range_op_s;

architecture behav of range_op_s is
  
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			O0 <= (others => '0');
		elsif (clk'event and clk = '1') then
			if(we = '1') then
				if (signed(I0)<min) then
					O0 <= conv_std_logic_vector(min, w_in);
				elsif (signed(I0)>max) then
					O0 <= conv_std_logic_vector(max, w_in);
				else
					O0 <= I0;
				end if;
			end if;
		end if;
	end process;
end behav;




--
-- LTH ZERO with signed  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity lt_op is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0) 
  );
end lt_op;

architecture behav of lt_op is
begin
  process(I0)
  begin
    if(unsigned(I0) < 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- LTH ZERO with signed  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity lt_op_s is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0) 
  );
end lt_op_s;

architecture behav of lt_op_s is

begin
  process(I0)
  begin
    if(signed(I0) < 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GEQ ZERO with signed  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity ge_op_s is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end ge_op_s;

architecture behav of ge_op_s is

begin
  process(I0)
  begin
    if(signed(I0) >= 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GEQ ZERO with unsigned  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ge_op is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end ge_op;

architecture behav of ge_op is

begin
  process(I0)
  begin
    if(unsigned(I0) >= 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GTHAN ZERO with signed  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity gt_op_s is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0             : out   std_logic_vector(w_out-1 downto 0)
  );
end gt_op_s;

architecture behav of gt_op_s is

begin
  process(I0)
  begin
    if(signed(I0) > 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- GTHAN ZERO with unsigned  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity gt_op is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end gt_op;

architecture behav of gt_op is

begin
  process(I0)
  begin
    if(unsigned(I0) > 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- EQ ZERO  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity eq_op is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end eq_op;

architecture behav of eq_op is

begin
  process(I0)
  begin
    if(unsigned(I0) = 0) then
      O0(0) <= '1';
    else
      O0(0) <= '0';
    end if;
  end process;
end behav;

--
-- NEQ ZERO  
--
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity ne_op is  
  generic (w_in  : integer := 16;
  		w_out  : integer := 1);
  port (
    I0             : in    std_logic_vector(w_in-1 downto 0);
    O0                  : out   std_logic_vector(0 downto 0)
  );
end ne_op;

architecture behav of ne_op is

begin
  process(I0)
  begin
    if(unsigned(I0) = 0) then
      O0(0) <= '0';
    else
      O0(0) <= '1';
    end if;
  end process;
end behav;


--######################## INTERNAL BlockRam ###################
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity block_ram is
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
end block_ram;

architecture rtl of block_ram is
  
	constant mem_depth : integer := 2**address_width;
  	type ram_type is array (mem_depth-1 downto 0)
    of std_logic_vector (data_width-1 downto 0);

  	signal read_a : std_logic_vector(address_width-1 downto 0);
 	signal RAM : ram_type;

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

--######################## EXTERNAL SRAM ###################
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_unsigned.ALL;
		
use std.textio.all;								 
--Quartus use IEEE.std_logic_textio.all;


entity ext_mem is  
  	generic (
  		width  : integer := 8;	 -- number of bits per memory word
  		w_address  : integer := 2;	-- number of bits of the address line
  	--	size:      integer :=  4;  -- number of memory words
		download_filename: string := "sram_load.dat";  -- name of the download source file
		dump_filename: string := "sram_dump.dat";  -- name of the dump file with memory contents
		init_zero: boolean := FALSE -- if true initialize memory to zero else read data from file
	);

  	port (
    	clock            : in    std_logic;
	nCS            : in    std_logic_vector(0 downto 0);-- chip select inverted
    	--RW            : in    std_logic;
    	Data_in             : in    std_logic_vector(width-1 downto 0);
    	Data_out             : out    std_logic_vector(width-1 downto 0);
    	Address             : in    std_logic_vector(w_address-1 downto 0);
    	nWE            : in    std_logic_vector(0 downto 0)
  	);

end ext_mem;

-- behavioral description for VHDL simulation
architecture behav_for_sim of ext_mem is

  constant size: integer := 2**w_address;
  
  constant dump_start:  natural := 0;     -- Written to the dump-file are the memory words from memory address 

  constant dump_end:  natural := size-1; 
  constant trace_ram_load: boolean:=FALSE;

  SIGNAL read_data: std_logic_vector(width-1 downto 0); 
	  
begin
  
  process(Address, Data_in, nCS, nWE)

    CONSTANT low_address: natural := 0;
    CONSTANT high_address: natural := size -1; 
    
    TYPE memory_array is
      ARRAY (natural RANGE low_address to high_address) of std_logic_vector(width-1  downto 0);
    
    VARIABLE mem: memory_array;



    --
    PROCEDURE power_up (mem: inout memory_array; clear: boolean) is
      
      VARIABLE init_value: std_logic;

     begin

      if clear THEN
        init_value := '0';
        write(output, string'("Initializing SRAM with zero ...") );
      ELSE
        init_value := 'X'; 
      end if;
      FOR add IN low_address to high_address LOOP
        FOR j IN (width-1) downto 0 LOOP
          mem(add)(j) := init_value;
        end LOOP;
      end LOOP; 

    end power_up;

	PROCEDURE load (mem: INOUT memory_array; download_filename: IN string) is

      FILE source : text open read_mode is download_filename;
      VARIABLE inline, outline : line;
      VARIABLE add: natural;
      VARIABLE c : character;
      VARIABLE source_line_nr: integer := 1;
      VARIABLE init_value: std_logic := 'U';

     begin
      write(output, string'("Loading SRAM from file ") & download_filename & string'(" ... ") );
      WHILE NOT endfile(source) LOOP
        readline(source, inline);
        read(inline, add);
        read(inline, c); 
        if (c /= ' ') THEN
          write(outline, string'("Syntax error in file '"));
          write(outline, download_filename);
          write(outline,  string'("', line "));
          write(outline, source_line_nr);
          writeline(output, outline);
          ASSERT FALSE
          REport "RAM load aborted."
          SEVERITY FAILURE;
        end if;
        FOR i IN (width -1) downto 0 LOOP
          read(inline, c);
	  if (c = '1') THEN
            mem(add)(i) := '1';
          ELSE
            if (c /= '0') THEN
              write(outline, string'("-W- Invalid character '"));
              write(outline, c);
              write(outline, string'("' in Bitstring in '"));
              write(outline, download_filename);
              write(outline, '(');
              write(outline, source_line_nr);
              write(outline, string'(") is set to '0'"));
              writeline(output, outline);
            end if;
            mem(add)(i) := '0';
          end if;
        end LOOP;
        if (trace_ram_load) THEN
          write(outline, string'("RAM["));
          write(outline, add);
          write(outline, string'("] :=  "));
--Quartus           write(outline, mem(add));
          writeline(output, outline );
        end if;
        source_line_nr := source_line_nr +1;

      end LOOP; -- WHILE

    end load;  -- PROCEDURE

	 PROCEDURE do_dump (mem: INOUT memory_array; 
                       dump_start, dump_end: IN natural; 
                       dump_filename: IN string) is

      FILE dest : text open write_mode is  dump_filename;
      VARIABLE l : line;
      VARIABLE c : character;

     begin
		write(output, string'("Dumping SRAM to file ") & dump_filename & string'(" ... ") );
      if (dump_start > dump_end)  OR (dump_end >= size) THEN
        ASSERT FALSE
        REport "Invalid addresses for memory dump. Cancelled."
        SEVERITY ERROR;
      ELSE
        FOR add IN dump_start to dump_end LOOP
          write(l, add);
          write(l, ' ');
          FOR i IN (width-1) downto 0 LOOP
--Quartus             write(l, mem(add)(i));
          end LOOP;
          writeline(dest, l);
        end LOOP;
      end if;

    end do_dump;  -- PROCEDURE
      
    variable wasWrite: boolean := FALSE; 
    variable wasLOADED: boolean := FALSE;

--      FILE test : text open write_mode is "lixo.txt";
  --    VARIABLE outline : line;
  --    FILE test1 : text open write_mode is "dados.txt";
   --   VARIABLE outline1 : line;
    begin
      if(nCS = "1") then -- CHIP not selected: for now we just read data to
        -- RAM or dump data to file
	
        if(wasWrite) then
          do_dump(mem, dump_start, dump_end, dump_filename);
          wasWrite := FALSE;
        else
          if(wasLOADED=FALSE) then  -- to LOAD initial
                                    -- data to RAM only once
            if(init_zero) then
              power_up(mem, init_zero);
            else
              load(mem, download_filename);
            end if;
                      
            wasLOADED := TRUE;
            
          end if;
        end if;

      elsif(nCS = "0") then   -- CHIP is selected
        
        if(nWE = "0")then       
          wasWrite := TRUE; -- for dumping
          
          mem(conv_integer(Address)) := Data_in;

          
          --write(outline1, conv_integer(Address));
          --write(outline1, conv_integer(Data_in));
          --write(outline1, Data_in);
          --writeline(test1, outline1);
       
        ELSif(nWE = "1") THEN
          
          --write(outline, conv_integer(Address));
          --writeline(test, outline);
          
          read_data <= mem(conv_integer(Address));
          ELSE
             ASSERT FALSE
          REport "nWE in RAM with unknown value!."
          SEVERITY FAILURE;
        end if;
        
      end if;

    end process;

    Data_out <= read_data;

end behav_for_sim;

--######################## OLD MEM_OP ###################
--
-- MACRO MEMORY ACCESS
--
--library  IEEE;
--use IEEE.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--
--entity mem_op is  
--  generic (w_in  : integer := 16;
--  w_address  : integer := 16);
--  port (
--    clock            : in    std_logic;
--    RW            : in    std_logic;
--    Data_in             : in    std_logic_vector(w_in-1 downto 0);
--    Data_out             : out    std_logic_vector(w_in-1 downto 0);
--    Address             : in    std_logic_vector(w_address-1 downto 0);
--    Data_bus             : inout    std_logic_vector(w_in-1 downto 0);
--    Address_bus         : out    std_logic_vector(w_address-1 downto 0);
--    WE            : out    std_logic;
--    Store            : in    std_logic
--  );
----attribute xc_loc of DATAIO_0: signal is "P3";
--end mem_op;
--
--architecture behav of mem_op is
--
----attribute xc_loc of DATAIO_0: label is "P3";
-- signal  Data            : std_logic_vector(w_in-1 downto 0);
--  signal  we_aux            : std_logic;
--  
--begin
--  
--  process(clock, Address, RW)
--    begin
--      if (clock'event AND clock = '1') then	
--        Address_bus <= Address;
--        we_aux <= RW;
--      end  if;
--  end process;
--
--  process(clock, RW, Data_in)
--    begin
--      if (clock'event AND clock = '1') then
--        if (RW = '0') then
--          Data <= Data_in;
--        end if;
--      end  if;
--  end process;
--
--  WE <= we_aux;
--  
--  process(we_aux, Data)
--    begin
--      if (we_aux = '1') then
--        Data_bus <= (others => 'Z');
--      ELSif (we_aux = '0') then
--        Data_bus <= (others => 'Z');
--        Data_bus <= Data;
--      else
--        Data_bus <= (others => 'Z');
--      end  if;
--  end process;
--
--  Data_out <= Data_bus;
--
--end behav;
--########################################################
--architecture behav of mem_op is

--type mem_type is array (2**(w_address-1) downto 0) of std_logic_vector (w_in-1 downto 0);
--signal mem: mem_type;

--signal read_address : std_logic_vector(w_address-1 downto 0);

--begin
--  process (clock)
--    begin
--      if (clock'event AND clock = '1') then	
--        read_address <= Address;
--        if (WE = '1') then
--          mem(conv_integer(read_address)) <= Data_in;
--        end if;
--      end  if;
--  end process;

--  Data_out <= mem(conv_integer(read_address));

--end behav;

--
-- MULTIPLEXER 2:1
--
library  IEEE;
use IEEE.std_logic_1164.all;

entity mux_op is  
  generic (w_in  : integer := 16);
  port (
    I0, I1            : in    std_logic_vector(w_in-1 downto 0);
    Sel1            : in    std_logic_vector(0 downto 0);
    O0            : out    std_logic_vector(w_in-1 downto 0)
  );
end mux_op;

architecture behav of mux_op is

begin
  process(Sel1, I0, I1)
  begin
    if(Sel1(0) = '0') then
      O0 <= I0;
    else
      O0 <= I1;
    end if;
  end process;
end behav;

--
-- MULTIPLEXER M:1
--
library  IEEE;
use IEEE.std_logic_1164.all;

entity mux_m_op is  
	generic (
		w_in	: integer := 32;
		N_ops	: integer := 32;
		N_sels: integer := 31
	);
	port (
		I0	: in	std_logic_vector((w_in*N_ops)-1 downto 0);
		Sel: in	std_logic_vector(N_sels-1 downto 0);
		O0	: out	std_logic_vector(w_in-1 downto 0)
	);
end mux_m_op;

architecture behav of mux_m_op is

begin
	process(I0, Sel)
		variable O_aux : std_logic_vector(w_in-1 downto 0);
	begin
	   -- by default de output is the first input
		O_aux := (others => '-');
		for i in N_ops downto 1 LOOP
			if (N_sels = N_ops -1) AND (i = N_ops) THEN
				O_aux := I0(N_ops*w_in-1 downto (N_ops-1)*w_in);
			ELSE
				if (Sel(i-1) = '1') THEN
					O_aux := I0(i*w_in-1 downto (i-1)*w_in);
				end if;
			end if;
		end LOOP;
		O0 <= O_aux;
	end process;
end behav;

--
-- SHifT left
--
library  IEEE;
use IEEE.std_logic_1164.all;	
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shl_op is  
  	generic (
		w_in1 : integer := 16;
  		w_in2 : integer := 4;
  		w_out : integer := 32
	);
 	port (
    		I0 : in std_logic_vector(w_in1-1 downto 0); 
    		I1 : in std_logic_vector(w_in2-1 downto 0); 	--I1 replaces Amount
    		O0 : out std_logic_vector(w_out-1 downto 0)
  	);
end shl_op;

architecture behav of shl_op is

function maximum(L, R: integer) return integer is
    begin
        if L > R then
            return L;
        else
            return R;
        end if;
    end;

begin
	process(I0, I1)
        begin
          O0 <= conv_std_logic_vector(SHL(unsigned(conv_std_logic_vector(unsigned(I0), maximum(w_in1, w_out))), unsigned(I1)), w_out);
        end process;
end behav;

 --
-- SHifT left by constant
--
library  IEEE;
use IEEE.std_logic_1164.all;	
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shl_c_op is  
  	generic (
		w_in1 : integer := 16;
  		w_out : integer := 20;
  		s_amount : integer := 4
	);
 	port (
    		I0 : in std_logic_vector(w_in1-1 downto 0); 
    		O0 : out std_logic_vector(w_out-1 downto 0)
  	);
end shl_c_op;

architecture behav of shl_c_op is

--function maximum(L, R: integer) return integer is
--    begin
--        if L > R then
--            return L;
--        else
--            return R;
--        end if;
--    end;

begin
	process(I0)
        begin
          --O0 <= conv_std_logic_vector(SHL(unsigned(conv_std_logic_vector(unsigned(I0), maximum(w_in1, w_out))), conv_unsigned(s_amount,w_out)), w_out);
	      O0 <= conv_std_logic_vector(SHL(unsigned(I0), conv_unsigned(s_amount,w_out)), w_out);
        end process;
end behav;

--
-- SHifT Right
--
library  IEEE;
use IEEE.std_logic_1164.all;	
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shr_op is  
	generic (
		w_in1 : integer := 16;
  		w_in2 : integer := 4;
  		w_out : integer := 16
	);
 	port (
    		I0 : in std_logic_vector(w_in1-1 downto 0); 
    		I1 : in std_logic_vector(w_in2-1 downto 0); 	 --I1 replaces Amount
    		O0 : out std_logic_vector(w_out-1 downto 0)
  	);
end shr_op;

architecture behav of shr_op is
begin
  process(I0, I1)
   begin
     O0 <= conv_std_logic_vector(SHR(unsigned(I0), unsigned(I1)), w_out);
   end process;
end behav;

--
-- SHifT Right by constant
--
library  IEEE;
use IEEE.std_logic_1164.all;	
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shr_c_op is  
	generic (
		w_in1	: integer := 16;
  		w_out	: integer := 15;  
  		s_amount	: integer := 1
	);
 	port (
		I0 : in	std_logic_vector(w_in1-1 downto 0);
		O0 : out	std_logic_vector(w_out-1 downto 0)
  	);
end shr_c_op;

architecture behav of shr_c_op is
begin
  process(I0)
   begin
     O0 <= conv_std_logic_vector(SHR(unsigned(I0), conv_unsigned(s_amount,w_out)), w_out);
   end process;
end behav;

--
-- SHifT Right signed 
--
library  IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity shr_op_s is  
  generic (w_in1  : integer := 16;
  w_in2  : integer := 4; 
  w_out : integer := 16);
  port (
    I0           : in    std_logic_vector(w_in1-1 downto 0);  
    I1       : in    std_logic_vector(w_in2-1 downto 0); 	  -- amount
    O0            : out    std_logic_vector(w_out-1 downto 0)
  );
end shr_op_s;

architecture behav of shr_op_s is

begin
  process(I0, I1)
  begin
     O0 <= conv_std_logic_vector(SHR(signed(I0), unsigned(I1)), w_out);
  end process;
end behav;


		--
-- SHifT Right signed by constant
--
library  IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity shr_c_op_s is  
  generic (w_in1  : integer := 16;
  				w_out : integer := 16;
  				s_amount  : integer := 4);
  port (
    I0           : in    std_logic_vector(w_in1-1 downto 0);  
    O0            : out    std_logic_vector(w_out-1 downto 0)
  );
end shr_c_op_s;

architecture behav of shr_c_op_s is

begin
  process(I0)
  begin
     O0 <= conv_std_logic_vector(SHR(signed(I0), conv_unsigned(s_amount,w_out)), w_out);
  end process;
end behav;

		--
-- SHifT Left signed by constant
--
library  IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity shl_c_op_s is  
  generic (w_in1  : integer := 16;
  				w_out : integer := 16;
  				s_amount  : integer := 4);
  port (
    I0           : in    std_logic_vector(w_in1-1 downto 0);  
    O0            : out    std_logic_vector(w_out-1 downto 0)
  );
end shl_c_op_s;

architecture behav of shl_c_op_s is

begin
  process(I0)
  begin
     O0 <= conv_std_logic_vector(SHL(signed(I0), conv_unsigned(s_amount,w_out)), w_out);
  end process;
end behav;

--
-- ASSIGN 
--
library  IEEE;
use IEEE.std_logic_1164.all;	
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity assign is  
  generic (w_in  : integer := 23;
  		w_out : integer := 16;
  		sign  : BOOLEAN := FALSE);
  port (
    I0           : in    std_logic_vector(w_in-1 downto 0);
    O0       : out    std_logic_vector(w_out-1 downto 0)
  );
end assign;

architecture behav of assign is

begin
  process(I0)
  begin
    if(sign = TRUE) then
    O0 <= conv_std_logic_vector(signed(I0), w_out);
    else
    O0 <= conv_std_logic_vector(unsigned(I0), w_out);
    end if;
  end process;
end behav;


