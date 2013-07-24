/* 
 * File:   op_simple.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "../header/meuHeader.h"
#include "op_simple.h"
#include "string"

using namespace std;

op_simple::op_simple(SgNode* node) : Componente(node) {
    this->tipo_comp = CompType::OPE;
    this->op_w_in1 = "32";
    this->op_w_in2 = "32";
    this->op_w_out = "32";

    //port map
    this->op_I0    = "";
    this->op_I1    = "";
    this->op_O0    = "";
    this->createAllPorts();
    this->createAllGeneric();
}

op_simple::~op_simple() {
}

void op_simple::createAllGeneric(){
    this->addGenericMap(new GenericMap("w_in1"  , "integer", "32"));
    this->addGenericMap(new GenericMap("w_in2"  , "integer", "32"));
    this->addGenericMap(new GenericMap("w_out"  , "integer", "32"));
}

void op_simple::createAllPorts(){
    this->addPort(new Port("I0" ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("I1" ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("O0" ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
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
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|add_op_s:"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

string op_simple::geraVHDLComp(){
    string res = "";

    res += "\\" + this->getName() + "\\ : "+this->getNomeCompVHDL();+" \n";
    res += "generic map ( \n";
    res += "        w_in1 => " + this->op_w_in1 + ", \n";
    res += "        w_in2 => " + this->op_w_in2 + ", \n";
    res += "        w_out => " + this->op_w_out + " \n";
    res += " ) \n";
    res += "port map ( \n";
    res += "        I0 => " + this->op_I0 + ", \n";
    res += "        I1 => " + this->op_I1 + ", \n";
    res += "        O0 => " + this->op_O0 + " \n";
    res += "); \n\n";

    return res;
}
