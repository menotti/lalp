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
                Componente(SgNode* node = NULL, const string &aux = "");
        void    ligado_Em(SgNode* nodo);
        SgNode* getPai();
        bool    writeEnable;

        bool    VetorTemValorInicial();
        string  getTipoOpVHDL();
        string  getDelayVal();
        void    setDelayVal(const string &val);
        string  getDelayBits();
        void    setDelayBits(const string &bits);
        void    setName(const string &nome);
        void    finalizaPortasComp();
        void    imprimeLigacoes();
        string  getStringPortIN();
        string  getStringPortINSize();
        string  getStringPortOUT();
        string  getStringPortOUTSize();
        string  geraVHDLComp();
        string  imprimeDOT();
        string  getName();
        //void    addLigacao();
        void    imprime();
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
        
        
        /**************************************************************/
        //OPERACAO
        string op_tipo_comp_vhdl; //add_op_s
	//generic map
	string op_w_in1;
	string op_w_in2;
	string op_w_out;
        
	//port map
	string op_I0;
	string op_I1;
	string op_O0;        
        /**************************************************************/
        
        
        /**************************************************************/
        //CONTADOR - EX.: for (i = 0, i < 10, i++)
        //string  for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
        int     for_ctr_val_ini;//Valor inicial da variavel de controle
        string  for_cond_var;   //variavel de condicao - EX.: (i) => i < 10
        int     for_cond_val;   //valor de condicao - EX.: (10) => i < 10
        string  for_cond_op;    //operacao de controle do for - EX.: (<) => i < 10
        string  for_incr_var;   //variavel incrementar for - EX.: (i) => i++;        //this->op_in_add1;     //Define entrada 1 da operacao ADD
        //this->op_in_add2;     //Define entrada 1 da operacao ADD
        //this->op_out_add2;    //Define saida da operacao ADD
        string  for_incr_op;    //incrementar for - EX.: (++) => i++;
        int     for_incr_val;   //valor incrementar for - EX.: 1
        //DELAY
        int     delayVal;
        
        //generic map
        string counter_bits;
        string counter_condition;
        string counter_down;
        string counter_increment;
        string counter_steps;
        
        //port map
        string counter_clk;
        string counter_clk_en;
        string counter_done;
        string counter_input;
        string counter_output;
        string counter_reset;
        string counter_step;
        string counter_termination;
        /**************************************************************/
        
        
        /**************************************************************/
        //Delay
        //generic map
	string delay_bits;
	string delay_delay;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

	//port map
	string delay_a;
	string delay_a_delayed;
	string delay_clk;
	string delay_reset;
        
        /**************************************************************/
        
        //Constante - Numero dentro da Expressao
        //string  cons_tipo;
        //valor
        
        //Referencias - Referencias de Arrays e Variaveis dentro das expressoes
        //string  ref_var_nome;
        //string  ref_var_index;
        //string  ref_var_tipo;   //A referencia pode ser Vetor ou Variavel
        
        void montaComponenteDelay();
        void montaComponenteVar();
        void montaComponenteLoop();
        void montaComponenteConst();
        void montaComponenteRef();
        void montaComponenteOp();
        void limpaAtributos();
        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */

