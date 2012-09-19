MODULES = $(shell ls -d */ | sed 's/\///')
DATA = 'Benchmark|Combinational ALUTs|Memory ALUTs|Dedicated logic registers|Total registers|Total pins|Total virtual pins|Total block memory bits|DSP block 18-bit elements|Total GXB Receiver Channel PCS|Total GXB Receiver Channel PMA|Total GXB Transmitter Channel PCS|Total GXB Transmitter Channel PMA|Total PLLs|Total DLLs'
#FPGA Family and Part
FAMILY = "Arria II"
PART = EP2AGX45DF29I5
#Open some benchmark.sta.rpt and look for the "Slow VOLTAGE TEMPERATURE Model Fmax Summary". The least and the highest temperature, as well as the voltage changes according to the FPGA Family and Part, and you have to set the values in the 3 variables below
VOLTAGE = 900mV
MIN_TEMPERATURE = -40C
MAX_TEMPERATURE = 100C
FMAX = ;$(VOLTAGE) $(MIN_TEMPERATURE) Fmax;$(VOLTAGE) $(MIN_TEMPERATURE) Restricted Fmax;$(VOLTAGE) $(MAX_TEMPERATURE) Fmax;$(VOLTAGE) $(MAX_TEMPERATURE) Restricted Fmax

all :
	echo "$(DATA)$(FMAX)" | sed "s/|/;/g ; s/'//g" > report.csv
	for dir in $(MODULES); do\
		(cd $$dir;\
		make generate;\
	        quartus_map $$dir --source=$$dir.vhd --source=memory.vhd --source=../NenyaBehaLib.vhd --family=$(FAMILY);\
		quartus_fit $$dir --part=$(PART);\
		quartus_sta $$dir;\
		echo $$dir > temp.txt;\
		egrep $(DATA) $$dir.flow.rpt | sed 's/18-// ; s/;//g ; s/[a-z]//Ig ; s/\/.*//g ; s/ //g' >> temp.txt;\
		sed '/; Slow $(VOLTAGE) $(MIN_TEMPERATURE) Model Fmax Summary/,+5!d' $$dir.sta.rpt | sed '/+/d ; /Fmax/d ; s/; clk.*// ; s/ *//g ; s/MHz//g ; s/;//' >> temp.txt;\
		sed '/; Slow $(VOLTAGE) $(MAX_TEMPERATURE) Model Fmax Summary/,+5!d' $$dir.sta.rpt | sed '/+/d ; /Fmax/d ; s/; clk.*// ; s/ *//g ; s/MHz//g ; s/;//' >> temp.txt;\
		sed ':begin ; $$ b end ; $$! N ; s/\n/;/ ; b begin ; :end' temp.txt > temp2.txt;\
		sed 's/--.*//g' temp2.txt > temp.txt;\
		cat temp.txt >> ../report.csv;\
		rm temp.txt;\
		rm temp2.txt;);\
	done
