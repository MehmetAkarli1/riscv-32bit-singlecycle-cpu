----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2025 07:32:35 PM
-- Design Name: 
-- Module Name: imem - Behavioral
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
use STD.TEXTIO.all;
--use IEEE.NUMERIC_STD_UNSIGNED.all; Not part of the standard IEEE library in Vivado
use ieee.NUMERIC_STD.ALL;
use ieee.std_logic_textio.all;

entity imem is
    Port ( a  : in STD_LOGIC_VECTOR (31 downto 0);    -- PC
           rd : out STD_LOGIC_VECTOR (31 downto 0));  -- instr
end imem;

architecture Behavioral of imem is
type ramtype is array(127 downto 0) of 
        std_logic_vector(31 downto 0);
        
        -- Read file that contains instruction in hex format
        impure function init_ram_hex return ramtype is
        file text_file : text open read_mode is "riscvtest1.txt";
            variable text_line   : line;
            variable ram_content : ramtype;
            variable i           : integer := 0; 
        begin
        -- sets all memory content to zero
            for i in 0 to 127 loop
                ram_content(i) := (others => '0');
            end loop;
        -- Loading instruction line-by-line into memory from file
        while not endfile(text_file) loop
            readline(text_file, text_line);      -- Read one line
            hread(text_line, ram_content(i));    -- Convert line in files from hex to 32-bit vector 
            i := i + 1;
        end loop;
return ram_content;
end function;
-- Creates signal mem that stores the instruction i text file
signal mem : ramtype := init_ram_hex; -- init_ram_hex: 1. Reads the file riscvtest.txt, 
                                      -- 2. Loads each line into a memory location, 
                                      -- 3. returns a full 128-entry memory array
        begin
        -- Reading from signal mem
        process(a) begin
        rd <= mem(to_integer(unsigned(a(31 downto 2))));
        end process;
        
end Behavioral;



