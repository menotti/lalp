
/* 
 * File:   block_ram.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "block_ram.h"
#include "string"
#include "../Aux/FuncoesAux.h"
#include <math.h>

using namespace std;
using std::string;
using std::stringstream;

block_ram::block_ram(void*node, int dataWidth) : Componente(node, "", dataWidth) {
    this->setDelayValComp("2");
    this->tipo_comp = CompType::MEM;   
    this->setNomeCompVHDL("block_ram"); 
    this->dataWidth     = dataWidth;
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
    string dataWidthAux    = FuncoesAux::IntToStr(this->dataWidth);
    string addressWidthAux = FuncoesAux::IntToStr(this->addressWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address["+addressWidthAux+"]|<clk>clk|<data_in>data_in["+dataWidthAux+"]|<oe>oe|<we>we}|block_ram:"+this->getName()+"|{<data_out>data_out["+dataWidthAux+"]}}\"]; \n";
    return res;
}

void block_ram::setQtdElementos(const string &qtd){
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

int block_ram::getAddressWidth(){
    return this->addressWidth;
}

void block_ram::setTipo(const string &tipo){
    this->tipo_var = tipo;    
}

void block_ram::editQtdElementos(const string &qtd){
    int index = FuncoesAux::StrToInt(qtd);
    double res = (log(index)/log(2));
    if( (int)res < res){
        this->addressWidth = (int)res+1;
    }else{
        this->addressWidth = (int)res;
    }
    
    this->getPortOther("address")->setWidth(FuncoesAux::IntToStr(this->addressWidth));
}

void block_ram::setValor(){
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

string block_ram::getMemoriaVHDLCab(){
//    std::ofstream fout("VHDL/memory.vhd");
    string res = "";
    res += "library IEEE; \n";
    res += "use IEEE.std_logic_1164.all; \n";
    res += "use IEEE.std_logic_arith.all; \n";
    res += "use IEEE.std_logic_unsigned.all; \n\n";
    res += "entity "+this->getNomeCompVHDL()+" is \n";
    res += "generic( \n";
    res += "        data_width : integer := 8; \n";
    res += "        address_width : integer := 8 \n";
    res += "); \n";
    res += "port( \n";
    res += "        data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
    res += "        address : in std_logic_vector(address_width-1 downto 0); \n";
    res += "        we: in std_logic := '0'; \n";
    res += "        oe: in std_logic := '1'; \n";
    res += "        clk : in std_logic; \n";
    res += "        data_out : out std_logic_vector(data_width-1 downto 0)); \n";
    res += "end "+this->getNomeCompVHDL()+"; \n\n";

    res += "architecture rtl of "+this->getNomeCompVHDL()+" is \n\n";

    res += "constant mem_depth : integer := 2**address_width; \n";
    res += "type ram_type is array (mem_depth-1 downto 0) \n";
    res += "of std_logic_vector (data_width-1 downto 0); \n\n";

    res += "signal read_a : std_logic_vector(address_width-1 downto 0); \n";
    
    return res;
}
string block_ram::getMemoriaVHDLRod(){
    string res = "";
      
    res +=  "\nbegin \n";
    res +=  "       process (clk) \n";
    res +=  "       begin \n";
    res +=  "              if (clk'event and clk = '1') then \n";
    res +=  "                  if (we = '1') then \n";
    res +=  "                        RAM(conv_integer(address)) <= data_in; \n";
    res +=  "                        data_out <= RAM(conv_integer(read_a)); \n";
    res +=  "                  elsif (oe = '1') then \n";
    res +=  "                        data_out <= RAM(conv_integer(read_a)); \n";
    res +=  "                  end if; \n";
    res +=  "                  read_a <= address; \n";
    res +=  "             end if; \n";
    res +=  "       end process; \n";
    res +=  "end rtl; \n\n";
    
    return res;
}