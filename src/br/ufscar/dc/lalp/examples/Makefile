MODULES = dotprod addsub fdct fibonacci_data_reuse fir matmult max sobel sobel_alt vecsum vecsum_asynchronous
all :
	for dir in $(MODULES); do\
		(cd $$dir; make generate compile);\
	done
