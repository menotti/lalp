/* 
 * File:   GenericMap.cpp
 * Author: demo
 * 
 * Created on July 23, 2013, 6:18 PM
 */
#include "../header/meuHeader.h"
#include "GenericMap.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>

using namespace std;

GenericMap::GenericMap(const string& nome, const string& tipo, const string& valor) {
    this->nome  = nome;
    this->tipo  = tipo;
    this->valor = valor;
}

string GenericMap::getNome(){
    return this->nome;
}
string GenericMap::getTipo(){
    return this->tipo;
}
string GenericMap::getValor(){
    return this->valor;
}
void GenericMap::setNome(const string& valor){
    this->nome = valor;
}
void GenericMap::setTipo(const string& valor){
    this->tipo = valor;
}
void GenericMap::setValor(const string& valor){
    this->valor = valor;
}

GenericMap::~GenericMap() {
}

