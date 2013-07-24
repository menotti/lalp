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
    string      geraVHDLComp();
    string      geraDOTComp();
    void        createAllPorts();
    void        createAllGeneric();
    void        montaComponente();
private:
    int         qtd_ele_vet;
    string      tipo_var;
    /**************************************************************/
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

#endif	/* OP_SIMPLE_H */

