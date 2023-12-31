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
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_board_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_board_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns tilt_board_tb -wlf tilt_ma_filter_sim.wlf

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_tb/clk
add wave -noupdate -color Cyan -radix symbolic /tilt_board_tb/axis_comp_async
add wave -noupdate -color Cyan -radix symbolic /tilt_board_tb/enable_filter

# Label
add wave -divider Outputs

add wave -noupdate -color Cyan -radix symbolic /tilt_board_tb/axis_pwm_pin
add wave -noupdate -color Cyan -radix symbolic /tilt_board_tb/axis_servo_pwm_pin

add wave -noupdate -color Cyan -radix binary /tilt_board_tb/LED_X00
add wave -noupdate -color Cyan -radix binary /tilt_board_tb/LED_0X0
add wave -noupdate -color Cyan -radix binary /tilt_board_tb/LED_00X

# Label
add wave -divider {ADC-Values and Valid Strobes}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/adc_valid_strobe
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/adc_value_filtered
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/adc_filterd_valid_strobe

add wave -divider {PWM and Binary}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/pwm_servo_on_counter_val
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_board_tb/TiltX/binary

add wave -divider {Moving Average Filter}
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/data_i
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/sum
add wave -noupdate -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/data_o
add wave -noupdate -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/data_last
add wave -noupdate -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/strobe_data_valid_i
add wave -noupdate -radix unsigned /tilt_board_tb/TiltX/MovingAverageFilter/strobe_data_valid_o

run 11 sec
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {11 sec}