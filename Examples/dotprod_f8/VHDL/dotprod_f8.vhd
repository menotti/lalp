library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity dotprod_f8 is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
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

component block_ram_mult_a 
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
        address_2           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_2           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_2          :out    std_logic_vector (data_width-1 downto 0); 
        we_2                :in     std_logic := '0'; 
        oe_2                :in     std_logic := '1'; 
        address_3           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_3           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_3          :out    std_logic_vector (data_width-1 downto 0); 
        we_3                :in     std_logic := '0'; 
        oe_3                :in     std_logic := '1'; 
        address_4           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_4           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_4          :out    std_logic_vector (data_width-1 downto 0); 
        we_4                :in     std_logic := '0'; 
        oe_4                :in     std_logic := '1'; 
        address_5           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_5           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_5          :out    std_logic_vector (data_width-1 downto 0); 
        we_5                :in     std_logic := '0'; 
        oe_5                :in     std_logic := '1'; 
        address_6           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_6           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_6          :out    std_logic_vector (data_width-1 downto 0); 
        we_6                :in     std_logic := '0'; 
        oe_6                :in     std_logic := '1'; 
        address_7           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_7           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_7          :out    std_logic_vector (data_width-1 downto 0); 
        we_7                :in     std_logic := '0'; 
        oe_7                :in     std_logic := '1'; 
        clk                 :       in std_logic 
); 
end component; 

component block_ram_mult_b 
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
        address_2           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_2           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_2          :out    std_logic_vector (data_width-1 downto 0); 
        we_2                :in     std_logic := '0'; 
        oe_2                :in     std_logic := '1'; 
        address_3           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_3           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_3          :out    std_logic_vector (data_width-1 downto 0); 
        we_3                :in     std_logic := '0'; 
        oe_3                :in     std_logic := '1'; 
        address_4           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_4           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_4          :out    std_logic_vector (data_width-1 downto 0); 
        we_4                :in     std_logic := '0'; 
        oe_4                :in     std_logic := '1'; 
        address_5           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_5           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_5          :out    std_logic_vector (data_width-1 downto 0); 
        we_5                :in     std_logic := '0'; 
        oe_5                :in     std_logic := '1'; 
        address_6           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_6           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_6          :out    std_logic_vector (data_width-1 downto 0); 
        we_6                :in     std_logic := '0'; 
        oe_6                :in     std_logic := '1'; 
        address_7           :in     std_logic_vector (address_width-1 downto 0); 
        data_in_7           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); 
        data_out_7          :out    std_logic_vector (data_width-1 downto 0); 
        we_7                :in     std_logic := '0'; 
        oe_7                :in     std_logic := '1'; 
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

