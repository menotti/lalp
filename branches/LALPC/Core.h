/* 
 * File:   ListaComponente.h
 * Author: Lucas Porto
 *
 * Created on 23 de Junho de 2013, 10:07
 */

#ifndef CORE_H
#define	CORE_H
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "variables.h"
#include <list>
#include "Componente/Componente.h"

using namespace std;
using namespace SageInterface;

class Core {  
    public:
        Core(SgProject *project);
        virtual ~Core();
        void identificaVariaveis();
        void FinalizaComponentes();
        void geraGrafo();
        void geraArquivosDotHW();
        void geraHW();
        void imprimeAll();
        void identificaFor();
        void analisaExp(SgNode *nodoAtual, SgNode* pai = NULL, bool debug = false, const string& aux = "");
        void imprimeTodosComponentes();
        list<Componente*> ListaComp;
        list<Ligacao*> ListaLiga;

    private:
        SgProject* project;
        SgGraph* grafo;
        vector<string> split(const string& s, const string& delim);
};

#endif	/* CORE_H */

