library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fullCPU is
port ( 
	input_indicator_cpu 		: out std_logic;
	output_indicator_cpu 	: out std_logic;
	
	clock : in std_logic;
	reset : in std_logic;
	enter : in std_logic;
	
	input_bus 	: in std_logic_vector (15 downto 0);
	output_bus 	: out std_logic_vector ( 15 downto 0);
	
	to_dm_data 		: out std_logic_vector ( 15 downto 0);
	dm_data			: in std_logic_vector (15 downto 0);
	
	to_dm_addr 		: out std_logic_vector ( 15 downto 0);
	
		ula_a_c : out std_logic_vector ( 15 downto 0);
		ula_b_c : out std_logic_vector ( 15 downto 0);
	
	zero_ot : out std_logic;
	to_dm_we : out std_logic

);
end fullCPU;


architecture structure of fullCPU is

component ControlBlock

  generic(
        r: natural := 8; 
        s: natural := 16
    ); 
	 
	port(
	
			input_indicator_cb 	: out std_logic;
			output_indicator_cb 	: out std_logic;
			
			clock : in std_logic;
			reset : in std_logic;
			enter	: in std_logic;
			
			dm_addr 			: out std_logic_vector ( s-1 downto 0);
			from_dm_data	: in std_logic_vector  ( s-1 downto 0);
			
			dmr_output_data 	: out std_logic_vector ( s-1 downto 0);
			ir_output_data 	: out std_logic_vector ( s-1 downto 0);
			pc_output_data		: out std_logic_vector ( s-1 downto 0);
			
			dm_we					: out std_logic;
			
			mux_4_R_ctr			: out std_logic_vector (1 downto 0);
			mux_4_A_ctr			: out std_logic_vector (1 downto 0);
			mux_4_B_ctr			: out std_logic_vector (1 downto 0);
			
			mux_2_2_ctr			: out std_logic;
			
			reg_bank_we			: out std_logic;
			
			alu_out_data		: in std_logic_vector ( s-1 downto 0);
			alu_ctr				: out std_logic_vector(2 downto 0);
			
--			pc_count_ot :out std_logic;
--			dmr_we_ot : out std_logic;
--			pc_we_ot : out std_logic;
			
			alu_zero_i			: in std_logic
	
	);
	end component;
	
component Datapath2
	port (	
		reset										: in std_logic;
		clock    								: in std_logic;
		
		register_bank_write_enable			: in std_logic;	-- sinal write_enable register bank
		
		mux2_ctr_2	: in std_logic;							-- sinal controle mux 2
		
		alu_out_zero 	: out std_logic; -- saida sinal zero ula
		alu_control 	: in std_logic_vector (2 downto 0); -- sinal controle ALU
		alu_out_data	: out std_logic_vector (15 downto 0);
		
		mux4_ctr_a 	:	in std_logic_vector (1 downto 0);	-- sinal controle mux 4x1 A
		mux4_ctr_b 	:	in std_logic_vector (1 downto 0);	-- sinal controle mux 4x1 B
		mux4_ctr_r 	:	in std_logic_vector (1 downto 0);	-- sinal controle mux 4x1 do Reg Bank
		
		from_pc_data			: in std_logic_vector( 15 downto 0);
	
		to_dm_data				: out std_logic_vector ( 15 downto 0);
		from_dmr_data			: in std_logic_vector ( 15 downto 0) ;
		
		from_ri_inst 			: in std_logic_vector ( 15 downto 0) ;
		
		ula_a : out std_logic_vector ( 15 downto 0);
		ula_b : out std_logic_vector ( 15 downto 0);
		
		input						: in std_logic_vector ( 15 downto 0);
		output		  			: out std_logic_vector(15 downto 0)
	);
	end component;
	
	

signal mux2_ctr_2_sig, register_bank_write_enable_sig, alu_zero_sig : std_logic ;

signal alu_control_sig: std_logic_vector (2 downto 0);

signal mux4_ctr_r_sig, mux4_ctr_a_sig, mux4_ctr_b_sig: std_logic_vector (1 downto 0);

signal from_dmr_data_sig, from_ir_inst_sig, from_pc_data_sig, alu_out_reg_data_sig : std_logic_vector (15 downto 0);
	
begin
		dpth : Datapath2
		port map(
		reset			=> reset,
		clock    	=> clock,
			
		register_bank_write_enable			=> register_bank_write_enable_sig,
		
		mux2_ctr_2	=> mux2_ctr_2_sig,
		
		alu_out_zero 	=> alu_zero_sig,
		alu_control 	=> alu_control_sig,
		alu_out_data	=> alu_out_reg_data_sig,
		
		mux4_ctr_a 	=> mux4_ctr_a_sig,
		mux4_ctr_b 	=> mux4_ctr_b_sig,
		mux4_ctr_r 	=> mux4_ctr_r_sig,
		
		from_pc_data			=> from_pc_data_sig,
	
		to_dm_data				=> to_dm_data,
		from_dmr_data			=> from_dmr_data_sig,
		
		from_ri_inst 			=> from_ir_inst_sig,
		
		ula_a => ula_a_c,
		ula_b => ula_b_c,

		
		input						=> input_bus,
		output		  			=> output_bus
		
		);

	ctrl_blk : ControlBlock
	port map (
	
			input_indicator_cb 	=> input_indicator_cpu,
			output_indicator_cb 	=> output_indicator_cpu,
	
			clock => clock,
			reset => reset,
			enter	=> enter,
			
			dm_addr 			=> to_dm_addr,
			from_dm_data	=> dm_data,
			
			dmr_output_data 	=> from_dmr_data_sig,
			ir_output_data 	=> from_ir_inst_sig,
			pc_output_data		=> from_pc_data_sig,
			
			dm_we					=> to_dm_we,
			
			mux_4_R_ctr			=> mux4_ctr_r_sig,
			mux_4_A_ctr			=> mux4_ctr_a_sig,
			mux_4_B_ctr			=> mux4_ctr_b_sig,
			
			mux_2_2_ctr			=> mux2_ctr_2_sig,
			
			reg_bank_we			=> register_bank_write_enable_sig,
			
			alu_out_data		=> alu_out_reg_data_sig,
			alu_ctr				=> alu_control_sig,
				
			alu_zero_i			=> alu_zero_sig

	);


zero_ot <= alu_zero_sig;



end structure;