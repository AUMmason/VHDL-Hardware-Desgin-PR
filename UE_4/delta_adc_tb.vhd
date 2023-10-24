library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity delta_adc_tb is
end entity delta_adc_tb;

architecture Testbench of delta_adc_tb is
  constant BIT_WIDTH : natural := 4;
  constant CLK_FREQUENCY : integer := 200; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal sampling_period : unsigned(BIT_WIDTH - 1 downto 0) := "1111";
  signal clk, reset : std_ulogic := '0';
  signal adc_valid_strobe, comparator, PWM_o : std_ulogic;
begin
  
  Delta_ADC: entity work.delta_adc(rtl) port map(
    clk_i => clk,
    reset_i => reset,
    comparator_i => comparator,
    sampling_period_i => sampling_period,
    adc_valid_strobe_o => adc_valid_strobe,
    PWM_o => PWM_o
  );
  
  clk <= not clk after CLK_PERIOD / 2;

  Stimuli: process is
  begin
    report std_ulogic'image(adc_valid_strobe);

    reset <= '1';

    wait for 20 ms;

    reset <= '0';

    comparator <= '1';

    wait for 200 ms;

    comparator <= '0';

    wait for 100 ms;

    comparator <= '1';

    wait for 400 ms;

    comparator <= '0';

    wait for 500 ms;

  end process Stimuli;
  
end architecture Testbench;