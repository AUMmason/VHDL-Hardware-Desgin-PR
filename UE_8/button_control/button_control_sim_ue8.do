quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_package.vhd

vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_to_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/button_control_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/button_control_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns button_control_tb -wlf button_control_tb_sim.wlf

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/clk

add wave -divider {Inputs: Switches}
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/sw_enable_debug_mode
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/sw_select_axis
add wave -noupdate -color Cyan -radix symbolic /button_control_tb/sw_select_increment_amount

add wave -divider {Inputs: Buttons}
add wave -noupdate -radix symbolic /button_control_tb/btn_increase
add wave -noupdate -color Red -radix symbolic /button_control_tb/btn_decrease

# Label
add wave -divider Outputs

add wave -noupdate -radix symbolic /button_control_tb/axis_pwm_pin
add wave -noupdate -radix symbolic /button_control_tb/axis_servo_pwm_pin

add wave -noupdate -color Cyan -radix binary /button_control_tb/LED_X00
add wave -noupdate -color Cyan -radix binary /button_control_tb/LED_0X0
add wave -noupdate -color Cyan -radix binary /button_control_tb/LED_00X

# Label
add wave -divider {button_control}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /button_control_tb/button_control/adc_value_x
add wave -noupdate -color {Cornflower Blue} -radix unsigned /button_control_tb/button_control/adc_value_x_next
add wave -noupdate -color {Cornflower Blue} -radix unsigned /button_control_tb/button_control/adc_value_y
add wave -noupdate -color {Cornflower Blue} -radix unsigned /button_control_tb/button_control/adc_value_y_next
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/button_control/btn_increase
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/button_control/btn_decrease
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/button_control/adc_valid_strobe
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/button_control/adc_valid_strobe_next

run 1760 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {18 ms}