/* 
 * File:   Componente.cpp
 * Author: Lucas Porto
 * 
 * Created on 14 de Junho de 2013, 10:07
 */
//#include "rose.h"
#include "../header/meuHeader.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "Componente.h"
#include "../Ligacao.h"
#include "Port.h"
#include "../Aux/FuncoesAux.h"
#include "GenericMap.h"

using namespace std;
using std::string;

Componente::Componente(SgNode* node/*=NULL*/, const string &aux/*=""*/){
    
    //Criacao de componentes baseados na arvore AST Rose
    if(node != NULL){
        this->node = node;
        this->writeEnable = false;
    }
    if(aux == "WE"){
        this->writeEnable = true;
    }
    this->sync = true;
    this->addressWidth  = 2;
    this->dataWidth     = 32;
    setALAP(0);
    setASAP(0);
    setNumLinha(0);
    this->setDelayValComp("1");
}
int Componente::getWidth(){
    return this->dataWidth;
}

bool Componente::getSync(){
    return this->sync;
}

void Componente::setSync(bool sync){
    this->sync = sync;
    if(!this->sync)
        this->setDelayValComp("0");
}

bool Componente::isSuccessorOf(Componente* comp){
    bool aux = false;
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
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
    res += "\t\\"+this->getName()+"\\: "+this->getNomeCompVHDL()+"\n";
    
    //GENERICS
    res += "\tgeneric map ( \n";
    f = false;
    for(g=this->genMap.begin(); g != this->genMap.end(); g++){
        if(f){
            res += ",\n";
        }else{
            f = true;
        }
        res += "\t\t"+(*g)->getNome()+" => "+(*g)->getValor();
    }
    res += "\n\t)\n"; 
    
    //PORTS
    f = false;
    res += "\tport map ( \n";
    list<Port*>::iterator p;
    for(p=this->portas.begin(); p != this->portas.end(); p++){
        if((*p)->getLigacao() == "") continue;

        Ligacao* s = this->getLigacaoByName((*p)->getLigacao());
//        cout<< this->getName() << "  PORTA "<< (*p)->getName() << " LIG: "<<(*p)->getLigacao() << endl;
        if(s != NULL){
            if(f){
                res += ",\n";
            }else{
                f = true;
            }
            if((*p)->getType() == s->getTipo()){
                if((*p)->getWidth() == s->getWidth()){
                    res += "\t\t"+(*p)->getName()+" => "+(*p)->getLigacao();
                }else{
                    int portaWidth = FuncoesAux::StrToInt((*p)->getWidth());
                    int LigacWidth = FuncoesAux::StrToInt(s->getWidth());
                    if(portaWidth < LigacWidth){
                        res += "\t\t"+(*p)->getName()+"("+FuncoesAux::IntToStr(portaWidth-1)+" downto 0) => "+(*p)->getLigacao()+"(" +FuncoesAux::IntToStr(portaWidth-1)+" downto 0)";
                    }else{
                        res += "\t\t"+(*p)->getName()+"("+FuncoesAux::IntToStr(LigacWidth-1)+" downto 0) => "+(*p)->getLigacao()+"(" +FuncoesAux::IntToStr(LigacWidth-1)+" downto 0)";
                    }  
                }
                
            }else{

                if(s->getTipo() == "std_logic"){
                    res += "\t\t"+(*p)->getName()+"(0) => "+(*p)->getLigacao();
                }else{
                    res += "\t\t"+(*p)->getName()+" => "+(*p)->getLigacao()+"(0)";
                }
            }
        }
        //Este caso entra as ligacoes de RESET e CLK tem a ref na porta mas nao existe a ligacao 
        else{ 
            if((*p)->getLigacao() != ""){
                if(f){
                res += ",\n";
                }else{
                    f = true;
                }
                res += "\t\t"+(*p)->getName()+" => "+(*p)->getLigacao();
            }
        }
  
    }
    res += "\n\t);\n\n"; 
    return res;
}


Ligacao* Componente::getLigacaoByName(const string &nome){
    bool debug = false;
    string str = "";
    str += "tentando encontrar ligacao com nome: "+nome+"\n";
    Ligacao* aux = NULL;
    list<Ligacao*>::iterator i;
    
    
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
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
    string ligName = "";
    ligName = this->getPortDataInOut("OUT")->getLigacao();
    if(ligName != ""){
        aux = this->getLigacaoByName(ligName);
    }
    return aux;
}

Ligacao* Componente::getLigacaoInDefault(){
    Ligacao* aux = NULL;
    aux = this->getLigacaoByName(this->getPortDataInOut("IN")->getName());
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

void Componente::setPai(SgNode* nodo){
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

SgNode* Componente::getPai(){
    return this->nodoPai;
}

string Componente::imprimeLigacoes(){
    string res ="";
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
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
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        res += (*i)->getName()+" : "+(*i)->getInput()+" | "+ (*i)->getType() +" | NOME LIG:" + (*i)->getLigacao() + "\n";
    }
      return res;
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
        if((*i)->getBlackEdge()) continue;
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
        this->genMap = this->getComponenteRef()->getGenericMap();
        this->portas = this->getComponenteRef()->getPorts();
        if(this->getTipoCompRef() == CompType::MEM){
            string vhdlComp = "block_ram";
            if(!this->getWE()){
                vhdlComp += "_"+this->getName();
            }else{
                this->getComponenteRef()->setNomeCompVHDL(vhdlComp);
            }
//            cout<<"----------NOME: "<< vhdlComp<<endl;
            this->setNomeCompVHDL(vhdlComp);
        }
    }
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
        cout<< (*l)->getNome() << "("<<(*l)->getOrigem()->getName()<<") ["<<(*l)->getPortOrigem()->getName()<<"] -> ["<<(*l)->getPortDestino()->getName()<< "] (" << (*l)->getDestino()->getName()<< ")" << endl;
    }
    
}

Componente::~Componente() {
}


