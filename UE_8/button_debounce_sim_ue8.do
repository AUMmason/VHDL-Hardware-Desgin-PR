quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_debounce_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_8/button_debounce_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns button_debounce_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_debounce_tb/clk
add wave -noupdate -color {Cornflower Blue} -radix symbolic /button_debounce_tb/reset
add wave -noupdate -radix symbolic /button_debounce_tb/button_input

# Label
add wave -divider Outputs

add wave -noupdate -radix symbolic /button_debounce_tb/debounce_output

# Label
add wave -divider {Simulation Internal Signals}

add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/pwm_on
add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/pwm_period

# Label
add wave -divider {Simulation Internal Signals}

add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/button_debounce/counter_value
add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/button_debounce/COUNTER_MAX_VALUE
add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/button_debounce/state_next
add wave -noupdate -color Cyan -radix unsigned /button_debounce_tb/button_debounce/state

run 105 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {105.5 ms}