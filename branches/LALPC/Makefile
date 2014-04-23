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
FOLDER_AUX      = Aux
FOLDER_COMP     = Componente
FOLDER_COMP_HDR = AlgoritHdw
FOLDER_COMP_ALG = Algoritmos

#funcoes AUX
AUX	    = $(FOLDER_AUX)/*.cpp
COMPONENTES = $(FOLDER_COMP)/*.cpp
FUNC_HDR    = $(FOLDER_COMP_HDR)/*.cpp
FUNC_ALG    = $(FOLDER_COMP_ALG)/*.cpp

## Your translator
TRANSLATOR=LALPC
TRANSLATOR_SOURCE=*.cpp $(AUX) $(COMPONENTES) $(FUNC_HDR) $(FUNC_ALG)

#-------------------------------------------------------------
# Makefile Targets
#-------------------------------------------------------------

all: $(TRANSLATOR) 

# compile the translator and generate an executable
# -g is recommended to be used by default to enable debugging your code

$(TRANSLATOR): $(TRANSLATOR_SOURCE)
	g++ -Wno-deprecated $(TRANSLATOR_SOURCE) -L$(ROSE_INSTALL)/lib -lrose -o  $(TRANSLATOR)

clean:
	rm -rf $(TRANSLATOR) *.o 

rose-headers:
	g++ -c -Wno-deprecated header/meuHeader.h -I/home/demo/opt/boost-1.40.0/include -I/home/demo/opt/rose-inst/include -o header/meuHeader.h.gch
	
	
boost-headers:
	g++ -c -Wno-deprecated header/headerGraph.h -I/home/demo/opt/boost-1.40.0/include -o header/headerGraph.h.gch
	

headers: rose-headers boost-headers
