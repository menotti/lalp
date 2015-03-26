library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod_f8 is 
   port ( 
           \clear\  : in	 std_logic; 
           \clk\    : in	 std_logic; 
           \done\   : out std_logic; 
           \init\   : in	 std_logic; 
           \reset\  : in	 std_logic; 
           \result\ : out std_logic_vector(31 downto 0) 
); 
end dotprod_f8; 

architecture behavior of dotprod_f8 is 

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

component block_ram_a_43 
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

component block_ram_a_51 
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

component block_ram_a_59 
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

component block_ram_a_67 
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

component block_ram_b_44 
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

component block_ram_b_52 
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

component block_ram_b_60 
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

component block_ram_b_68 
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

signal s48	: std_logic_vector(31 downto 0); 
signal s1	: std_logic_vector(31 downto 0); 
signal s88	: std_logic_vector(31 downto 0); 
signal s3	: std_logic_vector(31 downto 0); 
signal s4	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s7	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s89	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s90	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s19	: std_logic_vector(31 downto 0); 
signal s21	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s91	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s25	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s28	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 
signal s92	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(31 downto 0); 
signal s35	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s93	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s39	: std_logic_vector(31 downto 0); 
signal s40	: std_logic_vector(31 downto 0); 
signal s42	: std_logic_vector(31 downto 0); 
signal s43	: std_logic_vector(31 downto 0); 
signal s94	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s47	: std_logic_vector(31 downto 0); 
signal s49	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s95	: std_logic_vector(31 downto 0); 
signal s52	: std_logic_vector(31 downto 0); 
signal s53	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s57	: std_logic_vector(31 downto 0); 
signal s59	: std_logic_vector(31 downto 0); 
signal s61	: std_logic_vector(31 downto 0); 
signal s63	: std_logic_vector(31 downto 0); 
signal s65	: std_logic_vector(31 downto 0); 
signal s67	: std_logic_vector(31 downto 0); 
signal s69	: std_logic_vector(31 downto 0); 
signal s71	: std_logic; 
signal s86	: std_logic_vector(31 downto 0); 
signal s87	: std_logic_vector(31 downto 0); 
signal s96	: std_logic_vector(31 downto 0); 
signal s97	: std_logic_vector(31 downto 0); 
signal s98	: std_logic_vector(31 downto 0); 
signal s99	: std_logic_vector(31 downto 0); 
signal s100	: std_logic_vector(31 downto 0); 
signal s101	: std_logic_vector(31 downto 0); 
signal s102	: std_logic_vector(31 downto 0); 
signal s120	: std_logic_vector(0 downto 0); 
signal s111	: std_logic; 
signal s112	: std_logic; 
signal s113	: std_logic_vector(0 downto 0); 

