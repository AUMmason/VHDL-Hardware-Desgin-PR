library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity tilt_debug_tb is
end entity tilt_debug_tb;

architecture testbench of tilt_debug_tb is

  constant CLK_FREQUENCY : integer := 50e6; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal clk, reset : std_ulogic := '0';
  
  signal sw_enable_debug_mode, sw_select_axis : std_ulogic := '1';
  signal sw_select_increment_amount : std_ulogic;

  signal btn_increase, btn_decrease : std_ulogic := '0';

  signal axis_pwm_pin : std_ulogic;
  signal axis_servo_pwm_pin : std_ulogic;

  signal LED_X00, LED_0X0, LED_00X : std_ulogic_vector(0 to 6);
  signal debug_led : std_ulogic;
begin

  tilt_debug: entity work.tilt_debug(rtl) port map (
    clk_i => clk,
    reset_i => reset,
    axis_pwm_pin_o => axis_pwm_pin,
    axis_servo_pwm_pin_o => axis_servo_pwm_pin,

    sw_enable_debug_mode_i => sw_enable_debug_mode,
    sw_select_axis_i => sw_select_axis,
    sw_select_increment_amount_i => sw_select_increment_amount,
    btn_increase_i => btn_increase,
    btn_decrease_i => btn_decrease,
    debug_led_o => debug_led,

    LED_X00_o => LED_X00,
    LED_0X0_o => LED_0X0,
    LED_00X_o => LED_00X
  );

  clk <= not clk after CLK_PERIOD / 2;
  


  Stimuli: process is -- Sim Time: ~ 1760 ms
  begin
    reset <= '1';
    btn_decrease <= '0';
    sw_select_increment_amount <= '0';

    wait for 50 us;

    reset <= '0';

    wait for 200 us;

    btn_increase <= '1';

    wait for 250 us;

    btn_increase <= '0';

    wait for 500 us;

    sw_select_increment_amount <= '1';

    wait for 41 ms;

    btn_increase <= not btn_increase after 500 us; -- Used to trigger an increase more times

    wait for 600 ms;

    btn_increase <= '0';

    wait for 50 ms;

    sw_select_increment_amount <= '0';
    btn_decrease <= '1';

    wait for 500 us;
    
    btn_decrease <= '0';
    
    wait for 42 ms;
    
    sw_select_increment_amount <= '1';
    btn_decrease <= not btn_decrease after 500 us; -- Used to trigger a decrease more times

    wait for 1015 ms;

    btn_decrease <= '0';

    wait for 5 ms;

    wait;

  end process Stimuli;
end architecture testbench;