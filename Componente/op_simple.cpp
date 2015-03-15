/* 
 * File:   op_simple.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "op_simple.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

op_simple::op_simple(void*node, int dataWidth) : Componente(node) {
    this->dataWidth     = dataWidth;
    this->tipo_comp = CompType::OPE;
    this->createAllPorts();
    this->createAllGeneric();
}

op_simple::~op_simple() {
}

void op_simple::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in1"  , "integer", FuncoesAux::IntToStr(this->dataWidth)));
    this->addGenericMap(new GenericMap("w_in2"  , "integer", FuncoesAux::IntToStr(this->dataWidth)));
    this->addGenericMap(new GenericMap("w_out"  , "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

void op_simple::createAllPorts(){
    this->addPort(new Port("I0" ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("I1" ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("O0" ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
}

string op_simple::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        w_in1	: integer := 8; \n";
    res += "        w_in2	: integer := 8; \n";
    res += "        w_out	: integer := 16 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        I0          : in	std_logic_vector(w_in1-1 downto 0); \n";
    res += "        I1          : in	std_logic_vector(w_in2-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_out-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string op_simple::geraDOTComp(){
    string dataWidthAux = FuncoesAux::IntToStr(this->dataWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0["+dataWidthAux+"]|<I1>I1["+dataWidthAux+"]}|"+this->getNomeCompVHDL()+":"+this->getName()+"|{<O0>O0["+dataWidthAux+"]}}\"]; \n";
    return res;
}
