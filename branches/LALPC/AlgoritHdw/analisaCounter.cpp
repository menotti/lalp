/* 
 * File:   analisaCounter.cpp
 * Author: demo
 * 
 * Created on January 30, 2014, 5:52 PM
 */

#include "analisaCounter.h"
#include "../Aux/FuncoesAux.h"
#include "../Componente/comp_ref.h"
#include "../Componente/counter.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>

using namespace std;

analisaCounter::analisaCounter(Design* design) {
    this->debug = false;
    this->design = design;
}

void analisaCounter::ligaContReg(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    
    if(this->debug){
        cout<< "##################################" << endl;
//        cout<< "IF COMP: "<< compIf->getName() << endl;
        cout<< "##################################" << endl;
        cout<< " TRUE BODY" << endl;
        cout<< "----------------------------------" << endl;
    }
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CTD) continue;
        
        if ((*i)->tipo_comp == CompType::CTD) {
            
            counter* CompCounter = (counter*)(*i);
            
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->tipo_comp == CompType::REF) {
                
                comp_ref* CompRef = (comp_ref*)(*j); 
                
                //verificar se o componente e indice... se for remove ele e liga a saida do contador na entrada deste componente
                if (CompRef->getTipoVar() == "VAR" && CompRef->getNomeVarRef() == CompCounter->getVarControlCont()) {
                    
                    if( (*j)->getPortDataInOut("OUT")->temLigacao()){
                        
                        Ligacao* lig = (*j)->getPortDataInOut("OUT")->getLigacao2();
                        if(lig->getAtivo() == false) continue;
                        
                        Componente* CompIndice = lig->getOrigem();
                        
                        lig->editOrig((*i));
                        (*j)->removeLigacao(lig);
                        (*i)->addLigacao(lig);
                        
                        lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                        lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                        lig->setTipo((*i)->getPortDataInOut("OUT")->getType());
                        lig->getPortOrigem()->addLigacao(lig);
                        
                        this->design->removeComponente((*j), NULL);                     
                    }
                }else{
                    if (CompRef->getTipoVar() != "VAR"){
                        
                    }
                    if (CompRef->getTipoVar() != "VET"){
                        
                    }
                }
            } 
        }
    }
}

analisaCounter::~analisaCounter() {
}

