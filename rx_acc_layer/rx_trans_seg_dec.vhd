
-- Segment decoder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity trans_seg_dec is
   port (
    clk, rst: in std_logic;
	extb: in std_logic;
	clk_enable: in std_logic;
    seg_out: out segment

	);
end trans_seg_dec;

architecture behav of trans_seg_dec is

-- components
component counter is
    port (
        clk, rst: in std_logic;
        extb: in std_logic;
        clk_enable: in std_logic;
        count_out: out std_logic_vector(3 downto 0)
        );
end component counter;

signal count_data: std_logic_vector(3 downto 0);

begin

-- component instances
rx_counter: counter PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        extb => extb,
        count_out => count_data
    );

-- sync counter to segments

com_dec: process(count_data) 
begin
    case count_data is
        when "0000"|"0001"|"0010"|"0011"|"0100" => seg_out <= a;
        when "0101"|"0110" => seg_out <= b;
        when "0111"|"1000" => seg_out <= c;
        when "1001"|"1010" => seg_out <= d;
        when "1011"|"1100"|"1101"|"1110"|"1111" => seg_out <= e;
        when others => seg_out <= c; -- Default(seg c?)
    end case;
end process com_dec; 
    
end behav;
    