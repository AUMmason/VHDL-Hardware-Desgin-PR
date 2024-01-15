library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity debounce_tb is
end entity debounce_tb;

architecture testbench of debounce_tb is

  constant CLK_FREQUENCY : integer := 50e6; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f
  
  signal reset : std_ulogic := '0';
  signal clk : std_ulogic := '0';
  signal button_input, debounce_output : std_ulogic;

  constant DEBOUNCE_TIME_MS : natural := 20;
  constant PWM_PERIOD_MS : positive := 1;

  constant PWM_PERIOD_COUNT : natural := CLK_FREQUENCY / 10000; -- pwm Signal with one 100 us period
  constant PWM_BIT_WIDTH : natural := integer( ceil(log2( real(PWM_PERIOD_COUNT) )) ); 

  signal pwm_on, pwm_period : unsigned(PWM_BIT_WIDTH - 1 downto 0);
begin
  
  pwm_period <= to_unsigned(PWM_PERIOD_COUNT, PWM_BIT_WIDTH);

  PWM: entity work.pwm(rtl) generic map (
    COUNTER_LEN => PWM_BIT_WIDTH
  ) port map (
    clk_i => clk,
    reset_i => reset ,
    Period_counter_val_i => pwm_period,
    ON_counter_val_i => pwm_on,
    PWM_pin_o => button_input 
  );

  debounce: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLK_FREQUENCY,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk,
    reset_i => reset,
    button_i => button_input,
    debounce_o => debounce_output 
  );

  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin

    -- Pulse with Chatter in front:

    pwm_on <= to_unsigned(0, PWM_BIT_WIDTH);

    wait for 500 us;

    pwm_on <= to_unsigned((CLK_FREQUENCY / 10000)/2, PWM_BIT_WIDTH); -- 50 us

    wait for 500 us;

    pwm_on <= to_unsigned(PWM_PERIOD_COUNT, PWM_BIT_WIDTH);

    wait for 1 ms;

    pwm_on <= to_unsigned(0, PWM_BIT_WIDTH);

    wait for 22 ms;

    -- Pulse with chatter on press and release of button that shows
    -- that after the button is unpressed for the next 20 ms the
    -- new button presses have no effect.

    pwm_on <= to_unsigned((CLK_FREQUENCY / 10000)/2, PWM_BIT_WIDTH); -- 50 us

    wait for 1 ms;

    pwm_on <= to_unsigned(PWM_PERIOD_COUNT, PWM_BIT_WIDTH);

    wait for 1 ms;

    pwm_on <= to_unsigned((CLK_FREQUENCY / 10000)/2, PWM_BIT_WIDTH); -- 50 us

    wait for 1 ms;

    pwm_on <= to_unsigned(0, PWM_BIT_WIDTH);

    wait for 22 ms;

    -- Pulse with chatter on press and release of button

    pwm_on <= to_unsigned((CLK_FREQUENCY / 10000)/2, PWM_BIT_WIDTH); -- 50 us

    wait for 2 ms;

    pwm_on <= to_unsigned(PWM_PERIOD_COUNT, PWM_BIT_WIDTH);

    wait for 30 ms;

    pwm_on <= to_unsigned((CLK_FREQUENCY / 10000)/2, PWM_BIT_WIDTH); -- 50 us

    wait for 2 ms;

    pwm_on <= to_unsigned(0, PWM_BIT_WIDTH);

    wait for 22 ms;

  wait;

  end process Stimuli;
end architecture testbench;