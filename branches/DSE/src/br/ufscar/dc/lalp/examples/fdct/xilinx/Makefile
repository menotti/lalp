#PRJ = `cd ../src/; ls *vhd | sed 's/t_.*//' | sed 's/^/vhdl work ..\/src\//' | sed 's/..\/src\/$$/..\/..\/NenyaBehaLib.vhd/'`
CONSTRAINTS = "NET "_clk_" TNM_NET = _clk_; TIMESPEC TS__clk_ = PERIOD "_clk_" 3000 ns HIGH 50%;"

all:
	cd ../src/; ls *vhd | sed 's/t_.*//' | sed 's/^/vhdl work ..\/src\//' | sed 's/..\/src\/$$/..\/..\/NenyaBehaLib.vhd/' > $(DIR).prj
	mv ../src/$(DIR).prj .
	echo $(CONSTRAINTS) > $(DIR).ucf
	xflow -p xc2vp30ff896-7 -synth xst_vhdl.opt $(DIR).prj
	xflow -p xc2vp30ff896-7 -implement balanced.opt $(DIR).ngc
	echo $(DIR) > $(DIR)Report.csv
	egrep $(XILINX_DATA) $(DIR)_map.mrp | sed 's/out.*//' | sed 's/.*://' >> $(DIR)Report.csv
	grep 'Maximum frequency' $(DIR).twr | sed -e 's/.*:// ; s/)// ;s/MHz//;s/$$/;/' >> $(DIR)Report.csv
	sed ':begin ; $$ b end ; $$! N ; s/\n/;/ ; b begin ; :end' $(DIR)Report.csv > temp2.txt
	sed 's/ //g' temp2.txt  > $(DIR)Report.csv
	cat $(DIR)Report.csv >> ../../xilinxReport.csv
	rm temp2.txt
