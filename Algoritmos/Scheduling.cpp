/* 
 * File:   Scheduling.cpp
 * Author: demo
 * 
 * Created on January 20, 2014, 1:22 PM
 */

#include "Scheduling.h"
#include "../Aux/FuncoesAux.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>
using namespace std;

Scheduling::Scheduling(Design* design) {
    this->design = design;
    this->debug = true;
}

Design* Scheduling::getDesign() {
    return this->design;
}

void Scheduling::detectBackwardEdges(){
    list<Ligacao*>::iterator    k;
    cout<<"*********************************"<<endl;
    cout<<"Detectando Backward Edges (Topological)..."<<endl;
    cout<<"*********************************"<<endl;
    
    for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        //Self-connected component EX.: A->A
        if((*k)->getOrigem()->getName() == (*k)->getDestino()->getName()){
            (*k)->setBackEdge(true);
            if(this->debug)
                cout<< "signal " << (*k)->getOrigem()->getName() << " -> " <<  (*k)->getDestino()->getName() << " marked as backedge (self-connected)" << endl;
        }
        //self-connected components (pair) EX.: A->B and B->A 
        else if((*k)->getOrigem()->isSuccessorOf((*k)->getDestino())){
            (*k)->setBackEdge(true);
            if(this->debug)
                 cout<< "signal " << (*k)->getOrigem()->getName() << " -> " <<  (*k)->getDestino()->getName() << " marked as backedge (self-connected pair)" << endl;
        }
        else{
            if ((*k)->getDestino()->tipo_comp == CompType::REG || (*k)->getDestino()->tipo_comp == CompType::MEM || (*k)->getDestino()->tipo_comp == CompType::AUX || (*k)->getDestino()->tipo_comp == CompType::DEL    ) continue;
            int origLine = (*k)->getOrigem()->getNumLinha();
            int destLine = (*k)->getDestino()->getNumLinha();
            if(origLine > 0){
                if (destLine == 0){
                    destLine = (*k)->getDestino()->getSuccessorsLine();
                }
                if(origLine > destLine){
                    (*k)->setBackEdge(true);
                    if(this->debug)
                        cout<< "signal \"" << (*k)->getOrigem()->getName() << "\" -> \"" <<  (*k)->getDestino()->getName() << "\" marked as backedge (source defined after destination in source code)" << endl;
                }
            }
        }
    }
    cout<<"*********************************"<<endl;
    cout<<"Detectando Backward Edges (Topological)...OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Scheduling::balanceAndSyncrhonize(){
    cout<<"*********************************"<<endl;
    cout<<"Balance And Synchronize..."<<endl;
    cout<<"*********************************"<<endl;
