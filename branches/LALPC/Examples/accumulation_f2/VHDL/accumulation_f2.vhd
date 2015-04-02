library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity accumulation_f2 is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic;
        address_2           :in     std_logic_vector (3 downto 0); 
        data_in_2           :in     std_logic_vector (31 downto 0) := (others => '0'); 
        we_2                :in     std_logic := '0'
	);
end accumulation_f2; 

architecture behavior of accumulation_f2 is 

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

component block_ram_mult_a 
generic ( 
        data_width          : integer := 8; 
        address_width	: integer := 8 
); 
port ( 
        address_0           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_0           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_0          :out    std_logic_vector (data_width-1 downto 0); 
        we_0                :in     std_logic := '0'; 
        oe_0                :in     std_logic := '1'; 
        address_1           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_1           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_1          :out    std_logic_vector (data_width-1 downto 0); 
        we_1                :in     std_logic := '0'; 
        oe_1                :in     std_logic := '1'; 
        address_2           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_2           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_2          :out    std_logic_vector (data_width-1 downto 0); 
        we_2                :in     std_logic := '0'; 
        oe_2                :in     std_logic := '1'; 
        clk                 :       in std_logic 
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

signal s2	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(0 downto 0); 
signal s16	: std_logic; 
signal s17	: std_logic_vector(0 downto 0); 
signal s18	: std_logic; 
signal s19	: std_logic; 
signal s20	: std_logic_vector(0 downto 0); 
signal s21	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s23	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s28	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 

begin 

\i\: counter
generic map ( 
	bits => 32,
	condition => 1,
	down => 0,
	increment => 2,
	steps => 1
)
port map ( 
	clk => \clk\,
	clk_en => s18,
	done => s19,
	input => s13,
	output => s26,
	reset => \reset\,
	step => s16,
	termination => s12
);

\sum\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s23,
	I1 => s2,
	O0 => s23,
	clk => \clk\,
	reset => \reset\,
	we => s15(0)
);

\a_add_op_s_i_8\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s27,
	I1 => s21,
	O0 => s2
);

\sum_10\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s24,
	I1 => s6,
	O0 => s24,
	clk => \clk\,
	reset => \reset\,
	we => s17(0)
);

\a_12_add_op_s_comp_13\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s29,
	I1 => s22,
	O0 => s6
);

\i_14_add_op_s_num_15\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s26,
	I1 => s11,
	O0 => s28
);

\dly_21\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s16,
	a_delayed => s15,
	clk => \clk\,
	reset => \reset\
);

\dly_22\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s16,
	a_delayed => s17,
	clk => \clk\,
	reset => \reset\
);

\dly_23\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s19,
	a_delayed => s20,
	clk => \clk\,
	reset => \reset\
);

\dly_24\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s26,
	a_delayed => s21,
	clk => \clk\,
	reset => \reset\
);

\dly_25\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s28,
	a_delayed => s22,
	clk => \clk\,
	reset => \reset\
);

\sum_add_op_s_sum_10\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s23,
	I1 => s24,
	O0 => s25
);

\a\: block_ram_mult_a
generic map ( 
	address_width => 4,
	data_width => 32
)
port map ( 
	address_0(3 downto 0) => s26(3 downto 0),
	data_out_0 => s27,
	address_1(3 downto 0) => s28(3 downto 0),
	data_out_1 => s29,
	address_2 => address_2,
	data_in_2 => data_in_2,
	we_2 => we_2,
	clk => \clk\
);

s11 <= conv_std_logic_vector(1, 32);
s18 <= \init\;
\done\ <= s20(0);
s12 <= conv_std_logic_vector(9, 32);
s13 <= conv_std_logic_vector(0, 32);
\result\ <= s25;
end behavior; 
