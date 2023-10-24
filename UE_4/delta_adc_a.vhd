library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of delta_adc is
  -- Todo: this is a temporary fix it doesn't work as shown in class, idk if there is a better option?
  constant BIT_WIDTH : natural := integer( ceil(log2(real( abs(to_integer(sampling_period_i)) ))) );
  signal sampling_strobe : std_ulogic;
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
  
  -- When the sampling strobe is active the adc got an updated signal
  adc_valid_strobe_o <= sampling_strobe;

  Clock: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      ADC_Value <= (others => '0');
    elsif rising_edge(clk_i) then
      adc_value <= next_adc_value;
    end if;
  end process Clock;

  Sampler: process(sampling_strobe, adc_value)
  begin
    
    next_adc_value <= adc_value;

    if sampling_strobe = '1' then
      if comparator_i = '1' and adc_value < sampling_period_i then
        next_adc_value <= adc_value + to_unsigned(BIT_WIDTH - 1, 1);
      elsif comparator_i = '0' and adc_value > to_unsigned(BIT_WIDTH - 1, 0) then
        next_adc_value <= adc_value - to_unsigned(BIT_WIDTH - 1, 1);
      end if;
    end if;

  end process Sampler;

end architecture rtl;