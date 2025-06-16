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
		LeMem 		  : out std_logic;
	);
end Controlador;

architecture bdf_type of controlador is

-- Estados FSM (Máquina de Estados Finitas)
type state_type is (
	ST_FETCH; 	  -- Busca a instrução
	ST_DECODE; 	  -- Decodifica
	ST_EXECUTE;	  -- Execução (cálculo na ULA)
	ST_MEMORY; 	  -- Acesso a memória
	ST_WRITEBACK; -- Escrita no banco de registradores
);
signal pr_state, nx_state: state_type; -- Estado presente e Proximo estado

signal EscreveIR     : out std_logic;
signal EscrevePCCond : out std_logic;
signal EscrevePCBack : out std_logic;
signal EscrevePC	   : out std_logic;
signal OrigPC		   : out std_logic;

signal OrigAULA	   : out std_logic_vector(1 downto 0);
signal OrigBULA 	   : out std_logic_vector(1 downto 0);
signal ALUOp			: out std_logic_vector(1 downto 0);

signal EscreveReg	   : out std_logic;
signal Mem2Reg		   : out std_logic_vector(1 downto 0);

signal EscreveMem	   : out std_logic;
signal LeMem 		   : out std_logic;

begin

	EscreveIR     <= aux_EscreveIR;S
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
		if (iRST = '1')
			pr_state <= ST_FETCH;
		else
			pr_state <= nx_state;
	end if;
end process;

process(pr_state, opcode)
	begin
		nx_state <= ST_FETCH; -- Buscando a próxima instrução
		
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
		
		case pr_state is
			when ST_FETCH 		=>
				
				
			when ST_DECODE 	=>
			
			when ST_EXECUTE	=>
			
			when ST_MEMORY 	=>
			
			when ST_WRITEBACK =>

end bdf_type;