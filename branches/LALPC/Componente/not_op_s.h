/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef NOT_OP_S_H
#define	NOT_OP_S_H
#include "Componente.h"
#include "string"

using namespace std;

class not_op_s : public Componente {
public:
    not_op_s(void*node = NULL);
    virtual     ~not_op_s();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
private:

};

#endif	/* OP_SIMPLE_H */

