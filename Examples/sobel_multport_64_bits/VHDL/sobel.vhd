library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity sobel is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\out_142\	: out	std_logic_vector(63 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end sobel; 

architecture behavior of sobel is 

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

component block_ram_mult_in 
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

component if_lt_op_s 
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

component neg_op_s 
generic ( 
        w_in        : integer := 16;
        w_out       : integer := 16 
); 
port ( 
        I0		: in	std_logic_vector(w_in-1 downto 0); 
        O0		: out	std_logic_vector(w_out-1 downto 0) 
); 
end component; 

component reg_mux_op 
generic ( 
        w_in	: integer := 16; 
        initial	: integer := 0 
); 
port ( 
        clk         : in	std_logic; 
        reset       : in	std_logic; 
        we          : in	std_logic := '1'; 
        Sel1	: in	std_logic_vector(0 downto 0);
        I0          : in	std_logic_vector(w_in-1 downto 0); 
        I1          : in	std_logic_vector(w_in-1 downto 0); 
        O0          : out	std_logic_vector(w_in-1 downto 0) 
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

component sub_op_s 
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

signal s9	: std_logic_vector(63 downto 0); 
signal s11	: std_logic_vector(63 downto 0); 
signal s13	: std_logic_vector(63 downto 0); 
signal s18	: std_logic_vector(63 downto 0); 
signal s21	: std_logic_vector(63 downto 0); 
signal s24	: std_logic_vector(63 downto 0); 
signal s27	: std_logic_vector(63 downto 0); 
signal s30	: std_logic_vector(63 downto 0); 
signal s33	: std_logic_vector(63 downto 0); 
signal s36	: std_logic_vector(63 downto 0); 
signal s37	: std_logic_vector(63 downto 0); 
signal s38	: std_logic_vector(63 downto 0); 
signal s39	: std_logic_vector(63 downto 0); 
signal s41	: std_logic_vector(63 downto 0); 
signal s42	: std_logic_vector(63 downto 0); 
signal s45	: std_logic_vector(63 downto 0); 
signal s46	: std_logic_vector(63 downto 0); 
signal s47	: std_logic_vector(63 downto 0); 
signal s50	: std_logic_vector(63 downto 0); 
signal s51	: std_logic_vector(63 downto 0); 
signal s55	: std_logic_vector(63 downto 0); 
signal s56	: std_logic_vector(63 downto 0); 
signal s57	: std_logic_vector(63 downto 0); 
signal s60	: std_logic_vector(63 downto 0); 
signal s61	: std_logic_vector(63 downto 0); 
signal s62	: std_logic_vector(63 downto 0); 
signal s63	: std_logic_vector(63 downto 0); 
signal s66	: std_logic_vector(63 downto 0); 
signal s69	: std_logic_vector(63 downto 0); 
signal s70	: std_logic_vector(63 downto 0); 
signal s77	: std_logic_vector(63 downto 0); 
signal s82	: std_logic_vector(63 downto 0); 
signal s84	: std_logic_vector(0 downto 0); 
signal s85	: std_logic_vector(63 downto 0); 
signal s87	: std_logic_vector(0 downto 0); 
signal s88	: std_logic_vector(63 downto 0); 
signal s90	: std_logic_vector(0 downto 0); 
signal s92	: std_logic_vector(63 downto 0); 
signal s94	: std_logic_vector(63 downto 0); 
signal s96	: std_logic_vector(63 downto 0); 
signal s98	: std_logic_vector(63 downto 0); 
signal s100	: std_logic_vector(63 downto 0); 
signal s102	: std_logic_vector(63 downto 0); 
signal s104	: std_logic_vector(63 downto 0); 
signal s106	: std_logic_vector(63 downto 0); 
signal s108	: std_logic_vector(63 downto 0); 
signal s109	: std_logic_vector(63 downto 0); 
signal s111	: std_logic_vector(63 downto 0); 
signal s112	: std_logic_vector(63 downto 0); 
signal s113	: std_logic_vector(63 downto 0); 
signal s114	: std_logic_vector(63 downto 0); 
signal s115	: std_logic_vector(63 downto 0); 
signal s116	: std_logic_vector(63 downto 0); 
signal s117	: std_logic_vector(63 downto 0); 
signal s119	: std_logic_vector(0 downto 0); 
signal s121	: std_logic_vector(0 downto 0); 
signal s123	: std_logic_vector(0 downto 0); 
signal s125	: std_logic_vector(0 downto 0); 
signal s127	: std_logic_vector(0 downto 0); 
signal s129	: std_logic_vector(0 downto 0); 
signal s131	: std_logic_vector(0 downto 0); 
signal s133	: std_logic_vector(0 downto 0); 
signal s135	: std_logic_vector(0 downto 0); 
signal s137	: std_logic_vector(0 downto 0); 
signal s139	: std_logic_vector(0 downto 0); 
signal s141	: std_logic_vector(0 downto 0); 
signal s143	: std_logic_vector(0 downto 0); 
signal s145	: std_logic_vector(0 downto 0); 
signal s146	: std_logic; 
signal s147	: std_logic_vector(0 downto 0); 
signal s148	: std_logic; 
signal s149	: std_logic; 
signal s150	: std_logic_vector(0 downto 0); 
signal s151	: std_logic_vector(63 downto 0); 
signal s152	: std_logic_vector(63 downto 0); 
signal s153	: std_logic_vector(63 downto 0); 
signal s154	: std_logic_vector(63 downto 0); 
signal s155	: std_logic_vector(63 downto 0); 
signal s156	: std_logic_vector(63 downto 0); 
signal s157	: std_logic_vector(63 downto 0); 
signal s158	: std_logic_vector(63 downto 0); 
signal s159	: std_logic_vector(63 downto 0); 
signal s160	: std_logic_vector(63 downto 0); 
signal s161	: std_logic_vector(63 downto 0); 
signal s162	: std_logic_vector(63 downto 0); 
signal s163	: std_logic_vector(63 downto 0); 
signal s164	: std_logic_vector(63 downto 0); 
signal s165	: std_logic_vector(63 downto 0); 
signal s166	: std_logic_vector(63 downto 0); 
signal s167	: std_logic_vector(63 downto 0); 

begin 

\i\: counter
generic map ( 
	bits => 64,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 1
)
port map ( 
	clk => \clk\,
	clk_en => s148,
	done => s149,
	input => s116,
	output => s152,
	reset => \reset\,
	step => s146,
	termination => s115
);

\i00\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s153,
	O0 => s92,
	reset => \reset\,
	we => s121(0)
);

\i01\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s155,
	O0 => s94,
	reset => \reset\,
	we => s123(0)
);

