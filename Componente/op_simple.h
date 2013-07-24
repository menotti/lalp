/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef OP_SIMPLE_H
#define	OP_SIMPLE_H
#include "Componente.h"
#include "string"

using namespace std;

class op_simple : public Componente {
public:
    op_simple(SgNode* node);
    virtual     ~op_simple();
    void        createAllGeneric();
    string      getEstruturaComponenteVHDL();
    string      geraVHDLComp();
    string      geraDOTComp();
    void        createAllPorts();
    void        montaComponente();
private:
    /**************************************************************/
    //generic map
    string op_w_in1;
    string op_w_in2;
    string op_w_out;

    //port map
    string op_I0;
    string op_I1;
    string op_O0;        
    /**************************************************************/
};

#endif	/* OP_SIMPLE_H */

