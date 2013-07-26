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

component block_ram 
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

component op_add_s 
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

component block_ram_d 
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

signal s0	: std_logic_vector(31 downto 0); 
signal s1	: std_logic_vector(31 downto 0); 
signal s2	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(15 downto 0); 
signal s4	: std_logic; 
signal s7	: std_logic_vector(15 downto 0); 
signal s8	: std_logic_vector(0 downto 0); 
signal s9	: std_logic_vector(31 downto 0); 
signal s10	: std_logic; 
signal s11	: std_logic_vector(15 downto 0); 
signal s12	: std_logic_vector(15 downto 0); 
signal s13	: std_logic; 
signal s14	: std_logic_vector(0 downto 0); 

begin 

	\i\: counter
	generic map ( 
		bits => 16,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 0
	)
	port ( 
		input => s12,
		termination => s11,
		clk => \clk\,
		clk_en => s10,
		reset => \reset\,
		step => s4,
		done => s13,
		output => s6
	);

	\res\: block_ram
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port ( 
		data_in => s0,
		address(10 downto 0) => s7(10 downto 0),
		we => s8(0),
		clk => \clk\,
		data_out => s9
	);

	\b_op_add_s_d\: op_add_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port ( 
		I0 => s1,
		I1 => s2,
		O0 => s0
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port ( 
		address(10 downto 0) => s6(10 downto 0),
		clk => \clk\,
		data_out => s1
	);

	\d\: block_ram_d
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port ( 
		address(10 downto 0) => s6(10 downto 0),
		clk => \clk\,
		data_out => s2
	);

	\c9\: delay_op
	generic map ( 
		bits => 16,
		delay => 0
	)
	port ( 
		a => s6,
		clk => \clk\,
		reset => \reset\,
		a_delayed => s7
	);

	\c10\: delay_op
	generic map ( 
		bits => 1,
		delay => 0
	)
	port ( 
		a(0) => s4,
		clk => \clk\,
		reset => \reset\,
		a_delayed => s8
	);

	\c16\: delay_op
	generic map ( 
		bits => 1,
		delay => 0
	)
	port ( 
		a(0) => s13,
		a_delayed => s14
	);

\return\ <= s9; 
s10 <= \init\; 
\s11\ <= conv_std_logic_vector(10, 16); 
\s12\ <= conv_std_logic_vector(0, 16); 
\done\ <= s14(0); 
end behavior; 