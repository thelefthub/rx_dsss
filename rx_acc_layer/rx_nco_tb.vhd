-- test bench for nco
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity nco_tb is
end nco_tb;

architecture structural of nco_tb is
    
-- Component Declaration
component nco is
    port (
        clk, rst: in std_logic;
	    clk_enable: in std_logic;
	    seg_in: in segment;
        chip_sample: out std_logic;
        chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
        chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
     );
 end component nco;

for uut : nco use entity work.nco(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal seg_in: segment;
signal chip_sample, chip_sample1, chip_sample2: std_logic;

BEGIN
    uut: nco PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      seg_in => seg_in,
      chip_sample => chip_sample,
      chip_sample1 => chip_sample1,
      chip_sample2 => chip_sample2
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
        seg_in <= a;
        wait for period*20;
        seg_in <= b;
        wait for period*20;
        seg_in <= c;
        wait for period*20;
        seg_in <= d;
        wait for period*20;
        seg_in <= e;
        wait for period*20;
        rst <= '1';
        wait for period*20;
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;