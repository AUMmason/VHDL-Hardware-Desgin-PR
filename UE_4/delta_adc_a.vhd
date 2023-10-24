library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of delta_adc is
  constant BIT_WIDTH : natural := integer( ceil(log2(real(to_integer(sampling_period_i)))) );
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
  
end architecture rtl;