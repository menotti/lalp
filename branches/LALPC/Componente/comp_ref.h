/* 
 * File:   comp_ref.h
 * Author: demo
 *
 * Created on July 15, 2013, 10:18 AM
 */

#ifndef COMP_REF_H
#define	COMP_REF_H
#include "Componente.h"
#include "string"
using namespace std; 

class comp_ref : public Componente{
public:
    comp_ref(void*node = NULL, const string &aux = "", int dataWidth = 32);
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    void        createAllGeneric();
    void        createAllPorts();
    void        montaComponente();
//    void        setDelayValComp(const string &delayVal);
//    string      getDelayValComp();

    void        addGenericMap(GenericMap* map);    
    void        setNomeVarIndex(const string &index);
    string      getNomeVarIndex();
    void        setTipoVar(const string &tipo);
    string      getTipoVar();
    
    virtual     ~comp_ref();
private:
    string      ref_var_nome;
    string      ref_var_index;
    string      ref_var_tipo;   //A referencia pode ser Vetor ou Variavel

};

#endif	/* COMP_REF_H */
