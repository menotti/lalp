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

    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(this->node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(this->node);
    if(nodo_ref_var != NULL){
        this->ref_var_tipo  = "VAR";
        this->ref_var_nome = nodo_ref_var->get_symbol()->get_name().getString();
        this->nome = this->ref_var_nome;
//        cout<< "TESTE: " << nodo_ref_var->get_symbol()->get_symbol_basis()<<endl;
//        cout<< "TESTE: " << nodo_ref_var->get_symbol()->get_symbol_basis()->class_name()<<endl;
    }
    if(nodo_ref_arr != NULL){
        this->ref_var_tipo  = "VET";
        
        string arrName  = "";
        string arrPos   = ""; 
        SgVarRefExp* fe = isSgVarRefExp( nodo_ref_arr->get_lhs_operand_i() );
        SgVarRefExp* fd = isSgVarRefExp( nodo_ref_arr->get_rhs_operand_i() );
        if ( fe != NULL &&  fd != NULL){
            arrName     = fe->get_symbol()->get_name().getString();
            //nodo_ref fe->get_symbol()->->get_symbol_basis();
//            cout<< "TESTE: " << fe->get_symbol()->get_symbol_basis()<<endl;
//            cout<< "TESTE: " << fe->get_symbol()->get_symbol_basis()->class_name()<<endl;
            arrPos      = fd->get_symbol()->get_name().getString();
            this->ref_var_nome = arrName;
            this->ref_var_index= arrPos;
            this->nome = this->ref_var_nome;
        }
    }
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

string comp_ref::geraVHDLComp(){
    return (this->getComponenteRef()->geraVHDLComp());
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

void comp_ref::setWE(bool we){
    this->getComponenteRef()->setWE(we);
}
    
bool comp_ref::getWE(){
    return (this->getComponenteRef()->getWE());
}

int comp_ref::getQtdPorts(){
   return (this->getComponenteRef()->getQtdPorts()); 
}

comp_ref::~comp_ref() {
}
