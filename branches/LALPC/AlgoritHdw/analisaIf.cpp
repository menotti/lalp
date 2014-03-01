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
#include "../Componente/neg_op_s.h"
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

bool analisaIf::verificaCompExisteBodyTrueEFalse(Componente* compIf, Componente* compAtual){
    //verificar se existe o comp no body true e no false.
    //pois se existir precisa de MUX
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "VERIFICANDO SE COMPONENTE APARECE DUAS VEZES NO IF - BODY TRUE E FALSE" << endl;
        cout<< "Componente IF: '"<< compIf->getName() <<"'" << endl;
        cout<< "Componente   : '"<< compAtual->getName() <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    list<Componente*>::iterator i;
    bool res = false;
    bool existeTrue  = false;
    bool existeFalse = false;
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
//        if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->getIfBody() == false) continue;
        if ((*i)->writeEnable == false) continue;
        if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
            existeTrue = true;
            if(this->debug == true){
                cout<< "- Achou ocorrencia body TRUE do IF na linha: '"<< (*i)->getNumLinha() << "'" << endl;
            }
            break;
        }
    }
    
    if (existeTrue) {
        for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
            if ((*i)->tipo_comp != CompType::REF) continue;
            if ((*i)->getEIndice()) continue;
//            if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
            if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
            if ((*i)->getIfComp() != compIf) continue;
            if ((*i)->getIfBody() == true) continue;
            if ((*i)->writeEnable == false) continue;
            if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
                existeFalse = true;
                if(this->debug == true){
                    cout<< "- Achou ocorrencia body FALSE do IF na linha: '"<< (*i)->getNumLinha() << "'" << endl;
                }
                break;
            }
        }
    }
    
    if( existeTrue == true && existeFalse == true ) res = true;
    if(this->debug == true){
        if (res){
            cout<< "% Este componente existe no body TRUE e FALSE logo ele precisa de um MUX" << endl;
        }else{
            cout<< "% Este componente NAO aparece duas VEZES - no body TRUE e FALSE logo ele NAO precisa de um MUX" << endl;
        }
        cout<< "----------------------------------------" << endl;
    }
    return res;
}

bool analisaIf::verificaCompAntesIf(Componente* compIf, Componente* compAtual){
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "VERIFICANDO SE COMPONENTE APARECE ANTES DO IF" << endl;
        cout<< "Componente IF: '"<< compIf->getName() <<"'" << endl;
        cout<< "Componente   : '"<< compAtual->getName() <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    list<Componente*>::iterator i;
    bool res = false;
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getIf() == true) continue;        
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
        if (compAtual->node == (*i)->node) continue;
        if (compIf->getNumLinha() < (*i)->getNumLinha()) continue;
        if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
            res = true;
            if(this->debug == true){
                cout<< "- Achou ocorrencia antes do IF na linha: '"<< (*i)->getNumLinha() << "'" << endl;
            }
            break;
        }
    }
    
    return res;
    if(this->debug == true){
        cout<< "----------------------------------------" << endl;
    }
}

void analisaIf::criaLigIfParaPortaWE(Componente* comp){
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "CRIANDOP LIGACAO ENTRE IF E COMPONENTE UTILIZANDO A PORTA WE" << endl;
        cout<< "Componente IF: '"<< comp->getIfComp()->getName() <<"'" << endl;
        cout<< "Componente   : '"<< comp->getName() <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    if(comp->getIfBody()){
        this->design->insereLigacao(comp->getIfComp(), comp, "O0", "we");
    }else{
        //Criar componente NEG e colocar entre o IF e o COMP *I
        neg_op_s* negComp = new neg_op_s(NULL);
        negComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        negComp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
        negComp->setNumParalelLina(comp->getIfComp()->getNumParalelLina());
        negComp->setNumLinha(comp->getIfComp()->getNumLinha());
   
        this->design->addComponent(negComp);
        this->design->insereLigacao(comp->getIfComp(), negComp, "O0", "I0");
        this->design->insereLigacao(negComp, comp, "O0", "we");
    }
    comp->setIf(false);
}

