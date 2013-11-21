/* 
 * File:   block_ram.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef BLOCK_RAM_DUAL_H
#define	BLOCK_RAM_DUAL_H
#include "Componente.h"
#include "string"

using namespace std;

class block_ram_dual : public Componente {
public:
    block_ram_dual(void*node=NULL, const string &aux = "");
    virtual     ~block_ram_dual();
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
    void        setQtdElementos(const string &qtd);
    void        setTipo(const string &tipo);
    void        setValor();
    int         getAddressWidth();
    string      getMemoriaVHDLCab();
    string      getMemoriaVHDLRod();
    void        editQtdElementos(const string &qtd);
private:
    string      tipo_var;
};

#endif	/* OP_SIMPLE_H */

