library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity vecsum is 
   port ( 
           \clear\  : in	 std_logic; 
           \clk\    : in	 std_logic; 
           \done\   : out std_logic; 
           \init\   : in	 std_logic; 
           \reset\  : in	 std_logic; 
           \result\ : out std_logic_vector(31 downto 0) 
); 
end vecsum; 

architecture behavior of vecsum is 

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

component block_ram_dual 
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

component block_ram_dual_x 
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

component block_ram_dual_y 
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

signal s9	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s16	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s18	: std_logic; 
signal s25	: std_logic_vector(0 downto 0); 
signal s20	: std_logic; 
signal s21	: std_logic; 
signal s22	: std_logic_vector(0 downto 0); 
signal s23	: std_logic_vector(31 downto 0); 

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
		input => s16,
		output => s9,
		reset => \reset\,
		step => s18,
		termination => s15
	);

	\x_add_op_s_y\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s7,
		I1 => s8,
		O0 => s6
	);

	\i_15_add_op_s_c15\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s9,
		I1 => s10,
		O0 => s5
	);

	\x_18_add_op_s_y_19\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s12,
		I1 => s13,
		O0 => s11
	);

	\c26\: delay_op
	generic map ( 
		bits => 32,
		delay => 2
	)
	port map ( 
		a => s9,
		a_delayed => s17,
		clk => \clk\,
		reset => \reset\
	);

	\c27\: delay_op
	generic map ( 
		bits => 1,
		delay => 2
	)
	port map ( 
		a(0) => s18,
		a_delayed => s25,
		clk => \clk\,
		reset => \reset\
	);

	\c28\: delay_op
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

	\c29\: delay_op
	generic map ( 
		bits => 32,
		delay => 2
	)
	port map ( 
		a => s5,
		a_delayed => s23,
		clk => \clk\,
		reset => \reset\
	);

	\z\: block_ram_dual
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address_0(10 downto 0) => s17(10 downto 0),
		data_in_0 => s6,
		we_0 => s25(0),
		address_1(10 downto 0) => s23(10 downto 0),
		data_in_1 => s11,
		we_1 => s25(0),
		clk => \clk\
	);

	\x\: block_ram_dual_x
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address_0(10 downto 0) => s9(10 downto 0),
		data_out_0 => s7,
		address_1(10 downto 0) => s5(10 downto 0),
		data_out_1 => s12,
		clk => \clk\
	);

	\y\: block_ram_dual_y
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address_0(10 downto 0) => s9(10 downto 0),
		data_out_0 => s8,
		address_1(10 downto 0) => s5(10 downto 0),
		data_out_1 => s13,
		clk => \clk\
	);

s10 <= conv_std_logic_vector(1, 32); 
s20 <= \init\; 
\done\ <= s22(0); 
s15 <= conv_std_logic_vector(2047, 32); 
s16 <= conv_std_logic_vector(0, 32); 
end behavior; 