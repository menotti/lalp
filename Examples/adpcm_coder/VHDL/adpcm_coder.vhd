library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity adpcm_coder is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end adpcm_coder; 

architecture behavior of adpcm_coder is 

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

component and_op 
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

component block_ram_indata 
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

component block_ram_indexTable 
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

component block_ram_stepsizeTable 
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

component if_ge_op_s 
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

component if_ne_op_s 
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

component not_op 
generic ( 
        w_in        : integer := 16;
        w_out       : integer := 16 
); 
port ( 
        I0		: in	std_logic_vector(w_in-1 downto 0); 
        O0		: out	std_logic_vector(w_out-1 downto 0) 
); 
end component; 

component or_op 
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

component shl_c_op_s 
generic ( 
        w_in1       : integer := 16;
        w_out       : integer := 15; 
        s_amount    : integer := 1 
); 
port ( 
        I0		: in	std_logic_vector(w_in1-1 downto 0); 
        O0		: out	std_logic_vector(w_out-1 downto 0) 
); 
end component; 

component shr_c_op_s 
generic ( 
        w_in1       : integer := 16;
        w_out       : integer := 15; 
        s_amount    : integer := 1 
); 
port ( 
        I0		: in	std_logic_vector(w_in1-1 downto 0); 
        O0		: out	std_logic_vector(w_out-1 downto 0) 
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

signal s0	: std_logic_vector(31 downto 0); 
signal s2	: std_logic_vector(31 downto 0); 
signal s5	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s15	: std_logic_vector(31 downto 0); 
signal s17	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s22	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s26	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s32	: std_logic_vector(31 downto 0); 
signal s35	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s45	: std_logic_vector(31 downto 0); 
signal s49	: std_logic_vector(31 downto 0); 
signal s56	: std_logic_vector(31 downto 0); 
signal s60	: std_logic_vector(31 downto 0); 
signal s72	: std_logic_vector(31 downto 0); 
signal s75	: std_logic_vector(31 downto 0); 
signal s77	: std_logic_vector(31 downto 0); 
signal s80	: std_logic_vector(31 downto 0); 
signal s81	: std_logic_vector(31 downto 0); 
signal s83	: std_logic_vector(31 downto 0); 
signal s85	: std_logic_vector(31 downto 0); 
signal s87	: std_logic_vector(31 downto 0); 
signal s88	: std_logic_vector(31 downto 0); 
signal s90	: std_logic_vector(31 downto 0); 
signal s92	: std_logic_vector(0 downto 0); 
signal s94	: std_logic_vector(31 downto 0); 
signal s95	: std_logic_vector(31 downto 0); 
signal s96	: std_logic_vector(0 downto 0); 
signal s97	: std_logic_vector(31 downto 0); 
signal s99	: std_logic_vector(0 downto 0); 
signal s100	: std_logic_vector(31 downto 0); 
signal s101	: std_logic_vector(31 downto 0); 
signal s103	: std_logic_vector(31 downto 0); 
signal s106	: std_logic_vector(31 downto 0); 
signal s108	: std_logic_vector(0 downto 0); 
signal s109	: std_logic_vector(31 downto 0); 
signal s112	: std_logic_vector(31 downto 0); 
signal s115	: std_logic_vector(31 downto 0); 
signal s117	: std_logic_vector(0 downto 0); 
signal s118	: std_logic_vector(31 downto 0); 
signal s121	: std_logic_vector(31 downto 0); 
signal s123	: std_logic_vector(0 downto 0); 
signal s124	: std_logic_vector(31 downto 0); 
signal s125	: std_logic_vector(31 downto 0); 
signal s126	: std_logic_vector(0 downto 0); 
signal s127	: std_logic_vector(31 downto 0); 
signal s129	: std_logic_vector(0 downto 0); 
signal s130	: std_logic_vector(31 downto 0); 
signal s132	: std_logic_vector(0 downto 0); 
signal s133	: std_logic_vector(31 downto 0); 
signal s135	: std_logic_vector(0 downto 0); 
signal s136	: std_logic_vector(31 downto 0); 
signal s138	: std_logic_vector(0 downto 0); 
signal s140	: std_logic_vector(31 downto 0); 
signal s143	: std_logic_vector(31 downto 0); 
signal s145	: std_logic_vector(31 downto 0); 
signal s147	: std_logic_vector(31 downto 0); 
signal s149	: std_logic_vector(31 downto 0); 
signal s150	: std_logic_vector(31 downto 0); 
signal s152	: std_logic_vector(31 downto 0); 
signal s153	: std_logic_vector(31 downto 0); 
signal s154	: std_logic_vector(31 downto 0); 
signal s159	: std_logic_vector(31 downto 0); 
signal s163	: std_logic_vector(31 downto 0); 
signal s165	: std_logic_vector(31 downto 0); 
signal s166	: std_logic_vector(31 downto 0); 
signal s167	: std_logic_vector(31 downto 0); 
signal s168	: std_logic_vector(31 downto 0); 
signal s171	: std_logic_vector(31 downto 0); 
signal s172	: std_logic_vector(31 downto 0); 
signal s173	: std_logic_vector(31 downto 0); 
signal s174	: std_logic_vector(31 downto 0); 
signal s177	: std_logic_vector(31 downto 0); 
signal s178	: std_logic_vector(31 downto 0); 
signal s179	: std_logic_vector(31 downto 0); 
signal s180	: std_logic_vector(31 downto 0); 
signal s182	: std_logic_vector(31 downto 0); 
signal s184	: std_logic_vector(0 downto 0); 
signal s185	: std_logic_vector(31 downto 0); 
signal s186	: std_logic_vector(31 downto 0); 
signal s187	: std_logic_vector(31 downto 0); 
signal s189	: std_logic_vector(0 downto 0); 
signal s191	: std_logic_vector(0 downto 0); 
signal s193	: std_logic_vector(0 downto 0); 
signal s195	: std_logic_vector(0 downto 0); 
signal s197	: std_logic_vector(0 downto 0); 
signal s199	: std_logic_vector(0 downto 0); 
signal s201	: std_logic_vector(0 downto 0); 
signal s203	: std_logic_vector(0 downto 0); 
signal s205	: std_logic_vector(0 downto 0); 
signal s207	: std_logic_vector(0 downto 0); 
signal s209	: std_logic_vector(0 downto 0); 
signal s211	: std_logic_vector(0 downto 0); 
signal s213	: std_logic_vector(0 downto 0); 
signal s215	: std_logic_vector(0 downto 0); 
signal s217	: std_logic_vector(0 downto 0); 
signal s219	: std_logic_vector(0 downto 0); 
signal s221	: std_logic_vector(0 downto 0); 
signal s223	: std_logic_vector(0 downto 0); 
signal s225	: std_logic_vector(0 downto 0); 
signal s227	: std_logic_vector(0 downto 0); 
signal s229	: std_logic_vector(0 downto 0); 
signal s231	: std_logic_vector(0 downto 0); 
signal s234	: std_logic_vector(0 downto 0); 
signal s235	: std_logic_vector(0 downto 0); 
signal s237	: std_logic_vector(0 downto 0); 
signal s239	: std_logic_vector(0 downto 0); 
signal s241	: std_logic_vector(0 downto 0); 
signal s242	: std_logic_vector(0 downto 0); 
signal s243	: std_logic_vector(0 downto 0); 
signal s245	: std_logic_vector(0 downto 0); 
signal s247	: std_logic_vector(0 downto 0); 
signal s249	: std_logic_vector(0 downto 0); 
signal s250	: std_logic; 
signal s251	: std_logic_vector(0 downto 0); 
signal s252	: std_logic; 
signal s253	: std_logic; 
signal s254	: std_logic_vector(0 downto 0); 
signal s255	: std_logic_vector(31 downto 0); 
signal s256	: std_logic_vector(31 downto 0); 
signal s257	: std_logic_vector(31 downto 0); 
signal s258	: std_logic_vector(31 downto 0); 
signal s259	: std_logic_vector(31 downto 0); 
signal s260	: std_logic_vector(0 downto 0); 
signal s261	: std_logic_vector(31 downto 0); 
signal s262	: std_logic_vector(31 downto 0); 
signal s263	: std_logic_vector(31 downto 0); 
signal s264	: std_logic_vector(31 downto 0); 
signal s265	: std_logic_vector(31 downto 0); 

begin 

\len\: counter
generic map ( 
	bits => 32,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 17
)
port map ( 
	clk => \clk\,
	clk_en => s252,
	done => s253,
	input => s187,
	output => s0,
	reset => \reset\,
	step => s250,
	termination => s186
);

\val\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s26,
	O0 => s143,
	reset => \reset\,
	we => s189(0)
);

