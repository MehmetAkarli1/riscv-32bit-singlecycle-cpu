----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2025 01:55:31 PM
-- Design Name: 
-- Module Name: dmem - Behavioral
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
use IEEE.NUMERIC_STD.ALL; -- Needed for unsigned() and to_integer()

entity dmem is
    Port ( clk : in STD_LOGIC;                  
           memwrite : in STD_LOGIC;                                 -- Signal enabling write to Data memory
           a : in STD_LOGIC_VECTOR (31 downto 0);                   -- ALUResult input to Data Memory
           wd : in STD_LOGIC_VECTOR (31 downto 0);                  -- WriteData input to Data Memory
           rd : out STD_LOGIC_VECTOR (31 downto 0)                  -- ReadData output from Data Memory
         );
end dmem;

architecture Behavioral of dmem is
    type ramtype is array (0 to 127) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem: ramtype := (others => (others => '0')); -- Initializing memory
begin
    process(clk, a)
    begin
        if rising_edge(clk) then
            if (memwrite = '1') then
               mem(to_integer(unsigned(a(8 downto 2)))) <= wd;
            end if;
        end if;
    end process;
    
    rd <= mem(to_integer(unsigned(a(8 downto 2))));
          
end Behavioral;
