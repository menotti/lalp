#If you want to make just some of the benchmarks, write their names separated for space instead of the shell command bellow
MODULES = $(shell ls -d */ | sed 's/\///')
######################################################Altera######################################################
ALTERA_DATA = 'Benchmark|Combinational ALUTs|Memory ALUTs|Dedicated logic registers|Total registers|Total pins|Total virtual pins|Total block memory bits|DSP block 18-bit elements|Total GXB Receiver Channel PCS|Total GXB Receiver Channel PMA|Total GXB Transmitter Channel PCS|Total GXB Transmitter Channel PMA|Total PLLs|Total DLLs'
#Altera FPGA Family and Part
FAMILY = "Arria II"
PART = EP2AGX45DF29I5
#Open some benchmark.sta.rpt and look for the "Slow VOLTAGE TEMPERATURE Model Fmax Summary". The least and the highest temperature, as well as the voltage changes according to the FPGA Family and Part, and you have to set the values in the 3 variables below
VOLTAGE = 900mV
MIN_TEMPERATURE = -40C
MAX_TEMPERATURE = 100C
FMAX = ;$(VOLTAGE) $(MIN_TEMPERATURE) Fmax;$(VOLTAGE) $(MIN_TEMPERATURE) Restricted Fmax;$(VOLTAGE) $(MAX_TEMPERATURE) Fmax;$(VOLTAGE) $(MAX_TEMPERATURE) Restricted Fmax
######################################################Xilinx######################################################
XILINX_DATA = 'Benchmark|Slice Flip Flops|occupied Slices|Total Number of 4 input LUTs|bonded IOBs|RAMB16s|BUFGMUXs'
XILINX_DEVICE = 'xc2vp30ff896-7' #Virtex II-Pro
export

all :
	echo "$(ALTERA_DATA)$(FMAX)" | sed "s/|/;/g ; s/'//g" > alteraReport.csv
	echo "$(XILINX_DATA);Fmax" | sed "s/|/;/g ; s/'//g" > xilinxReport.csv
	for dir in $(MODULES); do\
		(cd $$dir;\
		make generate implementXilinx;\
		make implementAltera);\
	done