\indata\: block_ram_indata
generic map ( 
	address_width => 10,
	data_width => 32
)
port map ( 
	address(9 downto 0) => s0(9 downto 0),
	clk => \clk\,
	data_out => s26
);

\diff\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s27,
	O0 => s145,
	reset => \reset\,
	we => s191(0)
);

\val_22_sub_op_s_valpred\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s143,
	I1 => s255,
	O0 => s27
);

\if_lt_op_s_24\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s145,
	I1 => s2,
	O0 => s96
);

\step\: reg_op
generic map ( 
	initial => 7,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s256,
	O0 => s159,
	reset => \reset\,
	we => s193(0)
);

\stepsizeTable\: block_ram_stepsizeTable
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address(6 downto 0) => s166(6 downto 0),
	clk => \clk\,
	data_out => s32
);

\sign_153\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s95,
	I1 => s94,
	O0 => s171,
	reset => \reset\,
	Sel1 => s96,
	we => s195(0)
);

\if_ne_op_s_34\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s171,
	I1 => s5,
	O0 => s99
);

\diff_39_neg_op_s\: neg_op_s
generic map ( 
	w_in => 32,
	w_out => 32
)
port map ( 
	I0 => s145,
	O0 => s97
);

\delta\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s35,
	O0 => s101,
	reset => \reset\,
	we => s197(0)
);

