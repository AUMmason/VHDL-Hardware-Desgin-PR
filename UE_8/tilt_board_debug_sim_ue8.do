quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_package.vhd

vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd

vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/delta_adc_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/delta_adc_a.vhd

vcom VHDL-Hardware-Desgin-PR/UE_4_5/sync_chain_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_controller_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/hold_value_on_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_ea.vhd

vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_to_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/delta_adc_debug_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/button_control_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/tilt_board_debug_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/tilt_board_debug_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns tilt_board_debug_tb -wlf tilt_board_debug_tb_sim.wlf

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/clk

add wave -divider {Inputs: Switches}
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/sw_enable_debug_mode
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/sw_select_axis
add wave -noupdate -color Cyan -radix symbolic /tilt_board_debug_tb/sw_select_increment_amount

add wave -divider {Inputs: Buttons}
add wave -noupdate -radix symbolic /tilt_board_debug_tb/btn_increase
add wave -noupdate -color Coral -radix symbolic /tilt_board_debug_tb/btn_decrease

# Label
add wave -divider Outputs

add wave -noupdate -radix symbolic /tilt_board_debug_tb/axis_pwm_pin
add wave -noupdate -radix symbolic /tilt_board_debug_tb/axis_servo_pwm_pin

add wave -noupdate -color Cyan -radix binary /tilt_board_debug_tb/LED_X00
add wave -noupdate -color Cyan -radix binary /tilt_board_debug_tb/LED_0X0
add wave -noupdate -color Cyan -radix binary /tilt_board_debug_tb/LED_00X

# Label
add wave -divider {ADC-Values and Valid Strobes}
add wave -noupdate -radix symbolic /tilt_board_debug_tb/tilt_board_debug/adc_valid_strobe
add wave -noupdate -radix unsigned /tilt_board_debug_tb/tilt_board_debug/hold_adc_value
add wave -noupdate -color {Cornflower Blue} -radix unsigned tilt_board_debug_tb/tilt_board_debug/debug_adc_value_i
add wave -noupdate -color {Cornflower Blue} -radix unsigned tilt_board_debug_tb/tilt_board_debug/adc_value_filtered

# Label
add wave -divider {button_control}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_debug_tb/button_control/adc_value_x
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_debug_tb/button_control/adc_value_x_next
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_debug_tb/button_control/adc_value_y
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_debug_tb/button_control/adc_value_y_next
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/button_control/btn_increase
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/button_control/btn_decrease
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/button_control/adc_valid_strobe
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/button_control/adc_valid_strobe_next

# Label
add wave -divider {PWM and Binary}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_debug_tb/tilt_board_debug/pwm_servo_on_counter_val
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_debug_tb/tilt_board_debug/binary


run 2150 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {18 ms}