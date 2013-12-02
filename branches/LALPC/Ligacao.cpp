/* 
 * File:   Ligacao.cpp
 * Author: Lucas Porto
 * 
 * Created on June 28, 2013, 8:51 AM
 */
//#include "header/meuHeader.h"
#include "Ligacao.h"
#include "Componente/Componente.h"
#include <string>
#include "Componente/Port.h"

using namespace std;
using std::string;
using std::stringstream;

Ligacao::Ligacao(class Componente* origem, class Componente* destino, const string& nome) {
    this->origem        = origem;
    this->destino       = destino;
    this->nome          = nome;
    this->BackEdge      = false;
    this->width         = "1";
    this->ativo         = true;
}

void Ligacao::setBackEdge(bool val){
    this->BackEdge  = val;
}

bool Ligacao::getBackEdge(){
    return this->BackEdge;
}

void Ligacao::setAtivo(bool status){
    this->ativo  = status;
}

bool Ligacao::getAtivo(){
    return this->ativo;
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
    size = "["+this->width+"]";
  
    res += "\""+this->origem->getName()+"\""+inPorta+" -> \"" +this->destino->getName()+"\""+outPorta+"[label=\"" +this->nome+size+  "\" color=red ";
    if(this->BackEdge) {
        res += "style=dashed";
    }
    res += "]; \n";
    return res;
}

string Ligacao::getTipo(){
    return this->tipo;
}

void Ligacao::setName(const string &nome){
    this->nome = nome;
}
void Ligacao::setTipo(const string &tipo){
    this->tipo = tipo;
}

string Ligacao::getWidth(){
    return this->width;
}

void Ligacao::setWidth(const string &size){
    this->width = size;
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

const string& Ligacao::getNome()const{
    return this->nome;
}

class Componente* Ligacao::getDestino() {
    return this->destino;
}

Ligacao::~Ligacao() {
}

