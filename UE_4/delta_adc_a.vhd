library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of delta_adc is
  signal sampling_strobe, next_adc_valid_strobe : std_ulogic;
  signal adc_value, next_adc_value : unsigned(BIT_WIDTH - 1 downto 0);
begin
  
  -- Wiring everthing up:
  Sampling_Strobe_Module: entity work.strobe_generator(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    strobe_period_i => sampling_period_i, 
    strobe_o => sampling_strobe
  );

  PWM_Module: entity work.PWM(rtl) generic map(
    COUNTER_LEN => BIT_WIDTH 
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => sampling_period_i,
    ON_counter_val_i => adc_value,
    PWM_pin_o => PWM_o
  );
  
  -- adc_valid_strobe_o can only be '1' after sampling strobe has been '1'

  Clock: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      ADC_Value <= (others => '0');
    elsif rising_edge(clk_i) then
      adc_value <= next_adc_value;
      adc_valid_strobe_o <= next_adc_valid_strobe;
    end if;
  end process Clock;

  Sampler: process(sampling_strobe, adc_value)
  begin
    
    next_adc_value <= adc_value;

    if sampling_strobe = '1' then
      -- set adc_valid_strobe = '1' after adc_value is registered
      next_adc_valid_strobe <= '1';
    
      if comparator_i = '1' and adc_value < sampling_period_i then
        next_adc_value <= adc_value + to_unsigned(BIT_WIDTH - 1, 1);
      elsif comparator_i = '0' and adc_value > 0 then 
      -- @Tutor: Why can I not use adc_value > to_unsigned(BIT_WIDTH - 1, 0); instead of adc_value > 0 ???
        report "adc_value - 1";
        next_adc_value <= adc_value - to_unsigned(BIT_WIDTH - 1, 1);
      end if;

    else 
      next_adc_valid_strobe <= '0';
    end if;

  end process Sampler;

end architecture rtl;