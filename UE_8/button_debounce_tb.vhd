library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity button_debounce_tb is
end entity button_debounce_tb;

architecture testbench of button_debounce_tb is

  constant CLK_FREQUENCY : integer := 50e6; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f
  
  signal reset : std_ulogic := '0';
  signal clk : std_ulogic := '0';
  signal button_input, debounce_output : std_ulogic;

  constant DEBOUNCE_TIME_MS : natural := 20;
  constant PWM_PERIOD_MS : positive := 1;

  constant PWM_PERIOD_COUNT : natural := (1 / 1000) / (1 / CLK_FREQUENCY);
  constant PWM_BIT_WIDTH : natural := integer( ceil(log2(real( PWM_PERIOD_COUNT ))) ); 

  signal pwm_on, pwm_period : unsigned(PWM_BIT_WIDTH - 1 downto 0);
begin
  
  pwm_period <= to_unsigned(PWM_PERIOD_COUNT, PWM_BIT_WIDTH);

  PWM: entity work.pwm(rtl) generic map (
    PWM_BIT_WIDTH => COUNTER_LEN
  ) port map (
    clk => clk_i,
    reset => reset_i,
    pwm_period => Period_counter_val_i,
    pwm_on => ON_counter_val_i,
    button_input => PWM_pin_o
  );

  button_debounce: entity work.pwm(rtl) generic map (
    CLK_FREQUENCY_HZ => CLK_FREQUENCY,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk => clk_i,
    reset => reset_i,
    button_input => button_i,
    debounce_output => debounce_o
  );

  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin

  wait;

  end process Stimuli;
end architecture testbench;