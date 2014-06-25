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
#include "../Componente/not_op.h"
#include "../Componente/neg_op_s.h"
#include "../Componente/and_op.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>
#include <list>

using namespace std;

analisaIf::analisaIf(Design* design) {
    this->debug = false;
    this->design = design;
    this->buscaIfs();
}

void analisaIf::ligaExpInternoIf(Componente* compIf){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    Componente* CompRefAux = NULL;
    
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "IF COMP: '"<< compIf->getName() << "' linha: " << compIf->getNumLinha() << endl;
        cout<< "##################################" << endl;
        cout<< " TRUE BODY" << endl;
        cout<< "----------------------------------" << endl;
    }
    //if body TRUE
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getIf() == false) continue;
        if ((*i)->getIfBody() == false) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        
        CompRefAux = (*i);
        if(this->debug){
            cout<< "----------------------------------" << endl;
            cout<< " AUX: '" << CompRefAux->getName() <<"' - '"<< CompRefAux->getNomeVarRef() << "' linha: " << compIf->getNumLinha() << endl;
            cout<< "----------------------------------" << endl;
        }
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if (CompRefAux->node == (*j)->node) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == false) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if (CompRefAux->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            
            if (CompRefAux->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    CompRefAux = (*j);
                    if(this->debug){
                        cout<< "NEW AUX: '" << (*j)->getName() <<"' - '"<< (*j)->getNomeVarRef()  << "' linha: " << compIf->getNumLinha() << endl;
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
        if(this->debug)cout<< "==================================" << endl;
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
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getIf() == false) continue;
        if ((*i)->getIfBody() == true) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        
        CompRefAux = (*i);
        if(this->debug){
            cout<< "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" << endl;
            cout<< " AUX: '" << CompRefAux->getName() <<"' - '"<< CompRefAux->getNomeVarRef() << "' linha: " << CompRefAux->getNumLinha() << endl;
            cout<< "----------------------------------" << endl;
        }
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if (CompRefAux->node == (*j)->node) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == true) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if (CompRefAux->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            
            if (CompRefAux->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    CompRefAux = (*j);
                    if(this->debug){
                        cout<< "NEW AUX: '" << CompRefAux->getName() << "' linha: " << CompRefAux->getNumLinha() << endl;
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

bool analisaIf::verificaCompExisteBodyTrueEFalse(Componente* compIf, Componente* compAtual, bool corpo, bool isWE){
    list<Componente*>::iterator i;
    //verificar se existe o comp no body true e no false.
    //pois se existir precisa de MUX
    string auxDebug     = "FALSE";
    string auxDebugWE   = "NAO WE";
    if(corpo) auxDebug  = "TRUE";
    if(isWE) auxDebugWE = "WE";
    if(this->debug == true){
        
        cout<< "========================================" << endl;
        cout<< "VERIFICANDO SE COMPONENTE APARECE CORPO DO IF: '"<< auxDebug <<"'" << endl;
        cout<< "Componente IF : '"<< compIf->getName() <<"'" << endl;
        cout<< "Componente    : '"<< compAtual->getName() <<"'" << endl;
        cout<< "Componente FOR: '"<< compAtual->getForComp()->getName()  <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    
    bool res = false;   
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
//        if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if (!(*i)->getIfBody() == corpo) continue;
        if (!(*i)->writeEnable == isWE) continue;
        if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
            res = true;
            if(this->debug == true){
                cout<< "- Achou ocorrencia "<<  auxDebugWE << " da variavel no body '"<< auxDebug<< "' do IF na linha: '"<< (*i)->getNumLinha() << "'" << endl;
            }
            break;
        }
    }
//    
//    if (existeTrue) {
//        for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//            if ((*i)->tipo_comp != CompType::REF) continue;
//            if ((*i)->getEIndice()) continue;
////            if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
//            if ((*i)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
//            if ((*i)->getIfComp() != compIf) continue;
//            if ((*i)->getIfBody() == true) continue;
//            if ((*i)->writeEnable == false) continue;
//            if ((*i)->getNomeVarRef() == compAtual->getNomeVarRef()) {
//                existeFalse = true;
//                if(this->debug == true){
//                    cout<< "- Achou ocorrencia body FALSE do IF na linha: '"<< (*i)->getNumLinha() << "'" << endl;
//                }
//                break;
//            }
//        }
//    }
//    
//    if( existeTrue == true && existeFalse == true ) res = true;
    if(this->debug == true){
        if (!res){
            cout<< "% NAO EXISTE este componente WE no body '"<< auxDebug<< "'"<< endl;
        }
        cout<< "----------------------------------------" << endl;
    }
    return res;
}

bool analisaIf::verificaCompAntesIf(Componente* compIf, Componente* compAtual){
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "VERIFICANDO SE COMPONENTE APARECE ANTES DO IF" << endl;
        cout<< "Componente IF : '"<< compIf->getName() <<"' na linha: '" << compIf->getNumLinha() << "'" << endl;
        cout<< "Componente    : '"<< compAtual->getName() <<"' na linha: '" << compAtual->getNumLinha() << "'" << endl;
        cout<< "Componente FOR: '"<< compAtual->getForComp()->getName()  <<"' na linha: '" << compAtual->getForComp()->getNumLinha() << "'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    list<Componente*>::iterator k;
 
    bool res = false;
    
    for (k = this->design->ListaComp.begin(); k != this->design->ListaComp.end(); k++) {
        if ((*k)->tipo_comp != CompType::REF) continue;
//        cout << (*k)->getName() << " - "<< (*k)->getNomeVarRef() << " - NumL: " << (*k)->getNumLinha()  << " - PL: " << (*k)->getNumParalelLina() << endl;
        if ((*k)->getNumParalelLina() != compAtual->getNumParalelLina()) continue;
        if (compIf->getNumLinha() <= (*k)->getNumLinha()) continue;
        if ((*k)->getNomeVarRef() == compAtual->getNomeVarRef()) {
            res = true;
            if(this->debug == true){
                cout<< "- Achou ocorrencia antes do IF na linha: '"<< (*k)->getNumLinha() << "'" << endl;
            }
        }
    }

    if(this->debug == true){
        if(res == false) cout<< "- NAO Achou ocorrencia antes do IF para o componente: '"<< compAtual->getName() << "'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    
    return res;
}

void analisaIf::criaLigIfParaPortaWE(Componente* comp){
    if(this->debug == true){
        cout<< "========================================" << endl;
        cout<< "CRIANDOP LIGACAO ENTRE IF E COMPONENTE UTILIZANDO A PORTA WE" << endl;
        cout<< "Componente IF : '"<< comp->getIfComp()->getName() <<"'" << endl;
        cout<< "Componente    : '"<< comp->getName() <<"'" << endl;
        cout<< "Componente FOR: '"<< comp->getForComp()->getName()  <<"'" << endl;
        cout<< "----------------------------------------" << endl;
    }
    and_op* andCompAux = new and_op(NULL, 1);
    andCompAux->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    andCompAux->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
    andCompAux->setNumParalelLina(comp->getIfComp()->getNumParalelLina());
    andCompAux->setNumLinha(comp->getIfComp()->getNumLinha());
    this->design->addComponent(andCompAux);
        
    Componente* compAuxFor = NULL;
    compAuxFor = comp->getForComp();
    if(compAuxFor == NULL) compAuxFor = comp->getIfComp()->getForComp();
    if(comp->getIfBody()){
        this->design->insereLigacao(comp->getIfComp(), andCompAux, "O0"  , "I0");
        this->design->insereLigacao(compAuxFor       , andCompAux, "step", "I1");
        this->design->insereLigacao(andCompAux, comp, "O0", "we");
        
    }else{
        
        //Criar componente NEG e colocar entre o IF e o COMP *I
        not_op* negComp = new not_op(NULL, 1);
        negComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        negComp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
        negComp->setNumParalelLina(comp->getIfComp()->getNumParalelLina());
        negComp->setNumLinha(comp->getIfComp()->getNumLinha());
   
        this->design->addComponent(negComp);
        
        this->design->insereLigacao(comp->getIfComp(), negComp, "O0", "I0");
        this->design->insereLigacao(negComp   , andCompAux, "O0", "I0");
        this->design->insereLigacao(compAuxFor, andCompAux, "step", "I1");
        
        this->design->insereLigacao(andCompAux, comp, "O0", "we");
        
    }
    comp->setIf(false);
}

void analisaIf::analiseProcessoCriaMux(Componente* compIf){
    list<Componente*>::iterator i;
    
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getNomeCompVHDL() == "reg_mux_op") continue;
        
        
        comp_ref* CompRefI = (comp_ref*) (*i);
        if (CompRefI->getTipoVar() == "VET") {
            bool ExisteNoTrue       = false;
            bool ExisteNoFalse      = false;
            
            ExisteNoTrue            = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),true, true);
            ExisteNoFalse           = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),false,true);
            if (ExisteNoTrue == true && ExisteNoFalse == true){
                //this->criaLigIfParaPortaWE((*i));
                cout<< "ERROR: utilizando duas escritas na mesma memoria - operacao nao permitida..." << endl;
                cout<< "Componente IF: " << compIf->getNumLinha()<< endl;
                exit(EXIT_FAILURE);
            }
        }else{
            //Verificar se existe qualquer ocorrencia do componente antes do IF
            //se nao existir setar saida do IF para a porta WE deste componente
            //NAO PODE TER ELEMENTO no Body FALSE do IF
            
            bool ExisteAntesIf      = false;
            bool ExisteNoTrueFalse  = false;
            bool ExisteNoTrue       = false;
            bool ExisteNoFalse      = false;
            
            ExisteNoTrue            = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),true, true);
            ExisteNoFalse           = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),false,true);
            if(ExisteNoTrue && ExisteNoFalse) ExisteNoTrueFalse = true;
            
            if(!ExisteNoTrueFalse) ExisteAntesIf      = this->verificaCompAntesIf(compIf,(*i));
            if(ExisteNoTrueFalse || ExisteAntesIf){
                if(this->verificaCompPrecisaMux(compIf,(*i)) == true){
                    this->criaComponenteMux(compIf, (*i));
                }
            }else{
                //Nova condicao necessaria o componnente existe em um determinado corpo do IF - TRUE/FALSE
                //porem nao existe nenhuma referencia antes do if E existe um componente do tipo nao WE no outro BODY
                //existe um WE no ELSE e um componente NAO WE no IF - neste caso existe a necessidade do MUX para condicoes de 
                //dependencia....
                if(ExisteAntesIf == false && (ExisteNoTrue || ExisteNoFalse)){
                    bool existeRefNaoWEnoFALSE = false;
                    bool existeRefNaoWEnoTRUE  = false;
                    
                    if (ExisteNoTrue) existeRefNaoWEnoFALSE = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),false,false);
                    if (ExisteNoFalse) existeRefNaoWEnoTRUE = this->verificaCompExisteBodyTrueEFalse(compIf,(*i),true ,false);
                    
                    if (ExisteNoTrue || ExisteNoFalse) this->criaComponenteMux(compIf, (*i));
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
        this->conectaCompIfSemMux((*i));
    }

    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CND) continue;
        this->finalizaDependenciaMux((*i));
    }
}

