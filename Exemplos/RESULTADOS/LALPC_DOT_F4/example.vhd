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

component block_ram_a14 
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

component block_ram_a21 
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

component block_ram_a28 
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

component block_ram_b18 
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

component block_ram_b25 
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

component block_ram_b32 
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

signal s36	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s53	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s54	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s23	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s56	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 
signal s37	: std_logic; 
signal s41	: std_logic_vector(31 downto 0); 
signal s42	: std_logic_vector(31 downto 0); 
signal s52	: std_logic_vector(0 downto 0); 
signal s47	: std_logic; 
signal s48	: std_logic; 
signal s49	: std_logic_vector(0 downto 0); 
signal s57	: std_logic_vector(31 downto 0); 
signal s58	: std_logic_vector(31 downto 0); 
signal s59	: std_logic_vector(31 downto 0); 

begin 

	\CTD_5\: counter
	generic map ( 
		bits => 32,
		condition => 1,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map ( 
		clk => \clk\,
		clk_en => s47,
		done => s48,
		input => s42,
		output => s36,
		reset => \reset\,
		step => s37,
		termination => s41
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s53,
		I1 => s8,
		O0 => s53,
		clk => \clk\,
		reset => \reset\,
		we => s52(0)
	);

	\a_mult_op_s_b\: mult_op_s
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

	\a\: block_ram_a
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s10
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s11
	);

	\sum12\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s54,
		I1 => s12,
		O0 => s54,
		clk => \clk\,
		reset => \reset\,
		we => s52(0)
	);

	\a14_mult_op_s_b18\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s14,
		I1 => s17,
		O0 => s12
	);

	\a14\: block_ram_a14
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s14
	);

	\b18\: block_ram_b18
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s17
	);

	\sum19\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s55,
		I1 => s18,
		O0 => s55,
		clk => \clk\,
		reset => \reset\,
		we => s52(0)
	);

	\a21_mult_op_s_b25\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s20,
		I1 => s23,
		O0 => s18
	);

	\a21\: block_ram_a21
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s20
	);

	\b25\: block_ram_b25
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s23
	);

	\sum26\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s56,
		I1 => s24,
		O0 => s56,
		clk => \clk\,
		reset => \reset\,
		we => s52(0)
	);

	\a28_mult_op_s_b32\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s26,
		I1 => s29,
		O0 => s24
	);

	\a28\: block_ram_a28
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s26
	);

	\b32\: block_ram_b32
	generic map ( 
		address_width => 9,
		data_width => 32
	)
	port map ( 
		address(8 downto 0) => s36(8 downto 0),
		clk => \clk\,
		data_out => s29
	);

	\c45\: delay_op
	generic map ( 
		bits => 1,
		delay => 2
	)
	port map ( 
		a(0) => s37,
		a_delayed => s52,
		clk => \clk\,
		reset => \reset\
	);

	\c49\: delay_op
	generic map ( 
		bits => 1,
		delay => 5
	)
	port map ( 
		a(0) => s48,
		a_delayed => s49,
		clk => \clk\,
		reset => \reset\
	);

	\sum_add_op_s_sum12\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s53,
		I1 => s54,
		O0 => s57
	);

	\sum19_add_op_s_sum26\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s55,
		I1 => s56,
		O0 => s58
	);

	\sum_add_op_s_sum12_add_op_s_sum19_add_op_s_sum26\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s57,
		I1 => s58,
		O0 => s59
	);

s47 <= \init\; 
\done\ <= s49(0); 
s41 <= conv_std_logic_vector(511, 32); 
s42 <= conv_std_logic_vector(0, 32); 
\result\ <= s59; 
end behavior; 