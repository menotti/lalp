#ifndef COMPONENTE_H
#define	COMPONENTE_H
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
#include <list>
#include "Ligacao.h"




using namespace std;
using namespace SageInterface;

class Componente {  
    public:
                Componente(SgNode* node);
        void    ligado_Em(SgNode* nodo);
        SgNode* getPai();

        void    setName(const string &nome);
        void    imprimeLigacoes();
        string  imprimeDOT();
        string  getName();
        //void    addLigacao();
        void    imprime();
        virtual ~Componente();
        void    addLigacao(Ligacao* lig);
        string  tipo_comp; 
        SgNode* node;
        string  for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
        string  op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        string  valor;          //Valor da Variavel ou Todos os elementos do Vetor
        //Componente* out_comp;   //Define saida do componente (esse atributo 'e comum)
        
        //Referencias - Referencias de Arrays e Variaveis dentro das expressoes
        string  ref_var_nome;
        string  ref_var_index;
        string  ref_var_tipo;   //A referencia pode ser Vetor ou Variavel
        
        string  cons_tipo;
    private:
        //COMUM
        //SgNode* node;
        string  nome;
        //string  tipo_comp;      //Tipo do Componente - Registrador - Operacao - Contador - etc
        bool    eInicializado;  //Se a variavel foi inicializada
        SgNode* nodoPai;       //Relacionado com os nodos nas expressoes
        //Componente* out_comp;   //Define saida do componente (esse atributo 'e comum)
        list<Ligacao*> ligacoes;
        
        //VAR
        string  tipo_var;       //Int - Str - Flo
        //string  valor;          //Valor da Variavel ou Todos os elementos do Vetor
        
        //VETOR
        bool    eVetor;
        int     qtd_ele_vet;    //quantidade de elementos dentro do vetor
        
        //OPERACAO
        //string  op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        //Componente*  op_in_1;    //Define entrada 1
        //Componente*  op_in_2;    //Define entrada 2
        
        //CONTADOR - EX.: for (i = 0, i < 10, i++)
        //string  for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
        int     for_ctr_val_ini;//Valor inicial da variavel de controle
        string  for_cond_var;   //variavel de condicao - EX.: (i) => i < 10
        int     for_cond_val;   //valor de condicao - EX.: (10) => i < 10
        string  for_cond_op;    //operacao de controle do for - EX.: (<) => i < 10
        string  for_incr_var;   //variavel incrementar for - EX.: (i) => i++;
        string  for_incr_op;    //incrementar for - EX.: (++) => i++;
        int     for_incr_val;   //valor incrementar for - EX.: 1
        //DELAY
        
        //Constante - Numero dentro da Expressao
        //string  cons_tipo;
        //valor
        
        //Referencias - Referencias de Arrays e Variaveis dentro das expressoes
        //string  ref_var_nome;
        //string  ref_var_index;
        //string  ref_var_tipo;   //A referencia pode ser Vetor ou Variavel
        
        void montaComponenteVar();
        void montaComponenteLoop();
        void montaComponenteConst();
        void montaComponenteRef();
        void montaComponenteOp();
        void limpaAtributos();
        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */

