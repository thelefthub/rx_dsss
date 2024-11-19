--- Matched filter: sync pn stream sender and receiver 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types

-- Testbench entity (no ports needed)
entity matched_filter_tb is
end matched_filter_tb;

architecture structural of matched_filter_tb is
    
component matched_filter is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        sdi_spread: in std_logic;
        chip_sample: in std_logic; -- check use of correct sample delay!!!
        dip_sw: in std_logic_vector(1 downto 0);
        seq_match: out std_logic
        );
end component matched_filter;

for uut : matched_filter use entity work.matched_filter(behav);

constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal sdi_spread:  std_logic;
signal chip_sample:  std_logic;
signal dip_sw: std_logic_vector(1 downto 0);
signal seq_match:  std_logic;

BEGIN
    uut: matched_filter PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      sdi_spread => sdi_spread,
      chip_sample => chip_sample,
      dip_sw => dip_sw,
      seq_match => seq_match
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
    variable pn_ml1: std_logic_vector(30 downto 0):="0100001010111011000111110011010";
    variable pn_ml2: std_logic_vector(30 downto 0):="1110000110101001000101111101100";
    variable pn_gold: std_logic_vector(30 downto 0) := pn_ml1 xor pn_ml2;

    BEGIN
        -- normal sequence
        rst <='0';
        -- dip selection unencrypted: exepected output is high or output is low
        dip_sw <= "00";
        --high seq
        for i in 30 downto 0 loop
            sdi_spread <= '1';
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*2;
        --low seq
        for i in 30 downto 0 loop
            sdi_spread	<= '0';
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*5;
        -- dip selection at pn_ml1 (encrypted):exepected output is a specific repeating pattern (cf. variables)
        dip_sw <= "01";
        -- normal seq
        for i in 30 downto 0 loop
            -- wait for period;
            sdi_spread	<= pn_ml1(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*2;
        --inverted seq
        for i in 30 downto 0 loop
            -- wait for period;
            sdi_spread	<= not pn_ml1(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*5;
        -- dip selection at pn_ml2 (encrypted):exepected output is a specific repeating pattern (cf. variables)
        dip_sw <= "10";
        -- normal seq
        for i in 30 downto 0 loop
            sdi_spread	<= pn_ml2(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*2;
        --inverted seq
        for i in 30 downto 0 loop
            sdi_spread	<= not pn_ml2(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*5;
        -- dip selection at pn_gold (encrypted):exepected output is a specific repeating pattern (cf. variables)
        dip_sw <= "11";
        -- normal seq
        for i in 30 downto 0 loop
            sdi_spread	<= pn_gold(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*2;
        --inverted seq
        for i in 30 downto 0 loop
            sdi_spread	<= not pn_gold(i);
            wait for period;
            chip_sample	<= '1';
            wait for period;
            chip_sample	<= '0';
            wait for period;
        end loop;
        wait for period*5;
        -- reset
        rst <='1';
        wait for period*10;
        end_of_sim <= true;
        wait;
    END PROCESS;
  END;


