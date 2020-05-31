library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity ula is
	generic(
			n: natural := 16; -- numero de bits dos operandos da ALU
			m: natural := 3 -- numero de bits de funcoes diferentes
	);
	port 
	(	ALUin_0 : in std_logic_vector(n-1 downto 0); 
		ALUin_1 : in std_logic_vector(n-1 downto 0);
		ALU_ctr : in std_logic_vector (m-1 downto 0);
		ALUout_result : out std_logic_vector (n-1 downto 0);
		ALUout_zero : out std_logic
	);
end ula;

architecture comportamento of ula is

constant ADICAO : std_logic_vector(m-1 downto 0) := "000";
constant SUBTRACAO : std_logic_vector(m-1 downto 0) := "001";
constant AND_BIT : std_logic_vector(m-1 downto 0) := "010";
constant NOR_BIT : std_logic_vector(m-1 downto 0) := "011";
constant XOR_BIT : std_logic_vector(m-1 downto 0) := "100";
constant COMP : std_logic_vector(m-1 downto 0) := "101";

signal out_aux : std_logic_vector(n-1 downto 0);
signal comp_aux : std_logic_vector(n-1 downto 0);
begin
	comb: process (ALUin_0, ALUin_1, ALU_ctr)
	begin
		case ALU_ctr is
		 when ADICAO =>
			ALUout_zero <= '0';
			 out_aux <= ALUin_0 + ALUin_1;
			 
		 when SUBTRACAO =>
			 out_aux <= ALUin_0 - ALUin_1;
		
			 
		 when AND_BIT =>
				ALUout_zero <= '0';
			 out_aux <= ALUin_0 AND ALUin_1;
			 
		 when NOR_BIT =>
				ALUout_zero <= '0';
			 out_aux <= ALUin_0 NOR ALUin_1;
			 
		 when XOR_BIT =>
			ALUout_zero <= '0';
			 out_aux <= ALUin_0 XOR ALUin_1;
			 
		 when COMP =>
			ALUout_zero <= '0';
			comp_aux <= ALUin_0 - ALUin_1;
			if comp_aux(15) = '1' then
				out_aux <= "0000000000000001";
			else
				out_aux <= "0000000000000000";
			end if;
			
		when others => null;
		
		end case;
		
				if out_aux = "0000000000000000" then
					ALUout_zero <= '1';
			end if;  
		
	end process comb; 
	
	
	
	ALUout_result <= out_aux;
	
end comportamento;