void analisaIf::conectaCompIfSemMux(Componente* compIf){
    list<Componente*>::iterator i;
//    cout<< "========================================" << endl;
//    cout<< "LIGANDO IF NA PORTA WE DOS COMP SEM MUX " << endl;
//    cout<< "Componente IF: '"<< compIf->getName() <<"'" << endl;
//    cout<< "----------------------------------------" << endl;
    
    Componente* compNexAux = NULL;
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        if ((*i)->getNomeCompVHDL() == "reg_mux_op") continue;
        if ((*i)->getIf() != true) continue;
        
        if((*i)->getPortOther("we")->temLigacao() == false){
            Ligacao* newLig = NULL;
            if((*i)->getIfBody() == true){
                newLig = this->design->insereLigacao(compIf, (*i), compIf->getPortDataInOut("OUT")->getName(), "we");
            }else{
                if(compNexAux == NULL){
                    neg_op_s* comp = new neg_op_s(NULL, 1);
                    comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    comp->setNumParalelLina(compIf->getNumParalelLina());
                    this->design->addComponent(comp);
                    compNexAux = comp;
                    Ligacao* newLigAux = NULL;
                    newLigAux = this->design->insereLigacao(compIf, compNexAux, compIf->getPortDataInOut("OUT")->getName(), compNexAux->getPortDataInOut("IN")->getName());
                }
                newLig = this->design->insereLigacao(compNexAux, (*i), compNexAux->getPortDataInOut("OUT")->getName(), "we");
            }
//            cout<< "Componente  : '"<< (*i)->getName() <<"'" << endl;
//            cout<< "Ligacao     : '"<< newLig->getNome() <<"'" << endl;
//            cout<< "----------------------------------------" << endl;
            newLig->setIfEdge(true);
        }
        
    }
}

