library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity sobel is 
port ( 
	\clear\  : in	 std_logic; 
	\clk\    : in	 std_logic; 
	\done\   : out std_logic; 
	\init\   : in	 std_logic; 
	\reset\  : in	 std_logic; 
	\result\ : out std_logic_vector(31 downto 0) 
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

signal s9	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s161	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s21	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s30	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s37	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s39	: std_logic_vector(31 downto 0); 
signal s41	: std_logic_vector(31 downto 0); 
signal s42	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s47	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s51	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s56	: std_logic_vector(31 downto 0); 
signal s57	: std_logic_vector(31 downto 0); 
signal s60	: std_logic_vector(31 downto 0); 
signal s61	: std_logic_vector(31 downto 0); 
signal s62	: std_logic_vector(31 downto 0); 
signal s63	: std_logic_vector(31 downto 0); 
signal s66	: std_logic_vector(31 downto 0); 
signal s69	: std_logic_vector(31 downto 0); 
signal s70	: std_logic_vector(31 downto 0); 
signal s73	: std_logic_vector(31 downto 0); 
signal s75	: std_logic_vector(31 downto 0); 
signal s77	: std_logic_vector(31 downto 0); 
signal s80	: std_logic_vector(31 downto 0); 
signal s82	: std_logic_vector(31 downto 0); 
signal s108	: std_logic_vector(31 downto 0); 
signal s84	: std_logic_vector(0 downto 0); 
signal s85	: std_logic_vector(31 downto 0); 
signal s111	: std_logic_vector(31 downto 0); 
signal s87	: std_logic_vector(0 downto 0); 
signal s88	: std_logic_vector(31 downto 0); 
signal s113	: std_logic_vector(31 downto 0); 
signal s90	: std_logic_vector(0 downto 0); 
signal s92	: std_logic_vector(31 downto 0); 
signal s94	: std_logic_vector(31 downto 0); 
signal s96	: std_logic_vector(31 downto 0); 
signal s98	: std_logic_vector(31 downto 0); 
signal s100	: std_logic_vector(31 downto 0); 
signal s102	: std_logic_vector(31 downto 0); 
signal s104	: std_logic_vector(31 downto 0); 
signal s106	: std_logic_vector(31 downto 0); 
signal s109	: std_logic_vector(31 downto 0); 
signal s112	: std_logic_vector(31 downto 0); 
signal s114	: std_logic_vector(31 downto 0); 
signal s136	: std_logic; 
signal s133	: std_logic_vector(31 downto 0); 
signal s134	: std_logic_vector(31 downto 0); 
signal s135	: std_logic_vector(31 downto 0); 
signal s137	: std_logic_vector(0 downto 0); 
signal s138	: std_logic_vector(0 downto 0); 
signal s139	: std_logic_vector(0 downto 0); 
signal s140	: std_logic_vector(0 downto 0); 
signal s141	: std_logic_vector(0 downto 0); 
signal s142	: std_logic_vector(0 downto 0); 
signal s143	: std_logic_vector(0 downto 0); 
signal s144	: std_logic_vector(0 downto 0); 
signal s145	: std_logic_vector(0 downto 0); 
signal s146	: std_logic_vector(0 downto 0); 
signal s147	: std_logic_vector(0 downto 0); 
signal s148	: std_logic_vector(0 downto 0); 
signal s149	: std_logic_vector(0 downto 0); 
signal s150	: std_logic_vector(0 downto 0); 
signal s151	: std_logic_vector(0 downto 0); 
signal s152	: std_logic_vector(0 downto 0); 
signal s153	: std_logic_vector(0 downto 0); 
signal s154	: std_logic_vector(0 downto 0); 
signal s155	: std_logic; 
signal s156	: std_logic; 
signal s157	: std_logic_vector(0 downto 0); 
signal s158	: std_logic_vector(31 downto 0); 
signal s159	: std_logic_vector(0 downto 0); 
signal s160	: std_logic_vector(0 downto 0); 
signal s162	: std_logic_vector(31 downto 0); 
signal s163	: std_logic_vector(31 downto 0); 
signal s164	: std_logic_vector(31 downto 0); 
signal s165	: std_logic_vector(31 downto 0); 
signal s166	: std_logic_vector(31 downto 0); 
signal s167	: std_logic_vector(31 downto 0); 
signal s168	: std_logic_vector(31 downto 0); 
signal s169	: std_logic_vector(31 downto 0); 
signal s170	: std_logic_vector(31 downto 0); 
signal s171	: std_logic_vector(31 downto 0); 
signal s172	: std_logic_vector(31 downto 0); 
signal s173	: std_logic_vector(31 downto 0); 
signal s174	: std_logic_vector(31 downto 0); 
signal s175	: std_logic_vector(31 downto 0); 
signal s176	: std_logic_vector(31 downto 0); 
signal s177	: std_logic_vector(31 downto 0); 

begin 

\CTD_15\: counter
generic map ( 
	bits => 32,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 1
)
port map ( 
	clk => \clk\,
	clk_en => s155,
	done => s156,
	input => s134,
	output => s161,
	reset => \reset\,
	step => s136,
	termination => s133
);

\i00\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s162,
	O0 => s92,
	reset => \reset\,
	we => s138(0)
);

