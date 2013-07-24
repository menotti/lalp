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
    delay_op(SgNode* node = NULL);
    virtual     ~delay_op();
    void        setDelayVal(const string &val);
    void        setDelayBits(const string &bits);
    string      getDelayVal();
    void        createAllGeneric();
    string      getDelayBits();
    string      getEstruturaComponenteVHDL();
    string      geraVHDLComp();
    string      geraDOTComp();
    void        createAllPorts();
    void        montaComponente();
private:
    //generic map
    string delay_bits;
    string delay_delay;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

    //port map
    string delay_a;
    string delay_a_delayed;
    string delay_clk;
    string delay_reset;
};

#endif	/* OP_SIMPLE_H */

