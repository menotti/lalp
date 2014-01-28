/* 
 * File:   analisaMem.h
 * Author: demo
 *
 * Created on January 17, 2014, 9:28 AM
 */

#ifndef ANALISAIF_H
#define	ANALISAIF_H
#include "../Design.h"
#include "../Componente/Componente.h"
#include "../Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;

class analisaIf {
public:
    analisaIf(Design* design);
    virtual ~analisaIf();
    void        buscaIfs();
    void        ligaExpInternoIf(Componente* comp);
    void        criaMux(Componente* comp);
    Design*     getDesign();
    
private:
    Componente*         getCompAntesIf(Componente* compIf, const string& linhaParal);
    Design*             design;
    bool                debug;
};

#endif	/* ANALISAMEM_H */

