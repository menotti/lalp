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
	 ("00000000000000000000000000000000"),	 -- 99	99
	 ("10000000000000000000000000100110"),	 -- 98	38
	 ("01000000000000000000000001100001"),	 -- 97	97
	 ("00100000000000000000000001100000"),	 -- 96	96
	 ("00010000000000000000000001011111"),	 -- 95	95
	 ("00001000000000000000000001011110"),	 -- 94	94
	 ("00000100000000000000000001011101"),	 -- 93	93
	 ("00000010000000000000000001011100"),	 -- 92	92
	 ("00000001000000000000000001100000"),	 -- 91	96
	 ("00000000100000000000000001011111"),	 -- 90	95
	 ("00000000010000000000000001011001"),	 -- 89	89
	 ("00000000001000000000000000011100"),	 -- 88	28
	 ("00000000000100000000000001010111"),	 -- 87	87
	 ("00000000000010000000000001010110"),	 -- 86	86
	 ("00000000000001000000000001010101"),	 -- 85	85
	 ("00000000000000100000000001010100"),	 -- 84	84
	 ("00000000000000010000000001010011"),	 -- 83	83
	 ("00000000000000001000000001010010"),	 -- 82	82
	 ("00000000000000000100000001010111"),	 -- 81	87
	 ("00000000000000000010000001010100"),	 -- 80	84
	 ("00000000000000000001000000011101"),	 -- 79	29
	 ("00000000000000000000100000010010"),	 -- 78	18
	 ("00000000000000000000010000100101"),	 -- 77	37
	 ("00000000000000000000001001100000"),	 -- 76	96
	 ("00000000000000000000000100110111"),	 -- 75	55
	 ("00000000000000000010000000100010"),	 -- 74	34
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
	 ("10000000000000100000000001100011"),	 -- 63	99
	 ("01000000000001000000000000100110"),	 -- 62	38
	 ("00100000000010000000000001011111"),	 -- 61	95
	 ("00010000000100000000000001011110"),	 -- 60	94
	 ("00001000001000000000000001011101"),	 -- 59	93
	 ("00000100010000000000000001011100"),	 -- 58	92
	 ("00000010100000000000000001100000"),	 -- 57	96
	 ("00000001000000000000000001011111"),	 -- 56	95
	 ("00000010100000000000000001011001"),	 -- 55	89
	 ("00000100010000000000000000011100"),	 -- 54	28
	 ("00001000001000000000000001010101"),	 -- 53	85
	 ("00010000000100000000000001010100"),	 -- 52	84
	 ("00100000000010000000000001010011"),	 -- 51	83
	 ("01000000000001000000000001010010"),	 -- 50	82
	 ("10000000000000100000000011010111"),	 -- 49	87
	 ("00000000000000010000000101010100"),	 -- 48	84
	 ("00000000000000001000001001000101"),	 -- 47	69
	 ("00000000000000000100010001000100"),	 -- 46	68
	 ("00000000000000000010100001000001"),	 -- 45	65
	 ("00000000000000000001000001000000"),	 -- 44	64
	 ("00000000000000000010100001000010"),	 -- 43	66
	 ("00000000000000000100010000111110"),	 -- 42	62
	 ("00000000000000001000001001000101"),	 -- 41	69
	 ("00000000000000010000000100111100"),	 -- 40	60
	 ("00000000000000100000000011011001"),	 -- 39	89
	 ("10000000000001000000000000110000"),	 -- 38	48
	 ("01000000000010000000000000101101"),	 -- 37	45
	 ("00100000000100000000000000101100"),	 -- 36	44
	 ("00010000001000000000000001001001"),	 -- 35	73
	 ("00001000010000000000000000101010"),	 -- 34	42
	 ("00000100100000000000000000101001"),	 -- 33	41
	 ("00000011000000000000000000101000"),	 -- 32	40
	 ("00000011000000000000000000011101"),	 -- 31	29
	 ("00000100100000000000000000010010"),	 -- 30	18
	 ("00001000010000000000000000101101"),	 -- 29	45
	 ("00010000001000000000000000100010"),	 -- 28	34
	 ("00100000000100000000000011010011"),	 -- 27	83
	 ("01000000000010000000000011001000"),	 -- 26	72
	 ("10000000000001000000000001001100"),	 -- 25	12
	 ("00000000000000100000000011110110"),	 -- 24	54
	 ("00000000000000010000000100011101"),	 -- 23	29
	 ("00000000000000001000001000011100"),	 -- 22	28
	 ("00000000000000000100010000011001"),	 -- 21	25
	 ("00000000000000000010100000010100"),	 -- 20	20
	 ("00000000000000000001000000010111"),	 -- 19	23
	 ("00000000000000000010100001010010"),	 -- 18	82
	 ("00000000000000000100010000010111"),	 -- 17	23
	 ("00000000000000001000001000010100"),	 -- 16	20
	 ("00000000000000010000000100100111"),	 -- 15	39
	 ("00000000000000100000000010010010"),	 -- 14	18
	 ("00000000000001000000000001001111"),	 -- 13	15
	 ("00000000000010000000000000101110"),	 -- 12	14
	 ("00000000000100000000000000011101"),	 -- 11	13
	 ("00000000001000000000000001001000"),	 -- 10	72
	 ("10000000010000000000000000001110"),	 -- 9	14
	 ("01000000100000000000000000001110"),	 -- 8	14
	 ("00100001000000000000000000011101"),	 -- 7	29
	 ("00010010000000000000000000010010"),	 -- 6	18
	 ("00001100000000000000000000101101"),	 -- 5	45
	 ("00001100000000000000000000100010"),	 -- 4	34
	 ("00010010000000000000000001010011"),	 -- 3	83
	 ("00100001000000000000000000111110"),	 -- 2	62
	 ("01000000100000000000000001000001"),	 -- 1	65
	 ("10000000010000000000000000110010"));	 -- 0	50


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

