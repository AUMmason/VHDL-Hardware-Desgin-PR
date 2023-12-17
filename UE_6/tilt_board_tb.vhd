library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity tilt_board_tb is
end entity tilt_board_tb;

architecture testbench of tilt_board_tb is

  constant INPUT_MAX : natural := 2000;
  constant BIT_WIDTH : natural := integer( ceil(log2(real( INPUT_MAX ))) );
  constant CLK_FREQUENCY : integer := 50e6; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal enable_filter : std_ulogic := '1';
  signal clk, reset : std_ulogic := '0';
  
  signal axis_comp_async : std_ulogic;
  signal axis_pwm_pin : std_ulogic;
  signal axis_servo_pwm_pin : std_ulogic;

  signal LED_X00, LED_0X0, LED_00X : std_ulogic_vector(0 to 6);
begin

  TiltX: entity work.tilt_board(rtl) port map (
    enable_filter_i => enable_filter,
    clk_i => clk,
    reset_i => reset,
    axis_comp_async_i => axis_comp_async,
    axis_pwm_pin_o => axis_pwm_pin,
    axis_servo_pwm_pin_o => axis_servo_pwm_pin,
    
    LED_X00_o => LED_X00,
    LED_0X0_o => LED_0X0,
    LED_00X_o => LED_00X
  );

  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin
    -- report std_ulogic'image(signal);
    reset <= '1';
    axis_comp_async <= '1';
    
    wait for 100 ns;
    reset <= '0';
    
    axis_comp_async <= '1';
    wait for 2500 ms;

    enable_filter <= '0';
    wait for 500 ms;
    
    enable_filter <= '1';
    wait for 2000 ms;

    axis_comp_async <= '0';
    wait for 2500 ms;

    enable_filter <= '0';
    wait for 500 ms;
    
    enable_filter <= '1';
    wait for 2000 ms;
    wait;

  end process Stimuli;
end architecture testbench;