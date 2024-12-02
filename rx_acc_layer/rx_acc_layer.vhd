-- Layered architecture: Access layer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity access_layer is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdi_spread: in std_logic;
     dip_sw: in std_logic_vector(1 downto 0);
     bit_sample: out std_logic;
     databit: out std_logic
     );
end access_layer;

architecture behav of access_layer is

-- acc layer components
-- digital phased locked loop
component dpll is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdi_spread: in std_logic;
     extb: out std_logic;
     chip_sample: out std_logic;
     chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
     chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
     );
end component dpll;

-- sync pn stream sender and receiver
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

-- pseudo noice generator
component pn_generator is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     seq_det: in std_logic;
     chip_sample: in std_logic; -- check use of correct sample delay!!!
     bit_sample: out std_logic;
     pn_ml1: out std_logic;
     pn_ml2: out std_logic;
     pn_gold: out std_logic
     );
end component pn_generator;

-- despreading incoming data
component despread is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdi_spread:	in std_logic;
     pn_seq:		in std_logic;
     chip_sample:	in std_logic;
     despread_out:	out std_logic   
     );
end component despread;

-- remove noice from signal
component correlator is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     bit_sample:		in std_logic;
     chip_sample:	in std_logic;
     sdi_despread:	in std_logic;
     databit:	out std_logic   
     );
end component correlator;

-- 2 input mux
component mux_i2 is
    Port (
        i1: in  std_logic;               
        i2: in  std_logic;
        sel: in  std_logic_vector(1 downto 0);
        result: out std_logic
    );
end component mux_i2;

-- 4 input mux
component mux_i42 is
    Port (
        i1: in  std_logic;               
        i2: in  std_logic;
        i3: in  std_logic;
        i4: in  std_logic;
        sel: in  std_logic_vector(1 downto 0);
        result: out std_logic
    );
end component mux_i42;

-- Internal signals for connecting components
signal int_chip_sample, int_chip_sample1, int_chip_sample2: std_logic;
signal int_extb: std_logic;
signal int_seq_match: std_logic;
signal int_seq_det: std_logic;
signal int_pn_ml1, int_pn_ml2, int_pn_gold: std_logic;
signal int_pn_seq: std_logic;
signal int_bit_sample: std_logic;
signal int_despread_out: std_logic;
signal int_sdi_despread: std_logic; 

begin

    bit_sample	<= int_bit_sample;

    -- instances of layer components
    rx_dpll: dpll PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      sdi_spread => sdi_spread,
      extb => int_extb,
      chip_sample => int_chip_sample,
      chip_sample1 => int_chip_sample1,
      chip_sample2 => int_chip_sample2
    );

    rx_matched_filter: matched_filter PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      sdi_spread => sdi_spread,
      chip_sample => int_chip_sample,
      dip_sw => dip_sw,
      seq_match => int_seq_match
    );

    rx_pn_generator: pn_generator PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      seq_det => int_seq_det,
      chip_sample => int_chip_sample1 ,--int_chip_sample1, 
      bit_sample => int_bit_sample,
      pn_ml1 => int_pn_ml1,
      pn_ml2 => int_pn_ml2,
      pn_gold => int_pn_gold
    );

    rx_despread: despread PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      sdi_spread => sdi_spread,
      pn_seq => int_pn_seq,
      chip_sample => int_chip_sample1,--int_chip_sample, int_chip_sample1, int_chip_sample2
      despread_out => int_despread_out
    );

    rx_correlator: correlator PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      bit_sample => int_bit_sample,
      chip_sample => int_chip_sample2,--int_chip_sample,
      sdi_despread => int_sdi_despread,
      databit => databit
    );

    rx_acc_mux_seq: mux_i2 PORT MAP(
      i1 => int_extb,               
      i2 => int_seq_match,
      sel => dip_sw,
      result => int_seq_det
    );

    rx_acc_mux_i42: mux_i42 PORT MAP(
      i1 => '0',               
      i2 => int_pn_ml1,
      i3 => int_pn_ml2,
      i4 => int_pn_gold,
      sel => dip_sw,
      result => int_pn_seq
    );

    rx_acc_mux_despread: mux_i2 PORT MAP(
      i1 => sdi_spread,               
      i2 => int_despread_out,
      sel => dip_sw,
      result => int_sdi_despread
    );

    

end behav;