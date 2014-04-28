/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef NOT_OP_H
#define	NOT_OP_H
#include "Componente.h"
#include "string"

using namespace std;

class not_op : public Componente {
public:
    not_op(void*node = NULL, int dataWidth = 32);
    virtual     ~not_op();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
private:
 
};

#endif	/* OP_SIMPLE_H */

