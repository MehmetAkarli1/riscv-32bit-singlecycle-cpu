----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2025 06:50:44 PM
-- Design Name: 
-- Module Name: mux_pcnext - Behavioral
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

entity mux_pcnext is
    Port ( s       : in STD_LOGIC_VECTOR (1 downto 0);         -- Select signal PCSrc
           d0      : in STD_LOGIC_VECTOR (31 downto 0);        -- PCplus4
           d1      : in STD_LOGIC_VECTOR (31 downto 0);        -- PCTarget
           d2      : in STD_LOGIC_VECTOR (31 downto 0);        -- ALUResult
           y       : out STD_LOGIC_VECTOR (31 downto 0));      -- PCnext signal
end mux_pcnext;

architecture Behavioral of mux_pcnext is
begin

    process(d0,d1,d2,s) begin
        if    (s = "00") then y <= d0;
        elsif (s = "01") then y <= d1;
        elsif (s = "10") then y <= d2;
        end if;
    end process;
    
end Behavioral;
