/* 
 * File:   ArquivosDotHW.cpp
 * Author: Luca Porto
 * 
 * Created on July 4, 2013, 5:13 PM
 */
#include "header/meuHeader.h"
#include "ArquivosDotHW.h"
#include <string>
#include "stdlib.h"
#include "stdio.h"
#include "CompType.h"
#include "Aux/FuncoesAux.h"

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
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM ) continue;  
        
        fout << (*i)->geraDOTComp();
        cout << (*i)->geraDOTComp();
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
        //fout << this->getEstruturaComponenteVHDL((*i));
    }
    
    //SINAIS
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        string res = "";
        res += "signal "+(*k)->getNome()+"       : std_logic";
        if((*k)->getWidth() == ""){
            res += "; \n";
        }
        if((*k)->getWidth() == "1"){
            res += "_vector(0 downto 0); \n";
        }
        if((*k)->getWidth() == "16"){
            res += "_vector(15 downto 0); \n";
        }
        if((*k)->getWidth() == "32"){
            res += "_vector(31 downto 0); \n";
        }
        
        fout << res;
    }
    
    fout << "\nbegin \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){       
        //fout << (*i)->geraVHDLComp();
    }
    fout << "end behavior; ";
    
    //cout<<"------------------------------------"<<endl;
}

void ArquivosDotHW::GeraMemoryVHDL() {
    cout<<"ENTROU MEMORIA"<<endl;
    list<Componente*>::iterator i;
    std::ofstream fout("VHDL/memory.vhd");
    
    fout << "-- IEEE Libraries -- \n";
    fout << "library IEEE; \n";
    fout << "use IEEE.std_logic_1164.all; \n";
    fout << "use IEEE.std_logic_arith.all; \n";
    fout << "use IEEE.std_logic_unsigned.all; \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if((*i)->tipo_comp != CompType::MEM) continue;
        
        if((*i)->getEInicializado() == true){
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
            const vector<string> values = FuncoesAux::split((*i)->valor, "|");
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


string ArquivosDotHW::ConvertDecToBin(const string &val){
    int dec = FuncoesAux::StrToInt(val);
    int rem,i=1,sum=0;
    do
    {
        rem=dec%2;
        sum=sum + (i*rem);
        dec=dec/2;
        i=i*10;
    }while(dec>0);
    string res = FuncoesAux::IntToStr(sum);
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

