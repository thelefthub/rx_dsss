-- Semaphore: sample memory
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types

entity semaphore is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     extb: in std_logic;
     chip_sample: in std_logic;
     seg_in: in segment;
     seg_out: out segment
 
     );
 end semaphore;
 
architecture behav of semaphore is

-- Internal signals for connecting components
type state_type is (IDLE, IN_TRANS, PUSH_OUT, NO_TRANS);
signal pres_state, next_state: state_type := IDLE;


begin

-- segment state detection machine and feed changes to NCO
syn_sema: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_state	<= IDLE;
        else
            pres_state 	<= next_state;
        end if;
    end if;
end process syn_sema;

com_sema: process(pres_state, extb, chip_sample, seg_in) 
begin
    -- state machine for chip handling
    case pres_state is
        when IDLE => -- waiting for state transition
            if extb = '1' then -- always react on 
            next_state <= IN_TRANS;
            elsif extb = '0' and chip_sample = '1' then --if sample received but no transition detected
            -- elsif (chip_sample = '1') then --if sample received but no transition detected
            next_state <= NO_TRANS;
            else 	
            next_state <= IDLE;
            end if;
            -- seg_out <= c;--default;?	
        when IN_TRANS => -- transition was detected
            if chip_sample = '1' then 
            next_state <= PUSH_OUT; --if in transition but sample received, send sample out
            else 	
            next_state <= IN_TRANS;
            end if;
            -- seg_out <= c;--default;?	
        when PUSH_OUT => -- provide data to NCO!
            seg_out	<= seg_in;
            next_state <= IDLE;
        when NO_TRANS => -- no transition detected (long series of 0 or 1): no corrections!
            seg_out <= c;
            next_state <= IDLE;
        when others => -- default: no pulse and next state idle?
            next_state <= IDLE;
            -- seg_out <= c;--default;?	
    end case;
end process com_sema; 
    
end behav;