\vpdiff\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s36,
	O0 => s178,
	reset => \reset\,
	we => s199(0)
);

\step_44_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 3
)
port map ( 
	I0 => s159,
	O0 => s36
);

\diff_155\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s145,
	I1 => s97,
	O0 => s147,
	reset => \reset\,
	Sel1 => s99,
	we => s201(0)
);

\if_ge_op_s_45\: if_ge_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s147,
	I1 => s159,
	O0 => s108
);

\diff_52_sub_op_s_step_53\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s147,
	I1 => s159,
	O0 => s103
);

\vpdiff_56_add_op_s_step_57\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s178,
	I1 => s159,
	O0 => s106
);

\step_58\: reg_op
generic map ( 
	initial => 7,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s45,
	O0 => s163,
	reset => \reset\,
	we => s203(0)
);

\step_60_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 1
)
port map ( 
	I0 => s159,
	O0 => s45
);

\diff_159\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s147,
	I1 => s103,
	O0 => s149,
	reset => \reset\,
	Sel1 => s108,
	we => s205(0)
);

\if_ge_op_s_61\: if_ge_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s149,
	I1 => s163,
	O0 => s117
);

\delta_157\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s101,
	I1 => s100,
	O0 => s172,
	reset => \reset\,
	Sel1 => s108,
	we => s207(0)
);

\delta_66_or_op_num_67\: or_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s172,
	I1 => s49,
	O0 => s109
);

\diff_70_sub_op_s_step_71\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s149,
	I1 => s163,
	O0 => s112
);

\vpdiff_161\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s178,
	I1 => s106,
	O0 => s179,
	reset => \reset\,
	Sel1 => s108,
	we => s209(0)
);

\vpdiff_74_add_op_s_step_75\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s179,
	I1 => s163,
	O0 => s115
);

\step_76\: reg_op
generic map ( 
	initial => 7,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s56,
	O0 => s165,
	reset => \reset\,
	we => s211(0)
);

\step_78_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 1
)
port map ( 
	I0 => s163,
	O0 => s56
);

\diff_165\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s149,
	I1 => s112,
	O0 => s150,
	reset => \reset\,
	Sel1 => s117,
	we => s213(0)
);

\if_ge_op_s_79\: if_ge_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s150,
	I1 => s165,
	O0 => s123
);

\delta_163\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s172,
	I1 => s109,
	O0 => s173,
	reset => \reset\,
	Sel1 => s117,
	we => s215(0)
);

