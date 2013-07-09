/* 
 * File:   ArquivosDotHW.cpp
 * Author: Luca Porto
 * 
 * Created on July 4, 2013, 5:13 PM
 */

#include "ArquivosDotHW.h"
#include <string>
using namespace std;
using std::string;
using std::stringstream;
ArquivosDotHW::ArquivosDotHW(list<Componente*> listaComp, list<Ligacao*> listaLiga) {
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;
}

void ArquivosDotHW::imprimeHWDOT() {
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"------------------------------------"<<endl;
    cout<<"Conteudo Arquivo DOT"<<endl;
    cout<<"Nome: _HW.dot"<<endl;
    cout<<"------------------------------------"<<endl;
    std::ofstream fout("DOT/Exemplo_HW.dot");
    fout << "digraph diagram {\n";
    fout << "// Components (Nodes) \n";
    cout << "digraph diagram {\n";
    cout << "// Components (Nodes) \n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;  
        
        fout << (*i)->imprimeDOT();
        cout << (*i)->imprimeDOT();
    }
    fout << "// Signals (Edges) \n";
    cout << "// Signals (Edges) \n";
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        fout << (*k)->imprimeDot();
        cout << (*k)->imprimeDot();
    }
    fout << "}\n";
    cout << "}\n";
    cout<<"------------------------------------"<<endl;
}

void ArquivosDotHW::imprimeVHDL() {
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"------------------------------------"<<endl;
    cout<<"Processo criacao arquivo VHDL"<<endl;
    cout<<"Nome: example.vhd"<<endl;
    cout<<"------------------------------------"<<endl;
    std::ofstream fout("VHDL/example.vhd");
    
    fout << "library IEEE; \n";
    fout << "use IEEE.std_logic_1164.all; \n";
    fout << "use IEEE.std_logic_arith.all; \n";
    fout << "use IEEE.std_logic_unsigned.all; \n";
    fout << "entity vecsum is \n";
    fout << "   port ( \n";
    fout << "           \\clear\\  : in	 std_logic; \n";
    fout << "           \\clk\\    : in	 std_logic; \n";
    fout << "           \\done\\   : out std_logic; \n";
    fout << "           \\init\\   : in	 std_logic; \n";
    fout << "           \\reset\\  : in	 std_logic; \n";
    fout << "           \\result\\ : out std_logic_vector(31 downto 0) \n";
    fout << "); \n";
    fout << "end vecsum; \n\n";
    fout << "architecture behavior of vecsum is \n\n";
    
    //COMPONENTES
    //Carrega as estruturas necessarias
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){       
        fout << this->getEstruturaComponenteVHDL((*i));
    }
    
    //SINAIS
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        string res = "";
        res += "signal "+(*k)->getNome()+"       : std_logic";
        if((*k)->getSize() == ""){
            res += "; \n";
        }
        if((*k)->getSize() == "1"){
            res += "_vector(0 downto 0); \n";
        }
        if((*k)->getSize() == "16"){
            res += "_vector(15 downto 0); \n";
        }
        if((*k)->getSize() == "32"){
            res += "_vector(31 downto 0); \n";
        }
    }
    
    fout << "begin \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){       
        fout << (*i)->geraVHDLComp();
    }
    fout << "end behavior; ";
    
    cout<<"------------------------------------"<<endl;
}


string ArquivosDotHW::getEstruturaComponenteVHDL(Componente* comp){
    string res = "";
    
    if(comp->tipo_comp == "DLY"){
        res += "component delay_op \n";
        res += "generic ( \n";
	res += "        bits            : integer := 8; \n";
	res += "        delay           : integer := 1 \n";
        res += "); \n";
        res += "port ( \n";
	res += "        a		: in	std_logic_vector(bits-1 downto 0); \n";
	res += "        clk		: in	std_logic; \n";
	res += "        reset		: in	std_logic; \n";
	res += "        a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0') \n";
        res += "); \n";
    }
    if(comp->tipo_comp == "CTD"){
        res += "component counter \n";
        res += "generic (\n";
        res += "        bits		: integer := 8;\n";
        res += "        steps		: integer := 1;\n";
        res += "        increment	: integer := 1;\n";
        res += "        down            : integer := 0;\n";
        res += "        condition       : integer := 0\n";
        res += ");\n";
        res += "port (\n";
        res += "        input		: in	std_logic_vector(bits-1 downto 0);\n";
        res += "        termination	: in	std_logic_vector(bits-1 downto 0);\n";
        res += "        clk		: in	std_logic;\n";
        res += "        clk_en		: in	std_logic := '1';\n";
        res += "        reset		: in	std_logic;\n";
        res += "        load		: in	std_logic := '0';\n";
        res += "        step		: out	std_logic;\n";
        res += "        done		: out	std_logic;\n";
        res += "        output		: out	std_logic_vector(bits-1 downto 0)\n";
        res += "); \n";
        res += "end component; \n";
    }
    if(comp->tipo_comp == "REF"){
        if(comp->ref_var_tipo  == "VAR"){
            
        }
        if(comp->ref_var_tipo  == "VET"){
            res += "component block_ram \n";
            res += "generic ( \n";
            res += "        data_width		: integer := 8; \n";
            res += "        address_width	: integer := 8 \n";
            res += "); \n";
            res += "port ( \n";
            res += "        clk			: in	std_logic; \n";
            res += "        we			: in	std_logic := '0'; \n";
            res += "        oe			: in	std_logic := '1'; \n";
            res += "        address		: in	std_logic_vector(address_width-1 downto 0); \n";
            res += "        data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
            res += "        data_out	: out	std_logic_vector(data_width-1 downto 0) \n";
            res += "); \n";
            res += "end component; \n";
        }
    }
    if(comp->tipo_comp == "OPE"){
        if(comp->op_tipo  == "ADD"){
            res += "component add_op_s \n";
            res += "generic ( \n";
            res += "        w_in1	: integer := 8; \n";
            res += "        w_in2	: integer := 8; \n";
            res += "        w_out	: integer := 16 \n";
            res += "); \n";
            res += "port ( \n";
            res += "        I0	: in	std_logic_vector(w_in1-1 downto 0); \n";
            res += "        I1	: in	std_logic_vector(w_in2-1 downto 0); \n";
            res += "        O0	: out	std_logic_vector(w_out-1 downto 0) \n";
            res += "); \n";
        }
        if(comp->op_tipo  == "SUB"){
            
        }
        if(comp->op_tipo  == "MUL"){
            
        }
    }
    return res;
}

ArquivosDotHW::~ArquivosDotHW() {
}

