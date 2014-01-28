/* 
 * File:   Design.cpp
 * Author: demo
 * 
 * Created on January 20, 2014, 10:23 AM
 */

#include "Design.h"
#include "Componente/comp_ref.h"
#include "Componente/delay_op.h"
#include "Aux/FuncoesAux.h"

#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>
using namespace std;

Design::Design(list<Ligacao*> ligacoes, list<Componente*> componentes) {
    this->ListaLiga = ligacoes;
    this->ListaComp = componentes;
    this->maxSchedulingTime = 0;
    this->sync = false;
}

void Design::setListaLiga(list<Ligacao*> ligacoes){
    this->ListaLiga = ligacoes;
}

void Design::setListaComp(list<Componente*> componentes){
    this->ListaComp = componentes;
}

list<Ligacao*> Design::getListaLiga(){
    return this->ListaLiga;
}

list<Componente*> Design::getListaComp(){
    return this->ListaComp;
}

bool Design::verificarPrecisaMux(Componente* comp) {
    list<Componente*>::iterator i;
    bool existe = false;
    int aux = 0;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getWE()) continue;
        comp_ref* comp = (comp_ref*) (*i);
        if (comp->getTipoVar() != "VET") continue;

        if ((*i)->getNomeVarRef() == comp->getNomeVarRef() && (*i)->getNumParalelLina() == comp->getNumParalelLina()) {
            aux++;
        }
    }
    if(aux > 1){
        existe = true;
    }
    return existe;
}

int Design::verificarQtdAcessoMem(Componente* comp) {
    list<Componente*>::iterator i;
    int aux = 0;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getWE()) continue;
        comp_ref* comp = (comp_ref*) (*i);
        if (comp->getTipoVar() != "VET") continue;

        if ((*i)->getNomeVarRef() == comp->getNomeVarRef() && (*i)->getNumParalelLina() == comp->getNumParalelLina()) {
            aux++;
        }
    }
    return aux;
}

void Design::deletaLigacao(const string& name){
    list<Ligacao*>::iterator    i;
    for (i = this->ListaLiga.begin(); i != this->ListaLiga.end(); i++) {
        if((*i)->getNome() == name){
           (*i)->setAtivo(false); 
        }
    }
}

