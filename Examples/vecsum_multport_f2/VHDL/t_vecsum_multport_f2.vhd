library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
entity t_vecsum_multport_f2 is 
end t_vecsum_multport_f2; 
architecture behavior of t_vecsum_multport_f2 is 

component vecsum_multport_f2 
	port (
		\init\	: in	std_logic;
		\done\	: out	std_logic;
		\out_27\	: out	std_logic_vector(31 downto 0);
		\out_28\	: out	std_logic_vector(31 downto 0);
		\clk\	: in	std_logic;
		\reset\	: in	std_logic;
		\clear\	: in	std_logic
	);
end component;

signal \init\	: std_logic	:= '0';
signal \done\	: std_logic	:= '0';
signal \out_27\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \out_28\	: std_logic_vector(31 downto 0)	:= (others => '0');
signal \clk\	: std_logic	:= '0';
signal \reset\	: std_logic	:= '0';
signal \clear\	: std_logic	:= '0';

begin


uut: vecsum_multport_f2 
port map ( 
	\init\ => \init\,
	\done\ => \done\,
	\out_27\ => \out_27\,
	\out_28\ => \out_28\,
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
