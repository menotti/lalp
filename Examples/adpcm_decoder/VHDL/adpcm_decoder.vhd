library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity adpcm_decoder is 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\result\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end adpcm_decoder; 

architecture behavior of adpcm_decoder is 

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

signal s1	: std_logic_vector(31 downto 0); 
signal s2	: std_logic_vector(31 downto 0); 
signal s6	: std_logic_vector(31 downto 0); 
signal s8	: std_logic_vector(31 downto 0); 
signal s9	: std_logic_vector(31 downto 0); 
signal s10	: std_logic_vector(31 downto 0); 
signal s11	: std_logic_vector(31 downto 0); 
signal s12	: std_logic_vector(31 downto 0); 
signal s13	: std_logic_vector(31 downto 0); 
signal s14	: std_logic_vector(31 downto 0); 
signal s16	: std_logic_vector(31 downto 0); 
signal s18	: std_logic_vector(31 downto 0); 
signal s20	: std_logic_vector(31 downto 0); 
signal s21	: std_logic_vector(31 downto 0); 
signal s24	: std_logic_vector(31 downto 0); 
signal s27	: std_logic_vector(31 downto 0); 
signal s29	: std_logic_vector(31 downto 0); 
signal s31	: std_logic_vector(31 downto 0); 
signal s33	: std_logic_vector(0 downto 0); 
signal s35	: std_logic_vector(31 downto 0); 
signal s36	: std_logic_vector(31 downto 0); 
signal s38	: std_logic_vector(31 downto 0); 
signal s41	: std_logic_vector(31 downto 0); 
signal s43	: std_logic_vector(31 downto 0); 
signal s44	: std_logic_vector(31 downto 0); 
signal s46	: std_logic_vector(31 downto 0); 
signal s47	: std_logic_vector(31 downto 0); 
signal s50	: std_logic_vector(31 downto 0); 
signal s55	: std_logic_vector(31 downto 0); 
signal s58	: std_logic_vector(31 downto 0); 
signal s61	: std_logic_vector(31 downto 0); 
signal s64	: std_logic_vector(31 downto 0); 
signal s76	: std_logic_vector(31 downto 0); 
signal s77	: std_logic_vector(31 downto 0); 
signal s80	: std_logic_vector(31 downto 0); 
signal s81	: std_logic_vector(31 downto 0); 
signal s82	: std_logic_vector(0 downto 0); 
signal s84	: std_logic_vector(31 downto 0); 
signal s86	: std_logic_vector(0 downto 0); 
signal s87	: std_logic_vector(31 downto 0); 
signal s89	: std_logic_vector(0 downto 0); 
signal s90	: std_logic_vector(31 downto 0); 
signal s92	: std_logic_vector(0 downto 0); 
signal s93	: std_logic_vector(31 downto 0); 
signal s95	: std_logic_vector(0 downto 0); 
signal s96	: std_logic_vector(31 downto 0); 
signal s98	: std_logic_vector(0 downto 0); 
signal s99	: std_logic_vector(31 downto 0); 
signal s100	: std_logic_vector(31 downto 0); 
signal s101	: std_logic_vector(0 downto 0); 
signal s102	: std_logic_vector(31 downto 0); 
signal s104	: std_logic_vector(0 downto 0); 
signal s105	: std_logic_vector(31 downto 0); 
signal s106	: std_logic_vector(31 downto 0); 
signal s107	: std_logic_vector(0 downto 0); 
signal s109	: std_logic_vector(0 downto 0); 
signal s113	: std_logic_vector(31 downto 0); 
signal s114	: std_logic_vector(31 downto 0); 
signal s115	: std_logic_vector(31 downto 0); 
signal s116	: std_logic_vector(31 downto 0); 
signal s119	: std_logic_vector(31 downto 0); 
signal s122	: std_logic_vector(31 downto 0); 
signal s123	: std_logic_vector(31 downto 0); 
signal s124	: std_logic_vector(31 downto 0); 
signal s125	: std_logic_vector(31 downto 0); 
signal s126	: std_logic_vector(31 downto 0); 
signal s128	: std_logic_vector(31 downto 0); 
signal s129	: std_logic_vector(31 downto 0); 
signal s131	: std_logic_vector(31 downto 0); 
signal s133	: std_logic_vector(31 downto 0); 
signal s134	: std_logic_vector(31 downto 0); 
signal s135	: std_logic_vector(31 downto 0); 
signal s137	: std_logic_vector(0 downto 0); 
signal s138	: std_logic_vector(0 downto 0); 
signal s139	: std_logic_vector(0 downto 0); 
signal s141	: std_logic_vector(0 downto 0); 
signal s143	: std_logic_vector(0 downto 0); 
signal s145	: std_logic_vector(0 downto 0); 
signal s147	: std_logic_vector(0 downto 0); 
signal s149	: std_logic_vector(0 downto 0); 
signal s151	: std_logic_vector(0 downto 0); 
signal s153	: std_logic_vector(0 downto 0); 
signal s155	: std_logic_vector(0 downto 0); 
signal s157	: std_logic_vector(0 downto 0); 
signal s159	: std_logic_vector(0 downto 0); 
signal s161	: std_logic_vector(0 downto 0); 
signal s165	: std_logic_vector(0 downto 0); 
signal s167	: std_logic_vector(0 downto 0); 
signal s169	: std_logic_vector(0 downto 0); 
signal s171	: std_logic_vector(0 downto 0); 
signal s173	: std_logic_vector(0 downto 0); 
signal s174	: std_logic; 
signal s175	: std_logic_vector(0 downto 0); 
signal s176	: std_logic; 
signal s177	: std_logic; 
signal s178	: std_logic_vector(0 downto 0); 
signal s179	: std_logic_vector(0 downto 0); 
signal s180	: std_logic_vector(31 downto 0); 
signal s181	: std_logic_vector(31 downto 0); 
signal s182	: std_logic_vector(31 downto 0); 
signal s183	: std_logic_vector(31 downto 0); 
signal s184	: std_logic_vector(31 downto 0); 
signal s185	: std_logic_vector(31 downto 0); 
signal s186	: std_logic_vector(0 downto 0); 
signal s187	: std_logic_vector(31 downto 0); 
signal s188	: std_logic_vector(0 downto 0); 
signal s189	: std_logic_vector(0 downto 0); 
signal s190	: std_logic_vector(0 downto 0); 
signal s191	: std_logic_vector(31 downto 0); 
signal s192	: std_logic_vector(31 downto 0); 
signal s193	: std_logic_vector(31 downto 0); 