//    list<Componente*> ListaCompAux;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    list<Ligacao*>::iterator    m;

    Componente* counter = NULL;
    Componente* firstCounter = NULL;
    int mii = 0, ats = 0;
    
    for(i=this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++){
        Componente* c = (*i);
        if ((*i)->tipo_comp == CompType::CTD){
            counter = c;
            if(firstCounter == NULL){
                firstCounter = (*i);
            }
            int step = 0;
            step = FuncoesAux::StrToInt(counter->getGenericMapVal("steps", "VAL"));
            
            if (step > mii){
                mii = step;
            }
            if(this->debug){
                cout<< "using counter \""<< (*i)->getName() << "\" to syncronize operations " << endl;
            }
            int counterSched = counter->getASAP();

            for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
                if((*k)->getAtivo() == false ) continue;
                if((*k)->getOrigem() != counter) continue;
                if((*k)->getPortDestino()->getName() != "address") continue;
                
                Componente* destino = (*k)->getDestino();
                int distance = destino->getASAP() - counterSched;
                if (distance > 1) {
                    string strAux = counter->getDelayValComp();
                    int dlyCtd = 0;
                    if(strAux != ""){
                        dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
                    }

                    Componente* dly1 = this->design->insereDelay((*k), distance-1, destino->getASAP() - dlyCtd);
                    ats++;

                    if(this->debug){
                        cout<< "inserting " << (distance-1) << " delay(s) on signal "<< counter->getName()<< "->" << destino->getName() <<" (memory address)" << endl;
                    }
                    
                    this->design->addComponent(dly1);
                    
                    string port = "we";
                    if(!destino->getWE()) port = "oe";
                    
                    if (destino->getPortOther(port)->temLigacao() == false){
                    
                        //CRIAR NOVA LIGACAO
                        Ligacao* lig = new Ligacao(counter, destino, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                        lig->setPortOrigem(counter->getPortOther("step"));
                        lig->setPortDestino(destino->getPortOther(port));
                        lig->setWidth(counter->getPortOther("step")->getWidth());
                        lig->setTipo(counter->getPortOther("step")->getType());

                        //ADICIONAR LIGACAO NA PORTA                        
                        lig->getPortDestino()->addLigacao(lig);
                        lig->getPortOrigem()->addLigacao(lig);

                        //ADICIONAR LIGACAO AOS COMPONENTES
                        counter->addLigacao(lig);
                        destino->addLigacao(lig);

                        //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                        this->design->ListaLiga.push_back(lig);

                        //INSERINDO DELAY NA NOVA LIGACAO
                        Componente* dly2 = this->design->insereDelay(lig, distance-1, (*k)->getDestino()->getASAP() - dlyCtd);
                        this->design->addComponent(dly2);

                        ats++;
                        if(this->debug){
                            cout<< "inserting " << (distance-1) << " delay(s) on signal "<< counter->getName()<< "->" << destino->getName() <<" (memory port: WE)" << endl;
                        }
                    }
                }
            }
        }
        else if( (counter != NULL) && (c->getTipoCompRef() != CompType::MEM) && (c->temPorta("we"))){
            if(c->getPortOther("we")->temLigacao() == false){
               
                int distance = c->getASAP() - counter->getASAP();
                
                if(distance > 1){
                    string strAux = counter->getDelayValComp();
                    int dlyCtd = 0;
                    if(strAux != ""){
                        dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
                    }
                    int stepAux= c->getValStepAux();
                    
                    Ligacao* s1 = this->design->insereLigacao(counter, c, "step", "we");
                    Componente* dly3 = this->design->insereDelay(s1, distance-1+stepAux, counter->getASAP() + dlyCtd);
                    this->design->addComponent(dly3);
                    ats++;
                    if(this->debug){
                        cout<< "inserting '" << (distance-1+stepAux) << "' delay(s) on signal '"<< counter->getName()<< "->" << c->getName() <<"' (write enable) " << dly3->getNomeCompVHDL() << ": '" << dly3->getName() <<"'" << endl;
                    }
                }
//                
//                else{
//                    if(distance == 1){
//                        cout << "**** Nome: '"<< c->getName() <<"' distance:"<< distance <<  endl;
//                        Ligacao* s1 = this->design->insereLigacao(counter, c, "step", "we");
//                        Componente* dly3 = this->design->insereDelay(s1, 1, counter->getASAP());
//                        this->design->addComponent(dly3);
//                        ats++;
//                    }
//                }
            }else{
                if(this->debug) cout<< "port 'we' of component \"" << c->getName() << "\" is connected, please check if aditional synchronization is needed (when ... && "<<counter->getName()<<".step@N)" << endl;
            }
        }
    }

    
    Componente* comp_init = this->design->getComponent("init");
    if(firstCounter != NULL && comp_init != NULL && comp_init->getLigacaoOutDefault() == NULL){
        //LIGACAO
        Ligacao* newLig = new Ligacao(comp_init, firstCounter, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));

        newLig->setPortDestino(firstCounter->getPortOther("clk_en"));
        newLig->setPortOrigem(comp_init->getPortDataInOut("OUT"));
        newLig->setWidth(firstCounter->getPortOther("clk_en")->getWidth());
        newLig->setTipo(firstCounter->getPortOther("clk_en")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig->getPortDestino()->addLigacao(newLig);
        newLig->getPortOrigem()->addLigacao(newLig);

        //ADICIONAR LIGACAO NO COMPONENTE
        firstCounter->addLigacao(newLig);
        comp_init->addLigacao(newLig);

        //ADD LISTAS
        this->design->ListaLiga.push_back(newLig);

    }
    
    Componente* comp_done = this->design->getComponent("done");
 
    if(counter != NULL && comp_done != NULL &&  comp_done->getLigacaoInDefault() == NULL){
        int amount = this->design->getMaxSchedulingTime() - counter->getASAP();// - 1;

        //LIGACAO 
        Ligacao* newLig4 = new Ligacao(firstCounter, comp_done, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
        newLig4->setPortOrigem(counter->getPortOther("done"));
        newLig4->setPortDestino(comp_done->getPortDataInOut("IN"));
        newLig4->setWidth(counter->getPortOther("done")->getWidth());
        newLig4->setTipo(counter->getPortOther("done")->getType());
        
        //ADICIONAR NOME LIGACAO NA PORTA
        newLig4->getPortDestino()->addLigacao(newLig4);
        newLig4->getPortOrigem()->addLigacao(newLig4);
        
        //ADICIONAR LIGACAO NO COMPONENTE
        counter->addLigacao(newLig4);
        comp_done->addLigacao(newLig4);

        //ADD LISTAS LIGACAO
        this->design->ListaLiga.push_back(newLig4);
        
        string strAux = counter->getDelayValComp();
        int dlyCtd = 0;
        if(strAux != ""){
            dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
        }
        if(amount <= 0) amount = 1;
        ats++;
        Componente* dly4 = this->design->insereDelay(newLig4, amount, counter->getASAP() + dlyCtd);
        this->design->addComponent(dly4); 
        if(this->debug){
            cout<< "inserting " << amount << " delay(s) on signal "<< counter->getName()<< "->" << comp_done->getName() <<" (termination)" << endl;
        }
    }    
    
    for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        Componente* orig = (*k)->getOrigem();
        Componente* dest = (*k)->getDestino();
        
        if(orig->tipo_comp == CompType::DEL || dest->tipo_comp == CompType::DEL) continue;
        if(orig->tipo_comp == CompType::AUX || dest->tipo_comp == CompType::AUX) continue;
        
        if(! (orig->getNomeCompVHDL() == "delay_op" || dest->getNomeCompVHDL() == "delay_op" || orig->getNomeCompVHDL() == "mux_m_op" || dest->getNomeCompVHDL() == "mux_m_op" || dest->getUserSync())) {
            int sourceSched = this->calculateASAP(orig);
            int destSched   = dest->getASAP();
            int distance    = destSched - sourceSched;
            if (distance > 1) {
//            if (distance >= 1) {
                Componente* dly5 = this->design->insereDelay((*k), distance, dest->getASAP());
                ats++;
                this->design->addComponent(dly5);
                if(this->debug){
                    cout<< "inserting " << distance << " delay(s) on signal "<< orig->getName()<< "->" << dest->getName() <<" (balance)" << endl;
                }
            }
        }
    }
    
    for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        if((*k)->getBackEdge()){
            Componente* orig = (*k)->getOrigem();
            Componente* dest = (*k)->getDestino();
            
            string strAux = orig->getDelayValComp();
            int dlyCtd = 0;
            if(strAux != ""){
                dlyCtd = FuncoesAux::StrToInt(orig->getDelayValComp());
            }
            
            int sourceSched = orig->getASAP() + dlyCtd;
            int destSched = dest->getASAP();
            int distance = sourceSched - destSched;
            
            if(orig->getSync() && dest->getSync()){
                if(distance > mii){
                    if(this->debug) cout<< "backedge "<< orig->getName()<< "->" << dest->getName() <<" have distance "<<distance<< " which is bigger than MII = "<<mii<<", this can limit MII to lower value" << endl;
                    if(orig->getForComp() != NULL )orig->getForComp()->setGenericMapVal("steps", "VAL", FuncoesAux::IntToStr(distance));
                    mii = distance;
                }
            }
            if(distance < 0){
                dest->setUserSync(true);
                dest->setDelayValComp(FuncoesAux::IntToStr(distance*(-1)));
            }
                
            if(this->debug){
                cout<< "backedge "<< orig->getName()<< "->" << dest->getName()<< " with distance ||"<< distance << endl;
            }
        }
    }
    
    cout<<""<<endl;
    cout<<"MII: "<<mii<<endl;
    
    
    cout<<"*********************************"<<endl;
    cout<<"Balance And Synchronize...OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Scheduling::ALAP(){
    cout<<"*********************************"<<endl;
    cout<<"ALAP..."<<endl;
    cout<<"*********************************"<<endl;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    
    this->ASAP();
    this->copySchedulingTimes();
    bool change = true;
    int min, succ, dlyAux;
    while(change){
        change = false;
        for(i=this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++){
            if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX || (*i)->tipo_comp == CompType::DEL ) continue;
            min  = 0;
            succ = 0;
            
            //Fazer calc para todos sucessores QUANDO ARESTA FOR DIFERENTE DE BLACK
            for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
                if((*k)->getAtivo() == false ) continue;
                if((*k)->getBackEdge() == true) continue;
                if((*k)->getOrigem() == (*i)){
                    dlyAux = FuncoesAux::StrToInt((*i)->getDelayValComp());
                    succ = (*k)->getDestino()->getALAP() - dlyAux;
                    if(succ < min)
                        min = succ;
                }
                
            }
            if((*i)->getALAP() != min){
                (*i)->setALAP(min);
                change = true;
            }
        }
    }
    cout<<"*********************************"<<endl;
    cout<<"ALAP... OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Scheduling::ASAP(){
    cout<<"Scheduling (ASAP)..."<<endl;
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    bool change = true;
    int max, pred, dlyAux;
    int id = 0;
