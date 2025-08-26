----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2025 07:20:09 PM
-- Design Name: 
-- Module Name: mux_writeback - Behavioral
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

entity mux_writeback is
    Port ( s  : in STD_LOGIC_VECTOR (1 downto 0);             -- Select signal ResultSrc
           d0 : in STD_LOGIC_VECTOR (31 downto 0);            -- ALUResult
           d1 : in STD_LOGIC_VECTOR (31 downto 0);            -- ReadData
           d2 : in STD_LOGIC_VECTOR (31 downto 0);            -- PCPlus4
           y  : out STD_LOGIC_VECTOR (31 downto 0));          -- Result
end mux_writeback;

architecture Behavioral of mux_writeback is
begin

    process(d0,d1,d2,s) begin
        if    (s = "00") then y <= d0;
        elsif (s = "01") then y <= d1;
        elsif (s = "10") then y <= d2;
        end if;
    end process;
    
end Behavioral;
