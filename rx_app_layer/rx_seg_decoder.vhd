--7 segment decoder (active low)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity decoder is
    Port (
        digit : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(7 downto 0)  -- 8-segment output (abcdefg + dp)
    );
end decoder;

architecture behav of decoder is

begin
    com_display: process(digit)
    -- disable decimal point segment
    constant dp :std_logic:='1';
    begin
        case digit is
            when "0000" => segments <= "0000001" & dp; -- 0
            when "0001" => segments <= "1001111" & dp; -- 1
            when "0010" => segments <= "0010010" & dp; -- 2
            when "0011" => segments <= "0000110" & dp; -- 3
            when "0100" => segments <= "1001100" & dp; -- 4
            when "0101" => segments <= "0100100" & dp; -- 5
            when "0110" => segments <= "0100000" & dp; -- 6
            when "0111" => segments <= "0001111" & dp; -- 7
            when "1000" => segments <= "0000000" & dp; -- 8
            when "1001" => segments <= "0000100" & dp; -- 9
            when "1010" => segments <= "0001000" & dp; -- a
            when "1011" => segments <= "1100000" & dp; -- b
            when "1100" => segments <= "0110001" & dp; -- c
            when "1101" => segments <= "1000010" & dp; -- d
            when "1110" => segments <= "0110000" & dp; -- e
            when "1111" => segments <= "0111000" & dp; -- f
            when others => segments <= "1111111" & dp; -- Default(all segments off)
        end case;
    end process com_display;
end behav;