-- test bench for semaphore
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity semaphore_tb is
end semaphore_tb;

architecture structural of semaphore_tb is 

component semaphore is
    port (
        clk, rst: in std_logic;
	    clk_enable: in std_logic;
	    extb: in std_logic;
        chip_sample: in std_logic;
        seg_in: in segment;
        seg_out: out segment
        );
 end component semaphore;

for uut : semaphore use entity work.semaphore(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal extb:  std_logic;
signal chip_sample:  std_logic;
signal seg_in: segment;
signal seg_out: segment;

BEGIN
    uut: semaphore PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      extb => extb,
      chip_sample => chip_sample,
      seg_in => seg_in,
      seg_out => seg_out
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
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
        begin
        rst <= stimvect(0);
        extb <= stimvect(1);
        chip_sample <= stimvect(2);

        seg_in <= b; -- a mock code
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset
        tbvector("001");
        wait for period*5;
        --start sample
        tbvector("010");
        wait for period*10;
        tbvector("100");
        wait for period*10;
        -- test extb
        tbvector("110");
        wait for period*5;
        --reset
        tbvector("001");
        wait for period*5;

        end_of_sim <= true;
        wait;
    END PROCESS;

  END;