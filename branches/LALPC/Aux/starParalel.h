/* 
 * File:   starParalel.h
 * Author: demo
 *
 * Created on October 11, 2013, 8:58 AM
 */

#ifndef STARPARALEL_H
#define	STARPARALEL_H
#include "../header/meuHeader.h"
//#include <list>;
using namespace std;
//using namespace SageInterface;
//using namespace AutoParallelization;
using std::stringstream;
//using boost::lexical_cast;
class starParalel {
public:
    starParalel(SgProject* project, list<SgNode*> listFor);
    virtual ~starParalel();
private:
    void          removeRedundance(SgProject* project);
    void          verifyLiveDeadVar(SgProject* project);
    void          normalizeLoop(SgProject* project);
    void          tryParallelLoop(SgProject* project,list<SgNode*> listFor);
    SgProject*    project;
    list<SgNode*> listFor;
};

#endif	/* STARPARALEL_H */

