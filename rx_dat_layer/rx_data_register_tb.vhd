-- test bench for data register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_register_tb is
end data_register_tb;

architecture structural of data_register_tb is
    
component data_register is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        databit: in std_logic;
        data_out: out std_logic_vector(10 downto 0)
        );
end component data_register;

for uut : data_register use entity work.data_register(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal bit_sample, databit:  std_logic;
signal data_out: std_logic_vector(10 downto 0);

BEGIN
    uut: data_register PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      bit_sample => bit_sample,
      databit => databit,
      data_out => data_out
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
    constant preamble: std_logic_vector(6 downto 0) := "0111110";
    constant test_nimble: std_logic_vector(3 downto 0) := "1011";
    
    BEGIN
    
    --reset
    rst <= '1';
    bit_sample	<= '0';
    databit	<= '0';
    rst <= '0';
    wait for period*5;        
    --normal sequence
    for i in 2 downto 0 loop
        for j in 6 downto 0 loop
            databit	<= preamble(j);
            wait for period;
            bit_sample	<= '1';
            wait for period;
            bit_sample	<= '0';
        end loop;
        for j in 3 downto 0 loop
            databit	<= test_nimble(j);
            wait for period;
            bit_sample	<= '1';
            wait for period;
            bit_sample	<= '0';
        end loop;
    end loop;
    
    -- reset
    rst <='1';
    wait for period*5;
    rst <='0';
    wait for period*5;
    for j in 6 downto 0 loop
        databit	<= preamble(j);
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;
    for j in 3 downto 0 loop
        databit	<= test_nimble(j);
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

    end_of_sim <= true;
    wait;
    END PROCESS;

  END;