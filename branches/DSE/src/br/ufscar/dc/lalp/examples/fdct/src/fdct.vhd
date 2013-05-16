--
-- Copyright (c) 2010 Ricardo Menotti, All Rights Reserved.
--
-- Permission to use, copy, modify, and distribute this software and its
-- documentation for NON-COMERCIAL purposes and without fee is hereby granted 
-- provided that this copyright notice appears in all copies.
--
-- RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
-- OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
-- NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES
-- SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
-- SOFTWARE OR ITS DERIVATIVES.
--
-- Generated at Wed Dec 12 13:45:23 BRST 2012
--

-- IEEE Libraries --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity fdct is
	port (
		\clear\	: in	std_logic;
		\clk\	: in	std_logic;
		\done\	: out	std_logic;
		\init\	: in	std_logic;
		\output\	: out	std_logic_vector(31 downto 0);
		\reset\	: in	std_logic
	);
end fdct;

architecture behavior of fdct is

component add_op_s
generic (
	w_in1	: integer := 8;
	w_in2	: integer := 8;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component and_op
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component block_ram
generic (
	data_width		: integer := 8;
	address_width	: integer := 8
);
port (
	clk			: in	std_logic;
	we			: in	std_logic := '0';
	oe			: in	std_logic := '1';
	address		: in	std_logic_vector(address_width-1 downto 0);
	data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0');
	data_out	: out	std_logic_vector(data_width-1 downto 0)
);
end component;

component block_ram_dct_io_ptr
generic (
	data_width		: integer := 8;
	address_width	: integer := 8
);
port (
	clk			: in	std_logic;
	we			: in	std_logic := '0';
	oe			: in	std_logic := '1';
	address		: in	std_logic_vector(address_width-1 downto 0);
	data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0');
	data_out	: out	std_logic_vector(data_width-1 downto 0)
);
end component;

component counter
generic (
	bits		: integer := 8;
	steps		: integer := 1;
	increment	: integer := 1;
	down	: integer := 0;
	condition : integer := 0
);
port (
	input		: in	std_logic_vector(bits-1 downto 0);
	termination	: in	std_logic_vector(bits-1 downto 0);
	clk			: in	std_logic;
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
	bits	: integer := 8;
	delay	: integer := 1
);
port (
	a			: in	std_logic_vector(bits-1 downto 0);
	clk			: in	std_logic;
	reset		: in	std_logic;
	a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0')
);
end component;

component mult_op_s_p
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32;
	k: integer := 5 -- number of pipeline stages
);
port (
	clk	: in	std_logic;
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component mux_m_op
generic (
	w_in	: integer := 32;
	N_ops	: integer := 32;
	N_sels	: integer := 31
);
port (
	I0	: in	std_logic_vector((w_in*N_ops)-1 downto 0);
	Sel	: in	std_logic_vector(N_sels-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;
component not_op
generic (
	w_in	: integer := 16;
	w_out	: integer := 16
);
port (
	I0	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component reg_mux_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	Sel1	: in	std_logic_vector(0 downto 0);
	I0	: in	std_logic_vector(w_in-1 downto 0);
	I1	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

component reg_op
generic (
	w_in	: integer := 16;
	initial	: integer := 0
);
port (
	clk	: in	std_logic;
	reset	: in	std_logic;
	we	: in	std_logic := '1';
	I0	: in	std_logic_vector(w_in-1 downto 0);
	O0	: out	std_logic_vector(w_in-1 downto 0)
);
end component;

component shr_c_op_s
generic (
	w_in1	: integer := 16;
	w_out	: integer := 15;
	s_amount	: integer := 1
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

component sub_op_s
generic (
	w_in1	: integer := 16;
	w_in2	: integer := 16;
	w_out	: integer := 32
);
port (
	I0	: in	std_logic_vector(w_in1-1 downto 0);
	I1	: in	std_logic_vector(w_in2-1 downto 0);
	O0	: out	std_logic_vector(w_out-1 downto 0)
);
end component;

signal s610	: std_logic_vector(31 downto 0);
signal s0	: std_logic_vector(9 downto 0);
signal s89	: std_logic_vector(31 downto 0);
signal s555	: std_logic_vector(0 downto 0);
signal s178	: std_logic_vector(0 downto 0);
signal s411	: std_logic_vector(31 downto 0);
signal s644	: std_logic_vector(31 downto 0);
signal s267	: std_logic_vector(31 downto 0);
signal s212	: std_logic_vector(9 downto 0);
signal s589	: std_logic_vector(31 downto 0);
signal s445	: std_logic_vector(0 downto 0);
signal s68	: std_logic_vector(31 downto 0);
signal s301	: std_logic_vector(31 downto 0);
signal s390	: std_logic_vector(31 downto 0);
signal s157	: std_logic_vector(31 downto 0);
signal s479	: std_logic_vector(0 downto 0);
signal s623	: std_logic_vector(31 downto 0);
signal s335	: std_logic_vector(31 downto 0);
signal s102	: std_logic_vector(31 downto 0);
signal s191	: std_logic;
signal s280	: std_logic_vector(31 downto 0);
signal s369	: std_logic_vector(31 downto 0);
signal s136	: std_logic_vector(31 downto 0);
signal s513	: std_logic_vector(0 downto 0);
signal s602	: std_logic_vector(31 downto 0);
signal s81	: std_logic_vector(31 downto 0);
signal s403	: std_logic_vector(0 downto 0);
signal s636	: std_logic_vector(31 downto 0);
signal s547	: std_logic_vector(0 downto 0);
signal s170	: std_logic_vector(0 downto 0);
signal s348	: std_logic_vector(31 downto 0);
signal s581	: std_logic_vector(31 downto 0);
signal s115	: std_logic_vector(31 downto 0);
signal s293	: std_logic_vector(31 downto 0);
signal s204	: std_logic_vector(0 downto 0);
signal s437	: std_logic_vector(0 downto 0);
signal s615	: std_logic_vector(31 downto 0);
signal s5	: std_logic_vector(9 downto 0);
signal s238	: std_logic_vector(0 downto 0);
signal s382	: std_logic_vector(31 downto 0);
signal s327	: std_logic_vector(31 downto 0);
signal s471	: std_logic_vector(0 downto 0);
signal s94	: std_logic_vector(31 downto 0);
signal s505	: std_logic_vector(0 downto 0);
signal s649	: std_logic_vector(31 downto 0);
signal s272	: std_logic_vector(31 downto 0);
signal s416	: std_logic_vector(9 downto 0);
signal s39	: std_logic_vector(0 downto 0);
signal s73	: std_logic_vector(31 downto 0);
signal s217	: std_logic_vector(0 downto 0);
signal s361	: std_logic_vector(31 downto 0);
signal s539	: std_logic_vector(0 downto 0);
signal s306	: std_logic_vector(31 downto 0);
signal s573	: std_logic_vector(31 downto 0);
signal s429	: std_logic_vector(0 downto 0);
signal s285	: std_logic_vector(31 downto 0);
signal s107	: std_logic_vector(31 downto 0);
signal s340	: std_logic_vector(31 downto 0);
signal s463	: std_logic_vector(0 downto 0);
signal s86	: std_logic_vector(31 downto 0);
signal s319	: std_logic_vector(31 downto 0);
signal s175	: std_logic_vector(31 downto 0);
signal s141	: std_logic_vector(31 downto 0);
signal s374	: std_logic_vector(31 downto 0);
signal s607	: std_logic_vector(31 downto 0);
signal s353	: std_logic_vector(31 downto 0);
signal s120	: std_logic_vector(31 downto 0);
signal s641	: std_logic_vector(31 downto 0);
signal s408	: std_logic_vector(31 downto 0);
signal s497	: std_logic_vector(0 downto 0);
signal s243	: std_logic_vector(31 downto 0);
signal s10	: std_logic_vector(0 downto 0);
signal s620	: std_logic_vector(31 downto 0);
signal s332	: std_logic_vector(31 downto 0);
signal s99	: std_logic_vector(31 downto 0);
signal s387	: std_logic_vector(31 downto 0);
signal s531	: std_logic_vector(0 downto 0);
signal s154	: std_logic_vector(31 downto 0);
signal s366	: std_logic_vector(31 downto 0);
signal s599	: std_logic_vector(31 downto 0);
signal s133	: std_logic_vector(31 downto 0);
signal s421	: std_logic_vector(0 downto 0);
signal s44	: std_logic_vector(31 downto 0);
signal s565	: std_logic_vector(0 downto 0);
signal s188	: std_logic_vector(31 downto 0);
signal s633	: std_logic_vector(31 downto 0);
signal s489	: std_logic_vector(0 downto 0);
signal s167	: std_logic_vector(31 downto 0);
signal s400	: std_logic_vector(0 downto 0);
signal s455	: std_logic_vector(0 downto 0);
signal s78	: std_logic_vector(31 downto 0);
signal s146	: std_logic_vector(31 downto 0);
signal s523	: std_logic_vector(0 downto 0);
signal s290	: std_logic_vector(31 downto 0);
signal s57	: std_logic_vector(31 downto 0);
signal s201	: std_logic;
signal s578	: std_logic_vector(31 downto 0);
signal s345	: std_logic_vector(31 downto 0);
signal s112	: std_logic_vector(31 downto 0);
signal s646	: std_logic_vector(31 downto 0);
signal s36	: std_logic_vector(0 downto 0);
signal s180	: std_logic_vector(31 downto 0);
signal s413	: std_logic;
signal s557	: std_logic_vector(0 downto 0);
signal s91	: std_logic_vector(31 downto 0);
signal s612	: std_logic_vector(31 downto 0);
signal s235	: std_logic_vector(0 downto 0);
signal s379	: std_logic_vector(31 downto 0);
signal s159	: std_logic_vector(31 downto 0);
signal s625	: std_logic_vector(31 downto 0);
signal s15	: std_logic_vector(9 downto 0);
signal s104	: std_logic_vector(31 downto 0);
signal s481	: std_logic_vector(0 downto 0);
signal s193	: std_logic_vector(0 downto 0);
signal s570	: std_logic;
signal s337	: std_logic_vector(31 downto 0);
signal s447	: std_logic_vector(0 downto 0);
signal s591	: std_logic_vector(31 downto 0);
signal s214	: std_logic_vector(0 downto 0);
signal s303	: std_logic_vector(31 downto 0);
signal s549	: std_logic_vector(0 downto 0);
signal s405	: std_logic_vector(31 downto 0);
signal s638	: std_logic_vector(31 downto 0);
signal s261	: std_logic_vector(31 downto 0);
signal s350	: std_logic_vector(31 downto 0);
signal s282	: std_logic_vector(31 downto 0);
signal s515	: std_logic_vector(0 downto 0);
signal s138	: std_logic_vector(31 downto 0);
signal s371	: std_logic_vector(31 downto 0);
signal s604	: std_logic_vector(31 downto 0);
signal s83	: std_logic_vector(31 downto 0);
signal s329	: std_logic_vector(31 downto 0);
signal s96	: std_logic_vector(31 downto 0);
signal s473	: std_logic_vector(0 downto 0);
signal s507	: std_logic_vector(0 downto 0);
signal s274	: std_logic_vector(31 downto 0);
signal s651	: std_logic_vector(31 downto 0);
signal s418	: std_logic_vector(31 downto 0);
signal s185	: std_logic_vector(0 downto 0);
signal s295	: std_logic_vector(31 downto 0);
signal s439	: std_logic_vector(0 downto 0);
signal s62	: std_logic_vector(31 downto 0);
signal s206	: std_logic_vector(0 downto 0);
signal s583	: std_logic_vector(31 downto 0);
signal s617	: std_logic_vector(31 downto 0);
signal s7	: std_logic_vector(9 downto 0);
signal s384	: std_logic_vector(31 downto 0);
signal s486	: std_logic;
signal s109	: std_logic_vector(31 downto 0);
signal s397	: std_logic_vector(0 downto 0);
signal s630	: std_logic_vector(31 downto 0);
signal s431	: std_logic_vector(0 downto 0);
signal s54	: std_logic_vector(31 downto 0);
signal s198	: std_logic;
signal s575	: std_logic_vector(31 downto 0);
signal s596	: std_logic_vector(31 downto 0);
signal s130	: std_logic_vector(31 downto 0);
signal s363	: std_logic_vector(31 downto 0);
signal s541	: std_logic_vector(0 downto 0);
signal s75	: std_logic_vector(31 downto 0);
signal s308	: std_logic_vector(31 downto 0);
signal s499	: std_logic_vector(0 downto 0);
signal s211	: std_logic_vector(9 downto 0);
signal s588	: std_logic_vector(31 downto 0);
signal s177	: std_logic_vector(31 downto 0);
signal s266	: std_logic_vector(31 downto 0);
signal s33	: std_logic_vector(0 downto 0);
signal s643	: std_logic_vector(31 downto 0);
signal s465	: std_logic_vector(0 downto 0);
signal s232	: std_logic_vector(0 downto 0);
signal s88	: std_logic_vector(31 downto 0);
signal s143	: std_logic_vector(31 downto 0);
signal s287	: std_logic_vector(31 downto 0);
signal s609	: std_logic_vector(31 downto 0);
signal s376	: std_logic_vector(31 downto 0);
signal s279	: std_logic_vector(31 downto 0);
signal s368	: std_logic_vector(31 downto 0);
signal s334	: std_logic_vector(31 downto 0);
signal s567	: std_logic_vector(0 downto 0);
signal s190	: std_logic_vector(31 downto 0);
signal s423	: std_logic_vector(0 downto 0);
signal s389	: std_logic_vector(31 downto 0);
signal s622	: std_logic_vector(31 downto 0);
signal s12	: std_logic;
signal s101	: std_logic_vector(31 downto 0);
signal s67	: std_logic_vector(31 downto 0);
signal s300	: std_logic_vector(31 downto 0);
signal s156	: std_logic_vector(31 downto 0);
signal s533	: std_logic_vector(0 downto 0);
signal s525	: std_logic_vector(0 downto 0);
signal s292	: std_logic_vector(31 downto 0);
signal s203	: std_logic_vector(0 downto 0);
signal s347	: std_logic_vector(31 downto 0);
signal s114	: std_logic_vector(31 downto 0);
signal s491	: std_logic_vector(0 downto 0);
signal s635	: std_logic_vector(31 downto 0);
signal s402	: std_logic_vector(31 downto 0);
signal s169	: std_logic_vector(31 downto 0);
signal s313	: std_logic_vector(31 downto 0);
signal s80	: std_logic_vector(31 downto 0);
signal s457	: std_logic_vector(0 downto 0);
signal s601	: std_logic_vector(31 downto 0);
signal s449	: std_logic_vector(0 downto 0);
signal s72	: std_logic_vector(31 downto 0);
signal s360	: std_logic_vector(31 downto 0);
signal s593	: std_logic_vector(31 downto 0);
signal s127	: std_logic_vector(31 downto 0);
signal s648	: std_logic_vector(31 downto 0);
signal s271	: std_logic_vector(31 downto 0);
signal s182	: std_logic_vector(31 downto 0);
signal s559	: std_logic_vector(0 downto 0);
signal s415	: std_logic_vector(0 downto 0);
signal s93	: std_logic_vector(31 downto 0);
signal s326	: std_logic_vector(31 downto 0);
signal s237	: std_logic_vector(31 downto 0);
signal s614	: std_logic_vector(31 downto 0);
signal s148	: std_logic_vector(31 downto 0);
signal s4	: std_logic_vector(9 downto 0);
signal s381	: std_logic_vector(31 downto 0);
signal s174	: std_logic_vector(0 downto 0);
signal s551	: std_logic_vector(0 downto 0);
signal s119	: std_logic_vector(31 downto 0);
signal s640	: std_logic_vector(31 downto 0);
signal s30	: std_logic_vector(0 downto 0);
signal s441	: std_logic_vector(0 downto 0);
signal s208	: std_logic_vector(9 downto 0);
signal s585	: std_logic_vector(31 downto 0);
signal s352	: std_logic_vector(31 downto 0);
signal s386	: std_logic_vector(31 downto 0);
signal s153	: std_logic_vector(31 downto 0);
signal s297	: std_logic_vector(31 downto 0);
signal s394	: std_logic_vector(0 downto 0);
signal s17	: std_logic_vector(9 downto 0);
signal s627	: std_logic_vector(31 downto 0);
signal s305	: std_logic_vector(31 downto 0);
signal s161	: std_logic_vector(31 downto 0);
signal s339	: std_logic_vector(31 downto 0);
signal s572	: std_logic_vector(31 downto 0);
signal s250	: std_logic_vector(31 downto 0);
signal s483	: std_logic_vector(0 downto 0);
signal s106	: std_logic_vector(31 downto 0);
signal s51	: std_logic_vector(31 downto 0);
signal s284	: std_logic_vector(31 downto 0);
signal s606	: std_logic_vector(31 downto 0);
signal s229	: std_logic_vector(0 downto 0);
signal s140	: std_logic_vector(31 downto 0);
signal s517	: std_logic_vector(0 downto 0);
signal s373	: std_logic_vector(31 downto 0);
signal s632	: std_logic_vector(31 downto 0);
signal s399	: std_logic_vector(31 downto 0);
signal s255	: std_logic_vector(31 downto 0);
signal s111	: std_logic_vector(31 downto 0);
signal s433	: std_logic_vector(0 downto 0);
signal s577	: std_logic_vector(31 downto 0);
signal s289	: std_logic_vector(31 downto 0);
signal s56	: std_logic_vector(31 downto 0);
signal s378	: std_logic_vector(31 downto 0);
signal s145	: std_logic_vector(31 downto 0);
signal s611	: std_logic_vector(31 downto 0);
signal s1	: std_logic_vector(9 downto 0);
signal s323	: std_logic_vector(31 downto 0);
signal s90	: std_logic_vector(31 downto 0);
signal s467	: std_logic_vector(0 downto 0);
signal s619	: std_logic_vector(31 downto 0);
signal s475	: std_logic_vector(0 downto 0);
signal s98	: std_logic_vector(31 downto 0);
signal s331	: std_logic_vector(31 downto 0);
signal s276	: std_logic_vector(31 downto 0);
signal s509	: std_logic_vector(0 downto 0);
signal s132	: std_logic_vector(31 downto 0);
signal s365	: std_logic_vector(31 downto 0);
signal s166	: std_logic_vector(31 downto 0);
signal s543	: std_logic_vector(0 downto 0);
signal s281	: std_logic_vector(31 downto 0);
signal s48	: std_logic_vector(31 downto 0);
signal s425	: std_logic_vector(0 downto 0);
signal s192	: std_logic_vector(31 downto 0);
signal s569	: std_logic_vector(0 downto 0);
signal s336	: std_logic_vector(31 downto 0);
signal s27	: std_logic_vector(0 downto 0);
signal s171	: std_logic_vector(31 downto 0);
signal s82	: std_logic_vector(31 downto 0);
signal s459	: std_logic_vector(0 downto 0);
signal s603	: std_logic_vector(31 downto 0);
signal s226	: std_logic_vector(0 downto 0);
signal s370	: std_logic_vector(31 downto 0);
signal s590	: std_logic_vector(31 downto 0);
signal s268	: std_logic_vector(31 downto 0);
signal s124	: std_logic_vector(31 downto 0);
signal s501	: std_logic_vector(0 downto 0);
signal s412	: std_logic_vector(0 downto 0);
signal s645	: std_logic_vector(31 downto 0);
signal s624	: std_logic_vector(31 downto 0);
signal s14	: std_logic_vector(9 downto 0);
signal s247	: std_logic_vector(31 downto 0);
signal s158	: std_logic_vector(31 downto 0);
signal s391	: std_logic_vector(31 downto 0);
signal s302	: std_logic_vector(31 downto 0);
signal s535	: std_logic_vector(0 downto 0);
signal s213	: std_logic;
signal s595	: std_logic_vector(31 downto 0);
signal s362	: std_logic_vector(31 downto 0);
signal s451	: std_logic_vector(0 downto 0);
signal s650	: std_logic_vector(31 downto 0);
signal s417	: std_logic_vector(9 downto 0);
signal s273	: std_logic_vector(31 downto 0);
signal s19	: std_logic_vector(0 downto 0);
signal s629	: std_logic_vector(31 downto 0);
signal s341	: std_logic_vector(31 downto 0);
signal s485	: std_logic_vector(0 downto 0);
signal s108	: std_logic_vector(31 downto 0);
signal s307	: std_logic_vector(31 downto 0);
signal s74	: std_logic_vector(31 downto 0);
signal s396	: std_logic_vector(31 downto 0);
signal s205	: std_logic_vector(31 downto 0);
signal s582	: std_logic_vector(31 downto 0);
signal s294	: std_logic_vector(31 downto 0);
signal s260	: std_logic_vector(31 downto 0);
signal s637	: std_logic_vector(31 downto 0);
signal s493	: std_logic_vector(0 downto 0);
signal s349	: std_logic_vector(31 downto 0);
signal s95	: std_logic_vector(31 downto 0);
signal s561	: std_logic_vector(0 downto 0);
signal s184	: std_logic_vector(31 downto 0);
signal s527	: std_logic_vector(0 downto 0);
signal s150	: std_logic_vector(31 downto 0);
signal s383	: std_logic_vector(31 downto 0);
signal s6	: std_logic_vector(9 downto 0);
signal s477	: std_logic_vector(0 downto 0);
signal s100	: std_logic_vector(31 downto 0);
signal s11	: std_logic_vector(0 downto 0);
signal s388	: std_logic_vector(31 downto 0);
signal s244	: std_logic_vector(31 downto 0);
signal s621	: std_logic_vector(31 downto 0);
signal s45	: std_logic_vector(0 downto 0);
signal s333	: std_logic_vector(31 downto 0);
signal s189	: std_logic_vector(0 downto 0);
signal s587	: std_logic_vector(31 downto 0);
signal s210	: std_logic_vector(0 downto 0);
signal s443	: std_logic_vector(0 downto 0);
signal s354	: std_logic_vector(31 downto 0);
signal s155	: std_logic_vector(31 downto 0);
signal s299	: std_logic_vector(31 downto 0);
signal s553	: std_logic_vector(0 downto 0);
signal s320	: std_logic_vector(31 downto 0);
signal s87	: std_logic_vector(31 downto 0);
signal s265	: std_logic_vector(31 downto 0);
signal s642	: std_logic_vector(31 downto 0);
signal s409	: std_logic_vector(0 downto 0);
signal s286	: std_logic_vector(31 downto 0);
signal s197	: std_logic_vector(9 downto 0);
signal s574	: std_logic_vector(31 downto 0);
signal s608	: std_logic_vector(31 downto 0);
signal s375	: std_logic_vector(31 downto 0);
signal s142	: std_logic_vector(31 downto 0);
signal s519	: std_logic_vector(0 downto 0);
signal s325	: std_logic_vector(31 downto 0);
signal s181	: std_logic_vector(0 downto 0);
signal s414	: std_logic_vector(31 downto 0);
signal s647	: std_logic_vector(31 downto 0);
signal s126	: std_logic_vector(31 downto 0);
signal s503	: std_logic_vector(0 downto 0);
signal s359	: std_logic_vector(31 downto 0);
signal s435	: std_logic_vector(0 downto 0);
signal s291	: std_logic_vector(31 downto 0);
signal s147	: std_logic_vector(31 downto 0);
signal s380	: std_logic_vector(31 downto 0);
signal s613	: std_logic_vector(31 downto 0);
signal s469	: std_logic_vector(0 downto 0);
signal s92	: std_logic_vector(31 downto 0);
signal s545	: std_logic_vector(0 downto 0);
signal s634	: std_logic_vector(31 downto 0);
signal s24	: std_logic_vector(0 downto 0);
signal s346	: std_logic_vector(31 downto 0);
signal s113	: std_logic_vector(31 downto 0);
signal s202	: std_logic_vector(0 downto 0);
signal s579	: std_logic_vector(31 downto 0);
signal s511	: std_logic_vector(0 downto 0);
signal s367	: std_logic_vector(31 downto 0);
signal s134	: std_logic_vector(31 downto 0);
signal s223	: std_logic_vector(0 downto 0);
signal s312	: std_logic_vector(31 downto 0);
signal s79	: std_logic_vector(31 downto 0);
signal s351	: std_logic_vector(31 downto 0);
signal s207	: std_logic_vector(9 downto 0);
signal s495	: std_logic_vector(0 downto 0);
signal s639	: std_logic_vector(31 downto 0);
signal s173	: std_logic_vector(31 downto 0);
signal s406	: std_logic_vector(0 downto 0);
signal s317	: std_logic_vector(31 downto 0);
signal s605	: std_logic_vector(31 downto 0);
signal s461	: std_logic_vector(0 downto 0);
signal s139	: std_logic_vector(31 downto 0);
signal s372	: std_logic_vector(31 downto 0);
signal s283	: std_logic_vector(31 downto 0);
signal s427	: std_logic_vector(0 downto 0);
signal s50	: std_logic_vector(31 downto 0);
signal s194	: std_logic_vector(9 downto 0);
signal s571	: std_logic_vector(0 downto 0);
signal s338	: std_logic_vector(31 downto 0);
signal s249	: std_logic_vector(31 downto 0);
signal s626	: std_logic_vector(31 downto 0);
signal s16	: std_logic_vector(9 downto 0);
signal s393	: std_logic_vector(31 downto 0);
signal s160	: std_logic_vector(31 downto 0);
signal s537	: std_logic_vector(0 downto 0);
signal s304	: std_logic_vector(31 downto 0);
signal s288	: std_logic_vector(31 downto 0);
signal s521	: std_logic_vector(0 downto 0);
signal s144	: std_logic_vector(31 downto 0);
signal s377	: std_logic_vector(31 downto 0);
signal s343	: std_logic_vector(31 downto 0);
signal s576	: std_logic_vector(31 downto 0);
signal s199	: std_logic_vector(9 downto 0);
signal s631	: std_logic_vector(31 downto 0);
signal s110	: std_logic_vector(31 downto 0);
signal s487	: std_logic_vector(0 downto 0);
signal s453	: std_logic_vector(0 downto 0);
signal s364	: std_logic_vector(31 downto 0);
signal s220	: std_logic_vector(0 downto 0);
signal s597	: std_logic_vector(31 downto 0);
signal s419	: std_logic;
signal s563	: std_logic_vector(0 downto 0);
signal s186	: std_logic_vector(31 downto 0);
signal s275	: std_logic_vector(31 downto 0);
signal s42	: std_logic_vector(0 downto 0);
signal s241	: std_logic_vector(31 downto 0);
signal s97	: std_logic_vector(31 downto 0);
signal s152	: std_logic_vector(31 downto 0);
signal s529	: std_logic_vector(0 downto 0);
signal s385	: std_logic_vector(31 downto 0);

begin

	\C3_mult_op_s_p_xQ_0_6_add_op_s_C5_mult_op_s_p_xS_0_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s345,
		I1 => s346,
		O0 => s347
	);

	\P_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s641,
		O0 => s582,
		clk => \clk\,
		reset => \reset\,
		we => s461(0)
	);

	\c322\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s439,
		clk => \clk\,
		reset => \reset\
	);

	\dct_io_tmp_address\: reg_mux_op
	generic map (
		initial => 0,
		w_in => 10
	)
	port map (
		I0 => s197,
		I1 => s416,
		O0 => s199,
		Sel1(0) => s413,
		clk => \clk\,
		reset => \reset\,
		we => s198
	);

	\c411\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s620,
		a_delayed => s617,
		clk => \clk\,
		reset => \reset\
	);

	\f0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s612,
		clk => \clk\,
		reset => \reset\,
		we => s24(0)
	);

	\f1_sub_op_s_f6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s645,
		I1 => s56,
		O0 => s57
	);

	\c356\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s507,
		clk => \clk\,
		reset => \reset\
	);

	\xs0a_mult_op_s_p_C0_6_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s293,
		O0 => s294
	);

	\dct_io_ptr\: block_ram_dct_io_ptr
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address => s194,
		clk => \clk\,
		data_out => s44
	);

	\c390\: delay_op
	generic map (
		bits => 32,
		delay => 6
	)
	port map (
		a => s574,
		a_delayed => s575,
		clk => \clk\,
		reset => \reset\
	);

	\xh2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s244,
		O0 => s276,
		clk => \clk\,
		reset => \reset\,
		we => s491(0)
	);

	\C7_mult_op_s_p_S_1_6_sub_op_s_C1_mult_op_s_p_Q_1_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s145,
		I1 => s146,
		O0 => s147
	);

	\xF_4_add_op_s_4_shr_c_op_s_3\: shr_c_op_s
	generic map (
		s_amount => 3,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s377,
		O0 => s378
	);

	\c335\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s486,
		a_delayed => s465,
		clk => \clk\,
		reset => \reset\
	);

	\xQ_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s320,
		O0 => s351,
		clk => \clk\,
		reset => \reset\,
		we => s535(0)
	);

	\c424\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s642,
		a_delayed => s643,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_9\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s570,
		a_delayed => s235,
		clk => \clk\,
		reset => \reset\
	);

	\xF_2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s623,
		O0 => s367,
		clk => \clk\,
		reset => \reset\,
		we => s553(0)
	);

	\c369\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s570,
		a_delayed => s533,
		clk => \clk\,
		reset => \reset\
	);

	\s0a_mult_op_s_p_C0_6_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s94,
		O0 => s95
	);

	\C7_mult_op_s_p_xQ_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s327,
		I1 => s337,
		O0 => s331,
		clk => \clk\
	);

	\R_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s108,
		O0 => s604,
		clk => \clk\,
		reset => \reset\,
		we => s457(0)
	);

	\c403\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s612,
		a_delayed => s601,
		clk => \clk\,
		reset => \reset\
	);

	\q0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s89,
		O0 => s96,
		clk => \clk\,
		reset => \reset\,
		we => s451(0)
	);

	\c314\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s423,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_33\: delay_op
	generic map (
		bits => 1,
		delay => 33
	)
	port map (
		a(0) => s191,
		a_delayed => s181,
		clk => \clk\,
		reset => \reset\
	);

	\c348\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s491,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_36\: delay_op
	generic map (
		bits => 1,
		delay => 36
	)
	port map (
		a(0) => s570,
		a_delayed => s412,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_7\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s191,
		a_delayed => s33,
		clk => \clk\,
		reset => \reset\
	);

	\q0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s101,
		O0 => s126,
		clk => \clk\,
		reset => \reset\,
		we => s455(0)
	);

	\xg1_sub_op_s_xh1\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s272,
		I1 => s273,
		O0 => s274
	);

	\g2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s625,
		O0 => s82,
		clk => \clk\,
		reset => \reset\,
		we => s435(0)
	);

	\xF_0_add_op_s_6_shr_c_op_s_3\: shr_c_op_s
	generic map (
		s_amount => 3,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s361,
		O0 => s362
	);

	\q1_sub_op_s_q0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s599,
		I1 => s126,
		O0 => s127
	);

	\c382\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s559,
		clk => \clk\,
		reset => \reset\
	);

	\i_done_delay_op_28\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s213,
		a_delayed => s210,
		clk => \clk\,
		reset => \reset\
	);

	\c327\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s449,
		clk => \clk\,
		reset => \reset\
	);

	\h2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s51,
		O0 => s83,
		clk => \clk\,
		reset => \reset\,
		we => s423(0)
	);

	\g0_add_op_s_h0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s73,
		I1 => s74,
		O0 => s72
	);

	\c416\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s626,
		a_delayed => s627,
		clk => \clk\,
		reset => \reset\
	);

	\r1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s81,
		O0 => s112,
		clk => \clk\,
		reset => \reset\,
		we => s443(0)
	);

	\p1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s78,
		O0 => s120,
		clk => \clk\,
		reset => \reset\,
		we => s441(0)
	);

	\C2_mult_op_s_p_xr1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s304,
		I1 => s305,
		O0 => s307,
		clk => \clk\
	);

	\c361\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s517,
		clk => \clk\,
		reset => \reset\
	);

	\xh0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s577,
		O0 => s267,
		clk => \clk\,
		reset => \reset\,
		we => s501(0)
	);

	\c395\: delay_op
	generic map (
		bits => 32,
		delay => 5
	)
	port map (
		a => s644,
		a_delayed => s585,
		clk => \clk\,
		reset => \reset\
	);

	\C5_mult_op_s_p_Q_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s157,
		I1 => s158,
		O0 => s160,
		clk => \clk\
	);

	\xf1_sub_op_s_xf6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s595,
		I1 => s249,
		O0 => s250
	);

	\xs1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s276,
		O0 => s610,
		clk => \clk\,
		reset => \reset\,
		we => s515(0)
	);

	\xF_7_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s387,
		I1 => s388,
		O0 => s389
	);

	\i_add_op_s_8\: add_op_s
	generic map (
		w_in1 => 10,
		w_in2 => 10,
		w_out => 10
	)
	port map (
		I0 => s6,
		I1 => s4,
		O0 => s5
	);

	\c340\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s475,
		clk => \clk\,
		reset => \reset\
	);

	\xp1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s271,
		O0 => s313,
		clk => \clk\,
		reset => \reset\,
		we => s509(0)
	);

	\c319\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s433,
		clk => \clk\,
		reset => \reset\
	);

	\F_7_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s190,
		O0 => s192
	);

	\C2_mult_op_s_p_r0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s104,
		I1 => s110,
		O0 => s107,
		clk => \clk\
	);

	\c374\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s543,
		clk => \clk\,
		reset => \reset\
	);

	\C7_mult_op_s_p_xS_1_6_sub_op_s_C1_mult_op_s_p_xQ_1_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s338,
		I1 => s339,
		O0 => s340
	);

	\c353\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s501,
		clk => \clk\,
		reset => \reset\
	);

	\f0_add_op_s_f7\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s613,
		I1 => s50,
		O0 => s48
	);

	\xq0a_mult_op_s_p_C0_6_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s287,
		O0 => s288
	);

	\f3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s67,
		clk => \clk\,
		reset => \reset\,
		we => s33(0)
	);

	\c408\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s610,
		a_delayed => s611,
		clk => \clk\,
		reset => \reset\
	);

	\xF_3_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s371,
		I1 => s372,
		O0 => s373
	);

	\s1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s83,
		O0 => s650,
		clk => \clk\,
		reset => \reset\,
		we => s447(0)
	);

	\c332\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s459,
		clk => \clk\,
		reset => \reset\
	);

	\xR_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s308,
		O0 => s596,
		clk => \clk\,
		reset => \reset\,
		we => s527(0)
	);

	\xf0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s630,
		clk => \clk\,
		reset => \reset\,
		we => s217(0)
	);

	\c387\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s569,
		clk => \clk\,
		reset => \reset\
	);

	\C7_mult_op_s_p_Q_1_6_add_op_s_C1_mult_op_s_p_S_1_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s138,
		I1 => s139,
		O0 => s140
	);

	\c366\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s527,
		clk => \clk\,
		reset => \reset\
	);

	\h3_sub_op_s_g3\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s87,
		I1 => s88,
		O0 => s89
	);

	\c421\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s636,
		a_delayed => s637,
		clk => \clk\,
		reset => \reset\
	);

	\xg2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s643,
		O0 => s275,
		clk => \clk\,
		reset => \reset\,
		we => s503(0)
	);

	\xj_step_delay_op_6\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s570,
		a_delayed => s226,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_33\: delay_op
	generic map (
		bits => 1,
		delay => 33
	)
	port map (
		a(0) => s570,
		a_delayed => s403,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_31\: delay_op
	generic map (
		bits => 1,
		delay => 31
	)
	port map (
		a(0) => s191,
		a_delayed => s174,
		clk => \clk\,
		reset => \reset\
	);

	\c400\: delay_op
	generic map (
		bits => 32,
		delay => 5
	)
	port map (
		a => s614,
		a_delayed => s595,
		clk => \clk\,
		reset => \reset\
	);

	\F_2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s605,
		O0 => s171,
		clk => \clk\,
		reset => \reset\,
		we => s485(0)
	);

	\xq1_sub_op_s_xq0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s617,
		I1 => s319,
		O0 => s320
	);

	\S_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s130,
		O0 => s142,
		clk => \clk\,
		reset => \reset\,
		we => s469(0)
	);

	\p0_add_op_s_p1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s119,
		I1 => s120,
		O0 => s640
	);

	\xf5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s255,
		clk => \clk\,
		reset => \reset\,
		we => s232(0)
	);

	\xg0_add_op_s_xh0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s266,
		I1 => s267,
		O0 => s265
	);

	\c345\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s485,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_4\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s191,
		a_delayed => s24,
		clk => \clk\,
		reset => \reset\
	);

	\xs0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s279,
		O0 => s289,
		clk => \clk\,
		reset => \reset\,
		we => s517(0)
	);

	\i_1_done_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0(0) => s201,
		O0 => s202
	);

	\c413\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s620,
		a_delayed => s621,
		clk => \clk\,
		reset => \reset\
	);

	\c324\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s443,
		clk => \clk\,
		reset => \reset\
	);

	\i_plus_8\: reg_op
	generic map (
		initial => 0,
		w_in => 10
	)
	port map (
		I0 => s5,
		O0 => s7,
		clk => \clk\,
		reset => \reset\
	);

	\C5_mult_op_s_p_xQ_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s350,
		I1 => s351,
		O0 => s353,
		clk => \clk\
	);

	\c379\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s553,
		clk => \clk\,
		reset => \reset\
	);

	\c392\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s578,
		a_delayed => s579,
		clk => \clk\,
		reset => \reset\
	);

	\C5_mult_op_s_p_S_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s150,
		I1 => s156,
		O0 => s153,
		clk => \clk\
	);

	\xF_5_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s381,
		O0 => s382
	);

	\xh1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s603,
		O0 => s273,
		clk => \clk\,
		reset => \reset\,
		we => s497(0)
	);

	\xP_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s591,
		O0 => s606,
		clk => \clk\,
		reset => \reset\,
		we => s529(0)
	);

	\xf0_add_op_s_xf7\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s631,
		I1 => s243,
		O0 => s241
	);

	\c337\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s486,
		a_delayed => s469,
		clk => \clk\,
		reset => \reset\
	);

	\c358\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s511,
		clk => \clk\,
		reset => \reset\
	);

	\f2_sub_op_s_f5\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s629,
		I1 => s62,
		O0 => s638
	);

	\C2_mult_op_s_p_xr0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s297,
		I1 => s303,
		O0 => s300,
		clk => \clk\
	);

	\xr0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s268,
		O0 => s303,
		clk => \clk\,
		reset => \reset\,
		we => s507(0)
	);

	\c316\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s427,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_34\: delay_op
	generic map (
		bits => 1,
		delay => 34
	)
	port map (
		a(0) => s191,
		a_delayed => s185,
		clk => \clk\,
		reset => \reset\
	);

	\c405\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s604,
		a_delayed => s605,
		clk => \clk\,
		reset => \reset\
	);

	\f6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s56,
		clk => \clk\,
		reset => \reset\,
		we => s42(0)
	);

	\xi_output_delay_op_29\: delay_op
	generic map (
		bits => 10,
		delay => 29
	)
	port map (
		a => s416,
		a_delayed => s417,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_9\: delay_op
	generic map (
		bits => 1,
		delay => 9
	)
	port map (
		a(0) => s191,
		a_delayed => s39,
		clk => \clk\,
		reset => \reset\
	);

	\c350\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s495,
		clk => \clk\,
		reset => \reset\
	);

	\c426\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s646,
		a_delayed => s647,
		clk => \clk\,
		reset => \reset\
	);

	\xF_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s333,
		O0 => s363,
		clk => \clk\,
		reset => \reset\,
		we => s541(0)
	);

	\q0a_mult_op_s_p_C0_6_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s98,
		I1 => s99,
		O0 => s100
	);

	\c371\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s570,
		a_delayed => s537,
		clk => \clk\,
		reset => \reset\
	);

	\C7_mult_op_s_p_xQ_1_6_add_op_s_C1_mult_op_s_p_xS_1_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s331,
		I1 => s332,
		O0 => s333
	);

	\mf\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 32
	)
	port map (
		I0(255 downto 224) => s166(31 downto 0),
		I0(223 downto 192) => s169(31 downto 0),
		I0(191 downto 160) => s173(31 downto 0),
		I0(159 downto 128) => s177(31 downto 0),
		I0(127 downto 96) => s180(31 downto 0),
		I0(95 downto 64) => s184(31 downto 0),
		I0(63 downto 32) => s188(31 downto 0),
		I0(31 downto 0) => s192(31 downto 0),
		O0 => s205,
		Sel(6 downto 6) => s170(0 downto 0),
		Sel(5 downto 5) => s174(0 downto 0),
		Sel(4 downto 4) => s178(0 downto 0),
		Sel(3 downto 3) => s181(0 downto 0),
		Sel(2 downto 2) => s185(0 downto 0),
		Sel(1 downto 1) => s189(0 downto 0),
		Sel(0 downto 0) => s193(0 downto 0)
	);

	\c329\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s453,
		clk => \clk\,
		reset => \reset\
	);

	\h1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s579,
		O0 => s80,
		clk => \clk\,
		reset => \reset\,
		we => s429(0)
	);

	\xF_1_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s365,
		O0 => s366
	);

	\xg3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s589,
		O0 => s281,
		clk => \clk\,
		reset => \reset\,
		we => s499(0)
	);

	\c418\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s630,
		a_delayed => s631,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_3\: delay_op
	generic map (
		bits => 1,
		delay => 3
	)
	port map (
		a(0) => s570,
		a_delayed => s217,
		clk => \clk\,
		reset => \reset\
	);

	\xf2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s646,
		clk => \clk\,
		reset => \reset\,
		we => s223(0)
	);

	\xh3_sub_op_s_xg3\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s280,
		I1 => s281,
		O0 => s282
	);

	\i_1\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 8,
		steps => 1
	)
	port map (
		clk => \clk\,
		clk_en => s19(0),
		done => s201,
		input => s16,
		load => s191,
		output => s194,
		reset => \reset\,
		step => s486,
		termination => s17
	);

	\c384\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s563,
		clk => \clk\,
		reset => \reset\
	);

	\s1_sub_op_s_s0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s651,
		I1 => s132,
		O0 => s133
	);

	\init_and_op_i_done_not_op\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0(0) => s198,
		I1 => s10,
		O0 => s11
	);

	\F_5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s154,
		O0 => s182,
		clk => \clk\,
		reset => \reset\,
		we => s477(0)
	);

	\c397\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s588,
		a_delayed => s589,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_30\: delay_op
	generic map (
		bits => 1,
		delay => 30
	)
	port map (
		a(0) => s570,
		a_delayed => s394,
		clk => \clk\,
		reset => \reset\
	);

	\xf7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s243,
		clk => \clk\,
		reset => \reset\,
		we => s238(0)
	);

	\c342\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s479,
		clk => \clk\,
		reset => \reset\
	);

	\xf2_sub_op_s_xf5\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s647,
		I1 => s255,
		O0 => s588
	);

	\xp0_add_op_s_xp1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s312,
		I1 => s313,
		O0 => s590
	);

	\g1_add_op_s_h1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s79,
		I1 => s80,
		O0 => s78
	);

	\c363\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s521,
		clk => \clk\,
		reset => \reset\
	);

	\F_1_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s167,
		O0 => s169
	);

	\xF6r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s386,
		O0 => s408,
		clk => \clk\,
		reset => \reset\,
		we => s569(0)
	);

	\c355\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s505,
		clk => \clk\,
		reset => \reset\
	);

	\f1_add_op_s_f6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s585,
		I1 => s56,
		O0 => s54
	);

	\xs0a_mult_op_s_p_C0_6_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s291,
		I1 => s292,
		O0 => s293
	);

	\c410\: delay_op
	generic map (
		bits => 32,
		delay => 5
	)
	port map (
		a => s614,
		a_delayed => s615,
		clk => \clk\,
		reset => \reset\
	);

	\i_1_delay_op_26\: delay_op
	generic map (
		bits => 10,
		delay => 26
	)
	port map (
		a => s194,
		a_delayed => s197,
		clk => \clk\,
		reset => \reset\
	);

	\f1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s644,
		clk => \clk\,
		reset => \reset\,
		we => s27(0)
	);

	\C5_mult_op_s_p_xS_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s343,
		I1 => s349,
		O0 => s346,
		clk => \clk\
	);

	\c321\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s437,
		clk => \clk\,
		reset => \reset\
	);

	\P_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s633,
		O0 => s626,
		clk => \clk\,
		reset => \reset\,
		we => s463(0)
	);

	\C6_mult_op_s_p_r0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s109,
		I1 => s110,
		O0 => s113,
		clk => \clk\
	);

	\c376\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s547,
		clk => \clk\,
		reset => \reset\
	);

	\s0a_mult_op_s_p_C0_6_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s92,
		I1 => s93,
		O0 => s94
	);

	\c368\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s531,
		clk => \clk\,
		reset => \reset\
	);

	\c334\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s463,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_8\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s570,
		a_delayed => s232,
		clk => \clk\,
		reset => \reset\
	);

	\c423\: delay_op
	generic map (
		bits => 32,
		delay => 6
	)
	port map (
		a => s640,
		a_delayed => s641,
		clk => \clk\,
		reset => \reset\
	);

	\xg1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s247,
		O0 => s272,
		clk => \clk\,
		reset => \reset\,
		we => s493(0)
	);

	\c389\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s572,
		a_delayed => s573,
		clk => \clk\,
		reset => \reset\
	);

	\s0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s95,
		O0 => s132,
		clk => \clk\,
		reset => \reset\,
		we => s453(0)
	);

	\xF_4_add_op_s_4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s375,
		I1 => s376,
		O0 => s377
	);

	\xQ_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s317,
		O0 => s337,
		clk => \clk\,
		reset => \reset\,
		we => s533(0)
	);

	\i\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 64,
		steps => 72
	)
	port map (
		clk => \clk\,
		clk_en => s198,
		done => s213,
		input => s0,
		output => s6,
		reset => \reset\,
		step => s12,
		termination => s1
	);

	\C1_mult_op_s_p_Q_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s143,
		I1 => s144,
		O0 => s146,
		clk => \clk\
	);

	\xf4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s261,
		clk => \clk\,
		reset => \reset\,
		we => s229(0)
	);

	\xg1_add_op_s_xh1\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s272,
		I1 => s273,
		O0 => s271
	);

	\c347\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s489,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_6\: delay_op
	generic map (
		bits => 1,
		delay => 6
	)
	port map (
		a(0) => s191,
		a_delayed => s30,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_35\: delay_op
	generic map (
		bits => 1,
		delay => 35
	)
	port map (
		a(0) => s570,
		a_delayed => s409,
		clk => \clk\,
		reset => \reset\
	);

	\F_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s583,
		O0 => s166,
		clk => \clk\,
		reset => \reset\,
		we => s481(0)
	);

	\c402\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s608,
		a_delayed => s599,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_32\: delay_op
	generic map (
		bits => 1,
		delay => 32
	)
	port map (
		a(0) => s191,
		a_delayed => s178,
		clk => \clk\,
		reset => \reset\
	);

	\c313\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s421,
		clk => \clk\,
		reset => \reset\
	);

	\xF5r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s382,
		O0 => s405,
		clk => \clk\,
		reset => \reset\,
		we => s567(0)
	);

	\xs1_sub_op_s_xs0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s593,
		I1 => s325,
		O0 => s326
	);

	\xF0r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s362,
		O0 => s391,
		clk => \clk\,
		reset => \reset\,
		we => s557(0)
	);

	\c360\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s515,
		clk => \clk\,
		reset => \reset\
	);

	\C6_mult_op_s_p_xr0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s302,
		I1 => s303,
		O0 => s306,
		clk => \clk\
	);

	\f3_sub_op_s_f4\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s67,
		I1 => s68,
		O0 => s624
	);

	\xF_6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s597,
		O0 => s383,
		clk => \clk\,
		reset => \reset\,
		we => s555(0)
	);

	\i_1_step_delay_op_28_and_op_i_1_done_not_op_delay_op_27\: and_op
	generic map (
		w_in1 => 1,
		w_in2 => 1,
		w_out => 1
	)
	port map (
		I0 => s203,
		I1 => s204,
		O0 => s206
	);

	\c415\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s624,
		a_delayed => s625,
		clk => \clk\,
		reset => \reset\
	);

	\xS_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s323,
		O0 => s335,
		clk => \clk\,
		reset => \reset\,
		we => s537(0)
	);

	\c326\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s447,
		clk => \clk\,
		reset => \reset\
	);

	\xF_0_add_op_s_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s359,
		I1 => s360,
		O0 => s361
	);

	\q1_add_op_s_q0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s609,
		I1 => s126,
		O0 => s124
	);

	\g3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s639,
		O0 => s88,
		clk => \clk\,
		reset => \reset\,
		we => s431(0)
	);

	\c381\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s557,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_35\: delay_op
	generic map (
		bits => 1,
		delay => 35
	)
	port map (
		a(0) => s191,
		a_delayed => s189,
		clk => \clk\,
		reset => \reset\
	);

	\c318\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s431,
		clk => \clk\,
		reset => \reset\
	);

	\Q_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s127,
		O0 => s158,
		clk => \clk\,
		reset => \reset\,
		we => s467(0)
	);

	\j_step_delay_op_11\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s191,
		a_delayed => s45,
		clk => \clk\,
		reset => \reset\
	);

	\f4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s68,
		clk => \clk\,
		reset => \reset\,
		we => s36(0)
	);

	\c407\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s608,
		a_delayed => s609,
		clk => \clk\,
		reset => \reset\
	);

	\xf1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s614,
		clk => \clk\,
		reset => \reset\,
		we => s220(0)
	);

	\xq0a_mult_op_s_p_C0_6_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s285,
		I1 => s286,
		O0 => s287
	);

	\c352\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s499,
		clk => \clk\,
		reset => \reset\
	);

	\xF3r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s374,
		O0 => s399,
		clk => \clk\,
		reset => \reset\,
		we => s563(0)
	);

	\c386\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s567,
		clk => \clk\,
		reset => \reset\
	);

	\C1_mult_op_s_p_S_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s136,
		I1 => s142,
		O0 => s139,
		clk => \clk\
	);

	\c394\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s582,
		a_delayed => s583,
		clk => \clk\,
		reset => \reset\
	);

	\dct_o\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address => s417,
		clk => \clk\,
		data_in => s414,
		data_out => s418,
		we => s415(0)
	);

	\C3_mult_op_s_p_S_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s155,
		I1 => s156,
		O0 => s159,
		clk => \clk\
	);

	\c339\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s473,
		clk => \clk\,
		reset => \reset\
	);

	\xF_6_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s385,
		O0 => s386
	);

	\xi\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 1
	)
	port map (
		clk => \clk\,
		clk_en => s210(0),
		done => s419,
		input => s207,
		output => s416,
		reset => \reset\,
		step => s413,
		termination => s208
	);

	\xq0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s282,
		O0 => s283,
		clk => \clk\,
		reset => \reset\,
		we => s519(0)
	);

	\xf1_add_op_s_xf6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s615,
		I1 => s249,
		O0 => s247
	);

	\c428\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s650,
		a_delayed => s651,
		clk => \clk\,
		reset => \reset\
	);

	\C1_mult_op_s_p_xQ_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s336,
		I1 => s337,
		O0 => s339,
		clk => \clk\
	);

	\C6_mult_op_s_p_r1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s102,
		I1 => s112,
		O0 => s106,
		clk => \clk\
	);

	\c373\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s541,
		clk => \clk\,
		reset => \reset\
	);

	\F_3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s161,
		O0 => s175,
		clk => \clk\,
		reset => \reset\,
		we => s479(0)
	);

	\c399\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s610,
		a_delayed => s593,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_32\: delay_op
	generic map (
		bits => 1,
		delay => 32
	)
	port map (
		a(0) => s570,
		a_delayed => s400,
		clk => \clk\,
		reset => \reset\
	);

	\c344\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s483,
		clk => \clk\,
		reset => \reset\
	);

	\init_delay_op_2\: delay_op
	generic map (
		bits => 1,
		delay => 2
	)
	port map (
		a(0) => s198,
		a_delayed => s19,
		clk => \clk\,
		reset => \reset\
	);

	\xf3_sub_op_s_xf4\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s260,
		I1 => s261,
		O0 => s642
	);

	\xf6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s249,
		clk => \clk\,
		reset => \reset\,
		we => s235(0)
	);

	\c378\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s551,
		clk => \clk\,
		reset => \reset\
	);

	\C6_mult_op_s_p_r0_6_sub_op_s_C2_mult_op_s_p_r1_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s113,
		I1 => s114,
		O0 => s115
	);

	\C3_mult_op_s_p_xS_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s348,
		I1 => s349,
		O0 => s352,
		clk => \clk\
	);

	\c323\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s441,
		clk => \clk\,
		reset => \reset\
	);

	\j_plus_64\: reg_op
	generic map (
		initial => 0,
		w_in => 10
	)
	port map (
		I0 => s15,
		O0 => s17,
		clk => \clk\,
		reset => \reset\
	);

	\xF_2_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s369,
		O0 => s370
	);

	\xR_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s301,
		O0 => s622,
		clk => \clk\,
		reset => \reset\,
		we => s525(0)
	);

	\c331\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s457,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_5\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s570,
		a_delayed => s223,
		clk => \clk\,
		reset => \reset\
	);

	\c420\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s634,
		a_delayed => s635,
		clk => \clk\,
		reset => \reset\
	);

	\xF_4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s573,
		O0 => s375,
		clk => \clk\,
		reset => \reset\,
		we => s551(0)
	);

	\h3_add_op_s_g3\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s87,
		I1 => s88,
		O0 => s86
	);

	\c365\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s525,
		clk => \clk\,
		reset => \reset\
	);

	\xq1_add_op_s_xq0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s621,
		I1 => s319,
		O0 => s317
	);

	\xq0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s288,
		O0 => s319,
		clk => \clk\,
		reset => \reset\,
		we => s521(0)
	);

	\F_2_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s171,
		O0 => s173
	);

	\q0a_mult_op_s_p_C0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s96,
		I1 => s97,
		O0 => s98,
		clk => \clk\
	);

	\xg0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s241,
		O0 => s266,
		clk => \clk\,
		reset => \reset\,
		we => s489(0)
	);

	\c425\: delay_op
	generic map (
		bits => 32,
		delay => 5
	)
	port map (
		a => s644,
		a_delayed => s645,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_10\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s570,
		a_delayed => s238,
		clk => \clk\,
		reset => \reset\
	);

	\c336\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s486,
		a_delayed => s467,
		clk => \clk\,
		reset => \reset\
	);

	\xP_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s575,
		O0 => s572,
		clk => \clk\,
		reset => \reset\,
		we => s531(0)
	);

	\c404\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s602,
		a_delayed => s603,
		clk => \clk\,
		reset => \reset\
	);

	\f7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s50,
		clk => \clk\,
		reset => \reset\,
		we => s45(0)
	);

	\F_5_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s182,
		O0 => s184
	);

	\c315\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s425,
		clk => \clk\,
		reset => \reset\
	);

	\R_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s115,
		O0 => s648,
		clk => \clk\,
		reset => \reset\,
		we => s459(0)
	);

	\C1_mult_op_s_p_xS_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s329,
		I1 => s335,
		O0 => s332,
		clk => \clk\
	);

	\c370\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s570,
		a_delayed => s535,
		clk => \clk\,
		reset => \reset\
	);

	\c357\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s509,
		clk => \clk\,
		reset => \reset\
	);

	\f2_add_op_s_f5\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s637,
		I1 => s62,
		O0 => s578
	);

	\c412\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s630,
		a_delayed => s619,
		clk => \clk\,
		reset => \reset\
	);

	\xF2r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s370,
		O0 => s396,
		clk => \clk\,
		reset => \reset\,
		we => s561(0)
	);

	\i_1_step_delay_op_28\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s486,
		a_delayed => s203,
		clk => \clk\,
		reset => \reset\
	);

	\s0a\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s86,
		O0 => s90,
		clk => \clk\,
		reset => \reset\,
		we => s449(0)
	);

	\xF_5_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s379,
		I1 => s380,
		O0 => s381
	);

	\C3_mult_op_s_p_Q_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s148,
		I1 => s158,
		O0 => s152,
		clk => \clk\
	);

	\c391\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s576,
		a_delayed => s577,
		clk => \clk\,
		reset => \reset\
	);

	\C6_mult_op_s_p_xr1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s295,
		I1 => s305,
		O0 => s299,
		clk => \clk\
	);

	\xr1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s274,
		O0 => s305,
		clk => \clk\,
		reset => \reset\,
		we => s511(0)
	);

	\c362\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s519,
		clk => \clk\,
		reset => \reset\
	);

	\C6_mult_op_s_p_xr0_6_sub_op_s_C2_mult_op_s_p_xr1_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s306,
		I1 => s307,
		O0 => s308
	);

	\xF_5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s347,
		O0 => s379,
		clk => \clk\,
		reset => \reset\,
		we => s545(0)
	);

	\c417\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s636,
		a_delayed => s629,
		clk => \clk\,
		reset => \reset\
	);

	\g0_sub_op_s_h0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s73,
		I1 => s74,
		O0 => s75
	);

	\xF_7_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s389,
		O0 => s390
	);

	\F_6\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s649,
		O0 => s186,
		clk => \clk\,
		reset => \reset\,
		we => s487(0)
	);

	\c341\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s477,
		clk => \clk\,
		reset => \reset\
	);

	\i_done_not_op\: not_op
	generic map (
		w_in => 1,
		w_out => 1
	)
	port map (
		I0(0) => s213,
		O0 => s10
	);

	\p0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s72,
		O0 => s119,
		clk => \clk\,
		reset => \reset\,
		we => s437(0)
	);

	\c396\: delay_op
	generic map (
		bits => 32,
		delay => 3
	)
	port map (
		a => s646,
		a_delayed => s587,
		clk => \clk\,
		reset => \reset\
	);

	\C3_mult_op_s_p_S_0_6_sub_op_s_C5_mult_op_s_p_Q_0_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s159,
		I1 => s160,
		O0 => s161
	);

	\xh3_add_op_s_xg3\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s280,
		I1 => s281,
		O0 => s279
	);

	\xf3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s237,
		O0 => s260,
		clk => \clk\,
		reset => \reset\,
		we => s226(0)
	);

	\xi_step_delay_op_29\: delay_op
	generic map (
		bits => 1,
		delay => 29
	)
	port map (
		a(0) => s413,
		a_delayed => s415,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_8\: delay_op
	generic map (
		bits => 1,
		delay => 8
	)
	port map (
		a(0) => s191,
		a_delayed => s36,
		clk => \clk\,
		reset => \reset\
	);

	\c349\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s493,
		clk => \clk\,
		reset => \reset\
	);

	\xS_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s326,
		O0 => s349,
		clk => \clk\,
		reset => \reset\,
		we => s539(0)
	);

	\c328\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s451,
		clk => \clk\,
		reset => \reset\
	);

	\i_done_delay_op_28_\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s213,
		a_delayed => s214,
		clk => \clk\,
		reset => \reset\
	);

	\s1_add_op_s_s0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s581,
		I1 => s132,
		O0 => s130
	);

	\c383\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s561,
		clk => \clk\,
		reset => \reset\
	);

	\g1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s54,
		O0 => s79,
		clk => \clk\,
		reset => \reset\,
		we => s425(0)
	);

	\xF_1_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s363,
		I1 => s364,
		O0 => s365
	);

	\xF4r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s378,
		O0 => s402,
		clk => \clk\,
		reset => \reset\,
		we => s565(0)
	);

	\xh3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s250,
		O0 => s280,
		clk => \clk\,
		reset => \reset\,
		we => s495(0)
	);

	\c388\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s571,
		clk => \clk\,
		reset => \reset\
	);

	\xF_3_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s373,
		O0 => s374
	);

	\c422\: delay_op
	generic map (
		bits => 32,
		delay => 2
	)
	port map (
		a => s638,
		a_delayed => s639,
		clk => \clk\,
		reset => \reset\
	);

	\xF_3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s354,
		O0 => s371,
		clk => \clk\,
		reset => \reset\,
		we => s547(0)
	);

	\c333\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s461,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_7\: delay_op
	generic map (
		bits => 1,
		delay => 7
	)
	port map (
		a(0) => s570,
		a_delayed => s229,
		clk => \clk\,
		reset => \reset\
	);

	\xs0a_mult_op_s_p_C0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s289,
		I1 => s290,
		O0 => s291,
		clk => \clk\
	);

	\f0_sub_op_s_f7\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s601,
		I1 => s50,
		O0 => s51
	);

	\c354\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s503,
		clk => \clk\,
		reset => \reset\
	);

	\C7_mult_op_s_p_S_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s141,
		I1 => s142,
		O0 => s145,
		clk => \clk\
	);

	\j\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 1,
		steps => 9
	)
	port map (
		clk => \clk\,
		clk_en => s11(0),
		input => s6,
		load => s12,
		output => s16,
		reset => \reset\,
		step => s191,
		termination => s7
	);

	\c320\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s435,
		clk => \clk\,
		reset => \reset\
	);

	\xp0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s265,
		O0 => s312,
		clk => \clk\,
		reset => \reset\,
		we => s505(0)
	);

	\C3_mult_op_s_p_xQ_0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s341,
		I1 => s351,
		O0 => s345,
		clk => \clk\
	);

	\f2\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s636,
		clk => \clk\,
		reset => \reset\,
		we => s30(0)
	);

	\c409\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s612,
		a_delayed => s613,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_36\: delay_op
	generic map (
		bits => 1,
		delay => 36
	)
	port map (
		a(0) => s191,
		a_delayed => s193,
		clk => \clk\,
		reset => \reset\
	);

	\xs0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s294,
		O0 => s325,
		clk => \clk\,
		reset => \reset\,
		we => s523(0)
	);

	\xf2_add_op_s_xf5\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s587,
		I1 => s255,
		O0 => s602
	);

	\c375\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s545,
		clk => \clk\,
		reset => \reset\
	);

	\C6_mult_op_s_p_r1_6_add_op_s_C2_mult_op_s_p_r0_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s106,
		I1 => s107,
		O0 => s108
	);

	\c325\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s486,
		a_delayed => s445,
		clk => \clk\,
		reset => \reset\
	);

	\i_1_done_not_op_delay_op_27\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a => s202,
		a_delayed => s204,
		clk => \clk\,
		reset => \reset\
	);

	\c414\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s622,
		a_delayed => s623,
		clk => \clk\,
		reset => \reset\
	);

	\xF_7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s340,
		O0 => s387,
		clk => \clk\,
		reset => \reset\,
		we => s543(0)
	);

	\f3_add_op_s_f4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s67,
		I1 => s68,
		O0 => s634
	);

	\c359\: delay_op
	generic map (
		bits => 1,
		delay => 12
	)
	port map (
		a(0) => s570,
		a_delayed => s513,
		clk => \clk\,
		reset => \reset\
	);

	\q1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s82,
		O0 => s608,
		clk => \clk\,
		reset => \reset\,
		we => s445(0)
	);

	\p0_sub_op_s_p1\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s119,
		I1 => s120,
		O0 => s632
	);

	\c380\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s555,
		clk => \clk\,
		reset => \reset\
	);

	\xmf\: mux_m_op
	generic map (
		N_ops => 8,
		N_sels => 7,
		w_in => 32
	)
	port map (
		I0(255 downto 224) => s391(31 downto 0),
		I0(223 downto 192) => s393(31 downto 0),
		I0(191 downto 160) => s396(31 downto 0),
		I0(159 downto 128) => s399(31 downto 0),
		I0(127 downto 96) => s402(31 downto 0),
		I0(95 downto 64) => s405(31 downto 0),
		I0(63 downto 32) => s408(31 downto 0),
		I0(31 downto 0) => s411(31 downto 0),
		O0 => s414,
		Sel(6 downto 6) => s394(0 downto 0),
		Sel(5 downto 5) => s397(0 downto 0),
		Sel(4 downto 4) => s400(0 downto 0),
		Sel(3 downto 3) => s403(0 downto 0),
		Sel(2 downto 2) => s406(0 downto 0),
		Sel(1 downto 1) => s409(0 downto 0),
		Sel(0 downto 0) => s412(0 downto 0)
	);

	\C3_mult_op_s_p_xS_0_6_sub_op_s_C5_mult_op_s_p_xQ_0_6\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s352,
		I1 => s353,
		O0 => s354
	);

	\h3\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s57,
		O0 => s87,
		clk => \clk\,
		reset => \reset\,
		we => s427(0)
	);

	\c401\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s596,
		a_delayed => s597,
		clk => \clk\,
		reset => \reset\
	);

	\F_3_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s175,
		O0 => s177
	);

	\xj_step_delay_op_34\: delay_op
	generic map (
		bits => 1,
		delay => 34
	)
	port map (
		a(0) => s570,
		a_delayed => s406,
		clk => \clk\,
		reset => \reset\
	);

	\F_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s140,
		O0 => s167,
		clk => \clk\,
		reset => \reset\,
		we => s473(0)
	);

	\c346\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s487,
		clk => \clk\,
		reset => \reset\
	);

	\j_step_delay_op_5\: delay_op
	generic map (
		bits => 1,
		delay => 5
	)
	port map (
		a(0) => s191,
		a_delayed => s27,
		clk => \clk\,
		reset => \reset\
	);

	\xg0_sub_op_s_xh0\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s266,
		I1 => s267,
		O0 => s268
	);

	\c367\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s529,
		clk => \clk\,
		reset => \reset\
	);

	\s0a_mult_op_s_p_C0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s90,
		I1 => s91,
		O0 => s92,
		clk => \clk\
	);

	\xs1_add_op_s_xs0\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s611,
		I1 => s325,
		O0 => s323
	);

	\S_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s133,
		O0 => s156,
		clk => \clk\,
		reset => \reset\,
		we => s471(0)
	);

	\xF7r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s390,
		O0 => s411,
		clk => \clk\,
		reset => \reset\,
		we => s571(0)
	);

	\c351\: delay_op
	generic map (
		bits => 1,
		delay => 11
	)
	port map (
		a(0) => s570,
		a_delayed => s497,
		clk => \clk\,
		reset => \reset\
	);

	\xq0a_mult_op_s_p_C0_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s283,
		I1 => s284,
		O0 => s285,
		clk => \clk\
	);

	\j_step_delay_op_10\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s191,
		a_delayed => s42,
		clk => \clk\,
		reset => \reset\
	);

	\f5\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s44,
		O0 => s62,
		clk => \clk\,
		reset => \reset\,
		we => s39(0)
	);

	\F_6_shr_c_op_s_13\: shr_c_op_s
	generic map (
		s_amount => 13,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s186,
		O0 => s188
	);

	\c406\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s606,
		a_delayed => s607,
		clk => \clk\,
		reset => \reset\
	);

	\Q_1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s124,
		O0 => s144,
		clk => \clk\,
		reset => \reset\,
		we => s465(0)
	);

	\c317\: delay_op
	generic map (
		bits => 1,
		delay => 10
	)
	port map (
		a(0) => s486,
		a_delayed => s429,
		clk => \clk\,
		reset => \reset\
	);

	\C7_mult_op_s_p_xS_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s334,
		I1 => s335,
		O0 => s338,
		clk => \clk\
	);

	\q0a_mult_op_s_p_C0_6_add_op_s_32767_shr_c_op_s_16\: shr_c_op_s
	generic map (
		s_amount => 16,
		w_in1 => 32,
		w_out => 32
	)
	port map (
		I0 => s100,
		O0 => s101
	);

	\c372\: delay_op
	generic map (
		bits => 1,
		delay => 20
	)
	port map (
		a(0) => s570,
		a_delayed => s539,
		clk => \clk\,
		reset => \reset\
	);

	\c427\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s648,
		a_delayed => s649,
		clk => \clk\,
		reset => \reset\
	);

	\xF_0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s607,
		O0 => s359,
		clk => \clk\,
		reset => \reset\,
		we => s549(0)
	);

	\xf0_sub_op_s_xf7\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s619,
		I1 => s243,
		O0 => s244
	);

	\c338\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s486,
		a_delayed => s471,
		clk => \clk\,
		reset => \reset\
	);

	\xj\: counter
	generic map (
		bits => 10,
		condition => 0,
		down => 0,
		increment => 8,
		steps => 8
	)
	port map (
		clk => \clk\,
		clk_en => s214(0),
		input => s211,
		reset => \reset\,
		step => s570,
		termination => s212
	);

	\xF_6_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s383,
		I1 => s384,
		O0 => s385
	);

	\F_7\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s147,
		O0 => s190,
		clk => \clk\,
		reset => \reset\,
		we => s475(0)
	);

	\c393\: delay_op
	generic map (
		bits => 32,
		delay => 7
	)
	port map (
		a => s650,
		a_delayed => s581,
		clk => \clk\,
		reset => \reset\
	);

	\C3_mult_op_s_p_Q_0_6_add_op_s_C5_mult_op_s_p_S_0_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s152,
		I1 => s153,
		O0 => s154
	);

	\dct_io_tmp\: block_ram
	generic map (
		address_width => 10,
		data_width => 32
	)
	port map (
		address => s199,
		clk => \clk\,
		data_in => s205,
		data_out => s237,
		we => s206(0)
	);

	\C6_mult_op_s_p_xr1_6_add_op_s_C2_mult_op_s_p_xr0_6\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s299,
		I1 => s300,
		O0 => s301
	);

	\C2_mult_op_s_p_r1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s111,
		I1 => s112,
		O0 => s114,
		clk => \clk\
	);

	\c377\: delay_op
	generic map (
		bits => 1,
		delay => 27
	)
	port map (
		a(0) => s570,
		a_delayed => s549,
		clk => \clk\,
		reset => \reset\
	);

	\c343\: delay_op
	generic map (
		bits => 1,
		delay => 26
	)
	port map (
		a(0) => s486,
		a_delayed => s481,
		clk => \clk\,
		reset => \reset\
	);

	\xf3_add_op_s_xf4\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s260,
		I1 => s261,
		O0 => s576
	);

	\xF1r\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s366,
		O0 => s393,
		clk => \clk\,
		reset => \reset\,
		we => s559(0)
	);

	\c398\: delay_op
	generic map (
		bits => 32,
		delay => 6
	)
	port map (
		a => s590,
		a_delayed => s591,
		clk => \clk\,
		reset => \reset\
	);

	\F_4\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s627,
		O0 => s180,
		clk => \clk\,
		reset => \reset\,
		we => s483(0)
	);

	\xj_step_delay_op_31\: delay_op
	generic map (
		bits => 1,
		delay => 31
	)
	port map (
		a(0) => s570,
		a_delayed => s397,
		clk => \clk\,
		reset => \reset\
	);

	\j_add_op_s_64\: add_op_s
	generic map (
		w_in1 => 10,
		w_in2 => 10,
		w_out => 10
	)
	port map (
		I0 => s16,
		I1 => s14,
		O0 => s15
	);

	\xq1\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s275,
		O0 => s620,
		clk => \clk\,
		reset => \reset\,
		we => s513(0)
	);

	\j_step_delay_op_30\: delay_op
	generic map (
		bits => 1,
		delay => 30
	)
	port map (
		a(0) => s191,
		a_delayed => s170,
		clk => \clk\,
		reset => \reset\
	);

	\c364\: delay_op
	generic map (
		bits => 1,
		delay => 19
	)
	port map (
		a(0) => s570,
		a_delayed => s523,
		clk => \clk\,
		reset => \reset\
	);

	\g1_sub_op_s_h1\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s79,
		I1 => s80,
		O0 => s81
	);

	\xp0_sub_op_s_xp1\: sub_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s312,
		I1 => s313,
		O0 => s574
	);

	\c419\: delay_op
	generic map (
		bits => 32,
		delay => 6
	)
	port map (
		a => s632,
		a_delayed => s633,
		clk => \clk\,
		reset => \reset\
	);

	\xj_step_delay_op_4\: delay_op
	generic map (
		bits => 1,
		delay => 4
	)
	port map (
		a(0) => s570,
		a_delayed => s220,
		clk => \clk\,
		reset => \reset\
	);

	\r0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s75,
		O0 => s110,
		clk => \clk\,
		reset => \reset\,
		we => s439(0)
	);

	\xF_2_add_op_s_32767\: add_op_s
	generic map (
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s367,
		I1 => s368,
		O0 => s369
	);

	\c330\: delay_op
	generic map (
		bits => 1,
		delay => 18
	)
	port map (
		a(0) => s486,
		a_delayed => s455,
		clk => \clk\,
		reset => \reset\
	);

	\h0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s635,
		O0 => s74,
		clk => \clk\,
		reset => \reset\,
		we => s433(0)
	);

	\C7_mult_op_s_p_Q_1_6\: mult_op_s_p
	generic map (
		k => 6,
		w_in1 => 32,
		w_in2 => 32,
		w_out => 32
	)
	port map (
		I0 => s134,
		I1 => s144,
		O0 => s138,
		clk => \clk\
	);

	\g0\: reg_op
	generic map (
		initial => 0,
		w_in => 32
	)
	port map (
		I0 => s48,
		O0 => s73,
		clk => \clk\,
		reset => \reset\,
		we => s421(0)
	);

	\c385\: delay_op
	generic map (
		bits => 1,
		delay => 28
	)
	port map (
		a(0) => s570,
		a_delayed => s565,
		clk => \clk\,
		reset => \reset\
	);

	\done\ <= s419;
	s4 <= conv_std_logic_vector(8, 10);
	s341 <= conv_std_logic_vector(9632, 32);
	s143 <= conv_std_logic_vector(11362, 32);
	s295 <= conv_std_logic_vector(4433, 32);
	s99 <= conv_std_logic_vector(32767, 32);
	s364 <= conv_std_logic_vector(32767, 32);
	s207 <= conv_std_logic_vector(0, 10);
	s329 <= conv_std_logic_vector(11362, 32);
	s134 <= conv_std_logic_vector(2260, 32);
	s384 <= conv_std_logic_vector(32767, 32);
	s286 <= conv_std_logic_vector(32767, 32);
	s198 <= \init\;
	s91 <= conv_std_logic_vector(46341, 32);
	s348 <= conv_std_logic_vector(9632, 32);
	s150 <= conv_std_logic_vector(6436, 32);
	s104 <= conv_std_logic_vector(10703, 32);
	s302 <= conv_std_logic_vector(4433, 32);
	s372 <= conv_std_logic_vector(32767, 32);
	s1 <= conv_std_logic_vector(640, 10);
	s211 <= conv_std_logic_vector(0, 10);
	s141 <= conv_std_logic_vector(2260, 32);
	s336 <= conv_std_logic_vector(11362, 32);
	s292 <= conv_std_logic_vector(32767, 32);
	s97 <= conv_std_logic_vector(46341, 32);
	s327 <= conv_std_logic_vector(2260, 32);
	s360 <= conv_std_logic_vector(6, 32);
	s157 <= conv_std_logic_vector(6436, 32);
	s284 <= conv_std_logic_vector(46341, 32);
	\output\ <= s418;
	s111 <= conv_std_logic_vector(10703, 32);
	s380 <= conv_std_logic_vector(32767, 32);
	s148 <= conv_std_logic_vector(9632, 32);
	s14 <= conv_std_logic_vector(64, 10);
	s343 <= conv_std_logic_vector(6436, 32);
	s102 <= conv_std_logic_vector(4433, 32);
	s368 <= conv_std_logic_vector(32767, 32);
	s297 <= conv_std_logic_vector(10703, 32);
	s334 <= conv_std_logic_vector(2260, 32);
	s0 <= conv_std_logic_vector(0, 10);
	s208 <= conv_std_logic_vector(640, 10);
	s93 <= conv_std_logic_vector(32767, 32);
	s290 <= conv_std_logic_vector(46341, 32);
	s136 <= conv_std_logic_vector(11362, 32);
	s388 <= conv_std_logic_vector(32767, 32);
	s155 <= conv_std_logic_vector(9632, 32);
	s350 <= conv_std_logic_vector(6436, 32);
	s212 <= conv_std_logic_vector(640, 10);
	s376 <= conv_std_logic_vector(4, 32);
	s109 <= conv_std_logic_vector(4433, 32);
	s304 <= conv_std_logic_vector(10703, 32);

end behavior;