void analisaIf::finalizaDependenciaMux(Componente* compIf){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
//    cout<< "========================================" << endl;
//    cout<< "PROCURANDO DEPENDENCIA PARA CRIAR MUX   " << endl;
//    cout<< "Componente IF: '"<< compIf->getName() <<"'" << endl;
//    cout<< "----------------------------------------" << endl;
    Componente* compAuxTrue = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getIfComp() != compIf) continue;
        if ((*i)->writeEnable != true) continue;
        if ((*i)->getNomeCompVHDL() != "reg_op") continue;
        if ((*i)->getIf() != true) continue;
        if ((*i)->getPortOther("we")->temLigacao() == true && (*i)->getPortOther("we")->getLigacao2()->getIfEdge() == true){
//            cout<< "Comp: '"<< (*i)->getName() <<"'" << endl;
//            cout<< "-tentando buscar componente relacionado com a dependencia" << endl;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                if ((*i)->getNumLinha() >= (*j)->getNumLinha()) continue;
                if ((*j)->getNomeCompVHDL() != "reg_op" && (*j)->getNomeCompVHDL() != "reg_mux_op" ) continue;
                if ((*j)->getIfComp() == compIf) continue;
                if ((*j)->writeEnable != true) continue;

                if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                    compAuxTrue = (*j);
//                    cout<< "--achou componente: '" <<   (*j)->getName() << "'" << endl;
                }
            }
            
        }
        if (compAuxTrue != NULL){
//            cout<< "--DEPENDENCIA existente entre: '" <<   compAuxTrue->getName() << "linha: "<< compAuxTrue->getNumLinha() << "' -> '"<<(*i)->getName()<< "' linha: "<< (*i)->getNumLinha()    << endl;
             
            comp_ref* ref = new comp_ref(NULL, "WE", (*i)->dataWidth);
    //        string name = this->design->getNomeCompRef(compAuxTrue->getNomeVarRef());
            string name = (*i)->getName();
            ref->setName(name);
            ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));

            ref->setNumParalelLina((*i)->getNumParalelLina());      
            ref->setNumLinha((*i)->getNumLinha());

            ref->setTipoVar("VAR");
            ref->setNomeVarRef((*i)->getNomeVarRef());

            ref->setIfComp(compIf);

            reg_mux_op* reg = new reg_mux_op(NULL, "WE", (*i)->dataWidth);
            reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            reg->setName(ref->getName());
            this->design->addComponent(reg);

            ref->setComponenteRef(reg);
            ref->updateCompRef();
            ref->setDelayValComp((*i)->getDelayValComp());
            
            Ligacao* ligIN  = NULL;
            Ligacao* ligWE  = NULL;
            Ligacao* ligOUT = NULL;

            if ((*i)->getPortDataInOut("IN")->temLigacao() ) ligIN  = (*i)->getPortDataInOut("IN")->getLigacao2();
            if ((*i)->getPortDataInOut("OUT")->temLigacao()) ligOUT = (*i)->getPortDataInOut("OUT")->getLigacao2();
            if ((*i)->getPortOther("we")->temLigacao())      ligWE  = (*i)->getPortOther("we")->getLigacao2();
 
            (*i)->removeLigacao(ligIN);
            (*i)->removeLigacao(ligOUT);
            (*i)->removeLigacao(ligWE);
     
            Componente* CompIN  = ligIN->getOrigem();
            string      portIN  = ligIN->getPortOrigem()->getName();
            
            Componente* CompWE  = ligWE->getOrigem();
            string      portWE  = ligWE->getPortOrigem()->getName();
            
            Componente* CompOUT = ligOUT->getDestino();
            string      portOUT = ligOUT->getPortDestino()->getName();

            CompIN->removeLigacao(ligIN);
            CompOUT->removeLigacao(ligOUT);
            CompWE->removeLigacao(ligWE);

            this->design->insereLigacao(CompIN, ref    , portIN, "I1");
            this->design->insereLigacao(CompWE, ref    , portWE, "Sel1");
            this->design->insereLigacao(ref   , CompOUT, "O0", portOUT);
 
            this->design->deletaLigacao(ligIN->getNome());
            this->design->deletaLigacao(ligOUT->getNome());
            this->design->deletaLigacao(ligWE->getNome());
  
            //Inserindo Ligacao de dependencia
            this->design->insereLigacao(compAuxTrue, ref, "O0", "I0");
            
            (*i) = ref;
        }
        //criar MUx
        
       
    }
    //Verficair se existe componente dentro do IF
    
    
    //verificar se existe mux
    //SE NAO
    
    //verficicar se exite dependencia
    
}


