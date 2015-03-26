library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity sobel is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
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

component block_ram_in 
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

component mux_m_op 
generic ( 
        w_in	: integer := 32;
        N_ops	: integer := 32;
        N_sels	: integer := 31
); 
port ( 
        I0          : in	std_logic_vector((w_in*N_ops)-1 downto 0);
        Sel         : in	std_logic_vector(N_sels-1 downto 0);
        O0          : out	std_logic_vector(w_in-1 downto 0)
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
signal s77	: std_logic_vector(31 downto 0); 
signal s82	: std_logic_vector(31 downto 0); 
signal s84	: std_logic_vector(0 downto 0); 
signal s85	: std_logic_vector(31 downto 0); 
signal s87	: std_logic_vector(0 downto 0); 
signal s88	: std_logic_vector(31 downto 0); 
signal s90	: std_logic_vector(0 downto 0); 
signal s92	: std_logic_vector(31 downto 0); 
signal s94	: std_logic_vector(31 downto 0); 
signal s96	: std_logic_vector(31 downto 0); 
signal s98	: std_logic_vector(31 downto 0); 
signal s100	: std_logic_vector(31 downto 0); 
signal s102	: std_logic_vector(31 downto 0); 
signal s104	: std_logic_vector(31 downto 0); 
signal s106	: std_logic_vector(31 downto 0); 
signal s108	: std_logic_vector(31 downto 0); 
signal s109	: std_logic_vector(31 downto 0); 
signal s111	: std_logic_vector(31 downto 0); 
signal s112	: std_logic_vector(31 downto 0); 
signal s113	: std_logic_vector(31 downto 0); 
signal s114	: std_logic_vector(31 downto 0); 
signal s115	: std_logic_vector(31 downto 0); 
signal s116	: std_logic_vector(31 downto 0); 
signal s118	: std_logic_vector(0 downto 0); 
signal s119	: std_logic_vector(31 downto 0); 
signal s120	: std_logic_vector(31 downto 0); 
signal s121	: std_logic_vector(31 downto 0); 
signal s124	: std_logic_vector(0 downto 0); 
signal s125	: std_logic_vector(31 downto 0); 
signal s128	: std_logic_vector(0 downto 0); 
signal s129	: std_logic_vector(31 downto 0); 
signal s132	: std_logic_vector(0 downto 0); 
signal s133	: std_logic_vector(31 downto 0); 
signal s136	: std_logic_vector(0 downto 0); 
signal s137	: std_logic_vector(31 downto 0); 
signal s140	: std_logic_vector(0 downto 0); 
signal s141	: std_logic_vector(31 downto 0); 
signal s144	: std_logic_vector(0 downto 0); 
signal s145	: std_logic_vector(31 downto 0); 
signal s146	: std_logic_vector(31 downto 0); 
signal s148	: std_logic_vector(0 downto 0); 
signal s149	: std_logic_vector(0 downto 0); 
signal s151	: std_logic_vector(0 downto 0); 
signal s153	: std_logic_vector(0 downto 0); 
signal s155	: std_logic_vector(0 downto 0); 
signal s157	: std_logic_vector(0 downto 0); 
signal s159	: std_logic_vector(0 downto 0); 
signal s161	: std_logic_vector(0 downto 0); 
signal s163	: std_logic_vector(31 downto 0); 
signal s165	: std_logic_vector(0 downto 0); 
signal s167	: std_logic_vector(0 downto 0); 
signal s169	: std_logic_vector(0 downto 0); 
signal s171	: std_logic_vector(0 downto 0); 
signal s173	: std_logic_vector(0 downto 0); 
signal s175	: std_logic_vector(0 downto 0); 
signal s176	: std_logic; 
signal s177	: std_logic_vector(0 downto 0); 
signal s178	: std_logic; 
signal s179	: std_logic; 
signal s180	: std_logic_vector(0 downto 0); 
signal s181	: std_logic_vector(31 downto 0); 
signal s182	: std_logic_vector(31 downto 0); 
signal s183	: std_logic_vector(31 downto 0); 
signal s184	: std_logic_vector(31 downto 0); 
signal s185	: std_logic_vector(31 downto 0); 
signal s186	: std_logic_vector(31 downto 0); 
signal s187	: std_logic_vector(31 downto 0); 
signal s188	: std_logic_vector(31 downto 0); 

begin 

\i\: counter
generic map ( 
	bits => 32,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 8
)
port map ( 
	clk => \clk\,
	clk_en => s178,
	done => s179,
	input => s116,
	output => s120,
	reset => \reset\,
	step => s176,
	termination => s115
);

\i00\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s92,
	reset => \reset\,
	we => s118(0)
);

