library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end entity pwm_tb;

architecture stimuli of pwm_tb is
  constant CLK_FREQENCY: integer := 50; -- 50 Hz
  constant CLK_PERIOD: time := 1000 ms / CLK_FREQENCY; -- T = 1/f

  constant COUNTER_LEN: integer := 4;
  signal clk, reset, PWM_pin: std_ulogic;
  signal ON_counter_val: unsigned(COUNTER_LEN - 1 downto 0) := "0011";
  signal Period_counter_val: unsigned(COUNTER_LEN - 1 downto 0) := "1111";
begin
  
  PWM_Module: entity work.PWM(rtl) generic map(
    COUNTER_LEN => COUNTER_LEN
  ) port map (
    clk_i => clk,
    reset_i => reset,
    Period_counter_val_i => Period_counter_val,
    ON_counter_val_i => ON_counter_val,
    PWM_pin_o => PWM_pin
  )

  reset <= '0';
  clk <= '0';
  clk <= not clk after CLK_PERIOD / 2;

  wait for 500 ms;

  reset <= '1';

  wait for 50 ms;

  reset <= '0';

end architecture stimuli;