----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/25/2025 10:25:49 AM
-- Design Name: 
-- Module Name: alucontroller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alucontroller is
    Port ( funct3       : in STD_LOGIC_VECTOR (2 downto 0);
           funct7b5     : in STD_LOGIC;
           opb5         : in STD_LOGIC;
           is_op_imm    : in STD_LOGIC;
           ALUop        : in STD_LOGIC_VECTOR (1 downto 0);
           ALUControl   : out STD_LOGIC_VECTOR(3 downto 0)
         );
end alucontroller;

architecture Behavioral of alucontroller is

begin
     process(funct3, funct7b5, opb5, is_op_imm, ALUop) begin
        case ALUop is
            when "00" =>
                ALUControl <= "0000";
            when "01" =>   
                if funct3 = "000" or funct3 = "001" then            -- beq, bne
                    ALUControl <= "0001";
                elsif funct3 = "100" then                           -- blt
                    ALUControl <= "0010";
                elsif funct3 = "101" then                           -- bge
                    ALUControl <= "0011";
                elsif funct3 = "110" then                           -- bltu
                    ALUControl <= "0100";     
                elsif funct3 = "111" then                           -- bgeu
                    ALUControl <= "0101";
                else
                    ALUControl <= "0000";                           -- Default/fallback    
                end if;
                
            when "10" =>
                if funct3 = "000" and is_op_imm = '1' then          -- addi
                    ALUControl <= "0000";
                elsif funct3 = "000" and funct7b5 = '1' then        -- sub
                    ALUControl <= "0001";
                elsif funct3 = "000" and funct7b5 = '0' then
                    ALUControl <= "0000";                           -- add
                elsif funct3 = "001" then                           -- sll, slli
                    ALUControl <= "0110";
                elsif funct3 = "010" then                           -- slt, slti
                    ALUControl <= "0010";
                elsif funct3 = "011" then                           -- sltu, sltiu    
                    ALUControl <= "0100";
                elsif funct3 = "100" then                           -- xor, xori
                    ALUControl <= "0111";        
                elsif funct3 = "101" and funct7b5 = '0' then        -- srl, srli
                    ALUControl <= "1000";
                elsif funct3 = "101" and funct7b5 = '1' then        -- sra, srai
                    ALUControl <= "1001";
                elsif funct3 = "110" then                           -- or, ori
                    ALUControl <= "1010";
                elsif funct3 = "111" then                           -- and, andi
                    ALUControl <= "1011";
                else
                    ALUControl <= "0000";
                end if;
                
            when "11" =>
                    ALUControl <= "0000";
            when others =>
                    ALUControl <= "0000";                    
        end case;
    end process;
    
end Behavioral;