Ligacao* Design::insereLigacao(Componente* origem, Componente* destino, const string& portaOrigem, const string& portaDestino){
    Ligacao* lig1 = new Ligacao(origem, destino, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
    if(portaOrigem != ""){
        lig1->setPortOrigem(origem->getPortOther(portaOrigem));
        lig1->setWidth(origem->getPortOther(portaOrigem)->getWidth());
        lig1->setTipo(origem->getPortOther(portaOrigem)->getType());
        if(origem->getPortOther(portaOrigem)->isLargePort == false) {
            origem->getPortOther(portaOrigem)->addLigacao(lig1);
        }else{
            PortLarge* portOr1 = (PortLarge*)(origem->getPortOther(portaOrigem));
            portOr1->addLigacao(lig1);
        }
    }else{
        lig1->setPortOrigem(origem->getPortDataInOut("OUT"));
        lig1->setWidth(origem->getPortDataInOut("OUT")->getWidth());
        lig1->setTipo(origem->getPortDataInOut("OUT")->getType());
        if(origem->getPortDataInOut("OUT")->isLargePort == false) {
            origem->getPortDataInOut("OUT")->addLigacao(lig1);
        }else{
            PortLarge* portOr2 = (PortLarge*)(origem->getPortDataInOut("OUT"));
            portOr2->addLigacao(lig1);
        }
    }           
    if(portaDestino != ""){
        lig1->setPortDestino(destino->getPortOther(portaDestino));
        if(destino->getPortOther(portaDestino)->isLargePort == false) {
            destino->getPortOther(portaDestino)->addLigacao(lig1);
        }else{
            PortLarge* portOr3 = (PortLarge*)(destino->getPortOther(portaDestino));
            portOr3->addLigacao(lig1);
        }
    }else{
        lig1->setPortDestino(destino->getPortDataInOut("IN"));
        if(destino->getPortDataInOut("IN")->isLargePort == false) {
            destino->getPortDataInOut("IN")->addLigacao(lig1);
        }else{
            PortLarge* portOr4 = (PortLarge*)(destino->getPortDataInOut("IN"));
            portOr4->addLigacao(lig1);
        }
    }  
    origem->addLigacao(lig1);
    destino->addLigacao(lig1);
    this->ListaLiga.push_back(lig1);

    return lig1;
}

void Design::substiuiComRecorente(Componente* origem, Componente* destino){
    //Ligacao nodo DESTINO
    Ligacao* sDestino = destino->getPortDataInOut("OUT")->getLigacao2();    
    sDestino->getDestino()->removeLigacao(sDestino);
    
    //CRIAR NOVA LIGACAO
    string str = FuncoesAux::IntToStr(this->ListaLiga.size());
    Ligacao* lig = new Ligacao(origem, sDestino->getDestino(), "s" + str);
    lig->setPortOrigem(origem->getPortDataInOut("OUT"));
    lig->setPortDestino(sDestino->getPortDestino());
    lig->setWidth(origem->getPortDataInOut("OUT")->getWidth());
    lig->setTipo(origem->getPortDataInOut("OUT")->getType());

    //ADICIONAR LIGACAO NA PORTA                        
//    lig->getPortDestino()->setLigacao(lig->getNome());
    lig->getPortDestino()->addLigacao(lig);
//    lig->getPortOrigem()->setLigacao(lig->getNome());
    lig->getPortOrigem()->addLigacao(lig);

    //ADICIONAR LIGACAO AOS COMPONENTES
    origem->addLigacao(lig);
    sDestino->getDestino()->addLigacao(lig);

    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
    this->ListaLiga.push_back(lig);

    this->deletaLigacao(sDestino->getNome());
    this->removeComponente(destino, NULL);
    //Neste caso nao gera nem VHDL/DOT para o J (comp repetido)
//    destino->tipo_comp = CompType::REG;

}

void Design::removeComponente(Componente* compRemove, Componente* naoRemover){
   compRemove->tipo_comp = CompType::DEL;
   list<Ligacao*>::iterator    k;
    for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if ( (*k)->getAtivo() == false  ) continue;
        if((*k)->getOrigem() == compRemove){
            this->deletaLigacao((*k)->getNome());
            (*k)->getOrigem()->removeLigacao((*k));
            (*k)->getDestino()->removeLigacao((*k));
        }
    }
    
    for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if ( (*k)->getAtivo() == false  ) continue;
        if((*k)->getDestino() == compRemove){
            this->deletaLigacao((*k)->getNome());
            (*k)->getOrigem()->removeLigacao((*k));
            (*k)->getDestino()->removeLigacao((*k));
            this->removeComponente((*k)->getOrigem(), naoRemover); 
        }
    }
}

void Design::addComponent(Componente* comp){
    list<Componente*>::iterator i;
    if(this->compForAux != NULL) comp->setForComp(this->compForAux);
    //verificar se existe o nodo ja nos componentes
    //isso ocorre pois existe a otimizacao da arvore durante o processo do rose
    bool existe = false;
    Componente* aux= false;
    if(comp->node != NULL){
        for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
            if( comp->node == (*i)->node ){
                existe = true;
                aux = (*i);
            }
        }
        if(existe == false){
            this->ListaComp.push_back(comp);
        //    cout<< " COMP: " << comp->getName() << " - Nome Comp VHDL: " << comp->getNomeCompVHDL() << " - ID:  "<< comp->getNumIdComp() << " - LINHA: " << comp->getNumLinha() << endl;
            if(!this->isSync() && comp->getSync()){
                setSync(true);
            }
        }

    }else{
        this->ListaComp.push_back(comp);
        //    cout<< " COMP: " << comp->getName() << " - Nome Comp VHDL: " << comp->getNomeCompVHDL() << " - ID:  "<< comp->getNumIdComp() << " - LINHA: " << comp->getNumLinha() << endl;
        if(!this->isSync() && comp->getSync()){
            setSync(true);
        }
    }
    void* node = NULL;
    void* pai  = NULL;
    if (aux != NULL){
        node = aux->node;
        pai  = comp->getPai();
    }else{
        node = comp->node;
        pai  = comp->getPai();
    }
    if(node != NULL && pai != NULL){
//        this->graph->addEdge(node, pai, "");
    }
}

void Design::setSync(bool sync){
    this->sync = sync;
}

