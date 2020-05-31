library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlBlock is
    generic(
        r: natural := 8; 
        s: natural := 16
    ); 
	port (
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
			
			pc_count_ot :out std_logic;
			dmr_we_ot : out std_logic;
			pc_we_ot : out std_logic;
			
			alu_zero_i			: in std_logic
		
	);
end ControlBlock;

architecture estrutural of ControlBlock is

component mux2X1
	port (
		MUXent_0	   : in std_logic_vector(15 downto 0);
	   MUXent_1		: in std_logic_vector(15 downto 0);
	   MUX_ctr		: in std_logic;
	   MUXsai		: out std_logic_vector(15 downto 0)
	);
end component;

component countReg
	port(
      R_reset				: in std_logic;
		R_clock 				: in std_logic;
		Data_in				: in std_logic_vector(16-1 downto 0);
		R_WriteEnable		: in std_logic;
		R_count 				: in std_logic;
		Data_out				: out std_logic_vector(16-1 downto 0)
	);	
end component;

component singleReg
	port (
		R_reset				: in std_logic;
		R_clock 				: in std_logic;
		Data_in				: in std_logic_vector(16-1 downto 0);
		R_WriteEnable		: in std_logic;
		Data_out				: out std_logic_vector(16-1 downto 0)
	);	
end component;

component controladora
	port (
		input_indicator 	: out std_logic;
		output_indicator 	: out std_logic;
		
		reset			: in std_logic;
		clock			: in std_logic;
-- sinal enter externo
		enter 		: in std_logic;
		
-- sinais registradores	
		pc_we		: out std_logic;
		pc_count		: out std_logic;
		pc_reset 	: out std_logic;
		
		ir_we 		: out std_logic;
		
		dmr_we 		: out std_logic;
		
-- sinal banco de registrador	
		rb_we		: out std_logic;
		
-- sinal memória de dados		
		dm_write		: out std_logic;
		
-- sinais mux	
		mux_1			: out std_logic;
		mux_2			: out std_logic;
		mux_r			: out std_logic_vector (1 downto 0);
		mux_alu_a	: out std_logic_vector (1 downto 0);
		mux_alu_b	: out std_logic_vector (1 downto 0);
			
-- sinal zero ula
		alu_zero		: in std_logic;
		
-- sinal operação da ula
		alu_op		: out std_logic_vector (2 downto 0);
		
-- sinal de intrução
		inst_opcode : in std_logic_vector(3 downto 0);

-- sinal funct
		inst_funct : in  std_logic_vector(  2 downto 0)

	);

end component;

		
signal	mux_1_ctr_sig	, dmr_we_ot_sig	: std_logic;

signal pc_out_data_sig, ir_output_data_sig		: std_logic_vector ( 15 downto 0);



signal pc_count_sig, dmr_we_sig, ir_we_sig, pc_we_sig, pc_reset_sig	: std_logic;


begin

	 
	PC: countReg 
	port map(
		R_reset				=> pc_reset_sig,
		R_clock 				=> clock,
		Data_in				=> alu_out_data,
		R_WriteEnable		=> pc_we_sig,
		R_count 				=> pc_count_sig,
		Data_out				=> pc_out_data_sig
	);
    
	 	RI: singleReg 
	port map(
      R_reset				 	=> reset,
		R_clock 					=> clock,
		Data_in					=> from_dm_data,
		R_WriteEnable		   => ir_we_sig,
		Data_out					=> ir_output_data_sig
    );

		DmReg : singleReg
		port map (
		
		R_reset				=> reset,
		R_clock 				=> clock, 
		Data_in				=> from_dm_data,
		R_WriteEnable		=> dmr_we_sig,
		Data_out				=> dmr_output_data
		
		);
	
		mux_1 : mux2X1
		port map (
		MUXent_0	   => pc_out_data_sig,
	   MUXent_1		=> alu_out_data,
	   MUX_ctr		=> mux_1_ctr_sig,
	   MUXsai		=> dm_addr
		
		);
	 
	 ctrler : controladora
		port map
	(
		input_indicator 	=> input_indicator_cb,
		output_indicator 	=> output_indicator_cb,
		
		reset			=> reset,
		clock			=> clock,
		
		enter 		=> enter,
		
		pc_we			=> pc_we_sig,
		pc_count		=> pc_count_sig,
		pc_reset 	=> pc_reset_sig,
		
		ir_we 		=> ir_we_sig,
		
		dmr_we 		=>	dmr_we_sig,

		rb_we			=> reg_bank_we,
		
		dm_write		=> dm_we,
		
	
		mux_1			=> mux_1_ctr_sig,
		mux_2			=> mux_2_2_ctr,
		mux_r			=> mux_4_R_ctr,
		mux_alu_a	=> mux_4_A_ctr,
		mux_alu_b	=> mux_4_B_ctr,
			

		alu_zero		=> alu_zero_i,
		

		alu_op		=> alu_ctr,
		

		inst_opcode => ir_output_data_sig( 15 downto 12),


		inst_funct => ir_output_data_sig ( 2 downto 0)
		
		);
		
		ir_output_data <= ir_output_data_sig;
		pc_output_data <= pc_out_data_sig;
		
		pc_count_ot <= pc_count_sig;
		dmr_we_ot <= dmr_we_sig;
		pc_we_ot <= pc_we_sig;
		
end estrutural;