\delta_84_or_op_num_85\: or_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s173,
	I1 => s60,
	O0 => s118
);

\vpdiff_167\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s179,
	I1 => s115,
	O0 => s180,
	reset => \reset\,
	Sel1 => s117,
	we => s217(0)
);

\vpdiff_88_add_op_s_step_89\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s180,
	I1 => s165,
	O0 => s121
);

\if_ne_op_s_90\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s171,
	I1 => s13,
	O0 => s126
);

\valpred_95_sub_op_s_vpdiff_96\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s261,
	I1 => s182,
	O0 => s124
);

\vpdiff_171\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s180,
	I1 => s121,
	O0 => s182,
	reset => \reset\,
	Sel1 => s123,
	we => s219(0)
);

\valpred_99_add_op_s_vpdiff_100\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s262,
	I1 => s182,
	O0 => s125
);

\valpred_173\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s125,
	I1 => s124,
	O0 => s153,
	reset => \reset\,
	Sel1 => s260,
	we => s221(0)
);

\if_gt_op_s_101\: if_gt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s153,
	I1 => s15,
	O0 => s129
);

\valpred_175\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s153,
	I1 => s127,
	O0 => s154,
	reset => \reset\,
	Sel1 => s129,
	we => s223(0)
);

\if_lt_op_s_106\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s154,
	I1 => s17,
	O0 => s132
);

\delta_169\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s173,
	I1 => s118,
	O0 => s174,
	reset => \reset\,
	Sel1 => s123,
	we => s225(0)
);

\delta_111\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s257,
	O0 => s177,
	reset => \reset\,
	we => s227(0)
);

\delta_113_or_op_sign_114\: or_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s174,
	I1 => s264,
	O0 => s72
);

\index_115\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s75,
	O0 => s167,
	reset => \reset\,
	we => s229(0)
);

\index_117_add_op_s_indexTable\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s263,
	I1 => s77,
	O0 => s75
);

\indexTable\: block_ram_indexTable
generic map ( 
	address_width => 4,
	data_width => 32
)
port map ( 
	address(3 downto 0) => s177(3 downto 0),
	clk => \clk\,
	data_out => s77
);

\if_lt_op_s_120\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s167,
	I1 => s20,
	O0 => s135
);

\index_179\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s167,
	I1 => s133,
	O0 => s168,
	reset => \reset\,
	Sel1 => s135,
	we => s231(0)
);

\if_gt_op_s_125\: if_gt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s168,
	I1 => s22,
	O0 => s138
);

\if_ne_op_s_130\: if_ne_op_s
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s184,
	I1(0 downto 0) => s24(0 downto 0),
	O0 => s234
);

\outputbuffer\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s258,
	O0 => s185,
	reset => \reset\,
	we => s235(0)
);

\comp_135_and_op_num_137\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s81,
	I1 => s83,
	O0 => s80
);

\delta_136_shl_c_op_s\: shl_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 4
)
port map ( 
	I0 => s177,
	O0 => s81
);

\comp_138\: not_op
generic map ( 
	w_in => 1,
	w_out => 1
)
port map ( 
	I0 => s184,
	O0 => s242
);

\i\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s140,
	I1 => s85,
	O0 => s140,
	clk => \clk\,
	reset => \reset\,
	we => s239(0)
);

\outdata\: block_ram
generic map ( 
	address_width => 9,
	data_width => 32
)
port map ( 
	address(8 downto 0) => s140(8 downto 0),
	clk => \clk\,
	data_in => s87,
	data_out => s265,
	we => s243(0)
);

\comp_146_or_op_outputbuffer_149\: or_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s259,
	I1 => s185,
	O0 => s87
);

\delta_147_and_op_num_148\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s177,
	I1 => s90,
	O0 => s88
);

\bufferstep_150\: reg_op
generic map ( 
	initial => 1,
	w_in => 1
)
port map ( 
	clk => \clk\,
	I0 => s92,
	O0 => s184,
	reset => \reset\,
	we => s247(0)
);

\bufferstep_152_not_op\: not_op
generic map ( 
	w_in => 1,
	w_out => 1
)
port map ( 
	I0 => s184,
	O0 => s92
);

