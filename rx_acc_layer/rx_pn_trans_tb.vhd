-- State transition detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types

entity pn_trans_tb is
end pn_trans_tb;

architecture structural of pn_trans_tb is 

component pn_trans is
   port (
	clk, rst: in std_logic;
	clk_enable: in std_logic;
    full_seq: in std_logic;
    chip_sample: in std_logic;
	bit_sample: out std_logic
	);
end component pn_trans;

for uut : pn_trans use entity work.pn_trans(behav);

constant period : time := 100 ns;

constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
signal full_seq:  std_logic;
signal chip_sample:  std_logic;
signal bit_sample:  std_logic;

BEGIN
    uut: pn_trans PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      full_seq => full_seq,
      chip_sample => chip_sample,
      bit_sample => bit_sample
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
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
        begin
        rst <= stimvect(0);
        full_seq <= stimvect(1);
        chip_sample <= stimvect(2);

        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset
        tbvector("001");
        wait for period*5;
        --test transition detection (active samples)
        for i in 0 to 20 loop
            tbvector("110");
            wait for period*5;
            tbvector("100");
            wait for period*5;
        end loop;
        --test transition detection (inactive samples)
        for i in 0 to 20 loop
            tbvector("010");
            wait for period*5;
            tbvector("000");
            wait for period*5;
        end loop;
        --reset
        tbvector("001");
        wait for period*5;
        end_of_sim <= true;
        wait;
    END PROCESS;

    

  END;


