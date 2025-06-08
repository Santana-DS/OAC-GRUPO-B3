library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;	
use work.riscv_pkg.all;

entity ULAControle is
    port 
	 (
			ALUop: 			in std_logic_vector(1 downto 0);
			funct3: 			in std_logic_vector(2 downto 0);
			funct7: 			in std_logic;											-- Pegando só o necessário
			controleULA: 	out std_logic_vector(4 downto 0)
	);
end ULAControle;

architecture arc of ULAControle is
begin
		
	process (ALUop, funct3, funct7)
	begin
	case ALUop is
		when "00" => 																	-- lw e sw (fazem add)
			controleULA <= "00010";
				
		when "01" => 																	-- beq
			controleULA <= "00110";
				
		when "10" => 																	-- instruções do tipo-R (add, sub, and, or, slt)
			case funct3 is
				when "000" => 
					if funct7 = '0' then 
						controleULA <= "00010"; 										-- add
					else 
						controleULA <= "00110"; 										-- sub
					end if;
 						
				when "111" => 															-- and
					controleULA <= "00000";
					
				when "110" => 
					controleULA <= "00001"; 											-- or
						
				when "010" =>
					controleULA <= "00111"; 											-- slt
					
				when others =>
					null; 								
				end case;
						
			when "11" =>					
				controleULA <= "00010";												-- addi e jalr (os dois fazem add). Note que o jal não passa pela ULA
				
			when others =>
				null;
							
	end case;
	end process;
end arc;
	