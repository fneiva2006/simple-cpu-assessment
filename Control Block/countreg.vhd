library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity countReg is
	port(
		R_reset				: in std_logic;
		R_clock 				: in std_logic;
		Data_in				: in std_logic_vector(16-1 downto 0);
		R_WriteEnable		: in std_logic;
		R_count 				: in std_logic;
		Data_out				: buffer std_logic_vector(16-1 downto 0)
	);	
end countReg;

architecture comportamento of countReg is			
begin
  escrita: process(R_clock, R_reset, Data_in, Data_out , R_WriteEnable)
  begin
	if R_reset='1' then	
		Data_out <= "0000000000000000";
		
    elsif rising_edge(R_clock) then
	 	
		if R_WriteEnable ='1' then
			Data_out <= Data_in;
		end if;
			
		if R_count = '1' then
			Data_out <= std_logic_vector(unsigned(Data_out) + 1);
		end if;
		
    end if;
  end process escrita;						   
end comportamento;
