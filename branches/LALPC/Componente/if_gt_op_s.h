/* 
 * File:   reg_op.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef IF_GT_OP_S_H
#define	IF_GT_OP_S_H

#include "Componente.h"
#include "string"

using namespace std;

class if_gt_op_s : public Componente {
public:
    if_gt_op_s(SgNode* node);
    virtual     ~if_gt_op_s();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
    void        setValor(const string &aux);
    void        setTipo(const string &aux);
    void        setCondEsq(const string &aux);
    void        setCondDir(const string &aux);
    string      getCondEsq();
    string      getCondDir();
    string      getTipo();
private:
    string      I0;
    string      I1;
    string      tipo_var;
};

#endif	/* IF_GT_OP_S_H */

