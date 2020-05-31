-- Quartus II VHDL Template
-- Single port RAM with single read/write address 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dm is

	generic 
	(
		DATA_WIDTH : natural := 16;
		ADDR_WIDTH : natural := 12
	);

	port 
	(
		reset	: in std_logic;
		clk	: in std_logic;
		addr	: in std_logic_vector (11 downto 0);
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic ;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of dm is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Register to hold the address 
	-- signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;
	
		function init_md
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		
		
			tmp(0) 	:= "0001001000010110";	-- addi $r1, $r0, 22
			tmp(1) 	:= "0001010000111110";	-- addi
			tmp(2) 	:= "0001011000010000";	-- addi
			tmp(3) 	:= "0001100000000000";	-- addi 
			tmp(5) 	:= "0001111000000000";	-- addi
			tmp(4) 	:= "0001101000000010";	-- addi	
			tmp(6) 	:= "0010100101000111";	-- beq $r4, $r5, 001110
			tmp(7) 	:= "0000110011100101";	-- slt $
			tmp(8) 	:= "0010110000000010";
			tmp(9) 	:= "0000111111010000";	
			tmp(10) 	:= "1000000000001100";
			tmp(11) 	:= "0000111111001000";				
			tmp(12) 	:= "0110100000111000";	
			tmp(13) 	:= "1000000000000110";
			tmp(14) 	:= "0111000000000000";
			tmp(15) 	:= "1000000000000000";	
			
		return tmp;
	end init_md;	 

	signal md : memory_t := init_md;
	
begin


	process(clk)
	begin
	


	if(rising_edge(clk)) then

		if(we = '1') then
			md(to_integer(unsigned(addr))) <= data;
		end if;
		
		q <= md(to_integer(unsigned(addr)));
		
		-- Register the address for reading
	
	end if;
	end process;
	
	

end rtl;

