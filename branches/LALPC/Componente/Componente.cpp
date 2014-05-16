/* 
 * File:   Componente.cpp
 * Author: Lucas Porto
 * 
 * Created on 14 de Junho de 2013, 10:07
 */
//#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <stdlib.h>
#include "Componente.h"
#include "../Ligacao.h"
#include "Port.h"
#include "PortLarge.h"
#include "../Aux/FuncoesAux.h"
#include "GenericMap.h"

using namespace std;
using std::string;
using std::stringstream;

Componente::Componente(void* node/*=NULL*/, const string &aux/*=""*/,  int dataWidth /*=32*/){
    
    //Criacao de componentes baseados na arvore AST Rose
    if(node != ""){
        this->node = node;
        this->writeEnable = false;
    }
    if(aux == "WE"){
        this->writeEnable = true;
    }
    this->nodoPai       = NULL;
    this->sync          = true;
    this->userSync      = false;
    this->addressWidth  = 2;
    this->dataWidth     = dataWidth;
    this->eInicializado = false;
    this->compIf        = NULL;
    this->compFor       = NULL;
    this->isIf          = false;
    this->isIfBody      = false;
    this->valStepAux    = 0;
    this->delayValComp  = "1";
    setEIndice(false);
    setALAP(0);
    setASAP(0);
    setNumLinha(0);
    this->setDelayValComp("1");
}


void Componente::setValStepAux(int val){
    this->valStepAux = val;
}

int Componente::getValStepAux(){
    return this->valStepAux;
}

void Componente::setIf(bool val){
    this->isIf = val;
}

bool Componente::getIf(){
    return this->isIf;
}

void Componente::setIfComp(Componente* comp){
    this->compIf = comp;
}

void Componente::setForComp(Componente* comp){
    this->compFor = comp;
}

Componente* Componente::getIfComp(){
    return this->compIf;
}
Componente* Componente::getForComp(){
    return this->compFor;
}

void Componente::setIfBody(bool val){
    this->isIfBody = val;
}

bool Componente::getIfBody(){
    return this->isIfBody;
}

string Componente::getMemoriaVHDLCab(){
}

string Componente::getMemoriaVHDLRod(){
}


int Componente::getAddressWidth(){
    return this->addressWidth;
}

int Componente::getWidth(){
    return this->dataWidth;
}

void Componente::setNomeVarRef(const string &nome){
    this->ref_var_nome = nome;
}

string Componente::getNomeVarRef(){
    return this->ref_var_nome;
}

bool Componente::getUserSync(){
    return this->userSync;
}

void Componente::setUserSync(bool userSync){
    this->userSync = userSync;
}

bool Componente::getSync(){
    return this->sync;
}

void Componente::setSync(bool sync){
    this->sync = sync;
    if(sync == false) this->setDelayValComp("0");
}

void Componente::setNumParalelLina(const string &id){
    this->numParallelLine = id;
}

string Componente::getNumParalelLina(){
    string res = "";
    res += this->numParallelLine;
    return res;
}

void Componente::setEIndice(bool val){
    this->isIndice = val;
}

bool Componente::getEIndice(){
    return this->isIndice;
}

bool Componente::isSuccessorOf(Componente* comp){
    bool aux = false;
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        if((*i)->getAtivo() == false ) continue;
        if((*i)->getDestino()->getName() == this->getName()){
            if((*i)->getOrigem()->getName() == comp->getName()){
                aux = true;
            }
        }
    }
    return aux;
}

void Componente::setNumLinha(int num){
    this->numLinha = num;
}

int Componente::getNumLinha(){
    return this->numLinha;
}

void Componente::setWE(bool val){
    this->writeEnable = val;
}

string Componente::getNumIdComp(){
    return this->idComp;
}

void Componente::setNumIdComp(const string &id){
    this->idComp = id;
}

string Componente::getDelayValComp(){
    return this->delayValComp;
}

void Componente::setDelayValComp(const string &delayVal){
    this->delayValComp = delayVal;
}

void Componente::setGenericMapVal(const string &map, const string &aux, const string &val){
    list<GenericMap*>::iterator g;
    for(g=this->genMap.begin(); g != this->genMap.end(); g++){
        if((*g)->getNome() == map){
            if(aux == "NOME"){
                (*g)->setNome(val);
            }
            if(aux == "VAL"){
                (*g)->setValor(val);
            }
            if(aux == "TIPO"){
                (*g)->setTipo(val);
            }
        }
    }
}

