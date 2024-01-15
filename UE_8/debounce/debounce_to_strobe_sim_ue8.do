quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_to_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/debounce/debounce_to_strobe_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns debounce_to_strobe_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /debounce_to_strobe_tb/clk
add wave -noupdate -color {Cornflower Blue} -radix symbolic /debounce_to_strobe_tb/reset
add wave -noupdate -radix symbolic /debounce_to_strobe_tb/button_input

# Label
add wave -divider Outputs

add wave -noupdate -radix symbolic /debounce_to_strobe_tb/strobe

# Label
add wave -divider {Simulation Internal Signals}
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/deb_input
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/deb_input_prev

# Label
add wave -divider {Simulation PWM}

add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/pwm_on
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/pwm_period

# Label
add wave -divider {Simulation Internal Signals}

add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/debounce/debounce_o
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/debounce/counter_value
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/debounce/COUNTER_MAX_VALUE
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/debounce/state_next
add wave -noupdate -color Cyan -radix unsigned /debounce_to_strobe_tb/debounce_to_strobe/debounce/state

run 105 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {105.5 ms}