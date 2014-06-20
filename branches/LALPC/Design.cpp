/* 
 * File:   Design.cpp
 * Author: demo
 * 
 * Created on January 20, 2014, 10:23 AM
 */

#include "Design.h"
#include "Componente/comp_ref.h"
#include "Componente/and_op.h"
#include "Componente/not_op.h"
#include "Componente/counter.h"
#include "Componente/delay_op.h"
#include "Aux/FuncoesAux.h"

#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>
#include <set>
using namespace std;

Design::Design(list<Ligacao*> ligacoes, list<Componente*> componentes, int dataWidth) {
    this->ListaLiga             = ligacoes;
    this->ListaComp             = componentes;
    this->maxSchedulingTime     = 0;
    this->sync                  = false;
    this->DATA_WIDHT            = dataWidth;
    this->temMemoria            = false;
}

void Design::setTemMemoria(bool val){
    this->temMemoria = val;
}

bool Design::getTemMemoria(){
    return this->temMemoria;
}

int Design::getDataWidht(){
    return this->DATA_WIDHT;
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
    bool debug = true;
    list<Componente*>::iterator i;
    int aux = 0;
    if (debug) cout << "Verificando quantidade de acessos na memoria: '"<< comp->getName()<<"'" << endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getWE()) continue;
        comp_ref* compI = (comp_ref*) (*i);
        if (compI->getTipoVar() != "VET") continue;
        if ((*i)->getNomeVarRef() == comp->getNomeVarRef()) {
            if (debug) cout << "componente: '" << (*i)->getName() <<"' - compRef: '"<< (*i)->getNomeVarRef() <<"'" << endl;
            aux++;
        }
    }
    if (debug) cout << "Total de acessos na memoria: '"<< aux <<"'" << endl;
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
    cout<< "ENTROU NO METODO DE SUB COMP REC" << endl;
    //Ligacao nodo DESTINO
    if(destino->getPortDataInOut("OUT")->temLigacao() == true){
        cout<< "1" << endl;
        list<Ligacao*>::iterator    k;
        for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
            if ((*k)->getAtivo() == false  ) continue;
            if((*k)->getOrigem() == destino){
                Componente* compDest = (*k)->getDestino();
                compDest->removeLigacao((*k));
                destino->removeLigacao((*k));
                
                Ligacao* lig = this->insereLigacao(origem, compDest, origem->getPortDataInOut("OUT")->getName(), (*k)->getPortDestino()->getName());
                
                cout<< "4" << endl;
                this->deletaLigacao((*k)->getNome());
                cout<< "5" << endl;
                //this->removeComponente(destino, NULL);
            }
        }
//        Ligacao* sDestino = destino->getPortDataInOut("OUT")->getLigacao2();    
//        sDestino->getDestino()->removeLigacao(sDestino);
//        destino->removeLigacao(sDestino);
//        cout<< "2" << endl;
//        cout<< "LIGACAO: " <<sDestino->getNome() << endl;
//        cout << "ORIGEM: " << origem->getName()<< "   DESTINO: "<<  sDestino->getDestino()->getName() << endl;
//        cout << "ORIGEM: " << origem->getPortDataInOut("OUT")->getName() << "   DESTINO: "<< sDestino->getPortDestino()->getName() << endl;
//        Ligacao* lig = this->insereLigacao(origem, sDestino->getDestino(), origem->getPortDataInOut("OUT")->getName(), sDestino->getPortDestino()->getName());
//        cout<< "3" << endl;
//        //CRIAR NOVA LIGACAO
//        string str = FuncoesAux::IntToStr(this->ListaLiga.size());
//        Ligacao* lig = new Ligacao(origem, sDestino->getDestino(), "s" + str);
//        lig->setPortOrigem(origem->getPortDataInOut("OUT"));
//        lig->setPortDestino(sDestino->getPortDestino());
//        lig->setWidth(origem->getPortDataInOut("OUT")->getWidth());
//        lig->setTipo(origem->getPortDataInOut("OUT")->getType());
//
//        //ADICIONAR LIGACAO NA PORTA                        
//    //    lig->getPortDestino()->setLigacao(lig->getNome());
//        lig->getPortDestino()->addLigacao(lig);
//    //    lig->getPortOrigem()->setLigacao(lig->getNome());
//        lig->getPortOrigem()->addLigacao(lig);
//
//        //ADICIONAR LIGACAO AOS COMPONENTES
//        origem->addLigacao(lig);
//        sDestino->getDestino()->addLigacao(lig);
//
//        //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
//        this->ListaLiga.push_back(lig);
//        cout<< "4" << endl;
//        this->deletaLigacao(sDestino->getNome());
//        cout<< "5" << endl;
//        //this->removeComponente(destino, NULL);
//        cout<< "6" << endl;
        destino->tipo_comp = CompType::DEL;
    }else{
        cout<< "Error ao tentar substituir um componente" << endl;
        cout<< "Metodo: substiuiComRecorente()" << endl;
        cout<< "Classe: Design" << endl;
        perror("ERROR");
    }
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

