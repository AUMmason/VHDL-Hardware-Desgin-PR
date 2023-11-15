library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity servo_controller is
  -- assume, that clock_frequency is 50 MHz
  generic (
    natural BIT_WIDTH; -- given from parent module and chosen by the lower and upper_bound values
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal pwm_on_value : in unsigned(BIT_WIDTH - 1 downto 0); --- 1000 = 0°, 2000 180°; 
    signal servo_o : out std_ulogic;
  );
end entity servo_controller;
  constant time : CLK_PERIOD := 20 ns; -- bei 50 MHz
  
  -- counter implementieren der bis 1 ms bzw 2 ms zählt. bzw. an pwm weitergeben?

  signal pwm_period : to_unsigned(UPPER_BOUND, BIT_WIDTH);

architecture rtl of servo_controller_ea is
  
begin
  
  PWM: entity work.PWM(rtl) generic map(
    
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => pwm_period,
    ON_counter_val_i => pwm_period_counter,
    PWM_pin_o => servo_o
  )

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      
    elsif rising_edge(clk_i) then
      
    end if;
  end process clk;

end architecture rtl;