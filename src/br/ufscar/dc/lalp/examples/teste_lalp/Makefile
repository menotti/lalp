#On Windows systems comment the line below and use: make TESTBENCH=t_<EntityName>
DIR = $(shell basename ${PWD})
TESTBENCH = `cd src; ls -1 t_*.vhd | sed 's/\(.*\)\..*/\1/'`


LALP_CMD = lalp
LALP_FLAGS = -gv -gs -vh -vi -vt -aa -at -ab -as -ad -ao -verbose
LALP_LIBS_DIR = /home/cristiano/lalp/src/br/ufscar/dc/lalp/lib


GHDL_CMD = ghdl

GHDL_LIBS_DIR = $(LALP_LIBS_DIR)/ieee_proposed

GHDL_FLAGS  = -v -P$(GHDL_LIBS_DIR) -fexplicit --std=02 --ieee=synopsys --warn-no-vital-generic
#GHDL_FLAGS  = -fexplicit --std=02 --ieee=synopsys --warn-no-vital-generic



#GHDL_SIM_OPT = --assert-level=error
#GHDL_SIM_OPT = --stop-time=500ns
#GHDL_SIM_OPT = --disp-tree --stats --stop-time=21us
GHDL_SIM_OPT = --stop-time=21us --ieee-asserts=disable

WAVEFORM_VIEWER = gtkwave



# Unix
REMOVE_CMD = rm 
# Windows
#REMOVE_CMD = del 
export 

all : generate compile run view
#all : compile run view
     

generate :
	$(LALP_CMD) $(LALP_FLAGS) *.alp
	mv *.vhd src/

analysis :
	$(GHDL_CMD) -a $(GHDL_FLAGS) src/*.vhd $(LALP_LIBS_DIR)/NenyaBehaLib.vhd $(LALP_LIBS_DIR)/LalpFloat.vhd  

elaborate :
	$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)
#	$(GHDL_CMD) -c $(GHDL_FLAGS) src/*.vhd  ../NenyaBehaLib2.vhd -e $(TESTBENCH)


compile : analysis elaborate
	mv *.o gnu/
	mv *.cf gnu/

run :
	$(GHDL_CMD) -r $(GHDL_FLAGS) $(TESTBENCH) $(GHDL_SIM_OPT) --vcd=$(TESTBENCH).vcd
	mv *.vcd gnu/ 

view :
	$(WAVEFORM_VIEWER) gnu/$(TESTBENCH).vcd gnu/$(TESTBENCH).sav &

clean :
	$(GHDL_CMD) --clean
	$(REMOVE_CMD) *.vhd *.vcd *.dot work-obj93.cf

implementAltera:
	make -C altera
implementXilinx:
	make -C xilinx
