library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controlador is
	port (
		iCLK	        : in std_logic; 		
		iRST 			  : in std_logic;
		opcode		  : in std_logic_vector(6 downto 0); 
		
		EscreveIR     : out std_logic;
		EscrevePCCond : out std_logic;
		EscrevePCBack : out std_logic;
		EscrevePC	  : out std_logic;
		OrigPC		  : out std_logic;
		
		OrigAULA		  : out std_logic_vector(1 downto 0);
		OrigBULA 	  : out std_logic_vector(1 downto 0);
		ALUOp			  : out std_logic_vector(1 downto 0);
		
		EscreveReg	  : out std_logic;
		Mem2Reg		  : out std_logic_vector(1 downto 0);
		
		EscreveMem	  : out std_logic;
		LeMem 		  : out std_logic
	);
end Controlador;

architecture bdf_type of controlador is

-- Estados FSM (Máquina de Estados Finitas)
type state_type is (
	ST_FETCH, 	  
	ST_DECODE, 	  
	ST_SW,
	ST_LW1,
	ST_LW2,
	ST_TipoR,
	ST_BEQ,
	ST_JAL,
	ST_JALR,
	ST_ADDI,
	ST_WRITEBACK
	);
signal pr_state, nx_state: state_type; -- Estado presente e Proximo estado

signal aux_EscreveIR     : std_logic;
signal aux_EscrevePCCond : std_logic;
signal aux_EscrevePCBack : std_logic;
signal aux_EscrevePC	   : std_logic;
signal aux_OrigPC		   : std_logic;

signal aux_OrigAULA	   : std_logic_vector(1 downto 0);
signal aux_OrigBULA 	   : std_logic_vector(1 downto 0);
signal aux_ALUOp			: std_logic_vector(1 downto 0);

signal aux_EscreveReg	   : std_logic;
signal aux_Mem2Reg		   : std_logic_vector(1 downto 0);

signal aux_EscreveMem	   : std_logic;
signal aux_LeMem 		   : std_logic;

begin

	EscreveIR     <= aux_EscreveIR;
	EscrevePCCond <= aux_EscrevePCCond;
	EscrevePCBack <= aux_EscrevePCBack;			
	EscrevePC 	  <= aux_EscrevePC;
	OrigPC        <= aux_OrigPC;
	
	OrigAULA      <= aux_OrigAULA;
	OrigBULA      <= aux_OrigBULA;
	ALUOp         <= aux_ALUOp;
	
	EscreveReg    <= aux_EscreveReg;
	Mem2Reg       <= aux_Mem2Reg;
	
	EscreveMem    <= aux_EscreveMem;
	LeMem         <= aux_LeMem;

process(iCLK, iRST)
	begin
		if rising_edge(iCLK) then
			if (iRST = '1') then
				pr_state <= ST_FETCH;
			else
				pr_state <= nx_state;
			end if;
		end if;
end process;

process(pr_state, opcode)
	begin
		aux_EscreveIR		<= '0';
		aux_EscrevePCCond <= '0';
		aux_EscrevePCBack <= '0';
      aux_EscrevePC  	<= '0';
      aux_OrigPC 	   	<= '0';
		
		aux_OrigAULA   	<= "00";
      aux_OrigBULA   	<= "00";
      aux_ALUOp      	<= "00";
		
      aux_EscreveReg 	<= '0';
		aux_Mem2Reg 		<= "00";
		
      aux_EscreveMem 	<= '0';
		aux_LeMem 	   	<= '0';
		
		nx_state <= ST_FETCH; -- Buscando a próxima instrução
		
		case pr_state is
			when ST_FETCH 		=>
				aux_EscreveIR		<= '1';
				aux_EscrevePC  	<= '1';
				aux_OrigPC 	   	<= '0';
				
				aux_OrigAULA   	<= "10";
				aux_OrigBULA   	<= "01";
				aux_ALUOp      	<= "00";
				
				nx_state <= ST_DECODE;
				
			when ST_DECODE 	=>
				aux_OrigAULA   	<= "00";
				aux_OrigBULA   	<= "10";
				aux_ALUOp      	<= "00";
				
				case opcode is 
					-- sw
					when "0100011" => 
						nx_state <= ST_SW;
					
					-- lw
					when "0000011" => 
						nx_state <= ST_LW1;
					
					-- Tipo-R
					when "0110011" => 
						nx_state <= ST_TipoR;
					
					-- beq
					when "1100011" => 
						nx_state <= ST_BEQ;
					
					-- jal
					when "1101111" => 
						nx_state <= ST_JAL;
					
					-- jalr
					when "1100111" => 
						nx_state <= ST_JALR;
					
					-- addi
					when "0010011" => 
						nx_state <= ST_ADDI;
						
					when others    => 
						nx_state <= ST_FETCH;	
				end case;
						
				when ST_SW =>
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "10";
					aux_ALUOp       <= "00";
					
					aux_EscreveMem  <= '1';

					nx_state <= ST_FETCH;
					
				when ST_LW1 =>
					
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "10";
					aux_ALUOp       <= "00";
			 
					nx_state <= ST_LW2;
					
				when ST_LW2 =>
					aux_EscreveReg  <= '1';
					aux_Mem2Reg 	 <= "10";  
					aux_LeMem       <= '1';

					nx_state <= ST_FETCH;
					
				when ST_TipoR =>
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "00";
					aux_ALUOp       <= "10";
					
					aux_EscreveReg  <= '1';
					aux_Mem2Reg     <= "00"; 
					
					aux_EscreveMem  <= '0';

					nx_state <= ST_WRITEBACK;
					
				when ST_BEQ =>
					aux_EscrevePCCond <= '1';
					aux_OrigPC      <= '0'; 
						
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "00";
					aux_ALUOp       <= "01";
						
					nx_state <= ST_FETCH;
					
				when ST_JAL =>
					aux_EscrevePC   <= '1';
					aux_OrigPC      <= '1';  
					aux_EscreveReg  <= '1';
					aux_Mem2Reg   	 <= "01"; 
     
					nx_state <= ST_FETCH;
					
				when ST_JALR =>
					aux_EscrevePC   <= '1';
					aux_OrigPC      <= '1';  
					
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "10";
					aux_ALUOp       <= "00";
					
					aux_EscreveReg  <= '1';
					aux_Mem2Reg   	 <= "01"; 

					nx_state <= ST_FETCH;
					
				when ST_ADDI =>
					aux_OrigAULA    <= "01";
					aux_OrigBULA    <= "10";
					aux_ALUOp       <= "00";
						
					aux_EscreveReg  <= '1';
					aux_Mem2Reg   	 <= "00";
						
					aux_EscreveMem  <= '0';

					nx_state <= ST_WRITEBACK;
						
				when ST_WRITEBACK =>
					aux_Mem2Reg   	 <= "00"; 
					aux_EscreveMem  <= '1';

					nx_state <= ST_FETCH;
					
	end case;

end process;
end architecture;