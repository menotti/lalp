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
                Componente(void* node = NULL, const string &aux = "");
        //CompType* tipo_SgNode* node = NULcomp;
        CompType::TIPO_COMP tipo_comp;
        void            setPai(void* nodo = NULL);
        int             getNumLinha();
        void            setNumLinha(int num = 0);
        Componente*     getComponenteRef();     
        void            setNumIdComp(const string &id);
        void            setNumParalelLina(const string &id);
        string          getNumParalelLina();
        string          getNumIdComp();
        virtual string  getGenericMapVal(const string &map, const string &aux);
        virtual void    setGenericMapVal(const string &map, const string &aux, const string &val);
        void            setComponenteRef(Componente* comp);
        bool            isSuccessorOf(Componente* comp);
        void*           getPai();
        bool            writeEnable;
        void            setNomeCompVHDL(const string &nome);
        string          getNomeCompVHDL();
        virtual bool    getWE();
        virtual void    setWE(bool we);
        void            setEInicializado(bool val);
        bool            getEInicializado();
        
        virtual void    setDelayValComp(const string &delayVal); //Referenciado a necessidade de delay do componente
        virtual string  getDelayValComp();
        void            setDelayVal(const string &val); //Referente ao VALOR dentro do DELAY (Generic Map)
        string          getDelayVal();
        virtual string  getMemoriaVHDLCab();
        virtual string  getMemoriaVHDLRod();
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
        virtual Ligacao*getLigacaoOutDefault();
        virtual Ligacao*getLigacaoInDefault();
        virtual void    removeLigacao(Ligacao* lig);
        virtual void    addLigacao(Ligacao* lig);
        virtual void    addGenericMap(GenericMap* map);
        int             getAddressWidth();
        bool            temPorta(const string &nome);
        void            setEIndice(bool val);
        bool            getEIndice();
        void            setNomeVarRef(const string &nome);
        string          getNomeVarRef();
//        virtual list<Port*> getAllPorts();
        void*          node;
        string          for_ctr_var;    //Variavel de controle - EX.: (i) => for (i = 0, ....)
//        string          op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
        string          valor;          //Valor da Variavel ou Todos os elementos do Vetor
        list<int>       valores;
        int             qtd_elem_vet;
//        string          ref_var_nome;
//        string          ref_var_index;
//        string          ref_var_tipo;   //A referencia pode ser Vetor ou Variavel
        string          cons_tipo;
        string          delayVal;
        string          nome;
        list<Ligacao*>  ligacoes;
        int             addressWidth;
        int             dataWidth;
        int             getWidth();
        int             getALAP();
        int             getASAP();
        void            setALAP(int val);
        void            setASAP(int val);
        list<GenericMap*> getGenericMap();
        list<Port*>     getPorts();
        void            updateCompRef();
        int             getSuccessorsLine();
        void            copySchedulingTimes();
        CompType::TIPO_COMP  getTipoCompRef();
        bool            getSync();
        void            setSync(bool val);
        void            printAllPortsAllLig();
        void            copyAllPortsAndGM();
        
    private:
        
        string          ref_var_nome;
        bool            isIndice;
        int             alap;
        int             asap;
        bool            sync;
        int             numLinha;
        string          numParallelLine;
        string          idComp;
        string          delayValComp; //Delay relacionado necessário na execucao em Hadware
        Componente*     refComp;
        list<Port*>     portas;
        list<GenericMap*> genMap;
        string          nome_comp_vhdl;
        void*          nodoPai;
        bool            eInicializado;
        string          tipo_var;       //Int - Str - Flo              
        bool            eVetor;
        int             qtd_ele_vet;   
};

#endif	/* COMPONENTE_H */