\valpred_177\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s154,
	I1 => s130,
	O0 => s152,
	reset => \reset\,
	Sel1 => s132,
	we => s249(0)
);

\index_181\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s168,
	I1 => s136,
	O0 => s166,
	reset => \reset\,
	Sel1 => s138,
	we => s251(0)
);

\dly_187\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s250,
	a_delayed => s189,
	clk => \clk\,
	reset => \reset\
);

\dly_188\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a(0) => s250,
	a_delayed => s191,
	clk => \clk\,
	reset => \reset\
);

\dly_189\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s250,
	a_delayed => s193,
	clk => \clk\,
	reset => \reset\
);

\dly_190\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a(0) => s250,
	a_delayed => s195,
	clk => \clk\,
	reset => \reset\
);

\dly_191\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s250,
	a_delayed => s197,
	clk => \clk\,
	reset => \reset\
);

\dly_192\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s250,
	a_delayed => s199,
	clk => \clk\,
	reset => \reset\
);

\dly_193\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s250,
	a_delayed => s201,
	clk => \clk\,
	reset => \reset\
);

\dly_194\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s250,
	a_delayed => s203,
	clk => \clk\,
	reset => \reset\
);

\dly_195\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s250,
	a_delayed => s205,
	clk => \clk\,
	reset => \reset\
);

\dly_196\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s250,
	a_delayed => s207,
	clk => \clk\,
	reset => \reset\
);

\dly_197\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s250,
	a_delayed => s209,
	clk => \clk\,
	reset => \reset\
);

\dly_198\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s250,
	a_delayed => s211,
	clk => \clk\,
	reset => \reset\
);

\dly_199\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s250,
	a_delayed => s213,
	clk => \clk\,
	reset => \reset\
);

\dly_200\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s250,
	a_delayed => s215,
	clk => \clk\,
	reset => \reset\
);

\dly_201\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s250,
	a_delayed => s217,
	clk => \clk\,
	reset => \reset\
);

\dly_202\: delay_op
generic map ( 
	bits => 1,
	delay => 8
)
port map ( 
	a(0) => s250,
	a_delayed => s219,
	clk => \clk\,
	reset => \reset\
);

\dly_203\: delay_op
generic map ( 
	bits => 1,
	delay => 9
)
port map ( 
	a(0) => s250,
	a_delayed => s221,
	clk => \clk\,
	reset => \reset\
);

\dly_204\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s250,
	a_delayed => s223,
	clk => \clk\,
	reset => \reset\
);

\dly_205\: delay_op
generic map ( 
	bits => 1,
	delay => 8
)
port map ( 
	a(0) => s250,
	a_delayed => s225,
	clk => \clk\,
	reset => \reset\
);

\dly_206\: delay_op
generic map ( 
	bits => 1,
	delay => 11
)
port map ( 
	a(0) => s250,
	a_delayed => s227,
	clk => \clk\,
	reset => \reset\
);

\dly_207\: delay_op
generic map ( 
	bits => 1,
	delay => 14
)
port map ( 
	a(0) => s250,
	a_delayed => s229,
	clk => \clk\,
	reset => \reset\
);

\dly_208\: delay_op
generic map ( 
	bits => 1,
	delay => 15
)
port map ( 
	a(0) => s250,
	a_delayed => s231,
	clk => \clk\,
	reset => \reset\
);

\comp_210\: and_op
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s234,
	I1 => s237,
	O0 => s235
);

\dly_211\: delay_op
generic map ( 
	bits => 1,
	delay => 17
)
port map ( 
	a(0) => s250,
	a_delayed => s237,
	clk => \clk\,
	reset => \reset\
);

\comp_212\: and_op
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s242,
	I1 => s241,
	O0 => s239
);

\dly_213\: delay_op
generic map ( 
	bits => 1,
	delay => 17
)
port map ( 
	a(0) => s250,
	a_delayed => s241,
	clk => \clk\,
	reset => \reset\
);

\comp_214\: and_op
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s242,
	I1 => s245,
	O0 => s243
);

\dly_215\: delay_op
generic map ( 
	bits => 1,
	delay => 18
)
port map ( 
	a(0) => s250,
	a_delayed => s245,
	clk => \clk\,
	reset => \reset\
);