/*
 * Verificar se todas as variaveis dentro do IF precisam de um MUX
 * isso ocorre quando a variavel tem seu valor modificado dentro do IF 
 * e esta e utilizada fora do IF     
 */
bool analisaIf::verificaCompPrecisaMux(Componente* compIf, Componente* compAtual){

    list<Componente*>::iterator i;
    bool precisa      = true;
    
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
            precisa = false;
        }
    }
    

    if (!precisa){
        if(this->debug == true) cout<< "Existe Mux para este Componente" << endl;
    }else{
        if(this->debug == true) cout<< "NAO existe Mux para este Componente" << endl;
    }

 
    if(this->debug == true)cout<< "----------------------------------------" << endl;
    
    return precisa;
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
    bool res = false;
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->getEIndice()) continue;
//        if ((*j)->getIf() == true) continue;
        if (compIf->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
        if ((*j)->getNomeVarRef() == name) {
            if((*j)->getNumLinha() <= compIf->getNumLinha()){
                aux = (*j);
                res = true;
                //break;
            }
        }
    }
    if(this->debug){
        if(res){
            cout<< "ACHOU Comp REG SIMPLES antes do IF:  '"<< aux->getName() << "'" << endl;
        }else{
            cout<< "NAO ACHOU Comp REG SIMPLES antes do IF"<< endl;
        }
    }
    return aux;
}

