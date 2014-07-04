/* 
 * File:   analisaMem.cpp
 * Author: Lucas
 * 
 * Created on January 17, 2014, 9:28 AM
 */
#include "analisaMem.h"
#include <set>
#include "../Componente/Port.h"
#include "../Aux/FuncoesAux.h"
#include "../Componente/comp_ref.h"
#include "../Componente/mux_m_op.h"
#include "../Componente/block_ram.h"
#include "../Componente/counter.h"
#include "../Componente/delay_op.h"
#include "../Componente/block_ram_mult.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>


using namespace std;

analisaMem::analisaMem(Design* design) {
    this->design = design; 
    this->debug  = false;
}

Design* analisaMem::getDesign(){
    
    return this->design;
}

//Quando existe a necessidade de se colocar um mux isso ocorre que existe mais de um acesso
//para a mesma memoria, neste caso para corrigir um erro durante o processo de verificar backedge
//vamos pegar a ultima ocorrencia do acesso da memoria e definir esse valor para todos os componentes
int analisaMem::getNumLinhaMaxMem(Componente* comp){
    list<Componente*>::iterator i;
    int max = 0;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        //if ((*i)->getWE()) continue;
        comp_ref* comp = (comp_ref*) (*i);
        if (comp->getTipoVar() != "VET") continue;

        if ((*i)->getNomeVarRef() == comp->getNomeVarRef() && (*i)->getNumParalelLina() == comp->getNumParalelLina()) {
            if(max < (*i)->getNumLinha()) max = (*i)->getNumLinha();
        }
    }
    return max;
}

void analisaMem::insereStepMux(){
    list<Componente*>::iterator i;
    counter* ctd = NULL;
    mux_m_op* mux = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
         if ((*i)->tipo_comp == CompType::MUX) {
            mux = (mux_m_op* )(*i);
        }
        if ((*i)->tipo_comp == CompType::CTD) {
            ctd =(counter*)(*i);
        }
    }
    if(mux != NULL && ctd != NULL){
        int qtdEleMux = FuncoesAux::StrToInt(mux->getNSels());
        ctd->setGenericMapSteps(mux->getNOps());
 
        for (int z = 0; z < qtdEleMux; z++){
            int val = z+1;
            string widthPortaStep = ctd->getPortOther("step")->getWidth();
            string str = FuncoesAux::IntToStr(this->design->ListaComp.size());
            delay_op* comp = new delay_op(NULL);
            this->design->addComponent(comp);
            
            comp->setDelayVal(FuncoesAux::IntToStr(val));
            comp->setNumIdComp(str);
            
            string nome = "dly_" + str;
            
            comp->setName(nome);
            comp->getPortDataInOut("IN")->setWidth(widthPortaStep);
            comp->getPortDataInOut("OUT")->setWidth(widthPortaStep);
            comp->setDelayBits(widthPortaStep);
            comp->setASAP(0);
            comp->setNumIdComp(str);
            
            this->design->insereLigacao(comp, mux, "a_delayed", "Sel");
            this->design->insereLigacao(ctd, comp, "step", "a");            
            
        }
    }
}

