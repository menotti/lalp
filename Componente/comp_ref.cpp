/* 
 * File:   comp_ref.cpp
 * Author: demo
 * 
 * Created on July 15, 2013, 10:18 AM
 */

#include "comp_ref.h"
#include "rose.h"
#include "string"

comp_ref::comp_ref(SgNode* node, const string &aux) : Componente(node, aux){
    this->tipo_comp         = "REF";
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

string comp_ref::getEstruturaComponenteVHDL(){
    //string res = "";
    string res = this->refComp->getEstruturaComponenteVHDL();
    return res;
}

string comp_ref::geraDOTComp(){
//    string res = "TESTE TESTE";
//    string res = this->getComponenteRef()->geraDOTComp();
//    string res = this->getComponenteRef()->getName();
    string res = this->refComp->geraDOTComp();
    return res;
}

string comp_ref::geraVHDLComp(){
//    string res = "";
    string res = this->refComp->geraVHDLComp();
    return res;
}



void comp_ref::finalizaPortasComp(){
    list<Ligacao*>::iterator k;
    //CHAMAR METODO DOS OBJETOS
}

comp_ref::~comp_ref() {
}