begin 

\len\: counter
generic map ( 
	bits => 32,
	condition => 0,
	down => 0,
	increment => 1,
	steps => 8
)
port map ( 
	clk => \clk\,
	clk_en => s176,
	done => s177,
	input => s134,
	output => s21,
	reset => \reset\,
	step => s174,
	termination => s133
);

\if_ne_op_s_15\: if_ne_op_s
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s109,
	I1(0 downto 0) => s1(0 downto 0),
	O0 => s82
);

\inputbuffer_and_op_num_21\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s80,
	I1 => s24,
	O0 => s76
);

\indata\: block_ram_indata
generic map ( 
	address_width => 9,
	data_width => 32
)
port map ( 
	address(8 downto 0) => s2(8 downto 0),
	clk => \clk\,
	data_out => s81
);

\comp_27_and_op_num_29\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s27,
	I1 => s29,
	O0 => s77
);

\inputbuffer_28_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 4
)
port map ( 
	I0 => s81,
	O0 => s27
);

\comp_30\: not_op
generic map ( 
	w_in => 1,
	w_out => 1
)
port map ( 
	I0 => s109,
	O0 => s138
);

\i_32\: add_reg_op_s
generic map ( 
	initial => 0,
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s2,
	I1 => s31,
	O0 => s2,
	clk => \clk\,
	reset => \reset\,
	we => s139(0)
);

\bufferstep_35\: reg_op
generic map ( 
	initial => 1,
	w_in => 1
)
port map ( 
	clk => \clk\,
	I0 => s179,
	O0 => s109,
	reset => \reset\,
	we => s143(0)
);

\bufferstep_37_not_op\: not_op
generic map ( 
	w_in => 1,
	w_out => 1
)
port map ( 
	I0 => s109,
	O0 => s33
);

\step\: reg_op
generic map ( 
	initial => 7,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s35,
	O0 => s113,
	reset => \reset\,
	we => s145(0)
);

