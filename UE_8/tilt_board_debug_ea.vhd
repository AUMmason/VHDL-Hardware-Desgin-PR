library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Packages
use work.servo_package.all;
use work.tilt_package.all;

entity tilt_board_debug is
  generic (
    ADC_BIT_WIDTH : natural
  );
  port (
    -- Debug Inputs
    signal debug_mode_enabled_i : in std_ulogic;
    signal debug_enable_filter_i : in std_ulogic;
    signal debug_adc_value_i : in unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal debug_adc_valid_strobe_i : in std_ulogic;

    -- Inputs
    signal axis_comp_async_i : in std_ulogic;
    signal clk_i, reset_i : in std_ulogic;
    -- Outputs
    signal axis_pwm_pin_o : out std_ulogic;
    signal axis_servo_pwm_pin_o : out std_ulogic;
    -- 3x Outputs for each 7seg Display (for on Axis) (6 in Total)
    signal LED_X00_o, LED_0X0_o, LED_00X_o : out std_ulogic_vector(0 to 6)
  );
end entity tilt_board_debug;

architecture rtl of tilt_board_debug is
  constant SERVO_PWM_BIT_WIDTH : natural := integer( ceil(log2(real( SERVO_SIGNAL_MAX ))) );
  constant BIN2BCD_BIT_WIDTH : natural := 16;
  constant SEVEN_SEG_BIT_WIDTH : natural := 4;

  signal ones, tens, hundreds : std_ulogic_vector(SEVEN_SEG_BIT_WIDTH - 1 downto 0);
  
  signal axis_comp_sync : std_ulogic;
  signal adc_valid_strobe, adc_unfiltered_valid_strobe, adc_filterd_valid_strobe : std_ulogic;
  signal adc_value, adc_value_unfiltered, adc_value_filtered, hold_adc_value : unsigned(ADC_BIT_WIDTH - 1 downto 0);

  signal pwm_servo_on_counter_val : unsigned(SERVO_PWM_BIT_WIDTH - 1 downto 0);
  
  -- For 7 Segment Display
  signal binary : std_ulogic_vector(BIN2BCD_BIT_WIDTH - 1 downto 0);

  -- Transfer Signals
  signal axis_pwm_pin, debug_axis_pwm_pin : std_ulogic;
begin
  
  -- * Debug Signal Assignments
  adc_value <= debug_adc_value_i when debug_mode_enabled_i = '1' else adc_value_filtered;
  axis_pwm_pin_o <= debug_axis_pwm_pin when debug_mode_enabled_i = '1' else axis_pwm_pin;
  adc_valid_strobe <= debug_adc_valid_strobe_i when debug_mode_enabled_i = '1' else adc_filterd_valid_strobe;

  Synchronizer : entity work.sync_chain(rtl) generic map (
    CHAIN_LENGTH => SYNC_CHAIN_LENGTH -- high enough value for synchronization
  ) port map (
    Async_i => axis_comp_async_i,
    Sync_o => axis_comp_sync,
    clk_i => clk_i,
    reset_i => reset_i
  );

  DeltaADC : entity work.delta_adc(rtl) generic map (
    PWM_PERIOD => CLOCK_FREQ / DELTA_ADC_PWM_FREQ,
    SAMPLING_PERIOD => CLOCK_FREQ / DELTA_ADC_SAMPLING_FREQ,
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    comparator_i => axis_comp_sync,
    adc_valid_strobe_o => adc_unfiltered_valid_strobe,
    pwm_o => axis_pwm_pin,
    adc_value_o => adc_value_unfiltered
  );

  DeltaADC_Debug : entity work.delta_adc_debug(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    adc_value_i => debug_adc_value_i,
    PWM_o => debug_axis_pwm_pin
  );

  MovingAverageFilter : entity work.moving_average_filter(rtl) generic map (
    FILTER_ORDER => MOV_AVG_LENGTH,
    BIT_WIDTH => ADC_BIT_WIDTH
  ) port map (
    enable_i => debug_enable_filter_i,
    clk_i => clk_i,
    reset_i => reset_i,
    strobe_data_valid_i => adc_unfiltered_valid_strobe,
    data_i => adc_value_unfiltered,
    data_o => adc_value_filtered,
    strobe_data_valid_o => adc_filterd_valid_strobe
  );

  HoldValueOnStrobe : entity work.hold_value_on_strobe(rtl) generic map (
    BIT_WIDTH => ADC_BIT_WIDTH
  ) port map (
    strobe_i => adc_valid_strobe, -- For initiation a strobe is needed otherwise the held adc value will be X
    clk_i => clk_i,
    reset_i => reset_i,
    value_i => adc_value, 
    hold_value_o => hold_adc_value
  );

  binary <= (BIN2BCD_BIT_WIDTH - 1 downto ADC_BIT_WIDTH => '0') & std_ulogic_vector(hold_adc_value);

  Bin2Bcd : entity work.bin2bcd(rtl) port map (
    binary_i => binary,
    ones_o => ones,
    tens_o => tens,
    hundreds_o => hundreds
  );

  BcdTo7Seg_Ones : entity work.bcd_to_7seg(rtl) port map (
    bcd_i => ones,
    LED_o => LED_00X_o
  );

  BcdTo7Seg_Tens : entity work.bcd_to_7seg(rtl) port map (
    bcd_i => tens,
    LED_o => LED_0X0_o
  );

  BcdTo7Seg_Hundreds : entity work.bcd_to_7seg(rtl) port map (
    bcd_i => hundreds,
    LED_o => LED_X00_o
  );

  TiltAxis : entity work.tilt(rtl) generic map (
    ADC_BIT_WIDTH => ADC_BIT_WIDTH,
    SERVO_BIT_WIDTH => SERVO_PWM_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    adc_value_i => hold_adc_value,
    pwm_on_o => pwm_servo_on_counter_val
  );

  PWMServo : entity work.servo_controller generic map (
    INPUT_BIT_WIDTH => SERVO_PWM_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    pwm_on_value_i => pwm_servo_on_counter_val,
    servo_o => axis_servo_pwm_pin_o
  );

end architecture rtl;