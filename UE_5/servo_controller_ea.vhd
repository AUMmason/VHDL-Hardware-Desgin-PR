library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Package
use work.servo_package.all;

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
    -- Sets the on-time for the pwm!
  signal pwm_servo_on_val : unsigned(SERVO_COUNTER_BIT_WIDTH - 1 downto 0);
begin

  pwm_servo_on_val <= resize(pwm_on_value_i * SERVO_STEP_SIZE, SERVO_COUNTER_BIT_WIDTH);
  
  PWM: entity work.PWM(rtl) generic map(
    COUNTER_LEN => SERVO_COUNTER_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => to_unsigned(SERVO_COUNTER_MAX, SERVO_COUNTER_BIT_WIDTH),
    ON_counter_val_i => pwm_servo_on_val,
    PWM_pin_o => servo_o
  );
end architecture rtl;