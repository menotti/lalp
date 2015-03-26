library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end dotprod; 

architecture behavior of dotprod is 

component add_reg_op_s 
generic ( 
        w_in1	: integer := 16; 
        w_in2	: integer := 16; 
        w_out	: integer := 32; 
        initial	: integer := 0
); 
port ( 
        clk         : in	std_logic; 
        reset       : in	std_logic; 
        we          : in	std_logic := '1'; 
        Sel1        : in	std_logic_vector(0 downto 0) := "1"; 
        I0          : in	std_logic_vector(w_in1-1 downto 0); 
        I1          : in	std_logic_vector(w_in2-1 downto 0); 
        O0          : out	std_logic_vector(w_out-1 downto 0) 
); 
end component; 

component block_ram_a 
generic ( 
        data_width          : integer := 8; 
        address_width	: integer := 8 
); 
port ( 
        clk                 : in	std_logic; 
        we                  : in	std_logic := '0'; 
        oe                  : in	std_logic := '1'; 
        address             : in	std_logic_vector(address_width-1 downto 0); 
        data_in             : in	std_logic_vector(data_width-1 downto 0) := (others => '0'); 
        data_out            : out	std_logic_vector(data_width-1 downto 0) 
); 
end component; 

component block_ram_b 
generic ( 
        data_width          : integer := 8; 
        address_width	: integer := 8 
); 
port ( 
        clk                 : in	std_logic; 
        we                  : in	std_logic := '0'; 
        oe                  : in	std_logic := '1'; 
        address             : in	std_logic_vector(address_width-1 downto 0); 
        data_in             : in	std_logic_vector(data_width-1 downto 0) := (others => '0'); 
        data_out            : out	std_logic_vector(data_width-1 downto 0) 
); 
end component; 

component counter 
generic (
        bits		: integer := 8;
        steps		: integer := 1;
        increment           : integer := 1;
        down                : integer := 0;
        condition           : integer := 0
);
port (
        input		: in	std_logic_vector(bits-1 downto 0);
        termination         : in	std_logic_vector(bits-1 downto 0);
        clk                 : in	std_logic;
        clk_en		: in	std_logic := '1';
        reset		: in	std_logic;
        load		: in	std_logic := '0';
        step		: out	std_logic;
        done		: out	std_logic;
        output		: out	std_logic_vector(bits-1 downto 0)
); 
end component; 

component delay_op 
generic ( 
        bits        : integer := 8; 
        delay       : integer := 1 
); 
port ( 
        a		: in	std_logic_vector(bits-1 downto 0); 
        clk		: in	std_logic; 
        reset	: in	std_logic; 
        a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0') 
); 
end component; 

component mult_op_s 
generic ( 
        w_in1	: integer := 8; 
        w_in2	: integer := 8; 
        w_out	: integer := 16 
); 
port ( 
        I0          : in	std_logic_vector(w_in1-1 downto 0); 
        I1          : in	std_logic_vector(w_in2-1 downto 0); 
        O0          : out	std_logic_vector(w_out-1 downto 0) 
); 
end component; 

signal s1	: std_logic_vector(31 downto 0); 
signal s2	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic; 
signal s9	: std_logic_vector(0 downto 0); 
signal s10	: std_logic; 
signal s11	: std_logic; 
signal s12	: std_logic_vector(0 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 

begin 

\i\: counter
generic map ( 
	bits => 32,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 1
)
port map ( 
	clk => \clk\,
	clk_en => s10,
	done => s11,
	input => s7,
	output => s1,
	reset => \reset\,
	step => s8,
	termination => s6
);

\sum\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s13,
	I1 => s2,
	O0 => s13,
	clk => \clk\,
	reset => \reset\,
	we => s9(0)
);

\a_mult_op_s_b\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s4,
	I1 => s5,
	O0 => s2
);

\a\: block_ram_a
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address(10 downto 0) => s1(10 downto 0),
	clk => \clk\,
	data_out => s4
);

\b\: block_ram_b
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address(10 downto 0) => s1(10 downto 0),
	clk => \clk\,
	data_out => s5
);

\dly_16\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s8,
	a_delayed => s9,
	clk => \clk\,
	reset => \reset\
);

\dly_17\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s11,
	a_delayed => s12,
	clk => \clk\,
	reset => \reset\
);

s10 <= \init\;
\done\ <= s12(0);
s6 <= conv_std_logic_vector(2048, 32);
s7 <= conv_std_logic_vector(0, 32);
\result\ <= s13;
end behavior; 