void analisaMem::insereMux(){
    set<string>ListaAuxString;
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    cout << "--Verificando necessidade de MUX: " << endl;
    ListaAuxString.clear();
    Componente* compAux = NULL;
    
    int valLinha = 0;

    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        //if ((*i)->getWE()) continue;
        comp_ref* comp = (comp_ref*) (*i);
        if (comp->getTipoVar() != "VET") continue;
        if (this->design->verificarPrecisaMux((*i)) == false) continue;
        
        valLinha = getNumLinhaMaxMem((*i));
//        valLinha = (*i)->getNumLinha();
        
        if (ListaAuxString.find((*i)->getNomeVarRef()+(*i)->getNumParalelLina()) == ListaAuxString.end()) {
            int count = 0;
            ListaAuxString.insert((*i)->getNomeVarRef()+(*i)->getNumParalelLina());
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                comp_ref* compJ = (comp_ref*) (*j);
                if (compJ->getTipoVar() != "VET") continue;
                //if ((*j)->getWE()) continue;
                if ((*i)->node == (*j)->node) continue;
                if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
                if ((*i)->getNomeVarRef() != (*j)->getNomeVarRef()) continue;
                count++;
                if (count <= 1) {
                    (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setValStepAux(count);
                    string valAuxDly = (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->getDelayValComp();
                    int valAuxDlyy = FuncoesAux::StrToInt(valAuxDly);
//                    (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setDelayValComp(FuncoesAux::IntToStr(valAuxDlyy + count));

                    int qtdMem = this->design->verificarQtdAcessoMem((*i));
                    string nPos = FuncoesAux::IntToStr(qtdMem);
                    string nLis = FuncoesAux::IntToStr(qtdMem - 1);
                    
                    mux_m_op* mux = new mux_m_op(NULL, nPos, nLis, (*i)->dataWidth);
                    mux->setName("mux" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    mux->setNumLinha(valLinha);
                    mux->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    mux->setNumParalelLina((*i)->getNumParalelLina());
                    this->design->addComponent(mux);
                    
                    Ligacao* ligAddr = (*i)->getPortOther("address")->getLigacao2();
                    
                    (*i)->setNumLinha(valLinha);
                    (*i)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setNumLinha(valLinha);
                    (*i)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setUserSync(true);
                    
                    // Ligar do Contador ate este comp da porta STEP -> WE
                    Ligacao* newLig1 = this->design->insereLigacao((*i)->getForComp(), (*i)->getPortDataInOut("OUT")->getLigacao2()->getDestino(), "step", "we"); 
                    Componente* dly1 = this->design->insereDelay(newLig1, 2);
                    this->design->addComponent(dly1);
                    
                    
                    Componente* compOrigem = ligAddr->getOrigem();
                    compOrigem->removeLigacao(ligAddr);
                    (*i)->removeLigacao(ligAddr);
                    this->design->deletaLigacao(ligAddr->getNome());
                    this->design->insereLigacao(mux, (*i), mux->getPortDataInOut("OUT")->getName(), "address");

                    this->design->insereLigacao(compOrigem, mux, compOrigem->getPortDataInOut("OUT")->getName(), mux->getPortDataInOut("IN")->getName());
                    compAux = mux;

                    Ligacao* ligAddrJ = (*j)->getPortOther("address")->getLigacao2();
                    Ligacao* ligOutJ = (*j)->getPortDataInOut("OUT")->getLigacao2();

                    Componente* compOrigemJ = ligAddrJ->getOrigem();
                    Componente* compDestJ = ligOutJ->getDestino();

                    compOrigemJ->removeLigacao(ligAddrJ);
                    compDestJ->removeLigacao(ligOutJ);

                    (*j)->removeLigacao(ligAddrJ);
                    (*j)->removeLigacao(ligOutJ);
                    
                    this->design->deletaLigacao(ligAddrJ->getNome());
                    this->design->deletaLigacao(ligOutJ->getNome());

                    this->design->insereLigacao(compOrigemJ, mux, compOrigemJ->getPortDataInOut("OUT")->getName(), mux->getPortDataInOut("IN")->getName());
                    this->design->insereLigacao((*i), compDestJ, (*i)->getPortDataInOut("OUT")->getName(), compDestJ->getPortDataInOut("IN")->getName());
                    
                    compDestJ->setNumLinha(valLinha);
                    compDestJ->setUserSync(true);
                    
                    // Ligar do Contador ate este comp da porta STEP -> WE
                    Ligacao* newLig2 = this->design->insereLigacao(compDestJ->getForComp(), compDestJ, "step", "we"); 
                    Componente* dly2 = this->design->insereDelay(newLig2, 2 + count);
                    this->design->addComponent(dly2);

                    this->design->removeComponente((*j), NULL);
                }else{
                    (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setValStepAux(count);
                    string valAuxDly = (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->getDelayValComp();
                    int valAuxDlyy = FuncoesAux::StrToInt(valAuxDly);
//                    (*j)->getPortDataInOut("OUT")->getLigacao2()->getDestino()->setDelayValComp(FuncoesAux::IntToStr(valAuxDlyy + count));

                    Ligacao* ligAddrJ = (*j)->getPortOther("address")->getLigacao2();
                    Ligacao* ligOutJ = (*j)->getPortDataInOut("OUT")->getLigacao2();

                    Componente* compOrigemJ = ligAddrJ->getOrigem();
                    Componente* compDestJ = ligOutJ->getDestino();

                    compOrigemJ->removeLigacao(ligAddrJ);
                    compDestJ->removeLigacao(ligOutJ);

                    (*j)->removeLigacao(ligAddrJ);
                    (*j)->removeLigacao(ligOutJ);
                    
                    this->design->deletaLigacao(ligAddrJ->getNome());
                    this->design->deletaLigacao(ligOutJ->getNome());

                    this->design->insereLigacao(compOrigemJ, compAux, compOrigemJ->getPortDataInOut("OUT")->getName(), compAux->getPortDataInOut("IN")->getName());
                    this->design->insereLigacao((*i), compDestJ, (*i)->getPortDataInOut("OUT")->getName(), compDestJ->getPortDataInOut("IN")->getName());
                    
                    compDestJ->setNumLinha(valLinha);
                    compDestJ->setUserSync(true);
                    
                    // Ligar do Contador ate este comp da porta STEP -> WE
                    Ligacao* newLig2 = this->design->insereLigacao(compDestJ->getForComp(), compDestJ, "step", "we"); 
                    Componente* dly2 = this->design->insereDelay(newLig2, 2 + count);
                    this->design->addComponent(dly2);
                    
                    this->design->removeComponente((*j), NULL);
                }
            }
        }
    }
    ListaAuxString.clear();
    cout << "--Verificando necessidade de MUX: OK" << endl; // </editor-fold>
}

void analisaMem::insereRamMultPort(){
    //Fazer igual ao metodo anterior porem sem criar um mux
    set<string>ListaAuxString;
    list<Port*>::iterator p;
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    cout << "--Inserindo Block Ram Mult Port: " << endl;
    ListaAuxString.clear();
    Componente* compAux = NULL;
    Componente* compAuxWE = NULL;
    string      portAuxWE = "";
   this->debug = false;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        //if ((*i)->getWE()) continue;
        comp_ref* comp = (comp_ref*) (*i);
        if (comp->getTipoVar() != "VET") continue;
        if (this->design->verificarPrecisaMux((*i)) == false) continue;
        compAuxWE = NULL;
        portAuxWE = "";
        if(this->debug) cout<< "1 - MEM: '" << comp->getName() << "' - '" << (*i)->getNomeVarRef()<<"'" << endl;
//        if (ListaAuxString.find((*i)->getNomeVarRef()+(*i)->getNumParalelLina()) == ListaAuxString.end()) {
        if (ListaAuxString.find((*i)->getNomeVarRef()) == ListaAuxString.end()) {
            if(this->debug) cout<< "2 - Nao existe na lista" << endl;
            int count = 0;
//            ListaAuxString.insert((*i)->getNomeVarRef()+(*i)->getNumParalelLina());
            ListaAuxString.insert((*i)->getNomeVarRef());
            if(this->debug) cout<< "3 - inserido na lista" << endl;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                comp_ref* compJ = (comp_ref*) (*j);
                if (compJ->getTipoVar() != "VET") continue;
                //if ((*j)->getWE()) continue;
                if ((*i)->node == (*j)->node) continue;
//                if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
                if ((*i)->getNomeVarRef() != (*j)->getNomeVarRef()) continue;
                if(this->debug) cout<< "3.1 - MEM: '" << (*j)->getName() << "' - '" << (*j)->getNomeVarRef()<<"'" << endl;
                count++;
                if (count <= 1) {
                    if(this->debug) cout<< "4 - COUTN <= 1: '" << (*j)->getName() << "' - '" << (*j)->getNomeVarRef()<<"'" << endl;
                    comp_ref* comp = new comp_ref();
                    
                    comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    comp->setNumLinha((*i)->getNumLinha());
                    comp->setNumParalelLina("");
                    comp->setName((*i)->getNomeVarRef());
                    comp->setEInicializado((*i)->getEInicializado());
                    this->design->addComponent(comp);
                    
                    int qtdMem = 0;
                    qtdMem = this->design->verificarQtdAcessoMem((*i));
                    
                    block_ram_mult*     multRam =  new block_ram_mult(NULL, "", qtdMem, (*i)->dataWidth);
                    block_ram*          ram = (block_ram*)(*i)->getComponenteRef();
                    
                    multRam->setName((*i)->getNomeVarRef());
                    this->design->addComponent(multRam);
                    
                    if(ram->getEInicializado() == true){
                        multRam->setEInicializado(true);
                    }
                    multRam->setNomeCompVHDL("block_ram_mult_"+(*i)->getNomeVarRef());
                    
                    if(this->debug) cout<< "4.1 - MULTRAM: '" << multRam->getName() << "' - QTD PORTS: '" << qtdMem<<"'" << endl;
                    
                    multRam->valores = ram->valores;
                    multRam->setQtdElementos(FuncoesAux::IntToStr(ram->qtd_elem_vet));
                    
                    
                    ram->tipo_comp = CompType::DEL;
                    
                    comp->setComponenteRef(multRam);
                    comp->updateCompRef();

                    list<Port*> portas = (*i)->getPorts();
                    for(p= portas.begin(); p != portas.end(); p++){
                        if((*i)->getPortOther((*p)->getName())->temLigacao() == false) continue;
                        Ligacao* ligAux = (*i)->getPortOther((*p)->getName())->getLigacao2();
                        (*i)->removeLigacao(ligAux);
                        string portName = (*p)->getName()+"_0";
                        
                        if((*p)->getInput() == "in"){
                            Componente* compOrigem  = ligAux->getOrigem();
                            compOrigem->removeLigacao(ligAux);
                            this->design->insereLigacao(compOrigem, comp, ligAux->getPortOrigem()->getName(), portName);
                            if((*p)->getName() == "we"){
                                compAuxWE = compOrigem;
                                portAuxWE = ligAux->getPortOrigem()->getName();
                            }
                        }else{
                            Componente* compDestino = ligAux->getDestino();
                            compDestino->removeLigacao(ligAux);
                            this->design->insereLigacao(comp, compDestino, portName, ligAux->getPortDestino()->getName());
                        }
                        this->design->deletaLigacao(ligAux->getNome());
                    }
                    compAux = comp;
                    
                    list<Port*> portasJ = (*j)->getPorts();
                    for(p= portasJ.begin(); p != portasJ.end(); p++){
                        if((*j)->getPortOther((*p)->getName())->temLigacao() == false) continue;
                        
                        Ligacao* ligAux = (*j)->getPortOther((*p)->getName())->getLigacao2();
                        (*j)->removeLigacao(ligAux);
                        
                        string portName = (*p)->getName()+"_1";
                        
                        if((*p)->getInput() == "in"){
                            Componente* compOrigem  = ligAux->getOrigem();
                            compOrigem->removeLigacao(ligAux);
                            this->design->insereLigacao(compOrigem, comp, ligAux->getPortOrigem()->getName(), portName);
                        }else{
                            Componente* compDestino = ligAux->getDestino();
                            compDestino->removeLigacao(ligAux);
                            this->design->insereLigacao(comp, compDestino, portName, ligAux->getPortDestino()->getName());
                        }
                        this->design->deletaLigacao(ligAux->getNome());
                    }
                    if (compAuxWE != NULL){
                        this->design->insereLigacao(compAuxWE, compAux, portAuxWE, "we_1");
                    }

                    this->design->removeComponente((*j), NULL);
                    this->design->removeComponente((*i), NULL);
                }else{
                    string auxVal = FuncoesAux::IntToStr(count);
                    
                    list<Port*> portasJ = (*j)->getPorts();
                    for(p= portasJ.begin(); p != portasJ.end(); p++){
                        if((*j)->getPortOther((*p)->getName())->temLigacao() == false) continue;
                        
                        Ligacao* ligAux = (*j)->getPortOther((*p)->getName())->getLigacao2();
                        (*j)->removeLigacao(ligAux);
                        
                        string portName = (*p)->getName()+"_"+auxVal;
                                
                        if((*p)->getInput() == "in"){
                            Componente* compOrigem  = ligAux->getOrigem();
                            compOrigem->removeLigacao(ligAux);
                            this->design->insereLigacao(compOrigem, compAux, ligAux->getPortOrigem()->getName(), portName);
                        }else{
                            Componente* compDestino = ligAux->getDestino();
                            compDestino->removeLigacao(ligAux);
                            this->design->insereLigacao(compAux, compDestino, portName, ligAux->getPortDestino()->getName());
                        }
                        
                        this->design->deletaLigacao(ligAux->getNome());
                    }
                    if (compAuxWE != NULL){
                        string portAuxWE = "we_"+auxVal;
                        this->design->insereLigacao(compAuxWE, compAux, portAuxWE, portAuxWE);
                    }
                    this->design->removeComponente((*j), NULL);
                }
            }
        }
        compAuxWE = NULL;
    }
    ListaAuxString.clear();
    cout << "--Inserindo Block Ram Mult Port: OK" << endl; // </editor-fold>
}

analisaMem::~analisaMem() {
}

