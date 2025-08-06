vlib work
vlog DSP_reg_MUX.v DSP.v DSP_tb.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all
#quit -sim