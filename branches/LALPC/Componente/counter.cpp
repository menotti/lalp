/* 
 * File:   counter.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 2:35 PM
 */
#include "../header/meuHeader.h"
#include "counter.h"
#include "string"

using namespace std;

counter::counter(SgNode* node) : Componente(node) {
    SgForStatement* cur_for = isSgForStatement(this->node);
    this->setNomeCompVHDL("counter");
    this->tipo_comp = CompType::CTD;     
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

        this->for_ctr_var = SageInterface::getLoopIndexVariable(this->node)->get_name().str();
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
    this->createAllPorts();
    this->createAllGeneric();
    
}
counter::~counter() {
}

void counter::createAllGeneric(){
    this->addGenericMap(new GenericMap("bits"           , "integer", "16"));
    this->addGenericMap(new GenericMap("condition"      , "integer", "0"));
    this->addGenericMap(new GenericMap("down"           , "integer", "0"));
    this->addGenericMap(new GenericMap("increment"      , "integer", "1"));
    this->addGenericMap(new GenericMap("steps"          , "integer", "1"));
}

void counter::createAllPorts(){
    this->addPort(new Port("input"      ,"in"   ,"std_logic_vector"     ,"16", "IN"));
    this->addPort(new Port("termination","in"   ,"std_logic_vector"     ,"16", ""));
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("clk_en"     ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("load"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("step"       ,"out"  ,"std_logic"            ,"1", ""));
    this->addPort(new Port("done"       ,"out"  ,"std_logic"            ,"1", ""));
    this->addPort(new Port("output"     ,"out"  ,"std_logic_vector"     ,"16", "OUT"));
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
    res += "\""+this->getName() +"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<clk>clk|<clk_en>clk_en|<input>input[16]|<load>load|<reset>reset|<termination>termination[16]}|counter:"+this->getName() +"\\n\\<\\n+=1\\nsteps=1|{<done>done|<output>output[16]|<step>step}}\"]; \n";   
    return res;
}

string counter::geraVHDLComp(){
    string res = "";

    res += "\\" + this->getName() + "\\: counter \n";
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
