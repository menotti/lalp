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
signal RAM : ram_type := ram_type'( 
	 ("10001000"),	 -- 127	0
	 ("01010000"),	 -- 126	0
	 ("00010000"),	 -- 125	0
	 ("10100000"),	 -- 124	0
	 ("10010000"),	 -- 123	0
	 ("10001000"),	 -- 122	0
	 ("10000100"),	 -- 121	0
	 ("11000010"),	 -- 120	0
	 ("11000000"),	 -- 119	0
	 ("10000000"),	 -- 118	0
	 ("11100000"),	 -- 117	0
	 ("10010000"),	 -- 116	0
	 ("10001000"),	 -- 115	0
	 ("10001000"),	 -- 114	0
	 ("10000000"),	 -- 113	0
	 ("10000100"),	 -- 112	0
	 ("10000000"),	 -- 111	0
	 ("10100000"),	 -- 110	0
	 ("10010000"),	 -- 109	0
	 ("10001000"),	 -- 108	0
	 ("10000100"),	 -- 107	0
	 ("10000010"),	 -- 106	0
	 ("11000000"),	 -- 105	0
	 ("10100000"),	 -- 104	0
	 ("10010000"),	 -- 103	0
	 ("10001000"),	 -- 102	0
	 ("00000100"),	 -- 101	0
	 ("00000000"),	 -- 100	0
	 ("11100011"),	 -- 99	99
	 ("10100110"),	 -- 98	38
	 ("11100001"),	 -- 97	97
	 ("01100000"),	 -- 96	96
	 ("11011111"),	 -- 95	95
	 ("11011110"),	 -- 94	94
	 ("01011101"),	 -- 93	93
	 ("10011100"),	 -- 92	92
	 ("01100000"),	 -- 91	96
	 ("11011111"),	 -- 90	95
	 ("11011001"),	 -- 89	89
	 ("10011100"),	 -- 88	28
	 ("11010111"),	 -- 87	87
	 ("11010110"),	 -- 86	86
	 ("11010101"),	 -- 85	85
	 ("11010100"),	 -- 84	84
	 ("11010011"),	 -- 83	83
	 ("11010010"),	 -- 82	82
	 ("01010111"),	 -- 81	87
	 ("11010100"),	 -- 80	84
	 ("10011101"),	 -- 79	29
	 ("10010010"),	 -- 78	18
	 ("00100101"),	 -- 77	37
	 ("11100000"),	 -- 76	96
	 ("10110111"),	 -- 75	55
	 ("11100010"),	 -- 74	34
	 ("01010011"),	 -- 73	83
	 ("11001000"),	 -- 72	72
	 ("11000100"),	 -- 71	68
	 ("10110101"),	 -- 70	53
	 ("11000101"),	 -- 69	69
	 ("11000100"),	 -- 68	68
	 ("11000011"),	 -- 67	67
	 ("11000000"),	 -- 66	64
	 ("01000001"),	 -- 65	65
	 ("11000000"),	 -- 64	64
	 ("01000010"),	 -- 63	66
	 ("00111110"),	 -- 62	62
	 ("01000101"),	 -- 61	69
	 ("00111100"),	 -- 60	60
	 ("00011101"),	 -- 59	29
	 ("00010010"),	 -- 58	18
	 ("00100101"),	 -- 57	37
	 ("01100000"),	 -- 56	96
	 ("00101101"),	 -- 55	45
	 ("00100010"),	 -- 54	34
	 ("01010011"),	 -- 53	83
	 ("01010010"),	 -- 52	82
	 ("00111100"),	 -- 51	60
	 ("00110100"),	 -- 50	52
	 ("01011001"),	 -- 49	89
	 ("00110000"),	 -- 48	48
	 ("00101111"),	 -- 47	47
	 ("00101110"),	 -- 46	46
	 ("00101101"),	 -- 45	45
	 ("00101100"),	 -- 44	44
	 ("01001001"),	 -- 43	73
	 ("00101010"),	 -- 42	42
	 ("00101001"),	 -- 41	41
	 ("00101000"),	 -- 40	40
	 ("00011101"),	 -- 39	29
	 ("00010010"),	 -- 38	18
	 ("01100001"),	 -- 37	97
	 ("01100000"),	 -- 36	96
	 ("00101101"),	 -- 35	45
	 ("00100010"),	 -- 34	34
	 ("01010011"),	 -- 33	83
	 ("01001000"),	 -- 32	72
	 ("00001100"),	 -- 31	12
	 ("00110110"),	 -- 30	54
	 ("00011101"),	 -- 29	29
	 ("00011100"),	 -- 28	28
	 ("00011011"),	 -- 27	27
	 ("00011010"),	 -- 26	26
	 ("00011001"),	 -- 25	25
	 ("00010100"),	 -- 24	20
	 ("00010111"),	 -- 23	23
	 ("01010010"),	 -- 22	82
	 ("00010111"),	 -- 21	23
	 ("00010100"),	 -- 20	20
	 ("00100111"),	 -- 19	39
	 ("00010010"),	 -- 18	18
	 ("00010001"),	 -- 17	17
	 ("00010000"),	 -- 16	16
	 ("00001111"),	 -- 15	15
	 ("00001110"),	 -- 14	14
	 ("00001101"),	 -- 13	13
	 ("01001000"),	 -- 12	72
	 ("00001110"),	 -- 11	14
	 ("00001110"),	 -- 10	14
	 ("00011101"),	 -- 9	29
	 ("00010010"),	 -- 8	18
	 ("01000011"),	 -- 7	67
	 ("01100000"),	 -- 6	96
	 ("00101101"),	 -- 5	45
	 ("00100010"),	 -- 4	34
	 ("01010011"),	 -- 3	83
	 ("00111110"),	 -- 2	62
	 ("01000001"),	 -- 1	65
	 ("00110010"));	 -- 0	50


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
             end if; 
       end process; 
end rtl; 

