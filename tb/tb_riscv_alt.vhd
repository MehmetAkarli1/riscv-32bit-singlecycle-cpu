----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/25/2025 05:06:03 PM
-- Design Name: 
-- Module Name: tb_riscv_alt - Behavioral
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
-- This testbench is developed to verify memory consistency by ensuring that during a load (MemWrite_tb = '0'), 
-- if the load address (ALUResult_tb) matches the most recent store address (last_store_addr), the read data (ReadData_tb) 
-- equals the data previously written (last_store_data, which came from WriteMem_tb during that store).
-- This confirms the CPU correctly stores data to memory and retrieves the same value when reading from the identical address, 
-- handling potential async memory behavior where the read data is immediately available in the same cycle. 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.ALL;

entity tb_riscv_alt is
end tb_riscv_alt;

architecture Behavioral of tb_riscv_alt is
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
    
  -- Success when a later load returns the most recently stored value to the same address
    process(clk_tb)
      variable have_store       : boolean := false;
      variable last_store_addr  : std_logic_vector(31 downto 0);
      variable last_store_data  : std_logic_vector(31 downto 0);
      variable pend_check       : boolean := false;
      variable pend_addr        : std_logic_vector(31 downto 0);
    begin
      if falling_edge(clk_tb) then
        -- record any store
        if MemWrite_tb = '1' then
          last_store_addr := ALUResult_tb;   -- store address
          last_store_data := WriteMem_tb;    -- store data
          have_store      := true;
        end if;
    
        -- if we scheduled a sync read check last cycle, verify data now
        if pend_check then
          if have_store and (pend_addr = last_store_addr) and (ReadData_tb = last_store_data) then
            report "NO ERRORS: Simulation succeded" severity warning;
            std.env.stop;  -- end sim cleanly (VHDL-2008)
          end if;
          pend_check := false;
        end if;
    
        -- saw a read address this cycle (any non-store): handle both async & sync
        if MemWrite_tb = '0' and have_store and (ALUResult_tb = last_store_addr) then
          -- async path: data might already be valid this cycle
          if ReadData_tb = last_store_data then
            report "NO ERRORS: Simulation succeded" severity note;
            std.env.stop;
          else
            -- sync path: check next cycle
            pend_addr  := ALUResult_tb;
            pend_check := true;
          end if;
        end if;
      end if;
    end process;
      
end Behavioral;
