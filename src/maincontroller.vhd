----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mehmet Akarli
-- 
-- Create Date: 07/25/2025 02:43:59 PM
-- Design Name: Single Cycle RISC-V 32-BIT Processor
-- Module Name: maincontroller - Behavioral
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

entity maincontroller is
    Port ( Op           : in STD_LOGIC_VECTOR (6 downto 0);
           is_op_imm    : out STD_LOGIC;
           Regwrite     : out STD_LOGIC;
           ResultSrc    : out STD_LOGIC_VECTOR (1 downto 0);
           ImmSrc       : out STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc       : out STD_LOGIC;
           ALUOp        : out STD_LOGIC_VECTOR (1 downto 0);
           Memwrite     : out STD_LOGIC
         );
end maincontroller;

architecture Behavioral of maincontroller is
signal select_control : STD_LOGIC_VECTOR(9 downto 0);

begin
    process(Op) begin
        case Op is 
            when "0110011" =>                           
                select_control <= "1000000010";       -- R-Type (X bits are don't-cares, set to '0' for synthesis)
            when "0010011" =>                           
                select_control <= "1000100010";       -- I-Type
            when "0000011" =>                           
                select_control <= "1000100100";       -- LW
            when "0100011" =>                           
                select_control <= "0001110000";       -- SW (X bits are don't-cares, set to '0' for synthesis)
            when "1100011" =>                           
                select_control <= "0010000001";       -- B-Type (X bits are don't-cares, set to '0' for synthesis)
            when "1101111" =>                           
                select_control <= "1100001000";       -- JAL (X bits are don't-cares, set to '0' for synthesis)
            when "1100111" =>                           
                select_control <= "1000101010";       -- JALR
            when others =>
                select_control <= (others => '0');
        end case; 
    end process;
    
    -- Boolean that tells ALU controller it's Op-Imm
    is_op_imm <= '1' when Op = "0010011" else '0';
    
    Regwrite    <= select_control(9);
    ImmSrc      <= select_control(8 downto 6);
    ALUSrc      <= select_control(5);
    Memwrite    <= select_control(4);
    ResultSrc   <= select_control(3 downto 2);
    ALUOp       <= select_control(1 downto 0);
     
end Behavioral;
