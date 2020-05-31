library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity singleReg is
	port(
		R_reset				: in std_logic;
		R_clock 				: in std_logic;
		Data_in				: in std_logic_vector(16-1 downto 0);
		R_WriteEnable		: in std_logic;
		Data_out				: out std_logic_vector(16-1 downto 0)
	);	
end singleReg;

architecture comportamento of singleReg is	

signal out_tmp : std_logic_vector(15 downto 0);
		
begin
  process(R_clock, R_reset)
	begin 
	if( R_reset = '1') then
				out_tmp <= (out_tmp'range =>'0');
			
		elsif ( rising_edge(R_clock)) then
			
			if( R_WriteEnable = '1' ) then
				out_tmp <= Data_in;
			
		end if;
		end if;
 end process;
 
 Data_out <= out_tmp ;
				   
end comportamento;
 