/* 
 * File:   reg_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "rose.h"
#include "reg_op.h"
#include "string"


using namespace std;

reg_op::reg_op(SgNode* node, const string &aux) : Componente(node, aux) {
    this->setNomeCompVHDL("reg_op");    
    this->w_in  = "";
    this->initial;
    
    //port
    this->clk;	 
    this->reset;	 
    this->we;
    this->I0;
    this->O0; 
    
    
    SgInitializedName* cur_var          = isSgInitializedName(this->node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(cur_var->get_parent());
    
    if (cur_var != NULL){
        varID var(isSgInitializedName(this->node));
        
        //Pegar nome
        this->nome = cur_var->get_name().getString();
        
        //Verificar se e vetor ou nao - isso vai empactar para definir hardware
        //registrador (variavel) ou memoria (vetor)
        string tipo="";
        
        this->tipo_comp     = "REG";

        //Pegar tipo da variavel
        tipo = cur_var->get_type()->get_mangled().str();
        

        //TODO - Ver como que vai ficar o esquema de tipo da variavel ou vetor
        //Identificar o tipo da variavel/vetor
        //if((tipo.compare("i")) == 1){
        if(tipo=="i"){
            this->tipo_var = "INT";
        }
        //if((tipo.compare("c")) == 1){
        if(tipo=="c"){
            this->tipo_var = "CHA";
        }
        //if((tipo.compare("f")) == 1){
        if(tipo=="f"){
            this->tipo_var = "FLO";
        }
        //if((tipo.compare("d")) == 1){
        if(tipo=="d"){
            this->tipo_var = "DOU";
        }
        
        
        /*
         * abaixo verifica a subtree apartir do nodo isSgInitializedName
         * sendo assim dentro desta sub-arvore temos todas as informacoes da
         * variavel/vetor
         */
        Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgAssignInitializer);
        if(var2.size() > 0){
            this->setEInicializado(true);
                                    
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    string str = this->ConverteIntToStr(intVal->get_value());
                    this->valor = ""+str;
                }
            }
        }
    }
}

reg_op::~reg_op() {
}

string reg_op::getEstruturaComponenteVHDL(){
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

string reg_op::geraDOTComp(){
    string res = "";
    res += "\""+this->ref_var_nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0[32]|<clk>clk|<reset>reset|<we>we}|reg_op:"+this->ref_var_nome+"|{<O0>O0[32]}}\"]; \n";
    return res;
}

string reg_op::geraVHDLComp(){
    string res = "";

    return res;
}

void reg_op::finalizaPortasComp(){
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

//        if(res == "address" && this->ref_address ==""){
//                    this->ref_address   = (*k)->getNome();
//        }
//        if(res == "clk" && this->ref_clk ==""){
//            this->ref_clk       = (*k)->getNome();
//        }
//        if(res == "data_in" && this->ref_data_in ==""){
//            this->ref_data_in   = (*k)->getNome();
//        }
//        if(res == "data_out" && this->ref_data_out ==""){
//            this->ref_data_out  = (*k)->getNome();
//        }
//        if(res == "we" && this->ref_we ==""){
//            this->ref_we        = (*k)->getNome();
//        }  
    }
}