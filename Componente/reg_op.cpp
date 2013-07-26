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
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,"0", "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"0", "OUT"));

}

void reg_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("data_width", "integer", "11"));
    this->addGenericMap(new GenericMap("data_width", "integer", "32"));
}

string reg_op::getEstruturaComponenteVHDL(){
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

string reg_op::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0[32]|<clk>clk|<reset>reset|<we>we}|reg_op:"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

void reg_op::setValor(const string &aux){
    this->valor = aux;
}

void reg_op::setTipo(const string &aux){
    this->tipo_var = aux;
}

