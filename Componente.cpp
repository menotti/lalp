/* 
 * File:   Componente.cpp
 * Author: Lucas Porto
 * 
 * Created on 14 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "Componente.h"
#include "variables.h"
#include <boost/lexical_cast.hpp>

using namespace std;
using namespace SageInterface;
using std::stringstream;
using boost::lexical_cast;
using std::string;

Componente::Componente(SgNode* node) {
    this->limpaAtributos();
    this->node = node;
    this->montaComponente();
}

void Componente::limpaAtributos(){
    //COMUM
    this->nome;
    this->tipo_comp     = "";      //Tipo do Componente - Registrador - Operacao - Contador - etc
    this->eInicializado = false;  //Se a variavel foi inicializada

    //VAR
    this->tipo_var      = "";       //Int - Str - Flo
    this->valor         = "";          //Valor da Variavel ou Todos os elementos do Vetor

    //VETOR
    this->eVetor        = false;
    this->qtd_ele_vet   = 0;    //quantidade de elementos dentro do vetor

    //OPERACAO
    this->tipo_op       = "";  
}

void Componente::imprime(){
    cout<< "NOME VAR:  "<< this->nome           << endl;
    cout<< "E INICIADO:"<< this->eInicializado  << endl;
    cout<< "E VETOR:   "<< this->eVetor         << endl;
    cout<< "TIPO VAR:  "<< this->tipo_var       << endl;
    cout<< "TIPO COMP: "<< this->tipo_comp      << endl;
    cout<< "QTD ELEME: "<< this->qtd_ele_vet    << endl;
    cout<< "VALOR:     "<< this->valor          << endl;
    cout<< " "<< endl;
}

//Metodo Resonsavel por montar o componente de acordo com sua estrutura: VARIAVEL, LACO, ETC
void Componente::montaComponente(){
    //VERIFICAR SE E VARIAVEL
    SgInitializedName* cur_var          = isSgInitializedName(this->node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(cur_var->get_parent());
    
    if (cur_var != NULL){
        varID var(isSgInitializedName(this->node));
        
        //Pegar nome
        this->nome = cur_var->get_name().getString();
        
        //Verificar se e vetor ou nao - isso vai empactar para definir hardware
        //registrador (variavel) ou memoria (vetor)
        string tipo="";
        if (var.isArrayType() == true){
            this->eVetor        = true;
            this->tipo_comp     = "MEM";
            
            //Pegar tipo do vetor
            tipo = SageInterface::getArrayElementType(cur_var->get_type())->get_mangled().str();
            
            //Tamanho do Vetor
            const vector<string> words = split(varDec->get_mangled_name().getString(), "_");
            this->qtd_ele_vet = lexical_cast<int>(string(words[7].c_str()));
        }else{
            this->eVetor = false;
            this->tipo_comp     = "REG";
            
            //Pegar tipo da variavel
            tipo = cur_var->get_type()->get_mangled().str();
        }

        //TODO - Ver como que vai ficar o esquema de tipo da variavel ou vetor
        //Identificar o tipo da variavel/vetor
        //if((tipo.compare("i")) == 1){
        if(tipo=="i"){
            this->tipo_var = "INT";
        }
        //if((tipo.compare("c")) == 1){
        if(tipo=="c"){
            this->tipo_var = "CHA";
        }
        //if((tipo.compare("f")) == 1){
        if(tipo=="f"){
            this->tipo_var = "FLO";
        }
        //if((tipo.compare("d")) == 1){
        if(tipo=="d"){
            this->tipo_var = "DOU";
        }
        
        
        /*
         * abaixo verifica a subtree apartir do nodo isSgInitializedName
         * sendo assim dentro desta sub-arvore temos todas as informacoes da
         * variavel/vetor
         */
        Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgAssignInitializer);
        if(var2.size() > 0){
            this->eInicializado = true;
            //Caso for vetor, pegar a quantidade de elementos dentro do mesmo
            if(var.isArrayType()){
                this->qtd_ele_vet = var2.size();
            }else{
                this->qtd_ele_vet = 1;
            }
            
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    std::string str = boost::lexical_cast<std::string>(intVal->get_value());
                    if(var2.size() < 2){
                        this->valor = ""+str;
                    }else{
                        this->valor += ""+str+"|";
                    }
                }
            }
        }
    }   
}

vector<string> Componente::split(const string& s, const string& delim) {
    vector<string> result;
    if (delim.empty()) {
        result.push_back(s);
        return result;
    }
    string::const_iterator substart = s.begin(), subend;
    while (true) {
        subend = search(substart, s.end(), delim.begin(), delim.end());
        string temp(substart, subend);
        if (!temp.empty()) {
            result.push_back(temp);
        }
        if (subend == s.end()) {
            break;
        }
        substart = subend + delim.size();
    }
    return result;
}

Componente::~Componente() {
}

