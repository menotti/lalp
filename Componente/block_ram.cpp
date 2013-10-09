
/* 
 * File:   block_ram.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "../header/meuHeader.h"
#include "block_ram.h"
#include "string"
#include "../Aux/FuncoesAux.h"

using namespace std;

block_ram::block_ram(SgNode* node, const string &aux) : Componente(node, aux) {
    this->setDelayValComp("2");
    this->tipo_comp = CompType::MEM;   
        
    this->dataWidth     = 32;
    this->addressWidth  = 8;
}

block_ram::~block_ram() {
}

string block_ram::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        data_width          : integer := 8; \n";
    res += "        address_width	: integer := 8 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        clk                 : in	std_logic; \n";
    res += "        we                  : in	std_logic := '0'; \n";
    res += "        oe                  : in	std_logic := '1'; \n";
    res += "        address             : in	std_logic_vector(address_width-1 downto 0); \n";
    res += "        data_in             : in	std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
    res += "        data_out            : out	std_logic_vector(data_width-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string block_ram::geraDOTComp(){
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address[11]|<clk>clk|<data_in>data_in[32]|<oe>oe|<we>we}|block_ram:"+this->getName()+"|{<data_out>data_out[32]}}\"]; \n";
    return res;
}

void block_ram::setQtdElementos(const string &qtd){
    this->qtd_ele_vet = qtd;
    int index = FuncoesAux::StrToInt(qtd);
    
    double res = (log(index)/log(2));
    if( (int)res < res){
        this->addressWidth = (int)res+1;
    }else{
        this->addressWidth = (int)res;
    }
    this->createAllPorts();
    this->createAllGeneric();
}

int block_ram::getAddressWidth(){
    return this->addressWidth;
}

void block_ram::setTipo(const string &tipo){
    this->tipo_var = tipo;
}

void block_ram::setValor(const string &valor){
    this->valor = valor;
}

void block_ram::createAllGeneric(){
    this->addGenericMap(new GenericMap("address_width", "integer", FuncoesAux::IntToStr(this->addressWidth)));
    this->addGenericMap(new GenericMap("data_width", "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

void block_ram::createAllPorts(){
    this->addPort(new Port("address"    ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->addressWidth), ""));
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("data_in"    ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("data_out"   ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    this->addPort(new Port("oe"         ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("we"         ,"in"   ,"std_logic"            ,"1", "")); 
}