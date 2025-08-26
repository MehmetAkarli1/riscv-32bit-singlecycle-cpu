----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/20/2025 10:34:49 AM
-- Design Name: 
-- Module Name: tb_riscv - Behavioral
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
use ieee.NUMERIC_STD.ALL;

entity tb_riscv is
end tb_riscv;

architecture Behavioral of tb_riscv is
    -- Adding topmoduleriscv component to use its output in the testbench --
    component topmoduleriscv port
        (clk              : in STD_LOGIC;
         reset            : in STD_LOGIC;
         PC               : out STD_LOGIC_VECTOR (31 downto 0);  -- input to instruction memory (output from datapath)        
         Instr            : out STD_LOGIC_VECTOR (31 downto 0);  -- Instruction output from Instruction memory (imem)         
         WriteMem         : out STD_LOGIC_VECTOR (31 downto 0);  -- Writedata value to data memory from register file 
         RegWrite         : out STD_LOGIC;                       -- Register write signal from maincontroller
         ALUResult        : out STD_LOGIC_VECTOR (31 downto 0);  -- Result from ALU (output from datapath) 
         ReadData         : out STD_LOGIC_VECTOR (31 downto 0);  -- Output from data memory (dmem) 
         MemWrite         : out STD_LOGIC                        -- write enable to data memory  
        );
    end component;
    -- Signals for testing purporse -- 
    signal clk_tb, reset_tb, RegWrite_tb, MemWrite_tb               : STD_LOGIC;
    signal PC_tb, Instr_tb, WriteMem_tb, ALUResult_tb, ReadData_tb : STD_LOGIC_VECTOR (31 downto 0);
    
begin
    -- port mapping component with signals, that will be used for testing --
    topmoduleriscv_map : topmoduleriscv port map(clk_tb, reset_tb, PC_tb, Instr_tb, WriteMem_tb, RegWrite_tb, ALUResult_tb, ReadData_tb, MemWrite_tb);
 
    -- Generating clock
    process begin
        clk_tb <= '1';
        wait for 10 ns;
        clk_tb <= '0';
        wait for 10 ns; 
    end process;
    
    -- Generating reset first 4 cycles
    process begin
        reset_tb <= '1';
        wait for 40 ns;
        reset_tb <= '0';
        wait;
    end process;
    
    -- checking if 25 is written at address 100 in memory
    process(clk_tb) begin
        if falling_edge(clk_tb) then
            if MemWrite_tb = '1' then
            if (to_integer(unsigned(ALUResult_tb)) = 100) and (to_integer(unsigned(WriteMem_tb)) = 25) then
                report "NO ERRORS: Simulation succeded" severity note;
            elsif (to_integer(unsigned(ALUResult_tb)) /= 96) then
                report "Simulation failed" severity note;
        end if;
       end if;
      end if; 
    end process;           
               
end Behavioral;
