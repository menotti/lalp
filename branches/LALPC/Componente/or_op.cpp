/* 
 * File:   add_reg_op_s.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
//#include "../header/meuHeader.h"
#include "or_op.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

or_op::or_op(void*node) : Componente(node) {
    this->setNomeCompVHDL("or_op");
    this->setSync(false);
    this->tipo_comp = CompType::OPE;  
    this->createAllPorts();
    this->createAllGeneric();
}

or_op::~or_op() {
}

void or_op::createAllPorts(){
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,"32", ""));
    this->addPort(new Port("I1"         ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
}

void or_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in1", "integer", "32"));
    this->addGenericMap(new GenericMap("w_in2", "integer", "32"));
    this->addGenericMap(new GenericMap("w_out", "integer", "32"));
}

string or_op::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        w_in1	: integer := 16; \n";
    res += "        w_in2	: integer := 16; \n";
    res += "        w_out	: integer := 1 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        I0          : in	std_logic_vector(w_in1-1 downto 0); \n";
    res += "        I1          : in	std_logic_vector(w_in2-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_out-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string or_op::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|"+this->getNomeCompVHDL()+":"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}