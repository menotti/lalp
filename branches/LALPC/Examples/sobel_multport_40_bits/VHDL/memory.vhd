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
	 ("0000000000000000000000000000000000000000"),	 -- 127	0
	 ("0000000000000000000000000000000000000000"),	 -- 126	0
	 ("0000000000000000000000000000000000000000"),	 -- 125	0
	 ("0000000000000000000000000000000000000000"),	 -- 124	0
	 ("0000000000000000000000000000000000000000"),	 -- 123	0
	 ("0000000000000000000000000000000000000000"),	 -- 122	0
	 ("0000000000000000000000000000000000000000"),	 -- 121	0
	 ("0000000000000000000000000000000000000000"),	 -- 120	0
	 ("0000000000000000000000000000000000000000"),	 -- 119	0
	 ("0000000000000000000000000000000000000000"),	 -- 118	0
	 ("0000000000000000000000000000000000000000"),	 -- 117	0
	 ("0000000000000000000000000000000000000000"),	 -- 116	0
	 ("0000000000000000000000000000000000000000"),	 -- 115	0
	 ("0000000000000000000000000000000000000000"),	 -- 114	0
	 ("0000000000000000000000000000000000000000"),	 -- 113	0
	 ("0000000000000000000000000000000000000000"),	 -- 112	0
	 ("0000000000000000000000000000000000000000"),	 -- 111	0
	 ("0000000000000000000000000000000000000000"),	 -- 110	0
	 ("0000000000000000000000000000000000000000"),	 -- 109	0
	 ("0000000000000000000000000000000000000000"),	 -- 108	0
	 ("0000000000000000000000000000000000000000"),	 -- 107	0
	 ("0000000000000000000000000000000000000000"),	 -- 106	0
	 ("0000000000000000000000000000000000000000"),	 -- 105	0
	 ("0000000000000000000000000000000000000000"),	 -- 104	0
	 ("0000000000000000000000000000000000000000"),	 -- 103	0
	 ("0000000000000000000000000000000000000000"),	 -- 102	0
	 ("0000000000000000000000000000000000000000"),	 -- 101	0
	 ("0000000000000000000000000000000000000000"),	 -- 100	0
	 ("1111110010000000000100000000000001100011"),	 -- 99	99
	 ("1111101111000000000010000000000000100110"),	 -- 98	38
	 ("1111011110100000000000000000000001100001"),	 -- 97	97
	 ("1110111110010000000001000000000001100000"),	 -- 96	96
	 ("1101111110001000000000100000000001011111"),	 -- 95	95
	 ("1011111110000000000000010000000001011110"),	 -- 94	94
	 ("0111111110000100000000001000000001011101"),	 -- 93	93
	 ("1111111010000010000000000100000001011100"),	 -- 92	92
	 ("1111110110000001000000000010000001100000"),	 -- 91	96
	 ("1111101110000000100000000000000001011111"),	 -- 90	95
	 ("1111011110000000010000000001000001011001"),	 -- 89	89
	 ("1110111110000000001000000000100000011100"),	 -- 88	28
	 ("1101111110000000000100000000000001010111"),	 -- 87	87
	 ("1011111110000000000010000000000001010110"),	 -- 86	86
	 ("0111111010000000000001000000000001010101"),	 -- 85	85
	 ("1111110110000000000000100000000001010100"),	 -- 84	84
	 ("1111101111000000000000010000000001010011"),	 -- 83	83
	 ("1111011110100000000000001000000001010010"),	 -- 82	82
	 ("1110111110010000000000000100000001010111"),	 -- 81	87
	 ("1101111110001000000000000010000001010100"),	 -- 80	84
	 ("1011111110000100000000000001000000011101"),	 -- 79	29
	 ("0111111110000010000000000000100000010010"),	 -- 78	18
	 ("1111111010000001000000000000010000100101"),	 -- 77	37
	 ("1111110110000000100000000000001001100000"),	 -- 76	96
	 ("1111101110000000010000000000000100110111"),	 -- 75	55
	 ("1111011110000000001000000000000000100010"),	 -- 74	34
	 ("1110111110000000000100000000000001010011"),	 -- 73	83
	 ("1101111110000000000010000000000001001000"),	 -- 72	72
	 ("1011111110000000000001000000000001000100"),	 -- 71	68
	 ("0111111111000000000000100000000000110101"),	 -- 70	53
	 ("1111101110100000000000010000000001000101"),	 -- 69	69
	 ("1111011110010000000000001000000001000100"),	 -- 68	68
	 ("1110111110001000000000000100000001000011"),	 -- 67	67
	 ("1101111110000100000000000010000001000000"),	 -- 66	64
	 ("1011111100010010000000000001000001000001"),	 -- 65	65
	 ("0111111100100001000000000000100001000000"),	 -- 64	64
	 ("1111111010000000000000000000010001000010"),	 -- 63	66
	 ("1111110110000000100000000000001000111110"),	 -- 62	62
	 ("1111101110000000010000000000000001000101"),	 -- 61	69
	 ("1111011110000000001000000000000100111100"),	 -- 60	60
	 ("1110111110000000000100000000000010011101"),	 -- 59	29
	 ("1101111110000000000010000000000001010010"),	 -- 58	18
	 ("1011111110000000000001000000000000100101"),	 -- 57	37
	 ("0111111110000000000000100000000001100000"),	 -- 56	96
	 ("1011111110000000000000010000000000101101"),	 -- 55	45
	 ("1101111110000000000000001000000000100010"),	 -- 54	34
	 ("1110111110000000000000000100000001010011"),	 -- 53	83
	 ("1111011110000000000000000000000001010010"),	 -- 52	82
	 ("1111101110000000000000000010000000111100"),	 -- 51	60
	 ("1111110110000000000000000001000000110100"),	 -- 50	52
	 ("1111111010000000000000000000100001011001"),	 -- 49	89
	 ("1111110011000000000000000000010000110000"),	 -- 48	48
	 ("1111101110100000000000000000001000101111"),	 -- 47	47
	 ("1111011110010000000000000000000100101110"),	 -- 46	46
	 ("1110111110001000000000000000000010101101"),	 -- 45	45
	 ("1101111110000100000000000000000000101100"),	 -- 44	44
	 ("1011111110000010000000000000000001001001"),	 -- 43	73
	 ("0111111110000001000000000000000000101010"),	 -- 42	42
	 ("1011111110000000100000000000000000101001"),	 -- 41	41
	 ("1100111110000000010000000000000000101000"),	 -- 40	40
	 ("1110111110000000001000000000000000011101"),	 -- 39	29
	 ("1111011110000000000000000000000000010010"),	 -- 38	18
	 ("1111101111000000000100000000000001100001"),	 -- 37	97
	 ("1111110110100000000010000000000001100000"),	 -- 36	96
	 ("1111111010010000000001000000000000101101"),	 -- 35	45
	 ("1111110110001000000000100000000000100010"),	 -- 34	34
	 ("1111101110000000000000010000000001010011"),	 -- 33	83
	 ("1111011110000100000000001000000001001000"),	 -- 32	72
	 ("1110111110000010000000000100000000001100"),	 -- 31	12
	 ("1101111110000001000000000010000000110110"),	 -- 30	54
	 ("1011111110000000100000000001000000011101"),	 -- 29	29
	 ("0111111110000000010000000000000000011100"),	 -- 28	28
	 ("1011111110000000001000000000100000011011"),	 -- 27	27
	 ("1101111110000000000100000000010000011010"),	 -- 26	26
	 ("1110111110000000000010000000001000011001"),	 -- 25	25
	 ("1111001110000000000001000000000100010100"),	 -- 24	20
	 ("1111101110000000000000100000000010010111"),	 -- 23	23
	 ("1111110110000000000000010000000001010010"),	 -- 22	82
	 ("1111111010100000000000001000000000010111"),	 -- 21	23
	 ("1111110010010000000000000100000000010100"),	 -- 20	20
	 ("1111101110000000000000000010000000100111"),	 -- 19	39
	 ("1111011110001000000000000001000000010010"),	 -- 18	18
	 ("1110111110000100000000000000100000010001"),	 -- 17	17
	 ("1101111110000010000000000000010000010000"),	 -- 16	16
	 ("1011111110000001000000000000001000001111"),	 -- 15	15
	 ("0111111110000000100000000000000100001110"),	 -- 14	14
	 ("1011111110000000010000000000000010001101"),	 -- 13	13
	 ("1101111110000000001000000000000001001000"),	 -- 12	72
	 ("1110111110000000000000000000000000101110"),	 -- 11	14
	 ("1111011110010000000100000000000000011110"),	 -- 10	14
	 ("1111101110001000000010000000000000011101"),	 -- 9	29
	 ("1111111010000100000001000000000000010010"),	 -- 8	18
	 ("1111111010000010000000100000000001000011"),	 -- 7	67
	 ("1111110110000001000000010000000001100000"),	 -- 6	96
	 ("1111101110000000100000001000000000101101"),	 -- 5	45
	 ("1111011110000000010000000100000000100010"),	 -- 4	34
	 ("1110111110000000001000000010000001010011"),	 -- 3	83
	 ("1101111110000000000100000001000000111110"),	 -- 2	62
	 ("1011111110000000000010000000000001000001"),	 -- 1	65
	 ("0111111110101000000001000000000000110010"));	 -- 0	50


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

