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
#include "Ligacao.h"


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
        void grafo();
        void geraArquivosDotHW();
        Componente* insereDelay(Ligacao* lig, int delay = 0, int asap = 0);
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
        bool            isParallel;
        int             maxSchedulingTime;
        list<Componente*>ListaComp;
        list<Ligacao*>  ListaLiga;
        list<SgNode*>   ListaForParall;
        string          compNameReturn;
        string          getNomeCompRef(const string& name);
        bool            sync;
        void            copySchedulingTimes();
        void            existeVarRef(const string& name);
        void            deletaLigacao(const string& name);
        void            updateCounter(SgNode* node, counter* comp);
        void            updateRegister(SgNode* node, reg_op* comp);
        void            updateBlockRam(SgNode* node, block_ram* comp);
        void            updateCompRef(SgNode* node, comp_ref* comp);
        void            detectBackwardEdges();
        void            preIdentificacaoCompParalelizados();
        bool            isIndiceVector(const string& name);
        void            ALAP();
        void            ASAP();
        void            analiseMemoriaDualPort();
        void            analiseDividirMemoria();
        void            balanceAndSyncrhonize();
        int             calculateASAP(Componente* comp);
        void            addComponent(Componente* comp);
        void            substiuiComRecorente(Componente* origem, Componente* destino);
        void            removeComponente(Componente* origem, Componente* naoRemover = NULL);
        void            retirarCompDelayRedundante();
        bool            insereLigacao(Componente* origem, Componente* destino, const string& portaOrigem = "", const string& portaDestino = "");
        void            setSync(bool sync);
        void            setClkReset();
        bool            isSync();
        Componente*     getComponent(const string& name);
        SgProject*      project;
        ArquivosDotHW*  dot;
};

#endif	/* CORE_H */

