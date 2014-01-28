/* 
 * File:   op_simple.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef MUX_M_OP_H
#define	MUX_M_OP_H
#include "Componente.h"
#include "string"

using namespace std;

class mux_m_op : public Componente {
public:
    mux_m_op(void* node = NULL, const string &nOps = "32", const string &sSels = "31");
    virtual     ~mux_m_op();
    void        setNOps(const string &val);
    void        setNSels(const string &bits);
    string      getNOps();
    void        createAllGeneric();
    string      getNSels();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        montaComponente();
private:
    string      nOps;
    string      nSels;

};

#endif	/* OP_SIMPLE_H */

