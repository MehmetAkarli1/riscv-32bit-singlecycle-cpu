----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2025 11:34:59 AM
-- Design Name: 
-- Module Name: pcgen - rtl
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

entity pcgen is 
    generic(width: integer := 32);
    Port(clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           d   : in STD_LOGIC_VECTOR (width-1 downto 0); -- input from mux_pnnext (PCnext)
           q   : out STD_LOGIC_VECTOR (width-1 downto 0) -- PC value
          );
end pcgen;

architecture rtl of pcgen is
begin
    process(clk,rst) begin
    if rst = '1' then q <= (others => '0');
    elsif rising_edge(clk) then q <= d;
    end if;
    end process;
end;