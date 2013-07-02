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

class Componente* Ligacao::getOrigem() {
    return this->origem;
}

string Ligacao::getNome(){
    return this->nome;
}

class Componente* Ligacao::getDestino() {
    return this->destino;
}
Ligacao::~Ligacao() {
}

