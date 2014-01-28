/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef SHL_C_OP_S_H
#define	SHL_C_OP_S_H
#include "Componente.h"
#include "string"

using namespace std;

class shl_c_op_s : public Componente {
public:
    shl_c_op_s(void*node = NULL, const string& amount = "1");
    virtual     ~shl_c_op_s();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
private:
    string      amount;
};

#endif	/* OP_SIMPLE_H */

