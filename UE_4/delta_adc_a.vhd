library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Todo how do we handle bit_width and the the maximum sample size?

architecture rtl of delta_adc is
  constant BIT_WIDTH : natural := integer( ceil(log2(real(to_integer(MAX_SAMPLE_VALUE)))) );
  signal sampling_strobe : std_ulogic;
  signal adc_value, next_adc_value : unsigned(BIT_WIDTH - 1 downto 0);
begin
  
  -- Wiring everthing up:
  Sampling_Strobe: entity work.strobe_generator(rtl) port map(
    STROBE_PERIOD <= MAX_SAMPLE_VALUE
  ) port map (
    clk_i <= clk_i,
    reset_i <= reset_i,
    strobe_o <= sampling_strobe
  );

  PWM_Module: entity work.PWM(rtl) generic map(
    BIT_WIDHT <= COUNTER_LEN
  ) port map (
    clk_i <= clk_i,
    reset_i <= reset_i,
  )
  
end architecture rtl;