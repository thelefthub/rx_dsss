-- dsss main application
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity top is
    port (
    clk, rst: in std_logic;
    sdi_spread: in std_logic;
    dip_sw: in std_logic_vector(1 downto 0);
    seg_display: out std_logic_vector(7 downto 0)
    );
end top;

architecture behav of top is

component main is
    port (
    clk, rst: in std_logic;
    clk_enable: in std_logic;
    sdi_spread: in std_logic;
    dip_sw: in std_logic_vector(1 downto 0);
    seg_display: out std_logic_vector(7 downto 0)
    );
end component main;

component clk_counter is
    port (
    clk: in std_logic;
    clk_out: out std_logic
     );
end component clk_counter;

-- Internal signals for connecting components
signal clk_send: std_logic;

begin
    -- instances of layer components
    rx_main: main PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_send,
        sdi_spread => sdi_spread,
        dip_sw => dip_sw,
        seg_display => seg_display
    );

    rx_clk_counter: clk_counter PORT MAP(
        clk => clk,
        clk_out => clk_send
    );

    
end behav;
