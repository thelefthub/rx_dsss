-- Latch to remove preamble and pass digit to 7 seg decoder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_latch is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     bit_sample: in std_logic;
     data_in: in std_logic_vector(10 downto 0);
     latch_out: out std_logic_vector(3 downto 0)
     );
end data_latch;

architecture behav of data_latch is

-- Preamble is used for detecting data sequences (latch out should only contain the effective digit)
constant preamble: std_logic_vector(6 downto 0) := "0111110";
signal preamble_sig: std_logic_vector(6 downto 0) := (others => '0');
signal latch_sig: std_logic_vector(3 downto 0) := (others => '0');
signal pres_latch, next_latch: std_logic_vector(3 downto 0) := (others => '0');

begin
-- data in contains the preamble and nibble
preamble_sig <= data_in(10 downto 4);
latch_sig <= data_in(3 downto 0);

-- signal out
latch_out <= pres_latch;


-- sequential process: (Flip-flop behavior)
syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_latch <= (others => '0');
        else
        if bit_sample = '1' and preamble_sig = preamble then -- only react on bit samples and check preamble data
            pres_latch <= next_latch;        
        -- else
        end if;
        end if;
    end if;
end process syn_shift;

-- Combinational process (Next-state logic)
com_shift: process(pres_latch, latch_sig) 
begin
    next_latch <= latch_sig;
end process com_shift; 

end behav;
