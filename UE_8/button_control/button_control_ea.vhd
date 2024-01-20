library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Packages
use work.tilt_package.all;

-- Central module for performing actions in debug mode and to turn on/off certain modules:
-- 1. Enable / Disable Debug Mode
-- 1.1. Select Axis for Debug Mode
-- 1.2. Select increment amount for pressing Buttons in Debug Mode
-- 1.3. Increase / Decrease current ADC-Value

entity button_control is
  generic (
    ADC_BIT_WIDTH : natural;
    DEBOUNCE_TIME_MS : natural;
    CLOCK_FREQUENCY_HZ : natural;
    DEFAULT_ADC_VALUE : natural -- ? What should the default value be ?
  );
  port (
    -- Inputs:
    -- Switches
    signal sw_enable_debug_mode_i, sw_select_axis_i, sw_select_increment_amount_i : in std_ulogic;
    -- Buttons
    signal btn_increase_i, btn_decrease_i : in std_ulogic; -- Reset Button is handled in top-level-entity
    -- Board Signals
    signal clk_i, reset_i : in std_ulogic;
    -- Outputs:
    signal enable_debug_mode_o : out std_ulogic;
    signal adc_value_x_o, adc_value_y_o : out unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal adc_valid_strobe_o : out std_ulogic
  );
end entity button_control;

architecture rtl of button_control is
  constant ADC_INCREMENT : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(1, ADC_BIT_WIDTH);
  constant ADC_INCREMENT_MULTIPLIER : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(10, ADC_BIT_WIDTH);
  -- The 2 constants below are not in a package because similar names are used in other files
  constant ADC_MAX_VALUE : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(ADC_VALUE_RANGE, ADC_BIT_WIDTH);
  constant ADC_MIN_VALUE : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(0, ADC_BIT_WIDTH);

  signal sw_enable_debug_mode, sw_select_axis, sw_select_increment_amount : std_ulogic;
  signal btn_increase, btn_decrease : std_ulogic;

  signal adc_value_x, adc_value_y, adc_value_x_next, adc_value_y_next : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(DEFAULT_ADC_VALUE, ADC_BIT_WIDTH);
  signal adc_valid_strobe, adc_valid_strobe_next : std_ulogic;

begin -- Architecture

  enable_debug_mode_o <= sw_enable_debug_mode;
  adc_value_x_o <= adc_value_x;
  adc_value_y_o <= adc_value_y;
  adc_valid_strobe_o <= adc_valid_strobe;

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      adc_value_x <= to_unsigned(DEFAULT_ADC_VALUE, ADC_BIT_WIDTH); 
      adc_value_y <= to_unsigned(DEFAULT_ADC_VALUE, ADC_BIT_WIDTH);
      adc_valid_strobe <= '0';
    elsif rising_edge(clk_i) then
      adc_value_x <= adc_value_x_next;
      adc_value_y <= adc_value_y_next;
      adc_valid_strobe <= adc_valid_strobe_next;
    end if;
  end process clk;

  -- @ Tutor, I know the code below is bad! I tried splitting off the increment and decrement functionality into
  -- a function but when synthesizing, it would always result in infered latches for adc_value_x and adc_value_y
  -- registers. This code does not produce any latches as for now and works just fine.
  -- I've added another version of this file to the submission of this assignment, maybe you can find a reason why
  -- I would always get inferred latches. Thank you.

  btn_actions: process(adc_valid_strobe, adc_value_x, adc_value_y, btn_increase, btn_decrease, sw_select_axis, sw_enable_debug_mode, sw_select_increment_amount)
  begin
    adc_valid_strobe_next <= adc_valid_strobe;
    adc_value_x_next <= adc_value_x;
    adc_value_y_next <= adc_value_y;
    
    if sw_select_axis = '1' then
      if btn_increase = '1' then
        if sw_select_increment_amount = '1' then
          if adc_value_x <= ADC_MAX_VALUE - ADC_INCREMENT_MULTIPLIER then
            adc_value_x_next <= adc_value_x + ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_x_next <= ADC_MAX_VALUE; -- clamp to max Value
          end if;
        else 
          if adc_value_x <= ADC_MAX_VALUE - ADC_INCREMENT then
            adc_value_x_next <= adc_value_x + ADC_INCREMENT;
          else 
            adc_value_x_next <= ADC_MAX_VALUE; -- clamp to max Value
          end if;
        end if; 
      elsif btn_decrease = '1' then
        if sw_select_increment_amount = '1' then
          if adc_value_x >= ADC_MIN_VALUE + ADC_INCREMENT_MULTIPLIER then
            adc_value_x_next <= adc_value_x - ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_x_next <= ADC_MIN_VALUE; -- clamp to min Value
          end if;
        else 
          if adc_value_x >= ADC_MIN_VALUE + ADC_INCREMENT then
            adc_value_x_next <= adc_value_x - ADC_INCREMENT;
          else 
            adc_value_x_next <= ADC_MIN_VALUE; -- clamp to min Value
          end if;
        end if;  
      else
        adc_value_x_next <= adc_value_x;
      end if;
    else
      if btn_increase = '1' then
        if sw_select_increment_amount = '1' then
          if adc_value_y <= ADC_MAX_VALUE - ADC_INCREMENT_MULTIPLIER then
            adc_value_y_next <= adc_value_y + ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_y_next <= ADC_MAX_VALUE; -- clamp to max Value
          end if;
        else 
          if adc_value_y <= ADC_MAX_VALUE - ADC_INCREMENT then
            adc_value_y_next <= adc_value_y + ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_y_next <= ADC_MAX_VALUE; -- clamp to max Value
          end if;
        end if; 
      elsif btn_decrease = '1' then
        if sw_select_increment_amount = '1' then
          if adc_value_y >= ADC_MIN_VALUE + ADC_INCREMENT_MULTIPLIER then
            adc_value_y_next <= adc_value_y - ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_y_next <= ADC_MIN_VALUE; -- clamp to min Value
          end if;
        else 
          if adc_value_y >= ADC_MIN_VALUE + ADC_INCREMENT then
            adc_value_y_next <= adc_value_y - ADC_INCREMENT_MULTIPLIER;
          else 
            adc_value_y_next <= ADC_MIN_VALUE; -- clamp to min Value
          end if;
        end if;  
      else
        adc_value_y_next <= adc_value_y;
      end if;
    end if;
    
    -- Send Valid Strobe when Button is pressed or debug mode is activated
    if sw_enable_debug_mode = '0' then -- * Needed for when activating debug mode
      adc_valid_strobe_next <= '1';
    elsif btn_increase = '1' or btn_decrease = '1' then
      adc_valid_strobe_next <= '1';
    else
      adc_valid_strobe_next <= '0';
    end if;
  end process btn_actions;

  -- Synchronize Input Switches
  debounce_sw_enable_debug_mode: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_enable_debug_mode_i,
    debounce_o => sw_enable_debug_mode 
  );

  debounce_sw_select_axis: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_select_axis_i,
    debounce_o => sw_select_axis
  );

  debounce_sw_select_increment_amount: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
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
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_increase_i,
    strobe_o => btn_increase
  );
  
  debounce_btn_decrease: entity work.debounce_to_strobe(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_decrease_i,
    strobe_o => btn_decrease
  );

end architecture rtl; 