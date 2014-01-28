/* 
 * File:   counter.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 2:35 PM
 */
//#include "../header/meuHeader.h"
#include "counter.h"
#include "string"

using namespace std;

counter::counter(void*node) : Componente(node) {
//    this->setDelayValComp("1");
//    SgForStatement* cur_for = isSgForStatement(this->node);
    this->setNomeCompVHDL("counter");
    this->tipo_comp = CompType::CTD;     
    
    this->createAllPorts();
    this->createAllGeneric();
    
}
counter::~counter() {
}

void counter::createAllGeneric(){
    this->addGenericMap(new GenericMap("bits"           , "integer", "32"));
    this->addGenericMap(new GenericMap("condition"      , "integer", "0"));
    this->addGenericMap(new GenericMap("down"           , "integer", "0"));
    this->addGenericMap(new GenericMap("increment"      , "integer", "1"));
    this->addGenericMap(new GenericMap("steps"          , "integer", "1"));
}

void counter::createAllPorts(){
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("clk_en"     ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("done"       ,"out"  ,"std_logic"            ,"1", ""));
    this->addPort(new Port("input"      ,"in"   ,"std_logic_vector"     ,"32", "IN"));
    this->addPort(new Port("load"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("output"     ,"out"  ,"std_logic_vector"     ,"32", "OUT"));
    this->addPort(new Port("reset"      ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("step"       ,"out"  ,"std_logic"            ,"1", ""));
    this->addPort(new Port("termination","in"   ,"std_logic_vector"     ,"32", "")); 
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
    res += "\""+this->getName() +"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<clk>clk|<clk_en>clk_en|<input>input[32]|<load>load|<reset>reset|<termination>termination[32]}|counter:"+this->getName() +"\\n\\<\\n+="+this->getGenericMapIncrements()+"\\nsteps="+this->getGenericMapSteps()+"|{<done>done|<output>output[32]|<step>step}}\"]; \n";   
    return res;
}

void counter::setGenericMapBits(const string &bits){
    this->setGenericMapVal("bits", "VAL", bits);
}

string counter::getGenericMapBits(){
    return (this->getGenericMapVal("bits", "VAL"));
}

void counter::setGenericMapCondition(const string &bits){
    this->setGenericMapVal("condition", "VAL", bits);
}

string counter::getGenericMapCondition(){
    return (this->getGenericMapVal("condition", "VAL"));
}

void counter::setGenericMapDown(const string &bits){
    this->setGenericMapVal("down", "VAL", bits);
}

string counter::getGenericMapDown(){
    return (this->getGenericMapVal("down", "VAL"));
}

void counter::setGenericMapSteps(const string &bits){
    this->setGenericMapVal("steps", "VAL", bits);
}

string counter::getGenericMapSteps(){
    return (this->getGenericMapVal("steps", "VAL"));
}

void counter::setGenericMapIncrements(const string &bits){
    this->setGenericMapVal("increment", "VAL", bits);
}

string counter::getGenericMapIncrements(){
    return (this->getGenericMapVal("increment", "VAL"));
}

void counter::setVarControlCont(const string &var){
    this->for_cond_var = var;
}

string counter::getVarControlCont(){
    return this->for_cond_var;
}

void counter::setVarControlValIni(const string &var){
    this->for_ctr_val_ini = var;
}

string counter::getVarControlValIni(){
    return this->for_ctr_val_ini;
}

void counter::setVarControlValStop(const string &var){
    this->for_cond_val = var;
}

string counter::getVarControlValStop(){
    return this->for_cond_val;
}

