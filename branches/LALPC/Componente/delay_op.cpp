/* 
 * File:   delay_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "rose.h"
#include "delay_op.h"
#include "string"

using namespace std;

delay_op::delay_op(SgNode* node) : Componente(node) {
    this->setNomeCompVHDL("delay_op");
    this->tipo_comp         = "DLY";
    this->delay_bits        = "";
    this->delay_delay       = "0";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    this->delay_a           = "";
    this->delay_a_delayed   = "";
    this->delay_clk         = "\\clk\\";
    this->delay_reset       = "\\reset\\";
}

delay_op::~delay_op() {
}

string delay_op::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component delay_op \n";
    res += "generic ( \n";
    res += "        bits        : integer := 8; \n";
    res += "        delay       : integer := 1 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        a		: in	std_logic_vector(bits-1 downto 0); \n";
    res += "        clk		: in	std_logic; \n";
    res += "        reset	: in	std_logic; \n";
    res += "        a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0') \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string delay_op::geraDOTComp(){
    string res = "";
    res += "\""+this->nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<a>a["+this->delay_bits+"]|<clk>clk|<reset>reset}|delay_op:"+this->nome+"\\ndelay=0|{<a_delayed>a_delayed["+this->delay_bits+"]}}\"]; \n";
    return res;
}

string delay_op::geraVHDLComp(){
    string res = "";
    res += "\\" + this->nome + "\\: delay_op \n";
    res += "generic map ( \n";
    res += "	bits => " + this->delay_bits + ", \n";
    res += "	delay => " + this->delay_delay + " \n";
    res += ") \n";
    res += "port map ( \n";
    res += "	a => " + this->delay_a + ", \n";
    res += "	a_delayed => " + this->delay_a_delayed + ", \n";
    res += "	clk => " + this->delay_clk + ", \n";
    res += "	reset => " + this->delay_reset + " \n";
    res += "); \n\n";
    return res;
}

void delay_op::finalizaPortasComp(){
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

        if(res == "bits" && this->delay_bits ==""){
                this->delay_bits        = (*k)->getNome();
        }
        if(res == "delay" && this->delay_delay ==""){
            this->delay_delay       = (*k)->getNome();
        }
        if(res == "a" && this->delay_a ==""){
                this->delay_a       = (*k)->getNome();
        }
        if(res == "a_delayed" && this->delay_a_delayed ==""){
                this->delay_a_delayed= (*k)->getNome();
        }
        if(res == "clk" && this->delay_clk ==""){
                this->delay_clk     = (*k)->getNome();
        }
        if(res == "reset" && this->delay_reset ==""){
                this->delay_reset   = (*k)->getNome();
        } 
    }
}

void delay_op::setDelayBits(const string &bits){
    this->delay_bits = bits;
}

string delay_op::getDelayBits(){
    return this->delay_bits;
}

void delay_op::setDelayVal(const string &val){
    this->delay_delay = val;
}

string delay_op::getDelayVal(){
    return this->delay_delay;
}