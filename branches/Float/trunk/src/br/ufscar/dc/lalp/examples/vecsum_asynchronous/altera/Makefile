all:	
	quartus_map $(DIR) --source=../src/$(DIR).vhd --source=../src/memory.vhd --source=../../NenyaBehaLib.vhd --family="ArriaII"
	quartus_fit $(DIR) --part=EP2AGX45DF29I5
	quartus_sta $(DIR)
	echo $(DIR) > $(DIR)Report.csv
	egrep $(ALTERA_DATA) $(DIR).flow.rpt | sed 's/18-// ; s/;//g ; s/[a-z]//Ig ; s/\/.*//g ; s/ //g' >> $(DIR)Report.csv
	sed '/; Slow $(VOLTAGE) $(MIN_TEMPERATURE) Model Fmax Summary/,+5!d' $(DIR).sta.rpt | sed '/+/d ; /Fmax/d ; s/; clk.*// ; s/ *//g ; s/MHz//g ; s/;//' >> $(DIR)Report.csv
	sed '/; Slow $(VOLTAGE) $(MAX_TEMPERATURE) Model Fmax Summary/,+5!d' $(DIR).sta.rpt | sed '/+/d ; /Fmax/d ; s/; clk.*// ; s/ *//g ; s/MHz//g ; s/;//' >> $(DIR)Report.csv
	sed ':begin ; $$ b end ; $$! N ; s/\n/;/ ; b begin ; :end' $(DIR)Report.csv > temp2.txt
	sed 's/--.*//g' temp2.txt > $(DIR)Report.csv
	cat $(DIR)Report.csv >> ../../alteraReport.csv
	rm temp2.txt
