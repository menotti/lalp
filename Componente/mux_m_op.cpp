/* 
 * File:   delay_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"

#include "mux_m_op.h"
#include "string"
#include <stdio.h>
#include <sstream>
#include <stdlib.h>

#include "../Aux/FuncoesAux.h"
using namespace std;

mux_m_op::mux_m_op(void* node, const string &nOps, const string &sSels) : Componente(node) {
    this->nOps  = nOps;
    this->nSels = sSels;
    this->setSync(false);
    this->setNomeCompVHDL("mux_m_op");
    this->tipo_comp         = CompType::MUX;
    this->createAllPorts();
    this->createAllGeneric();
}

mux_m_op::~mux_m_op() {
}

void mux_m_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("N_ops"  , "integer", this->nOps));
    this->addGenericMap(new GenericMap("N_sels" , "integer", this->nSels));
    this->addGenericMap(new GenericMap("w_in"   , "integer", "32"));
    

}

void mux_m_op::createAllPorts(){
    string dataWPort = "";
    int val = 0;
    val = 32 * FuncoesAux::StrToInt(this->nOps);
    dataWPort = FuncoesAux::IntToStr(val);
    
    PortLarge* porta = new PortLarge("I0","in","std_logic_vector",dataWPort, "IN");
    this->addPort(porta);
    
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
    
    PortLarge* porta2 = new PortLarge("Sel","in","std_logic_vector",this->nSels, "");
    this->addPort(porta2);
}

string mux_m_op::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component mux_m_op \n";
    res += "generic ( \n";
    res += "        w_in	: integer := 32;\n";
    res += "        N_ops	: integer := 32;\n";
    res += "        N_sels	: integer := 31\n";
    res += "); \n";
    res += "port ( \n";
    res += "        I0          : in	std_logic_vector((w_in*N_ops)-1 downto 0);\n";
    res += "        Sel         : in	std_logic_vector(N_sels-1 downto 0);\n";
    res += "        O0          : out	std_logic_vector(w_in-1 downto 0)\n";
    res += "); \n";
    res += "end component; \n\n";   
    
    return res;
}

string mux_m_op::geraDOTComp(){
    string dataWPort,nSels = "";
    int val, val1 = 0;
    val  = 32 * FuncoesAux::StrToInt(this->nOps);
    dataWPort = FuncoesAux::IntToStr(val);
    
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0["+dataWPort+"]|<Sel>Sel["+this->nSels+"]}|mux_m_op:"+this->getName()+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

void mux_m_op::setNOps(const string &bits){
    this->nOps = bits;
    this->setGenericMapVal("N_ops", "VAL", bits);
}

string mux_m_op::getNOps(){
    return (this->getGenericMapVal("N_ops", "VAL"));
}

void mux_m_op::setNSels(const string &val){
    this->nSels = val;
    this->setGenericMapVal("N_sels", "VAL", val);
}

string mux_m_op::getNSels(){
    return (this->getGenericMapVal("N_sels", "VAL"));
}