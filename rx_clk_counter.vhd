
-- Counter with up and down input
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity clk_counter is
   port (
    clk: in std_logic;
    -- test_out: out  std_logic_vector(13 downto 0);
	clk_out: out std_logic
	);
end clk_counter;

architecture behav of clk_counter is
    
signal pres_count, next_count: std_logic_vector(9 downto 0):=(others =>'1');
constant count_zero : std_logic_vector(9 downto 0):=(others =>'0');

begin

    -- test_out <= pres_count;
    
syn_count: process(clk)
begin
    
    if rising_edge(clk) then
        pres_count <= next_count;
    end if;

end process syn_count;

com_count: process(pres_count) 
begin
    if pres_count = count_zero then --restart
        clk_out <= '1';
        next_count <= (others =>'1');
    else -- each if minimally needs an unconditional else!
        clk_out <= '0';
        next_count <= pres_count - "0000000001";
    end if;
end process com_count;
    
end behav;
    