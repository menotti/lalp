/* 
 * File:   Scheduling.h
 * Author: demo
 *
 * Created on January 20, 2014, 1:22 PM
 */

#ifndef SCHEDULING_H
#define	SCHEDULING_H

#include "../Design.h"
#include <map>
#include "../Componente/Componente.h"
using namespace std;
class Scheduling {
public:
    Scheduling(Design* design);
    Design*     getDesign();
    void        negativeBalance(Design* desig);
    void        ALAP();
    void        balanceAndSyncrhonize();
    void        detectBackwardEdges();
    virtual     ~Scheduling();
private:
    bool        debug;
    bool        existeComponente(Componente* comp);
    void        ASAP();
    void        copySchedulingTimes();
    int         calculateASAP(Componente* comp);
    Design*     design;
    map<int, Componente*> componentes;
};

#endif	/* SCHEDULING_H */

