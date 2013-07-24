/* 
 * File:   counter.h
 * Author: demo
 *
 * Created on July 12, 2013, 2:35 PM
 */

#ifndef COUNTER_H
#define	COUNTER_H
#include "Componente.h"
#include "string"

using namespace std;

class counter : public Componente  {
public:
    counter(SgNode* node);
    virtual ~counter();
    string      geraVHDLComp();
    string      geraDOTComp();
    string      getEstruturaComponenteVHDL();
    void        createAllGeneric();
    void        createAllPorts();
private:
    int     for_ctr_val_ini;//Valor inicial da variavel de controle
    string  for_cond_var;   //variavel de condicao - EX.: (i) => i < 10
    int     for_cond_val;   //valor de condicao - EX.: (10) => i < 10
    string  for_cond_op;    //operacao de controle do for - EX.: (<) => i < 10
    string  for_incr_var;   //variavel incrementar for - EX.: (i) => i++;        //this->op_in_add1;     //Define entrada 1 da operacao ADD
    string  for_incr_op;    //incrementar for - EX.: (++) => i++;
    int     for_incr_val;   //valor incrementar for - EX.: 1


    //generic map
    string counter_bits;
    string counter_condition;
    string counter_down;
    string counter_increment;
    string counter_steps;

    //port map
    string counter_clk;
    string counter_clk_en;
    string counter_done;
    string counter_input;
    string counter_output;
    string counter_reset;
    string counter_step;
    string counter_termination;
};

#endif	/* COUNTER_H */