\stepsizeTable\: block_ram_stepsizeTable
generic map ( 
	address_width => 7,
	data_width => 32
)
port map ( 
	address(6 downto 0) => s114(6 downto 0),
	clk => \clk\,
	data_out => s35
);

\index_41\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s36,
	O0 => s115,
	reset => \reset\,
	we => s147(0)
);

\index_43_add_op_s_indexTable\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s192,
	I1 => s38,
	O0 => s36
);

\indexTable\: block_ram_indexTable
generic map ( 
	address_width => 4,
	data_width => 32
)
port map ( 
	address(3 downto 0) => s119(3 downto 0),
	clk => \clk\,
	data_out => s38
);

\delta_120\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s77,
	I1 => s185,
	O0 => s119,
	reset => \reset\,
	Sel1 => s186,
	we => s149(0)
);

\if_lt_op_s_46\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s115,
	I1 => s6,
	O0 => s86
);

\index_124\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s115,
	I1 => s84,
	O0 => s116,
	reset => \reset\,
	Sel1 => s86,
	we => s151(0)
);

\if_gt_op_s_51\: if_gt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s116,
	I1 => s8,
	O0 => s89
);

\sign\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s180,
	O0 => s123,
	reset => \reset\,
	we => s153(0)
);

\delta_58_and_op_num_59\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s119,
	I1 => s43,
	O0 => s41
);

\delta_60\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s181,
	O0 => s122,
	reset => \reset\,
	we => s155(0)
);

\delta_62_and_op_num_63\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s119,
	I1 => s46,
	O0 => s44
);

\vpdiff\: reg_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s182,
	O0 => s124,
	reset => \reset\,
	we => s157(0)
);

\step_66_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 3
)
port map ( 
	I0 => s113,
	O0 => s47
);

\delta_68_and_op_num_69\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s122,
	I1 => s50,
	O0 => s9
);

\if_ne_op_s_67\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s9,
	I1 => s10,
	O0 => s92
);

\vpdiff_74_add_op_s_step_75\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s124,
	I1 => s191,
	O0 => s90
);

\delta_77_and_op_num_78\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s122,
	I1 => s55,
	O0 => s11
);

\if_ne_op_s_76\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s11,
	I1 => s12,
	O0 => s95
);

\vpdiff_128\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s124,
	I1 => s90,
	O0 => s125,
	reset => \reset\,
	Sel1 => s92,
	we => s159(0)
);

\vpdiff_83_add_op_s_comp_84\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s125,
	I1 => s183,
	O0 => s93
);

\step_85_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 1
)
port map ( 
	I0 => s113,
	O0 => s58
);

\delta_87_and_op_num_88\: and_op
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s122,
	I1 => s61,
	O0 => s13
);

\if_ne_op_s_86\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s13,
	I1 => s14,
	O0 => s98
);

\vpdiff_130\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s125,
	I1 => s93,
	O0 => s126,
	reset => \reset\,
	Sel1 => s95,
	we => s161(0)
);

\vpdiff_93_add_op_s_comp_94\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s126,
	I1 => s184,
	O0 => s96
);

\step_95_shr_c_op_s\: shr_c_op_s
generic map ( 
	w_in1 => 32,
	w_out => 32,
	s_amount => 2
)
port map ( 
	I0 => s113,
	O0 => s64
);

\if_ne_op_s_96\: if_ne_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s123,
	I1 => s16,
	O0 => s101
);

\valpred_101_sub_op_s_vpdiff_102\: sub_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s129,
	I1 => s128,
	O0 => s99
);

\vpdiff_132\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s126,
	I1 => s96,
	O0 => s128,
	reset => \reset\,
	Sel1 => s189,
	we => s165(0)
);

\valpred_105_add_op_s_vpdiff_106\: add_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 32
)
port map ( 
	I0 => s129,
	I1 => s128,
	O0 => s100
);

\valpred_134\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s100,
	I1 => s99,
	O0 => s131,
	reset => \reset\,
	Sel1 => s190,
	we => s167(0)
);

\if_gt_op_s_107\: if_gt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s131,
	I1 => s18,
	O0 => s104
);

\if_lt_op_s_112\: if_lt_op_s
generic map ( 
	w_in1 => 32,
	w_in2 => 32,
	w_out => 1
)
port map ( 
	I0 => s131,
	I1 => s20,
	O0 => s107
);

