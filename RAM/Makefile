# ===================UVM TestBench Makefile===================
SEED ?= 1234

VCS_OPTS := -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps -debug_access+all -kdb -lca 
VCS_OPTS += +incdir+./tb
VCS_OPTS += -cm line+cond+fsm+tgl+branch+assert

SIM_OPTS += +UVM_VERBOSITY=UVM_HIGH
SIM_OPTS += +ntb_random_seed=$(SEED)c
SIM_OPTS += -cm line+cond+fsm+tgl+branch+assert
SIM_OPTS += -cm_dir coverage.vdb
SIM_OPTS += -cm_name sim1

VERDI_OPTS := -dbdir simv.daidir -ssf novas.fsdb

.PHONY: compile sim clean simv


compile:
	vcs $(VCS_OPTS) -o simv -f filelist.f
	@echo "Targe [$@] complete"



sim : compile
	./simv $(SIM_OPTS) +UVM_TESTNAME=ram_write_read_test

verdi : sim
	verdi $(VERDI_OPTS)

clean:
	rm -rf simv* csrc *.key *.h *.log *.fsdb novas* *.conf *LOG