signal s16	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s30	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s42	: std_logic_vector(31 downto 0); 
signal s44	: std_logic_vector(31 downto 0); 
signal s48	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s54	: std_logic_vector(31 downto 0); 
signal s56	: std_logic_vector(31 downto 0); 
signal s60	: std_logic_vector(31 downto 0); 
signal s62	: std_logic_vector(31 downto 0); 
signal s63	: std_logic_vector(31 downto 0); 
signal s65	: std_logic_vector(0 downto 0); 
signal s67	: std_logic_vector(0 downto 0); 
signal s69	: std_logic_vector(0 downto 0); 
signal s71	: std_logic_vector(0 downto 0); 
signal s73	: std_logic_vector(0 downto 0); 
signal s75	: std_logic_vector(0 downto 0); 
signal s77	: std_logic_vector(0 downto 0); 
signal s78	: std_logic; 
signal s79	: std_logic_vector(0 downto 0); 
signal s80	: std_logic; 
signal s81	: std_logic; 
signal s82	: std_logic_vector(0 downto 0); 
signal s83	: std_logic_vector(31 downto 0); 
signal s84	: std_logic_vector(31 downto 0); 
signal s85	: std_logic_vector(31 downto 0); 
signal s86	: std_logic_vector(31 downto 0); 
signal s87	: std_logic_vector(31 downto 0); 
signal s88	: std_logic_vector(31 downto 0); 
signal s89	: std_logic_vector(31 downto 0); 
signal s90	: std_logic_vector(31 downto 0); 
signal s91	: std_logic_vector(31 downto 0); 
signal s92	: std_logic_vector(31 downto 0); 
signal s93	: std_logic_vector(31 downto 0); 
signal s94	: std_logic_vector(31 downto 0); 
signal s95	: std_logic_vector(31 downto 0); 
signal s96	: std_logic_vector(31 downto 0); 
signal s97	: std_logic_vector(31 downto 0); 
signal s99	: std_logic_vector(31 downto 0); 
signal s101	: std_logic_vector(31 downto 0); 
signal s103	: std_logic_vector(31 downto 0); 
signal s105	: std_logic_vector(31 downto 0); 
signal s107	: std_logic_vector(31 downto 0); 
signal s109	: std_logic_vector(31 downto 0); 
signal s111	: std_logic_vector(31 downto 0); 
signal s113	: std_logic_vector(31 downto 0); 
signal s114	: std_logic_vector(31 downto 0); 
signal s115	: std_logic_vector(31 downto 0); 
signal s116	: std_logic_vector(31 downto 0); 
signal s117	: std_logic_vector(31 downto 0); 
signal s118	: std_logic_vector(31 downto 0); 
signal s119	: std_logic_vector(31 downto 0); 
signal s120	: std_logic_vector(31 downto 0); 
signal s121	: std_logic_vector(31 downto 0); 
signal s122	: std_logic_vector(31 downto 0); 
signal s123	: std_logic_vector(31 downto 0); 
signal s124	: std_logic_vector(31 downto 0); 
signal s125	: std_logic_vector(31 downto 0); 
signal s126	: std_logic_vector(31 downto 0); 
signal s127	: std_logic_vector(31 downto 0); 
signal s128	: std_logic_vector(31 downto 0); 
signal s129	: std_logic_vector(31 downto 0); 

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
	clk_en => s80,
	done => s81,
	input => s63,
	output => s114,
	reset => \reset\,
	step => s78,
	termination => s62
);

\sum\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s83,
	I1 => s16,
	O0 => s83,
	clk => \clk\,
	reset => \reset\,
	we => s65(0)
);

\a_mult_op_s_b\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s99,
	I1 => s115,
	O0 => s16
);

\sum_12\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s84,
	I1 => s20,
	O0 => s84,
	clk => \clk\,
	reset => \reset\,
	we => s67(0)
);

\a_14_mult_op_s_b_18\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s101,
	I1 => s117,
	O0 => s20
);

\i_16_add_op_s_num_17\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s24,
	O0 => s116
);

\sum_20\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s85,
	I1 => s26,
	O0 => s85,
	clk => \clk\,
	reset => \reset\,
	we => s69(0)
);

\a_22_mult_op_s_b_26\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s103,
	I1 => s119,
	O0 => s26
);

\i_24_add_op_s_num_25\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s30,
	O0 => s118
);

\sum_28\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s86,
	I1 => s32,
	O0 => s86,
	clk => \clk\,
	reset => \reset\,
	we => s71(0)
);

\a_30_mult_op_s_b_34\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s105,
	I1 => s121,
	O0 => s32
);

\i_32_add_op_s_num_33\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s36,
	O0 => s120
);

\sum_36\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s87,
	I1 => s38,
	O0 => s87,
	clk => \clk\,
	reset => \reset\,
	we => s73(0)
);

\a_38_mult_op_s_b_42\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s107,
	I1 => s123,
	O0 => s38
);

\i_40_add_op_s_num_41\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s42,
	O0 => s122
);

\sum_44\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s88,
	I1 => s44,
	O0 => s88,
	clk => \clk\,
	reset => \reset\,
	we => s75(0)
);

\a_46_mult_op_s_b_50\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s109,
	I1 => s125,
	O0 => s44
);

\i_48_add_op_s_num_49\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s48,
	O0 => s124
);

\sum_52\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s89,
	I1 => s50,
	O0 => s89,
	clk => \clk\,
	reset => \reset\,
	we => s77(0)
);

\a_54_mult_op_s_b_58\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s111,
	I1 => s127,
	O0 => s50
);

\i_56_add_op_s_num_57\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s54,
	O0 => s126
);

