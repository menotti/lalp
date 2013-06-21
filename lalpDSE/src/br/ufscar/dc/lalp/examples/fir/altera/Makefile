FILES = $(shell ls ../src/$(DIR)*.vhd | sed "s/.vhd// ; s/..\/src\///")

all:	
	for file in $(FILES); do\
		(rm -r $$file;\
		mkdir $$file;\
		cp MakefileAltera $$file;\
		mv $$file/MakefileAltera $$file/Makefile;\
		cd $$file;\
		make PROJECT=$$file);\
	done
