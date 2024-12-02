-- test bench for seven segment display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity decoder_tb is
end decoder_tb;

architecture structural of decoder_tb is
    
-- Component Declaration
component decoder is
    port (
        digit : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(7 downto 0)  -- 8-segment output (abcdefg + dp)
        );
    end component decoder;

for uut : decoder use entity work.decoder(behav);

constant period : time := 100 ns;
-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal digit:  std_logic_vector(3 downto 0):=(others => '0');
signal segments:  std_logic_vector(7 downto 0):=(others => '0');

BEGIN
    uut: decoder PORT MAP(
        digit => digit,
        segments => segments
      );

	tb : PROCESS
    BEGIN
        for i in 0 to 15 loop
            digit <= std_logic_vector(to_unsigned(i, 4));
            wait for period;
        end loop;
        end_of_sim <= true;
        wait;
    END PROCESS;

  END;
