library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity vecsum_multport_f2 is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\out_27\	: out	std_logic_vector(31 downto 0);
		\out_28\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end vecsum_multport_f2; 

architecture behavior of vecsum_multport_f2 is 

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

component block_ram_mult_x 
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
        clk                 :       in std_logic 
); 
end component; 

component block_ram_mult_y 
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
        clk                 :       in std_logic 
); 
end component; 

component block_ram_mult_z 
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

signal s10	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s17	: std_logic; 
signal s19	: std_logic; 
signal s20	: std_logic; 
signal s21	: std_logic_vector(0 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 
signal s30	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(0 downto 0); 
signal s34	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s37	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s39	: std_logic_vector(31 downto 0); 
signal s40	: std_logic_vector(31 downto 0); 

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
	clk_en => s19,
	done => s20,
	input => s15,
	output => s37,
	reset => \reset\,
	step => s17,
	termination => s14
);

\x_add_op_s_y\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s34,
	I1 => s38,
	O0 => s26
);

\i_14_add_op_s_num_15\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s37,
	I1 => s10,
	O0 => s39
);

\x_17_add_op_s_y_18\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s36,
	I1 => s40,
	O0 => s30
);

\dly_23\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s37,
	a_delayed => s25,
	clk => \clk\,
	reset => \reset\
);

\dly_24\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s17,
	a_delayed => s32,
	clk => \clk\,
	reset => \reset\
);

\dly_25\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s20,
	a_delayed => s21,
	clk => \clk\,
	reset => \reset\
);

\dly_26\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s39,
	a_delayed => s29,
	clk => \clk\,
	reset => \reset\
);

\z\: block_ram_mult_z
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s25(10 downto 0),
	data_in_0 => s26,
	data_out_0 => s27,
	we_0 => s32(0),
	address_1(10 downto 0) => s29(10 downto 0),
	data_in_1 => s30,
	data_out_1 => s31,
	we_1 => s32(0),
	clk => \clk\
);

\x\: block_ram_mult_x
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s37(10 downto 0),
	data_out_0 => s34,
	address_1(10 downto 0) => s39(10 downto 0),
	data_out_1 => s36,
	clk => \clk\
);

\y\: block_ram_mult_y
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s37(10 downto 0),
	data_out_0 => s38,
	address_1(10 downto 0) => s39(10 downto 0),
	data_out_1 => s40,
	clk => \clk\
);

s10 <= conv_std_logic_vector(1, 32);
s19 <= \init\;
\done\ <= s21(0);
s14 <= conv_std_logic_vector(2047, 32);
s15 <= conv_std_logic_vector(0, 32);
\out_27\ <= s27;
\out_28\ <= s31;
end behavior; 