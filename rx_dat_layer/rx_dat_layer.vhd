-- Data layer of the receiver
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_layer is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        databit: in std_logic;
        data_out: out std_logic_vector(10 downto 0)
     );
end data_layer;

architecture behav of data_layer is

component data_register is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample: in std_logic;
        databit: in std_logic;
        data_out: out std_logic_vector(10 downto 0)
     );
end component data_register;

begin

    rx_data_register: data_register PORT MAP(
    clk => clk,
    rst => rst,
    clk_enable => clk_enable,
    bit_sample => bit_sample,
    databit => databit,
    data_out => data_out
    );

end behav;