string Componente::getGenericMapVal(const string &nome, const string &aux){
    string res = "";
    list<GenericMap*>::iterator g;
    for(g=this->genMap.begin(); g != this->genMap.end(); g++){
        if((*g)->getNome() == nome){
            if(aux == "NOME"){ //sem funcionalidade, depois retiro
                res += (*g)->getNome();
            }
            if(aux == "VAL"){
                res += (*g)->getValor();
            }
            if(aux == "TIPO"){
                res += (*g)->getTipo();
            }
        }
    }
    return res;
}

//list<Port*> Componente::getAllPorts(){
//    return this->portas;
//}
string Componente::geraCompVHDL(){

    string deb = "";
    string res = "";
    list<GenericMap*>::iterator g;

    bool f;
    //NOME COMP
    res += "\\"+this->getName()+"\\: "+this->getNomeCompVHDL()+"\n";
        
    //GENERICS
    res += "generic map ( \n";
    f = false;
    for(g=this->genMap.begin(); g != this->genMap.end(); g++){
        if(f){
            res += ",\n";
        }else{
            f = true;
        }
        res += "\t"+(*g)->getNome()+" => "+(*g)->getValor();
    }
    res += "\n)\n"; 
    
    //PORTS
    f = false;
    res += "port map ( \n";
    list<Port*>::iterator p;
    for(p=this->portas.begin(); p != this->portas.end(); p++){
//        if(!(*p)->temLigacao()) continue;

        
        Ligacao* s = (*p)->getLigacao2();

        if(s != NULL && (*p)->isLargePort == false){
            //cout<< "COMP: {"<< this->getName() << "}  PORTA ["<< (*p)->getName() << "] LIG: '"<<s->getNome()<<"' " << endl;
            if(f){
                res += ",\n";
            }else{
                f = true;
            }
            if((*p)->getType() == s->getTipo()){
                if((*p)->getWidth() == s->getWidth()){
                    res += "\t"+(*p)->getName()+" => "+(*p)->getLigacao2()->getNome();
                }else{
                    int portaWidth = FuncoesAux::StrToInt((*p)->getWidth());
                    int LigacWidth = FuncoesAux::StrToInt(s->getWidth());
                    if(portaWidth < LigacWidth){
                        res += "\t"+(*p)->getName()+"("+FuncoesAux::IntToStr(portaWidth-1)+" downto 0) => "+(*p)->getLigacao2()->getNome()+"(" +FuncoesAux::IntToStr(portaWidth-1)+" downto 0)";
                    }else{
                        res += "\t"+(*p)->getName()+"("+FuncoesAux::IntToStr(LigacWidth-1)+" downto 0) => "+(*p)->getLigacao2()->getNome()+"(" +FuncoesAux::IntToStr(LigacWidth-1)+" downto 0)";
                    }  
                }
                
            }else{

                if(s->getTipo() == "std_logic"){
                    res += "\t"+(*p)->getName()+"(0) => "+(*p)->getLigacao2()->getNome();
                }else{
                    res += "\t"+(*p)->getName()+" => "+(*p)->getLigacao2()->getNome()+"(0)";
                }
            }
        }
        //Este caso entra as ligacoes de RESET e CLK tem a ref na porta mas nao existe a ligacao 
        else{
            if((*p)->isLargePort){
                map<int, Ligacao*>::iterator m;
                map<int, Ligacao*> ligacoes;
                PortLarge* portaL = (PortLarge*)(*p);
                int bits = (FuncoesAux::StrToInt(portaL->getWidth()))-1;
                
                ligacoes = portaL->getLigacoes();
                
                for(m= ligacoes.begin(); m != ligacoes.end(); m++){
                    if(f){
                        res += ",\n";
                    }else{
                        f = true;
                    }
                    int val             = -1 * ((*m).first);
                    string name         = (*m).second->getNome();
                    string auxWIdht     = (*m).second->getWidth();
                    int sinalWidth      = FuncoesAux::StrToInt(auxWIdht);
                    sinalWidth--; 
                    
                    res += "\t"+(*p)->getName() + "(" + FuncoesAux::IntToStr(bits) + " downto " + FuncoesAux::IntToStr(val) + ") => " + name + "(" + FuncoesAux::IntToStr(sinalWidth) + " downto 0)";
                    val--;
                    bits = val;
                }
            }else{
                if((*p)->getLigacao() != ""){
                    if(f){
                        res += ",\n";
                    }else{
                        f = true;
                    }
                    res += "\t"+(*p)->getName()+" => "+(*p)->getLigacao();
                }
            }
        }
  
    }
    res += "\n);\n\n"; 
    return res;
}