\dly_216\: delay_op
generic map ( 
	bits => 1,
	delay => 18
)
port map ( 
	a(0) => s250,
	a_delayed => s247,
	clk => \clk\,
	reset => \reset\
);

\dly_217\: delay_op
generic map ( 
	bits => 1,
	delay => 11
)
port map ( 
	a(0) => s250,
	a_delayed => s249,
	clk => \clk\,
	reset => \reset\
);

\dly_218\: delay_op
generic map ( 
	bits => 1,
	delay => 16
)
port map ( 
	a(0) => s250,
	a_delayed => s251,
	clk => \clk\,
	reset => \reset\
);

\dly_219\: delay_op
generic map ( 
	bits => 1,
	delay => 20
)
port map ( 
	a(0) => s253,
	a_delayed => s254,
	clk => \clk\,
	reset => \reset\
);

\dly_220\: delay_op
generic map ( 
	bits => 32,
	delay => 3
)
port map ( 
	a => s152,
	a_delayed => s255,
	clk => \clk\,
	reset => \reset\
);

\dly_221\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s32,
	a_delayed => s256,
	clk => \clk\,
	reset => \reset\
);

\dly_222\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s72,
	a_delayed => s257,
	clk => \clk\,
	reset => \reset\
);

\dly_223\: delay_op
generic map ( 
	bits => 32,
	delay => 5
)
port map ( 
	a => s80,
	a_delayed => s258,
	clk => \clk\,
	reset => \reset\
);

\dly_224\: delay_op
generic map ( 
	bits => 32,
	delay => 6
)
port map ( 
	a => s88,
	a_delayed => s259,
	clk => \clk\,
	reset => \reset\
);

\dly_225\: delay_op
generic map ( 
	bits => 1,
	delay => 4
)
port map ( 
	a => s126,
	a_delayed => s260,
	clk => \clk\,
	reset => \reset\
);

\dly_226\: delay_op
generic map ( 
	bits => 32,
	delay => 9
)
port map ( 
	a => s152,
	a_delayed => s261,
	clk => \clk\,
	reset => \reset\
);

\dly_227\: delay_op
generic map ( 
	bits => 32,
	delay => 9
)
port map ( 
	a => s152,
	a_delayed => s262,
	clk => \clk\,
	reset => \reset\
);

\dly_228\: delay_op
generic map ( 
	bits => 32,
	delay => 14
)
port map ( 
	a => s166,
	a_delayed => s263,
	clk => \clk\,
	reset => \reset\
);

\dly_229\: delay_op
generic map ( 
	bits => 32,
	delay => 4
)
port map ( 
	a => s171,
	a_delayed => s264,
	clk => \clk\,
	reset => \reset\
);

s2 <= conv_std_logic_vector(0, 32);
s94 <= conv_std_logic_vector(8, 32);
s95 <= conv_std_logic_vector(0, 32);
s5 <= conv_std_logic_vector(0, 32);
s35 <= conv_std_logic_vector(0, 32);
s100 <= conv_std_logic_vector(4, 32);
s49 <= conv_std_logic_vector(2, 32);
s60 <= conv_std_logic_vector(1, 32);
s13 <= conv_std_logic_vector(0, 32);
s15 <= conv_std_logic_vector(32767, 32);
s127 <= conv_std_logic_vector(32767, 32);
s17 <= conv_std_logic_vector(-32768, 32);
s130 <= conv_std_logic_vector(-32768, 32);
s20 <= conv_std_logic_vector(0, 32);
s133 <= conv_std_logic_vector(0, 32);
s22 <= conv_std_logic_vector(88, 32);
s136 <= conv_std_logic_vector(88, 32);
s24 <= conv_std_logic_vector(0, 32);
s83 <= conv_std_logic_vector(240, 32);
s85 <= conv_std_logic_vector(1, 32);
s90 <= conv_std_logic_vector(15, 32);
s252 <= \init\;
\done\ <= s254(0);
s186 <= conv_std_logic_vector(1024, 32);
s187 <= conv_std_logic_vector(0, 32);
\result\ <= s265;
end behavior; 