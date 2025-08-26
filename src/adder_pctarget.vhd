
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity adder_pctarget is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);      -- PC
           b : in STD_LOGIC_VECTOR (31 downto 0);      -- imm (sign-extended immediate) (Must be port mapped in parent module datapath)
           y : out STD_LOGIC_VECTOR (31 downto 0));    -- Result: PC + imm (PCTarget signal)
end adder_pctarget;

architecture Behavioral of adder_pctarget is
begin

    process(a,b)
    begin
        y <= std_logic_vector(unsigned(a) + unsigned(b));
    end process;
  
end Behavioral;