void analisaIf::analiseProcessoCriaMux(Componente* compIf){
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        if ((*i)->tipo_comp != CompType::REF) continue;
        
        comp_ref* CompRefI = (comp_ref*) (*i);
        if (CompRefI->getTipoVar() == "VET") {
            if (this->verificaCompExisteBodyTrueEFalse(compIf,(*i)) == false){
                this->criaLigIfParaPortaWE((*i));
            }else{
                cout<< "ERROR: utilizando duas escritas na mesma memoria - operacao nao permitida..." << endl;
                exit(EXIT_FAILURE);
            }
        }else{
            //Verificar se existe qualquer ocorrencia do componente antes do IF
            //se nao existir setar saida do IF para a porta WE deste componente
            //NAO PODE TER ELEMENTO no Body FALSE do IF
            if(this->verificaCompExisteBodyTrueEFalse(compIf,(*i)) == false  && this->verificaCompAntesIf(compIf,(*i)) == false){
                this->criaLigIfParaPortaWE((*i));
            }else{
                if(this->verificaCompPrecisaMux(compIf,(*i)) == true){
                    this->criaComponenteMux(compIf, (*i));
                }
            }
        }
    }
   
}

void analisaIf::buscaIfs(){
    list<Componente*>::iterator i;
    //Pegar todos componentes do tipo cond
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        
        if ((*i)->tipo_comp != CompType::CND) continue;
        this->ligaExpInternoIf((*i));
        this->analiseProcessoCriaMux((*i));
    }
}

/*
 * Verificar se todas as variaveis dentro do IF precisam de um MUX
 * isso ocorre quando a variavel tem seu valor modificado dentro do IF 
 * e esta e utilizada fora do IF     
 */
bool analisaIf::verificaCompPrecisaMux(Componente* compIf, Componente* compAtual){

    list<Componente*>::iterator i;
    bool res            = false;
    bool existeMux      = false;
    
    int numLinha = 0;
    
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "VERIFICANDO SE COMPONENTE PRECISA DE MUX" << endl;
        cout<< "Componente IF: '"<< compIf->getName() <<"'" << endl;
        cout<< "Componente   : '"<< compAtual->getName() <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    if(this->debug == true){
        cout<< "----------------------------------------" << endl;
        cout<< "VERIFICANDO SE JA EXISTE O MUX" << endl;
        cout<< "----------------------------------------" << endl;
    }
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->getNomeVarRef() != compAtual->getNomeVarRef()) continue;
        
        if ((*i)->getComponenteRef()->getNomeCompVHDL() == "reg_mux_op") { 
            existeMux = true;
        }
    }
    
    if(this->debug == true){
        if (existeMux){
            cout<< "Existe Mux para este Componente" << endl;
        }else{
            cout<< "NAO existe Mux para este Componente" << endl;
            res = true;
        }
    }
    
//    if(!existeMux){
//        //Pega a ultima ocorrencia WE dentro do IF - vai servir para identificar se abaixo
//        //uma utilizacao deste componente - neste caso - a necessidade de um MUX
//        for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//            if ((*i)->getIfComp() != compIf) continue;
//            if ((*i)->writeEnable != true) continue;
//            if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) numLinha = (*i)->getNumLinha();
//        }
//        if(this->debug == true){
//            cout<< "----------------------------------------" << endl;
//            cout<< "IF Linha                 : '"<< compIf->getNumLinha() <<"'" << endl;
//            cout<< "ultimmo Comp WE na Linha : '"<< numLinha <<"'" << endl;
//            cout<< "----------------------------------------" << endl;
//        }
//        if (numLinha > compIf->getNumLinha()){
//            if(this->debug == true){
//                cout<< "Achou componente dentro IF" << endl;
//            }
//            
//            //Aqui verifica se utiliza o componente depois do bloco do IF
//            for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//                if ((*i)->getIf() == true) continue; //pesquisar componentes fora do IF
//                if ((*i)->getNomeVarRef() != compAtual->getNomeVarRef()) continue;
//                if ((*i)->getNumLinha() > numLinha) {
//                    if ((*i)->writeEnable == true) break; //Nao pode ser WE
//                    res = true;
//                    if(this->debug == true){
//                        cout<< "Achou componente que precisa do MUX depois do IF na Linha: '" << (*i)->getNumLinha() << "'" << endl;
//                    }
//                    break;
//                }
//            }
//            
////            if(!res){
////                if(this->debug == true){
////                    cout<< "Verficar se existe dependencia (componente vai ter o valor atualizado no incio do for) " << endl;
////                    cout<< "neste caso pode existir a necessidade da criacao do mux " << endl;
////                }
////                bool auxWE = false;
////                int  linhaAux = 0;
////                string res = "";
////                for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
////                    if ((*i)->tipo_comp != CompType::REF) continue;
////                    if ((*i)->getEIndice()) continue;
////                    if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
////                    if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
////                    if (compAtual->node == (*i)->node) continue;
////                    if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
////                        if ((*i)->writeEnable == true) {
////                            if(this->debug == true){
////                                auxWE = true;
////                                linhaAux = (*i)->getNumLinha();
////                            }
////                            continue;
////                        }else{
////                            if ((*i)->getPortDataInOut("IN")->temLigacao() == false) {
////                                if(auxWE){
////                                    if ((*i)->getNumLinha() == linhaAux){
////                                        res = true;
////                                        teste = true;
////                                        cout<< "Achou componente sem LIG na PORTA 'IN' na linha: '" << (*i)->getNumLinha() << "'-- PRECISA DO MUX 1" << endl;
////                                        break;
////                                    }
////                                }else{
////                                    res = true;
////                                    teste = true;
////                                    cout<< "Achou componente sem LIG na PORTA 'IN' na linha: '" << (*i)->getNumLinha() << "'-- PRECISA DO MUX " << endl;
////                                    break;
////                                }
////                            }
////                        }
////                    }
////                }
////            }
//        }
//        if(this->debug == true){
//            if (res == false){
//                cout<< "Nao achou componente que precisa do MUX" << endl;
////                if (teste == true){
////                    res = true;
////                }
//            }
//        }
//    }
    if(this->debug == true){
        cout<< "----------------------------------------" << endl;
    }
    return res;
}

