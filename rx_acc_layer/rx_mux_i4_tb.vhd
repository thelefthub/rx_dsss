-- multiplexer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Testbench entity (no ports needed)
entity mux_i4_tb is
end mux_i4_tb;

architecture structural of mux_i4_tb is 

-- Component Declaration
component mux_i4
    Port (
        i1: in  std_logic_vector(30 downto 0);               
        i2: in  std_logic_vector(30 downto 0);
        i3: in  std_logic_vector(30 downto 0);
        i4: in  std_logic_vector(30 downto 0);
        sel: in  std_logic_vector(1 downto 0);
        result: out std_logic_vector(30 downto 0)
    );
end component;

for uut : mux_i4 use entity work.mux_i4(behav);

constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal i1, i2, i3, i4: std_logic_vector(30 downto 0) := (others=>'0');
signal sel: std_logic_vector(1 downto 0) := "00";
signal result: std_logic_vector(30 downto 0);
    
begin

    uut: mux_i4 PORT MAP (
        i1 => i1,               
        i2 => i2,
        i3 => i3,
        i4 => i4,
        sel => sel,
        result => result
        );

    process
    begin
        -- Test case 1
        i1 <= "0000000000000000000000000000000"; i2 <= "0000000000000000000000000000001"; i3 <= "0000000000000000000000000000011"; i4 <= "0000000000000000000000000000111";
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