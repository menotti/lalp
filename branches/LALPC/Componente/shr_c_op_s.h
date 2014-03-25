/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef SHR_C_OP_S_H
#define	SHR_C_OP_S_H
#include "Componente.h"
#include "string"

using namespace std;

class shr_c_op_s : public Componente {
public:
    shr_c_op_s(void*node = NULL, const string& amount = "1", int dataWidht = 32);
    virtual     ~shr_c_op_s();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
private:
    string      amount;
};

#endif	/* OP_SIMPLE_H */