\i_21_add_op_s_num_22\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s18,
	O0 => s154
);

\i02\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s157,
	O0 => s96,
	reset => \reset\,
	we => s125(0)
);

\i_26_add_op_s_num_27\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s21,
	O0 => s156
);

\i10\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s159,
	O0 => s98,
	reset => \reset\,
	we => s127(0)
);

\i_31_add_op_s_num_32\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s24,
	O0 => s158
);

\i12\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s161,
	O0 => s100,
	reset => \reset\,
	we => s129(0)
);

\i_36_add_op_s_num_37\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s27,
	O0 => s160
);

\i20\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s163,
	O0 => s102,
	reset => \reset\,
	we => s131(0)
);

\i_41_add_op_s_num_42\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s30,
	O0 => s162
);

\i21\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s165,
	O0 => s104,
	reset => \reset\,
	we => s133(0)
);

\i_46_add_op_s_num_47\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s33,
	O0 => s164
);

\i22\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s167,
	O0 => s106,
	reset => \reset\,
	we => s135(0)
);

\i_51_add_op_s_num_52\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s152,
	I1 => s36,
	O0 => s166
);

\H\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s37,
	O0 => s108,
	reset => \reset\,
	we => s137(0)
);

\comp_55_add_op_s_comp_62\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s38,
	I1 => s45,
	O0 => s37
);

\comp_56_add_op_s_comp_58\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s39,
	I1 => s41,
	O0 => s38
);

\i00_57_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s92,
	O0 => s39
);

\comp_59_sub_op_s_i01_61\: sub_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s42,
	I1 => s94,
	O0 => s41
);

\i01_60_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s94,
	O0 => s42
);

\comp_63_add_op_s_comp_67\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s46,
	I1 => s50,
	O0 => s45
);

\comp_64_add_op_s_i20_66\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s47,
	I1 => s102,
	O0 => s46
);

\i02_65_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s96,
	O0 => s47
);

\comp_68_add_op_s_i22_71\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s51,
	I1 => s106,
	O0 => s50
);

\i21_69_add_op_s_i21_70\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s104,
	I1 => s104,
	O0 => s51
);

\V\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s55,
	O0 => s111,
	reset => \reset\,
	we => s139(0)
);

\comp_74_add_op_s_comp_78\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s56,
	I1 => s60,
	O0 => s55
);

\comp_75_add_op_s_i02_77\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s57,
	I1 => s96,
	O0 => s56
);

\i00_76_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s92,
	O0 => s57
);

\comp_79_add_op_s_comp_87\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s61,
	I1 => s69,
	O0 => s60
);

\comp_80_add_op_s_comp_84\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s62,
	I1 => s66,
	O0 => s61
);

\comp_81_sub_op_s_i10_83\: sub_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s63,
	I1 => s98,
	O0 => s62
);

\i10_82_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s98,
	O0 => s63
);

\i12_85_add_op_s_i12_86\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s100,
	I1 => s100,
	O0 => s66
);

\comp_88_add_op_s_i22_90\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s70,
	I1 => s106,
	O0 => s69
);

\i20_89_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s102,
	O0 => s70
);

\if_lt_op_s_91\: if_lt_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 1
)
port map ( 
	I0 => s108,
	I1 => s9,
	O0 => s84
);

\H_96_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s108,
	O0 => s82
);

\if_lt_op_s_97\: if_lt_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 1
)
port map ( 
	I0 => s111,
	I1 => s11,
	O0 => s87
);

