/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef NEG_OP_S_H
#define	NEG_OP_S_H
#include "Componente.h"
#include "string"

using namespace std;

class neg_op_s : public Componente {
public:
    neg_op_s(void*node = NULL);
    virtual     ~neg_op_s();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
private:

};

#endif	/* OP_SIMPLE_H */

