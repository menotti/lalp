-- IEEE Libraries -- 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_mult_a is 
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
	clk : in std_logic); 
end block_ram_mult_a; 

architecture rtl of block_ram_mult_a is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_0 : std_logic_vector(address_width-1 downto 0); 
signal read_1 : std_logic_vector(address_width-1 downto 0); 
signal read_2 : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
         ("10000000000000010000000001000000"),   -- 15  0
         ("01000000000000101000000010000000"),   -- 14  0
         ("00100000000001000100000100000000"),   -- 13  0
         ("00010000000010000010001000000000"),   -- 12  0
         ("00001000000100000001010000000000"),   -- 11  0
         ("00000100001000000000100000000000"),   -- 10  0
         ("00000010010000000001010000001010"),   -- 9   10
         ("00000001100000000010001000001001"),   -- 8   9
         ("00000001100000000100000100001000"),   -- 7   8
         ("00000010010000001000000010000111"),   -- 6   7
         ("00000100001000010000000001000110"),   -- 5   6
         ("00001000000100100000000000100101"),   -- 4   5
         ("00010000000011000000000000010100"),   -- 3   4
         ("00100000000011000000000000001011"),   -- 2   3
         ("01000000000100100000000000010010"),   -- 1   2
         ("10000000001000010000000000100001"));  -- 0   1

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
             end if; 
       end process; 
end rtl; 

