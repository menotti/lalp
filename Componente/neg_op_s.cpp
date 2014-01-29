/* 
 * File:   neg_op_s.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "neg_op_s.h"
#include "string"

using namespace std;

neg_op_s::neg_op_s(void*node) : Componente(node) {
    this->setNomeCompVHDL("neg_op_s");
    this->tipo_comp  = CompType::OPE;
    this->createAllPorts();
    this->createAllGeneric();
    this->setSync(false);
}

neg_op_s::~neg_op_s() {
}

void neg_op_s::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in"   , "integer", "32"));
    this->addGenericMap(new GenericMap("w_out"  , "integer", "32"));
}

void neg_op_s::createAllPorts(){
    this->addPort(new Port("I0"  ,"in"   ,"std_logic_vector"     ,"32", "IN" ));
    this->addPort(new Port("O0"  ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
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
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]}|neg_op_s:"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}