\V_102_neg_op_s\: neg_op_s
generic map ( 
	w_in => 64,
	w_out => 64
)
port map ( 
	I0 => s111,
	O0 => s85
);

\O\: reg_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s77,
	O0 => s113,
	reset => \reset\,
	we => s141(0)
);

\H_105_add_op_s_V_106\: add_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 64
)
port map ( 
	I0 => s109,
	I1 => s112,
	O0 => s77
);

\H_115\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s108,
	I1 => s82,
	O0 => s109,
	reset => \reset\,
	Sel1 => s84,
	we => s143(0)
);

\V_117\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s111,
	I1 => s85,
	O0 => s112,
	reset => \reset\,
	Sel1 => s87,
	we => s145(0)
);

\if_gt_op_s_107\: if_gt_op_s
generic map ( 
	w_in1 => 64,
	w_in2 => 64,
	w_out => 1
)
port map ( 
	I0 => s113,
	I1 => s13,
	O0 => s90
);

\out\: block_ram
generic map ( 
	address_width => 7,
	data_width => 64
)
port map ( 
	address(6 downto 0) => s117(6 downto 0),
	clk => \clk\,
	data_in => s114,
	data_out => s151,
	we => s119(0)
);

\O_119\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 64
)
port map ( 
	clk => \clk\,
	I0 => s113,
	I1 => s88,
	O0 => s114,
	reset => \reset\,
	Sel1 => s90,
	we => s147(0)
);

\dly_125\: delay_op
generic map ( 
	bits => 64,
	delay => 7
)
port map ( 
	a => s152,
	a_delayed => s117,
	clk => \clk\,
	reset => \reset\
);

\dly_126\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s146,
	a_delayed => s119,
	clk => \clk\,
	reset => \reset\
);

\dly_127\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s121,
	clk => \clk\,
	reset => \reset\
);

\dly_128\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s123,
	clk => \clk\,
	reset => \reset\
);

\dly_129\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s125,
	clk => \clk\,
	reset => \reset\
);

\dly_130\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s127,
	clk => \clk\,
	reset => \reset\
);

\dly_131\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s129,
	clk => \clk\,
	reset => \reset\
);

\dly_132\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s131,
	clk => \clk\,
	reset => \reset\
);

\dly_133\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s133,
	clk => \clk\,
	reset => \reset\
);

\dly_134\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s146,
	a_delayed => s135,
	clk => \clk\,
	reset => \reset\
);

\dly_135\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s146,
	a_delayed => s137,
	clk => \clk\,
	reset => \reset\
);

\dly_136\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s146,
	a_delayed => s139,
	clk => \clk\,
	reset => \reset\
);

\dly_137\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s146,
	a_delayed => s141,
	clk => \clk\,
	reset => \reset\
);

\dly_138\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s146,
	a_delayed => s143,
	clk => \clk\,
	reset => \reset\
);

\dly_139\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s146,
	a_delayed => s145,
	clk => \clk\,
	reset => \reset\
);

\dly_140\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s146,
	a_delayed => s147,
	clk => \clk\,
	reset => \reset\
);

\dly_141\: delay_op
generic map ( 
	bits => 1,
	delay => 9
)
port map ( 
	a(0) => s149,
	a_delayed => s150,
	clk => \clk\,
	reset => \reset\
);

\in\: block_ram_mult_in
generic map ( 
	address_width => 7,
	data_width => 64
)
port map ( 
	address_0(6 downto 0) => s152(6 downto 0),
	data_out_0 => s153,
	address_1(6 downto 0) => s154(6 downto 0),
	data_out_1 => s155,
	address_2(6 downto 0) => s156(6 downto 0),
	data_out_2 => s157,
	address_3(6 downto 0) => s158(6 downto 0),
	data_out_3 => s159,
	address_4(6 downto 0) => s160(6 downto 0),
	data_out_4 => s161,
	address_5(6 downto 0) => s162(6 downto 0),
	data_out_5 => s163,
	address_6(6 downto 0) => s164(6 downto 0),
	data_out_6 => s165,
	address_7(6 downto 0) => s166(6 downto 0),
	data_out_7 => s167,
	clk => \clk\
);

s18 <= conv_std_logic_vector(1, 64);
s21 <= conv_std_logic_vector(2, 64);
s24 <= conv_std_logic_vector(10, 64);
s27 <= conv_std_logic_vector(12, 64);
s30 <= conv_std_logic_vector(20, 64);
s33 <= conv_std_logic_vector(21, 64);
s36 <= conv_std_logic_vector(22, 64);
s9 <= conv_std_logic_vector(0, 64);
s11 <= conv_std_logic_vector(0, 64);
s13 <= conv_std_logic_vector(255, 64);
s88 <= conv_std_logic_vector(255, 64);
s148 <= \init\;
\done\ <= s150(0);
s115 <= conv_std_logic_vector(78, 64);
s116 <= conv_std_logic_vector(0, 64);
\out_142\ <= s151;
end behavior; 