-- multiplexer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Testbench entity (no ports needed)
entity mux_i2_tb is
end mux_i2_tb;

architecture structural of mux_i2_tb is 

-- Component Declaration
component mux_i2
    Port (
        i1: in  std_logic;               
        i2: in  std_logic;
        sel: in  std_logic_vector(1 downto 0);
        result: out std_logic
    );
end component;

for uut : mux_i2 use entity work.mux_i2(behav);

constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal i1, i2: std_logic := '0';
signal sel: std_logic_vector(1 downto 0) := "00";
signal result: std_logic;
    
begin

    uut: mux_i2 PORT MAP (
        i1 => i1,               
        i2 => i2,
        sel => sel,
        result => result
        );

    process
    begin
        -- Test case 1
        i1 <= '1'; i2 <= '0';
        sel <= "00";
        wait for period;
        
        -- Test case 2
        sel <= "01";
        wait for period;
                
        -- Test case 3
        sel <= "10";
        wait for period;

        -- Test case 4
        sel <= "11";
        wait for period;

        end_of_sim <= true;
        wait;
    end process;

end;