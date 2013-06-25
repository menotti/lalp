/* 
 * File:   ListaComponente.h
 * Author: Lucas Porto
 *
 * Created on 23 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "variables.h"
#include <list>
#include "Componente.h"

#ifndef LISTACOMPONENTE_H
#define	LISTACOMPONENTE_H

using namespace std;
using namespace SageInterface;

class ListaComponente {  
    public:
        ListaComponente(SgProject *project);
        virtual ~ListaComponente();
        void identificaVariaveis();
        void identificaFor();
        void analisaExp(SgNode *nodoAtual, SgNode* pai, bool debug);
        void imprimeTodosComponentes();
        list<Componente> ListaComp;

    private:
        SgProject* project;
        vector<string> split(const string& s, const string& delim);
};

#endif	/* COMPONENTE_H */
