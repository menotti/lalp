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
	 ("1000000000000000"),	 -- 127	0
	 ("0000000000000000"),	 -- 126	0
	 ("0110000000000000"),	 -- 125	0
	 ("0000000000000000"),	 -- 124	0
	 ("0001000000000000"),	 -- 123	0
	 ("0000100000000000"),	 -- 122	0
	 ("0000010000000000"),	 -- 121	0
	 ("0000001000000000"),	 -- 120	0
	 ("0000000100000000"),	 -- 119	0
	 ("0000000010000000"),	 -- 118	0
	 ("1000000001000000"),	 -- 117	0
	 ("0100000000000000"),	 -- 116	0
	 ("0010000000000000"),	 -- 115	0
	 ("0001000000000000"),	 -- 114	0
	 ("0000000000000000"),	 -- 113	0
	 ("0000100000000000"),	 -- 112	0
	 ("0000010000000000"),	 -- 111	0
	 ("0000001000000000"),	 -- 110	0
	 ("0000000100000000"),	 -- 109	0
	 ("0000000010000000"),	 -- 108	0
	 ("1000000001000000"),	 -- 107	0
	 ("0100000000000000"),	 -- 106	0
	 ("0010000000000000"),	 -- 105	0
	 ("0001000000000000"),	 -- 104	0
	 ("0000100000000000"),	 -- 103	0
	 ("0000010000000000"),	 -- 102	0
	 ("0000001000000000"),	 -- 101	0
	 ("0000000100000000"),	 -- 100	0
	 ("0000000011100011"),	 -- 99	99
	 ("0000000001100110"),	 -- 98	38
	 ("0000000001100001"),	 -- 97	97
	 ("1000000001100000"),	 -- 96	96
	 ("0100000001011111"),	 -- 95	95
	 ("0010000001011110"),	 -- 94	94
	 ("0001000001011101"),	 -- 93	93
	 ("0000100001011100"),	 -- 92	92
	 ("0000010001100000"),	 -- 91	96
	 ("0000001001011111"),	 -- 90	95
	 ("0000000101011001"),	 -- 89	89
	 ("0000000010011100"),	 -- 88	28
	 ("1000000001010111"),	 -- 87	87
	 ("0100000001010110"),	 -- 86	86
	 ("0010000001010101"),	 -- 85	85
	 ("0001000001010100"),	 -- 84	84
	 ("0000100001010011"),	 -- 83	83
	 ("0000010001010010"),	 -- 82	82
	 ("0000001001010111"),	 -- 81	87
	 ("0000000101010100"),	 -- 80	84
	 ("0000000010011101"),	 -- 79	29
	 ("0000000000010010"),	 -- 78	18
	 ("0000000001100101"),	 -- 77	37
	 ("0000000001100000"),	 -- 76	96
	 ("0000000000110111"),	 -- 75	55
	 ("1110000000100010"),	 -- 74	34
	 ("0001000001010011"),	 -- 73	83
	 ("0000100001001000"),	 -- 72	72
	 ("0000010001000100"),	 -- 71	68
	 ("0000000000110101"),	 -- 70	53
	 ("0000001001000101"),	 -- 69	69
	 ("0000000101000100"),	 -- 68	68
	 ("0000000011000011"),	 -- 67	67
	 ("0000000001000000"),	 -- 66	64
	 ("0000000001000001"),	 -- 65	65
	 ("0010000001000000"),	 -- 64	64
	 ("0001000001000010"),	 -- 63	66
	 ("0000100000111110"),	 -- 62	62
	 ("0000010001000101"),	 -- 61	69
	 ("0000001000111100"),	 -- 60	60
	 ("0000000100011101"),	 -- 59	29
	 ("0000000000010010"),	 -- 58	18
	 ("0000001000100101"),	 -- 57	37
	 ("0000000101100000"),	 -- 56	96
	 ("0000000100101101"),	 -- 55	45
	 ("0000000100100010"),	 -- 54	34
	 ("0000000011010011"),	 -- 53	83
	 ("0000000011010010"),	 -- 52	82
	 ("0000000001111100"),	 -- 51	60
	 ("0000000001110100"),	 -- 50	52
	 ("1000000001011001"),	 -- 49	89
	 ("0100000000110000"),	 -- 48	48
	 ("0010000000101111"),	 -- 47	47
	 ("0001000000101110"),	 -- 46	46
	 ("0000100000101101"),	 -- 45	45
	 ("0000010000101100"),	 -- 44	44
	 ("0000000001001001"),	 -- 43	73
	 ("0000001000101010"),	 -- 42	42
	 ("0000000100101001"),	 -- 41	41
	 ("0000000011101000"),	 -- 40	40
	 ("0000000000011101"),	 -- 39	29
	 ("0000000000010010"),	 -- 38	18
	 ("1000000001100001"),	 -- 37	97
	 ("0110000001100000"),	 -- 36	96
	 ("0001000000101101"),	 -- 35	45
	 ("0000100000100010"),	 -- 34	34
	 ("0000010001010011"),	 -- 33	83
	 ("0000001001001000"),	 -- 32	72
	 ("0000000100001100"),	 -- 31	12
	 ("0000000010110110"),	 -- 30	54
	 ("0000000000011101"),	 -- 29	29
	 ("0000000001011100"),	 -- 28	28
	 ("0000000000111011"),	 -- 27	27
	 ("0000000000011010"),	 -- 26	26
	 ("0000000000011001"),	 -- 25	25
	 ("0000000000010100"),	 -- 24	20
	 ("1000000000010111"),	 -- 23	23
	 ("0100000001010010"),	 -- 22	82
	 ("0000000000010111"),	 -- 21	23
	 ("0010000000010100"),	 -- 20	20
	 ("0001000000100111"),	 -- 19	39
	 ("0000100000010010"),	 -- 18	18
	 ("0000010000010001"),	 -- 17	17
	 ("0000001000010000"),	 -- 16	16
	 ("0000000100001111"),	 -- 15	15
	 ("0000000010001110"),	 -- 14	14
	 ("0000000001001101"),	 -- 13	13
	 ("0000000001101000"),	 -- 12	72
	 ("0000000000011110"),	 -- 11	14
	 ("0000000000001110"),	 -- 10	14
	 ("0000000000011101"),	 -- 9	29
	 ("0000000000010010"),	 -- 8	18
	 ("0000000001000011"),	 -- 7	67
	 ("0000000001100000"),	 -- 6	96
	 ("0000000000101101"),	 -- 5	45
	 ("0000000000100010"),	 -- 4	34
	 ("0000000001010011"),	 -- 3	83
	 ("0000000000111110"),	 -- 2	62
	 ("0000000001000001"),	 -- 1	65
	 ("0000000000110010"));	 -- 0	50


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

