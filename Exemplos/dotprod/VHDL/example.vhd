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

component block_ram_a35 
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

component block_ram_a42 
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

component block_ram_a49 
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

component block_ram_a56 
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

component block_ram_b39 
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

component block_ram_b46 
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

component block_ram_b53 
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

component block_ram_b60 
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

signal s76	: std_logic_vector(31 downto 0); 
signal s16	: std_logic_vector(31 downto 0); 
signal s105	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s19	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s106	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s107	: std_logic_vector(31 downto 0); 
signal s28	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(31 downto 0); 
signal s108	: std_logic_vector(31 downto 0); 
signal s34	: std_logic_vector(31 downto 0); 
signal s37	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s109	: std_logic_vector(31 downto 0); 
signal s40	: std_logic_vector(31 downto 0); 
signal s43	: std_logic_vector(31 downto 0); 
signal s44	: std_logic_vector(31 downto 0); 
signal s110	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s49	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s111	: std_logic_vector(31 downto 0); 
signal s52	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s56	: std_logic_vector(31 downto 0); 
signal s112	: std_logic_vector(31 downto 0); 
signal s58	: std_logic_vector(31 downto 0); 
signal s61	: std_logic_vector(31 downto 0); 
signal s77	: std_logic; 
signal s85	: std_logic_vector(31 downto 0); 
signal s86	: std_logic_vector(31 downto 0); 
signal s104	: std_logic_vector(0 downto 0); 
signal s95	: std_logic; 
signal s96	: std_logic; 
signal s97	: std_logic_vector(0 downto 0); 
signal s113	: std_logic_vector(31 downto 0); 
signal s114	: std_logic_vector(31 downto 0); 
signal s115	: std_logic_vector(31 downto 0); 
signal s116	: std_logic_vector(31 downto 0); 
signal s117	: std_logic_vector(31 downto 0); 
signal s118	: std_logic_vector(31 downto 0); 
signal s119	: std_logic_vector(31 downto 0); 

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
		clk_en => s95,
		done => s96,
		input => s86,
		output => s76,
		reset => \reset\,
		step => s77,
		termination => s85
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s105,
		I1 => s16,
		O0 => s105,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a_mult_op_s_b\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s18,
		I1 => s19,
		O0 => s16
	);

	\a\: block_ram_a
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s18
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s19
	);

	\sum12\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s106,
		I1 => s20,
		O0 => s106,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a14_mult_op_s_b18\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s22,
		I1 => s25,
		O0 => s20
	);

	\a14\: block_ram_a14
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s22
	);

	\b18\: block_ram_b18
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s25
	);

	\sum19\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s107,
		I1 => s26,
		O0 => s107,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a21_mult_op_s_b25\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s28,
		I1 => s31,
		O0 => s26
	);

	\a21\: block_ram_a21
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s28
	);

	\b25\: block_ram_b25
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s31
	);

	\sum26\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s108,
		I1 => s32,
		O0 => s108,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a28_mult_op_s_b32\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s34,
		I1 => s37,
		O0 => s32
	);

	\a28\: block_ram_a28
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s34
	);

	\b32\: block_ram_b32
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s37
	);

	\sum33\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s109,
		I1 => s38,
		O0 => s109,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a35_mult_op_s_b39\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s40,
		I1 => s43,
		O0 => s38
	);

	\a35\: block_ram_a35
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s40
	);

	\b39\: block_ram_b39
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s43
	);

	\sum40\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s110,
		I1 => s44,
		O0 => s110,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a42_mult_op_s_b46\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s46,
		I1 => s49,
		O0 => s44
	);

	\a42\: block_ram_a42
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s46
	);

	\b46\: block_ram_b46
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s49
	);

	\sum47\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s111,
		I1 => s50,
		O0 => s111,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a49_mult_op_s_b53\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s52,
		I1 => s55,
		O0 => s50
	);

	\a49\: block_ram_a49
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s52
	);

	\b53\: block_ram_b53
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s55
	);

	\sum54\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s112,
		I1 => s56,
		O0 => s112,
		clk => \clk\,
		reset => \reset\,
		we => s104(0)
	);

	\a56_mult_op_s_b60\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s58,
		I1 => s61,
		O0 => s56
	);

	\a56\: block_ram_a56
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s58
	);

	\b60\: block_ram_b60
	generic map ( 
		address_width => 8,
		data_width => 32
	)
	port map ( 
		address(7 downto 0) => s76(7 downto 0),
		clk => \clk\,
		data_out => s61
	);

	\c85\: delay_op
	generic map ( 
		bits => 1,
		delay => 2
	)
	port map ( 
		a(0) => s77,
		a_delayed => s104,
		clk => \clk\,
		reset => \reset\
	);

	\c93\: delay_op
	generic map ( 
		bits => 1,
		delay => 5
	)
	port map ( 
		a(0) => s96,
		a_delayed => s97,
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
		I0 => s105,
		I1 => s106,
		O0 => s113
	);

	\sum19_add_op_s_sum26\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s107,
		I1 => s108,
		O0 => s114
	);

	\sum33_add_op_s_sum40\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s109,
		I1 => s110,
		O0 => s115
	);

	\sum47_add_op_s_sum54\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s111,
		I1 => s112,
		O0 => s116
	);

	\sum_add_op_s_sum12_add_op_s_sum19_add_op_s_sum26\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s113,
		I1 => s114,
		O0 => s117
	);

	\sum33_add_op_s_sum40_add_op_s_sum47_add_op_s_sum54\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s115,
		I1 => s116,
		O0 => s118
	);

	\sum_add_op_s_sum12_add_op_s_sum19_add_op_s_sum26_add_op_s_sum33_add_op_s_sum40_add_op_s_sum47_add_op_s_sum54\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s117,
		I1 => s118,
		O0 => s119
	);

s95 <= \init\; 
\done\ <= s97(0); 
s85 <= conv_std_logic_vector(255, 32); 
s86 <= conv_std_logic_vector(0, 32); 
\result\ <= s119; 
end behavior; 