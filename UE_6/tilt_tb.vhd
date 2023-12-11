library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity tilt_tb is
end entity tilt_tb;

architecture Testbench of tilt_tb is
  constant CLK_FREQUENCY : integer := 50e6; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f
  
  constant ADC_BIT_WIDTH : natural := integer( ceil(log2(real( ADC_VALUE_RANGE ))) );
  constant PWM_BIT_WIDTH : natural := integer( ceil(log2(real( SERVO_SIGNAL_MAX ))) );

  signal clk, reset : std_ulogic := '0';
  signal adc_value : unsigned(ADC_BIT_WIDTH - 1 downto 0);
  signal pwm_on : unsigned(PWM_BIT_WIDTH - 1 downto 0);
begin
  
  Tilt: entity work.tilt(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH,
    SERVO_BIT_WIDTH => PWM_BIT_WIDTH
  ) port map (
    clk_i => clk,
    reset_i => reset,
    adc_value_i => adc_value,
    pwm_on_o => pwm_on
  );
  
  clk <= not clk after CLK_PERIOD / 2;

  Stimuli: process is
  begin
    adc_value <= to_unsigned(0, ADC_BIT_WIDTH);
    reset <= '1';
    
    wait for 20 ns;
    reset <= '0';

    wait for 80 ns;
    adc_value <= to_unsigned(50, ADC_BIT_WIDTH);

    wait for 100 ns;
    adc_value <= to_unsigned(100, ADC_BIT_WIDTH);


    wait for 10 ns;
    adc_value <= to_unsigned(105, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(112, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(117, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(121, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(125, ADC_BIT_WIDTH); -- 90°

    wait for 10 ns;
    adc_value <= to_unsigned(132, ADC_BIT_WIDTH);
    
    wait for 10 ns;
    adc_value <= to_unsigned(138, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(143, ADC_BIT_WIDTH);

    wait for 10 ns;
    adc_value <= to_unsigned(147, ADC_BIT_WIDTH);


    wait for 10 ns;
    adc_value <= to_unsigned(150, ADC_BIT_WIDTH);

    wait for 100 ns;
    adc_value <= to_unsigned(200, ADC_BIT_WIDTH);

    wait for 100 ns;
    adc_value <= to_unsigned(250, ADC_BIT_WIDTH);

    wait;

  end process Stimuli;
  
end architecture Testbench;