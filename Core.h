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
#include "Ligacao.h"


using namespace std;

class Core {  
    public:
        Core(SgProject* project);
        virtual ~Core();        
        void identificaVariaveis();
        void identificaFor();
        void identificaReturn();
        void analisaExp(SgNode *nodoAtual, SgNode* pai = NULL, const string& aux = "");
        void FinalizaComponentes();
        void grafo();
        void geraArquivosDotHW();
        Componente* insereDelay(Ligacao* lig, int delay = 0, int asap = 0);
        void imprimeAll();
        int  getMaxSchedulingTime();
        void setMaxSchedulingTime(int maxSchedulingTime);
    private:
        bool            debug;
        int             maxSchedulingTime;
        list<Componente*>ListaComp;
        list<Ligacao*>  ListaLiga;
        string          compNameReturn;
        bool            sync;
        void            copySchedulingTimes();
        void            updateCounter(SgNode* node, counter* comp);
        void            updateRegister(SgNode* node, reg_op* comp);
        void            updateBlockRam(SgNode* node, block_ram* comp);
        void            updateCompRef(SgNode* node, comp_ref* comp);
        void            detectBackwardEdges();
        void            ALAP();
        void            ASAP();
        void            balanceAndSyncrhonize();
        int             calculateASAP(Componente* comp);
        void            addComponent(Componente* comp);
        void            setSync(bool sync);
        void            setClkReset();
        bool            isSync();
        Componente*     getComponent(const string& name);
        SgProject*      project;
};

#endif	/* CORE_H */

