-- IEEE Libraries -- 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_mult_in is 
generic( 
	data_width : integer := 8; 
	address_width : integer := 8 
); 
port( 
	data_in_0 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_0 : in std_logic_vector(address_width-1 downto 0); 
	we_0 : in std_logic := '0'; 
	oe_0 : in std_logic := '1'; 
	data_out_0 : out std_logic_vector(data_width-1 downto 0); 
	data_in_1 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_1 : in std_logic_vector(address_width-1 downto 0); 
	we_1 : in std_logic := '0'; 
	oe_1 : in std_logic := '1'; 
	data_out_1 : out std_logic_vector(data_width-1 downto 0); 
	data_in_2 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_2 : in std_logic_vector(address_width-1 downto 0); 
	we_2 : in std_logic := '0'; 
	oe_2 : in std_logic := '1'; 
	data_out_2 : out std_logic_vector(data_width-1 downto 0); 
	data_in_3 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_3 : in std_logic_vector(address_width-1 downto 0); 
	we_3 : in std_logic := '0'; 
	oe_3 : in std_logic := '1'; 
	data_out_3 : out std_logic_vector(data_width-1 downto 0); 
	data_in_4 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_4 : in std_logic_vector(address_width-1 downto 0); 
	we_4 : in std_logic := '0'; 
	oe_4 : in std_logic := '1'; 
	data_out_4 : out std_logic_vector(data_width-1 downto 0); 
	data_in_5 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_5 : in std_logic_vector(address_width-1 downto 0); 
	we_5 : in std_logic := '0'; 
	oe_5 : in std_logic := '1'; 
	data_out_5 : out std_logic_vector(data_width-1 downto 0); 
	data_in_6 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_6 : in std_logic_vector(address_width-1 downto 0); 
	we_6 : in std_logic := '0'; 
	oe_6 : in std_logic := '1'; 
	data_out_6 : out std_logic_vector(data_width-1 downto 0); 
	data_in_7 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_7 : in std_logic_vector(address_width-1 downto 0); 
	we_7 : in std_logic := '0'; 
	oe_7 : in std_logic := '1'; 
	data_out_7 : out std_logic_vector(data_width-1 downto 0); 
	data_in_8 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_8 : in std_logic_vector(address_width-1 downto 0); 
	we_8 : in std_logic := '0'; 
	oe_8 : in std_logic := '1'; 
	data_out_8 : out std_logic_vector(data_width-1 downto 0); 
	data_in_9 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_9 : in std_logic_vector(address_width-1 downto 0); 
	we_9 : in std_logic := '0'; 
	oe_9 : in std_logic := '1'; 
	data_out_9 : out std_logic_vector(data_width-1 downto 0); 
	data_in_10 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_10 : in std_logic_vector(address_width-1 downto 0); 
	we_10 : in std_logic := '0'; 
	oe_10 : in std_logic := '1'; 
	data_out_10 : out std_logic_vector(data_width-1 downto 0); 
	data_in_11 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_11 : in std_logic_vector(address_width-1 downto 0); 
	we_11 : in std_logic := '0'; 
	oe_11 : in std_logic := '1'; 
	data_out_11 : out std_logic_vector(data_width-1 downto 0); 
	data_in_12 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_12 : in std_logic_vector(address_width-1 downto 0); 
	we_12 : in std_logic := '0'; 
	oe_12 : in std_logic := '1'; 
	data_out_12 : out std_logic_vector(data_width-1 downto 0); 
	data_in_13 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_13 : in std_logic_vector(address_width-1 downto 0); 
	we_13 : in std_logic := '0'; 
	oe_13 : in std_logic := '1'; 
	data_out_13 : out std_logic_vector(data_width-1 downto 0); 
	data_in_14 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_14 : in std_logic_vector(address_width-1 downto 0); 
	we_14 : in std_logic := '0'; 
	oe_14 : in std_logic := '1'; 
	data_out_14 : out std_logic_vector(data_width-1 downto 0); 
	data_in_15 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_15 : in std_logic_vector(address_width-1 downto 0); 
	we_15 : in std_logic := '0'; 
	oe_15 : in std_logic := '1'; 
	data_out_15 : out std_logic_vector(data_width-1 downto 0); 
	clk : in std_logic); 
