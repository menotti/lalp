/* 
 * File:   reg_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
//#include "../header/meuHeader.h"
#include "reg_mux_op.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

reg_mux_op::reg_mux_op(void* node, const string &aux, int dataWidth) : Componente(node, aux) {
    this->dataWidth = dataWidth;
    this->setNomeCompVHDL("reg_mux_op");    
    this->tipo_comp = CompType::REG;    
    this->createAllPorts();
    this->createAllGeneric();
}

reg_mux_op::~reg_mux_op() {
}

void reg_mux_op::createAllPorts(){
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), ""));
    this->addPort(new Port("I1"         ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("Sel1"       ,"in"   ,"std_logic_vector"     ,"1", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"1", ""));
}

void reg_mux_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("initial", "integer", "0"));
    this->addGenericMap(new GenericMap("w_in", "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

string reg_mux_op::getEstruturaComponenteVHDL(){
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
    res += "        Sel1	: in	std_logic_vector(0 downto 0);\n";
    res += "        I0          : in	std_logic_vector(w_in-1 downto 0); \n";
    res += "        I1          : in	std_logic_vector(w_in-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_in-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    
    return res;
}

string reg_mux_op::geraDOTComp(){
    string dataWidthAux    = FuncoesAux::IntToStr(this->dataWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0["+dataWidthAux+"]|<I1>I1["+dataWidthAux+"]|<Sel1>Sel1[1]|<clk>clk|<reset>reset|<we>we}|reg_mux_op:"+this->getName()+"|{<O0>O0["+dataWidthAux+"]}}\"]; \n";  
    return res;
}

void reg_mux_op::setValor(const string &val){
    this->valor = val;
    this->setGenericMapVal("initial", "VAL", val);
}

string reg_mux_op::getTipo(){
    return this->tipo_var;
}

void reg_mux_op::setTipo(const string &aux){
    this->tipo_var = aux;
}

