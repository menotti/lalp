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
#include "../Ligacao.h"
#include "../Aux/FuncoesAux.h"



using namespace std;
using namespace SageInterface;

class Componente {  
    public:
                Componente(SgNode* node = NULL, const string &aux = "");
        void    setPai(SgNode* nodo = NULL);
        Componente* getComponenteRef();
        void    setComponenteRef(Componente* comp);
        int     ConverteStrToInt(const string &aux);
        vector<string> SplitStr(const string& s, const string& delim);
        string  ConverteIntToStr(int aux);
        SgNode* getPai();
        bool    writeEnable;
        void    setNomeCompVHDL(const string &nome);
        string  getNomeCompVHDL();
        void    setEInicializado(bool val);
        bool    getEInicializado();
//        string  getTipoOpVHDL();
        string  getDelayVal();
        void    setDelayVal(const string &val);
        string  getDelayBits();
        void    setDelayBits(const string &bits);
        void    setName(const string &nome);
        virtual void finalizaPortasComp()=0;
        void    imprimeLigacoes();
        string  getStringPortIN();
        string  getStringPortINSize();
        string  getStringPortOUT();
        string  getStringPortOUTSize();
        virtual string  geraVHDLComp()=0;
        virtual string  getEstruturaComponenteVHDL()=0;
        string  getName();
        //void    addLigacao();
        void    imprime();
        virtual string geraDOTComp()=0;
        virtual ~Componente();
        void    removeLigacao(Ligacao* lig);
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
        
        string  delayVal;
        
        string  nome;
        list<Ligacao*> ligacoes;
        Componente *refComp;
    private:
        //COMUM
        //SgNode* node;
        FuncoesAux* funcAux;
        
        string  nome_comp_vhdl;
        //string  tipo_comp;      //Tipo do Componente - Registrador - Operacao - Contador - etc
          //Se a variavel foi inicializada
        SgNode* nodoPai;       //Relacionado com os nodos nas expressoes
        //Componente* out_comp;   //Define saida do componente (esse atributo 'e comum)
        bool        eInicializado;
        
        //VAR
        string  tipo_var;       //Int - Str - Flo
        //string  valor;          //Valor da Variavel ou Todos os elementos do Vetor
              
        
        //VETOR
        bool    eVetor;
        int     qtd_ele_vet;    //quantidade de elementos dentro do vetor
//        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */

