-- IEEE Libraries -- 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_v is 
generic( 
        data_width : integer := 8; 
        address_width : integer := 8 
); 
port( 
        data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0'); 
        address : in std_logic_vector(address_width-1 downto 0); 
        we: in std_logic := '0'; 
        oe: in std_logic := '1'; 
        clk : in std_logic; 
        data_out : out std_logic_vector(data_width-1 downto 0)); 
end block_ram_v; 

architecture rtl of block_ram_v is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_a : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
	 ("00000000000000000000000000000000"),	 -- 15	0
	 ("00000000000000000000000000000000"),	 -- 14	0
	 ("00000000000000000000000000000000"),	 -- 13	0
	 ("00000000000000000000000000000000"),	 -- 12	0
	 ("00000000000000000000000000000000"),	 -- 11	0
	 ("00000000000000000000000000000000"),	 -- 10	0
	 ("00000000000000000000000000000010"),	 -- 9	2
	 ("00000000000000000000001111101000"),	 -- 8	1000
	 ("00000000000000000000000000000100"),	 -- 7	4
	 ("00000000000000000000000000000011"),	 -- 6	3
	 ("00000000000000000000000000000010"),	 -- 5	2
	 ("00000000000000000000000000000001"),	 -- 4	1
	 ("00000000000000000000000000010111"),	 -- 3	23
	 ("00000000000000000000001100100000"),	 -- 2	800
	 ("00000000000000000000000000000010"),	 -- 1	2
	 ("00000000000000000000000000000001"));	 -- 0	1


begin 
       process (clk) 
       begin 
              if (clk'event and clk = '1') then 
                  if (we = '1') then 
                        RAM(conv_integer(address)) <= data_in; 
                        data_out <= RAM(conv_integer(read_a)); 
                  elsif (oe = '1') then 
                        data_out <= RAM(conv_integer(read_a)); 
                  end if; 
                  read_a <= address; 
             end if; 
       end process; 
end rtl; 

