----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/16/2025 01:58:40 PM
-- Design Name: 
-- Module Name: riscvmodule - Behavioral
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

entity riscvmodule is
    Port ( clk       : in STD_LOGIC;
           reset     : in STD_LOGIC;
           Instr     : in STD_LOGIC_VECTOR (31 downto 0);           -- Instruction output from Instruction memory (imem)
           ReadData  : in STD_LOGIC_VECTOR (31 downto 0);           -- Output from data memory (dmem)
           RegWrite  : out STD_LOGIC;                               -- Register write signal from maincontroller
           PC        : out STD_LOGIC_VECTOR (31 downto 0);          -- input to instruction memory (output from datapath)
           WriteMem  : out STD_LOGIC_VECTOR (31 downto 0);          -- rs2 value from register file sent to Data Memory
           Memwrite  : out STD_LOGIC;                               -- write enable to data memory
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0)           -- Result from ALU (output from datapath)
         );
end riscvmodule;

architecture Behavioral of riscvmodule is
-- Signal is used to make connection between component
    signal RegWrite_internal, ALUSrc_internal, Zero_internal       : STD_LOGIC;
    signal PCSrc_internal, ResultSrc_internal                      : STD_LOGIC_VECTOR(1 downto 0); 
    signal ImmSrc_internal                                         : STD_LOGIC_VECTOR(2 downto 0);
    signal ALUControl_internal                                     : STD_LOGIC_VECTOR(3 downto 0);
    signal ALUResult_internal                                      : STD_LOGIC_VECTOR(31 downto 0);
--     
    signal Op_internal                                             : STD_LOGIC_VECTOR(6 downto 0);
    signal funct3_internal                                         : STD_LOGIC_VECTOR(2 downto 0);
    signal funct7b5_internal                                       : STD_LOGIC;
    
-- Component instantiation Headcontroller
component Headcontroller port
    (Op            : in STD_LOGIC_VECTOR (6 downto 0);
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
end component;

-- Component instantiation datapath
component datapath port
    (clk        : in STD_LOGIC;
     rst        : in STD_LOGIC;
     PCSrc      : in STD_LOGIC_VECTOR(1 downto 0);
     Regwrite   : in STD_LOGIC;
     ResultSrc  : in STD_LOGIC_VECTOR(1 downto 0);
     immSrc     : in STD_LOGIC_VECTOR(2 downto 0);
     ALUSrc     : in STD_LOGIC;
     ALUControl : in STD_LOGIC_VECTOR(3 downto 0);
     instr      : in STD_LOGIC_VECTOR(31 downto 0);
     ReadData   : in STD_LOGIC_VECTOR(31 downto 0);
     ALUResult  : out STD_LOGIC_VECTOR(31 downto 0);
     Zero       : out STD_LOGIC;
     PC         : out STD_LOGIC_VECTOR(31 downto 0);
     WriteMem   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

begin
    -- Assigning signals to instruction bit for achieving Opcode, funct3 and 5th bit of funct7
    Op_internal <= Instr(6 downto 0);
    funct3_internal <= Instr(14 downto 12);
    funct7b5_internal <= Instr(30);
    
    -- Assigning RegWrite and ALUResult signals to entity outputs --
    RegWrite <= RegWrite_internal;
    ALUResult <= ALUResult_internal;

-- Mapping Headcontroller
    Headcontroller_map : Headcontroller port map(Op_internal, funct3_internal, funct7b5_internal, Zero_internal, ALUResult_internal, ALUControl_internal, RegWrite_internal, ResultSrc_internal, ImmSrc_internal, ALUSrc_internal, Memwrite, PCSrc_internal);

-- Mapping maincontroller
    datapath_map : datapath port map(clk, reset, PCSrc_internal, RegWrite_internal, ResultSrc_internal, ImmSrc_internal, ALUSrc_internal, ALUControl_internal, Instr, ReadData, ALUResult_internal, Zero_internal, PC, WriteMem);           

end Behavioral;
