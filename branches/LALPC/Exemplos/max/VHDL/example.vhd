library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity max is 
   port ( 
           \clear\  : in	 std_logic; 
           \clk\    : in	 std_logic; 
           \done\   : out std_logic; 
           \init\   : in	 std_logic; 
           \reset\  : in	 std_logic; 
           \result\ : out std_logic_vector(31 downto 0) 
); 
end max; 

architecture behavior of max is 

component block_ram_v 
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

component if_gt_op_s 
generic ( 
        w_in1	: integer := 16; 
        w_in2	: integer := 16; 
        w_out	: integer := 1 
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

signal s4	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(0 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s9	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s14	: std_logic; 
signal s15	: std_logic; 
signal s16	: std_logic_vector(0 downto 0); 

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
		clk_en => s14,
		done => s15,
		input => s11,
		output => s9,
		reset => \reset\,
		termination => s10
	);

	\v_v_if_gt_op_s_maxval_maxval\: if_gt_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 1
	)
	port map ( 
		I0 => s7,
		I1 => s13,
		O0 => s6
	);

	\maxval\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s7,
		O0 => s12,
		reset => \reset\,
		we => s6(0)
	);

	\v\: block_ram_v
	generic map ( 
		address_width => 4,
		data_width => 32
	)
	port map ( 
		address(3 downto 0) => s9(3 downto 0),
		clk => \clk\,
		data_out => s4
	);

	\maxval\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		O0 => s13,
		reset => \reset\,
		we => s6(0)
	);

	\v\: block_ram_v
	generic map ( 
		address_width => 4,
		data_width => 32
	)
	port map ( 
		address(3 downto 0) => s9(3 downto 0),
		clk => \clk\,
		data_out => s7
	);

	\c15\: delay_op
	generic map ( 
		bits => 1,
		delay => 5
	)
	port map ( 
		a(0) => s15,
		a_delayed => s16,
		clk => \clk\,
		reset => \reset\
	);

s14 <= \init\; 
\done\ <= s16(0); 
s10 <= conv_std_logic_vector(10, 32); 
s11 <= conv_std_logic_vector(0, 32); 
\result\ <= s12; 
\result\ <= s13; 
end behavior; 