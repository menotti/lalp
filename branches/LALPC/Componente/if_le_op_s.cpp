/* 
 * File:   add_reg_op_s.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
//#include "../header/meuHeader.h"
#include "if_le_op_s.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

if_le_op_s::if_le_op_s(void*node) : Componente(node) {
    this->setNomeCompVHDL("if_le_op_s");
    this->setSync(false);
    this->tipo_comp = CompType::CND;  
    this->createAllPorts();
    this->createAllGeneric();
}

if_le_op_s::~if_le_op_s() {
}

void if_le_op_s::createAllPorts(){
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,"32", ""));
    this->addPort(new Port("I1"         ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"1", "OUT"));
}

void if_le_op_s::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in1", "integer", "32"));
    this->addGenericMap(new GenericMap("w_in2", "integer", "32"));
    this->addGenericMap(new GenericMap("w_out", "integer", "1"));
}

string if_le_op_s::getEstruturaComponenteVHDL(){
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

string if_le_op_s::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|"+this->getNomeCompVHDL()+":"+this->getName()+"|{<O0>O0[1]}}\"]; \n";
    return res;
}

void if_le_op_s::setValor(const string &val){
    this->valor = val;
    this->setGenericMapVal("initial", "VAL", val);
}

string if_le_op_s::getTipo(){
    return this->tipo_var;
}

string if_le_op_s::getCondEsq(){
    return(this->I0);
}

string if_le_op_s::getCondDir(){
    return(this->I1);
}

void if_le_op_s::setCondEsq(const string &aux){
    this->I0 = aux;
}

void if_le_op_s::setCondDir(const string &aux){
    this->I1 = aux;
}

void if_le_op_s::setTipo(const string &aux){
    this->tipo_var = aux;
}

