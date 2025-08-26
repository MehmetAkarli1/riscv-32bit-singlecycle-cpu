----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2025 02:41:02 PM
-- Design Name: 
-- Module Name: mux_alu - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_alu is
    generic(width : integer := 32);
    Port ( d0 : in STD_LOGIC_VECTOR (width-1 downto 0);      -- rd2
           d1 : in STD_LOGIC_VECTOR (width-1 downto 0);      -- immext
           s  : in STD_LOGIC;                                -- ALUSrc
           y  : out STD_LOGIC_VECTOR (width-1 downto 0)      -- srcB
         );
end mux_alu;

architecture Behavioral of mux_alu is
begin
    process(d0,d1,s)
    begin 
        if s = '0' then 
        y <= d0;
        else
        y <= d1;
        end if; 
    end process;
end Behavioral;
