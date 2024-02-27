library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Package
use work.tilt_package.all;

-- Updated version of delta_adc module which also outputs a pwm signal for debug purposes.

entity delta_adc_debug is
  generic (
    PWM_PERIOD : natural;
    SAMPLING_PERIOD : natural;
    ADC_BIT_WIDTH : natural
  );
  port (
    signal clk_i, reset_i, comparator_i : in std_ulogic;
    signal adc_valid_strobe_o : out std_ulogic;
    signal debug_adc_value_i : in unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal pwm_o, pwm_debug_o : out std_ulogic;
    signal adc_value_o : out unsigned(ADC_BIT_WIDTH - 1 downto 0)
  );
end entity delta_adc_debug;

architecture rtl of delta_adc_debug is
  -- ADC_BIT_WIDTH corresponds to the Sampling period (log2(Sampling_Period)) but must be given as a generic
  constant ADC_MAX_VALUE : unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(PWM_PERIOD, ADC_BIT_WIDTH);
  signal sampling_strobe, next_adc_valid_strobe : std_ulogic;
  signal adc_value, next_adc_value : unsigned(ADC_BIT_WIDTH - 1 downto 0);
begin

  sampling_strobe_module : entity work.strobe_generator(rtl) generic map(
    STROBE_PERIOD => SAMPLING_PERIOD
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    strobe_o => sampling_strobe
    );

  pwm_debug : entity work.PWM(rtl) generic map (
    COUNTER_LEN => ADC_BIT_WIDTH
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => ADC_MAX_VALUE,
    ON_counter_val_i => debug_adc_value_i,
    PWM_pin_o => pwm_debug_o
    );

  pwm_adc : entity work.PWM(rtl) generic map(
    COUNTER_LEN => ADC_BIT_WIDTH
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => ADC_MAX_VALUE,
    ON_counter_val_i => adc_value,
    PWM_pin_o => pwm_o
    );

  Clock : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      adc_value <= (others => '0');
    elsif rising_edge(clk_i) then
      adc_value <= next_adc_value;
      adc_valid_strobe_o <= next_adc_valid_strobe;
    end if;
  end process Clock;

  adc_value_o <= adc_value;

  Sampler : process (sampling_strobe, adc_value, comparator_i)
    -- The sampling strobe is being sent multiple times during a PWM-Period
    -- and updates the current ADC value each time.
  begin
    next_adc_value <= adc_value;

    if sampling_strobe = '1' then
      next_adc_valid_strobe <= '1'; -- set adc_valid_strobe = '1' after adc_value is registered
      if comparator_i = '1' and adc_value < ADC_MAX_VALUE then
        next_adc_value <= adc_value + to_unsigned(1, ADC_BIT_WIDTH);
      elsif comparator_i = '0' and adc_value > 0 then
        next_adc_value <= adc_value - to_unsigned(1, ADC_BIT_WIDTH);
      end if;
    else
      next_adc_valid_strobe <= '0';
    end if;
  end process Sampler;

end architecture rtl;