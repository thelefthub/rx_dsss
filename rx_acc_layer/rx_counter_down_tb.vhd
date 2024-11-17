-- test bench for counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_down_tb is
end counter_down_tb;

architecture structural of counter_down_tb is 

-- Component Declaration
component count_down is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     decoded: in std_logic_vector(4 downto 0);
     sample_out: out std_logic
     );
 end component count_down;

for uut : count_down use entity work.count_down(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal decoded: std_logic_vector(4 downto 0);
signal sample_out:  std_logic;


BEGIN
    uut: count_down PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      decoded => decoded,
      sample_out => sample_out
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
	
    tb : PROCESS
    BEGIN
        rst <= '1';
        rst <= '0';
        decoded <= "01111";
        wait for period*50;
        decoded <= "11111";
        wait for period*5;
        rst <= '1';

        end_of_sim <= true;
        wait;
    END PROCESS;

  END;


