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
	 ("10111100000000000000"),	 -- 127	0
	 ("01111011000000000000"),	 -- 126	0
	 ("10111000000000000000"),	 -- 125	0
	 ("11011000100000100000"),	 -- 124	0
	 ("11111000010001000000"),	 -- 123	0
	 ("11101000001110000000"),	 -- 122	0
	 ("11011000000110000000"),	 -- 121	0
	 ("10111000000001000000"),	 -- 120	0
	 ("10111000011000000000"),	 -- 119	0
	 ("11011010000000000000"),	 -- 118	0
	 ("11101001000000000000"),	 -- 117	0
	 ("11110000100000100000"),	 -- 116	0
	 ("10111000000001000000"),	 -- 115	0
	 ("11011000010110000000"),	 -- 114	0
	 ("11101000001000000000"),	 -- 113	0
	 ("10001111111100000000"),	 -- 112	0
	 ("01111001000010000000"),	 -- 111	0
	 ("10111100100000000000"),	 -- 110	0
	 ("11011010010000000000"),	 -- 109	0
	 ("11101001001000000000"),	 -- 108	0
	 ("11110000100100000000"),	 -- 107	0
	 ("10111000010000000000"),	 -- 106	0
	 ("11011000001000000000"),	 -- 105	0
	 ("11101000000000000000"),	 -- 104	0
	 ("10111000000110000000"),	 -- 103	0
	 ("11011000000011000000"),	 -- 102	0
	 ("11101010000000000000"),	 -- 101	0
	 ("11110001000000000000"),	 -- 100	0
	 ("10111000100001100011"),	 -- 99	99
	 ("11011000010000100110"),	 -- 98	38
	 ("11101000001001100001"),	 -- 97	97
	 ("10111000000001100000"),	 -- 96	96
	 ("11011010000001011111"),	 -- 95	95
	 ("11101001000001011110"),	 -- 94	94
	 ("11110000100001011101"),	 -- 93	93
	 ("11011000010001011100"),	 -- 92	92
	 ("11101000001001100000"),	 -- 91	96
	 ("11110000000111011111"),	 -- 90	95
	 ("11110000000001011001"),	 -- 89	89
	 ("11111010000000011100"),	 -- 88	28
	 ("11100011100001010111"),	 -- 87	87
	 ("11111001000001010110"),	 -- 86	86
	 ("11111000100001010101"),	 -- 85	85
	 ("11111000010001010100"),	 -- 84	84
	 ("11111000000001010011"),	 -- 83	83
	 ("11111000001001010010"),	 -- 82	82
	 ("11111000000101010111"),	 -- 81	87
	 ("11111000000011010100"),	 -- 80	84
	 ("11111000000000011101"),	 -- 79	29
	 ("11111100000000010010"),	 -- 78	18
	 ("11111010000000100101"),	 -- 77	37
	 ("11111001000001100000"),	 -- 76	96
	 ("11111000100000110111"),	 -- 75	55
	 ("11111000010000100010"),	 -- 74	34
	 ("11111000001001010011"),	 -- 73	83
	 ("11111000000101001000"),	 -- 72	72
	 ("11111010000001000100"),	 -- 71	68
	 ("11111001000000110101"),	 -- 70	53
	 ("11111000000001000101"),	 -- 69	69
	 ("11111000100001000100"),	 -- 68	68
	 ("11111000010001000011"),	 -- 67	67
	 ("11111000001001000000"),	 -- 66	64
	 ("11111000000101000001"),	 -- 65	65
	 ("11111000000011000000"),	 -- 64	64
	 ("11111000000001000010"),	 -- 63	66
	 ("11111000000000111110"),	 -- 62	62
	 ("11111000000001000101"),	 -- 61	69
	 ("11111000000000111100"),	 -- 60	60
	 ("11111000000000011101"),	 -- 59	29
	 ("11111100000000010010"),	 -- 58	18
	 ("11111010000000100101"),	 -- 57	37
	 ("11111001000001100000"),	 -- 56	96
	 ("11111000100000101101"),	 -- 55	45
	 ("11111000010000100010"),	 -- 54	34
	 ("11111000001001010011"),	 -- 53	83
	 ("11111000000111010010"),	 -- 52	82
	 ("11111000000001111100"),	 -- 51	60
	 ("11111000000000110100"),	 -- 50	52
	 ("11111000000001011001"),	 -- 49	89
	 ("11111000000000110000"),	 -- 48	48
	 ("11111100000000101111"),	 -- 47	47
	 ("11111010000000101110"),	 -- 46	46
	 ("11111001000000101101"),	 -- 45	45
	 ("11111000100000101100"),	 -- 44	44
	 ("11111000010001001001"),	 -- 43	73
	 ("11111000001000101010"),	 -- 42	42
	 ("11111000000100101001"),	 -- 41	41
	 ("11111000000010101000"),	 -- 40	40
	 ("11111000000001011101"),	 -- 39	29
	 ("11111000000000110010"),	 -- 38	18
	 ("11111000000001110001"),	 -- 37	97
	 ("11111000000001100000"),	 -- 36	96
	 ("11111000000000101101"),	 -- 35	45
	 ("11111000000000100010"),	 -- 34	34
	 ("11111000000001010011"),	 -- 33	83
	 ("11111000000001001000"),	 -- 32	72
	 ("11111000000000001100"),	 -- 31	12
	 ("11111000000000110110"),	 -- 30	54
	 ("11111000000000011101"),	 -- 29	29
	 ("11111000000000011100"),	 -- 28	28
	 ("11111000000000011011"),	 -- 27	27
	 ("11111000000000011010"),	 -- 26	26
	 ("11111000000000011001"),	 -- 25	25
	 ("11111000000000010100"),	 -- 24	20
	 ("11111000000000010111"),	 -- 23	23
	 ("11111000000001010010"),	 -- 22	82
	 ("11111000000000010111"),	 -- 21	23
	 ("11111000000000010100"),	 -- 20	20
	 ("11111000000000100111"),	 -- 19	39
	 ("11111000000000010010"),	 -- 18	18
	 ("11111000000000010001"),	 -- 17	17
	 ("11111000000000010000"),	 -- 16	16
	 ("11111000000000001111"),	 -- 15	15
	 ("11111000000000001110"),	 -- 14	14
	 ("11111000000000001101"),	 -- 13	13
	 ("11111000000001001000"),	 -- 12	72
	 ("11111000000000001110"),	 -- 11	14
	 ("11111000000001000001"),	 -- 1	65
	 ("11111000000000001110"),	 -- 10	14
	 ("11111000000000011101"),	 -- 9	29
	 ("11111000000000010010"),	 -- 8	18
	 ("11111000000001000011"),	 -- 7	67
	 ("11111000000001100000"),	 -- 6	96
	 ("11111000000000101101"),	 -- 5	45
	 ("11111000000000100010"),	 -- 4	34
	 ("11111000000001010011"),	 -- 3	83
	 ("11111000000000111110"),	 -- 2	62
	 ("11111000000000110010"));	 -- 0	50


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

