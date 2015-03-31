library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod_f4 is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end dotprod_f4; 

architecture behavior of dotprod_f4 is 

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
        address_3           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_3           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_3          :out    std_logic_vector (data_width-1 downto 0); 
        we_3                :in     std_logic := '0'; 
        oe_3                :in     std_logic := '1'; 
        clk                 :       in std_logic 
); 
end component; 

component block_ram_mult_b 
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
        address_3           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_3           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_3          :out    std_logic_vector (data_width-1 downto 0); 
        we_3                :in     std_logic := '0'; 
        oe_3                :in     std_logic := '1'; 
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

signal s8	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s16	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s28	: std_logic_vector(31 downto 0); 
signal s30	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(0 downto 0); 
signal s35	: std_logic_vector(0 downto 0); 
signal s37	: std_logic_vector(0 downto 0); 
signal s38	: std_logic; 
signal s39	: std_logic_vector(0 downto 0); 
signal s40	: std_logic; 
signal s41	: std_logic; 
signal s42	: std_logic_vector(0 downto 0); 
signal s43	: std_logic_vector(31 downto 0); 
signal s44	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s47	: std_logic_vector(31 downto 0); 
signal s48	: std_logic_vector(31 downto 0); 
signal s49	: std_logic_vector(31 downto 0); 
signal s51	: std_logic_vector(31 downto 0); 
signal s53	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s57	: std_logic_vector(31 downto 0); 
signal s58	: std_logic_vector(31 downto 0); 
signal s59	: std_logic_vector(31 downto 0); 
signal s60	: std_logic_vector(31 downto 0); 
signal s61	: std_logic_vector(31 downto 0); 
signal s62	: std_logic_vector(31 downto 0); 
signal s63	: std_logic_vector(31 downto 0); 
signal s64	: std_logic_vector(31 downto 0); 
signal s65	: std_logic_vector(31 downto 0); 

begin 

\i\: counter
generic map ( 
	bits => 32,
	condition => 1,
	down => 0,
	increment => 4,
	steps => 1
)
port map ( 
	clk => \clk\,
	clk_en => s40,
	done => s41,
	input => s31,
	output => s58,
	reset => \reset\,
	step => s38,
	termination => s30
);

\sum\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s43,
	I1 => s8,
	O0 => s43,
	clk => \clk\,
	reset => \reset\,
	we => s33(0)
);

\a_mult_op_s_b\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s51,
	I1 => s59,
	O0 => s8
);

\sum_12\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s44,
	I1 => s12,
	O0 => s44,
	clk => \clk\,
	reset => \reset\,
	we => s35(0)
);

\a_14_mult_op_s_b_18\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s53,
	I1 => s61,
	O0 => s12
);

\i_16_add_op_s_num_17\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s58,
	I1 => s16,
	O0 => s60
);

\sum_20\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s45,
	I1 => s18,
	O0 => s45,
	clk => \clk\,
	reset => \reset\,
	we => s37(0)
);

\a_22_mult_op_s_b_26\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s55,
	I1 => s63,
	O0 => s18
);

\i_24_add_op_s_num_25\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s58,
	I1 => s22,
	O0 => s62
);

\sum_28\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s46,
	I1 => s24,
	O0 => s46,
	clk => \clk\,
	reset => \reset\,
	we => s39(0)
);

\a_30_mult_op_s_b_34\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s57,
	I1 => s65,
	O0 => s24
);

\i_32_add_op_s_num_33\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s58,
	I1 => s28,
	O0 => s64
);

\dly_40\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s38,
	a_delayed => s33,
	clk => \clk\,
	reset => \reset\
);

\dly_41\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s38,
	a_delayed => s35,
	clk => \clk\,
	reset => \reset\
);

\dly_42\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s38,
	a_delayed => s37,
	clk => \clk\,
	reset => \reset\
);

\dly_43\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s38,
	a_delayed => s39,
	clk => \clk\,
	reset => \reset\
);

\dly_44\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s41,
	a_delayed => s42,
	clk => \clk\,
	reset => \reset\
);

\sum_add_op_s_sum_12\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s43,
	I1 => s44,
	O0 => s47
);

\sum_20_add_op_s_sum_28\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s45,
	I1 => s46,
	O0 => s48
);

\sum_add_op_s_sum_12_add_op_s_sum_20_add_op_s_sum_28\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s47,
	I1 => s48,
	O0 => s49
);

\a\: block_ram_mult_a
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s58(10 downto 0),
	data_out_0 => s51,
	address_1(10 downto 0) => s60(10 downto 0),
	data_out_1 => s53,
	address_2(10 downto 0) => s62(10 downto 0),
	data_out_2 => s55,
	address_3(10 downto 0) => s64(10 downto 0),
	data_out_3 => s57,
	clk => \clk\
);

\b\: block_ram_mult_b
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s58(10 downto 0),
	data_out_0 => s59,
	address_1(10 downto 0) => s60(10 downto 0),
	data_out_1 => s61,
	address_2(10 downto 0) => s62(10 downto 0),
	data_out_2 => s63,
	address_3(10 downto 0) => s64(10 downto 0),
	data_out_3 => s65,
	clk => \clk\
);

s16 <= conv_std_logic_vector(1, 32);
s22 <= conv_std_logic_vector(2, 32);
s28 <= conv_std_logic_vector(3, 32);
s40 <= \init\;
\done\ <= s42(0);
s30 <= conv_std_logic_vector(2047, 32);
s31 <= conv_std_logic_vector(0, 32);
\result\ <= s49;
end behavior; 