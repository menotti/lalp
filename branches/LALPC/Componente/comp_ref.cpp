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
    if(aux == "WE"){
        this->setWE(true);
    }
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
void comp_ref::addGenericMap(GenericMap* map){
}

string comp_ref::getDelayValComp(){
    return (this->getComponenteRef()->getDelayValComp()); 
}

void comp_ref::setDelayValComp(const string &delayVal){
    this->getComponenteRef()->setDelayValComp(delayVal);
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
comp_ref::~comp_ref() {
}
