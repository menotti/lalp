/* 
 * File:   counter.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 2:35 PM
 */
#include "rose.h"
#include "counter.h"
#include "string"

using namespace std;

counter::counter(SgNode* node) : Componente(node) {
    SgForStatement* cur_for = isSgForStatement(this->node);
    this->setNomeCompVHDL("counter");
    this->tipo_comp = "CTD";     
    if (cur_for != NULL){
        
        //Info necessarias para geracao do componente VHDL
        this->counter_bits      = "16";
        this->counter_condition = "0";
        this->counter_down      = "1";
        this->counter_increment = "1";
        this->counter_steps     = "1";
        
        //port map
        this->counter_clk       = "\\clk\\";
        this->counter_clk_en    = "";
        this->counter_done      = "";
        this->counter_input     = "";
        this->counter_output    = "";
        this->counter_reset     = "\\reset\\";
        this->counter_step      = "";
        this->counter_termination= "";
        
        
        ROSE_ASSERT(cur_for);

        this->for_ctr_var = getLoopIndexVariable(this->node)->get_name().str();
        this->nome = this->for_ctr_var;
        /**********************************************************/
        //Parte de pegar o padrao de inicio do FOR => EX.: int i = 0 
        SgForInitStatement* stmt    = cur_for->get_for_init_stmt();

        Rose_STL_Container<SgNode*> NodosFor1 = NodeQuery::querySubTree(stmt,V_SgNode); 
        for (Rose_STL_Container<SgNode*>::iterator for1 = NodosFor1.begin(); for1 != NodosFor1.end(); for1++ ) 
        {
            SgIntVal* valIni = isSgIntVal(*for1);
            if(valIni != NULL){
                this->for_ctr_val_ini = valIni->get_value();
            }
        }               
        /**********************************************************/


        /**********************************************************/
        //Condicao de parada do FOR => EX.: i < 10
        this->for_cond_var = this->for_ctr_var;
        
        SgExpression* testExp       = cur_for->get_test_expr();
        
        Rose_STL_Container<SgNode*> NodosFor2 = NodeQuery::querySubTree(testExp,V_SgNode);
        for (Rose_STL_Container<SgNode*>::iterator for2 = NodosFor2.begin(); for2 != NodosFor2.end(); for2++ ) 
        {
            //SgNode* node = isSgNode(*for2);
            //cout<<node->class_name()<< endl;
            SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            //SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            //SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            SgIntVal* valPar        = isSgIntVal(*for2);
            if (opMenorQue != NULL){
                //cond += " < ";
                this->for_cond_op = "<";
            }
            if (valPar != NULL){
                //std::string str = boost::lexical_cast<std::string>(valPar->get_value());
                //cond += str;
                this->for_cond_val = valPar->get_value();
            }
        }
        /**********************************************************/


        /**********************************************************/
        //Parte que identifica o incremento do FOR => EX.: i++
        this->for_incr_var = this->for_ctr_var;
        
        SgExpression* increment     = cur_for->get_increment();
        Rose_STL_Container<SgNode*> NodosFor3 = NodeQuery::querySubTree(increment,V_SgNode);
        
        for (Rose_STL_Container<SgNode*>::iterator for3 = NodosFor3.begin(); for3 != NodosFor3.end(); for3++ ) 
        {
            //SgNode* node = isSgNode(*for3);
            SgPlusPlusOp* opMaisMais    = isSgPlusPlusOp(*for3);
            SgVarRefExp*  varIncr       = isSgVarRefExp(*for3);
            if(opMaisMais != NULL){
                this->for_incr_op  = "++";
                this->for_incr_val = 1;
            }
        }
        /**********************************************************/
    }    
}
counter::~counter() {
}

string counter::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component counter \n";
    res += "generic (\n";
    res += "        bits		: integer := 8;\n";
    res += "        steps		: integer := 1;\n";
    res += "        increment           : integer := 1;\n";
    res += "        down                : integer := 0;\n";
    res += "        condition           : integer := 0\n";
    res += ");\n";
    res += "port (\n";
    res += "        input		: in	std_logic_vector(bits-1 downto 0);\n";
    res += "        termination         : in	std_logic_vector(bits-1 downto 0);\n";
    res += "        clk                 : in	std_logic;\n";
    res += "        clk_en		: in	std_logic := '1';\n";
    res += "        reset		: in	std_logic;\n";
    res += "        load		: in	std_logic := '0';\n";
    res += "        step		: out	std_logic;\n";
    res += "        done		: out	std_logic;\n";
    res += "        output		: out	std_logic_vector(bits-1 downto 0)\n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string counter::geraDOTComp(){
    string res = "";
    res += "\""+this->for_ctr_var +"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<clk>clk|<clk_en>clk_en|<input>input[16]|<load>load|<reset>reset|<termination>termination[16]}|counter:"+this->for_ctr_var +"\\n\\<\\n+=1\\nsteps=1|{<done>done|<output>output[16]|<step>step}}\"]; \n";   
    return res;
}

string counter::geraVHDLComp(){
    string res = "";

    res += "\\" + this->nome + "\\: counter \n";
    res += "generic map ( \n";
    res += "	bits => " + this->counter_bits + ", \n";
    res += "	condition => " + this->counter_condition + ", \n";
    res += "	down => " + this->counter_down + ", \n";
    res += "	increment => " + this->counter_increment + ", \n";
    res += "	steps => " + this->counter_steps + " \n";
    res += ") \n";
    res += "port map ( \n";
    res += "	clk => " + this->counter_clk + ", \n";
    res += "	clk_en => " + this->counter_clk_en + ", \n";
    res += "	done => " + this->counter_done + ", \n";
    res += "	input => " + this->counter_input + ", \n";
    res += "	output => " + this->counter_output + ", \n";
    res += "	reset => " + this->counter_reset + ", \n";
    res += "	step => " + this->counter_step + ", \n";
    res += "	termination => " + this->counter_termination + " \n";
    res += "); \n\n";

    return res;
}

void counter::finalizaPortasComp(){
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
        
        if(res == "output" && this->counter_output == ""){
                this->counter_output    = (*k)->getNome();
        }
        if(res == "done" && this->counter_done == ""){
            this->counter_done      = (*k)->getNome();
        }
        if(res == "step" && this->counter_step == ""){
            this->counter_step      = (*k)->getNome();
        }
        if(res == "clock_en" && this->counter_clk_en == ""){
            this->counter_clk_en    = (*k)->getNome();
        }
        if(res == "clk" && this->counter_clk == ""){
            this->counter_clk       = (*k)->getNome();
        }
        if(res == "termination" && this->counter_termination == ""){
            this->counter_termination= (*k)->getNome();
        }
        if(res == "input" && this->counter_input == ""){
            this->counter_input     = (*k)->getNome();
        }
        if(res == "reset" && this->counter_reset == ""){
            this->counter_reset     = (*k)->getNome();
        }  
    }
}