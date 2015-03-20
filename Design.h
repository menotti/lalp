/* 
 * File:   Design.h
 * Author: demo
 *
 * Created on January 20, 2014, 10:23 AM
 */

#ifndef DESIGN_H
#define	DESIGN_H

#include "Componente/Componente.h"
#include "Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;
//using namespace boost;

class Design {
public:
    Design(list<Ligacao*> ligacoes, list<Componente*> componentes, int dataWidth = 32);
    list<Ligacao*>      getListaLiga();
    list<Componente*>   getListaComp();
    void                setListaLiga(list<Ligacao*> ligacoes);
    void                setListaComp(list<Componente*> componentes);
    void                addComponent(Componente* comp);
    bool                verificarPrecisaMux(Componente* comp);
    int                 verificarQtdAcessoMem(Componente* comp);
    void                deletaLigacao(const string& name);
    Ligacao*            insereLigacao(Componente* origem, Componente* destino, const string& portaOrigem = "", const string& portaDestino = "");
    void                removeComponente(Componente* origem, Componente* naoRemover = NULL);
    void                setSync(bool sync);
    bool                isSync();
    int                 getMaxSchedulingTime();
    void                setMaxSchedulingTime(int maxSchedulingTime);
    Componente*         insereDelay(Ligacao* lig, int delay = 0, int asap = 0);
    Componente*         getComponent(const string& name);
    bool                verificaTemDelay(Componente* comp, const string& porta);
    void                imprimeAllComp();
    string              getNomeCompRef(const string& name);
    void                zeraValorNumLinha();
    bool                isLastCounter(Componente* destino);
    list<Ligacao*>      ListaLiga; 
    list<Componente*>   ListaComp;
//    ProcessGraph*       graph;
    int                 getDataWidht();
    virtual ~Design();
    void                setTemMemoria(bool val);
    bool                getTemMemoria();
    bool                isIndiceVector(const string& name);
    void                substiuiComRecorente(Componente* origem, Componente* destino);
    void                finalizaComponentesIF();
    void                ligaCompDependencia();
    void                finalizaCounters();
private:
    bool                temMemoria;
    bool                sync;
    Componente*         compForAux;
    int                 maxSchedulingTime;
    int                 DATA_WIDHT;
};

#endif	/* DESIGN_H */
