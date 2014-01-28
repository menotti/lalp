/* 
 * File:   Scheduling.h
 * Author: demo
 *
 * Created on January 20, 2014, 1:22 PM
 */

#ifndef SCHEDULING_H
#define	SCHEDULING_H

#include "../Design.h"
#include "../Componente/Componente.h"

class Scheduling {
public:
    Scheduling(Design* design);
    Design*     getDesign();
    void        ALAP();
    void        balanceAndSyncrhonize();
    void        detectBackwardEdges();
    virtual     ~Scheduling();
private:
    bool        debug;
    void        ASAP();
    void        copySchedulingTimes();
    int         calculateASAP(Componente* comp);
    Design*     design;
};

#endif	/* SCHEDULING_H */

