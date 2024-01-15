quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_package.vhd

vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_to_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/button_control_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/button_control_tb.vhd

# Start Simulation
# vim -Optimierung -t {Einheit} {testbench entity} -wlf {Name der Simulationsdatei}
vsim -voptargs="\+acc" -t ns button_control_tb -wlf button_control_tb_sim.wlf

add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/state_next
add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/state
add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/debounce_o
add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/counter_value
add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/button_i
add wave -noupdate /button_control_tb/button_control/debounce_sw_enable_debug_mode/reset_counter

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_control_tb/clk

add wave -divider {Inputs: Switches}
add wave -noupdate -color Cyan -radix symbolic /button_control_tb/sw_enable_debug_mode
add wave -noupdate -color Cyan -radix symbolic /button_control_tb/sw_select_axis
add wave -noupdate -color Cyan -radix symbolic /button_control_tb/sw_select_increment_amount

add wave -divider {Inputs: Buttons}
add wave -noupdate -radix symbolic /button_control_tb/btn_increase
add wave -noupdate -color Coral -radix symbolic /button_control_tb/btn_decrease

# Label
add wave -divider Outputs
add wave -noupdate -color Cyan -radix unsigned /button_control_tb/enable_debug_mode
add wave -noupdate -color Cyan -radix unsigned /button_control_tb/debug_adc_valid_strobe
add wave -noupdate -radix unsigned /button_control_tb/debug_adc_value_x
add wave -noupdate -radix unsigned /button_control_tb/debug_adc_value_y


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

run 4200 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {4250 ms}