
-- digital phased locked loop: feedback control system that synchronizes the generated digital signal with the phase of the incoming reference signal.
-- used for chip sync: indicate when chip can be sampled and ensure corrections when needed
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity dpll is
   port (
	clk, rst: in std_logic;
	clk_enable: in std_logic;
    sdi_spread: in std_logic;
	extb: out std_logic;
	chip_sample: out std_logic;
	chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
	chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
	);
end dpll;

architecture behav of dpll is

-- -- components
component trans_seg_dec is
    port (
     clk, rst: in std_logic;
     extb: in std_logic;
     clk_enable: in std_logic;
     seg_out: out segment
 
     );
end component trans_seg_dec;

component semaphore is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     extb: in std_logic;
     chip_sample: in std_logic;
     seg_in: in segment;
     seg_out: out segment
 
     );
end component semaphore;

component nco is
    port (
     clk, rst: in std_logic;
     clk_enable: in std_logic;
     seg_in: in segment;
     chip_sample: out std_logic;
     chip_sample1: out std_logic; -- slower version (possibly needed for delays in other components)
     chip_sample2: out std_logic -- slower version (possibly needed for delays in other components)
     );
end component nco;

-- Internal signals for connecting components
signal extb_int: std_logic;
signal seg_code: segment;
type state_type is (LOW, L_2_H, HIGH, H_2_L);
signal pres_state, next_state: state_type := LOW;
signal sample_int, sample_int1, sample_int2: std_logic;
signal sema_code: segment;

begin

-- signals out
extb <= extb_int;
chip_sample <= sample_int;
chip_sample1 <= sample_int1;
chip_sample2 <= sample_int2;

-- component instances
rx_trans_seg_dec: trans_seg_dec PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        extb => extb_int,
        seg_out => seg_code
    );

rx_semaphore: semaphore PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        extb => extb_int,
        chip_sample => sample_int,
        seg_in => seg_code,
        seg_out => sema_code
    );

rx_nco: nco PORT MAP(
        clk => clk,
        rst => rst,
        clk_enable => clk_enable,
        seg_in => sema_code,
        chip_sample => sample_int,
        chip_sample1 => sample_int1,
        chip_sample2 => sample_int2
    );


-- transition state detection machine and feed changes to segment decoder
syn_state: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_state <= LOW;
        else
            pres_state <= next_state;
        end if;
    end if;
end process syn_state;

com_state: process(sdi_spread, pres_state) 
begin
    -- state machine for transition handling
    case pres_state is
        when LOW => -- present state is low, verify incoming spread
            extb_int <= '0';
            if sdi_spread = '1' then 
                next_state <= L_2_H;
            else 	
                next_state <= LOW;
            end if;	
        when L_2_H => -- sending out pulse signal for transition change
            extb_int <= '1';
            next_state <= HIGH;
        when HIGH => -- present state is high, verify incoming spread
            extb_int <= '0';
            if sdi_spread = '0' then
                next_state <= H_2_L;
            else	
                next_state <= HIGH;
            end if;
        when H_2_L => -- sending out pulse signal for transition change
            extb_int <= '1';
            next_state <= LOW;
        when others => -- default: no pulse and next state low?
            extb_int <= '0';
            next_state <= LOW;
    end case;
end process com_state; 
    
end behav;
    