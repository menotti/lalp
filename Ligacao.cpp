/* 
 * File:   Ligacao.cpp
 * Author: Lucas Porto
 * 
 * Created on June 28, 2013, 8:51 AM
 */
#include "Ligacao.h"
#include "Componente.h"
#include <string>

using namespace std;
using std::string;
using std::stringstream;

Ligacao::Ligacao(class Componente* origem, class Componente* destino, const string& nome) {
    this->origem  = origem;
    this->destino = destino;
    this->nome    = nome;
    //cout<< "Ligacao: " << origem->node->class_name() << "--->" << destino->node->class_name() << endl;
}

void Ligacao::editOrig(class Componente* newOrig){
    this->origem  = newOrig;
}
void Ligacao::editDest(class Componente* newDest){
    this->destino = newDest;
}

string Ligacao::imprimeDot(){
    string res      = "";
    string inPorta   = "";
    string outPorta  = "";
    if(this->inPort != ""){
        inPorta = ":"+this->inPort;
    }
    if(this->outPort != ""){
        outPorta = ":"+this->outPort;
    }
    res             += "\""+this->origem->getName()+"\""+inPorta+" -> \"" +this->destino->getName()+"\""+outPorta+"[label=\"" +this->nome+  "\" color=red fontcolor=red]; \n";
    return res;
}

class Componente* Ligacao::getOrigem() {
    return this->origem;
}

void Ligacao::setDestPort(const string &porta){
    this->outPort = porta;
}

void Ligacao::setOrigPort(const string &porta){
    this->inPort = porta;
}

string Ligacao::getOrigPort(){
    return this->inPort;
}

string Ligacao::getDestPort(){
    return this->outPort;
}

string Ligacao::getNome(){
    return this->nome;
}

class Componente* Ligacao::getDestino() {
    return this->destino;
}

Ligacao::~Ligacao() {
}

