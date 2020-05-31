library IEEE;
use IEEE.std_logic_1164.all;

entity mux4X1 is
	generic(	
        m: natural := 16 -- Tamanho do dado que entra no mux
	);
	port
	(  MUXent_0	   : in std_logic_vector(m-1 downto 0);
	   MUXent_1		: in std_logic_vector(m-1 downto 0);
		MUXent_2		: in std_logic_vector(m-1 downto 0);
		MUXent_3		: in std_logic_vector(m-1 downto 0);
	   MUX_ctr		: in std_logic_vector(1 downto 0);
	   MUXsai		: out std_logic_vector(m-1 downto 0)
	);
end mux4X1;

architecture comportamento of mux4X1 is
signal saida_aux: std_logic_vector(m-1 downto 0);
begin
	comb: process(MUX_ctr, MUXent_0, MUXent_1, MUXent_2, MUXent_3)
	begin
	  case MUX_ctr is
	  
		when "00" => 
			saida_aux <= MUXent_0; 
		when "01" =>
			saida_aux <= MUXent_1;
		when "10" =>
			saida_aux <= MUXent_2;
		when "11" =>
			saida_aux <= MUXent_3;		
	  end case;
	  
	end process comb;
	MUXsai <= saida_aux;
end comportamento;