\valpred_136\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s131,
	I1 => s102,
	O0 => s106,
	reset => \reset\,
	Sel1 => s104,
	we => s169(0)
);

\outdata\: block_ram
generic map ( 
	address_width => 10,
	data_width => 32
)
port map ( 
	address(9 downto 0) => s135(9 downto 0),
	clk => \clk\,
	data_in => s129,
	data_out => s193,
	we => s137(0)
);

\valpred_138\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s106,
	I1 => s105,
	O0 => s129,
	reset => \reset\,
	Sel1 => s107,
	we => s171(0)
);

\inputbuffer_122\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s81,
	I1 => s187,
	O0 => s80,
	reset => \reset\,
	Sel1 => s188,
	we => s173(0)
);

\index_126\: reg_mux_op
generic map ( 
	initial => 0,
	w_in => 32
)
port map ( 
	clk => \clk\,
	I0 => s116,
	I1 => s87,
	O0 => s114,
	reset => \reset\,
	Sel1 => s89,
	we => s175(0)
);

\dly_144\: delay_op
generic map ( 
	bits => 32,
	delay => 14
)
port map ( 
	a => s21,
	a_delayed => s135,
	clk => \clk\,
	reset => \reset\
);

\dly_145\: delay_op
generic map ( 
	bits => 1,
	delay => 14
)
port map ( 
	a(0) => s174,
	a_delayed => s137,
	clk => \clk\,
	reset => \reset\
);

\comp_146\: and_op
generic map ( 
	w_in1 => 1,
	w_in2 => 1,
	w_out => 1
)
port map ( 
	I0 => s138,
	I1 => s141,
	O0 => s139
);

\dly_147\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s174,
	a_delayed => s141,
	clk => \clk\,
	reset => \reset\
);

\dly_148\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s174,
	a_delayed => s143,
	clk => \clk\,
	reset => \reset\
);

\dly_149\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s174,
	a_delayed => s145,
	clk => \clk\,
	reset => \reset\
);

\dly_150\: delay_op
generic map ( 
	bits => 1,
	delay => 5
)
port map ( 
	a(0) => s174,
	a_delayed => s147,
	clk => \clk\,
	reset => \reset\
);

\dly_151\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s174,
	a_delayed => s149,
	clk => \clk\,
	reset => \reset\
);

\dly_152\: delay_op
generic map ( 
	bits => 1,
	delay => 6
)
port map ( 
	a(0) => s174,
	a_delayed => s151,
	clk => \clk\,
	reset => \reset\
);

\dly_153\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s174,
	a_delayed => s153,
	clk => \clk\,
	reset => \reset\
);

\dly_154\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s174,
	a_delayed => s155,
	clk => \clk\,
	reset => \reset\
);

\dly_155\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s174,
	a_delayed => s157,
	clk => \clk\,
	reset => \reset\
);

\dly_156\: delay_op
generic map ( 
	bits => 1,
	delay => 8
)
port map ( 
	a(0) => s174,
	a_delayed => s159,
	clk => \clk\,
	reset => \reset\
);

\dly_157\: delay_op
generic map ( 
	bits => 1,
	delay => 9
)
port map ( 
	a(0) => s174,
	a_delayed => s161,
	clk => \clk\,
	reset => \reset\
);

\dly_159\: delay_op
generic map ( 
	bits => 1,
	delay => 10
)
port map ( 
	a(0) => s174,
	a_delayed => s165,
	clk => \clk\,
	reset => \reset\
);

\dly_160\: delay_op
generic map ( 
	bits => 1,
	delay => 11
)
port map ( 
	a(0) => s174,
	a_delayed => s167,
	clk => \clk\,
	reset => \reset\
);

\dly_161\: delay_op
generic map ( 
	bits => 1,
	delay => 12
)
port map ( 
	a(0) => s174,
	a_delayed => s169,
	clk => \clk\,
	reset => \reset\
);

\dly_162\: delay_op
generic map ( 
	bits => 1,
	delay => 13
)
port map ( 
	a(0) => s174,
	a_delayed => s171,
	clk => \clk\,
	reset => \reset\
);

\dly_163\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a(0) => s174,
	a_delayed => s173,
	clk => \clk\,
	reset => \reset\
);