\sum_60\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s90,
	I1 => s56,
	O0 => s90,
	clk => \clk\,
	reset => \reset\,
	we => s79(0)
);

\a_62_mult_op_s_b_66\: mult_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s113,
	I1 => s129,
	O0 => s56
);

\i_64_add_op_s_num_65\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s114,
	I1 => s60,
	O0 => s128
);

\dly_72\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s65,
	clk => \clk\,
	reset => \reset\
);

\dly_73\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s67,
	clk => \clk\,
	reset => \reset\
);

\dly_74\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s69,
	clk => \clk\,
	reset => \reset\
);

\dly_75\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s71,
	clk => \clk\,
	reset => \reset\
);

\dly_76\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s73,
	clk => \clk\,
	reset => \reset\
);

\dly_77\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s75,
	clk => \clk\,
	reset => \reset\
);

\dly_78\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s77,
	clk => \clk\,
	reset => \reset\
);

\dly_79\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s78,
	a_delayed => s79,
	clk => \clk\,
	reset => \reset\
);

\dly_80\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s81,
	a_delayed => s82,
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
	I0 => s83,
	I1 => s84,
	O0 => s91
);

\sum_20_add_op_s_sum_28\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s85,
	I1 => s86,
	O0 => s92
);

\sum_36_add_op_s_sum_44\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s87,
	I1 => s88,
	O0 => s93
);

\sum_52_add_op_s_sum_60\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s89,
	I1 => s90,
	O0 => s94
);

\sum_add_op_s_sum_12_add_op_s_sum_20_add_op_s_sum_28\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s91,
	I1 => s92,
	O0 => s95
);

\sum_36_add_op_s_sum_44_add_op_s_sum_52_add_op_s_sum_60\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s93,
	I1 => s94,
	O0 => s96
);

\sum_add_op_s_sum_12_add_op_s_sum_20_add_op_s_sum_28_add_op_s_sum_36_add_op_s_sum_44_add_op_s_sum_52_add_op_s_sum_60\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s95,
	I1 => s96,
	O0 => s97
);

\a\: block_ram_mult_a
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s114(10 downto 0),
	data_out_0 => s99,
	address_1(10 downto 0) => s116(10 downto 0),
	data_out_1 => s101,
	address_2(10 downto 0) => s118(10 downto 0),
	data_out_2 => s103,
	address_3(10 downto 0) => s120(10 downto 0),
	data_out_3 => s105,
	address_4(10 downto 0) => s122(10 downto 0),
	data_out_4 => s107,
	address_5(10 downto 0) => s124(10 downto 0),
	data_out_5 => s109,
	address_6(10 downto 0) => s126(10 downto 0),
	data_out_6 => s111,
	address_7(10 downto 0) => s128(10 downto 0),
	data_out_7 => s113,
	clk => \clk\
);

\b\: block_ram_mult_b
generic map ( 
	address_width => 11,
	data_width => 32
)
port map ( 
	address_0(10 downto 0) => s114(10 downto 0),
	data_out_0 => s115,
	address_1(10 downto 0) => s116(10 downto 0),
	data_out_1 => s117,
	address_2(10 downto 0) => s118(10 downto 0),
	data_out_2 => s119,
	address_3(10 downto 0) => s120(10 downto 0),
	data_out_3 => s121,
	address_4(10 downto 0) => s122(10 downto 0),
	data_out_4 => s123,
	address_5(10 downto 0) => s124(10 downto 0),
	data_out_5 => s125,
	address_6(10 downto 0) => s126(10 downto 0),
	data_out_6 => s127,
	address_7(10 downto 0) => s128(10 downto 0),
	data_out_7 => s129,
	clk => \clk\
);

s24 <= conv_std_logic_vector(1, 32);
s30 <= conv_std_logic_vector(2, 32);
s36 <= conv_std_logic_vector(3, 32);
s42 <= conv_std_logic_vector(4, 32);
s48 <= conv_std_logic_vector(5, 32);
s54 <= conv_std_logic_vector(6, 32);
s60 <= conv_std_logic_vector(7, 32);
s80 <= \init\;
\done\ <= s82(0);
s62 <= conv_std_logic_vector(2047, 32);
s63 <= conv_std_logic_vector(0, 32);
\result\ <= s97;
end behavior; 