bool Design::isSync(){
    return this->sync;
}

int Design::getMaxSchedulingTime(){
    return this->maxSchedulingTime;
}

void Design::setMaxSchedulingTime(int maxSchedulingTime){
    this->maxSchedulingTime = maxSchedulingTime;
}

Componente* Design::insereDelay(Ligacao* lig, int delay, int asap){
    string str = FuncoesAux::IntToStr(this->ListaComp.size());

    delay_op* comp = new delay_op(NULL);
    
    comp->setDelayVal(FuncoesAux::IntToStr(delay));

    
     //Setando Valor do ID
    comp->setNumIdComp(str);

    string nome = "dly_" + str;
    comp->setName(nome);
    comp->getPortDataInOut("IN")->setWidth(lig->getWidth());
    comp->getPortDataInOut("OUT")->setWidth(lig->getWidth());
    comp->setDelayBits(lig->getWidth());
    comp->setASAP(asap);

    //CRIAR NOVA LIGACAO
    Ligacao* newLig = new Ligacao(comp, lig->getDestino(), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
    newLig->setPortDestino((lig->getPortDestino()));
    newLig->setPortOrigem(comp->getPortDataInOut("OUT"));
    newLig->setWidth(lig->getWidth());
    newLig->setTipo(comp->getPortDataInOut("OUT")->getType());

    //ADICIONAR NOME LIGACAO NA PORTA
    newLig->getPortDestino()->addLigacao(newLig);
    newLig->getPortOrigem()->addLigacao(newLig);

    //Adicionando as novas ligacoes no Delay e no DESTINO DO DELAY
    comp->addLigacao(newLig);
    comp->addLigacao(lig);
    comp->setDelayBits(lig->getWidth());

    //Setando Valor do ID
    comp->setNumIdComp(str);

    //EDITAR PARAMETRO LIGACAO ANTIGA 
    lig->editDest(comp);
    lig->setPortDestino(comp->getPortDataInOut("IN"));

    //ADICIONAR LIGACAO NA PORTA
    lig->getPortDestino()->addLigacao(lig);

    //Excluir referencia da ligacao antiga
    newLig->getDestino()->removeLigacao(lig);
    newLig->getDestino()->addLigacao(newLig);
    
    this->ListaLiga.push_back(newLig);
    
    return comp;
}

Componente* Design::getComponent(const string& name){
    Componente* comp = NULL;
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp ==  CompType::DEL) continue;
        if((*i)->getName() == name){
            comp = (*i);
        }
    }
    
    return comp;
}

bool Design::verificaTemDelay(Componente* comp, const string& porta){
    bool existe = false;
    list<Ligacao*>::iterator    k;
    for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if ( (*k)->getAtivo() == false  ) continue;
        if( (*k)->getDestino() == comp && (*k)->getPortDestino()->getName() == porta && (*k)->getOrigem()->tipo_comp == CompType::DLY ){
            existe = true;
        }
    }
    return existe;
}

string Design::getNomeCompRef(const string& name){
    list<Componente*>::iterator i;
    int aux = 0;
    string newName= "";
    string nameReturn = name;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM ) continue;
        comp_ref* CompRef = (comp_ref*)(*i);
        if(CompRef->getNomeVarRef() == name){
            newName = CompRef->getNomeVarRef()+CompRef->getNumIdComp();
            aux++;
        }
    }
    if(aux > 1){
        nameReturn = newName;
    }
    return nameReturn;
}

void Design::imprimeAllComp(){
    list<Componente*>::iterator i;
    cout<< " ======================================== "<<endl;
    cout<< " COMPONENTES - QTD: "<< this->ListaComp.size() <<endl;
    cout<< " ======================================== "<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp ==  CompType::MEM ) continue; 
//        if ((*i)->tipo_comp ==  CompType::REG ) continue; 
        if ((*i)->tipo_comp ==  CompType::DEL ) continue; 
        cout<< "COMP: " << (*i)->getName() << " - NUM: " <<(*i)->getNumIdComp() << "||| " << (*i) << endl;
        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->imprimePortas() << endl;
//        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->imprimeLigacoes() << endl;
//        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->geraCompVHDL() << endl;
//        cout<< " ---------------------------------------- "<<endl;
    }
    cout<< " ======================================== "<<endl;  
}

Design::~Design() {
}

