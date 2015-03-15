/* 
 * File:   add_reg_op_s.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
//#include "../header/meuHeader.h"
#include "add_reg_op_s.h"
#include "string"
#include "../Aux/FuncoesAux.h"
#include <iostream>

using namespace std;

add_reg_op_s::add_reg_op_s(void*node, const string &aux, int dataWidth) : Componente(node, aux) {
    this->dataWidth = dataWidth;
    this->setNomeCompVHDL("add_reg_op_s");    
    this->tipo_comp = CompType::REG;    
    this->createAllPorts();
    this->createAllGeneric();
}

add_reg_op_s::~add_reg_op_s() {
}

void add_reg_op_s::createAllPorts(){
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), ""));
    this->addPort(new Port("I1"         ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"1", ""));
}

void add_reg_op_s::createAllGeneric(){
    this->addGenericMap(new GenericMap("initial", "integer", "0"));
    this->addGenericMap(new GenericMap("w_in1", "integer", FuncoesAux::IntToStr(this->dataWidth)));
    this->addGenericMap(new GenericMap("w_in2", "integer", FuncoesAux::IntToStr(this->dataWidth)));
    this->addGenericMap(new GenericMap("w_out", "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

string add_reg_op_s::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        w_in1	: integer := 16; \n";
    res += "        w_in2	: integer := 16; \n";
    res += "        w_out	: integer := 32; \n";
    res += "        initial	: integer := 0\n";
    res += "); \n";
    res += "port ( \n";
    res += "        clk         : in	std_logic; \n";
    res += "        reset       : in	std_logic; \n";
    res += "        we          : in	std_logic := '1'; \n";
    res += "        Sel1        : in	std_logic_vector(0 downto 0) := \"1\"; \n";
    res += "        I0          : in	std_logic_vector(w_in1-1 downto 0); \n";
    res += "        I1          : in	std_logic_vector(w_in2-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_out-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string add_reg_op_s::geraDOTComp(){
    string dataWidthAux    = FuncoesAux::IntToStr(this->dataWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0["+dataWidthAux+"]|<I1>I1["+dataWidthAux+"]|<Sel1>Sel1[1]|<clk>clk|<reset>reset|<we>we}|add_reg_op_s:"+this->getName()+"|{<O0>O0["+dataWidthAux+"]}}\"]; \n";
    return res;
}

void add_reg_op_s::setValor(const string &val){
    this->valor = val;
    this->setGenericMapVal("initial", "VAL", val);
}

string add_reg_op_s::getTipo(){
    return this->tipo_var;
}

void add_reg_op_s::setTipo(const string &aux){
    this->tipo_var = aux;
}

