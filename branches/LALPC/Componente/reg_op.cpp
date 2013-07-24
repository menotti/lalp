/* 
 * File:   reg_op.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "rose.h"
#include "../header/meuHeader.h"
#include "reg_op.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

reg_op::reg_op(SgNode* node, const string &aux) : Componente(node, aux) {
    this->setNomeCompVHDL("reg_op");    
    this->tipo_comp = CompType::REG;

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
                    string str = FuncoesAux::IntToStr(intVal->get_value());
                    this->valor = ""+str;
                }
            }
        }
    }
    this->createAllPorts();
    this->createAllGeneric();
}

reg_op::~reg_op() {
}

void reg_op::createAllPorts(){
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"0", ""));
    this->addPort(new Port("I0"         ,"in"   ,"std_logic_vector"     ,"0", "IN"));
    this->addPort(new Port("O0"         ,"out"  ,"std_logic_vector"     ,"0", "OUT"));

}

void reg_op::createAllGeneric(){
    this->addGenericMap(new GenericMap("data_width", "integer", "11"));
    this->addGenericMap(new GenericMap("data_width", "integer", "32"));
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


