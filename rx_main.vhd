-- dsss main receiver application
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity main is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdi_spread: in std_logic;
     dip_sw: in std_logic_vector(1 downto 0);
     seg_display: out std_logic_vector(7 downto 0)    
     );
end main;

architecture behav of main is

component app_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        data_in: in std_logic_vector(10 downto 0);
        seg_display: out std_logic_vector(7 downto 0)
    );
end component app_layer;

component data_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        databit: in std_logic;
        data_out: out std_logic_vector(10 downto 0)
    );
end component data_layer;

component access_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        sdi_spread: in std_logic;
        dip_sw: in std_logic_vector(1 downto 0);
        bit_sample: out std_logic;
        databit: out std_logic
    );
end component access_layer;

-- Internal signals for connecting components
signal int_data: std_logic_vector(10 downto 0);
signal bit_sample, databit: std_logic;
-- Inverted signals
signal rst_inv : std_logic;
signal dip_sw_inv: std_logic_vector(1 downto 0);
signal int_sdi_spread : std_logic;

begin
    -- All I/O active low!!!!! => invert I/O
    rst_inv <= not rst;
    dip_sw_inv <= not dip_sw;
    int_sdi_spread <= sdi_spread;

    
    -- instances of layer components
    rx_app_layer: app_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        bit_sample => bit_sample,
        data_in => int_data,
        seg_display => seg_display
    );

    rx_data_layer: data_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        bit_sample => bit_sample,
        databit => databit,
        data_out => int_data
    );

    rx_access_layer: access_layer PORT MAP(
        clk => clk,
        rst => rst_inv,
        clk_enable => clk_enable,
        sdi_spread => int_sdi_spread,
        dip_sw => dip_sw_inv,
        bit_sample => bit_sample,
        databit => databit
    );

end behav;
