library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controladora is
	generic(r: natural := 8; s: natural := 16);  
	port (
		
		input_indicator 	: out std_logic;
		output_indicator 	: out std_logic;
		
		reset			: in std_logic;
		clock			: in std_logic;
-- sinal enter externo
		enter 		: in std_logic;
		
-- sinais registradores	
		pc_we			: out std_logic;
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
end controladora;

architecture FSM of controladora is 

constant ro_operations	: std_logic_vector(3 downto 0):= "0000";

constant addi 				: std_logic_vector(3 downto 0):= "0001";
constant beq 				: std_logic_vector(3 downto 0):= "0010";

constant load 				: std_logic_vector(3 downto 0):= "0011";
constant store 			: std_logic_vector(3 downto 0):= "0100";

constant move 				: std_logic_vector(3 downto 0):= "0101";

constant input 			: std_logic_vector(3 downto 0):= "0110";
constant output 			: std_logic_vector(3 downto 0):= "0111";

constant jump 				: std_logic_vector(3 downto 0):= "1000";

-- Definição dos estados da FSM de baixo nível.
type tipo_estado is (iniciar , buscar, decodificar,	s_RO_ops , s_ADDI , s_BEQ_1, s_BEQ_2, s_BEQ_3,
 s_STORE_1, s_STORE_2, s_LOAD_1, s_LOAD_2, s_LOAD_3, s_INPUT_1, s_INPUT_2,	s_OUTPUT_1, s_OUTPUT_2, s_JUMP, s_JUMP_2, s_MOVE );


signal proximo, atual: tipo_estado;

begin

Registrador_de_estados: process(clock, reset)
    begin
		if (reset='1') then
			atual <= iniciar;
		elsif (rising_edge(clock)) then
			atual <= proximo;
		end if;

    end process;
	 
	logica_combinacional: process(atual)
	begin
	
			
			alu_op	<= "000";
	
			mux_1		<= '0';
			mux_2		<= '0';
			mux_r		<= "10";

			mux_alu_a	<= "11";
			mux_alu_b	<= "11";
	 
			pc_we			<= '0';
			pc_count		<= '0';
			pc_reset 	<= '0';
		
			ir_we 		<= '0';
		
			dmr_we 		<= '0';
			
			rb_we			<= '0';
	
			dm_write		<= '0';
			
			output_indicator <= '0';
			input_indicator <= '0';
			
	
	 case atual is
		when iniciar =>	
			pc_reset 	<= '1';
			proximo <= buscar;
			
		
		when buscar =>
			output_indicator <= '0';
			input_indicator <= '0';
			
			pc_reset 	<= '0';

			pc_count		<= '1';
		
			ir_we 		<= '1';
			
			proximo <= decodificar;
			
			
		when decodificar =>

			
			case(inst_opcode) is
					when ro_operations =>
						proximo <= s_RO_ops;
					when addi =>
						proximo <= s_ADDI;
					when beq =>
						proximo <= s_BEQ_1;
					when load =>
						proximo <= s_LOAD_1;
					when store =>
						proximo <= s_STORE_1;
					when move =>
						proximo <= s_MOVE;
					when input =>
						proximo <= s_INPUT_1;
					when output =>
						proximo <= s_OUTPUT_1;	
					when jump =>
						proximo <= s_JUMP;
					when others =>
						proximo <= buscar;
				end case;
			
			
			when s_RO_ops =>
				alu_op <= inst_funct;
	
				mux_1		<= '0';
				mux_2		<= '0';
				mux_r		<= "10";

				mux_alu_a	<= "11";
				mux_alu_b	<= "11";
		
				ir_we 		<= '0';
				
				rb_we			<= '1';
				
				proximo <= buscar;
				
				
			when s_ADDI =>
				
				alu_op <= "000";
				
				mux_1		<= '0';
				mux_2		<= '0';
				mux_r		<= "10";

				mux_alu_a	<= "11";
				mux_alu_b	<= "10";
				
				rb_we			<= '1';
				
				proximo <= buscar;
				
			when s_BEQ_1 =>
				alu_op <= "001";
				
				mux_alu_a <= "00";
				mux_alu_b <= "01";
				
				mux_1		<= '0';
				mux_2		<= '0';
				mux_r		<= "10";
				
				if alu_zero = '1' then
					proximo <= s_BEQ_2;
				else
					proximo <= buscar;
				end if;
				
			when s_BEQ_2 =>
				alu_op <= "000";
				
				mux_1		<= '0';
				mux_2		<= '0';
				mux_r		<= "10";
				
				mux_alu_a 	<= "10";
				mux_alu_b	<= "10";
											
				pc_we			<= '1';
			
				proximo <= s_BEQ_3;
				
			when s_BEQ_3 =>
				alu_op <= "000";
				
				mux_alu_a 	<= "10";
				mux_alu_b	<= "00";
											
				mux_1		<= '0';
				mux_2		<= '0';
				mux_r		<= "10";
	 
				pc_we			<= '0';

				proximo <= buscar;
				
			when s_LOAD_1 =>
				alu_op <= "000";
				
				mux_alu_a <= "11";
				mux_alu_b <= "10";
				
				mux_2 <= '0';
				mux_1 <= '1';
				
				proximo <= s_LOAD_2;
				
				
			when s_LOAD_2 =>
				dmr_we <= '1';
				
				proximo <= s_lOAD_3;
				
			when s_LOAD_3 =>
				dmr_we <= '0';
				mux_r <= "00";
				rb_we <= '1';
				
				proximo <= buscar;
				
				
			when s_STORE_1 =>
				alu_op <= "000";
				
				mux_alu_a <= "11";
				mux_alu_b <= "10";
				
				mux_2 <= '0';
				mux_1 <= '1';
				
				proximo <= s_STORE_2;
				
			when s_STORE_2 =>
				dm_write <= '1';
				
				proximo <= buscar;
				
			when s_MOVE =>
				alu_op <= "000";
				
				mux_alu_a <= "11";
				mux_alu_b <= "00";
				
				mux_r <= "10";
				
				rb_we <= '1';
				
				proximo <= buscar;
				
			when s_INPUT_1 =>
				alu_op <= "000";
				input_indicator <= '1';
	
				if enter = '1' then
					proximo <= s_INPUT_2;
				else
					proximo <= s_INPUT_1;
				end if;
				
			when s_INPUT_2 =>
			input_indicator <= '1';
					mux_r <= "01";
					rb_we <= '1';
				
				if enter = '0' then
					proximo <= buscar;
				else
					proximo <= s_INPUT_2;
				end if;
				
				
			when s_OUTPUT_1 =>
				alu_op <= "000";
				output_indicator <= '1';
				
				if enter = '1' then
					proximo <= s_OUTPUT_2;
				else
					proximo <= s_OUTPUT_1;
				end if;
				
			when s_OUTPUT_2 =>
				alu_op <= "000";
				output_indicator <= '1';
			
				if enter = '0' then
					proximo <= buscar;
				else
					proximo <= s_OUTPUT_2;
				end if;
				
			when s_JUMP =>
				alu_op <= "000";
				
				mux_alu_a <= "01";
				mux_alu_b <= "10";
				
				mux_2 <= '1';
				
				pc_we <= '1';
				
				proximo <= s_JUMP_2;
				
			when s_JUMP_2 =>
			alu_op <= "000";
			proximo <= buscar;
			
			
			when others => 
				proximo <= buscar;
				
			end case;
			
		end process;		

end FSM;

