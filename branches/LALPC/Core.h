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
#include "Ligacao.h"

using namespace std;

class Core {  
    public:
        Core(SgProject* project);
        virtual ~Core();        
        void identificaVariaveis();
        void identificaFor();
        void identificaReturn();
        void analisaExp(SgNode *nodoAtual, SgNode* pai = NULL, bool debug = false, const string& aux = "");
        void FinalizaComponentes();
        void geraArquivosDotHW();
//        void geraHW();
        void imprimeAll();

        list<Componente*> ListaComp;
        list<Ligacao*> ListaLiga;

    private:
        SgProject* project;
};

#endif	/* CORE_H */