\i01\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s164,
	O0 => s94,
	reset => \reset\,
	we => s139(0)
);

\i21_add_op_s_num_22\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s18,
	O0 => s163
);

\i02\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s166,
	O0 => s96,
	reset => \reset\,
	we => s140(0)
);

\i26_add_op_s_num_27\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s21,
	O0 => s165
);

\i10\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s168,
	O0 => s98,
	reset => \reset\,
	we => s141(0)
);

\i31_add_op_s_num_32\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s24,
	O0 => s167
);

\i12\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s170,
	O0 => s100,
	reset => \reset\,
	we => s142(0)
);

\i36_add_op_s_num_37\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s27,
	O0 => s169
);

\i20\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s172,
	O0 => s102,
	reset => \reset\,
	we => s143(0)
);

\i41_add_op_s_num_42\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s30,
	O0 => s171
);

\i21\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s174,
	O0 => s104,
	reset => \reset\,
	we => s144(0)
);

\i46_add_op_s_num_47\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s33,
	O0 => s173
);

\i22\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s176,
	O0 => s106,
	reset => \reset\,
	we => s145(0)
);

\i51_add_op_s_num_52\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s161,
	I1 => s36,
	O0 => s175
);

\H\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s37,
	O0 => s108,
	reset => \reset\,
	we => s146(0)
);

\comp_55_add_op_s_comp_62\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s38,
	I1 => s45,
	O0 => s37
);

\comp_56_add_op_s_comp_58\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s39,
	I1 => s41,
	O0 => s38
);

\i0057_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s92,
	O0 => s39
);

\comp_59_sub_op_s_i0161\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s42,
	I1 => s94,
	O0 => s41
);

\i0160_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s94,
	O0 => s42
);

\comp_63_add_op_s_comp_67\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s46,
	I1 => s50,
	O0 => s45
);

\comp_64_add_op_s_i2066\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s47,
	I1 => s102,
	O0 => s46
);

\i0265_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s96,
	O0 => s47
);

\comp_68_add_op_s_i2271\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s51,
	I1 => s106,
	O0 => s50
);

\i2169_add_op_s_i2170\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s104,
	I1 => s104,
	O0 => s51
);

\V\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s55,
	O0 => s111,
	reset => \reset\,
	we => s147(0)
);

\comp_74_add_op_s_comp_78\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s56,
	I1 => s60,
	O0 => s55
);

\comp_75_add_op_s_i0277\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s57,
	I1 => s96,
	O0 => s56
);

\i0076_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s92,
	O0 => s57
);

\comp_79_add_op_s_comp_87\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s61,
	I1 => s69,
	O0 => s60
);

\comp_80_add_op_s_comp_84\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s62,
	I1 => s66,
	O0 => s61
);

\comp_81_sub_op_s_i1083\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s63,
	I1 => s98,
	O0 => s62
);

\i1082_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s98,
	O0 => s63
);

\i1285_add_op_s_i1286\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s100,
	I1 => s100,
	O0 => s66
);

\comp_88_add_op_s_i2290\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s70,
	I1 => s106,
	O0 => s69
);

\i2089_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s102,
	O0 => s70
);

\if_lt_op_s_91\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s108,
	I1 => s9,
	O0 => s84
);

\H94\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s73,
	O0 => s82,
	reset => \reset\,
	we => s148(0)
);

\H96_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s108,
	O0 => s73
);

\reg_mux_H115\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s108,
	I1 => s82,
	O0 => s109,
	reset => \reset\,
	Sel1 => s84,
	we => s149(0)
);

\if_lt_op_s_97\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s111,
	I1 => s11,
	O0 => s87
);

\V100\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s75,
	O0 => s85,
	reset => \reset\,
	we => s150(0)
);

\V102_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s111,
	O0 => s75
);

\reg_mux_V136\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s158,
	I1 => s85,
	O0 => s112,
	reset => \reset\,
	Sel1 => s159,
	we => s151(0)
);

\O\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s77,
	O0 => s113,
	reset => \reset\,
	we => s152(0)
);

\H105_add_op_s_V106\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s109,
	I1 => s112,
	O0 => s77
);

\if_gt_op_s_107\: if_gt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s113,
	I1 => s13,
	O0 => s90
);

