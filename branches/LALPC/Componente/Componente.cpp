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
    setNumLinha(0);
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
            if(aux == "NOME"){
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
        Ligacao* s = this->getLigacaoByName((*p)->getLigacao());
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
        }else{
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
    Ligacao* aux = NULL;
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        if((*i)->getNome() == nome){
            aux = (*i);
        }
    }
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
        res += (*i)->getNome()+":( "+ (*i)->getWidth() +" ):"+(*i)->getOrigem()->getName()+" ("+(*i)->getPortOrigem()->getName()+") -> ("+(*i)->getPortDestino()->getName()+") "+(*i)->getDestino()->getName()+"\n";
    }
      return res;
}

string Componente::imprimePortas(){
    string res ="";
    list<Port*>::iterator i;
    for(i=this->portas.begin(); i != this->portas.end(); i++){
        res += (*i)->getName()+" : "+(*i)->getInput()+ " - NOME LIG:" + (*i)->getLigacao() + "\n";
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

Componente::~Componente() {
}

