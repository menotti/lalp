/* 
 * File:   delay_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "../header/meuHeader.h"
#include "delay_op.h"
#include "string"

using namespace std;

delay_op::delay_op(SgNode* node) : Componente(node) {
    this->setNomeCompVHDL("delay_op");
    this->tipo_comp         = CompType::DLY;
    this->createAllPorts();
    this->createAllGeneric();
}

delay_op::~delay_op() {
}

void delay_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("bits"   , "integer", "16"));
    this->addGenericMap(new GenericMap("delay"  , "integer", "0"));
}

void delay_op::createAllPorts(){
    this->addPort(new Port("a"          ,"in"   ,"std_logic_vector"     ,"0", "IN"));
    this->addPort(new Port("clk"        ,"in"   ,"std_logic_vector"     ,"0", ""));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("a_delayed"  ,"out"  ,"std_logic_vector"     ,"0", "OUT"));
}

string delay_op::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component delay_op \n";
    res += "generic ( \n";
    res += "        bits        : integer := 8; \n";
    res += "        delay       : integer := 1 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        a		: in	std_logic_vector(bits-1 downto 0); \n";
    res += "        clk		: in	std_logic; \n";
    res += "        reset	: in	std_logic; \n";
    res += "        a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0') \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string delay_op::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<a>a["+this->getDelayBits()+"]|<clk>clk|<reset>reset}|delay_op:"+this->getName()+"\\ndelay="+this->getDelayVal()+"|{<a_delayed>a_delayed["+this->getDelayBits()+"]}}\"]; \n";
    return res;
}

void delay_op::setDelayBits(const string &bits){
    this->setGenericMapVal("bits", "VAL", bits);
}

string delay_op::getDelayBits(){
    return (this->getGenericMapVal("bits", "VAL"));
}

void delay_op::setDelayVal(const string &val){
    this->setGenericMapVal("delay", "VAL", val);
}

string delay_op::getDelayVal(){
    return (this->getGenericMapVal("delay", "VAL"));
}