/* 
 * File:   geraDOT.h
 * Author: demo
 *
 * Created on July 4, 2013, 5:13 PM
 */

#ifndef ARQUIVODOTHW_H
#define	ARQUIVODOTHW_H

#include <string>
#include <stdio.h>
#include <list>
#include "Componente/Componente.h"
#include <sstream>
#include <stdlib.h>

using namespace std;
class ArquivosDotHW {
public:
    ArquivosDotHW(list<Componente*> listaComp, list<Ligacao*> listaLiga);
    CompType*           tipo_comp;
    void                imprimeVHDL();
    void                imprimeHWDOT();    
    virtual             ~ArquivosDotHW();
private:
    list<Componente*>   ListaComp;
    list<Ligacao*>      ListaLiga;
    vector<string>      ListaAux;
    void                GeraMemoryVHDL();
    vector<string>      split(const string& s, const string& delim);
    string              LPad(const string &val, int size);
    string              ConvertDecToBin(const string &val);
    bool                ExisteNaListaAux(const string &val);
};

#endif	/* GERADOT_H */

