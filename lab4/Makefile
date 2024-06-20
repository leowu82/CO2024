.PHONY: part1
part1:
	make clean
	verilator -Wall --cc PipelineCPU.v --exe example_testbench.cpp --trace
	make -C obj_dir -f VPipelineCPU.mk VPipelineCPU
	./obj_dir/VPipelineCPU

.PHONY: clean
clean:
	rm -rf obj_dir
	rm -f waveform.vcd
