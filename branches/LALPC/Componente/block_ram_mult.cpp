
/* 
 * File:   block_ram_dual.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "block_ram_mult.h"
#include "string"
#include <math.h>
#include "../Aux/FuncoesAux.h"

using namespace std;

block_ram_mult::block_ram_mult(void*node, const string &aux, int qtdElementos) : Componente(node, aux) {
    this->setDelayValComp("2");
    this->tipo_comp = CompType::MEM;   
    this->setNomeCompVHDL("block_ram_mult"); 
    this->dataWidth     = 32;
    this->addressWidth  = 8;
    this->qtdElementos = qtdElementos;
}

block_ram_mult::~block_ram_mult() {
}

string block_ram_mult::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        data_width          : integer := 8; \n";
    res += "        address_width	: integer := 8 \n";
    res += "); \n";
    res += "port ( \n";
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        res += "        address_"+val+"           :in     std_logic_vector (address_width-1 downto 0); \n";
        res += "        data_in_"+val+"           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); \n"; //Talvez colocar := (others => '0'); \n";
        res += "        data_out_"+val+"          :out    std_logic_vector (data_width-1 downto 0); \n"; 
        res += "        we_"+val+"                :in     std_logic := '0'; \n";
        res += "        oe_"+val+"                :in     std_logic := '1'; \n";
    }
    res += "        clk                 :       in std_logic \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string block_ram_mult::geraDOTComp(){
    string addressWidth = FuncoesAux::IntToStr(this->addressWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightblue\", label=\"{{";
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        res += "<address_"+val+">address_"+val+"["+addressWidth+"]|";  
        res += "<data_in_"+val+">data_in_"+val+"[32]|";  
        res += "<oe_"+val+">oe_"+val+"|";  
        res += "<we_"+val+">we_"+val+"";
        if(i < this->qtdElementos-1) res += "|";
    }
    res += "}|block_ram_mult:"+this->getName()+"|{";
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        res+= "<data_out_"+val+">data_out_"+val+"[32]";
        if(i < this->qtdElementos-1) res += "|";
    }
    res+= "}}\"]; \n";
    return res;
}

void block_ram_mult::setQtdElementos(const string &qtd){
//    this->qtd_ele_vet = qtd;
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

void block_ram_mult::editQtdElementos(const string &qtd){
    int index = FuncoesAux::StrToInt(qtd);
    double res = (log(index)/log(2));
    if( (int)res < res){
        this->addressWidth = (int)res+1;
    }else{
        this->addressWidth = (int)res;
    }
//    this->getPortOther("address_0")->setWidth(FuncoesAux::IntToStr(this->addressWidth));
//    this->getPortOther("address_1")->setWidth(FuncoesAux::IntToStr(this->addressWidth));
}

int block_ram_mult::getAddressWidth(){
    return this->addressWidth;
}

void block_ram_mult::setTipo(const string &tipo){
    this->tipo_var = tipo;
}

void block_ram_mult::setValor(){
}

void block_ram_mult::createAllGeneric(){
    this->addGenericMap(new GenericMap("address_width", "integer", FuncoesAux::IntToStr(this->addressWidth)));
    this->addGenericMap(new GenericMap("data_width", "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

void block_ram_mult::createAllPorts(){
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        
        string address  = "address_"+val;
        string data_in  = "data_in_"+val;
        string data_out = "data_out_"+val;
        string we       = "we_"+val;
        string oe       = "oe_"+val;
        
        this->addPort(new Port(address  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->addressWidth), ""));
        this->addPort(new Port(data_in  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
        this->addPort(new Port(data_out ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
        this->addPort(new Port(we       ,"in"   ,"std_logic"            ,"1", ""));
        this->addPort(new Port(oe       ,"in"   ,"std_logic"            ,"1", ""));
    }
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
}


string block_ram_mult::getMemoriaVHDLCab(){
//    std::ofstream fout("VHDL/memory.vhd");
    string res = "";
    
    res += "library IEEE; \n";
    res += "use IEEE.std_logic_1164.all; \n";
    res += "use IEEE.std_logic_arith.all; \n";
    res += "use IEEE.std_logic_unsigned.all; \n\n";

    res += "entity "+this->getNomeCompVHDL()+" is \n";
    res += "generic( \n";
    res += "	data_width : integer := 8; \n";
    res += "	address_width : integer := 8 \n";
    res += "); \n";
    res += "port( \n";

    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        res += "	data_in_"+val+" : in std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
        res += "	address_"+val+" : in std_logic_vector(address_width-1 downto 0); \n";
        res += "	we_"+val+" : in std_logic := '0'; \n";
        res += "	oe_"+val+" : in std_logic := '1'; \n";
        res += "	data_out_"+val+" : out std_logic_vector(data_width-1 downto 0); \n";
    }
    
    res += "	clk : in std_logic); \n";
    res += "end "+this->getNomeCompVHDL()+"; \n\n";

    res += "architecture rtl of "+this->getNomeCompVHDL()+" is \n\n";

    res += "constant mem_depth : integer := 2**address_width; \n";
    res += "type ram_type is array (mem_depth-1 downto 0) \n";
    res += "of std_logic_vector (data_width-1 downto 0); \n\n";
    
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        res += "signal read_"+val+" : std_logic_vector(address_width-1 downto 0); \n";
    }
    res += "signal RAM : ram_type := ram_type'( \n";
    
    return res;
}
string block_ram_mult::getMemoriaVHDLRod(){
    string res = "";
      
    res +=  "\nbegin \n";
    res +=  "       process (clk) \n";
    res +=  "       begin \n";
    res +=  "              if (clk'event and clk = '1') then \n";
    for (int i = 0; i < this->qtdElementos; i++){
        string val      = FuncoesAux::IntToStr(i);
        
        res +=  "                  if (we_"+val+" = '1') then \n";
        res +=  "                        RAM(conv_integer(address_"+val+")) <= data_in_"+val+"; \n";
        res +=  "                        data_out_"+val+" <= RAM(conv_integer(read_"+val+")); \n";
        res +=  "                  elsif (oe_"+val+" = '1') then \n";
        res +=  "                        data_out_"+val+" <= RAM(conv_integer(read_"+val+")); \n";
        res +=  "                  end if; \n";
        res +=  "                  read_"+val+" <= address_"+val+"; \n"; 
    }
    res +=  "             end if; \n";
    res +=  "       end process; \n";
    res +=  "end rtl; \n\n";
    
    return res;
}