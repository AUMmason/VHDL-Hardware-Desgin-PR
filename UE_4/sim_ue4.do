quit -sim 

# Files needed for Simulation

vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/delta_adc_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/delta_adc_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/delta_adc_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns delta_adc_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /delta_adc_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /delta_adc_tb/clk
add wave -noupdate -color Cyan -radix symbolic /delta_adc_tb/comparator

# Label
add wave -divider Outputs

add wave -noupdate -color Cyan -radix symbolic /delta_adc_tb/adc_valid_strobe
add wave -noupdate -color Cyan -radix unsigned /delta_adc_tb/adc_value
add wave -noupdate -color Cyan -radix symbolic /delta_adc_tb/pwm

# Label
add wave -divider Internal
add wave -noupdate -color {Cornflower Blue} -radix symbolic /delta_adc_tb/delta_adc/sampling_strobe
add wave -noupdate -color {Cornflower Blue} -radix unsigned /delta_adc_tb/delta_adc/adc_value

run 1250 ms
# Set Zoom Level {from ns} {to ns}
WaveRestoreZoom {0 ms} {1300 ms}