//    while(id < 10){
    while(change){
        change = false;
        
        //varrer todos componentes
        for(i=this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++){
            if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX || (*i)->tipo_comp == CompType::DEL ) continue;
            max = 0;
            pred = 0;
            if(this->debug){
                cout<< "scheduling \""<<(*i)->getName()<<"\" ASAP: \"" << (*i)->getASAP() << "\" line:" << (*i)->getNumLinha()<<endl;
            }
            //all predecessors 
            for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
                if((*k)->getAtivo() == false ) continue;
                if((*k)->getBackEdge() == true) continue;
                
                if((*k)->getDestino() == (*i)){
                    dlyAux = FuncoesAux::StrToInt((*k)->getOrigem()->getDelayValComp());
                    pred = (*k)->getOrigem()->getASAP() + dlyAux;
                    if(pred > max){
                        max = pred;
                        if(this->debug)
                            cout<< "dependence \""<<(*k)->getOrigem()->getName()<<"\" ASAP: '" << (*k)->getOrigem()->getASAP() << "' line: '" << (*k)->getOrigem()->getNumLinha()<<"'" <<endl;
                    }
                }
            }
            
            //all source code predecessors
            if((*i)->getWE() == true && (*i)->getNumLinha() != 0){
                for(j=this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++){
                    if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM || (*j)->tipo_comp == CompType::AUX || (*j)->tipo_comp == CompType::DEL ) continue;
                    if ((*j)->getWE() == false && (*j)->getNumLinha() == 0 ) continue;
                    int line = (*j)->getNumLinha();
                    if(line > (*i)->getNumLinha()){
                        if(this->debug) cout<< "break on: \""<<(*j)->getName()<<"\" ASAP:" << (*j)->getASAP() << " line: '" << (*j)->getNumLinha()<<"'" <<endl;
                        goto innerBreak;
                    }
                    pred = (*j)->getASAP();
                    if(pred > max){
                        max = pred;
                        if(this->debug)
                            cout<< "predecessor \""<<(*j)->getName()<<"\" ASAP: '" << (*j)->getASAP() << "' line: '" << (*j)->getNumLinha()<<"'"<<endl;
                    }
                }
            }
            innerBreak:
            
            if( (*i)->getASAP() != max ){
                (*i)->setASAP(max);
                change = true;
                if (max > this->design->getMaxSchedulingTime())
                    this->design->setMaxSchedulingTime(max);
            }
        }
    }
    cout<<"Scheduling (ASAP)...OK"<<endl;
}

int Scheduling::calculateASAP(Componente* comp){
    list<Ligacao*>::iterator    k;
    if(comp->getSync()){
        int dlyAux = FuncoesAux::StrToInt(comp->getDelayValComp());
        return comp->getASAP() + dlyAux;
    }else{
        int max = 0;
        for(k=this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++){
            if((*k)->getAtivo() == false ) continue;
            if((*k)->getDestino() == comp){
                if ((*k)->getOrigem()->tipo_comp == CompType::REG || (*k)->getOrigem()->tipo_comp == CompType::MEM || (*k)->getOrigem()->tipo_comp == CompType::AUX || (*k)->getOrigem()->tipo_comp == CompType::DEL) continue;
                int newMax = this->calculateASAP((*k)->getOrigem());
                
                if(newMax > max){
                    max = newMax;
                    if(this->debug)
                        cout<< "calculating ASAP of \""<< comp->getName() << "\" by '" << (*k)->getOrigem()->getName()<<"'"<< endl;
            
                }
            }
        }
        return max;
    }
}

void Scheduling::copySchedulingTimes(){
    
    list<Componente*>::iterator i;
    for(i=this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++){
        (*i)->copySchedulingTimes();
    }
} 

Scheduling::~Scheduling() {
}

