-- test bench for main application
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity top_tb is
end top_tb;

architecture structural of top_tb is

component top is
    port (
        clk, rst: in std_logic;
        -- clk_enable: in std_logic;
        sdi_spread: in std_logic;
        dip_sw: in std_logic_vector(1 downto 0);
        seg_display: out std_logic_vector(7 downto 0)  
        
        );
end component top;

for uut : top use entity work.top(behav);

constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clk, rst: std_logic;
signal sdi_spread: std_logic;
signal seg_display: std_logic_vector(7 downto 0);
signal dip_sw: std_logic_vector(1 downto 0);

BEGIN
    uut: top PORT MAP(
      clk => clk,
      rst => rst,
    --   clk_enable => '1',
      sdi_spread => sdi_spread,
      seg_display => seg_display,
      dip_sw => dip_sw      
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
    constant seq_delay: integer := 496;
    constant preamble: std_logic_vector(6 downto 0) := "0111110";
    constant test_nibble: std_logic_vector(3 downto 0) := "1011"; --1011 1111 1001
    variable pn_ml1: std_logic_vector(30 downto 0) := "0100001010111011000111110011010";
    variable pn_ml2: std_logic_vector(30 downto 0) := "1110000110101001000101111101100";
    variable pn_gold: std_logic_vector(30 downto 0) := pn_ml1 xor pn_ml2;

    BEGIN
    
    --normal sequence
    rst <= not '0';
    sdi_spread <= '0'; 

    -- dip selection unencrypted
    dip_sw <= not "00";
    for i in 6 downto 0 loop
        sdi_spread	<= preamble(i);
        wait for period * seq_delay;
    end loop;
    for i in 3 downto 0 loop
        sdi_spread	<= test_nibble(i);
        wait for period * seq_delay;
    end loop;
    
    -- dip selection at pn_ml1 (encrypted):exepected output is a specific repeating pattern (cf. variables)
    dip_sw <= not "01";
    -- preamble
    for i in 30 downto 0 loop
        sdi_spread	<= pn_ml1(i); --0
        wait for period * 16;
    end loop;
    for j in 4 downto 0 loop
        for i in 30 downto 0 loop
            sdi_spread	<= not pn_ml1(i); --111111
            wait for period * 16;
        end loop;
    end loop;
    for i in 30 downto 0 loop
        sdi_spread	<= pn_ml1(i); --0
        wait for period * 16;
    end loop;
    -- data
    for j in 3 downto 0 loop
        if test_nibble(j) = '1' then 
            for i in 30 downto 0 loop
                sdi_spread	<= not pn_ml1(i); --1
                wait for period * 16;
            end loop;
        else 
            for i in 30 downto 0 loop
                sdi_spread	<= pn_ml1(i); --0
                wait for period * 16;
            end loop;
        end if;
    end loop;

    -- dip selection at pn_ml2 (encrypted):exepected output is a specific repeating pattern (cf. variables)
    dip_sw <= not "10";
    -- preamble
    for i in 30 downto 0 loop
        sdi_spread	<= pn_ml2(i); --0
        wait for period * 16;
    end loop;
    for j in 4 downto 0 loop
        for i in 30 downto 0 loop
            sdi_spread	<= not pn_ml2(i); --111111
            wait for period * 16;
        end loop;
    end loop;
    for i in 30 downto 0 loop
        sdi_spread	<= pn_ml2(i); --0
        wait for period * 16;
    end loop;
    -- data
    for j in 3 downto 0 loop
        if test_nibble(j) = '1' then 
            for i in 30 downto 0 loop
                sdi_spread	<= not pn_ml2(i); --1
                wait for period * 16;
            end loop;
        else 
            for i in 30 downto 0 loop
                sdi_spread	<= pn_ml2(i); --0
                wait for period * 16;
            end loop;
        end if;
    end loop;

    -- dip selection at pn_gold (encrypted):exepected output is a specific repeating pattern (cf. variables)
    dip_sw <= not "11";
    -- preamble
    for i in 30 downto 0 loop
        sdi_spread	<= pn_gold(i); --0
        wait for period * 16;
    end loop;
    for j in 4 downto 0 loop
        for i in 30 downto 0 loop
            sdi_spread	<= not pn_gold(i); --111111
            wait for period * 16;
        end loop;
    end loop;
    for i in 30 downto 0 loop
        sdi_spread	<= pn_gold(i); --0
        wait for period * 16;
    end loop;
    -- data
    for j in 3 downto 0 loop
        if test_nibble(j) = '1' then 
            for i in 30 downto 0 loop
                sdi_spread	<= not pn_gold(i); --1
                wait for period * 16;
            end loop;
        else 
            for i in 30 downto 0 loop
                sdi_spread	<= pn_gold(i); --0
                wait for period * 16;
            end loop;
        end if;
    end loop;
    
    -- reset
    rst <= not '1';
    wait for period*10;
    rst <= not '0';
    wait for period*496;

    -- dip selection unencrypted
    dip_sw <= not "00";
    for i in 6 downto 0 loop
        sdi_spread	<= preamble(i);
        wait for period * seq_delay;
    end loop;
    for i in 3 downto 0 loop
        sdi_spread	<= test_nibble(i);
        wait for period * seq_delay;
    end loop;
    for i in 6 downto 0 loop
        sdi_spread	<= preamble(i);
        wait for period * seq_delay;
    end loop;
    for i in 3 downto 0 loop
        sdi_spread	<= test_nibble(i);
        wait for period * seq_delay;
    end loop;

    end_of_sim <= true;
    wait;
    END PROCESS;


END;