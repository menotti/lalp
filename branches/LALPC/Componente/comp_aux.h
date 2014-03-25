/* 
 * File:   comp_aux.h
 * Author: demo
 *
 * Created on July 25, 2013, 1:35 PM
 */

#ifndef COMP_AUX_H
#define	COMP_AUX_H
#include "Componente.h"
#include "string"

using namespace std;

class comp_aux : public Componente  {
public:
    comp_aux(void*node = NULL,  const string& aux = NULL, int dataWidth = 32);
    string  getEstruturaComponenteVHDL();
    string  geraDOTComp();
    void    createAllPorts(); //0
    void    createAllGeneric(); //0
    string  geraCompVHDL();
    void    setValAux(const string& aux);
    virtual ~comp_aux();
private:
    string valAux; //val aux que armazena valores necessarios
};

#endif	/* COMP_AUX_H */