void analisaIf::criaComponenteMux(Componente* compIf, Componente* compAtual){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;

    Componente* compAuxTrue     = NULL;
    Componente* compAuxFalse    = NULL;
    
    bool        deletaCompTrue  = true;
    bool        deletaCompFalse = true;
    
    if(this->debug){
        cout<< "##################################" << endl;
        cout<< "IF COMP: "<< compIf->getName() << endl;
        cout<< "##################################" << endl;
        cout<< " Criando componente REG MUX para: '" << compAtual->getName()<< "'" << endl;
        cout<< "----------------------------------" << endl;
    }
    
    //Pegar Componente do Body TRUE QUANDO e WE
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
    
    //Pegar Componente do Body FALSE QUANDO e WE
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
//            if ((*j)->getIf() == true) continue;
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
        deletaCompTrue = false;
    }
    
    //Pegar Componente do Body TRUE quando nao e WE isso ocorre quando nao satisfaz 
    //as condicoes anteriores nao achou WE - nao achou WE antes do IF - nao achou o comp NAO WE antes do IF
    //agora pegar comp nao WE no IF
    if (compAuxTrue == NULL) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == false) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if (compAtual->getNomeVarRef() == (*j)->getNomeVarRef()) {
                compAuxTrue = (*j);
                deletaCompTrue  = false;
            }
        }
    }
    
    //Caso a variavel tenha o valor modificado apenas no corpo TRUE do IF
    //tem que pegar a ultima ocorrencia desta no ultimo WE ante do IF
    if (compAuxFalse == NULL) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
