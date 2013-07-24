/* 
 * File:   Ligacao.cpp
 * Author: Lucas Porto
 * 
 * Created on June 28, 2013, 8:51 AM
 */
#include "header/meuHeader.h"
#include "Ligacao.h"
#include "Componente/Componente.h"
#include <string>
#include "Componente/Port.h"

using namespace std;
using std::string;
using std::stringstream;

Ligacao::Ligacao(class Componente* origem, class Componente* destino, const string& nome) {
    this->origem  = origem;
    this->destino = destino;
    this->nome    = nome;
}

void Ligacao::editOrig(class Componente* newOrig){
    this->origem  = newOrig;
}

void Ligacao::editDest(class Componente* newDest){
    this->destino = newDest;
}

string Ligacao::imprimeDot(){
    string res       = "";
    string inPorta   = "";
    string outPorta  = "";
    string size      = "";
 
    inPorta = ":"+this->getPortOrigem()->getName();
    outPorta = ":"+this->getPortDestino()->getName();
    size = "["+this->tamBarramento+"]";
  
    res += "\""+this->origem->getName()+"\""+inPorta+" -> \"" +this->destino->getName()+"\""+outPorta+"[label=\"" +this->nome+size+  "\" color=red fontcolor=red]; \n";
    return res;
}

string Ligacao::getTipo(){
    return this->tipo;
}

void Ligacao::setTipo(const string &tipo){
    this->tipo = tipo;
}

string Ligacao::getWidth(){
    return this->tamBarramento;
}

void Ligacao::setWidth(const string &size){
    this->tamBarramento = size;
}
class Componente* Ligacao::getOrigem() {
    return this->origem;
}

void Ligacao::setPortDestino(Port* porta){
    this->portDestino = porta;
}

void Ligacao::setPortOrigem(Port* porta){
    this->portOrigem = porta;
}

Port* Ligacao::getPortDestino(){
    return this->portDestino;
}

Port* Ligacao::getPortOrigem(){
    return this->portOrigem;
}

string Ligacao::getNome(){
    return this->nome;
}

class Componente* Ligacao::getDestino() {
    return this->destino;
}

Ligacao::~Ligacao() {
}

