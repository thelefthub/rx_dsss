
-- State transition detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity pn_trans is
   port (
	clk, rst: in std_logic;
	clk_enable: in std_logic;
    full_seq: in std_logic;
    chip_sample: in std_logic;
	bit_sample: out std_logic
	);
end pn_trans;

architecture behav of pn_trans is

type state_type is (LOW, L_2_H, HIGH, H_2_L);
signal pres_state, next_state: state_type := LOW;

begin

-- signals out


-- transition state detection machine and feed changes to correlator
syn_state: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_state <= LOW;
        else
            if chip_sample = '1' then -- only react on chip samples
                pres_state <= next_state;
            else
                pres_state <= pres_state;
            end if;
        end if;
    end if;
end process syn_state;

com_state: process(full_seq, pres_state) 
begin
    -- state machine for transition handling
    case pres_state is
        when LOW => -- present state is low, verify incoming spread
            bit_sample <= '0';
            if full_seq = '1' then 
                next_state <= L_2_H;
            else 	
                next_state <= LOW;
            end if;	
        when L_2_H => -- sending out pulse signal for transition change
            bit_sample <= '1';
            next_state <= HIGH;
        when HIGH => -- present state is high, verify incoming spread
            bit_sample <= '0';
            if full_seq = '0' then
                next_state <= H_2_L;
            else	
                next_state <= HIGH;
            end if;
        when H_2_L => -- transition change but no pulse required
            bit_sample <= '0';
            next_state <= LOW;
        when others => -- default: no pulse and next state low?
            bit_sample <= '0';
            next_state <= LOW;
    end case;
end process com_state; 
    
end behav;
    