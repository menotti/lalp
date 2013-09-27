/* 
 * File:   block_ram.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef BLOCK_RAM_H
#define	BLOCK_RAM_H
#include "Componente.h"
#include "string"

using namespace std;

class block_ram : public Componente {
public:
    block_ram(SgNode* node, const string &aux = "");
    virtual     ~block_ram();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
    void        setQtdElementos(const string &qtd);
    void        setTipo(const string &tipo);
    void        setValor(const string &valor);
    int         getAddressWidth();
    
private:
    string      qtd_ele_vet;
    string      tipo_var;
    int         addressWidth;
    
};

#endif	/* OP_SIMPLE_H */

