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

# Pastas Projeto
FOLDER_AUX  = Aux
FOLDER_COMP = Componente

#funcoes AUX
AUX	    = $(FOLDER_AUX)/FuncoesAux.cpp
COMPONENTES = $(FOLDER_COMP)/Componente.cpp $(FOLDER_COMP)/Port.cpp $(FOLDER_COMP)/GenericMap.cpp $(FOLDER_COMP)/comp_aux.cpp $(FOLDER_COMP)/op_simple.cpp $(FOLDER_COMP)/op_add_s.cpp $(FOLDER_COMP)/op_sub_s.cpp $(FOLDER_COMP)/counter.cpp $(FOLDER_COMP)/delay_op.cpp $(FOLDER_COMP)/block_ram.cpp $(FOLDER_COMP)/reg_op.cpp $(FOLDER_COMP)/comp_ref.cpp

## Your translator
TRANSLATOR=LALPC
TRANSLATOR_SOURCE=$(TRANSLATOR).cpp Core.cpp ProcessGraph.cpp Ligacao.cpp CompType.cpp ArquivosDotHW.cpp $(AUX) $(COMPONENTES)

## Input testcode for your translator
TESTCODE=hello.c

#-------------------------------------------------------------
# Makefile Targets
#-------------------------------------------------------------

all: $(TRANSLATOR) check #clean

# compile the translator and generate an executable
# -g is recommended to be used by default to enable debugging your code

$(TRANSLATOR): $(TRANSLATOR_SOURCE)
	g++ -Wno-deprecated $(TRANSLATOR_SOURCE) -L$(ROSE_INSTALL)/lib -lrose -o  $(TRANSLATOR)

# test the translator
check: $(TRANSLATOR)
	./$(TRANSLATOR) -c -I. $(TESTCODE) 

clean:
	rm -rf $(TRANSLATOR) *.o rose_* *.dot

hd:
	g++ -c -Wno-deprecated header/meuHeader.h -I/home/demo/opt/boost-1.40.0/include -I/home/demo/opt/rose-inst/include -o header/meuHeader.h.gch
	
	
hd2:
	g++ -c -Wno-deprecated header/headerGraph.h -I/home/demo/opt/boost-1.40.0/include -o header/headerGraph.h.gch