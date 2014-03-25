/* 
 * File:   neg_op_s.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "neg_op_s.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

neg_op_s::neg_op_s(void*node, int dataWidth) : Componente(node) {
    this->setNomeCompVHDL("neg_op_s");
    this->tipo_comp  = CompType::OPE;
    this->dataWidth  = dataWidth;
    this->createAllPorts();
    this->createAllGeneric();
    this->setSync(false);
}

neg_op_s::~neg_op_s() {
}

void neg_op_s::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in"   , "integer", FuncoesAux::IntToStr(this->dataWidth)));
    this->addGenericMap(new GenericMap("w_out"  , "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

void neg_op_s::createAllPorts(){
    this->addPort(new Port("I0"  ,"in"   ,"std_logic_vector" ,FuncoesAux::IntToStr(this->dataWidth), "IN" ));
    this->addPort(new Port("O0"  ,"out"  ,"std_logic_vector" ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
}

string neg_op_s::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component neg_op_s \n";
    res += "generic ( \n";
    res += "        w_in        : integer := 16;\n";
    res += "        w_out       : integer := 16 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        I0		: in	std_logic_vector(w_in-1 downto 0); \n";
    res += "        O0		: out	std_logic_vector(w_out-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string neg_op_s::geraDOTComp(){
    string dataWidthAux    = FuncoesAux::IntToStr(this->dataWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0["+dataWidthAux+"]}|neg_op_s:"+this->getName()+"|{<O0>O0["+dataWidthAux+"]}}\"]; \n";
    return res;
}