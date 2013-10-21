library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod is 
   port ( 
           \clear\  : in	 std_logic; 
           \clk\    : in	 std_logic; 
           \done\   : out std_logic; 
           \init\   : in	 std_logic; 
           \reset\  : in	 std_logic; 
           \result\ : out std_logic_vector(31 downto 0) 
); 
end dotprod; 

architecture behavior of dotprod is 

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

signal s13	: std_logic_vector(31 downto 0); 
signal s1	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(31 downto 0); 
signal s3	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s34	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s26	: std_logic; 
signal s31	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(31 downto 0); 
signal s35	: std_logic_vector(31 downto 0); 
signal s37	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(0 downto 0); 
signal s41	: std_logic; 
signal s42	: std_logic; 
signal s43	: std_logic_vector(0 downto 0); 

begin 

	\i\: counter
	generic map ( 
		bits => 32,
		condition => 1,
		down => 0,
		increment => 3,
		steps => 1
	)
	port map ( 
		clk => \clk\,
		clk_en => s41,
		done => s42,
		input => s32,
		output => s13,
		reset => \reset\,
		step => s26,
		termination => s31
	);

	\x\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s13,
		O0 => s20,
		reset => \reset\,
		we => s26
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s33,
		I1 => s1,
		O0 => s33,
		clk => \clk\,
		reset => \reset\,
		we => s45(0)
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
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s20(1 downto 0),
		clk => \clk\,
		data_out => s3
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s20(1 downto 0),
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
		O0 => s22,
		reset => \reset\,
		we => s26
	);

	\i_15_add_op_s_c15\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s13,
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
		I0 => s34,
		I1 => s8,
		O0 => s34,
		clk => \clk\,
		reset => \reset\,
		we => s45(0)
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
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s22(1 downto 0),
		clk => \clk\,
		data_out => s10
	);

	\b_20\: block_ram_b_20
	generic map ( 
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s22(1 downto 0),
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
		O0 => s24,
		reset => \reset\,
		we => s26
	);

	\i_23_add_op_s_c23\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s13,
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
		I0 => s36,
		I1 => s15,
		O0 => s36,
		clk => \clk\,
		reset => \reset\,
		we => s45(0)
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
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s24(1 downto 0),
		clk => \clk\,
		data_out => s17
	);

	\b_28\: block_ram_b_28
	generic map ( 
		address_width => 2,
		data_width => 32
	)
	port map ( 
		address(1 downto 0) => s24(1 downto 0),
		clk => \clk\,
		data_out => s18
	);

	\sum_add_op_s_sum_17\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s33,
		I1 => s34,
		O0 => s35
	);

	\sum_add_op_s_sum_17_add_op_s_sum_25\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s35,
		I1 => s36,
		O0 => s37
	);

	\c43\: delay_op
	generic map ( 
		bits => 1,
		delay => 3
	)
	port map ( 
		a(0) => s26,
		a_delayed => s45,
		clk => \clk\,
		reset => \reset\
	);

	\c46\: delay_op
	generic map ( 
		bits => 1,
		delay => 7
	)
	port map ( 
		a(0) => s42,
		a_delayed => s43,
		clk => \clk\,
		reset => \reset\
	);

s7 <= conv_std_logic_vector(1, 32); 
s14 <= conv_std_logic_vector(2, 32); 
s41 <= \init\; 
\done\ <= s43(0); 
s31 <= conv_std_logic_vector(2, 32); 
s32 <= conv_std_logic_vector(0, 32); 
\result\ <= s37; 
end behavior; 