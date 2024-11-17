-- Segment decoder
library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types
USE IEEE.numeric_std.all; -- needed for calculations

entity nco is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     seg_in: in segment;
     chip_sample: out std_logic;
     chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
     chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
     );
 end nco;
 
 architecture behav of nco is

-- components
component count_down is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        decoded: in std_logic_vector(4 downto 0);
	    sample_out: out std_logic
        );
end component count_down;

signal decoded_seg: std_logic_vector(4 downto 0);
signal count_sample: std_logic;
signal single_delay: std_logic;
signal double_delay: std_logic;


begin
-- signals out
chip_sample	<= count_sample;
chip_sample1 <= single_delay;
chip_sample2 <= double_delay;

-- component instances
rx_count_down: count_down PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        decoded => decoded_seg,
        sample_out => count_sample
    );

-- use different chip speeds
syn_count: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        single_delay <= count_sample;
        double_delay <= single_delay;
    end if;
end process syn_count;

-- sync segments to counter
com_dec: process(seg_in) 
begin
    case seg_in is
        when a => decoded_seg <= "01111" + "00011"; -- "00011"
        when b => decoded_seg <= "01111" + "00001";-- "00001"
        when c => decoded_seg <= "01111";
        when d => decoded_seg <= "01111" - "00001";
        when e => decoded_seg <= "01111" - "00011";
        when others => decoded_seg <= "01111"; -- Default (segment c)
    end case;
end process com_dec;



end behav;