-- test bench for counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity clk_counter_tb is
end clk_counter_tb;

architecture structural of clk_counter_tb is 

-- Component Declaration
component clk_counter is
    port (
        clk: in std_logic;
        -- test_out: out  std_logic_vector(13 downto 0);
        clk_out: out std_logic
     );
 end component clk_counter;

for uut : clk_counter use entity work.clk_counter(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, clk_out:  std_logic;
-- signal test_out: std_logic_vector(13 downto 0);

begin
    uut: clk_counter PORT MAP(
        clk => clk,
        -- test_out => test_out,
        clk_out => clk_out
        );

    clock : process
    begin
        clk <= '0';
        wait for period/2;
        loop
        clk <= '0';
        wait for period/2;
        clk <= '1';
        wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    tb : process
    begin
        wait for period * 1024 * 3;
        end_of_sim <= true;
        wait;
    end process;

end;