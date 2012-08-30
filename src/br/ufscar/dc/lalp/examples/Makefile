MODULES = $(shell ls -d */ | sed 's/\///')
DATA = 'Logic utilization|Combinational ALUTs|Memory ALUTs|Dedicated logic registers|Total registers|Total pins|Total virtual pins|Total block memory bits|DSP block 18-bit elements|Total GXB Receiver Channel PCS|Total GXB Receiver Channel PMA|Total GXB Transmitter Channel PCS|Total GXB Transmitter Channel PMA|Total PLLs|Total DLLs'
#FPGA Family and Part
FAMILY = "Arria II"
PART = EP2AGX45DF29I5

all :
	rm -f report.txt
	for dir in $(MODULES); do\
		(cd $$dir;\
		make generate compile;\
	        quartus_map $$dir --source=$$dir.vhd --source=memory.vhd --source=../NenyaBehaLib.vhd --family=$(FAMILY);\
		quartus_fit $$dir --part=$(PART);\
		quartus_sta $$dir;\
		echo ----------------------------------------$$dir---------------------------------------- >> ../report.txt;\
		egrep $(DATA) $$dir.flow.rpt | sed 's/;//g' >> ../report.txt;\
		sed '/Slow 900mV 100C Model Fmax Summary/,+5!d' $$dir.sta.rpt |sed '1,6d' >> ../report.txt;\
		sed '/Slow 900mV -40C Model Fmax Summary/,+5!d' $$dir.sta.rpt |sed '1,6d' >> ../report.txt;\
		echo >> ../report.txt;);\
	done
	
