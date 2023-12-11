library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of delta_adc is
  -- Derive Bitlength for internal signals from given generics
  constant STROBE_BIT_WIDTH: natural := integer( ceil(log2(real( SAMPLING_PERIOD ))) );
  -- ADC_BIT_WIDTH corresponds to the Sampling period (log2(Sampling_Period)) but must be given as a generic
  constant ADC_MAX_VALUE: unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(PWM_PERIOD, ADC_BIT_WIDTH);

  signal sampling_strobe, next_adc_valid_strobe : std_ulogic;
  signal adc_value, next_adc_value : unsigned(ADC_BIT_WIDTH - 1 downto 0);
begin

  Sampling_Strobe_Module: entity work.strobe_generator(rtl) generic map(
    STROBE_PERIOD => SAMPLING_PERIOD 
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    strobe_o => sampling_strobe
  );

  PWM_Module: entity work.PWM(rtl) generic map(
    COUNTER_LEN => ADC_BIT_WIDTH 
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => ADC_MAX_VALUE,
    ON_counter_val_i => adc_value,
    PWM_pin_o => PWM_o
  );

  Clock: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      adc_value <= (others => '0');
    elsif rising_edge(clk_i) then
      adc_value <= next_adc_value;
      adc_valid_strobe_o <= next_adc_valid_strobe;
    end if;
  end process Clock;

  adc_value_o <= adc_value;

  Sampler: process(sampling_strobe, adc_value)
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