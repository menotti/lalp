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
	
comp-headers:
	g++ -c -Wno-deprecated Componente/Componente.h -o Componente/Componente.h.gch
	g++ -c -Wno-deprecated Componente/GenericMap.h -o Componente/GenericMap.h.gch
	g++ -c -Wno-deprecated Componente/Port.h -o Componente/Port.h.gch
	g++ -c -Wno-deprecated Componente/add_reg_op_s.h -o Componente/add_reg_op_s.h.gch
	g++ -c -Wno-deprecated Componente/block_ram.h -o Componente/block_ram.h.gch
	g++ -c -Wno-deprecated Componente/block_ram_dual.h -o Componente/block_ram_dual.h.gch
	g++ -c -Wno-deprecated Componente/comp_aux.h -o Componente/comp_aux.h.gch
	g++ -c -Wno-deprecated Componente/comp_ref.h -o Componente/comp_ref.h.gch
	g++ -c -Wno-deprecated Componente/counter.h -o Componente/counter.h.gch
	g++ -c -Wno-deprecated Componente/delay_op.h -o Componente/delay_op.h.gch
	g++ -c -Wno-deprecated Componente/if_gt_op_s.h -o Componente/if_gt_op_s.h.gch
	g++ -c -Wno-deprecated Componente/op_mult_s.h -o Componente/op_mult_s.h.gch
	g++ -c -Wno-deprecated Componente/op_simple.h -o Componente/op_simple.h.gch
	g++ -c -Wno-deprecated Componente/op_sub_s.h -o Componente/op_sub_s.h.gch
	g++ -c -Wno-deprecated Componente/reg_op.h -o Componente/reg_op.h.gch
	g++ -c -Wno-deprecated Componente/op_add_s.h -o Componente/op_add_s.h.gch

headers: rose-headers boost-headers comp-headers
