library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity t_accumulation is 
end t_accumulation; 
architecture behavior of t_accumulation is 

component accumulation 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end component;

signal \init\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \clk\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \clear\	: std_logic	:= '0';

begin


uut: accumulation 
port map ( 
	\init\ => \init\,
	\done\ => \done\,
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