\in\: block_ram_in
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address(6 downto 0) => s119(6 downto 0),
	clk => \clk\,
	data_out => s146
);

\i01\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s94,
	reset => \reset\,
	we => s124(0)
);

\i_21_add_op_s_num_22\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s18,
	O0 => s121
);

\i02\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s96,
	reset => \reset\,
	we => s128(0)
);

\i_26_add_op_s_num_27\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s21,
	O0 => s125
);

\i10\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s98,
	reset => \reset\,
	we => s132(0)
);

\i_31_add_op_s_num_32\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s24,
	O0 => s129
);

\i12\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s100,
	reset => \reset\,
	we => s136(0)
);

\i_36_add_op_s_num_37\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s27,
	O0 => s133
);

\i20\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s102,
	reset => \reset\,
	we => s140(0)
);

\i_41_add_op_s_num_42\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s30,
	O0 => s137
);

\i21\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s104,
	reset => \reset\,
	we => s144(0)
);

\i_46_add_op_s_num_47\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s33,
	O0 => s141
);

\i22\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s146,
	O0 => s106,
	reset => \reset\,
	we => s148(0)
);

\i_51_add_op_s_num_52\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s120,
	I1 => s36,
	O0 => s145
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
	we => s167(0)
);

\comp_55_add_op_s_comp_62\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s181,
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

\i00_57_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s92,
	O0 => s39
);

\comp_59_sub_op_s_i01_61\: sub_op_s
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

\i01_60_neg_op_s\: neg_op_s
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
	I0 => s182,
	I1 => s50,
	O0 => s45
);

\comp_64_add_op_s_i20_66\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s183,
	I1 => s102,
	O0 => s46
);

\i02_65_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s96,
	O0 => s47
);

\comp_68_add_op_s_i22_71\: add_op_s
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

\i21_69_add_op_s_i21_70\: add_op_s
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
	we => s169(0)
);

\comp_74_add_op_s_comp_78\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s184,
	I1 => s60,
	O0 => s55
);

\comp_75_add_op_s_i02_77\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s185,
	I1 => s96,
	O0 => s56
);

\i00_76_neg_op_s\: neg_op_s
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
	I0 => s186,
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

\comp_81_sub_op_s_i10_83\: sub_op_s
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

\i10_82_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s98,
	O0 => s63
);

\i12_85_add_op_s_i12_86\: add_op_s
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

\comp_88_add_op_s_i22_90\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s187,
	I1 => s106,
	O0 => s69
);

\i20_89_neg_op_s\: neg_op_s
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

\H_96_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s108,
	O0 => s82
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

\V_102_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s111,
	O0 => s85
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
	we => s171(0)
);

\H_105_add_op_s_V_106\: add_op_s
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

\H_115\: reg_mux_op
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
	we => s173(0)
);

\V_117\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s111,
	I1 => s85,
	O0 => s112,
	reset => \reset\,
	Sel1 => s87,
	we => s175(0)
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

\out\: block_ram
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address(6 downto 0) => s163(6 downto 0),
	clk => \clk\,
	data_in => s114,
	data_out => s188,
	we => s165(0)
);

\O_119\: reg_mux_op
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
	we => s177(0)
);

\mux125\: mux_m_op
generic map ( 
	N_ops => 8,
	N_sels => 7,
	w_in => 32
)
port map ( 
	I0(255 downto 224) => s120(31 downto 0),
	I0(223 downto 192) => s121(31 downto 0),
	I0(191 downto 160) => s125(31 downto 0),
	I0(159 downto 128) => s129(31 downto 0),
	I0(127 downto 96) => s133(31 downto 0),
	I0(95 downto 64) => s137(31 downto 0),
	I0(63 downto 32) => s141(31 downto 0),
	I0(31 downto 0) => s145(31 downto 0),
	O0 => s119,
	Sel(6 downto 6) => s149(0 downto 0),
	Sel(5 downto 5) => s151(0 downto 0),
	Sel(4 downto 4) => s153(0 downto 0),
	Sel(3 downto 3) => s155(0 downto 0),
	Sel(2 downto 2) => s157(0 downto 0),
	Sel(1 downto 1) => s159(0 downto 0),
	Sel(0 downto 0) => s161(0 downto 0)
);

\dly_126\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s176,
	a_delayed => s118,
	clk => \clk\,
	reset => \reset\
);

\dly_127\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s176,
	a_delayed => s124,
	clk => \clk\,
	reset => \reset\
);

\dly_128\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s176,
	a_delayed => s128,
	clk => \clk\,
	reset => \reset\
);

\dly_129\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s176,
	a_delayed => s132,
	clk => \clk\,
	reset => \reset\
);

