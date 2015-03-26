library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity accumulation is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end accumulation; 

architecture behavior of accumulation is 

component add_op_s 
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

signal s1	: std_logic_vector(31 downto 0); 
signal s3	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s7	: std_logic; 
signal s8	: std_logic_vector(0 downto 0); 
signal s9	: std_logic; 
signal s10	: std_logic; 
signal s11	: std_logic_vector(0 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
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
	clk_en => s9,
	done => s10,
	input => s6,
	output => s4,
	reset => \reset\,
	step => s7,
	termination => s5
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
	I1 => s1,
	O0 => s13,
	clk => \clk\,
	reset => \reset\,
	we => s8(0)
);

\a_add_op_s_i_8\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s3,
	I1 => s12,
	O0 => s1
);

\a\: block_ram_a
generic map ( 
	address_width => 4,
	data_width => 32
)
port map ( 
	address(3 downto 0) => s4(3 downto 0),
	clk => \clk\,
	data_out => s3
);

\dly_14\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s7,
	a_delayed => s8,
	clk => \clk\,
	reset => \reset\
);

\dly_15\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s10,
	a_delayed => s11,
	clk => \clk\,
	reset => \reset\
);

\dly_16\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s4,
	a_delayed => s12,
	clk => \clk\,
	reset => \reset\
);

s9 <= \init\;
\done\ <= s11(0);
s5 <= conv_std_logic_vector(10, 32);
s6 <= conv_std_logic_vector(0, 32);
\result\ <= s13;
end behavior; 