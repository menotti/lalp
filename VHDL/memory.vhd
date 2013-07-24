-- IEEE Libraries -- 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity block_ram_res is 
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
end block_ram_res; 

architecture rtl of block_ram_res is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_a : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
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
entity block_ram_b is 
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
end block_ram_b; 

architecture rtl of block_ram_b is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_a : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
("00000000000000000000000000001010"),   --9         10
("00000000000000000000000000001001"),   --8         9
("00000000000000000000000000001000"),   --7         8
("00000000000000000000000000000111"),   --6         7
("00000000000000000000000000000110"),   --5         6
("00000000000000000000000000000101"),   --4         5
("00000000000000000000000000000100"),   --3         4
("00000000000000000000000000000011"),   --2         3
("00000000000000000000000000000010"),   --1         2
("00000000000000000000000000000001"));  --0         1
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
entity block_ram_d is 
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
end block_ram_d; 

architecture rtl of block_ram_d is 

constant mem_depth : integer := 2**address_width; 
type ram_type is array (mem_depth-1 downto 0) 
of std_logic_vector (data_width-1 downto 0); 

signal read_a : std_logic_vector(address_width-1 downto 0); 
signal RAM : ram_type := ram_type'( 
("00000000000000000000000000000000"),   --9         0
("00000000000000000000000000000000"),   --8         0
("00000000000000000000000000000000"),   --7         0
("00000000000000000000000000000000"),   --6         0
("00000000000000000000000000000000"),   --5         0
("00000000000000000000000000000000"),   --4         0
("00000000000000000000000000000000"),   --3         0
("00000000000000000000000000000000"),   --2         0
("00000000000000000000000000000000"),   --1         0
("00000000000000000000000000000000"));  --0         0
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
