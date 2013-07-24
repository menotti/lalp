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
    string      geraVHDLComp();
    string      geraDOTComp();
    string      getNomeCompVHDL();
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
    bool        getWE();
    void        setWE(bool we);
    virtual     ~comp_ref();
private:
    
    /**************************************************************/
    //OPERACAO
    //generic map
    string      ref_address_width;
    string      ref_data_width;

    //port map
    string      ref_address;
    string      ref_clk;
    string      ref_data_in;
    string      ref_data_out;
    string      ref_we;        
    /**************************************************************/
};

#endif	/* COMP_REF_H */

