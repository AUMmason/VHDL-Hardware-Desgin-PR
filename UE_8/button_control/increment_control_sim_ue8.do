quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/increment_control_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_control/increment_control_tb.vhd

# Start Simulation
# vim -Optimierung -t {Einheit} {testbench entity} -wlf {Name der Simulationsdatei}
vsim -voptargs="\+acc" -t ns increment_control_tb -wlf increment_control.wlf

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /increment_control_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /increment_control_tb/clk

add wave -divider {Inputs: Switches}
add wave -noupdate -radix symbolic /increment_control_tb/multiply_increment

add wave -divider {Inputs: Buttons}
add wave -noupdate -radix symbolic /increment_control_tb/increase
add wave -noupdate -radix symbolic /increment_control_tb/decrease

# Label
add wave -divider Outputs
add wave -noupdate -color Cyan -radix unsigned /increment_control_tb/value

run 250 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {260 ms}