\dly_164\: delay_op
generic map ( 
	bits => 1,
	delay => 7
)
port map ( 
	a(0) => s174,
	a_delayed => s175,
	clk => \clk\,
	reset => \reset\
);

\dly_165\: delay_op
generic map ( 
	bits => 1,
	delay => 16
)
port map ( 
	a(0) => s177,
	a_delayed => s178,
	clk => \clk\,
	reset => \reset\
);

\dly_166\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a => s33,
	a_delayed => s179,
	clk => \clk\,
	reset => \reset\
);

\dly_167\: delay_op
generic map ( 
	bits => 32,
	delay => 4
)
port map ( 
	a => s41,
	a_delayed => s180,
	clk => \clk\,
	reset => \reset\
);

\dly_168\: delay_op
generic map ( 
	bits => 32,
	delay => 4
)
port map ( 
	a => s44,
	a_delayed => s181,
	clk => \clk\,
	reset => \reset\
);

\dly_169\: delay_op
generic map ( 
	bits => 32,
	delay => 4
)
port map ( 
	a => s47,
	a_delayed => s182,
	clk => \clk\,
	reset => \reset\
);

\dly_170\: delay_op
generic map ( 
	bits => 32,
	delay => 6
)
port map ( 
	a => s58,
	a_delayed => s183,
	clk => \clk\,
	reset => \reset\
);

\dly_171\: delay_op
generic map ( 
	bits => 32,
	delay => 7
)
port map ( 
	a => s64,
	a_delayed => s184,
	clk => \clk\,
	reset => \reset\
);

\dly_172\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s76,
	a_delayed => s185,
	clk => \clk\,
	reset => \reset\
);

\dly_173\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a => s82,
	a_delayed => s186,
	clk => \clk\,
	reset => \reset\
);

\dly_174\: delay_op
generic map ( 
	bits => 32,
	delay => 2
)
port map ( 
	a => s80,
	a_delayed => s187,
	clk => \clk\,
	reset => \reset\
);

\dly_175\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a => s82,
	a_delayed => s188,
	clk => \clk\,
	reset => \reset\
);

\dly_176\: delay_op
generic map ( 
	bits => 1,
	delay => 2
)
port map ( 
	a => s98,
	a_delayed => s189,
	clk => \clk\,
	reset => \reset\
);

\dly_177\: delay_op
generic map ( 
	bits => 1,
	delay => 3
)
port map ( 
	a => s101,
	a_delayed => s190,
	clk => \clk\,
	reset => \reset\
);

\dly_178\: delay_op
generic map ( 
	bits => 32,
	delay => 5
)
port map ( 
	a => s113,
	a_delayed => s191,
	clk => \clk\,
	reset => \reset\
);

\dly_179\: delay_op
generic map ( 
	bits => 32,
	delay => 5
)
port map ( 
	a => s114,
	a_delayed => s192,
	clk => \clk\,
	reset => \reset\
);

s1 <= conv_std_logic_vector(0, 32);
s24 <= conv_std_logic_vector(15, 32);
s29 <= conv_std_logic_vector(15, 32);
s31 <= conv_std_logic_vector(1, 32);
s6 <= conv_std_logic_vector(0, 32);
s84 <= conv_std_logic_vector(0, 32);
s8 <= conv_std_logic_vector(88, 32);
s87 <= conv_std_logic_vector(88, 32);
s43 <= conv_std_logic_vector(8, 32);
s46 <= conv_std_logic_vector(7, 32);
s50 <= conv_std_logic_vector(4, 32);
s10 <= conv_std_logic_vector(0, 32);
s55 <= conv_std_logic_vector(2, 32);
s12 <= conv_std_logic_vector(0, 32);
s61 <= conv_std_logic_vector(1, 32);
s14 <= conv_std_logic_vector(0, 32);
s16 <= conv_std_logic_vector(0, 32);
s18 <= conv_std_logic_vector(32767, 32);
s102 <= conv_std_logic_vector(32767, 32);
s20 <= conv_std_logic_vector(-32768, 32);
s105 <= conv_std_logic_vector(-32768, 32);
s176 <= \init\;
\done\ <= s178(0);
s133 <= conv_std_logic_vector(1024, 32);
s134 <= conv_std_logic_vector(0, 32);
\result\ <= s193;
end behavior; 