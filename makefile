## A sample Makefile to build a ROSE tool.
##
## Important: remember that Makefile recipes must contain tabs:
##
##     <target>: [ <dependency > ]*
##         [ <TAB> <command> <endl> ]+

## ROSE installation contains
##   * libraries, e.g. "librose.la"
##   * headers, e.g. "rose.h"



ROSE_INSTALL=/home/demo/opt/rose-inst

## ROSE uses the BOOST C++ libraries
BOOST_INSTALL=/home/demo/opt/boost-1.40.0

## Your translator
TRANSLATOR=Main
TRANSLATOR_SOURCE=$(TRANSLATOR).cpp autoParSupport.cpp Componente.cpp ListaComponente.cpp Ligacao.cpp ArquivosDotHW.cpp

## Input testcode for your translator
TESTCODE=hello.c

#-------------------------------------------------------------
# Makefile Targets
#-------------------------------------------------------------

all: $(TRANSLATOR) check

# compile the translator and generate an executable
# -g is recommended to be used by default to enable debugging your code
$(TRANSLATOR): $(TRANSLATOR_SOURCE)
	g++ -g  -Wno-deprecated  $(TRANSLATOR_SOURCE) -I$(BOOST_INSTALL)/include -I$(ROSE_INSTALL)/include -L$(ROSE_INSTALL)/lib -lrose -o $(TRANSLATOR)

# test the translator
check: 
	./$(TRANSLATOR) -c -I. -I$(ROSE_INSTALL)/include $(TESTCODE) 
	
clean:
	rm -rf $(TRANSLATOR) *.o *.pdf rose_* *.dot
