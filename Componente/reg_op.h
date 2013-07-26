/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef REG_OP_H
#define	REG_OP_H

#include "Componente.h"
#include "string"

using namespace std;

class reg_op : public Componente {
public:
    reg_op(SgNode* node, const string &aux = "");
    virtual     ~reg_op();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
    void        setValor(const string &aux);
    void        setTipo(const string &aux);
private:
    string      tipo_var;
};

#endif	/* REG_OP_H */

