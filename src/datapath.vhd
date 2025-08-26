----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2025 01:10:01 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity datapath is
    Port ( clk        : in STD_LOGIC;
           rst        : in STD_LOGIC;
           PCSrc      : in STD_LOGIC_VECTOR(1 downto 0);
           Regwrite   : in STD_LOGIC;
           ResultSrc  : in STD_LOGIC_VECTOR(1 downto 0);
           immSrc     : in STD_LOGIC_VECTOR(2 downto 0);
           ALUSrc     : in STD_LOGIC;
           ALUControl : in STD_LOGIC_VECTOR(3 downto 0);
           instr      : in STD_LOGIC_VECTOR(31 downto 0);
           ReadData   : in STD_LOGIC_VECTOR(31 downto 0);
           ALUResult  : out STD_LOGIC_VECTOR(31 downto 0);
           Zero       : out STD_LOGIC;
           PC         : out STD_LOGIC_VECTOR(31 downto 0);
           WriteMem   : out STD_LOGIC_VECTOR(31 downto 0)
         );
end datapath;

architecture Behavioral of datapath is
    signal srcA, srcB, rd2_s              : STD_LOGIC_VECTOR(31 downto 0); -- From register file output
    signal immext, result                 : STD_LOGIC_VECTOR(31 downto 0); -- immext: output from extend & result: output from mux_writeback
    signal PCNext, PCPlus4, PCTarget      : STD_LOGIC_VECTOR(31 downto 0); -- Signals to handle next PC, PC + 4 and PC target = PC + imm 
    
    signal PC_s, ALUResult_s              : STD_LOGIC_VECTOR(31 downto 0); -- To drive output signals like PC, ALUResult and Writedata
    
    component pcgen generic(width: integer); 
    port (clk, rst: in STD_LOGIC;
          d : in STD_LOGIC_VECTOR(width-1 downto 0);          -- input from mux_pnnext (PCnext)
          q : out STD_LOGIC_VECTOR(width-1 downto 0)          -- PC value
         );
    end component;
    component adder_pcplus4 port 
         (a : in STD_LOGIC_VECTOR(31 downto 0);               -- PC
          b : in STD_LOGIC_VECTOR(31 downto 0);               -- Constant 4 (Must be port mapped in parent module datapath)
          y : out STD_LOGIC_VECTOR(31 downto 0)               -- Result: PC + 4 (PCPlus4 signal)
         );
    end component;
    component adder_pctarget port
         (a : in STD_LOGIC_VECTOR(31 downto 0);               -- PC 
          b : in STD_LOGIC_VECTOR(31 downto 0);               -- imm (sign-extended immediate) (Must be port mapped in parent module datapath)
          y : out STD_LOGIC_VECTOR(31 downto 0)               -- Result: PC + imm (PCTarget signal)
         );    
    end component;
    component alu port
         (srcA : in STD_LOGIC_VECTOR(31 downto 0);            -- Output from regfile
          srcB         : in std_logic_vector(31 downto 0);    -- Output from mux_alu 
          aluControl   : in STD_LOGIC_VECTOR(3 downto 0);     -- ALUControl signal to choose arithmetic operation   
          aluResult    : out STD_LOGIC_VECTOR(31 downto 0);   -- Result from ALU
          zero         : out STD_LOGIC                        -- Zero output only used for beq/bne via subtraction
         );
    end component;      
    component extend port
         (instr  : in STD_LOGIC_VECTOR(31 downto 0);          -- Instruction from imem
          s      : in STD_LOGIC_VECTOR(2 downto 0);           -- Select signal immSrc
          immext : out STD_LOGIC_VECTOR(31 downto 0)          -- ImmExt (immediate value processed in extend)
         );     
    end component;
    component mux_alu generic(width: integer); 
    port (d0 : in STD_LOGIC_VECTOR(width-1 downto 0);         -- rd2
          d1 : in STD_LOGIC_VECTOR(width-1 downto 0);         -- immext
          s  : in STD_LOGIC;                                   -- ALUSrc
          y  : out STD_LOGIC_VECTOR(width-1 downto 0)         -- srcB
         );
    end component;
    component mux_pcnext port
         (s  : in STD_LOGIC_VECTOR(1 downto 0);                -- Select signal PCSrc
          d0 : in STD_LOGIC_VECTOR(31 downto 0);               -- PCplus4
          d1 : in STD_LOGIC_VECTOR(31 downto 0);               -- PCTarget
          d2 : in STD_LOGIC_VECTOR(31 downto 0);               -- ALUResult
          y  : out STD_LOGIC_VECTOR(31 downto 0)               -- PCnext signal  
         );             
    end component;
    component mux_writeback port
         (s  : in STD_LOGIC_VECTOR(1 downto 0);                -- Select signal ResultSrc
          d0 : in STD_LOGIC_VECTOR(31 downto 0);               -- ALUResult
          d1 : in STD_LOGIC_VECTOR(31 downto 0);               -- ReadData
          d2 : in STD_LOGIC_VECTOR(31 downto 0);               -- PCPlus4
          y  : out STD_LOGIC_VECTOR(31 downto 0)               -- Result     
         );                
    end component;
    component regfile port
        (regwrite : in STD_LOGIC;                               -- write enable signal
         clk : in STD_LOGIC;                                    -- clock
         a1 : in STD_LOGIC_VECTOR(4 downto 0);                 -- instruction bit(19:15)
         a2 : in STD_LOGIC_VECTOR(4 downto 0);                 -- instruction bit(24:20)
         a3 : in STD_LOGIC_VECTOR(4 downto 0);                 -- instruction bit(11:7)
         wd : in STD_LOGIC_VECTOR(31 downto 0);                -- "result" signal selected at mux_writeback
         rd1 : out STD_LOGIC_VECTOR(31 downto 0);              -- output rd1 from regfile
         rd2 : out STD_LOGIC_VECTOR(31 downto 0)               -- output rd2 from regfile
        );
    end component;           
begin

    -- Drive entity out ports from internal signals
    PC        <= PC_s;
    ALUResult <= ALUResult_s;
    WriteMem  <= rd2_s;
    
    -- Mapping pcgen's input and output
    pcgen_map : pcgen generic map(32) port map(clk, rst, PCNext, PC_s);
    -- Mapping adder to increase PC = PC + 4
    adder_pcplus4_map : adder_pcplus4 port map(PC_s, X"00000004", PCPlus4);
    -- Mapping adder to increase PC = PC + imm    
    adder_pctarget_map : adder_pctarget port map(PC_s, immext, PCTarget);
    -- Mapping alu 
    alu_map : alu port map(srcA, srcB, ALUControl, ALUResult_s, Zero);
    --  Mapping extend block
    extend_map : extend port map(instr, immSrc, immext);
    -- Mapping mux selecting immediate or rd2
    mux_alu_map : mux_alu generic map(32) port map(rd2_s, immext, ALUSrc, srcB); 
    -- Mapping mux selecting the next PC value
    mux_pcnext_map : mux_pcnext port map(PCSrc, PCPlus4, PCTarget, ALUResult_s, PCNext);
    -- Mapping mux selecting input value that will be send to regfile(rd)
    mux_writeback_map : mux_writeback port map(ResultSrc, ALUResult_s, ReadData, PCPlus4, result);
    -- Mapping register file 
    regfile_map: regfile port map(Regwrite, clk, instr(19 downto 15), instr(24 downto 20), instr(11 downto 7), result, srcA, rd2_s);
    
end Behavioral;
