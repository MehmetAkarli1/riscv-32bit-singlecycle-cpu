----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/22/2025 11:41:07 AM
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port ( srcA         : in STD_LOGIC_VECTOR (31 downto 0);       -- Output from regfile
           srcB         : in STD_LOGIC_VECTOR (31 downto 0);       -- Output from mux_alu
           aluControl   : in STD_LOGIC_VECTOR (3 downto 0);        -- ALUControl signal to choose arithmetic operation   
           aluResult    : out STD_LOGIC_VECTOR (31 downto 0);      -- Result from ALU
           zero         : out STD_LOGIC                            -- Zero output only used for beq/bne via subtraction
           );
end alu;

architecture Behavioral of alu is
begin
    process(srcA, srcB, aluControl) begin
                zero <= '0';  -- default value of zero
    case aluControl is
        when "0000" =>
                aluResult <= std_logic_vector(unsigned(srcA) + unsigned(srcB));  -- lw, sw, add, addi
        when "0001" =>
                aluResult <= std_logic_vector(unsigned(srcA) - unsigned(srcB));  -- beq, bne, sub
            if srcA = srcB then
                zero <= '1';                                                     -- for beq 
            else
                zero <= '0';                                                     -- for bne
            end if;
        when "0010" =>                                                           -- blt, slt, slti
            if signed(srcA) < signed(srcB) then
                aluResult <= (31 downto 1 => '0') & '1';                    
            else
                aluResult <= (others => '0');           
            end if;
        when "0011" =>                                                            -- bge
            if signed(srcA) >= signed(srcB) then
                 aluResult <= (31 downto 1 => '0') & '1';                    
            else
                 aluResult <= (others => '0');           
            end if;
        when "0100" =>                                                            -- bltu, sltu, sltiu
            if unsigned(srcA) < unsigned(srcB) then
                 aluResult <= (31 downto 1 => '0') & '1';                    
            else
                 aluResult <= (others => '0');           
            end if;
        when "0101" =>                                                            -- bgeu             
            if unsigned(srcA) >= unsigned(srcB) then
                  aluResult <= (31 downto 1 => '0') & '1';                    
            else
                  aluResult <= (others => '0');           
            end if;    
        when "0110" =>                                                            -- sll, slli  
                  aluResult <= std_logic_vector(shift_left(unsigned(srcA), to_integer(unsigned(srcB(4 downto 0)))));     
        when "0111" =>                                                            -- XOR, XORI
                  aluResult <= srcA xor srcB;
        when "1000" =>                                                            -- srl, srli
                  aluResult <= std_logic_vector(shift_right(unsigned(srcA), to_integer(unsigned(srcB(4 downto 0)))));   
        when "1001" =>                                                            -- sra, srai
                  aluResult <= std_logic_vector(shift_right(signed(srcA), to_integer(unsigned(srcB(4 downto 0)))));         
        when "1010" =>
                  aluResult <= srcA or srcB;
        when "1011" =>
                  aluResult <= srcA and srcB;
        when others =>
                  aluResult <= (others => '0');
    end case;
  end process;                         
end Behavioral;
