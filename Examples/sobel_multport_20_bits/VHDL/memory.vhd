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
	 ("00000000000000000000"),	 -- 127	0
	 ("00000000000000000000"),	 -- 126	0
	 ("00000000000000000000"),	 -- 125	0
	 ("00000000000000000000"),	 -- 124	0
	 ("00000000000000000000"),	 -- 123	0
	 ("00000000000000000000"),	 -- 122	0
	 ("00000000000000000000"),	 -- 121	0
	 ("00000000000000000000"),	 -- 120	0
	 ("00000000000000000000"),	 -- 119	0
	 ("00000000000000000000"),	 -- 118	0
	 ("00000000000000000000"),	 -- 117	0
	 ("00000000000000000000"),	 -- 116	0
	 ("00000000000000000000"),	 -- 115	0
	 ("00000000000000000000"),	 -- 114	0
	 ("00000000000000000000"),	 -- 113	0
	 ("00000000000000000000"),	 -- 112	0
	 ("00000000000000000000"),	 -- 111	0
	 ("00000000000000000000"),	 -- 110	0
	 ("00000000000000000000"),	 -- 109	0
	 ("00000000000000000000"),	 -- 108	0
	 ("00000000000000000000"),	 -- 107	0
	 ("00000000000000000000"),	 -- 106	0
	 ("00000000000000000000"),	 -- 105	0
	 ("00000000000000000000"),	 -- 104	0
	 ("00000000000000000000"),	 -- 103	0
	 ("00000000000000000000"),	 -- 102	0
	 ("00000000000000000000"),	 -- 101	0
	 ("00000000000000000000"),	 -- 100	0
	 ("10111010100001100011"),	 -- 99	99
	 ("11011001010000100110"),	 -- 98	38
	 ("10101000101001100001"),	 -- 97	97
	 ("00111000010001100000"),	 -- 96	96
	 ("11011010010001011111"),	 -- 95	95
	 ("11100001000001011110"),	 -- 94	94
	 ("11110000100001011101"),	 -- 93	93
	 ("11001010010001011100"),	 -- 92	92
	 ("11001000001001100000"),	 -- 91	96
	 ("10110001000111011111"),	 -- 90	95
	 ("01110000100001011001"),	 -- 89	89
	 ("11111010010000011100"),	 -- 88	28
	 ("11100011101001010111"),	 -- 87	87
	 ("11101001000001010110"),	 -- 86	86
	 ("11011000100001010101"),	 -- 85	85
	 ("10111000010001010100"),	 -- 84	84
	 ("01111000000001010011"),	 -- 83	83
	 ("11110000001001010010"),	 -- 82	82
	 ("11101010000101010111"),	 -- 81	87
	 ("11011001000011010100"),	 -- 80	84
	 ("10111000000000011101"),	 -- 79	29
	 ("11111100100000010010"),	 -- 78	18
	 ("01111010010000100101"),	 -- 77	37
	 ("11110001001001100000"),	 -- 76	96
	 ("11101000100100110111"),	 -- 75	55
	 ("11011000010000100010"),	 -- 74	34
	 ("10111000001001010011"),	 -- 73	83
	 ("01111010000101001000"),	 -- 72	72
	 ("11110010001001000100"),	 -- 71	68
	 ("11101001000000110101"),	 -- 70	53
	 ("11011001110001000101"),	 -- 69	69
	 ("10111000110001000100"),	 -- 68	68
	 ("01111000110001000011"),	 -- 67	67
	 ("11110000001001000000"),	 -- 66	64
	 ("11101000000101000001"),	 -- 65	65
	 ("11011001011011000000"),	 -- 64	64
	 ("10111000000001000010"),	 -- 63	66
	 ("01111000000000111110"),	 -- 62	62
	 ("11110010001101000101"),	 -- 61	69
	 ("11101010000000111100"),	 -- 60	60
	 ("11011001000000011101"),	 -- 59	29
	 ("10111100111000010010"),	 -- 58	18
	 ("01111010000000100101"),	 -- 57	37
	 ("11110001000001100000"),	 -- 56	96
	 ("11101000100000101101"),	 -- 55	45
	 ("11011000010000100010"),	 -- 54	34
	 ("10111000001001010011"),	 -- 53	83
	 ("01111100000111010010"),	 -- 52	82
	 ("11101010000001111100"),	 -- 51	60
	 ("11011001000000110100"),	 -- 50	52
	 ("10111001000001011001"),	 -- 49	89
	 ("01110000001000110000"),	 -- 48	48
	 ("11101110000100101111"),	 -- 47	47
	 ("11011011000000101110"),	 -- 46	46
	 ("10111001100010101101"),	 -- 45	45
	 ("01111000110000101100"),	 -- 44	44
	 ("11100000010001001001"),	 -- 43	73
	 ("11011000001000101010"),	 -- 42	42
	 ("10111100000100101001"),	 -- 41	41
	 ("01111010000010101000"),	 -- 40	40
	 ("11111001000001011101"),	 -- 39	29
	 ("11110000100000110010"),	 -- 38	18
	 ("11101000000001110001"),	 -- 37	97
	 ("11011000010001100000"),	 -- 36	96
	 ("10111000001000101101"),	 -- 35	45
	 ("01110000000000100010"),	 -- 34	34
	 ("11101010000001010011"),	 -- 33	83
	 ("11011000000001001000"),	 -- 32	72
	 ("10111100000000001100"),	 -- 31	12
	 ("01111100000000110110"),	 -- 30	54
	 ("11111010000000011101"),	 -- 29	29
	 ("11110010000000011100"),	 -- 28	28
	 ("11101001000000011011"),	 -- 27	27
	 ("11011000100000011010"),	 -- 26	26
	 ("10111000010000011001"),	 -- 25	25
	 ("01111000001000010100"),	 -- 24	20
	 ("11110000000100010111"),	 -- 23	23
	 ("11101000000011010010"),	 -- 22	82
	 ("11011001000000010111"),	 -- 21	23
	 ("10111000000000010100"),	 -- 20	20
	 ("01111000100000100111"),	 -- 19	39
	 ("11110000010000010010"),	 -- 18	18
	 ("11101000001000010001"),	 -- 17	17
	 ("11011000000100010000"),	 -- 16	16
	 ("10111000000010001111"),	 -- 15	15
	 ("01111001000000001110"),	 -- 14	14
	 ("11110000000000001101"),	 -- 13	13
	 ("11101000100001001000"),	 -- 12	72
	 ("11011000010000001110"),	 -- 11	14
	 ("10111000001001000001"),	 -- 1	65
	 ("01111000000100001110"),	 -- 10	14
	 ("11111010100010011101"),	 -- 9	29
	 ("11101001000000010010"),	 -- 8	18
	 ("01111000110001000011"),	 -- 7	67
	 ("11111000010001100000"),	 -- 6	96
	 ("11111000100000101101"),	 -- 5	45
	 ("11011000100000100010"),	 -- 4	34
	 ("11011001010001010011"),	 -- 3	83
	 ("10111011000000111110"),	 -- 2	62
	 ("10111000001000110010"));	 -- 0	50


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

