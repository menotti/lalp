/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef AND_OP_H
#define	AND_OP_H

#include "Componente.h"
#include "string"

using namespace std;

class and_op : public Componente {
public:
    and_op(void* node);
    virtual     ~and_op();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
private:
    string      I0;
    string      I1;
    string      tipo_var;
};

#endif	/* IF_GT_OP_S_H */

