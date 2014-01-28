/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef REG_MUX_OP_H
#define	REG_MUX_OP_H

#include "Componente.h"
#include "string"

using namespace std;

class reg_mux_op : public Componente {
public:
    reg_mux_op(void* node = NULL, const string &aux = "");
    virtual     ~reg_mux_op();
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

#endif	/* REG_OP_H */