void Design::finalizaComponentesIF(){
    cout<< "FINALIZANDO LIGANDO NA SAIDA WE DOS COMPONENTES" << endl;
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->writeEnable != true) continue;
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getNomeCompVHDL() == "reg_mux_op"){
            cout << (*i)->getName() << endl;
//            this->insereLigacao((*i)->getIfComp(), (*i), (*i)->getIfComp()->getPortDataInOut("OUT")->getName()   , "Sel1");
        }else{
            if ((*i)->getIf() != true) continue;
            cout << (*i)->getName() << endl;
            Componente* comOriAuxWE = NULL;
            if((*i)->getPortOther("we")->temLigacao()){
                Ligacao* ligAuxWE = (*i)->getPortOther("we")->getLigacao2();
                comOriAuxWE = (*i)->getPortOther("we")->getLigacao2()->getOrigem();

                (*i)->removeLigacao(ligAuxWE);
                comOriAuxWE->removeLigacao(ligAuxWE);

                this->deletaLigacao(ligAuxWE->getNome());
            }

            if(comOriAuxWE != NULL){

                //Criando componente AND
                and_op* andCompAux = new and_op(NULL, 1);
                andCompAux->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                andCompAux->setName("comp_"+FuncoesAux::IntToStr(this->ListaComp.size()));
                andCompAux->setNumParalelLina((*i)->getIfComp()->getNumParalelLina());
                andCompAux->setNumLinha((*i)->getIfComp()->getNumLinha());
                this->addComponent(andCompAux);

                //Verificar se e' da parte TRUE do IF - caso for da FALSE tem que colocar um componente NEG na saida do IF
                if((*i)->getIfBody()){  
                    this->insereLigacao(comOriAuxWE, andCompAux, comOriAuxWE->getPortDataInOut("OUT")->getName()  , "I0");
                    this->insereLigacao((*i)->getIfComp(), andCompAux, "O0", "I1");
                    this->insereLigacao(andCompAux, (*i), "O0", "we");
                }else{
                    //Criar componente NEG e colocar entre o IF e o COMP *I
                    not_op* negComp = new not_op(NULL, 1);
                    negComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                    negComp->setName("comp_"+FuncoesAux::IntToStr(this->ListaComp.size()));
                    negComp->setNumParalelLina((*i)->getIfComp()->getNumParalelLina());
                    negComp->setNumLinha((*i)->getIfComp()->getNumLinha());

                    this->addComponent(negComp);

                    this->insereLigacao((*i)->getIfComp(), negComp, "O0", "I0");
                    this->insereLigacao(negComp   , andCompAux, "O0", "I1");
                    this->insereLigacao(comOriAuxWE, andCompAux, comOriAuxWE->getPortDataInOut("OUT")->getName()  , "I0");
                    this->insereLigacao(andCompAux, (*i), "O0", "we");
                }

            }else{
                //Verificar se e' da parte TRUE do IF - caso for da FALSE tem que colocar um componente NEG na saida do IF
                if((*i)->getIfBody()){
                    this->insereLigacao((*i)->getIfComp(), (*i), "O0", "we");
                }else{
                    //Criar componente NEG e colocar entre o IF e o COMP *I
                    not_op* negComp = new not_op(NULL, 1);
                    negComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                    negComp->setName("comp_"+FuncoesAux::IntToStr(this->ListaComp.size()));
                    negComp->setNumParalelLina((*i)->getIfComp()->getNumParalelLina());
                    negComp->setNumLinha((*i)->getIfComp()->getNumLinha());

                    this->addComponent(negComp);

                    this->insereLigacao((*i)->getIfComp(), negComp, "O0", "I0");
                    this->insereLigacao(negComp, (*i), "O0", "we");
                }
            } 
            
        }
               
    }
    cout<< "FINALIZANDO LIGANDO NA SAIDA WE DOS COMPONENTES: OK" << endl;
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

bool Design::isIndiceVector(const string& name){
    bool res = false;
    list<Componente*>::iterator i;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::CTD){
            counter* CompCounter = (counter*)(*i); 
            if(CompCounter->getVarControlCont() == name){
                res = true;
            }
        }
    }
    return res; 
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
            newName = CompRef->getNomeVarRef()+"_"+CompRef->getNumIdComp();
            aux++;
        }
    }
    if(aux > 1){
        nameReturn = newName;
    }
    return nameReturn;
}

