/* 
 * File:   analisaMem.cpp
 * Author: Lucas
 * 
 * Created on January 17, 2014, 9:28 AM
 */
#include "analisaIf.h"
#include <set>
#include "../Aux/FuncoesAux.h"
#include "../Componente/comp_ref.h"
#include "../Componente/reg_mux_op.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>


using namespace std;

analisaIf::analisaIf(Design* design) {
    this->debug = true;
    this->design = design;
    this->buscaIfs();
}

void analisaIf::ligaExpInternoIf(Componente* compIf){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    Componente* CompRefAux = NULL;
    
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "IF COMP: "<< compIf->getName() << endl;
        cout<< "##################################" << endl;
        cout<< " TRUE BODY" << endl;
        cout<< "----------------------------------" << endl;
    }
    //if body TRUE
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getEIndice()) continue;
        if ((*i)->getIf() == false) continue;
        if ((*i)->getIfBody() == false) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        
        CompRefAux = (*i);
        if(this->debug){
            cout<< "----------------------------------" << endl;
            cout<< " AUX: '" << CompRefAux->getName() <<"'" << endl;
            cout<< "----------------------------------" << endl;
        }
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*i)->node == (*j)->node) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == false) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            
            if (CompRefAux->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    CompRefAux = (*j);
                    if(this->debug){
                        cout<< "NEW AUX: '" << CompRefAux->getName() <<"'" << endl;
                    }
                    continue;
                } else {
                    if (CompRefAux->getNumLinha() >= (*j)->getNumLinha()) continue;
                    if (CompRefAux->getPortDataInOut("OUT")->temLigacao()) {
                        if(this->debug){
                            cout<< "SUB COMP: '" << CompRefAux->getName() <<"' por '" << (*j)->getName() <<"'"<<  endl;
  
                        }   
                        this->design->substiuiComRecorente(CompRefAux, (*j));
                        
                    } else {
                        Componente* CompRefAuxDestino = (*j)->getLigacaoOutDefault()->getDestino();
                        if(this->debug){
                            cout<< "NEW LIG: '" << CompRefAux->getName() <<"' -> '" << (*j)->getName() <<"'"<<  endl;
                        }  
                        this->design->insereLigacao(CompRefAux, CompRefAuxDestino, CompRefAux->getPortDataInOut("OUT")->getName(), (*j)->getLigacaoOutDefault()->getPortDestino()->getName());
                        this->design->removeComponente((*j), NULL);
                    }
                }
            }
        }
    }
    if(this->debug){
        cout<< "----------------------------------" << endl;
        cout<< "----------------------------------" << endl;
        cout<< " FALSE BODY" << endl;
        cout<< "----------------------------------" << endl;
    }
    //if body FALSE
    CompRefAux = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getEIndice()) continue;
        if ((*i)->getIf() == false) continue;
        if ((*i)->getIfBody() == true) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        
        CompRefAux = (*i);
        if(this->debug){
            cout<< "----------------------------------" << endl;
            cout<< " AUX: '" << CompRefAux->getName() <<"'" << endl;
            cout<< "----------------------------------" << endl;
        }
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*i)->node == (*j)->node) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == true) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            
            if (CompRefAux->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    CompRefAux = (*j);
                    if(this->debug){
                        cout<< "NEW AUX: '" << CompRefAux->getName() <<"'" << endl;
                    }
                    continue;
                } else {
                    if (CompRefAux->getNumLinha() >= (*j)->getNumLinha()) continue;
                    if (CompRefAux->getPortDataInOut("OUT")->temLigacao()) {
                        if(this->debug){
                            cout<< "SUB COMP: '" << CompRefAux->getName() <<"' por '" << (*j)->getName() <<"'"<<  endl;
  
                        }   
                        this->design->substiuiComRecorente(CompRefAux, (*j));
                        
                    } else {
                        Componente* CompRefAuxDestino = (*j)->getLigacaoOutDefault()->getDestino();
                        if(this->debug){
                            cout<< "NEW LIG: '" << CompRefAux->getName() <<"' -> '" << (*j)->getName() <<"'"<<  endl;
                        }  
                        this->design->insereLigacao(CompRefAux, CompRefAuxDestino, CompRefAux->getPortDataInOut("OUT")->getName(), (*j)->getLigacaoOutDefault()->getPortDestino()->getName());
                        this->design->removeComponente((*j), NULL);
                    }
                }
            }
        }
    }
}

void analisaIf::buscaIfs(){
    bool exite = false;
    list<Componente*>::iterator i;
    //Pegar todos componentes do tipo cond
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        
        if ((*i)->tipo_comp != CompType::CND) continue;
        this->ligaExpInternoIf((*i));
        this->criaMux((*i));
    }
}

