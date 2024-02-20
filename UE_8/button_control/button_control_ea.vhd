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
    CLOCK_FREQUENCY_HZ : natural
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
  signal sw_enable_debug_mode, sw_select_axis, sw_select_increment_amount : std_ulogic;
  signal btn_increase, btn_decrease : std_ulogic;
  signal increase_x, increase_y, decrease_x, decrease_y : std_ulogic;
  signal adc_valid_strobe, adc_valid_strobe_next : std_ulogic;
  signal sw_enable_debug_mode_prev : std_ulogic;

begin

  enable_debug_mode_o <= sw_enable_debug_mode;
  adc_valid_strobe_o <= adc_valid_strobe;

  clk : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      adc_valid_strobe <= '0';
    elsif rising_edge(clk_i) then
      adc_valid_strobe <= adc_valid_strobe_next;
      sw_enable_debug_mode_prev <= sw_enable_debug_mode;
    end if;
  end process clk;

  strobe : process (btn_increase, btn_decrease, adc_valid_strobe, sw_enable_debug_mode, sw_enable_debug_mode_prev)
  begin
    adc_valid_strobe_next <= adc_valid_strobe;
    if sw_enable_debug_mode = '1' and sw_enable_debug_mode_prev = '0' then
      -- Send valid strobe in order to update current ADC values to debug ADC values when enabling debug mode
      adc_valid_strobe_next <= '1';
    else
      -- Update on increase / decrease
      if (btn_increase = '1' or btn_decrease = '1') and adc_valid_strobe = '0' then
        adc_valid_strobe_next <= '1';
      else
        adc_valid_strobe_next <= '0';
      end if;
    end if;
  end process;

  increase_x <= '1' when btn_increase = '1' and sw_select_axis = '0' else
                '0';
  increase_y <= '1' when btn_increase = '1' and sw_select_axis = '1' else
                '0';
  decrease_x <= '1' when btn_decrease = '1' and sw_select_axis = '0' else
                '0';
  decrease_y <= '1' when btn_decrease = '1' and sw_select_axis = '1' else
                '0';

  increment_control_x : entity work.increment_control generic map (
    BIT_WIDTH => ADC_BIT_WIDTH,
    INCREMENT_VALUE => ADC_INCREMENT_DEBUG,
    MULTIPLIER_VALUE => ADC_INCREMENT_MULTIPLIER_DEBUG,
    MIN_VALUE => ADC_VALUE_0_DEG,
    MAX_VALUE => ADC_VALUE_180_DEG,
    DEFAULT_VALUE => DEFAULT_ADC_VALUE_DEBUG
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    multiply_increment_i => sw_select_increment_amount,
    increase_i => increase_x,
    decrease_i => decrease_x,
    value_o => adc_value_x_o
    );

  increment_control_y : entity work.increment_control generic map (
    BIT_WIDTH => ADC_BIT_WIDTH,
    INCREMENT_VALUE => ADC_INCREMENT_DEBUG,
    MULTIPLIER_VALUE => ADC_INCREMENT_MULTIPLIER_DEBUG,
    MIN_VALUE => ADC_VALUE_0_DEG,
    MAX_VALUE => ADC_VALUE_180_DEG,
    DEFAULT_VALUE => DEFAULT_ADC_VALUE_DEBUG
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    multiply_increment_i => sw_select_increment_amount,
    increase_i => increase_y,
    decrease_i => decrease_y,
    value_o => adc_value_y_o
    );

  -- Synchronize Input Switches
  debounce_sw_enable_debug_mode : entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_enable_debug_mode_i,
    debounce_o => sw_enable_debug_mode
    );

  debounce_sw_select_axis : entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => sw_select_axis_i,
    debounce_o => sw_select_axis
    );

  debounce_sw_select_increment_amount : entity work.debounce(rtl) generic map (
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

  debounce_btn_increase : entity work.debounce_to_strobe(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_increase_i,
    strobe_o => btn_increase
    );

  debounce_btn_decrease : entity work.debounce_to_strobe(rtl) generic map (
    CLK_FREQUENCY_HZ => CLOCK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => btn_decrease_i,
    strobe_o => btn_decrease
    );

end architecture rtl;