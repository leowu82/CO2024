.PHONY: part1
part1:
	make clean
	verilator -Wall --cc SingleCycleCPU.v --exe example_testbench.cpp --trace
	make -C obj_dir -f VSingleCycleCPU.mk VSingleCycleCPU
	./obj_dir/VSingleCycleCPU

.PHONY: clean
clean:
	rm -rf obj_dir
	rm -f waveform.vcd