void analisaIf::criaMux(Componente* compIf){
    bool debug = true; 
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    Componente* CompRefAux = NULL;
    Componente* compAuxTrue = NULL;
    Componente* compAuxFalse = NULL;
    
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "IF COMP: "<< compIf->getName() << endl;
        cout<< "##################################" << endl;
        cout<< " Criando componente REG MUX" << endl;
        cout<< "----------------------------------" << endl;
    }
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        compAuxTrue  = NULL;
        compAuxFalse = NULL;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getIf() == false) continue;
        if ((*i)->getIfBody() == false) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        if ((*i)->getPortDataInOut("OUT")->temLigacao() ) continue;
        
        compAuxTrue = (*i);
 
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == true) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if ((*j)->writeEnable != true) continue;
            if ((*j)->getPortDataInOut("OUT")->temLigacao() ) continue;
            if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                compAuxFalse = (*j);
            }
        }
        //Isso ocorre pois nao foi encontrado a referencia da variavel WE no body FALSE do IF entao tem que associar a
        //mesma variavel com WE antes da ocorrencia do IF
        if (compAuxFalse == NULL) {
            compAuxFalse = this->getCompAntesIf( compIf , (*i)->getNomeVarRef());
        }
        if (compAuxFalse == NULL) {
            
        }
        if (compAuxTrue != NULL && compAuxFalse != NULL) {
            
            int linha= compAuxFalse->getNumLinha();
            if (compAuxTrue->getNumLinha() > linha ) linha = compAuxTrue->getNumLinha();

            comp_ref* ref = new comp_ref(NULL, "WE");
            ref->setName("reg_mux_"+compAuxTrue->getNomeVarRef()+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            ref->setNumLinha(linha+1);
            this->design->addComponent(ref);

            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if(ref->getNumLinha() > compAuxTrue->getNumLinha() && ref->getNumLinha() <= (*j)->getNumLinha()){
                    this->design->ListaComp.insert(j, ref);
                }
            }
            
            ref->setTipoVar("VAR");
            ref->setNomeVarRef(compAuxTrue->getNomeVarRef());
            ref->setNumParalelLina(compAuxTrue->getNumParalelLina());

            reg_mux_op* reg = new reg_mux_op(NULL, "WE");
            reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            reg->setName(ref->getName());
            this->design->addComponent(reg);

            ref->setComponenteRef(reg);
            ref->updateCompRef();
            
            if(this->debug){
                cout<< "compAuxTrue:  '" << compAuxTrue->getName() <<"'" << endl;
                cout<< "compAuxFalse: '" << compAuxFalse->getName() <<"'\n" << endl;
                cout<< "REG mux:      '" << reg->getName() <<"'" << endl;
                cout<< "REF mux:      '" << ref->getName() <<"'" << endl;
            }
            
            this->design->insereLigacao(compAuxTrue,  ref, compAuxTrue->getPortDataInOut("OUT")->getName(), "I1");
            this->design->insereLigacao(compAuxFalse, ref, compAuxFalse->getPortDataInOut("OUT")->getName(), "I0");
            this->design->insereLigacao(compAuxTrue->getIfComp(), ref, compAuxTrue->getIfComp()->getPortDataInOut("OUT")->getName(), "Sel1");
        }
    }
}

Componente* analisaIf::getCompAntesIf(Componente* compIf, const string& name){
    Componente* aux = NULL;
    list<Componente*>::iterator j;
    
    cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
    cout<< "IDENTIFICANDO COMP FALSE BODY" << endl;
    cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
    cout<< "Tentando identiciar comp nome: '"<< name << "'" << endl;
    cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
    
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
        if ((*j)->getIf() == true) continue;
        if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
        if ((*j)->getNomeVarRef() == name) {
            if ((*j)->getNumLinha() < compIf->getNumLinha()) {
                aux = (*j);
                break;
            }
        }
    } 
    cout<< "Comp False Body REG SIMPLES:  '"<< aux->getName() << "'" << endl;
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
        if ((*j)->writeEnable != true) continue;
        if ((*j)->getIf() == true) continue;
        if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
        if ((*j)->getNomeVarRef() == name) {
            if ((*j)->getNumLinha() < compIf->getNumLinha()) {
                aux = (*j);
            }
        }
    }
    cout<< "Comp False Body LAST WE:  '"<< aux->getName() << "'" << endl;
    cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
    return aux;
}


Design* analisaIf::getDesign(){
    return this->design;
}

analisaIf::~analisaIf() {
}

