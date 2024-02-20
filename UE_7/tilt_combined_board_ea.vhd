library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Libraries
use work.tilt_package.all;
use work.servo_package.all;

entity tilt_xy_board is
  port (
    -- Inputs
    signal enable_filter_i : in std_ulogic;
    signal clk_i, reset_i : in std_ulogic;
    -- Axis Inputs
    signal x_comp_async_i, y_comp_async_i : in std_ulogic;
    -- Outputs
    signal x_pwm_pin_o, y_pwm_pin_o : out std_ulogic;
    signal x_servo_pwm_pin_o, y_servo_pwm_pin_o : out std_ulogic;
    -- 3x Outputs for each 7seg Display (for on Axis) (6 in Total)
    signal x_LED_X00_o, x_LED_0X0_o, x_LED_00X_o : out std_ulogic_vector(0 to 6);
    signal y_LED_X00_o, y_LED_0X0_o, y_LED_00X_o : out std_ulogic_vector(0 to 6)
  );
end entity tilt_xy_board;

architecture rtl of tilt_xy_board is
  signal reset, enable_filter : std_ulogic;
begin

  reset <= not reset_i;

  -- Entprellung des Filter-Switches
  Synchronizer : entity work.sync_chain(rtl) generic map (
    CHAIN_LENGTH => 2
    ) port map (
    clk_i => clk_i,
    reset_i => reset,
    Async_i => enable_filter_i,
    Sync_o => enable_filter
    );

  TiltX : entity work.tilt_board(rtl) port map (
    enable_filter_i => enable_filter,
    clk_i => clk_i,
    reset_i => reset,
    axis_comp_async_i => x_comp_async_i,
    axis_pwm_pin_o => x_pwm_pin_o,
    axis_servo_pwm_pin_o => x_servo_pwm_pin_o,
    LED_X00_o => x_LED_X00_o,
    LED_0X0_o => x_LED_0X0_o,
    LED_00X_o => x_LED_00X_o
    );

  TiltY : entity work.tilt_board(rtl) port map (
    enable_filter_i => enable_filter,
    clk_i => clk_i,
    reset_i => reset,
    axis_comp_async_i => y_comp_async_i,
    axis_pwm_pin_o => y_pwm_pin_o,
    axis_servo_pwm_pin_o => y_servo_pwm_pin_o,
    LED_X00_o => y_LED_X00_o,
    LED_0X0_o => y_LED_0X0_o,
    LED_00X_o => y_LED_00X_o
    );

end architecture rtl;