
-- Down Counter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity count_down is
   port (
    clk, rst: in std_logic;
	clk_enable: in std_logic;
    decoded: in std_logic_vector(4 downto 0);
	sample_out: out std_logic
	);
end count_down;

architecture behav of count_down is
    
signal pres_count, next_count: std_logic_vector(4 downto 0):="00111"; --count down from the middle
-- signal sample: std_logic;

begin
-- sample_out <= sample;


syn_count: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_count <= "00111"; --count down from the middle
        else
            pres_count <= next_count;
        end if;
    end if;
end process syn_count;

com_count: process(pres_count, decoded) 
begin
    if pres_count = "00000" then
        sample_out	<= '0';
        next_count	<= decoded; -- load new counter code
    elsif pres_count = "00001" then
        sample_out	<= '1'; -- take into account delay between semaphore and NCO: send at 1 instead of 0
        next_count 	<= pres_count - "00001";
    else
        sample_out	<= '0';
        next_count 	<= pres_count - "00001";
    end if;
end process com_count; 
    
end behav;
    