-- pseudo noice generator
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types

entity pn_generator is
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
end pn_generator;
 
architecture behav of pn_generator is

-- components
component pn_trans is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        full_seq: in std_logic;
        chip_sample: in std_logic;
        bit_sample: out std_logic
 
     );
end component pn_trans;

signal pres_shift_1, next_shift_1: std_logic_vector(4 downto 0) := "00010";
signal pres_shift_2, next_shift_2: std_logic_vector(4 downto 0) := "00111";
signal full_seq: std_logic;
signal bit_sample_int: std_logic;


begin

-- signals out
bit_sample <= bit_sample_int; --needed for sync?
pn_ml1   <= pres_shift_1(0);
pn_ml2   <= pres_shift_2(0);
pn_gold  <= pres_shift_1(0) xor pres_shift_2(0);

-- component instances
rx_pn_trans: pn_trans PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        full_seq => full_seq,
        chip_sample => chip_sample,
        bit_sample => bit_sample_int
    );


syn_shift: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' or seq_det = '1' then -- use seq_det as additional reset option!
            pres_shift_1 <= "00010";
            pres_shift_2 <= "00111";
        else
            if chip_sample = '1' then -- only react on chip samples
                pres_shift_1 <= next_shift_1;
                pres_shift_2 <= next_shift_2;
            -- else
            end if;
        end if;
    end if;

end process syn_shift;

com_shift: process(pres_shift_1,pres_shift_2) 
begin
    -- Shift right and consecutive xor ops for the MSB
    next_shift_1 <= (pres_shift_1(0) xor pres_shift_1(3)) & pres_shift_1(4 downto 1);
    next_shift_2 <= ((((pres_shift_2(0) xor pres_shift_2(1)) xor pres_shift_2(3)) xor pres_shift_2(4))) & pres_shift_2(4 downto 1);

    -- output for sequence controller (load or shift op)
    if next_shift_1 = "00010"
    then 
        full_seq <='1';
    else
        full_seq <='0';
    end if;

end process com_shift;

-- delay for sync - needed???
-- syn_delay: Process(clk)
-- begin
-- if rising_edge(clk) and clk_enable ='1' then
-- 	if chip_sample = '1' then
-- 		bit_sample <= bit_sample_int;
-- 	else
-- 		bit_sample <= '0';
-- 	end if;
-- else
-- end if;
-- end process syn_delay;
    
end behav;