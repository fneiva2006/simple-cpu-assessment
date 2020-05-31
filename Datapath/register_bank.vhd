library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_bank is

	port(
		reset				: in std_logic;
		clock 			: in std_logic;
		
		
		RA_addr			: in std_logic_vector(2 downto 0);
		RB_addr			: in std_logic_vector(2 downto 0);
		RC_addr			: in std_logic_vector(2 downto 0);
		
		write_enable	: in std_logic;
		data_in			: in std_logic_vector(15 downto 0);
		
		RA_out_data 	: out std_logic_vector(15 downto 0);
		RB_out_data		: out std_logic_vector(15 downto 0);
		RC_out_data		: out std_logic_vector(15 downto 0);
		R7_out_data 	: out std_logic_vector(15 downto 0)
		
	);	
	
end register_bank;


architecture comportamento of register_bank is	
		
type BR_tipo is array (0 to 7) of std_logic_vector(15 downto 0);
signal BR_aux: BR_tipo;

begin
  escrita: process(clock, reset, RA_addr, RB_addr, RC_addr, write_enable, BR_aux , data_in )
  begin
	if reset='1' then	
		for  i  in  0 to 7  loop
            BR_aux(i)<= std_logic_vector(to_unsigned(i,16));
        end loop;
		  
    elsif rising_edge(clock) then
		if write_enable = '1' then
			BR_aux(to_integer(unsigned(RA_addr))) <= data_in;
		end if;
    end if;
	 

  end process escrita;	

	 RA_out_data <= BR_aux(to_integer(unsigned(RA_addr)));
	RB_out_data <= BR_aux(to_integer(unsigned(RB_addr)));
	RC_out_data <= BR_aux(to_integer(unsigned(RC_addr)));
	
	R7_out_data <= BR_aux(7);
end comportamento;
