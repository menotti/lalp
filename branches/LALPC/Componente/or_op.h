/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef OR_OP_H
#define	OR_OP_H

#include "Componente.h"
#include "string"

using namespace std;

class or_op : public Componente {
public:
    or_op(void* node);
    virtual     ~or_op();
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

