-- Layered architecture: application layer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity app_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     bit_sample: in std_logic;
     data_in: in std_logic_vector(10 downto 0);
     seg_display: out std_logic_vector(7 downto 0)
     );
end app_layer;

architecture behav of app_layer is

component data_latch is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        data_in: in std_logic_vector(10 downto 0);
        latch_out: out std_logic_vector(3 downto 0)
        );
end component data_latch;

component decoder is
    Port (
        digit : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(7 downto 0)  -- 8-segment output (abcdefg + dp)
    );
end component decoder;

-- Internal signals for connecting components
signal latch_data: std_logic_vector(3 downto 0);

begin
    -- instances of layer components
    rx_data_latch: data_latch PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        bit_sample => bit_sample,
        data_in => data_in,
        latch_out => latch_data
    );

    rx_decoder: decoder PORT MAP(
        digit => latch_data,
        segments => seg_display
    );

    

end behav;
