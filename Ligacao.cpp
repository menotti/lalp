/* 
 * File:   Ligacao.cpp
 * Author: Lucas Porto
 * 
 * Created on June 28, 2013, 8:51 AM
 */
#include "Ligacao.h"
#include "Componente.h"


Ligacao::Ligacao(class Componente* origem, class Componente* destino) {
    this->origem  = origem;
    this->destino = destino;
}

class Componente* Ligacao::getOrigem() {
    return this->origem;
}

class Componente* Ligacao::getDestino() {
    return this->destino;
}
Ligacao::~Ligacao() {
}

