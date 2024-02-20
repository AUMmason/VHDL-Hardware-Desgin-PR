library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Top Level Entity for Servo Controller

entity servo_controller_board_ea is
  -- INPUT_BIT_WIDTH = log2(2000 + 1) = 11;
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal pwm_on_value_i : in unsigned(11 - 1 downto 0); --- 1000 = 0°, 2000 180°
    signal servo_o : out std_ulogic
  );
end entity servo_controller_board_ea;

architecture synth of servo_controller_board_ea is
  constant BIT_WIDTH : natural := 11;
begin

  ServoController : entity work.servo_controller(rtl) generic map(
    INPUT_BIT_WIDTH => BIT_WIDTH
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    pwm_on_value_i => pwm_on_value_i,
    servo_o => servo_o
    );

end architecture synth;