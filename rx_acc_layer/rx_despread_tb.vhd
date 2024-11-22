-- test bench for despread
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity despread_tb is
end despread_tb;

architecture structural of despread_tb is 

-- Component Declaration
component despread is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        sdi_spread:	in std_logic;
        pn_seq:		in std_logic;
        chip_sample:	in std_logic;
        despread_out:	out std_logic
     );
 end component despread;

for uut : despread use entity work.despread(behav);

-- constant delay  : time :=  10 ns;
constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal sdi_spread, pn_seq, chip_sample :  std_logic;
signal despread_out: std_logic;

BEGIN
    uut: despread PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      sdi_spread => sdi_spread,
      pn_seq => pn_seq,
      chip_sample => chip_sample,
      despread_out => despread_out
      );

	clock : process

    begin
        clk <= '0';
        wait for period/2;
        loop
        clk <= '0';
        wait for period/2;
        clk <= '1';
        wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    tb : PROCESS
    procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
        begin
        rst <= stimvect(0);
        sdi_spread <= stimvect(1);
        pn_seq <= stimvect(2);
        chip_sample <= stimvect(3);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset
        tbvector("0001");
        wait for period*5;
        sdi_spread	<='1';
        
        -- test 1 xor 0 = 1 with sample
        tbvector("1100");
        wait for period*5;
        -- test 1 xor 0 = 1 without sample
        tbvector("0100");
        wait for period*5;
        -- test 0 xor 0 = 0 with sample
        tbvector("1000");
        wait for period*5;
        -- test 0 xor 0 = 0 without sample
        tbvector("0000");
        wait for period*5;
        -- test 0 xor 1 = 1 with sample
        tbvector("1010");
        wait for period*5;
        -- test 0 xor 1 = 1 without sample
        tbvector("0010");
        wait for period*5;
        -- test 1 xor 1 = 0 with sample
        tbvector("1110");
        wait for period*5;
        -- test 1 xor 1 = 0 without sample
        tbvector("0110");
        wait for period*5;
        --test reset
        tbvector("1100");
        wait for period*5;
        tbvector("0001");
        wait for period*5;

        end_of_sim <= true;
        wait;
    END PROCESS;

  END;