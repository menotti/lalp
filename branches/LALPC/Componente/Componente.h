#ifndef COMPONENTE_H
#define	COMPONENTE_H
/* 
 * File:   Componente.h
 * Author: Lucas Porto
 *
 * Created on 14 de Junho de 2013, 10:07
 */

#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>
#include "../Ligacao.h"
#include "../CompType.h"
#include "Port.h"
#include "GenericMap.h"

using namespace std;

class Componente {  
    public:
                Componente(SgNode* node = NULL, const string &aux = "");
        //CompType* tipo_comp;
        CompType::TIPO_COMP tipo_comp;
        void            setPai(SgNode* nodo = NULL);
        int             getNumLinha();
        void            setNumLinha(int num = 0);
        Componente*     getComponenteRef();
        virtual void    setDelayValComp(const string &delayVal);
        void            setNumIdComp(const string &id);
        string          getNumIdComp();
        virtual string  getDelayValComp();
        virtual string  getGenericMapVal(const string &map, const string &aux);
        virtual void    setGenericMapVal(const string &map, const string &aux, const string &val);
        void            setComponenteRef(Componente* comp);
        SgNode*         getPai();
        bool            writeEnable;
        void            setNomeCompVHDL(const string &nome);
        virtual string  getNomeCompVHDL();
        virtual bool    getWE();
        virtual void    setWE(bool we);
        void            setEInicializado(bool val);
        bool            getEInicializado();
        string          getDelayVal();
        void            setDelayVal(const string &val);
        string          getDelayBits();
        void            setDelayBits(const string &bits);
        void            setName(const string &nome);
        virtual string  imprimePortas();       
        virtual string  imprimeLigacoes();
        virtual string  getEstruturaComponenteVHDL() = 0; //0
        string          getName();
        virtual string  geraDOTComp() = 0; //0
        virtual         ~Componente();
        void            addPort(Port* porta);
        virtual void    createAllPorts() = 0; //0
        virtual void    createAllGeneric() = 0; //0
        virtual string  geraCompVHDL();
        
        virtual int     getQtdPorts();
        int             getQtdLig();
        virtual Port*   getPortDataInOut(const string &nome);
        virtual Port*   getPortOther(const string &nome);
        virtual Ligacao*getLigacaoByName(const string &nome);
        virtual void    removeLigacao(Ligacao* lig);
        virtual void    addLigacao(Ligacao* lig);
        virtual void    addGenericMap(GenericMap* map);
//        virtual list<Port*> getAllPorts();
        SgNode*         node;
        string          for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
//        string          op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        string          valor;          //Valor da Variavel ou Todos os elementos do Vetor
//        string          ref_var_nome;
//        string          ref_var_index;
//        string          ref_var_tipo;   //A referencia pode ser Vetor ou Variavel
        string          cons_tipo;
        string          delayVal;
        string          nome;
        list<Ligacao*>  ligacoes;
    private:
        int             numLinha;
        string          idComp;
        string          delayValComp;
        Componente*     refComp;
        list<Port*>     portas;
        list<GenericMap*> genMap;
        string          nome_comp_vhdl;
        SgNode*         nodoPai;
        bool            eInicializado;
        string          tipo_var;       //Int - Str - Flo              
        bool            eVetor;
        int             qtd_ele_vet;   
};

#endif	/* COMPONENTE_H */