end block_ram_mult_in; 

architecture rtl of block_ram_mult_in is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_0 : std_logic_vector(address_width-1 downto 0); 
signal read_1 : std_logic_vector(address_width-1 downto 0); 
signal read_2 : std_logic_vector(address_width-1 downto 0); 
signal read_3 : std_logic_vector(address_width-1 downto 0); 
signal read_4 : std_logic_vector(address_width-1 downto 0); 
signal read_5 : std_logic_vector(address_width-1 downto 0); 
signal read_6 : std_logic_vector(address_width-1 downto 0); 
signal read_7 : std_logic_vector(address_width-1 downto 0); 
signal read_8 : std_logic_vector(address_width-1 downto 0); 
signal read_9 : std_logic_vector(address_width-1 downto 0); 
signal read_10 : std_logic_vector(address_width-1 downto 0); 
signal read_11 : std_logic_vector(address_width-1 downto 0); 
signal read_12 : std_logic_vector(address_width-1 downto 0); 
signal read_13 : std_logic_vector(address_width-1 downto 0); 
signal read_14 : std_logic_vector(address_width-1 downto 0); 
signal read_15 : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
	 ("00000000000000000000000000000000"),	 -- 127	0
	 ("00000000000000000000000000000000"),	 -- 126	0
	 ("00000000000000000000000000000000"),	 -- 125	0
	 ("00000000000000000000000000000000"),	 -- 124	0
	 ("00000000000000000000000000000000"),	 -- 123	0
	 ("00000000000000000000000000000000"),	 -- 122	0
	 ("00000000000000000000000000000000"),	 -- 121	0
	 ("00000000000000000000000000000000"),	 -- 120	0
	 ("00000000000000000000000000000000"),	 -- 119	0
	 ("00000000000000000000000000000000"),	 -- 118	0
	 ("00000000000000000000000000000000"),	 -- 117	0
	 ("00000000000000000000000000000000"),	 -- 116	0
	 ("00000000000000000000000000000000"),	 -- 115	0
	 ("00000000000000000000000000000000"),	 -- 114	0
	 ("00000000000000000000000000000000"),	 -- 113	0
	 ("00000000000000000000000000000000"),	 -- 112	0
	 ("00000000000000000000000000000000"),	 -- 111	0
	 ("00000000000000000000000000000000"),	 -- 110	0
	 ("00000000000000000000000000000000"),	 -- 109	0
	 ("00000000000000000000000000000000"),	 -- 108	0
	 ("00000000000000000000000000000000"),	 -- 107	0
	 ("00000000000000000000000000000000"),	 -- 106	0
	 ("00000000000000000000000000000000"),	 -- 105	0
	 ("00000000000000000000000000000000"),	 -- 104	0
	 ("00000000000000000000000000000000"),	 -- 103	0
	 ("00000000000000000000000000000000"),	 -- 102	0
	 ("00000000000000000000000000000000"),	 -- 101	0
	 ("00000000000000000000000000000000"),	 -- 100	0
	 ("00000000000000000000000001100011"),	 -- 99	99
	 ("00000000000000000000000000100110"),	 -- 98	38
	 ("00000000000000000000000001100001"),	 -- 97	97
	 ("00000000000000000000000001100000"),	 -- 96	96
	 ("00000000000000000000000001011111"),	 -- 95	95
	 ("00000000000000000000000001011110"),	 -- 94	94
	 ("00000000000000000000000001011101"),	 -- 93	93
	 ("00000000000000000000000001011100"),	 -- 92	92
	 ("00000000000000000000000001100000"),	 -- 91	96
	 ("00000000000000000000000001011111"),	 -- 90	95
	 ("00000000000000000000000001011001"),	 -- 89	89
	 ("00000000000000000000000000011100"),	 -- 88	28
	 ("00000000000000000000000001010111"),	 -- 87	87
	 ("00000000000000000000000001010110"),	 -- 86	86
	 ("00000000000000000000000001010101"),	 -- 85	85
	 ("00000000000000000000000001010100"),	 -- 84	84
	 ("00000000000000000000000001010011"),	 -- 83	83
	 ("00000000000000000000000001010010"),	 -- 82	82
	 ("00000000000000000000000001010111"),	 -- 81	87
	 ("00000000000000000000000001010100"),	 -- 80	84
	 ("00000000000000000000000000011101"),	 -- 79	29
	 ("00000000000000000000000000010010"),	 -- 78	18
	 ("00000000000000000000000000100101"),	 -- 77	37
	 ("00000000000000000000000001100000"),	 -- 76	96
	 ("00000000000000000000000000110111"),	 -- 75	55
	 ("00000000000000000000000000100010"),	 -- 74	34
	 ("00000000000000000000000001010011"),	 -- 73	83
	 ("00000000000000000000000001001000"),	 -- 72	72
	 ("00000000000000000000000001000100"),	 -- 71	68
	 ("00000000000000000000000000110101"),	 -- 70	53
	 ("00000000000000000000000001000101"),	 -- 69	69
	 ("00000000000000000000000001000100"),	 -- 68	68
	 ("00000000000000000000000001000011"),	 -- 67	67
	 ("00000000000000000000000001000000"),	 -- 66	64
	 ("00000000000000000000000001000001"),	 -- 65	65
	 ("00000000000000000000000001000000"),	 -- 64	64
	 ("00000000000000000000000001000010"),	 -- 63	66
	 ("00000000000000000000000000111110"),	 -- 62	62
	 ("00000000000000000000000001000101"),	 -- 61	69
	 ("00000000000000000000000000111100"),	 -- 60	60
	 ("00000000000000000000000000011101"),	 -- 59	29
	 ("00000000000000000000000000010010"),	 -- 58	18
	 ("00000000000000000000000000100101"),	 -- 57	37
	 ("00000000000000000000000001100000"),	 -- 56	96
	 ("00000000000000000000000000101101"),	 -- 55	45
	 ("00000000000000000000000000100010"),	 -- 54	34
	 ("00000000000000000000000001010011"),	 -- 53	83
	 ("00000000000000000000000001010010"),	 -- 52	82
	 ("00000000000000000000000000111100"),	 -- 51	60
	 ("00000000000000000000000000110100"),	 -- 50	52
	 ("00000000000000000000000001011001"),	 -- 49	89
	 ("00000000000000000000000000110000"),	 -- 48	48
	 ("00000000000000000000000000101111"),	 -- 47	47
	 ("00000000000000000000000000101110"),	 -- 46	46
	 ("00000000000000000000000000101101"),	 -- 45	45
	 ("00000000000000000000000000101100"),	 -- 44	44
	 ("00000000000000000000000001001001"),	 -- 43	73
	 ("00000000000000000000000000101010"),	 -- 42	42
	 ("00000000000000000000000000101001"),	 -- 41	41
	 ("00000000000000000000000000101000"),	 -- 40	40
	 ("00000000000000000000000000011101"),	 -- 39	29
	 ("00000000000000000000000000010010"),	 -- 38	18
	 ("00000000000000000000000001100001"),	 -- 37	97
	 ("00000000000000000000000001100000"),	 -- 36	96
	 ("00000000000000000000000000101101"),	 -- 35	45
	 ("00000000000000000000000000100010"),	 -- 34	34
	 ("00000000000000000000000001010011"),	 -- 33	83
	 ("00000000000000000000000001001000"),	 -- 32	72
	 ("00000000000000000000000000001100"),	 -- 31	12
	 ("00000000000000000000000000110110"),	 -- 30	54
	 ("00000000000000000000000000011101"),	 -- 29	29
	 ("00000000000000000000000000011100"),	 -- 28	28
	 ("00000000000000000000000000011011"),	 -- 27	27
	 ("00000000000000000000000000011010"),	 -- 26	26
	 ("00000000000000000000000000011001"),	 -- 25	25
	 ("00000000000000000000000000010100"),	 -- 24	20
	 ("00000000000000000000000000010111"),	 -- 23	23
	 ("00000000000000000000000001010010"),	 -- 22	82
	 ("00000000000000000000000000010111"),	 -- 21	23
	 ("00000000000000000000000000010100"),	 -- 20	20
	 ("00000000000000000000000000100111"),	 -- 19	39
	 ("00000000000000000000000000010010"),	 -- 18	18
	 ("00000000000000000000000000010001"),	 -- 17	17
	 ("00000000000000000000000000010000"),	 -- 16	16
	 ("00000000000000000000000000001111"),	 -- 15	15
	 ("00000000000000000000000000001110"),	 -- 14	14
	 ("00000000000000000000000000001101"),	 -- 13	13
	 ("00000000000000000000000001001000"),	 -- 12	72
	 ("00000000000000000000000000001110"),	 -- 11	14
	 ("00000000000000000000000000001110"),	 -- 10	14
	 ("00000000000000000000000000011101"),	 -- 9	29
	 ("00000000000000000000000000010010"),	 -- 8	18
	 ("00000000000000000000000001000011"),	 -- 7	67
	 ("00000000000000000000000001100000"),	 -- 6	96
	 ("00000000000000000000000000101101"),	 -- 5	45
	 ("00000000000000000000000000100010"),	 -- 4	34
	 ("00000000000000000000000001010011"),	 -- 3	83
	 ("00000000000000000000000000111110"),	 -- 2	62
	 ("00000000000000000000000001000001"),	 -- 1	65
	 ("00000000000000000000000000110010"));	 -- 0	50


