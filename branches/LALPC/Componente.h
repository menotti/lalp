/* 
 * File:   Componente.h
 * Author: Lucas Porto
 *
 * Created on 14 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "variables.h"

#ifndef COMPONENTE_H
#define	COMPONENTE_H

using namespace std;
using namespace SageInterface;

class Componente {  
    public:
        Componente(SgNode* node);
        void imprime();
        virtual ~Componente();
    private:
        //COMUM
        SgNode* node;
        string  nome;
        string  tipo_comp;      //Tipo do Componente - Registrador - Operacao - Contador - etc
        bool    eInicializado;  //Se a variavel foi inicializada
        
        //VAR
        string  tipo_var;       //Int - Str - Flo
        string  valor;          //Valor da Variavel ou Todos os elementos do Vetor
        
        //VETOR
        bool    eVetor;
        int     qtd_ele_vet;    //quantidade de elementos dentro do vetor
        
        //OPERACAO
        string  tipo_op;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        
        //CONTADOR
        
        //DELAY
        
        void montaComponente();
        void limpaAtributos();
        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */

