/* 
 * File:   ArquivosDotHW.cpp
 * Author: Luca Porto
 * 
 * Created on July 4, 2013, 5:13 PM
 */

#include "ArquivosDotHW.h"
#include <boost/lexical_cast.hpp>
#include <string>
#include "stdlib.h"
#include "stdio.h"

using namespace std;
using std::string;
using std::stringstream;
using boost::lexical_cast;
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
    GeraMemoryVHDL();
    
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
        
        fout << res;
    }
    
    fout << "\nbegin \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){       
        fout << (*i)->geraVHDLComp();
    }
    fout << "end behavior; ";
    
    //cout<<"------------------------------------"<<endl;
}

string ArquivosDotHW::getEstruturaComponenteVHDL(Componente* comp){
    string res = "";
    
    if(comp->tipo_comp == "DLY"){
        if(ExisteNaListaAux("delay_op") == false){
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
            res += "end component; \n\n";
            this->ListaAux.push_back("delay_op");
        }
    }
    if(comp->tipo_comp == "CTD"){
        if(ExisteNaListaAux("counter") == false){ 
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
            res += "end component; \n\n";
            this->ListaAux.push_back("counter");
        }
    }
    if(comp->tipo_comp == "MEM"){
        if(comp->VetorTemValorInicial() == true){
            string name = "block_ram_"+comp->getName();
            if(ExisteNaListaAux(name) == false){  
                res += "component block_ram_"+comp->getName()+" \n";
                res += "generic ( \n";
                res += "        data_width	: integer := 8; \n";
                res += "        address_width	: integer := 8 \n";
                res += "); \n";
                res += "port ( \n";
                res += "        clk		: in	std_logic; \n";
                res += "        we		: in	std_logic := '0'; \n";
                res += "        oe		: in	std_logic := '1'; \n";
                res += "        address		: in	std_logic_vector(address_width-1 downto 0); \n";
                res += "        data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
                res += "        data_out	: out	std_logic_vector(data_width-1 downto 0) \n";
                res += "); \n";
                res += "end component; \n\n";
                
                this->ListaAux.push_back(name);
            }
        }else{
            if(ExisteNaListaAux("block_ram") == false){
                res += "component block_ram \n";
                res += "generic ( \n";
                res += "        data_width	: integer := 8; \n";
                res += "        address_width	: integer := 8 \n";
                res += "); \n";
                res += "port ( \n";
                res += "        clk		: in	std_logic; \n";
                res += "        we		: in	std_logic := '0'; \n";
                res += "        oe		: in	std_logic := '1'; \n";
                res += "        address		: in	std_logic_vector(address_width-1 downto 0); \n";
                res += "        data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
                res += "        data_out	: out	std_logic_vector(data_width-1 downto 0) \n";
                res += "); \n";
                res += "end component; \n\n";

                this->ListaAux.push_back("block_ram");
            }
        }
    }
    if(comp->tipo_comp == "OPE"){
        if(comp->op_tipo  == "ADD"){
            if(ExisteNaListaAux(comp->getTipoOpVHDL()) == false){
                res += "component add_op_s \n";
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
                this->ListaAux.push_back(comp->getTipoOpVHDL());
            }
        }
        if(comp->op_tipo  == "SUB"){
            
        }
        if(comp->op_tipo  == "MUL"){
            
        }
    }
    return res;
}

