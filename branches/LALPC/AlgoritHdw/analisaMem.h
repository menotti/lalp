/* 
 * File:   analisaMem.h
 * Author: demo
 *
 * Created on January 17, 2014, 9:28 AM
 */

#ifndef ANALISAMEM_H
#define	ANALISAMEM_H
#include "../Design.h"
#include "../Componente/Componente.h"
#include "../Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;

class analisaMem {
public:
    analisaMem(Design* design);
    virtual ~analisaMem();
    
    void        insereMux();
    void        insereRamMultPort();
    Design*     getDesign();
    void        insereStepMux();
    int         getNumLinhaMaxMem(Componente* comp);
    
private:
    Design*             design;
    bool                debug;
};

#endif	/* ANALISAMEM_H */

