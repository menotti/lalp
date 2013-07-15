/* 
 * File:   op_simple.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "rose.h"
#include "op_simple.h"
#include "string"

using namespace std;

op_simple::op_simple(SgNode* node) : Componente(node) {
    this->tipo_comp= "OPE";
    this->op_w_in1 = "32";
    this->op_w_in2 = "32";
    this->op_w_out = "32";

    //port map
    this->op_I0    = "";
    this->op_I1    = "";
    this->op_O0    = "";
}

op_simple::~op_simple() {
}

string op_simple::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        w_in1	: integer := 8; \n";
    res += "        w_in2	: integer := 8; \n";
    res += "        w_out	: integer := 16 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        I0          : in	std_logic_vector(w_in1-1 downto 0); \n";
    res += "        I1          : in	std_logic_vector(w_in2-1 downto 0); \n";
    res += "        O0          : out	std_logic_vector(w_out-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string op_simple::geraDOTComp(){
    string res = "";
    res += "\""+this->nome+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|add_op_s:"+this->nome+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

string op_simple::geraVHDLComp(){
    string res = "";

    res += "\\" + this->nome + "\\ : "+this->getNomeCompVHDL();+" \n";
    res += "generic map ( \n";
    res += "        w_in1 => " + this->op_w_in1 + ", \n";
    res += "        w_in2 => " + this->op_w_in2 + ", \n";
    res += "        w_out => " + this->op_w_out + " \n";
    res += " ) \n";
    res += "port map ( \n";
    res += "        I0 => " + this->op_I0 + ", \n";
    res += "        I1 => " + this->op_I1 + ", \n";
    res += "        O0 => " + this->op_O0 + " \n";
    res += "); \n\n";

    return res;
}

void op_simple::finalizaPortasComp(){
    list<Ligacao*>::iterator k;
    //cout<<"*********************************"<<endl;
    //cout<<"*********************************"<<endl;
    //cout<<"LIGACOES"<<endl;
    //cout<<"Qtd: "<< this->ligacoes.size() <<endl;
    string res = "";
    for(k=this->ligacoes.begin(); k != this->ligacoes.end(); k++){
        //cout<< (*k)->getNome() << " :: " << (*k)->getOrigem()->getName()<<":"<< (*k)->getOrigPort() << " -> "<< (*k)->getDestino()->getName()<<":"<< (*k)->getDestPort() <<endl;
        if((*k)->getOrigem()->getName() == this->getName()){
            res = (*k)->getOrigPort();
            //cout<<"RES 1: " << res <<endl;
            //cout<<"NOME : " << (*k)->getNome() <<endl;
        }else {
            res = (*k)->getDestPort();
            //cout<<"RES 2: " << res <<endl;
            //cout<<"NOME : " << (*k)->getNome() <<endl;
        }

        if(res == "I0" && this->op_I0 ==""){
            this->op_I0             = (*k)->getNome();
        }
        if(res == "I1" && this->op_I1 ==""){
            this->op_I1             = (*k)->getNome();
        }
        if(res == "O0" && this->op_O0 ==""){
            this->op_O0             = (*k)->getNome();
        }    
    }
}