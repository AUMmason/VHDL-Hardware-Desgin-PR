library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Packages
use work.servo_package.all;
use work.tilt_package.all;

-- Central module for performing actions in debug mode and to turn on/off certain modules

entity button_control is
  port (
    -- Inputs:
    -- Switches
    signal sw_enable_filter_i, sw_enable_debug_mode_i, sw_select_axis_i, sw_select_increase_amount_i : in std_ulogic;
    -- Buttons
    signal btn_increase_i, btn_decrease_i : in std_ulogic; -- Reset Button is handled in top-level-entity
    -- Board Signals
    signal clk_i, reset_i : in std_ulogic;

    -- Outputs:
    signal debug_led_o : out std_ulogic; -- Led to show that debug mode is enabled!
    signal adc_value_x_o, adc_value_y_o : out std_ulogic;
    signal adc_valid_strobe_o : out std_ulogic
  );
end entity button_control;

architecture rtl of button_control is
  constant DEBOUNCE_TIME_MS : natural := 20; -- 20 ms
  constant ADC_BIT_WIDTH : natural := integer( ceil(log2(real( ADC_VALUE_RANGE ))) ); 
  constant BASE_AMOUNT : natural := 1;
  constant AMOUNT_MULTIPLYER : natural := 10;

  signal sw_enable_filter, sw_enable_debug_mode, sw_select_axis, sw_select_increase_amount : std_ulogic;
  signal btn_increase, btn_decrease : std_ulogic;

  signal adc_value_x, adc_value_y : unsigned(ADC_BIT_WIDTH - 1 downto 0);
  signal adc_valid_strobe : std_ulogic;
begin
  
  debug_led_o <= sw_enable_debug_mode;

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      -- TODO: Maybe change this later to an angle where the ball can be balanced better!
      adc_value_x <= to_unsigned(0, ADC_BIT_WIDTH);
      adc_value_y <= to_unsigned(0, ADC_BIT_WIDTH);
      adc_valid_strobe <= '0';
    elsif rising_edge(clk_i) then
      
    end if;
  end process clk;

  -- TODO implement statement for increasing / decreasing inputs / outpus
  -- Note: a Process was chosen for processing increases/decreases in adc_values since the code is more well arranged!
  btn_actions: process(sw_select_axis, sw_enable_debug_mode, sw_select_increase_amount, btn_increase, btn_decrease)
    variable amount : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(BASE_AMOUNT, ADC_BIT_WIDTH);
  begin
    if sw_enable_debug_mode = '1' then
      if sw_select_increase_amount = '1' then -- Increase ADC-Value by 10
        amount <= resize(amount * to_unsigned(AMOUNT_MULTIPLYER, ADC_BIT_WIDTH))
      else

      end if;

      if sw_select_axis = '1' then -- X-Axis is selected
        adc_value_x <= ...  
      else -- Y-Axis is selected
        adc_value_y <= ...
      end if;
    end if;
  end process btn_actions;

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

  debounce_sw_select_increase_amount: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_select_increase_amount_i,
    debounce_o => sw_select_increase_amount
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