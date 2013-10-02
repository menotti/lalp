/* 
 * File:   reg_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
#include "../header/meuHeader.h"
#include "reg_op.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

reg_op::reg_op(SgNode* node, const string &aux) : Componente(node, aux) {
    this->setNomeCompVHDL("reg_op");    
    this->tipo_comp = CompType::REG;    
    this->createAllPorts();
    this->createAllGeneric();
}

reg_op::~reg_op() {
}

void reg_op::createAllPorts(){
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"1", ""));
}

void reg_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("initial", "integer", "0"));
    this->addGenericMap(new GenericMap("w_in", "integer", "32"));
}

string reg_op::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        w_in	: integer := 16; \n";
    res += "        initial	: integer := 0 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        clk         : in	std_logic; \n";
    res += "        reset       : in	std_logic; \n";
    res += "        we          : in	std_logic := '1'; \n";
    res += "        I0          : in	std_logic_vector(w_in-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_in-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string reg_op::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0[32]|<clk>clk|<reset>reset|<we>we}|reg_op:"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

void reg_op::setValor(const string &val){
    this->valor = val;
    this->setGenericMapVal("initial", "VAL", val);
}

string reg_op::getTipo(){
    return this->tipo_var;
}

void reg_op::setTipo(const string &aux){
    this->tipo_var = aux;
}

