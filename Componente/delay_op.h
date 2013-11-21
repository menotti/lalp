/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef DELAY_OP_H
#define	DELAY_OP_H
#include "Componente.h"
#include "string"

using namespace std;

class delay_op : public Componente {
public:
    delay_op(void*node = NULL);
    virtual     ~delay_op();
    void        setDelayVal(const string &val);
    void        setDelayBits(const string &bits);
    string      getDelayVal();
    void        createAllGeneric();
    string      getDelayBits();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        montaComponente();
private:

};

#endif	/* OP_SIMPLE_H */

