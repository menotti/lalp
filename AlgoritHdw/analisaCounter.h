/* 
 * File:   analisaCounter.h
 * Author: demo
 *
 * Created on January 30, 2014, 5:52 PM
 */

#ifndef ANALISACOUNTER_H
#define	ANALISACOUNTER_H
#include "../Design.h"
#include "../Componente/Componente.h"
#include "../Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;

class analisaCounter {
public:
    analisaCounter(Design* design);

    virtual ~analisaCounter();
private:
    void        ligaContReg();
    Design*             design;
    bool                debug;
};

#endif	/* ANALISACOUNTER_H */

