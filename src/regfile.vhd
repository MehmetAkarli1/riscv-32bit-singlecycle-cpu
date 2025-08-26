----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2025 04:48:08 PM
-- Design Name: 
-- Module Name: regfile - Behavioral
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

entity regfile is
    Port ( regwrite : in STD_LOGIC;                         -- write enable signal
           clk      : in STD_LOGIC;                              
           a1       : in STD_LOGIC_VECTOR (4 downto 0);           -- instruction bit(19:15) / rs1
           a2       : in STD_LOGIC_VECTOR (4 downto 0);           -- instruction bit(24:20) / rs2
           a3       : in STD_LOGIC_VECTOR (4 downto 0);           -- instruction bit(11:7) / rd
           wd       : in STD_LOGIC_VECTOR (31 downto 0);          -- Result signal selected at mux_writeback
           rd1      : out STD_LOGIC_VECTOR (31 downto 0);         -- output rd1 from regfile
           rd2      : out STD_LOGIC_VECTOR (31 downto 0));        -- output rd2 from regfile
end regfile;

architecture Behavioral of regfile is
    type reg_type is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0); -- Creates 32 register. All registers support 32 bit
    signal regf: reg_type := (others => (others => '0'));             -- All register are initialized to 0
begin                                                                 -- The outer (others => ..) applies to all 32 registers  
                                                                      -- The inner (others => '0') applies to all 32 bits inside each register          
    process(clk) begin
        if rising_edge(clk) then
            if (regwrite = '1') and a3 /= "00000" then -- x0 is always zero
            regf(to_integer(unsigned(a3))) <= wd;
            end if;
        end if;
     end process;
     
rd1 <= regf(to_integer(unsigned(a1)));   
rd2 <= regf(to_integer(unsigned(a2)));

end Behavioral;
