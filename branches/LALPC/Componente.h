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
        //void ligadoEm(SgNode* node);
        virtual ~Componente();
        string  tipo_comp; 
        SgNode* node;
    private:
        //COMUM
        //SgNode* node;
        string  nome;
        //string  tipo_comp;      //Tipo do Componente - Registrador - Operacao - Contador - etc
        bool    eInicializado;  //Se a variavel foi inicializada
        SgNode* ligadoEm;       //Relacionado com os nodos nas expressoes
        
        //VAR
        string  tipo_var;       //Int - Str - Flo
        string  valor;          //Valor da Variavel ou Todos os elementos do Vetor
        
        //VETOR
        bool    eVetor;
        int     qtd_ele_vet;    //quantidade de elementos dentro do vetor
        
        //OPERACAO
        string  op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        string  op_in_add1;     //Define entrada 1 da operacao ADD
        string  op_in_add2;     //Define entrada 1 da operacao ADD
        string  op_out_add2;    //Define saida da operacao ADD       
        
        //CONTADOR - EX.: for (i = 0, i < 10, i++)
        string  for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
        int     for_ctr_val_ini;//Valor inicial da variavel de controle
        string  for_cond_var;   //variavel de condicao - EX.: (i) => i < 10
        int     for_cond_val;   //valor de condicao - EX.: (10) => i < 10
        string  for_cond_op;    //operacao de controle do for - EX.: (<) => i < 10
        string  for_incr_var;   //variavel incrementar for - EX.: (i) => i++;
        string  for_incr_op;    //incrementar for - EX.: (++) => i++;
        int     for_incr_val;   //valor incrementar for - EX.: 1
        //DELAY
        
        //Constante - Numero dentro da Expressao
        string  cons_tipo;
        //valor
        
        //Referencias - Referencias de Arrays e Variaveis dentro das expressoes
        string  ref_var_nome;
        string  ref_var_index;
        
        void montaComponenteVar();
        void montaComponenteLoop();
        void montaComponenteConst();
        void montaComponenteRef();
        void montaComponenteOp();
        void limpaAtributos();
        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */

