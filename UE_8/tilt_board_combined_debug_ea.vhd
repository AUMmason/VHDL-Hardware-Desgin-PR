library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Internal Packages
use work.tilt_package.all;
use work.servo_package.all;

entity tilt_board_combined_debug is
  port (
    -- Inputs:
    --  Board Signals
    signal clk_i, reset_i : in std_ulogic;
    --  Switches:
    signal sw_enable_debug_mode_i : in std_ulogic;
    signal sw_select_axis_i : in std_ulogic;
    signal sw_select_increment_amount_i : in std_ulogic;
    signal sw_enable_filter_i : in std_ulogic;
    --  Buttons:
    signal btn_increase_i : in std_ulogic;
    signal btn_decrease_i : in std_ulogic;
    --  Input Signals:
    signal x_comp_async_i, y_comp_async_i : in std_ulogic;

    -- Outputs:
    --  Comparison Voltage for X and Y
    signal x_pwm_pin_o, y_pwm_pin_o : out std_ulogic;
    --  Servo Signal Output for X and Y
    signal x_servo_pwm_pin_o, y_servo_pwm_pin_o : out std_ulogic;
    --  3x Outputs for each 7seg Display (for on Axis) (6 in Total)
    signal x_LED_X00_o, x_LED_0X0_o, x_LED_00X_o : out std_ulogic_vector(0 to 6);
    signal y_LED_X00_o, y_LED_0X0_o, y_LED_00X_o : out std_ulogic_vector(0 to 6);
    --  Debug Mode LED
    signal debug_led_o : out std_ulogic
  );
end entity tilt_board_combined_debug;

architecture rtl of tilt_board_combined_debug is
  constant ADC_BIT_WIDTH : natural := integer(ceil(log2(real(ADC_VALUE_RANGE))));

  signal reset, btn_increase, btn_decrease : std_ulogic;
  signal enable_filter : std_ulogic;

  signal enable_debug_mode : std_ulogic;
  signal debug_adc_valid_strobe : std_ulogic;
  signal debug_adc_value_x, debug_adc_value_y : unsigned(ADC_BIT_WIDTH - 1 downto 0);
begin

  -- * Assign other Output Signals
  debug_led_o <= enable_debug_mode;

  -- * Invert all Input Buttons
  reset <= not reset_i;
  btn_increase <= not btn_increase_i;
  btn_decrease <= not btn_decrease_i;

  -- Other Inputs get debounced in button_control
  -- ? @Tutor: Should the reset button also be debounced?
  debounce_enable_filter_sw : entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => BOARD_CLOCK_FREQ,
    DEBOUNCE_TIME_MS => BTN_DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset,
    button_i => sw_enable_filter_i,
    debounce_o => enable_filter
    );

  button_control : entity work.button_control(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH,
    DEBOUNCE_TIME_MS => BTN_DEBOUNCE_TIME_MS,
    CLOCK_FREQUENCY_HZ => BOARD_CLOCK_FREQ
    ) port map (
    clk_i => clk_i,
    reset_i => reset,

    sw_enable_debug_mode_i => sw_enable_debug_mode_i,
    sw_select_axis_i => sw_select_axis_i,
    sw_select_increment_amount_i => sw_select_increment_amount_i,
    btn_increase_i => btn_increase,
    btn_decrease_i => btn_decrease,

    enable_debug_mode_o => enable_debug_mode,
    adc_value_x_o => debug_adc_value_x,
    adc_value_y_o => debug_adc_value_y,
    adc_valid_strobe_o => debug_adc_valid_strobe
    );

  tilt_board_debug_x : entity work.tilt_board_debug(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
    ) port map (
    clk_i => clk_i,
    reset_i => reset,

    debug_mode_enabled_i => enable_debug_mode,
    debug_enable_filter_i => enable_filter,
    debug_adc_value_i => debug_adc_value_x,
    debug_adc_valid_strobe_i => debug_adc_valid_strobe,

    axis_comp_async_i => x_comp_async_i,
    axis_pwm_pin_o => x_pwm_pin_o,
    axis_servo_pwm_pin_o => x_servo_pwm_pin_o,

    LED_X00_o => x_LED_X00_o,
    LED_0X0_o => x_LED_0X0_o,
    LED_00X_o => x_LED_00X_o
    );

  tilt_board_debug_y : entity work.tilt_board_debug(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
    ) port map (
    clk_i => clk_i,
    reset_i => reset,

    debug_mode_enabled_i => enable_debug_mode,
    debug_enable_filter_i => enable_filter,
    debug_adc_value_i => debug_adc_value_y,
    debug_adc_valid_strobe_i => debug_adc_valid_strobe,

    axis_comp_async_i => y_comp_async_i,
    axis_pwm_pin_o => y_pwm_pin_o,
    axis_servo_pwm_pin_o => y_servo_pwm_pin_o,

    LED_X00_o => y_LED_X00_o,
    LED_0X0_o => y_LED_0X0_o,
    LED_00X_o => y_LED_00X_o
    );

end architecture rtl;