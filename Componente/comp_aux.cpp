/* 
 * File:   comp_aux.cpp
 * Author: demo
 * 
 * Created on July 25, 2013, 1:35 PM
 */
//#include "../header/meuHeader.h"
#include "comp_aux.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;
//Componente voltado para criacao dos pinos de entrada
comp_aux::comp_aux(void*node,  const string& aux, int dataWidth) : Componente(node, aux) {
    this->setSync(false);
    this->valAux = "0";
    this->dataWidth = dataWidth;
    this->tipo_comp = CompType::AUX;
//    this->isIn      = true;
    this->comIn     = true;
    string type     = "std_logic";
    if(this->dataWidth > 1) type = "std_logic_vector";     
    
    if(aux == "VALOR"){
        this->setNomeCompVHDL("valor");
        this->addPort(new Port("out","out"   ,type, FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    }
    if(aux == "OUT"){
        this->setNomeCompVHDL("out");
        this->comIn = false; 
        this->addPort(new Port("in" ,"in"   ,type     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    }
    if(aux == "IN"){
        this->setNomeCompVHDL("in");
        this->addPort(new Port("out","out"   ,type    ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    } 
}

bool comp_aux::ehCompIn(){
    return this->comIn;
}

string comp_aux::getValAux(){
    return this->valAux;
}

void    comp_aux::setValAux(const string& aux){
    this->valAux = aux;
}

string  comp_aux::geraCompVHDL(){}
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

