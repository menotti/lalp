/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef OP_SIMPLE_H
#define	OP_SIMPLE_H
#include "Componente.h"
#include "string"

using namespace std;

class op_simple : public Componente {
public:
    op_simple(void*node = NULL, int dataWidth = 32);
    virtual     ~op_simple();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        montaComponente();
    string      op_tipo;        //Definir tipo de opercacao - soma, sub, mult, div, etc.
private:
    
};

#endif	/* OP_SIMPLE_H */

