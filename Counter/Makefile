# ===================UVM TestBench Makefile===================
TC ?= counter_test
SEED ?= 1234

VCS_OPTS = -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps -debug_access+all -kdb -lca

SIM_OPTS := +UVM_TESTNAME=$(TC)
SIM_OPTS += +UVM_VERBOSITY=UVM_HIGH
SIM_OPTS += +ntb_random_seed=$(SEED)

.PHONY: compile sim clean simv


compile:
	vcs $(VCS_OPTS) -o simv -f filelist.f
	@echo "Targe [$@] complete"



sim : compile
	./simv $(SIM_OPTS)

clean:
	rm -rf simv* csrc *.key *.
	