Ligacao* Componente::getLigacaoByName(const string &nome){
    bool debug = false;
    string str = "";
    str += "tentando encontrar ligacao com nome: "+nome+"\n";
    Ligacao* aux = NULL;
    list<Ligacao*>::iterator i;
    
    
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        if((*i)->getAtivo() == false ) continue;
        str += (*i)->getNome() + "\n";                
        if((*i)->getNome() == nome){
            aux = (*i);
            str += "-- Econtrada lig com: "+nome+"\n";
        }
    }
    if (debug)
        cout<<str<<endl;
    return aux;
}

Ligacao* Componente::getLigacaoOutDefault(){
    Ligacao* aux = NULL;
    aux = this->getPortDataInOut("OUT")->getLigacao2();
    return aux;
}

Ligacao* Componente::getLigacaoInDefault(){
    Ligacao* aux = NULL;
    aux = this->getPortDataInOut("IN")->getLigacao2();;
    return aux;
}

bool Componente::getWE(){
    return this->writeEnable;
}

void Componente::setEInicializado(bool val){
    this->eInicializado = val;
}

bool Componente::getEInicializado(){
    return (this->eInicializado);
}

Port* Componente::getPortDataInOut(const string &str_aux){
    list<Port*>::iterator i;
    Port* aux;
    
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        if((*i)->getAux() == str_aux){
            aux = (*i);
        }
    }
    return aux;
}

Port* Componente::getPortOther(const string &str_aux){
    list<Port*>::iterator i;
    Port* aux = NULL;
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        if((*i)->getName() == str_aux){
            aux = (*i);
        }
    }
    return aux;
}

int Componente::getQtdPorts(){
    return this->portas.size();
}

string Componente::getNomeCompVHDL(){
    return this->nome_comp_vhdl;
}

void Componente::setNomeCompVHDL(const string &nome){
    this->nome_comp_vhdl = nome;
}

void Componente::setPai(void* nodo){
    //Cria a ligacao do noto atual na entrada do nodo do PARAMETRO
    this->nodoPai = nodo;
}

void Componente::addPort(Port* lig){
    this->portas.push_back(lig);
}

void Componente::addGenericMap(GenericMap* map){
    this->genMap.push_back(map);
}

void Componente::addLigacao(Ligacao* lig){
    this->ligacoes.push_back(lig);
}

void Componente::removeLigacao(Ligacao* lig){
    
    this->ligacoes.remove(lig);
}

void*  Componente::getPai(){
    return this->nodoPai;
}

string Componente::imprimeLigacoes(){
    string res ="";
    list<Ligacao*>::iterator i;
    cout<< "QTD LIG: "<< this->ligacoes.size() << endl;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        if((*i)->getAtivo() == false ) continue;
//        res += (*i)->getNome()+":( "+ (*i)->getWidth() +" ):"+(*i)->getOrigem()->getName()+" ("+(*i)->getPortOrigem()->getName()+") -> ("+(*i)->getPortDestino()->getName()+") "+(*i)->getDestino()->getName()+"\n";
        res += " LIGACAO  ("+(*i)->getNome()+")  WIDTH: "+ (*i)->getWidth() +" TIPO: "+(*i)->getTipo()+"\n"; 
        res += " Origem:  ("+(*i)->getPortOrigem()->getName()+ ")  WIDTH: "+ (*i)->getPortOrigem()->getWidth() + " TIPO: "+ (*i)->getPortOrigem()->getType()  +"\n";
        res += " Destino: ("+(*i)->getPortDestino()->getName()+ ")  WIDTH: "+ (*i)->getPortDestino()->getWidth() + " TIPO: "+ (*i)->getPortDestino()->getType() +"\n\n";
    }
      return res;
}

string Componente::imprimePortas(){
    string res ="";
    list<Port*>::iterator i;
    cout<< "qtd: "<< this->portas.size() << endl;
 
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        if ((*i)->temLigacaoo != true) continue;
        if ((*i)->isLargePort == false){
            if((*i)->temLigacaoo == true && (*i)->getLigacao2() == false){
                res += (*i)->getName()+" : "+(*i)->getInput()+" | "+ (*i)->getType() +" | NOME LIG:" + (*i)->getLigacao() + "\n";
            }else{
                res += (*i)->getName()+" : "+(*i)->getInput()+" | "+ (*i)->getType() +" | NOME LIG:" + (*i)->getLigacao2()->getNome() + "\n";
            }
        }else{
            map<int, Ligacao*>::iterator m;
            map<int, Ligacao*> ligacoes1;
            PortLarge* portaL = (PortLarge*)(*i);
            ligacoes1 = portaL->getLigacoes();
            for(m= ligacoes1.begin(); m != ligacoes1.end(); m++){
                res += (*i)->getName()+" : "+(*i)->getInput()+" | "+ (*i)->getType() +" | NOME LIG:" + (*m).second->getNome() + "\n";
            }
        }
    }
    return res;
}