begin 
       process (clk) 
       begin 
              if (clk'event and clk = '1') then 
                  if (we_0 = '1') then 
                        RAM(conv_integer(address_0)) <= data_in_0; 
                        data_out_0 <= RAM(conv_integer(read_0)); 
                  elsif (oe_0 = '1') then 
                        data_out_0 <= RAM(conv_integer(read_0)); 
                  end if; 
                  read_0 <= address_0; 
                  if (we_1 = '1') then 
                        RAM(conv_integer(address_1)) <= data_in_1; 
                        data_out_1 <= RAM(conv_integer(read_1)); 
                  elsif (oe_1 = '1') then 
                        data_out_1 <= RAM(conv_integer(read_1)); 
                  end if; 
                  read_1 <= address_1; 
                  if (we_2 = '1') then 
                        RAM(conv_integer(address_2)) <= data_in_2; 
                        data_out_2 <= RAM(conv_integer(read_2)); 
                  elsif (oe_2 = '1') then 
                        data_out_2 <= RAM(conv_integer(read_2)); 
                  end if; 
                  read_2 <= address_2; 
                  if (we_3 = '1') then 
                        RAM(conv_integer(address_3)) <= data_in_3; 
                        data_out_3 <= RAM(conv_integer(read_3)); 
                  elsif (oe_3 = '1') then 
                        data_out_3 <= RAM(conv_integer(read_3)); 
                  end if; 
                  read_3 <= address_3; 
                  if (we_4 = '1') then 
                        RAM(conv_integer(address_4)) <= data_in_4; 
                        data_out_4 <= RAM(conv_integer(read_4)); 
                  elsif (oe_4 = '1') then 
                        data_out_4 <= RAM(conv_integer(read_4)); 
                  end if; 
                  read_4 <= address_4; 
                  if (we_5 = '1') then 
                        RAM(conv_integer(address_5)) <= data_in_5; 
                        data_out_5 <= RAM(conv_integer(read_5)); 
                  elsif (oe_5 = '1') then 
                        data_out_5 <= RAM(conv_integer(read_5)); 
                  end if; 
                  read_5 <= address_5; 
                  if (we_6 = '1') then 
                        RAM(conv_integer(address_6)) <= data_in_6; 
                        data_out_6 <= RAM(conv_integer(read_6)); 
                  elsif (oe_6 = '1') then 
                        data_out_6 <= RAM(conv_integer(read_6)); 
                  end if; 
                  read_6 <= address_6; 
                  if (we_7 = '1') then 
                        RAM(conv_integer(address_7)) <= data_in_7; 
                        data_out_7 <= RAM(conv_integer(read_7)); 
                  elsif (oe_7 = '1') then 
                        data_out_7 <= RAM(conv_integer(read_7)); 
                  end if; 
                  read_7 <= address_7; 
                  if (we_8 = '1') then 
                        RAM(conv_integer(address_8)) <= data_in_8; 
                        data_out_8 <= RAM(conv_integer(read_8)); 
                  elsif (oe_8 = '1') then 
                        data_out_8 <= RAM(conv_integer(read_8)); 
                  end if; 
                  read_8 <= address_8; 
                  if (we_9 = '1') then 
                        RAM(conv_integer(address_9)) <= data_in_9; 
                        data_out_9 <= RAM(conv_integer(read_9)); 
                  elsif (oe_9 = '1') then 
                        data_out_9 <= RAM(conv_integer(read_9)); 
                  end if; 
                  read_9 <= address_9; 
                  if (we_10 = '1') then 
                        RAM(conv_integer(address_10)) <= data_in_10; 
                        data_out_10 <= RAM(conv_integer(read_10)); 
                  elsif (oe_10 = '1') then 
                        data_out_10 <= RAM(conv_integer(read_10)); 
                  end if; 
                  read_10 <= address_10; 
                  if (we_11 = '1') then 
                        RAM(conv_integer(address_11)) <= data_in_11; 
                        data_out_11 <= RAM(conv_integer(read_11)); 
                  elsif (oe_11 = '1') then 
                        data_out_11 <= RAM(conv_integer(read_11)); 
                  end if; 
                  read_11 <= address_11; 
                  if (we_12 = '1') then 
                        RAM(conv_integer(address_12)) <= data_in_12; 
                        data_out_12 <= RAM(conv_integer(read_12)); 
                  elsif (oe_12 = '1') then 
                        data_out_12 <= RAM(conv_integer(read_12)); 
                  end if; 
                  read_12 <= address_12; 
                  if (we_13 = '1') then 
                        RAM(conv_integer(address_13)) <= data_in_13; 
                        data_out_13 <= RAM(conv_integer(read_13)); 
                  elsif (oe_13 = '1') then 
                        data_out_13 <= RAM(conv_integer(read_13)); 
                  end if; 
                  read_13 <= address_13; 
                  if (we_14 = '1') then 
                        RAM(conv_integer(address_14)) <= data_in_14; 
                        data_out_14 <= RAM(conv_integer(read_14)); 
                  elsif (oe_14 = '1') then 
                        data_out_14 <= RAM(conv_integer(read_14)); 
                  end if; 
                  read_14 <= address_14; 
                  if (we_15 = '1') then 
                        RAM(conv_integer(address_15)) <= data_in_15; 
                        data_out_15 <= RAM(conv_integer(read_15)); 
                  elsif (oe_15 = '1') then 
                        data_out_15 <= RAM(conv_integer(read_15)); 
                  end if; 
                  read_15 <= address_15; 
             end if; 
       end process; 
end rtl; 

library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_mult_out is 
generic( 
	data_width : integer := 8; 
	address_width : integer := 8 
); 
port( 
	data_in_0 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_0 : in std_logic_vector(address_width-1 downto 0); 
	we_0 : in std_logic := '0'; 
	oe_0 : in std_logic := '1'; 
	data_out_0 : out std_logic_vector(data_width-1 downto 0); 
	data_in_1 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
	address_1 : in std_logic_vector(address_width-1 downto 0); 
	we_1 : in std_logic := '0'; 
	oe_1 : in std_logic := '1'; 
	data_out_1 : out std_logic_vector(data_width-1 downto 0); 
	clk : in std_logic); 
end block_ram_mult_out; 

architecture rtl of block_ram_mult_out is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_0 : std_logic_vector(address_width-1 downto 0); 
signal read_1 : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type; 

begin 
       process (clk) 
       begin 
              if (clk'event and clk = '1') then 
                  if (we_0 = '1') then 
                        RAM(conv_integer(address_0)) <= data_in_0; 
                        data_out_0 <= RAM(conv_integer(read_0)); 
                  elsif (oe_0 = '1') then 
                        data_out_0 <= RAM(conv_integer(read_0)); 
                  end if; 
                  read_0 <= address_0; 
                  if (we_1 = '1') then 
                        RAM(conv_integer(address_1)) <= data_in_1; 
                        data_out_1 <= RAM(conv_integer(read_1)); 
                  elsif (oe_1 = '1') then 
                        data_out_1 <= RAM(conv_integer(read_1)); 
                  end if; 
                  read_1 <= address_1; 
             end if; 
       end process; 
end rtl; 

