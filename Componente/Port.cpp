/* 
 * File:   Port.cpp
 * Author: demo
 * 
 * Created on July 16, 2013, 1:33 PM
 */
//#include "../header/meuHeader.h"
#include "Port.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "../Ligacao.h"
#include <iostream>
using namespace std;

Port::Port(const string& name, const string& input, const string& type, const string& width, const string& aux) {
    this->name          = name;
    this->input         = input;
    this->type          = type;
    this->width         = width;
    this->aux           = aux;
    this->isLargePort   = false;
    this->temLigacaoo   = false;
    this->lig           = NULL;
    this->ligacao       = "";
}

bool Port::temLigacao(){
    return this->temLigacaoo;
}

Ligacao* Port::getLigacao2(){
    Ligacao* retorno = NULL;
    if(this->isLargePort == false){ 
        retorno = this->lig; 
    }
    return retorno;
}

const string& Port::getLigacao(){
    return this->ligacao;
}

void Port::addLigacao(Ligacao* lig1){
    this->temLigacaoo = true;
    this->lig = lig1;
}

void Port::setLigacao(const string&  lig){
    this->temLigacaoo = true;
    this->ligacao = lig;
}

string Port::getName(){
    return this->name;
}

string Port::getInput(){
    return this->input;
}

string Port::getType(){
    return this->type;
}

string Port::getWidth(){
    return this->width;
}

string Port::getAux(){
    return this->aux;
}

void Port::setWidth(const string&  width){
    this->width = width;
}

Port::~Port() {
}

