library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity servo_controller is
  generic (
    INPUT_BIT_WIDTH : natural -- given from parent module and chosen by the lower and upper_bound values
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal pwm_on_value_i : in unsigned(INPUT_BIT_WIDTH - 1 downto 0); --- 1000 = 0°, 2000 180°; 
    signal servo_o : out std_ulogic
  );
end entity servo_controller;

architecture rtl of servo_controller is
  -- Servo Controller receives Signals at 50 MHz = 50_000_000 Hz.
  -- Clock Period is 20 ns = 0,000_000_02.
  -- So after 50_000_000 Clock Cycles one second has passed.
  -- Which means we have to set servo_o to '1' for 50_000_000 to 100_000_000
  -- Clock Cycles to set the angle of the servo!

  -- Min and Max values that are vaild for the input signals to set the servo angle!
  constant SERVO_SIGNAL_MIN : natural := 1000; -- 0°
  constant SERVO_SIGNAL_MAX : natural := 2000; -- 180°
  -- Timing Setup:
  constant CYCLES_PER_SECOND : natural := 50_000_000; -- = 50 MHz
  constant MAX_SECONDS : natural := 2; -- S
  constant COUNTER_MIN : natural := CYCLES_PER_SECOND;
  constant COUNTER_MAX : natural := MAX_SECONDS * CYCLES_PER_SECOND;
  constant COUNTER_BIT_WIDTH : natural := integer( ceil(log2(real( COUNTER_MAX ))) );
  -- Signal Mapping:
  constant STEP_SIZE : unsigned(COUNTER_BIT_WIDTH - 1 downto 0) := to_unsigned(COUNTER_MAX / 1000, COUNTER_BIT_WIDTH); 
  signal pwm_servo_on_val : unsigned(COUNTER_BIT_WIDTH - 1 downto 0);
begin  

  -- Clamp values that are below 1000 or over 2000
  -- Multiply pwm_on_value_i with stepsize!
  pwm_servo_on_val <= 
      to_unsigned(COUNTER_MIN, COUNTER_BIT_WIDTH) when 
    pwm_on_value_i < to_unsigned(SERVO_SIGNAL_MIN, INPUT_BIT_WIDTH) else 
      to_unsigned(SERVO_SIGNAL_MAX, INPUT_BIT_WIDTH) when 
    pwm_on_value_i > to_unsigned(SERVO_SIGNAL_MAX, INPUT_BIT_WIDTH) else
      STEP_SIZE * pwm_on_value_i;

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