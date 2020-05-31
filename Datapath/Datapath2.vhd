library IEEE;
use IEEE.std_logic_1164.all;

entity Datapath2 is
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
end Datapath2;

architecture behaviour of Datapath2 is

component ula is 	
	port 
	(	ALUin_0 : in std_logic_vector(15 downto 0); 
		ALUin_1 : in std_logic_vector(15 downto 0);
		ALU_ctr : in std_logic_vector (2 downto 0);
		ALUout_result : out std_logic_vector (15 downto 0);
		ALUout_zero : out std_logic
	);
end component;

component mux4X1 is
generic( m : natural :=16);
	port
	(  MUXent_0	   : in std_logic_vector(m-1 downto 0);
	   MUXent_1		: in std_logic_vector(m-1 downto 0);
		MUXent_2		: in std_logic_vector(m-1 downto 0);
		MUXent_3		: in std_logic_vector(m-1 downto 0);
	   MUX_ctr		: in std_logic_vector(1 downto 0);
	   MUXsai		: out std_logic_vector(m-1 downto 0)
	);
end component;

component signal_extent12to16 is
	port
	(  signal_extent_in	   : in std_logic_vector(12-1 downto 0);
		signal_extent_out	   : out std_logic_vector(16-1 downto 0)
	);
end component;

component signal_extent6to16 is
	port
	(  signal_extent_in	   : in std_logic_vector(5 downto 0);
		signal_extent_out	   : out std_logic_vector(15 downto 0)
	);
end component;

component singleReg is
	port(
		R_reset				: in std_logic;
		R_clock 				: in std_logic;
		Data_in				: in std_logic_vector(16-1 downto 0);
		R_WriteEnable		: in std_logic;
		Data_out				: buffer std_logic_vector(16-1 downto 0)
	);	
end component;

component register_bank is

	port
	(
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
end component;

component mux2X1 is
	generic(	
        m: natural := 16 -- Tamanho do dado que entra no mux
	);
	port
	(  MUXent_0	   : in std_logic_vector(m-1 downto 0);
	   MUXent_1		: in std_logic_vector(m-1 downto 0);
	   MUX_ctr		: in std_logic;
	   MUXsai		: out std_logic_vector(m-1 downto 0)
	);
end component;

signal RA_out_data_sig, RB_out_data_sig, RC_out_data_sig	:  std_logic_vector(15 downto 0);

signal   mux_a_to_alu, mux_b_to_alu,  from_s_ext12_to_mux_2, from_s_ext6_to_mux_2:  std_logic_vector(15 downto 0);

signal mux_a_out_sig, mux_b_out_sig , mux_2_out_sig	, alu_out_sig , register_bank_data_in_sig:  std_logic_vector(15 downto 0);
--signal alu_out_zero : std_logic;

begin

	reg_bank : register_bank
		port map 
		(
			reset				=> reset,
			clock 			=> clock,
		
			RA_addr			=> from_ri_inst( 11 downto 9),
			RB_addr			=> from_ri_inst (8 downto 6),
			RC_addr			=> from_ri_inst (5 downto 3),
		
			write_enable	=> register_bank_write_enable,
			data_in			=> register_bank_data_in_sig,
		
			RA_out_data 	=> RA_out_data_sig,
			RB_out_data		=> RB_out_data_sig,
			RC_out_data		=> RC_out_data_sig,
			
			R7_out_data 	=>	output
		);
	
		mux_a : mux4X1
			port map
			(
				MUXent_0		=> RA_out_data_sig,
				MUXent_1		=> "0000000000000000",
				MUXent_2		=> from_pc_data,
				MUXent_3		=> RB_out_data_sig,
				MUX_ctr		=> mux4_ctr_a,
				MUXsai		=> mux_a_out_sig
			);
			
		mux_b : mux4X1
			port map
			(
				MUXent_0		=> "0000000000000000",
				MUXent_1		=> RB_out_data_sig,
				MUXent_2		=> mux_2_out_sig,
				MUXent_3		=> RC_out_data_sig,
				MUX_ctr		=> mux4_ctr_b,
				MUXsai		=> mux_b_out_sig
			);
			
		alu : ula
			port map
			(	
				ALUin_0			=> mux_a_out_sig,
				ALUin_1			=> mux_b_out_sig,
				ALU_ctr			=>	alu_control,
				ALUout_result	=>	alu_out_sig,
				ALUout_zero 	=> alu_out_zero
				
			);
			
	
		mux_R : mux4X1
			port map
			(
				MUXent_0		=> from_dmr_data,
				MUXent_1		=> input,
				MUXent_2		=> alu_out_sig,
				MUXent_3		=> "0000000000000000",
				MUX_ctr		=> mux4_ctr_r,
				MUXsai		=> register_bank_data_in_sig
			
			);
			

		mux2 : mux2X1
			port map
			(
				MUXent_0		=> from_s_ext6_to_mux_2,
				MUXent_1		=> from_s_ext12_to_mux_2,
				MUX_ctr		=> mux2_ctr_2,
				MUXsai		=> mux_2_out_sig
			
			);
		
			
			s_ext_6to16 : signal_extent6to16
			port map
			(
				signal_extent_in	=> from_ri_inst(5 downto 0),
				signal_extent_out	=> from_s_ext6_to_mux_2
			);
			
		
		s_ext_12to16 : signal_extent12to16
			port map
			(
				signal_extent_in	=> from_ri_inst(11 downto 0),
				signal_extent_out	=> from_s_ext12_to_mux_2
			);
			
		alu_out_data <= alu_out_sig;
		to_dm_data <= RA_out_data_sig;
		
		ula_a <= mux_a_out_sig;
		ula_b <= mux_b_out_sig;
			
end behaviour;


