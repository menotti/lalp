
/* 
 * File:   block_ram_dual.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
//#include "../header/meuHeader.h"
#include "block_ram_dual.h"
#include "string"
#include <math.h>
#include "../Aux/FuncoesAux.h"

using namespace std;

block_ram_dual::block_ram_dual(void*node, const string &aux, int dataWidth) : Componente(node, aux) {
    this->setDelayValComp("2");
    this->tipo_comp = CompType::MEM;   
    this->setNomeCompVHDL("block_ram_dual"); 
    this->dataWidth     = dataWidth;
    this->addressWidth  = 8;
}

block_ram_dual::~block_ram_dual() {
}

string block_ram_dual::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        data_width          : integer := 8; \n";
    res += "        address_width	: integer := 8 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        address_0           :in     std_logic_vector (address_width-1 downto 0); \n";
    res += "        data_in_0           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); \n"; //Talvez colocar := (others => '0'); \n";
    res += "        data_out_0          :out    std_logic_vector (data_width-1 downto 0); \n"; 
    res += "        we_0                :in     std_logic := '0'; \n";
    res += "        oe_0                :in     std_logic := '1'; \n";
    res += "        address_1           :in     std_logic_vector (address_width-1 downto 0); \n";
    res += "        data_in_1           :in     std_logic_vector (data_width-1 downto 0) := (others => '0'); \n";
    res += "        data_out_1          :out    std_logic_vector (data_width-1 downto 0); \n"; 
    res += "        we_1                :in     std_logic := '0'; \n";
    res += "        oe_1                :in     std_logic := '1'; \n";
    res += "        clk                 :       in std_logic \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string block_ram_dual::geraDOTComp(){
    string dataWidthAux    = FuncoesAux::IntToStr(this->dataWidth);
    string addressWidthAux = FuncoesAux::IntToStr(this->addressWidth);
    string res = "";
    res += "\""+this->getName()+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightblue\", label=\"{{<address_0>address_0["+addressWidthAux+"]|<data_in_0>data_in_0["+dataWidthAux+"]|<oe_0>oe_0|<we_0>we_0|<address_1>address_1["+addressWidthAux+"]|<data_in_1>data_in_1["+dataWidthAux+"]|<oe_1>oe_1|<we_1>we_1}|block_ram_dual:"+this->getName()+"|{<data_out_0>data_out_0["+dataWidthAux+"]|<data_out_1>data_out_1["+dataWidthAux+"]}}\"]; \n";
    return res;
}

void block_ram_dual::setQtdElementos(const string &qtd){
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

void block_ram_dual::editQtdElementos(const string &qtd){
    int index = FuncoesAux::StrToInt(qtd);
    double res = (log(index)/log(2));
    if( (int)res < res){
        this->addressWidth = (int)res+1;
    }else{
        this->addressWidth = (int)res;
    }
    this->getPortOther("address_0")->setWidth(FuncoesAux::IntToStr(this->addressWidth));
    this->getPortOther("address_1")->setWidth(FuncoesAux::IntToStr(this->addressWidth));
}

int block_ram_dual::getAddressWidth(){
    return this->addressWidth;
}

void block_ram_dual::setTipo(const string &tipo){
    this->tipo_var = tipo;
}

void block_ram_dual::setValor(){
}

void block_ram_dual::createAllGeneric(){
    this->addGenericMap(new GenericMap("address_width", "integer", FuncoesAux::IntToStr(this->addressWidth)));
    this->addGenericMap(new GenericMap("data_width", "integer", FuncoesAux::IntToStr(this->dataWidth)));
}

void block_ram_dual::createAllPorts(){
    this->addPort(new Port("address_0"  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->addressWidth), ""));
    this->addPort(new Port("data_in_0"  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("data_out_0" ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    this->addPort(new Port("we_0"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("oe_0"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("address_1"  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->addressWidth), ""));
    this->addPort(new Port("data_in_1"  ,"in"   ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "IN"));
    this->addPort(new Port("data_out_1" ,"out"  ,"std_logic_vector"     ,FuncoesAux::IntToStr(this->dataWidth), "OUT"));
    this->addPort(new Port("we_1"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("oe_1"       ,"in"   ,"std_logic"            ,"1", ""));
    this->addPort(new Port("clk"        ,"in"   ,"std_logic"            ,"1", ""));
}


string block_ram_dual::getMemoriaVHDLCab(){
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
    res += "	data_in_0 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
    res += "	address_0 : in std_logic_vector(address_width-1 downto 0); \n";
    res += "	we_0: in std_logic := '0'; \n";
    res += "	oe_0: in std_logic := '1'; \n";
    res += "	data_out_0 : out std_logic_vector(data_width-1 downto 0); \n";
    res += "	data_in_1 : in std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
    res += "	address_1 : in std_logic_vector(address_width-1 downto 0); \n";
    res += "	we_1: in std_logic := '0'; \n";
    res += "	oe_1: in std_logic := '1'; \n";
    res += "	data_out_1 : out std_logic_vector(data_width-1 downto 0); \n";
    res += "	clk : in std_logic); \n";
    res += "end "+this->getNomeCompVHDL()+"; \n\n";

    res += "architecture rtl of "+this->getNomeCompVHDL()+" is \n\n";

    res += "constant mem_depth : integer := 2**address_width; \n";
    res += "type ram_type is array (mem_depth-1 downto 0) \n";
    res += "of std_logic_vector (data_width-1 downto 0); \n\n";

    res += "signal read_a : std_logic_vector(address_width-1 downto 0); \n";
    res += "signal read_b : std_logic_vector(address_width-1 downto 0); \n";
    res += "signal RAM : ram_type := ram_type'( \n";
    
    return res;
}
string block_ram_dual::getMemoriaVHDLRod(){
    string res = "";
      
    res +=  "\nbegin \n";
    res +=  "       process (clk) \n";
    res +=  "       begin \n";
    res +=  "              if (clk'event and clk = '1') then \n";
    res +=  "                  if (we_0 = '1') then \n";
    res +=  "                        RAM(conv_integer(address_0)) <= data_in_0; \n";
    res +=  "                        data_out_0 <= RAM(conv_integer(read_a)); \n";
    res +=  "                  elsif (oe_0 = '1') then \n";
    res +=  "                        data_out_0 <= RAM(conv_integer(read_a)); \n";
    res +=  "                  end if; \n";
    res +=  "                  read_a <= address_0; \n";
    res +=  "             end if; \n";
    res +=  "       end process; \n";
    res +=  "       process (clk) \n";
    res +=  "       begin \n";
    res +=  "              if (clk'event and clk = '1') then \n";    
    res +=  "                  if (we_1 = '1') then \n";
    res +=  "                        RAM(conv_integer(address_1)) <= data_in_1; \n";
    res +=  "                        data_out_1 <= RAM(conv_integer(read_b)); \n";
    res +=  "                  elsif (oe_1 = '1') then \n";
    res +=  "                        data_out_1 <= RAM(conv_integer(read_b)); \n";
    res +=  "                  end if; \n";
    res +=  "                  read_b <= address_1; \n";
    res +=  "             end if; \n";
    res +=  "       end process; \n";
    res +=  "end rtl; \n\n";
    
    return res;
}