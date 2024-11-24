-- Correlator: remove noice from signal
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity correlator is
   port (
    clk, rst: in std_logic;
	clk_enable: in std_logic;
    bit_sample:		in std_logic;
	chip_sample:	in std_logic;
    sdi_despread:	in std_logic;
    -- test_count:	out std_logic_vector(5 downto 0);
	databit:	out std_logic   
	);
end correlator;

architecture behav of correlator is

-- six bit counter    
signal pres_count, next_count: std_logic_vector(5 downto 0):="100000"; -- init value for counter
constant reset: std_logic_vector(5 downto 0) :="100000"; --reset value for counter
signal msb: std_logic;

begin
    -- test_count <= pres_count;


syn_count: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        if rst = '1' or bit_sample ='1' then
            pres_count <= reset;
        else
        if chip_sample = '1' then -- only react on chip samples
            pres_count <= next_count;
        -- else
        end if;
        end if;
    end if;
end process syn_count;

com_count: process(pres_count,sdi_despread) 
begin
    if sdi_despread = '1' then
        next_count <= pres_count + "000001";
    elsif sdi_despread = '0' then
        next_count <= pres_count - "000001";
    else 
        next_count <= pres_count; --need unconditional else, no change
    end if;
end process com_count;

com_msb: process(pres_count) 
begin
    if pres_count >= reset then
        msb <= '1';
    elsif pres_count < reset then	
        msb <= '0';
    else 	--need unconditional else
        msb <= '0';
    end if;
end process com_msb;

--delay count out (databit) - needed?
com_delay: process(clk)
begin
    if rising_edge(clk) and clk_enable = '1' then
        databit <= msb;
    end if;
end process com_delay;
    
end behav;
    