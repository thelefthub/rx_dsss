-- digital phased locked loop: testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- use work.my_types.all; -- custom package to use seg types

entity dpll_tb is
end dpll_tb;

architecture structural of dpll_tb is 

-- Component Declaration
component dpll is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        sdi_spread: in std_logic;
        extb: out std_logic;
        chip_sample: out std_logic;
        chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
        chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
        );
    end component dpll;

for uut : dpll use entity work.dpll(behav);
     
constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal sdi_spread:  std_logic;
signal extb:  std_logic;
signal chip_sample, chip_sample1, chip_sample2:  std_logic;

BEGIN
    uut: dpll PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      sdi_spread => sdi_spread,
      extb => extb,
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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
        begin
        rst <= stimvect(0);
        sdi_spread <= stimvect(1);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset
        tbvector("01");
        wait for period*5;
        --test spread sequence
        for i in 0 to 5 loop
            tbvector("10");
            wait for period*15;
            tbvector("00");
            wait for period*15;
        end loop;
        tbvector("10");
        wait for period*15;
        -- verify long sequence of 0's
        tbvector("00");
        wait for period*15;
        tbvector("00");
        wait for period*15;
        tbvector("10");
        wait for period*15;
        tbvector("00");
        wait for period*15;
        --introduce errors and verify correction
        wait for period*4;
        for i in 0 to 5 loop
            tbvector("10");
            wait for period*15;
            tbvector("00");
            wait for period*15;
        end loop;
        --reset
        tbvector("01");
        wait for period*5;
        for i in 0 to 5 loop
            tbvector("10");
            wait for period*15;
            tbvector("00");
            wait for period*15;
        end loop;
        end_of_sim <= true;
        wait;
    END PROCESS;

    

  END;