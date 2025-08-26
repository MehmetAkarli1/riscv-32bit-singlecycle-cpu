
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extend is
    Port ( instr  : in STD_LOGIC_VECTOR (31 downto 0);                              -- Instruction from imem
           s      : in STD_LOGIC_VECTOR (2 downto 0);                               -- Select signal immSrc
           immext : out STD_LOGIC_VECTOR (31 downto 0));                            -- ImmExt 
end extend;

architecture Behavioral of extend is 
begin
    process(instr, s) begin
        case s is
            -- I-Type --
            when "000" =>
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 20);
            -- S-Type
            when "001" =>
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            -- B-Type --
            when "010" =>
                immext <= (31 downto 12 => instr(31)) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';     
            -- J-Type --    
            when "100" =>
                immext <= (31 downto 20 => instr(31)) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
            when others =>
                immext <= (31 downto 0 => '-');
         end case;
    end process;       
end Behavioral;
