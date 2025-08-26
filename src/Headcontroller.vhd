----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2025 10:43:11 AM
-- Design Name: 
-- Module Name: Headcontroller - Behavioral
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

entity Headcontroller is
    port( Op            : in STD_LOGIC_VECTOR (6 downto 0);
          funct3        : in STD_LOGIC_VECTOR (2 downto 0);
          funct7b5      : in STD_LOGIC;
          Zero          : in STD_LOGIC;
          ALUResult     : in STD_LOGIC_VECTOR(31 downto 0);
          ALUControl    : out STD_LOGIC_VECTOR(3 downto 0);
          RegWrite      : out STD_LOGIC;
          ResultSrc     : out STD_LOGIC_VECTOR (1 downto 0);
          ImmSrc        : out STD_LOGIC_VECTOR (2 downto 0);
          ALUSrc        : out STD_LOGIC;
          MemWrite      : out STD_LOGIC;
          PCSrc         : out STD_LOGIC_VECTOR (1 downto 0)
          );
end Headcontroller;

architecture Behavioral of Headcontroller is
    signal ALUOp       : STD_LOGIC_VECTOR (1 downto 0);            -- Declaring ALUop as signal, as its send from one component to another
    signal is_op_imm_s : STD_LOGIC;                                -- Internal signal to propagate is_op_imm from main to- alucontroller
    
    component maincontroller port
        (Op           : in STD_LOGIC_VECTOR (6 downto 0);
         is_op_imm    : out STD_LOGIC;
         Regwrite     : out STD_LOGIC;
         ResultSrc    : out STD_LOGIC_VECTOR (1 downto 0);
         ImmSrc       : out STD_LOGIC_VECTOR (2 downto 0);
         ALUSrc       : out STD_LOGIC;
         ALUOp        : out STD_LOGIC_VECTOR (1 downto 0);
         Memwrite     : out STD_LOGIC
         );
    end component;     
    
    component alucontroller port
        (funct3       : in STD_LOGIC_VECTOR (2 downto 0);
         funct7b5     : in STD_LOGIC;
         opb5         : in STD_LOGIC;
         is_op_imm    : in STD_LOGIC;
         ALUop        : in STD_LOGIC_VECTOR (1 downto 0);
         ALUControl   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
            
begin
    -- Mapping component's and entity
    
    -- Mapping maincontroller
    maincontroller_map : maincontroller port map(Op, is_op_imm_s, RegWrite, ResultSrc, ImmSrc, ALUSrc, ALUOp, MemWrite);
    
    -- Mapping alucontroller
    alucontroller_map : alucontroller port map(funct3, funct7b5, Op(5), is_op_imm_s, ALUOp, ALUControl);    
    
    -- PCSrc logic
process(Op, funct3, Zero, ALUResult) begin    
    if Op = "1100011" then -- B type
        if (funct3 = "000" and Zero = '1') or               -- beq
           (funct3 = "001" and Zero = '0') or               -- bne
           (funct3 = "100" and ALUResult(0) = '1') or       -- blt
           (funct3 = "101" and ALUResult(0) = '1') or       -- bge
           (funct3 = "110" and ALUResult(0) = '1') or       -- bltu
           (funct3 = "111" and ALUResult(0) = '1')          -- bgeu
           then 
            PCSrc <= "01";
        else
            PCSrc <= "00"; -- Dont branch
        end if;
    elsif Op = "1101111" then -- jal
        PCSrc <= "01";
    elsif Op = "1100111" then -- jalr
        PCSrc <= "10";
    else
        PCSrc <= "00"; -- Default: next = PC + 4
    end if;    
end process;

end Behavioral;
