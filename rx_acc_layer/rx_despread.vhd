-- Despreading incoming data
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity despread is
   port (
    clk, rst: in std_logic;
	clk_enable: in std_logic;
    sdi_spread:	in std_logic;
	pn_seq:		in std_logic;
	chip_sample:	in std_logic;
	despread_out:	out std_logic   
	);
end despread;

architecture behav of despread is
    
signal pres_state, next_state: std_logic;

begin
despread_out <= pres_state;


syn_despread: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' then
            pres_state <= '0';
            else
            if chip_sample = '1' then -- only react on chip samples
                pres_state <= next_state;
            -- else
            end if;
        end if;
    end if;
end process syn_despread;

com_despread: process(pres_state, sdi_spread, pn_seq) 
begin
    next_state <= sdi_spread xor pn_seq;
end process com_despread; 
    
end behav;
    