/*
 * Metodo criado para gerar componentes similar ao LALP
 * no lalp apenas REGISTRADORES, MEMORIAS e CONTADORES tem a informacao do 
 * numero da linha referente ao arquivo de entrada
 * Porem no LALPC essa info e importante no processo de ligacao dos componentes
 */
void Design::zeraValorNumLinha(){
    //metodo utilizado antes do scheduling
    list<Componente*>::iterator i;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::CTD || (*i)->tipo_comp == CompType::MUX || (*i)->tipo_comp == CompType::REF) continue;
        (*i)->setNumLinha(0);
    }
}

void Design::imprimeAllComp(){
    list<Componente*>::iterator i;
    cout<< " ======================================== "<<endl;
    cout<< " COMPONENTES - QTD: "<< this->ListaComp.size() <<endl;
    cout<< " ======================================== "<<endl;
    cout<< "NOME;DELAY;LINHA;ASAP;ALAP"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp ==  CompType::DEL ) continue; 
        if ((*i)->tipo_comp ==  CompType::MEM ) continue; 
        if ((*i)->tipo_comp ==  CompType::REG ) continue; 
        if ((*i)->getNumLinha() <= 0)  continue; 
//        cout<< "COMP: '" << (*i)->getName() << "' - VHDL: '" <<(*i)->getNomeCompVHDL()<< "' - DLY: '" << (*i)->getDelayValComp()<<"' - LINHA: '" <<(*i)->getNumLinha()  <<"'" <<endl;
        cout<< (*i)->getName() << ";"<< (*i)->getDelayValComp()<<";" <<(*i)->getNumLinha()<<";" <<(*i)->getASAP()<<";" <<(*i)->getALAP()<<endl;
    }
    cout<< " ======================================== "<<endl;  
}

void Design::ligaCompDependencia(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    Componente* lastWE  = NULL;
    bool        debug   = false;
    if(debug) cout << "--Ligar componentes DEPENDENTES:" << endl;
    
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getComponenteRef()->tipo_comp == CompType::MEM) continue;
        if(debug) cout<< " Componente (I): "<< (*i)->getName() << endl;
        //Verificar ultima ocorrencia deste no codigo
        lastWE = NULL;

        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->getEIndice()) continue;
            if ((*j)->getComponenteRef()->tipo_comp == CompType::MEM) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;

            if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    lastWE = (*j);
                }
            }
        }
        if(debug){
            cout<< " Ultimo comp WE: '"<< lastWE->getName()<<"'"  << endl;
        }

        if (lastWE == NULL) continue;

        if(debug) cout<< " Procurar Componentes que vao receber a ligacao "<< endl;
        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->getComponenteRef()->tipo_comp == CompType::MEM) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            if (lastWE->getNumLinha() < (*j)->getNumLinha()) continue;
            if ((*i)->node == (*j)->node) continue;
            if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    break;
                } else {
                    if ((*j)->getPortDataInOut("IN")->temLigacao() == false) {
                        if(debug) cout<<"--Ligando componentes (dependencia): " << lastWE->getName() << " -> " << (*j)->getName() <<endl;

                        //Pegar todas as ligacores da saida do componente que o compoente ORIGEM seja (*j)
                        for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++) {
                            if ((*k)->getOrigem() == (*j) && (*k)->getAtivo() == true){

                                (*j)->removeLigacao((*k));
                                (*k)->editOrig(lastWE);
                                (*k)->setPortOrigem(lastWE->getPortDataInOut("OUT"));
                                lastWE->addLigacao((*k));
                                lastWE->getPortDataInOut("OUT")->addLigacao((*k));

                                (*k)->setBackEdge(true);
                            }
                        }

                        (*j)->tipo_comp = CompType::DEL;

                        if((*j)->getPortOther("we")->temLigacao()){
                            Ligacao*    lig = (*j)->getPortOther("we")->getLigacao2();
                            lig->getOrigem()->removeLigacao(lig);
                            lig->getDestino()->removeLigacao(lig);
                            this->deletaLigacao(lig->getNome());

                            Ligacao*    lig2= lig->getOrigem()->getPortDataInOut("IN")->getLigacao2();
                            lig2->getOrigem()->removeLigacao(lig);
                            lig2->getDestino()->removeLigacao(lig);
                            this->deletaLigacao(lig2->getNome());

                            lig->getOrigem()->tipo_comp = CompType::DEL;
                        } 
                    }
                }
            }
        }
    }
    if(debug) cout << "--Ligar componentes DEPENDENTES: OK" << endl;
}



Design::~Design() {
}

