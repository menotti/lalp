/* 
 * File:   comp_aux.cpp
 * Author: demo
 * 
 * Created on July 25, 2013, 1:35 PM
 */
#include "../header/meuHeader.h"
#include "comp_aux.h"
#include "string"

using namespace std;
//Componente voltado para criacao dos pinos de entrada
comp_aux::comp_aux(SgNode* node,  const string& aux) : Componente(node, aux) {
    this->setDelayValComp("1");
    this->tipo_comp = CompType::AUX;     
    if(aux == "INIT"){
        this->setNomeCompVHDL("init");
        this->addPort(new Port("out","out"   ,"std_logic"     ,"32", "OUT"));
    }        
    if(aux == "INPUT"){
        this->setNomeCompVHDL("input");
        this->addPort(new Port("out","out"   ,"std_logic_vector","32", "OUT"));
    }        
    if(aux == "TERMINATION"){
        this->setNomeCompVHDL("termination");
        this->addPort(new Port("out","out"   ,"std_logic_vector","32", "OUT"));
    }
    if(aux == "VALOR"){
        this->setNomeCompVHDL("valor");
        this->addPort(new Port("out","out"   ,"std_logic_vector","32", "OUT"));
    }
    if(aux == "DONE"){
        this->setNomeCompVHDL("done");
        this->addPort(new Port("in" ,"in"   ,"std_logic"     ,"1", "IN"));
    }        
    if(aux == "RESULT"){
        this->setNomeCompVHDL("result");
        this->addPort(new Port("in" ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    }    
}
void    comp_aux::setValAux(const string& aux){
    this->valAux = aux;
}

string  comp_aux::geraCompVHDL(){
    string res = "\t";
    if(this->getNomeCompVHDL() == "result"){
        res = "\\"+this->getName()+"\\ <= "+this->getPortDataInOut("IN")->getLigacao()+"; \n";
    }
    if(this->getNomeCompVHDL() == "done"){
        res = "\\"+this->getName()+"\\ <= "+this->getPortDataInOut("IN")->getLigacao()+"(0); \n";
    }
    if(this->getNomeCompVHDL() == "init"){
        res = this->getPortDataInOut("OUT")->getLigacao()+" <= \\"+this->getName()+"\\; \n";
    }
    if(this->getNomeCompVHDL() == "termination" || this->getNomeCompVHDL() == "input"){
        res = this->getPortDataInOut("OUT")->getLigacao()+" <= conv_std_logic_vector("+this->valAux+", 32); \n";
    }
    if(this->getNomeCompVHDL() == "valor"){
        res = this->getPortDataInOut("OUT")->getLigacao()+" <= conv_std_logic_vector("+this->valAux+", 32); \n";
    }
    return res;
}
string  comp_aux::getEstruturaComponenteVHDL(){}
string  comp_aux::geraDOTComp(){
    string res = "";
    if(this->getNomeCompVHDL() == "valor"){
        res = "\""+this->getName()+"\" [fontcolor=b label=\""+this->getName()+"="+this->valAux+"\"]";
    }else{
        res = "\""+this->getName()+"\" [shape=msquare fontcolor=red label=\""+this->getName()+"\"]";
    }
    return res;
}
void    comp_aux::createAllPorts(){}
void    comp_aux::createAllGeneric(){}
comp_aux::~comp_aux() {
}

