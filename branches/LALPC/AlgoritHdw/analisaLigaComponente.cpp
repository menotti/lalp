/* 
 * File:   analisaLigaComponente.cpp
 * Author: demo
 * 
 * Created on March 13, 2014, 3:00 PM
 */

#include "analisaLigaComponente.h"
#include "../Aux/FuncoesAux.h"
#include <set>
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>

using namespace std;

analisaLigaComponente::analisaLigaComponente(Design* design) {
    this->debug = true;
    this->design = design;
    this->listaComponentes();
}

void analisaLigaComponente::listaComponentes(){
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "LISTANDO COMPONENTES PARA PROCESSO DE LIGACAO"<< endl;
        cout<< "##################################" << endl;
    }
    list<Componente*>::iterator i;
    set<string>ListaAuxString;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if((*i)->tipo_comp != CompType::REF) continue;
        if(this->design->isIndiceVector((*i)->getNomeVarRef()))continue;
        if((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
//        if((*i)->getIf()) continue;
        
        if (ListaAuxString.find((*i)->getNomeVarRef()+(*i)->getNumParalelLina()) == ListaAuxString.end()){
            ListaAuxString.insert((*i)->getNomeVarRef()+(*i)->getNumParalelLina());
            if(this->debug){
                cout<< "### Componente: '"<<(*i)->getNomeVarRef()<< "' Linha Para.: '" <<(*i)->getNumParalelLina()<<"' na linha: '"<<(*i)->getNumLinha()<<"'"<< endl;
                cout<< "----------------------------------" << endl;
            }
            this->ligaComponentes((*i));
        }
    }
}

void analisaLigaComponente::ligaComponentes(Componente* comp){
    list<Componente*>::iterator i;
    if(this->debug){
        cout<< "-Iniciando processo ligar componentes" << endl;
        cout<< "Componente: '"<<comp->getName()<<"' na linha: '"<<comp->getNumLinha()<<"'"<<endl;
        cout<< "----------------------------------" << endl;
    }
    Componente* compAux = NULL;
    compAux = comp;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if(comp == (*i))continue; 
        if((*i)->tipo_comp != CompType::REF) continue; 
        if((*i)->getNomeVarRef() != comp->getNomeVarRef() )continue;
        if(this->design->isIndiceVector((*i)->getNomeVarRef()))continue;
        if((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if((*i)->getNumParalelLina() != comp->getNumParalelLina()) continue;
        
        if((*i)->writeEnable == true){
//            if ((*i)->getIf() == false){
                Componente* aux2 = NULL;
                if(this->debug){
                    cout<< "NOVO WE - Componente: '"<<(*i)->getName()<<"' na linha: '"<<(*i)->getNumLinha()<<"'"<<endl;
                }
                //Verificar se existe um comp NAO WE na mesma linha isso ocorre no processo de empilhamento dos comp na lista
                //ou seja no caso de c = c + 1;  o primeiro 'c' a ser encontrado vai ser o da esquerda (WE) neste caso tem que pegar o ultimo WE
                //e ligar ao 'c' da direita
                aux2 = this->bustaCompNaoWEnaMesmaLinha((*i));
                if(aux2 != NULL){
                    if(this->debug){
                        cout<< "- verficando se exite um comp NAO WE" << endl;
                        cout<< "NAO WE - Componente: '"<<aux2->getName()<<"' na linha: '"<<aux2->getNumLinha()<<"'"<<endl;
                    }
                    this->design->substiuiComRecorente(compAux, aux2);
                }
                compAux = (*i);
//            }
        }else{
            if(compAux->getNumLinha() > (*i)->getNumLinha()) continue;
            if(compAux->getPortDataInOut("OUT")->temLigacao() ){
                if(this->debug){
                    cout<< "- SUB" << endl;
                    cout<< "Componente: '"<<compAux->getName()<<"' linha: '"<< compAux->getNumLinha() <<"' POR: '"<<(*i)->getName()<<"' linha: '"<< (*i)->getNumLinha() <<"'" <<endl;
                }
                this->design->substiuiComRecorente(compAux, (*i));
            }else{
                
                Componente* compAuxDestino = (*i)->getLigacaoOutDefault()->getDestino();
//                        cout<< "-- NEW LIG: '"<< CompRefAux->getName() << "' ->  '" << compAuxDestino->getName()<< "'" << endl;
                this->design->insereLigacao(compAux, compAuxDestino, compAux->getPortDataInOut("OUT")->getName(), (*i)->getLigacaoOutDefault()->getPortDestino()->getName());
                this->design->removeComponente((*i), NULL);
                if(this->debug){
                    cout<< "- ADD" << endl;
                    cout<< "Componente: '"<<compAux->getName()<<"' linha: '"<< compAux->getNumLinha() <<"' POR: '"<<compAuxDestino->getName()<<"' linha: '"<< compAuxDestino->getNumLinha() <<"'" <<endl;
                }
            }
        }
        if(this->debug) cout<< "--------------------------" << endl;
        
    }
     
}

Componente* analisaLigaComponente::bustaCompNaoWEnaMesmaLinha(Componente* compBusca){
    list<Componente*>::iterator i;
    Componente* compReturn = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if(compBusca == (*i))continue; 
        if((*i)->tipo_comp != CompType::REF) continue; 
        if((*i)->getNomeVarRef() != compBusca->getNomeVarRef() )continue;
        if((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if((*i)->getNumParalelLina() != compBusca->getNumParalelLina()) continue;
        if((*i)->writeEnable == true ) continue;
        if((*i)->getNumLinha() == compBusca->getNumLinha()) compReturn = (*i);
    }
    return compReturn;
}

Design* analisaLigaComponente::getDesign(){
    return this->design;
}

void analisaLigaComponente::setDesign(Design* design){
   this->design = design;
}

analisaLigaComponente::~analisaLigaComponente() {
}