bool Componente::temPorta(const string &nome){
    bool tem = false;
    list<Port*>::iterator i;
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        if ((*i)->getName() == nome){
            tem = true;
        }
    }
      return tem;
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

int Componente::getQtdLig(){
    this->ligacoes.size();
}

void Componente::setALAP(int alap){
    this->alap = alap;
}

int Componente::getALAP(){
    return this->alap;
}

void Componente::setASAP(int asap){
    this->asap = asap;
}

int Componente::getASAP(){
    return this->asap;
}

list<Port*> Componente::getPorts(){
    return this->portas;
}

list<GenericMap*> Componente::getGenericMap(){
    return this->genMap;
}

int Componente::getSuccessorsLine(){
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        if((*i)->getAtivo() == false ) continue;
        if((*i)->getBackEdge()) continue;
        if((*i)->getOrigem()->getName() != this->getName()) continue;
        
        if((*i)->getDestino()->getNumLinha() > 0){
            return (*i)->getDestino()->getNumLinha();
        }else{
            return (*i)->getDestino()->getSuccessorsLine();
        }
    }
    return 0;
}

void Componente::copySchedulingTimes(){
    this->alap = this->asap;
}

void Componente::updateCompRef(){
    if (this->tipo_comp == CompType::REF){
        this->dataWidth         = this->getComponenteRef()->dataWidth;
        this->genMap            = this->getComponenteRef()->getGenericMap();
        this->portas            = this->getComponenteRef()->getPorts();
        this->delayValComp      = this->getComponenteRef()->getDelayValComp();
        this->copyAllPortsAndGM();
//        if(this->getTipoCompRef() == CompType::MEM){
//            string vhdlComp =  this->getComponenteRef()->getNomeCompVHDL();
//            if(this->getComponenteRef()->getEInicializado() == true){
//                vhdlComp += "_"+this->getName();
//            }
//            this->setNomeCompVHDL(vhdlComp);
//            this->getComponenteRef()->setNomeCompVHDL(vhdlComp);
//        }
//        if(this->getTipoCompRef() == CompType::REG){
            this->setNomeCompVHDL(this->getComponenteRef()->getNomeCompVHDL());
//        }
    }
}

void Componente::copyAllPortsAndGM(){
    list<Port*>::iterator p;
    list<GenericMap*>::iterator g;
    list<Port*>         newPortas;
    list<GenericMap*>   newGenMap;
    for(p=this->portas.begin(); p != this->portas.end(); p++){
        string nome     = (*p)->getName();
        string input    = (*p)->getInput();
        string tipo     = (*p)->getType();
        string widt     = (*p)->getWidth();
        string aux      = (*p)->getAux();
        newPortas.push_back(new Port(nome ,input ,tipo ,widt, aux));
    }
    this->portas = newPortas;
        
    for(g=this->genMap.begin(); g != this->genMap.end(); g++){
        string nome     = (*g)->getNome();
        string tipo     = (*g)->getTipo();
        string valor    = (*g)->getValor();
        newGenMap.push_back(new GenericMap(nome , tipo, valor));
    }
    this->genMap = newGenMap;
}

CompType::TIPO_COMP Componente::getTipoCompRef(){
    if (this->tipo_comp == CompType::REF){      
        return this->getComponenteRef()->tipo_comp;
    }else{
        return this->tipo_comp;
    }
}

void Componente::printAllPortsAllLig() {
    cout<< "----------------------------" << endl;
    cout<< this->getName() << endl;
    cout<< "----------------------------" << endl;
    list<Ligacao*>::iterator l;
    cout<< "##LIG:" << endl;
    cout << "#### QTD3 " << this->ligacoes.size() <<endl;
    for(l=this->ligacoes.begin(); l != this->ligacoes.end(); l++){
        if((*l)->getAtivo() == false ) continue;
        cout<< (*l)->getNome() << "("<<(*l)->getOrigem()->getName()<<") ["<<(*l)->getPortOrigem()->getName()<<"] -> ["<<(*l)->getPortDestino()->getName()<< "] (" << (*l)->getDestino()->getName()<< ")" << endl;
    }
    
}

Componente::~Componente() {
}


