
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity adder_pcplus4 is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);      -- PC
           b : in STD_LOGIC_VECTOR (31 downto 0);      -- Constant 4 (Must be port mapped in parent module datapath)
           y : out STD_LOGIC_VECTOR (31 downto 0));    -- Result: PC + 4 (PCPlus4 signal)
end adder_pcplus4;

architecture Behavioral of adder_pcplus4 is
begin

    process(a,b)
    begin
        y <= std_logic_vector(unsigned(a) + unsigned(b));
    end process;
  
end Behavioral;
