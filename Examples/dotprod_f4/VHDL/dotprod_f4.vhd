library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod_f4 is 
   port ( 
           \clear\  : in	 std_logic; 
           \clk\    : in	 std_logic; 
           \done\   : out std_logic; 
           \init\   : in	 std_logic; 
           \reset\  : in	 std_logic; 
           \result\ : out std_logic_vector(31 downto 0) 
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

component block_ram_a_19 
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

component block_ram_a_27 
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

component block_ram_a_35 
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

component block_ram_b_20 
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

component block_ram_b_28 
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

component block_ram_b_36 
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

component reg_op 
generic ( 
        w_in	: integer := 16; 
        initial	: integer := 0 
); 
port ( 
        clk         : in	std_logic; 
        reset       : in	std_logic; 
        we          : in	std_logic := '1'; 
        I0          : in	std_logic_vector(w_in-1 downto 0); 
        O0          : out	std_logic_vector(w_in-1 downto 0) 
); 
end component; 

signal s20	: std_logic_vector(31 downto 0); 
signal s1	: std_logic_vector(31 downto 0); 
signal s44	: std_logic_vector(31 downto 0); 
signal s3	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s19	: std_logic_vector(31 downto 0); 
signal s21	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s47	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(31 downto 0); 
signal s35	: std_logic; 
signal s42	: std_logic_vector(31 downto 0); 
signal s43	: std_logic_vector(31 downto 0); 
signal s48	: std_logic_vector(31 downto 0); 
signal s49	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s60	: std_logic_vector(0 downto 0); 
signal s55	: std_logic; 
signal s56	: std_logic; 
signal s57	: std_logic_vector(0 downto 0); 

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
		clk_en => s55,
		done => s56,
		input => s43,
		output => s20,
		reset => \reset\,
		step => s35,
		termination => s42
	);

	\x\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s20,
		O0 => s27,
		reset => \reset\,
		we => s35
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s44,
		I1 => s1,
		O0 => s44,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\a_mult_op_s_b\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s3,
		I1 => s4,
		O0 => s1
	);

	\a\: block_ram_a
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s27(10 downto 0),
		clk => \clk\,
		data_out => s3
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s27(10 downto 0),
		clk => \clk\,
		data_out => s4
	);

	\x_13\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s5,
		O0 => s29,
		reset => \reset\,
		we => s35
	);

	\i_15_add_op_s_c15\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s20,
		I1 => s7,
		O0 => s5
	);

	\sum_17\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s45,
		I1 => s8,
		O0 => s45,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\a_19_mult_op_s_b_20\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s10,
		I1 => s11,
		O0 => s8
	);

	\a_19\: block_ram_a_19
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s29(10 downto 0),
		clk => \clk\,
		data_out => s10
	);

	\b_20\: block_ram_b_20
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s29(10 downto 0),
		clk => \clk\,
		data_out => s11
	);

	\x_21\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s12,
		O0 => s31,
		reset => \reset\,
		we => s35
	);

	\i_23_add_op_s_c23\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s20,
		I1 => s14,
		O0 => s12
	);

	\sum_25\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s46,
		I1 => s15,
		O0 => s46,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\a_27_mult_op_s_b_28\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s17,
		I1 => s18,
		O0 => s15
	);

	\a_27\: block_ram_a_27
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s31(10 downto 0),
		clk => \clk\,
		data_out => s17
	);

	\b_28\: block_ram_b_28
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s31(10 downto 0),
		clk => \clk\,
		data_out => s18
	);

	\x_29\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s19,
		O0 => s33,
		reset => \reset\,
		we => s35
	);

	\i_31_add_op_s_c31\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s20,
		I1 => s21,
		O0 => s19
	);

	\sum_33\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s47,
		I1 => s22,
		O0 => s47,
		clk => \clk\,
		reset => \reset\,
		we => s60(0)
	);

	\a_35_mult_op_s_b_36\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s24,
		I1 => s25,
		O0 => s22
	);

	\a_35\: block_ram_a_35
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s33(10 downto 0),
		clk => \clk\,
		data_out => s24
	);

	\b_36\: block_ram_b_36
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s33(10 downto 0),
		clk => \clk\,
		data_out => s25
	);

	\sum_add_op_s_sum_17\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s44,
		I1 => s45,
		O0 => s48
	);

	\sum_25_add_op_s_sum_33\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s46,
		I1 => s47,
		O0 => s49
	);

	\sum_add_op_s_sum_17_add_op_s_sum_25_add_op_s_sum_33\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
		I1 => s49,
		O0 => s50
	);

	\c56\: delay_op
	generic map ( 
		bits => 1,
		delay => 3
	)
	port map ( 
		a(0) => s35,
		a_delayed => s60,
		clk => \clk\,
		reset => \reset\
	);

	\c60\: delay_op
	generic map ( 
		bits => 1,
		delay => 7
	)
	port map ( 
		a(0) => s56,
		a_delayed => s57,
		clk => \clk\,
		reset => \reset\
	);

s7 <= conv_std_logic_vector(1, 32); 
s14 <= conv_std_logic_vector(2, 32); 
s21 <= conv_std_logic_vector(3, 32); 
s55 <= \init\; 
\done\ <= s57(0); 
s42 <= conv_std_logic_vector(2047, 32); 
s43 <= conv_std_logic_vector(0, 32); 
\result\ <= s50; 
end behavior; 