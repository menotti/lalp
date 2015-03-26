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
	clk : in std_logic); 
end block_ram_mult_a; 

architecture rtl of block_ram_mult_a is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_0 : std_logic_vector(address_width-1 downto 0); 
signal read_1 : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
	 ("00000000000000000000000000000000"),	 -- 15	0
	 ("00000000000000000000000000000000"),	 -- 14	0
	 ("00000000000000000000000000000000"),	 -- 13	0
	 ("00000000000000000000000000000000"),	 -- 12	0
	 ("00000000000000000000000000000000"),	 -- 11	0
	 ("00000000000000000000000000000000"),	 -- 10	0
	 ("00000000000000000000000000001010"),	 -- 9	10
	 ("00000000000000000000000000001001"),	 -- 8	9
	 ("00000000000000000000000000001000"),	 -- 7	8
	 ("00000000000000000000000000000111"),	 -- 6	7
	 ("00000000000000000000000000000110"),	 -- 5	6
	 ("00000000000000000000000000000101"),	 -- 4	5
	 ("00000000000000000000000000000100"),	 -- 3	4
	 ("00000000000000000000000000000011"),	 -- 2	3
	 ("00000000000000000000000000000010"),	 -- 1	2
	 ("00000000000000000000000000000001"));	 -- 0	1


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

