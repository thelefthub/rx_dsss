-- Data register with preamble and count data
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_register is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     bit_sample: in std_logic;
     databit: in std_logic;
     data_out: out std_logic_vector(10 downto 0)
     );
end data_register;

architecture behav of data_register is

-- Preamble is used for detecting data sequences (hence shift preamble out first)
-- constant preamble: std_logic_vector(6 downto 0) := "0111110";
signal pres_data, next_data: std_logic_vector(10 downto 0) := (others => '0');

begin

-- signal out
data_out <= pres_data;

-- sequential process: (Flip-flop behavior)
syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_data <= (others => '0');
        else
        if bit_sample = '1' then -- only react on bit samples
            pres_data <= next_data;        
        -- else
        end if;
        end if;
    end if;
end process syn_shift;

-- Combinational process (Next-state logic)
com_shift: process(pres_data, databit) 
begin
    next_data <= pres_data(9 downto 0) & databit; -- shift
end process com_shift; 

end behav;

