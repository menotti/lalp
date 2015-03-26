library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity t_sobel is 
end t_sobel; 
architecture behavior of t_sobel is 

component sobel 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\out_142\	: out	std_logic_vector(7 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end component;

signal \init\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \out_142\	: std_logic_vector(7 downto 0)	:= (others => '0');
signal \clk\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \clear\	: std_logic	:= '0';

begin


uut: sobel 
port map ( 
	\init\ => \init\,
	\done\ => \done\,
	\out_142\ => \out_142\,
	\clk\ => \clk\,
	\reset\ => \reset\,
	\clear\ => \clear\
);

clock: process 
begin
	wait for 5 ns; 
	\clk\  <= not \clk\; 
end process clock; 

stimulus: process 
begin 
	\reset\  <= '1'; 
	wait for 50 ns; 
	\reset\  <= '0'; 
	wait for 50 ns; 
	\init\  <= '1'; 
	wait; 
end process stimulus; 
end behavior;