\O110\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s80,
	O0 => s88,
	reset => \reset\,
	we => s153(0)
);

\reg_mux_O151\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s113,
	I1 => s88,
	O0 => s114,
	reset => \reset\,
	Sel1 => s90,
	we => s154(0)
);

\out\: block_ram
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address(6 downto 0) => s135(6 downto 0),
	clk => \clk\,
	data_in => s114,
	data_out => s177,
	we => s160(0)
);

\dly_161\: delay_op
generic map ( 
	bits => 32,
	delay => 10
)
port map ( 
	a => s161,
	a_delayed => s135,
	clk => \clk\,
	reset => \reset\
);

\dly_162\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s136,
	a_delayed => s137,
	clk => \clk\,
	reset => \reset\
);

\dly_163\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s138,
	clk => \clk\,
	reset => \reset\
);

\dly_164\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s139,
	clk => \clk\,
	reset => \reset\
);

\dly_165\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s140,
	clk => \clk\,
	reset => \reset\
);

\dly_166\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s141,
	clk => \clk\,
	reset => \reset\
);

\dly_167\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s142,
	clk => \clk\,
	reset => \reset\
);

\dly_168\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s143,
	clk => \clk\,
	reset => \reset\
);

\dly_169\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s144,
	clk => \clk\,
	reset => \reset\
);

\dly_170\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s136,
	a_delayed => s145,
	clk => \clk\,
	reset => \reset\
);

\dly_171\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s136,
	a_delayed => s146,
	clk => \clk\,
	reset => \reset\
);

\dly_172\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s136,
	a_delayed => s147,
	clk => \clk\,
	reset => \reset\
);

\dly_173\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s136,
	a_delayed => s148,
	clk => \clk\,
	reset => \reset\
);

\dly_174\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s136,
	a_delayed => s149,
	clk => \clk\,
	reset => \reset\
);

\dly_175\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s136,
	a_delayed => s150,
	clk => \clk\,
	reset => \reset\
);

\dly_176\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s136,
	a_delayed => s151,
	clk => \clk\,
	reset => \reset\
);

\dly_177\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s136,
	a_delayed => s152,
	clk => \clk\,
	reset => \reset\
);

\dly_178\: delay_op
generic map ( 
	bits => 1,
	delay => 8
)
port map ( 
	a(0) => s136,
	a_delayed => s153,
	clk => \clk\,
	reset => \reset\
);

\dly_179\: delay_op
generic map ( 
	bits => 1,
	delay => 9
)
port map ( 
	a(0) => s136,
	a_delayed => s154,
	clk => \clk\,
	reset => \reset\
);

\dly_180\: delay_op
generic map ( 
	bits => 1,
	delay => 13
)
port map ( 
	a(0) => s156,
	a_delayed => s157,
	clk => \clk\,
	reset => \reset\
);

\dly_181\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s111,
	a_delayed => s158,
	clk => \clk\,
	reset => \reset\
);

\dly_182\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a => s87,
	a_delayed => s159,
	clk => \clk\,
	reset => \reset\
);

\dly_183\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s136,
	a_delayed => s160,
	clk => \clk\,
	reset => \reset\
);

\in\: block_ram_mult_in
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address_0(6 downto 0) => s161(6 downto 0),
	data_out_0 => s162,
	address_1(6 downto 0) => s163(6 downto 0),
	data_out_1 => s164,
	address_2(6 downto 0) => s165(6 downto 0),
	data_out_2 => s166,
	address_3(6 downto 0) => s167(6 downto 0),
	data_out_3 => s168,
	address_4(6 downto 0) => s169(6 downto 0),
	data_out_4 => s170,
	address_5(6 downto 0) => s171(6 downto 0),
	data_out_5 => s172,
	address_6(6 downto 0) => s173(6 downto 0),
	data_out_6 => s174,
	address_7(6 downto 0) => s175(6 downto 0),
	data_out_7 => s176,
	clk => \clk\
);

s18 <= conv_std_logic_vector(1, 32); 
s21 <= conv_std_logic_vector(2, 32); 
s24 <= conv_std_logic_vector(10, 32); 
s27 <= conv_std_logic_vector(12, 32); 
s30 <= conv_std_logic_vector(20, 32); 
s33 <= conv_std_logic_vector(21, 32); 
s36 <= conv_std_logic_vector(22, 32); 
s9 <= conv_std_logic_vector(0, 32); 
s11 <= conv_std_logic_vector(0, 32); 
s13 <= conv_std_logic_vector(255, 32); 
s80 <= conv_std_logic_vector(255, 32); 
s155 <= \init\; 
\done\ <= s157(0); 
s133 <= conv_std_logic_vector(78, 32); 
s134 <= conv_std_logic_vector(0, 32); 
\result\ <= s177; 
end behavior; 