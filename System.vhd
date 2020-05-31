library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system is 
port (
		reset : in std_logic;
		clock : in std_logic;
		
		input_indicator_sys	: out std_logic;
		output_indicator_sys	: out std_logic;
		
		system_input_bus 	: in std_logic_vector ( 15 downto 0);
		system_output_bus	: out std_logic_vector (15 downto 0);
		
		show_addr_dm : out std_logic_vector (15 downto 0);
		show_inst : out std_logic_vector (15 downto 0);
		
		zero_ot : out std_logic;
		
		ula_a_s : out std_logic_vector ( 15 downto 0);
		ula_b_s : out std_logic_vector ( 15 downto 0);
		
		enter : in std_logic
);
end system;

architecture sys_struct of system is 

	component dm 
	port 
	(
		clk	: in std_logic;
		addr	: in std_logic_vector (11 downto 0);
		data	: in std_logic_vector((16-1) downto 0);
		we		: in std_logic ;
		q		: out std_logic_vector((16 -1) downto 0)

	);
	end component;
	
	
	component fullCpu
	port (
		input_indicator_cpu 	: out std_logic;
		output_indicator_cpu 	: out std_logic;
		
		clock : in std_logic;
		reset : in std_logic;
		enter : in std_logic;
	
		input_bus 	: in std_logic_vector (15 downto 0);
		output_bus 	: out std_logic_vector ( 15 downto 0);
	
		to_dm_data 		: out std_logic_vector ( 15 downto 0);
		dm_data			: in std_logic_vector (15 downto 0);
	
		to_dm_addr 		: out std_logic_vector ( 15 downto 0);
	
		zero_ot : out std_logic;
		
				ula_a_c : out std_logic_vector ( 15 downto 0);
		ula_b_c : out std_logic_vector ( 15 downto 0);
		
		to_dm_we : out std_logic

	);
	end component;
	
	signal to_dm_data_sig, from_dm_data_sig : std_logic_vector ( 15 downto 0);
	
	signal to_dm_addr_sig : std_logic_vector ( 15 downto 0 );
	
	signal to_dm_we_sig, to_dm_re_sig : std_logic;
	
	begin
	
	CPU : fullCpu
	port map
	(
		input_indicator_cpu 	=> input_indicator_sys,
		output_indicator_cpu 	=> output_indicator_sys,
	
		clock => clock,
		reset => reset,
		enter => enter,
	
		input_bus 	=> system_input_bus,
		output_bus 	=> system_output_bus,
	
		to_dm_data 		=> to_dm_data_sig,
		dm_data			=> from_dm_data_sig,
	
		to_dm_addr 		=> to_dm_addr_sig,
		
		ula_a_c => ula_a_s,
		ula_b_c => ula_b_s,
		
		zero_ot => zero_ot,
		
		to_dm_we => to_dm_we_sig
	
	);
	
	
	DataMemory : dm
	port map 
	(
			clk	=> clock,
			addr	=> to_dm_addr_sig(11 downto 0),
			data	=> to_dm_data_sig,
			we		=> to_dm_we_sig,
			q		=> from_dm_data_sig
	
	);
	
	show_addr_dm <= to_dm_addr_sig;
	show_inst <= from_dm_data_sig;
	

	end sys_struct;
	