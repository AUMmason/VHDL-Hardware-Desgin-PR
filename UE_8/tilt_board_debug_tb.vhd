library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity tilt_board_debug_tb is
end entity tilt_board_debug_tb;

architecture testbench of tilt_board_debug_tb is
  constant ADC_BIT_WIDTH : natural := integer(ceil(log2(real(ADC_VALUE_RANGE))));
  constant CLK_FREQUENCY : integer := 50e6; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal clk, reset : std_ulogic := '0';

  -- Debug Settings
  signal sw_enable_debug_mode : std_ulogic;
  signal sw_select_axis : std_ulogic := '1';
  signal sw_select_increment_amount : std_ulogic;
  signal btn_increase : std_ulogic;
  signal btn_decrease : std_ulogic;

  signal enable_debug_mode, debug_adc_valid_strobe : std_ulogic;
  signal debug_adc_value_axis : unsigned(ADC_BIT_WIDTH - 1 downto 0);

  -- Other board settings
  signal enable_filter : std_ulogic := '1';
  signal axis_comp_async : std_ulogic;
  signal axis_pwm_pin : std_ulogic;
  signal axis_servo_pwm_pin : std_ulogic;

  signal LED_X00, LED_0X0, LED_00X : std_ulogic_vector(0 to 6);

  -- Signal used to control btn_increase / btn_decrease
  signal btn_increase_control, btn_decrease_control : std_ulogic := '0';
begin

  button_control : entity work.button_control(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH,
    DEBOUNCE_TIME_MS => 20,
    CLOCK_FREQUENCY_HZ => CLK_FREQUENCY
    ) port map (
    clk_i => clk,
    reset_i => reset,

    sw_enable_debug_mode_i => sw_enable_debug_mode,
    sw_select_axis_i => sw_select_axis,
    sw_select_increment_amount_i => sw_select_increment_amount,

    btn_increase_i => btn_increase,
    btn_decrease_i => btn_decrease,

    enable_debug_mode_o => enable_debug_mode,
    adc_value_x_o => debug_adc_value_axis,
    adc_value_y_o => open,
    adc_valid_strobe_o => debug_adc_valid_strobe
    );

  tilt_board_debug : entity work.tilt_board_debug(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
    ) port map (
    clk_i => clk,
    reset_i => reset,

    debug_mode_enabled_i => enable_debug_mode,
    debug_enable_filter_i => enable_filter,
    debug_adc_value_i => debug_adc_value_axis,
    debug_adc_valid_strobe_i => debug_adc_valid_strobe,

    axis_comp_async_i => axis_comp_async,
    axis_pwm_pin_o => axis_pwm_pin,
    axis_servo_pwm_pin_o => axis_servo_pwm_pin,

    LED_X00_o => LED_X00,
    LED_0X0_o => LED_0X0,
    LED_00X_o => LED_00X
    );

  btn_increase <= not btn_increase after 500 us when btn_increase_control = '1' else
                  '0';
  btn_decrease <= not btn_decrease after 500 us when btn_decrease_control = '1' else
                  '0';
  clk <= not clk after CLK_PERIOD / 2;

  Stimuli_1 : process is
  begin
    reset <= '1';
    sw_select_increment_amount <= '0';
    sw_select_axis <= '1';
    sw_enable_debug_mode <= '0';

    wait for 500 us;

    sw_enable_debug_mode <= '1';
    reset <= '0';

    wait for 500 us;

    btn_increase_control <= '1';

    wait for 100 ms;

    sw_select_increment_amount <= '1';

    wait for 250 ms;

    sw_enable_debug_mode <= '0'; -- Disable Debug Mode!

    wait for 200 ms;

    sw_enable_debug_mode <= '1';

    wait for 300 ms;

    btn_increase_control <= '0'; -- Stop Increase

    wait for 50 ms;

    sw_select_increment_amount <= '0'; -- Reset Multiplier to 1
    btn_decrease_control <= '1';

    wait for 100 ms;

    sw_select_increment_amount <= '1';
    btn_decrease_control <= '1';

    wait for 1100 ms;

    btn_decrease_control <= '0';

    wait;
  end process;

  Stimuli_2 : process is
  begin

    wait for 50 ns;

    axis_comp_async <= '1';

    wait for 500 ms;

    enable_filter <= '0';

    wait for 250 ms;

    enable_filter <= '1';

    wait for 4750 ms;

    axis_comp_async <= '0';
    wait for 5500 ms;

    wait;

  end process;

end architecture testbench;