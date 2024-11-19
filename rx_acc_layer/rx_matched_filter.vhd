--- Matched filter: sync pn stream sender and receiver 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types

entity matched_filter is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     sdi_spread: in std_logic;
     chip_sample: in std_logic; -- check use of correct sample delay!!!
     dip_sw: in std_logic_vector(1 downto 0);
     seq_match: out std_logic
     );
end matched_filter;
 
architecture behav of matched_filter is

-- Use mux
component mux_i4 is
    Port (
        i1: in std_logic_vector(30 downto 0);               
        i2: in std_logic_vector(30 downto 0);
        i3: in std_logic_vector(30 downto 0);
        i4: in std_logic_vector(30 downto 0);
        sel: in std_logic_vector(1 downto 0);
        result: out std_logic_vector(30 downto 0)
    );
end component mux_i4;

-- Internal signals for connecting components
signal pres_shift, next_shift: std_logic_vector(30 downto 0) := (others=>'0');
signal pn_code: std_logic_vector(30 downto 0) := (others=>'0');
signal pn_code_inv: std_logic_vector(30 downto 0) := not pn_code;


constant unencrypted: std_logic_vector(30 downto 0) := (others=>'0');
constant unencrypted_inv: std_logic_vector(30 downto 0) := not unencrypted;
constant pn_ml1: std_logic_vector(30 downto 0) := "0100001010111011000111110011010";
constant pn_ml1_inv: std_logic_vector(30 downto 0) := not pn_ml1;
constant pn_ml2: std_logic_vector(30 downto 0) := "1110000110101001000101111101100";
constant pn_ml2_inv: std_logic_vector(30 downto 0) := not pn_ml2;
constant pn_gold: std_logic_vector(30 downto 0) := pn_ml1 xor pn_ml2;
constant pn_gold_inv: std_logic_vector(30 downto 0) := not pn_gold;


begin

-- 2 mux instances
rx_mux: mux_i4 PORT MAP(
    i1 => unencrypted,               
    i2 => pn_ml1,
    i3 => pn_ml2,
    i4 => pn_gold,
    sel => dip_sw,
    result => pn_code
);

rx_mux_inv: mux_i4 PORT MAP(
    i1 => unencrypted_inv,               
    i2 => pn_ml1_inv,
    i3 => pn_ml2_inv,
    i4 => pn_gold_inv,
    sel => dip_sw,
    result => pn_code_inv
);

syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_shift <= (others => '0'); -- seq_match and init all zeros???
        else
            if chip_sample = '1' then -- only react on chip samples
                pres_shift <= next_shift;
            -- else
            end if;
        end if;
    end if;

end process syn_shift;

com_shift: process(pres_shift, sdi_spread, pn_code, pn_code_inv)
begin
    -- Shift left
    next_shift <= pres_shift(29 downto 0) & sdi_spread;

    -- verify match and generate output for pn generator
    if pres_shift = pn_code or pres_shift = pn_code_inv
    then 
        seq_match <='1';
    else
        seq_match <='0';
    end if;


end process com_shift;
    

end behav;




