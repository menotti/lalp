/* 
 * File:   Port.cpp
 * Author: demo
 * 
 * Created on July 16, 2013, 1:33 PM
 */
#include "../header/meuHeader.h"
#include "Port.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>


using namespace std;

Port::Port(const string& name, const string& input, const string& type, const string& width, const string& aux) {
    this->name  = name;
    this->input = input;
    this->type  = type;
    this->width = width;
    this->aux   = aux;
}

//Ligacao* Port::getLigacao(){
string Port::getLigacao(){
    return this->ligacao;
}

//void Port::setLigacao(Ligacao* lig){
void Port::setLigacao(const string&  lig){
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

void Port::setWidth(const string&  width){
    this->width = width;
}

string Port::getWidth(){
    return this->width;
}

string Port::getAux(){
    return this->aux;
}

Port::~Port() {
}

