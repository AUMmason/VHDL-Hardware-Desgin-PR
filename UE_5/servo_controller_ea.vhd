library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity servo_controller is
  generic (
    -- given by parent module and chosen by the lower and upper_bound values (eg. 1000 or 2000)
    INPUT_BIT_WIDTH : natural 
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal pwm_on_value_i : in unsigned(INPUT_BIT_WIDTH - 1 downto 0); --- 1000 = 0°, 2000 180°; 
    signal servo_o : out std_ulogic
  );
end entity servo_controller;

architecture rtl of servo_controller is
  -- EXPLAINATION:

  -- Servo Controller receives Signals at 50 MHz = 50_000_000 Hz.
  -- Clock Period is 20 ns = 0,000_000_02.
  -- So after 50_000_000 Clock Cycles one second has passed.
  -- Which means we have to set servo_o to '1' and count to 50_000_000 upto 100_000_000 
  -- Clock Cycles to set the angle of the servo!

  -- TODO: put everything below in a package
  -- Min and Max values that are vaild for the input signals to set the servo angle!
  constant SERVO_SIGNAL_RANGE : natural := 1000;
  constant SERVO_SIGNAL_MIN : natural := 1000; -- 0°
  constant SERVO_SIGNAL_MAX : natural := SERVO_SIGNAL_MIN + SERVO_SIGNAL_RANGE; -- 180°
  -- TIMING SETUP:
  -- Clock Frequency is per Millisecond!
  constant CLOCK_FREQUENCY : natural := 50_000_000 / 1000; -- 50MHz / 1000
  constant PWM_PERIOD : natural := 2; -- ms
  constant COUNTER_MIN : natural := CLOCK_FREQUENCY;
  constant COUNTER_MAX : natural := PWM_PERIOD * CLOCK_FREQUENCY;
  constant COUNTER_BIT_WIDTH : natural := integer( ceil(log2(real( COUNTER_MAX ))) );
  -- INPUT SIGNAL MAPPING:
  constant STEP_SIZE : unsigned(COUNTER_BIT_WIDTH - 1 downto 0) := to_unsigned(CLOCK_FREQUENCY / SERVO_SIGNAL_RANGE, COUNTER_BIT_WIDTH); 
    -- Sets the on-time for the pwm!
  signal pwm_servo_on_val : unsigned(COUNTER_BIT_WIDTH - 1 downto 0);
    -- Temporary Signal used for multiplication with STEP_SIZE:
  signal pwm_temp : unsigned(COUNTER_BIT_WIDTH + INPUT_BIT_WIDTH - 1 downto 0);
begin  

  pwm_temp <= pwm_on_value_i * STEP_SIZE;

  pwm_servo_on_val <= pwm_temp(pwm_temp'high - INPUT_BIT_WIDTH downto 0);
    
  PWM: entity work.PWM(rtl) generic map(
    COUNTER_LEN => COUNTER_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => to_unsigned(COUNTER_MAX, COUNTER_BIT_WIDTH),
    ON_counter_val_i => pwm_servo_on_val,
    PWM_pin_o => servo_o
  );

end architecture rtl;