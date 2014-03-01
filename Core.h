/* 
 * File:   ListaComponente.h
 * Author: Lucas Porto
 *
 * Created on 23 de Junho de 2013, 10:07
 */

#ifndef CORE_H
#define	CORE_H
//#include "rose.h"   //metodo antigo pra dar certo
#include "header/meuHeader.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>
#include "Componente/Componente.h"
#include "Componente/counter.h"
#include "Componente/reg_op.h"
#include "Componente/block_ram.h"
#include "Componente/comp_ref.h"
#include "ArquivosDotHW.h"
#include "ProcessGraph.h"
#include "Ligacao.h"
#include "Design.h"


using namespace std;

class Core {  
    public:
        Core(SgProject* project, list<SgNode*> lista);
        virtual ~Core();        
        void identificaVariaveis();
        void identificaFor();
        void identificaReturn();
        Componente* analisaExp(SgNode *nodoAtual, SgNode* pai = NULL, const string& aux = "", const string& linhaParal = "");
        void FinalizaComponentes();
        void geraArquivosDotHW();
        Componente* insereReg(Ligacao* lig);
        void imprimeAll();
        int  getMaxSchedulingTime();
        void setMaxSchedulingTime(int maxSchedulingTime);
        void* GetStrPointerAdd(SgNode* nodo);
    private:
        bool            existeSgNode(SgNode* node);
        Componente*     getCompBySgNode(SgNode* node);
        bool            debug;
        bool            gerarDual;
        bool            ramMultPort;
        bool            isParallel;
        int             maxSchedulingTime;
        list<Componente*>ListaComp;
        list<Ligacao*>  ListaLiga;
        list<SgNode*>   ListaForParall;
        Design*         design;
        string          compNameReturn;
        void            copySchedulingTimes();
        void            existeVarRef(const string& name);
        void            updateCounter(SgNode* node, counter* comp);
        void            updateRegister(SgNode* node, reg_op* comp);
        void            updateBlockRam(SgNode* node, block_ram* comp);
        void            updateCompRef(SgNode* node, comp_ref* comp);
        void            preIdentificacaoCompParalelizados();
        bool            isIndiceVector(const string& name);
        void            analiseMemoriaDualPort();
        void            analiseDividirMemoria();
        void            substiuiComRecorente(Componente* origem, Componente* destino);
        void            retirarCompDelayRedundante();
        void            setClkReset();    
        void            identificaPragmas();
        void            ligaCompDep();
        void            corrigeRegWe();
        void            ligaRegNoWE();
        
        Componente*     compForAux;
        SgProject*      project;
        ArquivosDotHW*  dot;
        ProcessGraph*   graph;
};

#endif	/* CORE_H */