//            if ((*j)->getIf() == true) continue;
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
        deletaCompFalse = false;
    }
    
    //Pegar Componente do Body FALSE quando nao e WE isso ocorre quando nao satisfaz 
    //as condicoes anteriores nao achou WE - nao achou WE antes do IF - nao achou o comp NAO WE antes do IF
    //agora pegar comp nao WE no IF
    if (compAuxFalse == NULL) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->getEIndice()) continue;
            if ((*j)->getIf() == false) continue;
            if ((*j)->getIfBody() == true) continue;
            if ((*j)->getIfComp() != compIf) continue;
            if (compAtual->getNomeVarRef() == (*j)->getNomeVarRef()) {
                compAuxFalse = (*j);
                deletaCompFalse = false;
            }
        }
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

        comp_ref* ref = new comp_ref(NULL, "WE", compAuxTrue->dataWidth);
//        string name = this->design->getNomeCompRef(compAuxTrue->getNomeVarRef());
        string name = compAuxTrue->getNomeVarRef()+"_"+FuncoesAux::IntToStr(this->design->ListaComp.size());
        ref->setName(name);
        ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        
        ref->setNumParalelLina(compAuxTrue->getNumParalelLina());      
        ref->setNumLinha(linha+1);

        ref->setTipoVar("VAR");
        ref->setNomeVarRef(compAuxTrue->getNomeVarRef());
        
        ref->setIfComp(compIf);

        reg_mux_op* reg = new reg_mux_op(NULL, "WE", compAuxTrue->dataWidth);
        reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        reg->setName(ref->getName());
        this->design->addComponent(reg);

        ref->setComponenteRef(reg);
        ref->updateCompRef();
        ref->setDelayValComp(compAuxTrue->getDelayValComp());   
        
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
            string deletaAuxT = "(deleta)";
            if(deletaCompTrue == false) deletaAuxT = "(NAO deleta)";
            string deletaAuxF = "(deleta)";
            if(deletaCompFalse == false) deletaAuxF = "(NAO deleta)";
            cout<< "compAuxTrue:  '" << compAuxTrue->getName() <<"' na linha: '" << compAuxTrue->getNumLinha() <<  "' :: ("<< compAuxTrue->getNomeVarRef()<< ")| Deleta comp:"<< deletaAuxT << endl;
            cout<< "compAuxFalse: '" << compAuxFalse->getName() <<"' na linha: '" <<  compAuxFalse->getNumLinha() << "' :: ("<<  compAuxFalse->getNomeVarRef()<< ")| Deleta comp:" << deletaAuxF << endl;
            cout<< "REG mux:      '" << reg->getName() <<"'" << endl;
            cout<< "REF mux:      '" << ref->getName() <<"' na linha: '" <<  ref->getNumLinha() <<  "' :: ("<<  ref->getNomeVarRef()<< ")" << endl;
        }
        
        //O processo esta errado pois deve se retirar os dois COMP que vao na entrada IMPUT do REG MUX
        Componente* comTrue     = NULL;
        Componente* comFalse    = NULL;
        
        comTrue = compAuxTrue;
        comFalse= compAuxFalse;

        cout<< "%%%%" << endl;
        if(compAuxTrue->getIfComp() == compIf && compAuxTrue->getIf() == true && deletaCompTrue == true){
            Ligacao* ligOrigemTrue = NULL;
            Componente* comOrigemTrue  = NULL;
            
            ligOrigemTrue = compAuxTrue->getPortDataInOut("IN")->getLigacao2();
            comOrigemTrue = ligOrigemTrue->getOrigem();
            
            //Apagando
            comOrigemTrue->removeLigacao(ligOrigemTrue);
            compAuxTrue->removeLigacao(ligOrigemTrue);
            this->design->deletaLigacao(ligOrigemTrue->getNome());
            
            if(comOrigemTrue != NULL) comTrue = comOrigemTrue;
            
            //Pegar todos os componentes da saida 
            Componente* compAuxDest = NULL;
            string portAuxDest = "";
            for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                if( (*k)->getAtivo() == false ) continue;
                
                if( (*k)->getOrigem() == compAuxTrue ){
                    compAuxDest = (*k)->getDestino();
                    portAuxDest = (*k)->getPortDestino()->getName();
                    
                    compAuxDest->removeLigacao((*k));
                    compAuxTrue->removeLigacao((*k));
                    this->design->deletaLigacao((*k)->getNome());
                    
                    this->design->insereLigacao(comOrigemTrue , compAuxDest, comOrigemTrue->getPortDataInOut("OUT")->getName(), portAuxDest );
                }
            }
            this->design->removeComponente(compAuxTrue, NULL);
        }
        cout<< "%%%% fim do deleta true" << endl;
        if(compAuxFalse->getIfComp() == compIf && compAuxFalse->getIf() == true && deletaCompFalse == true){
            Ligacao* ligOrigemFalse  = NULL;
            Componente* comOrigemFalse  = NULL;
            cout<< "1" << endl;
            ligOrigemFalse = compAuxFalse->getPortDataInOut("IN")->getLigacao2();
            cout<< "2" << endl;
            comOrigemFalse = ligOrigemFalse->getOrigem();
            cout<< "3" << endl;
            comOrigemFalse->removeLigacao(ligOrigemFalse);
            compAuxFalse->removeLigacao(ligOrigemFalse);
            this->design->deletaLigacao(ligOrigemFalse->getNome());
            cout<< "4" << endl;
            if(comOrigemFalse != NULL) comFalse = comOrigemFalse;
            cout<< "5" << endl;
            //Pegar todos os componentes da saida 
            Componente* compAuxDest = NULL;
            string portAuxDest = "";
            cout<< "6" << endl;
            for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                if( (*k)->getAtivo() == false ) continue;
                
                if( (*k)->getOrigem() == compAuxFalse ){
                    compAuxDest = (*k)->getDestino();
                    portAuxDest = (*k)->getPortDestino()->getName();
                    
                    compAuxDest->removeLigacao((*k));
                    compAuxFalse->removeLigacao((*k));
                    this->design->deletaLigacao((*k)->getNome());
                    
                    this->design->insereLigacao(comOrigemFalse , compAuxDest, comOrigemFalse->getPortDataInOut("OUT")->getName(), portAuxDest );
                }
            }
            cout<< "7" << endl;
            this->design->removeComponente(compAuxFalse, NULL);
        }
        cout<< "%%%% fim do deleta False" << endl;
        
        this->design->insereLigacao(comTrue , ref, comTrue->getPortDataInOut("OUT")->getName()  , "I1"  );
        this->design->insereLigacao(comFalse, ref, comFalse->getPortDataInOut("OUT")->getName() , "I0"  );
        this->design->insereLigacao(compIf  , ref, compIf->getPortDataInOut("OUT")->getName()   , "Sel1");
        
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
            cout<< "FIM" << endl;
        }
    }
    
}

Design* analisaIf::getDesign(){
    return this->design;
}

analisaIf::~analisaIf() {
}

