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
    string      geraDOTComp();
    string      getEstruturaComponenteVHDL();
    void        createAllGeneric();
    void        createAllPorts();
    
    void        setGenericMapBits(const string &bits);
    string      getGenericMapBits();
    void        setGenericMapCondition(const string &bits);
    string      getGenericMapCondition();
    void        setGenericMapDown(const string &bits);
    string      getGenericMapDown();
    void        setGenericMapSteps(const string &bits);
    string      getGenericMapSteps();
    void        setGenericMapIncrements(const string &bits);
    string      getGenericMapIncrements();

    //Define a variavel de controle do contador
    void        setVarControlCont(const string &bits);
    string      getVarControlCont();
    void        setVarControlValIni(const string &bits);
    string      getVarControlValIni();
    void        setVarControlValStop(const string &bits);
    string      getVarControlValStop();
private:
    string  for_cond_var;  //variavel de condicao - EX.: (i) => i < 10
    string  for_ctr_val_ini;//Valor inicial da variavel de controle
    string  for_cond_val;   //valor de condicao - EX.: (10) => i < 10
    
    string  for_cond_op;    //operacao de controle do for - EX.: (<) => i < 10
    string  for_incr_var;   //variavel incrementar for - EX.: (i) => i++;        //this->op_in_add1;     //Define entrada 1 da operacao ADD
    string  for_incr_op;    //incrementar for - EX.: (++) => i++;
    int     for_incr_val;   //valor incrementar for - EX.: 1
};

#endif	/* COUNTER_H */