Componente* analisaIf::getCompAntesIf(Componente* compIf, const string& name){
    Componente* aux = NULL;
    list<Componente*>::iterator j;
    if(this->debug){
       cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
       cout<< "IDENTIFICANDO COMP ANTES IF" << endl;
       cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
       cout<< "Tentando identiciar comp nome: '"<< name << "'" << endl;
       cout<< "++++++++++++++++++++++++++++++++++++++" << endl;
    }
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
        if ((*j)->getIf() == true) continue;
        if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
        if ((*j)->getNomeVarRef() == name) {
            if((*j)->getNumLinha() <= compIf->getNumLinha()){
                aux = (*j);
                //break;
            }
        }
    }
    if(this->debug){
        cout<< "Comp False Body REG SIMPLES:  '"<< aux->getName() << "'" << endl;
    }
    return aux;
}

void analisaIf::criaComponenteMux(Componente* compIf, Componente* compAtual){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;

    Componente* compAuxTrue = NULL;
    Componente* compAuxFalse = NULL;
    
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "IF COMP: "<< compIf->getName() << endl;
        cout<< "##################################" << endl;
        cout<< " Criando componente REG MUX para: '" << compAtual->getName()<< "'" << endl;
        cout<< "----------------------------------" << endl;
    }
    
    //Pegar Componente do Body TRUE
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
        if ((*j)->getIf() == false) continue;
        if ((*j)->getIfBody() == false) continue;
        if ((*j)->getIfComp() != compIf) continue;
        if ((*j)->writeEnable != true) continue;
        if (compAtual->getNomeVarRef() == (*j)->getNomeVarRef()) {
            compAuxTrue = (*j);
        }
    }
    
    //Pegar Componente do Body FALSE
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
        if ((*j)->getIf() == false) continue;
        if ((*j)->getIfBody() == true) continue;
        if ((*j)->getIfComp() != compIf) continue;
        if ((*j)->writeEnable != true) continue;
        if (compAtual->getNomeVarRef() == (*j)->getNomeVarRef()) {
            compAuxFalse = (*j);
        }
    }
    
    //Caso a variavel tenha o valor modificado apenas no corpo FALSE do IF
    //tem que pegar a ultima ocorrencia desta no ultimo WE ante do IF
    if (compAuxTrue == NULL) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
            if ((*j)->getIf() == true) continue;
            if ((*j)->writeEnable != true) continue;
            if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            if ((*j)->getNomeVarRef() == compAtual->getNomeVarRef()) {
                if((*j)->getNumLinha() <= compIf->getNumLinha()){
                    compAuxTrue = (*j);
                }
            }
        }
    }
    
    //Pegar a primeira ocorrencia do COMP IDEPENDENTE SE e WE
    if (compAuxTrue == NULL) {
        compAuxTrue = this->getCompAntesIf(compIf , compAtual->getNomeVarRef());
    }
    
    //Caso a variavel tenha o valor modificado apenas no corpo TRUE do IF
    //tem que pegar a ultima ocorrencia desta no ultimo WE ante do IF
    if (compAuxFalse == NULL) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
            if ((*j)->getIf() == true) continue;
            if ((*j)->writeEnable != true) continue;
            if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            if ((*j)->getNomeVarRef() == compAtual->getNomeVarRef()) {
                if((*j)->getNumLinha() <= compIf->getNumLinha()){
                    compAuxFalse = (*j);
                }
            }
        }
    }
    if (compAuxFalse == NULL) {
        compAuxFalse = this->getCompAntesIf(compIf , compAtual->getNomeVarRef());
    }
    
    //Criar Compoente REF e um REG MUX 
    if (compAuxTrue != NULL && compAuxFalse != NULL) {
        
        if(this->debug){
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
            cout<< " Criando componente REG MUX para: '" << compAtual->getName()<< "'" << endl;
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
            cout<< " LISTA ANTES CRIAR REG"<< endl;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                if((*j)->getNomeVarRef() != compAtual->getNomeVarRef()) continue;
                string res = "";
                if ( (*j)->writeEnable == true){
                    res += "(WE) ";
                }else{
                    res += "(  ) ";
                }
                res += "'" + (*j)->getName() + "' na LINHA: ";
                cout << res << (*j)->getNumLinha() << endl; 
            }
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
        }
        int linha = 0;

        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if ((*j)->getComponenteRef()->getNomeCompVHDL() == "reg_mux_op") continue;
            if ((*j)->getNumLinha() >= linha) {
                linha   = (*j)->getNumLinha();

            }
        }

        comp_ref* ref = new comp_ref(NULL, "WE");
        ref->setName("reg_mux_"+compAuxTrue->getNomeVarRef()+FuncoesAux::IntToStr(this->design->ListaComp.size()));
        ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        
        ref->setNumParalelLina(compAuxTrue->getNumParalelLina());      
        ref->setNumLinha(linha+1);
        

        ref->setTipoVar("VAR");
        ref->setNomeVarRef(compAuxTrue->getNomeVarRef());
        ref->setNumParalelLina(compAuxTrue->getNumParalelLina());
        ref->setIfComp(compIf);

        reg_mux_op* reg = new reg_mux_op(NULL, "WE");
        reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        reg->setName(ref->getName());
        this->design->addComponent(reg);

        ref->setComponenteRef(reg);
        ref->updateCompRef();
        
        
        bool auxFind = false;
        
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;            
            if (ref->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            if((*j)->getNomeVarRef() != ref->getNomeVarRef()) continue;
            if (ref->getNumLinha() < (*j)->getNumLinha()) {
                auxFind = true;
                this->design->ListaComp.insert(j, ref);
                break;
            }
        }
        //Caso for o ultimo elemento
        if(!auxFind){
            this->design->addComponent(ref);
        }
        
        if(this->debug){
            cout<< "compAuxTrue:  '" << compAuxTrue->getName() <<"' na linha: '" << compAuxTrue->getNumLinha() <<  "' :: ("<< compAuxTrue->getNomeVarRef()<< ")" << endl;
            cout<< "compAuxFalse: '" << compAuxFalse->getName() <<"' na linha: '" <<  compAuxFalse->getNumLinha() << "' :: ("<<  compAuxFalse->getNomeVarRef()<< ")" << endl;
            cout<< "REG mux:      '" << reg->getName() <<"'" << endl;
            cout<< "REF mux:      '" << ref->getName() <<"' na linha: '" <<  ref->getNumLinha() <<  "' :: ("<<  ref->getNomeVarRef()<< ")" << endl;
        }
        this->design->insereLigacao(compAuxTrue,  ref, compAuxTrue->getPortDataInOut("OUT")->getName(), "I1");
        this->design->insereLigacao(compAuxFalse, ref, compAuxFalse->getPortDataInOut("OUT")->getName(), "I0");
        this->design->insereLigacao(compIf, ref, compIf->getPortDataInOut("OUT")->getName(), "Sel1");
        
        if(this->debug){
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                if((*j)->getNomeVarRef() != compAtual->getNomeVarRef()) continue;
                string res = "";
                if ( (*j)->writeEnable == true){
                    res += "(WE) ";
                }else{
                    res += "(  ) ";
                }
                res += "'" + (*j)->getName() + "' na LINHA: ";
                cout << res << (*j)->getNumLinha() << endl; 
            }
            cout<< "++++++++++++++++++++++++++++++++++++++++" << endl;
        }
    }
    
}

Design* analisaIf::getDesign(){
    return this->design;
}

analisaIf::~analisaIf() {
}