begin 

	\i\: counter
	generic map ( 
		bits => 32,
		condition => 1,
		down => 0,
		increment => 8,
		steps => 1
	)
	port map ( 
		clk => \clk\,
		clk_en => s111,
		done => s112,
		input => s87,
		output => s48,
		reset => \reset\,
		step => s71,
		termination => s86
	);

	\x\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s48,
		O0 => s55,
		reset => \reset\,
		we => s71
	);

	\sum\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s88,
		I1 => s1,
		O0 => s88,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
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
		address(10 downto 0) => s55(10 downto 0),
		clk => \clk\,
		data_out => s3
	);

	\b\: block_ram_b
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s55(10 downto 0),
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
		O0 => s57,
		reset => \reset\,
		we => s71
	);

	\i_15_add_op_s_c15\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
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
		I0 => s89,
		I1 => s8,
		O0 => s89,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
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
		address(10 downto 0) => s57(10 downto 0),
		clk => \clk\,
		data_out => s10
	);

	\b_20\: block_ram_b_20
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s57(10 downto 0),
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
		O0 => s59,
		reset => \reset\,
		we => s71
	);

	\i_23_add_op_s_c23\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
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
		I0 => s90,
		I1 => s15,
		O0 => s90,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
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
		address(10 downto 0) => s59(10 downto 0),
		clk => \clk\,
		data_out => s17
	);

	\b_28\: block_ram_b_28
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s59(10 downto 0),
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
		O0 => s61,
		reset => \reset\,
		we => s71
	);

	\i_31_add_op_s_c31\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
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
		I0 => s91,
		I1 => s22,
		O0 => s91,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
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
		address(10 downto 0) => s61(10 downto 0),
		clk => \clk\,
		data_out => s24
	);

	\b_36\: block_ram_b_36
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s61(10 downto 0),
		clk => \clk\,
		data_out => s25
	);

	\x_37\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s26,
		O0 => s63,
		reset => \reset\,
		we => s71
	);

	\i_39_add_op_s_c39\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
		I1 => s28,
		O0 => s26
	);

	\sum_41\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s92,
		I1 => s29,
		O0 => s92,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\a_43_mult_op_s_b_44\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s31,
		I1 => s32,
		O0 => s29
	);

	\a_43\: block_ram_a_43
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s63(10 downto 0),
		clk => \clk\,
		data_out => s31
	);

	\b_44\: block_ram_b_44
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s63(10 downto 0),
		clk => \clk\,
		data_out => s32
	);

	\x_45\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s33,
		O0 => s65,
		reset => \reset\,
		we => s71
	);

	\i_47_add_op_s_c47\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
		I1 => s35,
		O0 => s33
	);

	\sum_49\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s93,
		I1 => s36,
		O0 => s93,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\a_51_mult_op_s_b_52\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s38,
		I1 => s39,
		O0 => s36
	);

	\a_51\: block_ram_a_51
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s65(10 downto 0),
		clk => \clk\,
		data_out => s38
	);

	\b_52\: block_ram_b_52
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s65(10 downto 0),
		clk => \clk\,
		data_out => s39
	);

	\x_53\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s40,
		O0 => s67,
		reset => \reset\,
		we => s71
	);

	\i_55_add_op_s_c55\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
		I1 => s42,
		O0 => s40
	);

	\sum_57\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s94,
		I1 => s43,
		O0 => s94,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\a_59_mult_op_s_b_60\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s45,
		I1 => s46,
		O0 => s43
	);

	\a_59\: block_ram_a_59
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s67(10 downto 0),
		clk => \clk\,
		data_out => s45
	);

	\b_60\: block_ram_b_60
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s67(10 downto 0),
		clk => \clk\,
		data_out => s46
	);

	\x_61\: reg_op
	generic map ( 
		initial => 0,
		w_in => 32
	)
	port map ( 
		clk => \clk\,
		I0 => s47,
		O0 => s69,
		reset => \reset\,
		we => s71
	);

	\i_63_add_op_s_c63\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s48,
		I1 => s49,
		O0 => s47
	);

	\sum_65\: add_reg_op_s
	generic map ( 
		initial => 0,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s95,
		I1 => s50,
		O0 => s95,
		clk => \clk\,
		reset => \reset\,
		we => s120(0)
	);

	\a_67_mult_op_s_b_68\: mult_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s52,
		I1 => s53,
		O0 => s50
	);

	\a_67\: block_ram_a_67
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s69(10 downto 0),
		clk => \clk\,
		data_out => s52
	);

	\b_68\: block_ram_b_68
	generic map ( 
		address_width => 11,
		data_width => 32
	)
	port map ( 
		address(10 downto 0) => s69(10 downto 0),
		clk => \clk\,
		data_out => s53
	);

	\sum_add_op_s_sum_17\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s88,
		I1 => s89,
		O0 => s96
	);

	\sum_25_add_op_s_sum_33\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s90,
		I1 => s91,
		O0 => s97
	);

	\sum_41_add_op_s_sum_49\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s92,
		I1 => s93,
		O0 => s98
	);

	\sum_57_add_op_s_sum_65\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s94,
		I1 => s95,
		O0 => s99
	);

	\sum_add_op_s_sum_17_add_op_s_sum_25_add_op_s_sum_33\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s96,
		I1 => s97,
		O0 => s100
	);

	\sum_41_add_op_s_sum_49_add_op_s_sum_57_add_op_s_sum_65\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s98,
		I1 => s99,
		O0 => s101
	);

	\sum_add_op_s_sum_17_add_op_s_sum_25_add_op_s_sum_33_add_op_s_sum_41_add_op_s_sum_49_add_op_s_sum_57_add_op_s_sum_65\: add_op_s
	generic map ( 
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map ( 
		I0 => s100,
		I1 => s101,
		O0 => s102
	);

	\c108\: delay_op
	generic map ( 
		bits => 1,
		delay => 3
	)
	port map ( 
		a(0) => s71,
		a_delayed => s120,
		clk => \clk\,
		reset => \reset\
	);

	\c116\: delay_op
	generic map ( 
		bits => 1,
		delay => 7
	)
	port map ( 
		a(0) => s112,
		a_delayed => s113,
		clk => \clk\,
		reset => \reset\
	);

s7 <= conv_std_logic_vector(1, 32); 
s14 <= conv_std_logic_vector(2, 32); 
s21 <= conv_std_logic_vector(3, 32); 
s28 <= conv_std_logic_vector(4, 32); 
s35 <= conv_std_logic_vector(5, 32); 
s42 <= conv_std_logic_vector(6, 32); 
s49 <= conv_std_logic_vector(7, 32); 
s111 <= \init\; 
\done\ <= s113(0); 
s86 <= conv_std_logic_vector(2047, 32); 
s87 <= conv_std_logic_vector(0, 32); 
\result\ <= s102; 
end behavior; 