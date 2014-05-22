/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef SUB_REG_OP_S_H
#define	SUB_REG_OP_S_H

#include "Componente.h"
#include "string"

using namespace std;

class sub_reg_op_s : public Componente {
public:
    sub_reg_op_s(void*node, const string &aux = "", int dataWidth = 32);
    virtual     ~sub_reg_op_s();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
    void        setValor(const string &aux);
    void        setTipo(const string &aux);
    string      getTipo();
private:
    string      tipo_var;
};

#endif	/* ADD_REG_OP_S */

