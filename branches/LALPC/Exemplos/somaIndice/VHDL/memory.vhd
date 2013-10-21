-- IEEE Libraries -- 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_a is 
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
end block_ram_a; 

architecture rtl of block_ram_a is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_a : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
	 ("00000000000000000000000000000000"),	 -- 3	0
	 ("00000000000000000000000000000001"),	 -- 2	1
	 ("00000000000000000000000000000001"),	 -- 1	1
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

