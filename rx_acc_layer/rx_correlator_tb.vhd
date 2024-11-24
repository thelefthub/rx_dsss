-- test bench for correlator
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity correlator_tb is
end correlator_tb;

architecture structural of correlator_tb is
    
-- Component Declaration
component correlator is
    port (
        clk, rst: in std_logic;
        clk_enable: in std_logic;
        bit_sample:		in std_logic;
        chip_sample:	in std_logic;
        sdi_despread:	in std_logic;
        -- test_count:	out std_logic_vector(5 downto 0);
        databit:	out std_logic   
     );
 end component correlator;

for uut : correlator use entity work.correlator(behav);

constant delay  : time :=  10 ns;
constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal sdi_despread, bit_sample, chip_sample :  std_logic;
signal databit: std_logic;
-- signal test_count: std_logic_vector(5 downto 0);


BEGIN
    uut: correlator PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      sdi_despread => sdi_despread,
      bit_sample => bit_sample,
      chip_sample => chip_sample,
    --   test_count => test_count,
      databit => databit
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
        sdi_despread <= stimvect(1);
        bit_sample <= stimvect(2);
        chip_sample <= stimvect(3);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset
        tbvector("0001");
        wait for period*5;
        
        -- test 1
        for i in 0 to 30 loop
            tbvector("1010");
            tbvector("0010");
            wait for period*10;
        end loop;
        wait for period*2;
        tbvector("0110"); --reset with bit sample
        tbvector("1110"); 
        wait for period;
        tbvector("0110"); --reset with bit sample
        tbvector("0010");
        wait for period * 5;
        -- test 2
        for i in 0 to 30 loop
            tbvector("1000");
            tbvector("0000");
            wait for period*10;
        end loop;
        wait for period*2;
        tbvector("0100"); --reset with bit sample
        tbvector("1100"); 
        wait for period;
        tbvector("0100"); --reset with bit sample
        tbvector("0000");
        wait for period * 5;
        -- some noice
        for i in 0 to 10 loop
            tbvector("1010");
            tbvector("0010");
            wait for period*10;
        end loop;
        for i in 0 to 10 loop
            tbvector("1000");
            tbvector("0000");
            wait for period*10;
        end loop;
        tbvector("0110"); --reset with bit sample
        tbvector("1110"); 
        wait for period;
        tbvector("0110"); --reset with bit sample
        tbvector("0010");
        wait for period*30;
        
        --test reset
        tbvector("1010");
        wait for period*5;
        tbvector("1011");
        wait for period*5;

        end_of_sim <= true;
        wait;
    END PROCESS;
END;