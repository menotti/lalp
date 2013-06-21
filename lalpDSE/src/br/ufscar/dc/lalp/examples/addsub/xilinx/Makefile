#PRJ = `cd ../src/; ls *vhd | sed 's/t_.*//' | sed 's/^/vhdl work ..\/src\//' | sed 's/..\/src\/$$/..\/..\/NenyaBehaLib.vhd/'`
CONSTRAINTS = "NET "_clk_" TNM_NET = _clk_; TIMESPEC TS__clk_ = PERIOD "_clk_" 3000 ns HIGH 50%;"
FILES = $(shell ls ../src/$(DIR)*.vhd | sed "s/.vhd// ; s/..\/src\///")

all:
	for file in $(FILES); do\
		(rm -r $$file;\
		mkdir $$file;\
		cd $$file;\
		echo $$file.vhd > temp.prj;\
		echo memory.vhd >> temp.prj;\
		echo ? >> temp.prj;\
		cat temp.prj | sed 's/t_.*//' | sed 's/^/vhdl work ..\/..\/src\//'| sed 's/src\/?/..\/NenyaBehaLib.vhd/' > $$file.prj;\
		rm temp.prj;\
		echo $(CONSTRAINTS) > $$file.ucf;\
		xflow -p $(XILINX_DEVICE) -synth xst_vhdl.opt $$file.prj;\
		xflow -p $(XILINX_DEVICE) -implement balanced.opt $$file.ngc;\
		echo $$file > $$file.Report.csv;\
		egrep $(XILINX_DATA) *_map.mrp | sed 's/out.*//' | sed 's/.*://' >> $$file.Report.csv;\
		grep 'Maximum frequency' $$file.twr | sed -e 's/.*:// ; s/)// ;s/MHz//;s/$$/;/' >> $$file.Report.csv;\
		sed ':begin ; $$ b end ; $$! N ; s/\n/;/ ; b begin ; :end' $$file.Report.csv > temp2.txt;\
		sed 's/ //g' temp2.txt  > $$file.Report.csv;\
		cat $$file.Report.csv >> ../../../xilinxReport.csv;\
		rm temp2.txt);\
	done
