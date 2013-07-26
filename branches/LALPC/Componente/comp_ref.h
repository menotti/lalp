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
    comp_ref(SgNode* node, const string &aux = "");
    string      getEstruturaComponenteVHDL();
    string      geraDOTComp();
    string      getNomeCompVHDL();
    string      getGenericMapVal(const string &map, const string &aux);
    void        setGenericMapVal(const string &map, const string &aux, const string &val);
    void        createAllGeneric();
    void        createAllPorts();
    void        montaComponente();
    string      geraCompVHDL();
    string      imprimeLigacoes();
    string      imprimePortas();
    int         getQtdPorts();
    Port*       getPortDataInOut(const string &nome);
    Port*       getPortOther(const string &nome);
    Ligacao*    getLigacaoByName(const string &nome);
    void        removeLigacao(Ligacao* lig);
    void        addLigacao(Ligacao* lig);
    void        addGenericMap(GenericMap* map);
//    list<Port*> getAllPorts();
//    bool        getWE();
//    void        setWE(bool we);
    
    void        setNomeVarIndex(const string &index);
    string      getNomeVarIndex();
    void        setNomeVarRef(const string &nome);
    string      getNomeVarRef();
    void        setTipoVar(const string &tipo);
    string      getTipoVar();
    
    virtual     ~comp_ref();
private:
    string      ref_var_nome;
    string      ref_var_index;
    string      ref_var_tipo;   //A referencia pode ser Vetor ou Variavel

};

#endif	/* COMP_REF_H */

