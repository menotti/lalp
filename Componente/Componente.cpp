/* 
 * File:   Componente.cpp
 * Author: Lucas Porto
 * 
 * Created on 14 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "Componente.h"
#include "variables.h"
#include <boost/lexical_cast.hpp>
#include "../Ligacao.h"
#include "../Aux/FuncoesAux.h"

using namespace std;
using namespace SageInterface;
using std::stringstream;
using boost::lexical_cast;
using std::string;

Componente::Componente(SgNode* node/*=NULL*/, const string &aux/*=""*/){
    
    //Criacao de componentes baseados na arvore AST Rose
    if(node != NULL){
        this->node = node;
        
        if(aux == "WE"){
            this->writeEnable = true;
        }else{
            this->writeEnable = false;
        }
    }
}

vector<string> Componente:: SplitStr(const string& s, const string& delim){
    return(this->funcAux->split(s,delim));
}

string Componente::ConverteIntToStr(int aux){
    return(this->funcAux->IntToStr(aux));
}

void Componente::setEInicializado(bool val){
    this->eInicializado = val;
}

bool Componente::getEInicializado(){
    return (this->eInicializado);
}

int Componente::ConverteStrToInt(const string &aux){
    return(this->funcAux->StrToInt(aux));
}

string Componente::getNomeCompVHDL(){
    return this->nome_comp_vhdl;
}

void Componente::setNomeCompVHDL(const string &nome){
    this->nome_comp_vhdl = nome;
}

void Componente::setPai(SgNode* nodo){
    //Cria a ligacao do noto atual na entrada do nodo do PARAMETRO
    this->nodoPai = nodo;
}

void Componente::addLigacao(Ligacao* lig){
    this->ligacoes.push_back(lig);
}

void Componente::removeLigacao(Ligacao* lig){
    this->ligacoes.remove(lig);
}

SgNode* Componente::getPai(){
    return this->nodoPai;
}

string Componente::getStringPortOUT(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "O0";
    }
    if(this->tipo_comp == "CTD"){
        res = "output";
    }
    if(this->tipo_comp == "DLY"){
        res = "a_delayed";
    }
    if(this->tipo_comp == "MEM"){
        //if(this->ref_var_tipo == "VET"){
        res = "data_out";
        //}
//        if(this->ref_var_tipo == "VAR"){
//                res = "O0";
//        }
    }
    
    return res;
}

string Componente::getStringPortOUTSize(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "32";
    }
    if(this->tipo_comp == "CTD"){
        res = "16";
    }
    if(this->tipo_comp == "DLY"){
        res = "1";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "32";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "32";
        }
    }
    return res;
}

string Componente::getStringPortIN(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "I0";
    }
    if(this->tipo_comp == "DLY"){
        res = "a";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "data_in";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "I0";
        }
    }
    return res;
}

string Componente::getStringPortINSize(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "32";
    }
    if(this->tipo_comp == "DLY"){
        res = "1";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "32";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "32";
        }
    }
    return res;
}

void Componente::imprime(){
//    if(this->tipo_comp == "REG" || this->tipo_comp == "MEM"){
//        cout<< "NOME VAR:  "<< this->nome           << endl;
//        cout<< "E INICIADO:"<< this->eInicializado  << endl;
//        cout<< "E VETOR:   "<< this->eVetor         << endl;
//        cout<< "TIPO VAR:  "<< this->tipo_var       << endl;
//        cout<< "TIPO COMP: "<< this->tipo_comp      << endl;
//        cout<< "QTD ELEME: "<< this->qtd_ele_vet    << endl;
//        cout<< "VALOR:     "<< this->valor          << endl;
//        cout<< "--------------------------------------------"<< endl;
//    }else if(this->tipo_comp == "CTD"){
//        cout<< "VAR:       "<<this->for_ctr_var     << endl;
//        cout<< "VAL INI:   "<<this->for_ctr_val_ini << endl;
//        cout<< " "<< endl;
//        cout<< "VAR:       "<<this->for_cond_var    << endl;
//        cout<< "OP CONTR:  "<<this->for_cond_op     << endl;
//        cout<< "VAL CONTR: "<<this->for_cond_val    << endl;  
//        cout<< " "<< endl;
//        cout<< "VAR INCR:  "<<this->for_incr_var    << endl;
//        cout<< "OP  INCR:  "<<this->for_incr_op     << endl;
//        cout<< "VAL INCR:  "<<this->for_incr_val    << endl;
//        cout<< "--------------------------------------------"<< endl;
//    }else if(this->tipo_comp == "OPE"){
//        cout<<"OPERCACAO:  "<<this->tipo_comp       <<endl;
//        cout<<"TIPO OP:    "<<this->op_tipo         <<endl;
//        cout<<"-- LIGACOES:   "<<endl;
//        //this->imprimeLigacoes();
//        cout<< "--------------------------------------------"<< endl;
//    }else if(this->tipo_comp == "CON"){
//        cout<<"Constante   "<<endl;
//        cout<<"TIPO:       "<<this->cons_tipo        <<endl;
//        cout<<"VALOR:      "<<this->valor             <<endl;
//        //cout<<"SAIDA:      "<<this->out_comp->node->class_name()   <<endl;
//        cout<< "--------------------------------------------"<< endl;
//    }else if(this->tipo_comp == "REF"){
//        cout<<"Referencia  "<<endl;
//        cout<<"TIPO:       "<<this->ref_var_tipo      <<endl;
//        cout<<"Nome Ref:   "<<this->ref_var_nome      <<endl;
//        cout<<"INDICE:     "<<this->ref_var_index     <<endl;
//        //cout<<"SAIDA:      "<<this->out_comp->node->class_name()   <<endl;
//        cout<< "--------------------------------------------"<< endl;
//    }
}

void Componente::imprimeLigacoes(){
    list<Ligacao*>::iterator i;
    //cout<<"QTD ELEM: "<< this->ligacoes.size() << endl;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        cout<< "ORIGEM:  "<< (*i)->getOrigem()->node->class_name()<<endl;
        cout<< "DESTINO: "<< (*i)->getDestino()->node->class_name()<<endl;
        cout<< "" <<endl;
    }
}

void Componente::setName(const string &nome){
    this->nome = nome;
}

string Componente::getName(){
    return this->nome;
}

Componente* Componente::getComponenteRef(){
    return (this->refComp);
}
void Componente::setComponenteRef(Componente* comp){
    this->refComp = comp;
}

Componente::~Componente() {
}

