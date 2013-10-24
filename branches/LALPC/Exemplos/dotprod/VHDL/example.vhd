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

component block_ram_dual_a 
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

component block_ram_dual_b 
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

signal s11	: std_logic_vector(31 downto 0); 
signal s3	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s14	: std_logic; 
signal s16	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s23	: std_logic_vector(0 downto 0); 
signal s20	: std_logic; 
signal s21	: std_logic; 
signal s22	: std_logic_vector(0 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 

begin 

	\CTD_5\: counter
	generic map ( 
		bits => 32,
		condition => 1,
		down => 0,
		increment => 2,
		steps => 1
	)
	port map ( 
		clk => \clk\,
		clk_en => s20,
		done => s21,
		input => s17,
		output => s11,
		reset => \reset\,
		step => s14,
		termination => s16
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s24,
		I1 => s4,
		O0 => s24,
		clk => \clk\,
		reset => \reset\,
		we => s23(0)
	);

	\a_mult_op_s_b\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s6,
		I1 => s7,
		O0 => s4
	);

	\sum_12\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s25,
		I1 => s8,
		O0 => s25,
		clk => \clk\,
		reset => \reset\,
		we => s23(0)
	);

	\a_14_mult_op_s_b_18\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s10,
		I1 => s13,
		O0 => s8
	);

	\i_16_add_op_s_c16\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s11,
		I1 => s12,
		O0 => s3
	);

	\c25\: delay_op
	generic map ( 
		bits => 1,
		delay => 2
	)
	port map ( 
		a(0) => s14,
		a_delayed => s23,
		clk => \clk\,
		reset => \reset\
	);

	\c27\: delay_op
	generic map ( 
		bits => 1,
		delay => 5
	)
	port map ( 
		a(0) => s21,
		a_delayed => s22,
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
		I0 => s24,
		I1 => s25,
		O0 => s26
	);

	\a\: block_ram_dual_a
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address_0(10 downto 0) => s11(10 downto 0),
		data_out_0 => s6,
		address_1(10 downto 0) => s3(10 downto 0),
		data_out_1 => s10,
		clk => \clk\
	);

	\b\: block_ram_dual_b
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address_0(10 downto 0) => s11(10 downto 0),
		data_out_0 => s7,
		address_1(10 downto 0) => s3(10 downto 0),
		data_out_1 => s13,
		clk => \clk\
	);

s12 <= conv_std_logic_vector(1, 32); 
s20 <= \init\; 
\done\ <= s22(0); 
s16 <= conv_std_logic_vector(2047, 32); 
s17 <= conv_std_logic_vector(0, 32); 
\result\ <= s26; 
end behavior; 