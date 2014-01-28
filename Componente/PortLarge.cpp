/* 
 * File:   Port.cpp
 * Author: demo
 * 
 * Created on July 16, 2013, 1:33 PM
 */
//#include "../header/meuHeader.h"
#include "PortLarge.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "../Aux/FuncoesAux.h"
#include <map>
#include "../Ligacao.h"
#include <iostream>
using namespace std;

PortLarge::PortLarge(const string& name, const string& input, const string& type, const string& width, const string& aux) : Port (name, input, type, width, aux) {
    this->name          = name;
    this->input         = input;
    this->type          = type;
    this->width         = width;
    this->aux           = aux;
    this->isLargePort   = true;
    this->temLigacaoo   = false;
    this->lastConnectedBit = FuncoesAux::StrToInt(width) * -1;
}

 map<int, Ligacao*> PortLarge::getLigacoes(){
     return this->ligacaoMap;
 }

void PortLarge::addLigacao(Ligacao* lig){
    if(this->lastConnectedBit != 0){
        this->temLigacaoo = true;
        this->lastConnectedBit += FuncoesAux::StrToInt(lig->getWidth());
        this->ligacaoMap.insert(make_pair(this->lastConnectedBit, lig));
    }
}

PortLarge::~PortLarge() {
}

