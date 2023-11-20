quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR\\UE_2\\counter_e.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_2\\counter_a.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_2\\FSM_e.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_2\\FSM_a.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_2\\LED_Blinking_Tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ms LED_Blinking_Tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /LED_Blinking_Tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /LED_Blinking_Tb/clk
add wave -noupdate -color Cyan -radix unsigned /LED_Blinking_Tb/start_button

# Label
add wave -divider Outputs

add wave -noupdate /LED_Blinking_Tb/led

# Label
add wave -divider Internal

add wave -noupdate -color {Medium Slate Blue} -radix unsigned /LED_Blinking_Tb/counter_e/counter_value

add wave -noupdate -color {Medium Slate Blue} -radix unsigned /LED_Blinking_Tb/FSM_e/state
add wave -noupdate -color {Medium Slate Blue} -radix unsigned /LED_Blinking_Tb/FSM_e/next_state

run 3000 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {3000 ms}