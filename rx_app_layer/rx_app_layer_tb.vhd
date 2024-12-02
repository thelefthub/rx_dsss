-- test bench for data register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity app_layer_tb is
end app_layer_tb;

architecture structural of app_layer_tb is
    
component app_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        data_in: in std_logic_vector(10 downto 0);
        seg_display: out std_logic_vector(7 downto 0)
        );
end component app_layer;

for uut : app_layer use entity work.app_layer(behav);

constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal bit_sample:  std_logic;
signal data_in: std_logic_vector(10 downto 0);
signal seg_display: std_logic_vector(7 downto 0);

BEGIN
    uut: app_layer PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      bit_sample => bit_sample,
      data_in => data_in,
      seg_display => seg_display
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
    constant test_shift_1: std_logic_vector(10 downto 0) := "11111100100";
    constant test_shift_2: std_logic_vector(10 downto 0) := "01111100001";
    constant test_shift_3: std_logic_vector(10 downto 0) := "01111100010";
    constant test_shift_4: std_logic_vector(10 downto 0) := "01111100011";
    constant test_shift_5: std_logic_vector(10 downto 0) := "01111100100";
   
    
    BEGIN
    
    -- reset
    rst <= '1';
    bit_sample	<= '0';
    rst <= '0';
    wait for period*5;      

    -- no preamble match
    data_in	<= test_shift_1;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

    -- preamble match
    data_in	<= test_shift_2;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

    -- preamble match
    data_in	<= test_shift_3;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

    -- preamble match
    data_in	<= test_shift_4;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

    -- preamble match
    data_in	<= test_shift_5;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;

        
    -- reset
    rst <='1';
    wait for period*5;
    rst <='0';
    wait for period*5;

    -- preamble match
    data_in	<= test_shift_5;
    for i in 20 downto 0 loop
        wait for period;
        bit_sample	<= '1';
        wait for period;
        bit_sample	<= '0';
    end loop;
    

    end_of_sim <= true;
    wait;
    END PROCESS;

  END;
