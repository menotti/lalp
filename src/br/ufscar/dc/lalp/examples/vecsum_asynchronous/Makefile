#On Windows systems comment the line below and use: make TESTBENCH=t_<EntityName>
TESTBENCH = `ls -1 t_*.vhd | sed 's/\(.*\)\..*/\1/'`

LALP_CMD = lalp
LALP_FLAGS = -gv -gs -vh -vt -aa -at -ab -as -ad -ao -verbose

GHDL_CMD = ghdl
GHDL_FLAGS  = -fexplicit --std=02 --ieee=synopsys --warn-no-vital-generic

#GHDL_SIM_OPT = --assert-level=error
#GHDL_SIM_OPT = --stop-time=500ns
#GHDL_SIM_OPT = --disp-tree --stats --stop-time=21us
GHDL_SIM_OPT = --stop-time=21us --ieee-asserts=disable

WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm 
# Windows
#REMOVE_CMD = del 

all : generate compile run view

generate :
	$(LALP_CMD) $(LALP_FLAGS) *.alp

compile :
	$(GHDL_CMD) -a $(GHDL_FLAGS) *.vhd ../NenyaBehaLib.vhd
	$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)

run :
	$(GHDL_CMD) -r $(GHDL_FLAGS) $(TESTBENCH) $(GHDL_SIM_OPT) --vcd=$(TESTBENCH).vcd 

view :
	$(WAVEFORM_VIEWER) $(TESTBENCH).vcd $(TESTBENCH).sav &

clean :
	$(GHDL_CMD) --clean
	$(REMOVE_CMD) *.vhd *.vcd *.dot work-obj93.cf
