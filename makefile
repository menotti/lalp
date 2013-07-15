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

#Pastas
FOLDER_COMP = Componente
FOLDER_AUX  = Aux

#Componentes
COMPONENTES = $(FOLDER_COMP)/Componente.cpp $(FOLDER_COMP)/op_simple.cpp $(FOLDER_COMP)/op_add_s.cpp $(FOLDER_COMP)/counter.cpp $(FOLDER_COMP)/delay_op.cpp $(FOLDER_COMP)/block_ram.cpp $(FOLDER_COMP)/reg_op.cpp $(FOLDER_COMP)/comp_ref.cpp

#funcoes AUXO
AUX	    = $(FOLDER_AUX)/FuncoesAux.cpp

## Your translator
TRANSLATOR=LALPC
TRANSLATOR_SOURCE=$(TRANSLATOR).cpp autoParSupport.cpp Core.cpp Ligacao.cpp ArquivosDotHW.cpp $(COMPONENTES) $(AUX)

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
