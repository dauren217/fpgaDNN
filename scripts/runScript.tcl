create_project -in_memory -part xc7z020clg484-1
set_param synth.vivado.isSynthRun true
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]

read_mem ../src/fpga/rtl/sigContent.mif
read_verilog -library xil_defaultlib {
  ../src/fpga/rtl/Layer.v
  ../src/fpga/rtl/Sig_ROM.v
  ../src/fpga/rtl/relu.v
  ../src/fpga/rtl/Weight_Memory.v
  ../src/fpga/rtl/axi_lite_wrapper.v
  ../src/fpga/rtl/maxFinder.v
  ../src/fpga/rtl/neuron.v
  ../src/fpga/rtl/nn_autoGen_top.v
}

read_xdc ../src/fpga/constraints/constraints.xdc
set_property used_in_implementation true [get_files ../src/fpga/constraints/constraints.xdc]

synth_design -quiet -top nn_autoGen_top -part xc7z020clg484-1
opt_design -quiet
place_design -quiet
route_design -quiet
report_utilization -file utilization.log
report_timing_summary -file timing.log
exit
