library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity delta_adc_tb is
end entity delta_adc_tb;

architecture Testbench of delta_adc_tb is
  constant CLK_FREQUENCY : integer := 1000; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f
  
  constant PWM_PERIOD : natural := 20;
  constant SAMPLING_PERIOD : natural := 8;
  constant ADC_BIT_WIDTH : natural := integer( ceil(log2(real( PWM_PERIOD ))) );

  signal clk, reset : std_ulogic := '0';
  signal adc_valid_strobe, comparator, PWM : std_ulogic;

  signal adc_value : unsigned(ADC_BIT_WIDTH - 1 downto 0);
begin
  
  Delta_ADC: entity work.delta_adc(rtl) generic map (
    PWM_PERIOD => PWM_PERIOD,
    SAMPLING_PERIOD => SAMPLING_PERIOD,
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
  ) port map(
    clk_i => clk,
    reset_i => reset,
    comparator_i => comparator,
    adc_valid_strobe_o => adc_valid_strobe,
    PWM_o => PWM,
    adc_value_o => adc_value
  );
  
  clk <= not clk after CLK_PERIOD / 2;

  Stimuli: process is
  begin
    report std_ulogic'image(adc_valid_strobe);
    report std_ulogic'image(PWM);

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

    comparator <= '1';

    wait;

  end process Stimuli;
  
end architecture Testbench;