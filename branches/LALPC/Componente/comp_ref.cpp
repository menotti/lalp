/* 
 * File:   comp_ref.cpp
 * Author: demo
 * 
 * Created on July 15, 2013, 10:18 AM
 */
#include "../header/meuHeader.h"
#include "comp_ref.h"
#include "string"

comp_ref::comp_ref(SgNode* node, const string &aux) : Componente(node, aux){
    this->tipo_comp = CompType::REF;
}

string comp_ref::imprimePortas(){
    return(this->getComponenteRef()->imprimePortas());
}

string comp_ref::imprimeLigacoes(){
    return(this->getComponenteRef()->imprimeLigacoes());
}

string comp_ref::getNomeCompVHDL(){
    return (this->getComponenteRef()->getNomeCompVHDL());
}

string comp_ref::getEstruturaComponenteVHDL(){
    return (this->getComponenteRef()->getEstruturaComponenteVHDL());
}

string comp_ref::geraDOTComp(){
    return (this->getComponenteRef()->geraDOTComp());
}

void comp_ref::createAllGeneric(){
    
}
void comp_ref::createAllPorts(){
}

Port* comp_ref::getPortDataInOut(const string &nome){
    return (this->getComponenteRef()->getPortDataInOut(nome)); 
}

Port* comp_ref::getPortOther(const string &nome){
    return (this->getComponenteRef()->getPortOther(nome)); 
}

void comp_ref::removeLigacao(Ligacao* lig){
    this->getComponenteRef()->removeLigacao(lig);
}

void comp_ref::addLigacao(Ligacao* lig){
    this->getComponenteRef()->addLigacao(lig);
}

void comp_ref::addGenericMap(GenericMap* map){
    this->getComponenteRef()->addGenericMap(map);
}

Ligacao* comp_ref::getLigacaoByName(const string &nome){
    return (this->getComponenteRef()->getLigacaoByName(nome));
}

string comp_ref::geraCompVHDL(){
    return (this->getComponenteRef()->geraCompVHDL());
}

string comp_ref::getGenericMapVal(const string &map, const string &aux){
    return (this->getComponenteRef()->getGenericMapVal(map, aux));
}

void comp_ref::setGenericMapVal(const string &map, const string &aux, const string &val){
    this->getComponenteRef()->setGenericMapVal(map, aux, val);
}    
    
//void comp_ref::setWE(bool we){
//    this->getComponenteRef()->setWE(we);
//}
//    
//bool comp_ref::getWE(){
//    return (this->getComponenteRef()->getWE());
//}


string comp_ref::getDelayValComp(){
    return (this->getComponenteRef()->getDelayValComp()); 
}

void comp_ref::setDelayValComp(const string &delayVal){
    this->getComponenteRef()->setDelayValComp(delayVal);
}

int comp_ref::getQtdPorts(){
   return (this->getComponenteRef()->getQtdPorts()); 
}

void comp_ref::setNomeVarIndex(const string &index){
    this->ref_var_index = index;
}

string comp_ref::getNomeVarIndex(){
    return this->ref_var_index;
}

void comp_ref::setNomeVarRef(const string &nome){
    this->ref_var_nome = nome;
}

void comp_ref::setTipoVar(const string &tipo){
    this->ref_var_tipo = tipo;
}

//list<Port*> comp_ref::getAllPorts(){
//    return (this->getComponenteRef()->getAllPorts());
//}

comp_ref::~comp_ref() {
}
