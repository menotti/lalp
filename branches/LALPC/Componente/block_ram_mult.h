/* 
 * File:   block_ram.h
 * Author: demo
 *
 * Created on July 12, 2013, 10:02 AM
 */

#ifndef BLOCK_RAM_MULT_H
#define	BLOCK_RAM_MULT_H
#include "Componente.h"
#include "string"

using namespace std;

class block_ram_mult : public Componente {
public:
    block_ram_mult(void*node=NULL, const string &aux = "", int qtdElementos = 0, int dataWidth = 32);
    virtual     ~block_ram_mult();
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
    int         qtdElementos;
    int         qtdAcessos;
    string      tipo_var;
};

#endif	/* OP_SIMPLE_H */