void ArquivosDotHW::GeraMemoryVHDL() {
    list<Componente*>::iterator i;
    std::ofstream fout("VHDL/memory.vhd");
    
    fout << "-- IEEE Libraries -- \n";
    fout << "library IEEE; \n";
    fout << "use IEEE.std_logic_1164.all; \n";
    fout << "use IEEE.std_logic_arith.all; \n";
    fout << "use IEEE.std_logic_unsigned.all; \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if((*i)->tipo_comp != "MEM") continue;
        
        if((*i)->VetorTemValorInicial() == true){
            fout << "entity block_ram_"+(*i)->getName()+" is \n";
            fout << "generic( \n";
            fout << "        data_width : integer := 8; \n";
            fout << "        address_width : integer := 8 \n";
            fout << "); \n";
            fout << "port( \n";
            fout << "        data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
            fout << "        address : in std_logic_vector(address_width-1 downto 0); \n";
            fout << "        we: in std_logic := '0'; \n";
            fout << "        oe: in std_logic := '1'; \n";
            fout << "        clk : in std_logic; \n";
            fout << "        data_out : out std_logic_vector(data_width-1 downto 0)); \n";
            fout << "end block_ram_"+(*i)->getName()+"; \n\n";

            fout << "architecture rtl of block_ram_"+(*i)->getName()+" is \n\n";

            fout << "constant mem_depth : integer := 2**address_width; \n";
            fout << "type ram_type is array (mem_depth-1 downto 0) \n";
            fout << "of std_logic_vector (data_width-1 downto 0); \n\n";

            fout << "signal read_a : std_logic_vector(address_width-1 downto 0); \n";
            fout << "signal RAM : ram_type := ram_type'( \n";
    //        cout<< "-----------------------------------"<< endl;
    //        cout<< "block_ram_"+(*i)->getName() << endl;
    //        cout<< "VALOR COMPLETO: " << (*i)->valor << endl;
    //        cout<< "-----------------------------------"<< endl;
            const vector<string> values = split((*i)->valor, "|");
            string valPos = "";
            for (int c = values.size()-1; c >=0 ; c--){
                string posVec = boost::lexical_cast<std::string>(c);
                valPos = this->LPad(this->ConvertDecToBin(values[c]),32);
                if(c > 0){
                    //fout << "(\""+valPos+"\"),   --"+posVec+"         \n";
                    fout << "(\""+valPos+"\"),   --"+posVec+"         "+string(values[c].c_str())+"\n";
                    //cout << "(\""<<valPos<<"\"),   --"<<c<<"         "<<values[c]<<endl;
                }else{
                    fout << "(\""+valPos+"\"));  --"+posVec+"         "+string(values[c].c_str())+"\n";
                    //cout << "(\""<<valPos<<"\"),   --"<<c<<"         "<<values[c]<<endl;
                }
            }


            fout << "begin \n";
            fout << "       process (clk) \n";
            fout << "       begin \n";
            fout << "              if (clk'event and clk = '1') then \n";
            fout << "                  if (we = '1') then \n";
            fout << "                        RAM(conv_integer(address)) <= data_in; \n";
            fout << "                        data_out <= RAM(conv_integer(read_a)); \n";
            fout << "                  elsif (oe = '1') then \n";
            fout << "                        data_out <= RAM(conv_integer(read_a)); \n";
            fout << "                  end if; \n";
            fout << "                  read_a <= address; \n";
            fout << "             end if; \n";
            fout << "       end process; \n";
            fout << "end rtl; \n";
        }
    }
}

vector<string> ArquivosDotHW::split(const string& s, const string& delim) {
    vector<string> result;
    if (delim.empty()) {
        result.push_back(s);
        return result;
    }
    string::const_iterator substart = s.begin(), subend;
    while (true) {
        subend = search(substart, s.end(), delim.begin(), delim.end());
        string temp(substart, subend);
        if (!temp.empty()) {
            result.push_back(temp);
        }
        if (subend == s.end()) {
            break;
        }
        substart = subend + delim.size();
    }
    return result;
}

string ArquivosDotHW::ConvertDecToBin(const string &val){
    int dec = lexical_cast<int>(val);
    int rem,i=1,sum=0;
    do
    {
        rem=dec%2;
        sum=sum + (i*rem);
        dec=dec/2;
        i=i*10;
    }while(dec>0);
    string res = boost::lexical_cast<std::string>(sum);
    return res;
}

bool ArquivosDotHW::ExisteNaListaAux(const string &val){
    vector<string>::iterator i;
    bool existe = false;
    for(i=this->ListaAux.begin(); i != this->ListaAux.end(); i++){       
        if( (*i)== val){
            existe = true;
        }
    }
    return existe;
}

string ArquivosDotHW::LPad(const string &val, int size){
    string res ="";
    string res2 ="";
    while((val.size() + res.size()) < size){
        res.push_back('0');
    }
    res2 = string(res.c_str())+val;
    return res2;
}

ArquivosDotHW::~ArquivosDotHW() {
}