\dly_130\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s176,
	a_delayed => s136,
	clk => \clk\,
	reset => \reset\
);

\dly_131\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s176,
	a_delayed => s140,
	clk => \clk\,
	reset => \reset\
);

\dly_132\: delay_op
generic map ( 
	bits => 1,
	delay => 8
)
port map ( 
	a(0) => s176,
	a_delayed => s144,
	clk => \clk\,
	reset => \reset\
);

\dly_133\: delay_op
generic map ( 
	bits => 1,
	delay => 9
)
port map ( 
	a(0) => s176,
	a_delayed => s148,
	clk => \clk\,
	reset => \reset\
);

\dly_134\: delay_op
generic map ( 
	bits => 1,
	delay => 1
)
port map ( 
	a(0) => s176,
	a_delayed => s149,
	clk => \clk\,
	reset => \reset\
);

\dly_135\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s176,
	a_delayed => s151,
	clk => \clk\,
	reset => \reset\
);

\dly_136\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s176,
	a_delayed => s153,
	clk => \clk\,
	reset => \reset\
);

\dly_137\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s176,
	a_delayed => s155,
	clk => \clk\,
	reset => \reset\
);

\dly_138\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s176,
	a_delayed => s157,
	clk => \clk\,
	reset => \reset\
);

\dly_139\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s176,
	a_delayed => s159,
	clk => \clk\,
	reset => \reset\
);

\dly_140\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s176,
	a_delayed => s161,
	clk => \clk\,
	reset => \reset\
);

\dly_141\: delay_op
generic map ( 
	bits => 32,
	delay => 14
)
port map ( 
	a => s120,
	a_delayed => s163,
	clk => \clk\,
	reset => \reset\
);

\dly_142\: delay_op
generic map ( 
	bits => 1,
	delay => 14
)
port map ( 
	a(0) => s176,
	a_delayed => s165,
	clk => \clk\,
	reset => \reset\
);

\dly_143\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s176,
	a_delayed => s167,
	clk => \clk\,
	reset => \reset\
);

\dly_144\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s176,
	a_delayed => s169,
	clk => \clk\,
	reset => \reset\
);

\dly_145\: delay_op
generic map ( 
	bits => 1,
	delay => 12
)
port map ( 
	a(0) => s176,
	a_delayed => s171,
	clk => \clk\,
	reset => \reset\
);

\dly_146\: delay_op
generic map ( 
	bits => 1,
	delay => 11
)
port map ( 
	a(0) => s176,
	a_delayed => s173,
	clk => \clk\,
	reset => \reset\
);

\dly_147\: delay_op
generic map ( 
	bits => 1,
	delay => 11
)
port map ( 
	a(0) => s176,
	a_delayed => s175,
	clk => \clk\,
	reset => \reset\
);

\dly_148\: delay_op
generic map ( 
	bits => 1,
	delay => 13
)
port map ( 
	a(0) => s176,
	a_delayed => s177,
	clk => \clk\,
	reset => \reset\
);

\dly_149\: delay_op
generic map ( 
	bits => 1,
	delay => 16
)
port map ( 
	a(0) => s179,
	a_delayed => s180,
	clk => \clk\,
	reset => \reset\
);

\dly_150\: delay_op
generic map ( 
	bits => 32,
	delay => 6
)
port map ( 
	a => s38,
	a_delayed => s181,
	clk => \clk\,
	reset => \reset\
);

\dly_151\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s46,
	a_delayed => s182,
	clk => \clk\,
	reset => \reset\
);

\dly_152\: delay_op
generic map ( 
	bits => 32,
	delay => 3
)
port map ( 
	a => s47,
	a_delayed => s183,
	clk => \clk\,
	reset => \reset\
);

\dly_153\: delay_op
generic map ( 
	bits => 32,
	delay => 5
)
port map ( 
	a => s56,
	a_delayed => s184,
	clk => \clk\,
	reset => \reset\
);

\dly_154\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s57,
	a_delayed => s185,
	clk => \clk\,
	reset => \reset\
);

\dly_155\: delay_op
generic map ( 
	bits => 32,
	delay => 3
)
port map ( 
	a => s61,
	a_delayed => s186,
	clk => \clk\,
	reset => \reset\
);

\dly_156\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s70,
	a_delayed => s187,
	clk => \clk\,
	reset => \reset\
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
s88 <= conv_std_logic_vector(255, 32);
s178 <= \init\;
\done\ <= s180(0);
s115 <= conv_std_logic_vector(78, 32);
s116 <= conv_std_logic_vector(0, 32);
\result\ <= s188;
end behavior; 