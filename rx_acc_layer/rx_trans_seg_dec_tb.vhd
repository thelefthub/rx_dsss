-- test bench for trans_seg_dec
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_types.all; -- custom package to use seg types


entity trans_seg_dec_tb is
end trans_seg_dec_tb;

architecture structural of trans_seg_dec_tb is 

-- Component Declaration
component trans_seg_dec is
    port (
        clk, rst: in std_logic;
	    extb: in std_logic;
	    clk_enable: in std_logic;
	    -- seg_out: out std_logic_vector(4 downto 0)
        seg_out: out segment
     );
 end component trans_seg_dec;

for uut : trans_seg_dec use entity work.trans_seg_dec(behav);
 
constant period : time := 100 ns;

-- constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk, rst:  std_logic;
-- signal clk_enable:  std_logic;
signal extb:  std_logic;
signal seg_out: segment;

BEGIN
    uut: trans_seg_dec PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => '1',
      extb => extb,
      seg_out => seg_out
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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
        begin
        rst <= stimvect(0);
        extb <= stimvect(1);
        
        wait for period;
    end tbvector;
    
    BEGIN
        --reset 2H, 2L
        tbvector("01");
        wait for period*5;
        --start count
        tbvector("00");
        wait for period*20;
        
        -- test extb
        tbvector("10");
        wait for period*5;

        --restart count
        tbvector("00");
        wait for period*10;

        end_of_sim <= true;
        wait;
    END PROCESS;

  END;


