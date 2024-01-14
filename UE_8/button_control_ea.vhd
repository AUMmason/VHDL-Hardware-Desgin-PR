library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Packages
use work.servo_package.all;
use work.tilt_package.all;

-- Central module for performing actions in debug mode and to turn on/off certain modules:
-- 1. Enable / Disable Debug Mode
-- 1.1. Select Axis for Debug Mode
-- 1.2. Select increment amount for pressing Buttons in Debug Mode
-- 1.3. Increase / Decrease current ADC-Value
-- 2. Enable / Disable Moving Average Filter

entity button_control is
  generic (
    ADC_BIT_WIDTH : natural
  );
  port (
    -- Inputs:
    -- Switches
    signal sw_enable_filter_i, sw_enable_debug_mode_i, sw_select_axis_i, sw_select_increment_amount_i : in std_ulogic;
    -- Buttons
    signal btn_increase_i, btn_decrease_i : in std_ulogic; -- Reset Button is handled in top-level-entity
    -- Board Signals
    signal clk_i, reset_i : in std_ulogic;
    -- Outputs:
    signal debug_led_o : out std_ulogic; -- Led to show that debug mode is enabled!
    signal adc_value_x_o, adc_value_y_o : out unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal adc_valid_strobe_o : out std_ulogic;
    signal enable_filter_o : out std_ulogic
  );
end entity button_control;

architecture rtl of button_control is
  constant DEBOUNCE_TIME_MS : natural := 20; -- 20 ms
  constant ADC_INCREMENT : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(1, ADC_BIT_WIDTH);
  constant ADC_INCREMENT_MULTIPLIER : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(10, ADC_BIT_WIDTH);
  -- The 2 constants below are not in a package because similar names are used in other files
  constant ADC_MAX_VALUE : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(ADC_VALUE_RANGE, ADC_BIT_WIDTH);
  constant ADC_MIN_VALUE : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(0, ADC_BIT_WIDTH);
  
  signal sw_enable_filter, sw_enable_debug_mode, sw_select_axis, sw_select_increment_amount : std_ulogic;
  signal btn_increase, btn_decrease : std_ulogic;

  signal adc_value_x, adc_value_y : unsigned(ADC_BIT_WIDTH - 1 downto 0);

  impure function set_adc_value(
    total_value, increment_value, factor: unsigned(ADC_BIT_WIDTH - 1 downto 0);
    enable_factor, increase, decrease: std_ulogic) 
  return unsigned is
    variable total : unsigned(ADC_BIT_WIDTH - 1 downto 0) := total_value;
    variable value : unsigned(ADC_BIT_WIDTH - 1 downto 0) := increment_value;
  begin
    if enable_factor = '1' then 
      value := resize(value * factor, ADC_BIT_WIDTH);
    end if;
    -- Assuming that only one button will be pressed at a time!
    if increase = '1' then
      if total + value <= ADC_MAX_VALUE then
        total := total + value;
      else 
        total := ADC_MAX_VALUE;
      end if;
    elsif decrease = '1' then
      if total - value >= ADC_MIN_VALUE then
        total := total - value;
      else 
        total := ADC_MIN_VALUE;
      end if;
    end if;

    return total;
  end function;
begin
  debug_led_o <= sw_enable_debug_mode;
  adc_value_x_o <= adc_value_x;
  adc_value_y_o <= adc_value_y;
  enable_filter_o <= sw_enable_filter;

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      -- TODO: Maybe change this later to an angle where the ball can be balanced better! Initialize with values corresponding to 0 degress = 150
      adc_value_x <= to_unsigned(175, ADC_BIT_WIDTH); -- 90°
      adc_value_y <= to_unsigned(175, ADC_BIT_WIDTH); -- 90°
    end if;
  end process clk;

  -- Note: a Process was chosen for processing increases/decreases in adc_values since the code is more well arranged!
  btn_actions: process(sw_select_axis, sw_enable_debug_mode, sw_select_increment_amount, btn_increase, btn_decrease)
  begin
    if sw_enable_debug_mode = '1' then      
      if sw_select_axis = '1' then -- X-Axis is selected
        adc_value_x <= set_adc_value(adc_value_x, ADC_INCREMENT, ADC_INCREMENT_MULTIPLIER, sw_select_increment_amount, btn_increase, btn_decrease);
      else -- Y-Axis is selected
        adc_value_y <= set_adc_value(adc_value_y, ADC_INCREMENT, ADC_INCREMENT_MULTIPLIER, sw_select_increment_amount, btn_increase, btn_decrease);
      end if;
    end if;
  end process btn_actions;

  strobe_generator: entity work.strobe_generator(rtl) generic map (
    STROBE_PERIOD => CLOCK_FREQ / DELTA_ADC_SAMPLING_FREQ
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    strobe_o => adc_valid_strobe_o
  );

  -- Synchronize Input Switches
  debounce_sw_enable_filter: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_enable_filter_i,
    debounce_o => sw_enable_filter 
  );

  debounce_sw_enable_debug_mode: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_enable_debug_mode_i,
    debounce_o => sw_enable_debug_mode 
  );

  debounce_sw_select_axis: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_select_axis_i,
    debounce_o => sw_select_axis
  );

  debounce_sw_select_increment_amount: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_select_increment_amount_i,
    debounce_o => sw_select_increment_amount
  );

  -- Debounce Input Buttons:
  -- * Note: Button Inputs on the board are inverted, the input signals do NOT get inverted here.
  -- * They are inverted in the top-level-entity.
  
  debounce_btn_increase: entity work.debounce_to_strobe(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_increase_i,
    strobe_o => btn_increase
  );
  
  debounce_btn_decrease: entity work.debounce_to_strobe(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_decrease_i,
    strobe_o => btn_decrease
  );

end architecture rtl; 