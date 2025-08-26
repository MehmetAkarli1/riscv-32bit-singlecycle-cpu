----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2025 03:44:08 PM
-- Design Name: 
-- Module Name: topmoduleriscv - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topmoduleriscv is
    Port ( clk              : in STD_LOGIC;
           reset            : in STD_LOGIC;
           PC               : out STD_LOGIC_VECTOR (31 downto 0);  -- input to instruction memory (output from datapath)        
           Instr            : out STD_LOGIC_VECTOR (31 downto 0);  -- Instruction output from Instruction memory (imem)         
           WriteMem         : out STD_LOGIC_VECTOR (31 downto 0);  -- Writedata value to data memory from register file 
           RegWrite         : out STD_LOGIC;                       -- Register write signal from maincontroller
           ALUResult        : out STD_LOGIC_VECTOR (31 downto 0);  -- Result from ALU (output from datapath) 
           ReadData         : out STD_LOGIC_VECTOR (31 downto 0);  -- Output from data memory (dmem) 
           MemWrite         : out STD_LOGIC                        -- write enable to data memory  
           );                      
end topmoduleriscv;

architecture Behavioral of topmoduleriscv is
-- Component declaration -- 
component riscvmodule port
    (clk       : in STD_LOGIC;                                      
     reset     : in STD_LOGIC;  
     Instr     : in STD_LOGIC_VECTOR (31 downto 0);                 -- Instruction output from Instruction memory (imem)
     ReadData  : in STD_LOGIC_VECTOR (31 downto 0);                 -- Output from data memory (dmem)
     RegWrite  : out STD_LOGIC;                                     -- Register write signal from maincontroller
     PC        : out STD_LOGIC_VECTOR (31 downto 0);                -- input to instruction memory (output from datapath)
     WriteMem  : out STD_LOGIC_VECTOR (31 downto 0);                -- Writedata value to data memory from register file
     Memwrite  : out STD_LOGIC;                                     -- write enable to data memory    
     ALUResult : out STD_LOGIC_VECTOR (31 downto 0)                 -- Result from ALU (output from datapath)
    );
end component;

component imem port
    (a  : in STD_LOGIC_VECTOR (31 downto 0);                        -- PC 
     rd : out STD_LOGIC_VECTOR (31 downto 0)                        -- Instr
    );
end component;

component dmem port
    (clk        : in STD_LOGIC;                  
     memwrite   : in STD_LOGIC;                                     -- Signal enabling write to Data memory
     a          : in STD_LOGIC_VECTOR (31 downto 0);                -- ALUResult input to Data Memory
     wd         : in STD_LOGIC_VECTOR (31 downto 0);                -- WriteData input to Data Memory from Register file
     rd         : out STD_LOGIC_VECTOR (31 downto 0)                -- ReadData output from Data Memory
    );
 end component;
 -- Intermediate signals between components riscvmodule, imem and dmem
 signal MemWrite_internal                                         : STD_LOGIC;
 signal Instr_internal, PC_internal                               : STD_LOGIC_VECTOR (31 downto 0);     
 signal ReadData_internal, WriteMem_internal, ALUResult_internal  : STD_LOGIC_VECTOR (31 downto 0);     
    
begin

    Memwrite  <= MemWrite_internal;
    Instr     <= Instr_internal;
    PC        <= PC_internal;
    ReadData  <= ReadData_internal;
    WriteMem  <= WriteMem_internal;
    ALUResult <= ALUResult_internal;


    -- Mapping component riscvmodule
    riscvmodule_map : riscvmodule port map(clk, reset, Instr_internal, ReadData_internal, RegWrite, PC_internal, WriteMem_internal, MemWrite_internal, ALUResult_internal);
    
    -- Mapping component imem
    imem_map : imem port map(PC_internal, Instr_internal);
    
    -- Mapping component dmem
    dmem_map : dmem port map(clk, MemWrite_internal, ALUResult_internal, WriteMem_internal, ReadData_internal);         

end Behavioral;
