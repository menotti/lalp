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
#include "Componente/counter.h"
#include "Componente/block_ram.h"

using namespace std;
using std::string;
using std::stringstream;

ArquivosDotHW::ArquivosDotHW(list<Componente*> listaComp, list<Ligacao*> listaLiga, const string& nome) {
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;
    this->nomeArquivo = nome;
    this->organizaListaNome();
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
        if((*k)->getAtivo() == false ) continue;
        fout << (*k)->imprimeDot();
        cout << (*k)->imprimeDot();
    }
    fout << "}\n";
    cout << "}\n";
    cout<<"------------------------------------"<<endl;
}

void ArquivosDotHW::imprimeVHDL() {
    GeraMemoryVHDL();
    map<string, Componente*> ::iterator m;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
//    list<Port*>::iterator       p;
    
    cout<<"------------------------------------"<<endl;
    cout<<"Processo criacao arquivo VHDL"<<endl;
    cout<<"Nome: "<<this->nomeArquivo<<".vhd"<<endl;
    cout<<"------------------------------------"<<endl;

    std::ofstream fout("VHDL/example.vhd");
    
    fout << "library IEEE; \n";
    fout << "use IEEE.std_logic_1164.all; \n";
    fout << "use IEEE.std_logic_arith.all; \n";
    fout << "use IEEE.std_logic_unsigned.all; \n";
    fout << "entity "+this->nomeArquivo+" is \n";
    fout << "   port ( \n";
    fout << "           \\clear\\  : in	 std_logic; \n";
    fout << "           \\clk\\    : in	 std_logic; \n";
    fout << "           \\done\\   : out std_logic; \n";
    fout << "           \\init\\   : in	 std_logic; \n";
    fout << "           \\reset\\  : in	 std_logic; \n";
    fout << "           \\result\\ : out std_logic_vector(31 downto 0) \n";
    fout << "); \n";
    fout << "end "+this->nomeArquivo+"; \n\n";
    fout << "architecture behavior of "+this->nomeArquivo+" is \n\n";
    
    //COMPONENTES
    //Carrega as estruturas necessarias
    this->ListaAux.clear();

//    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
    for(m=this->CompMap.begin(); m != this->CompMap.end(); m++){
//        cout<< "1 - " <<  (*m).first << " -- " << (*m).second->getName() <<endl;
//        if ((*m).second->tipo_comp == CompType::REG || (*m).second->tipo_comp == CompType::MEM || (*m).second->tipo_comp == CompType::AUX ) continue;
//        if ( (*m).second->tipo_comp == CompType::AUX ) continue;
//        cout<< "2 - " <<  (*m).first << " -- " << (*m).second->getName() <<endl;
//        if(this->ExisteNaListaAux((*m).first) == false){
//            cout<< "3 - " <<  (*m).first << " -- " << (*m).second->getName() <<endl;
            fout << (*m).second->getEstruturaComponenteVHDL();
            this->ListaAux.push_back((*m).first);
//        }
        
    }
    
    //IGUAO OCORRE NO LALP UMA SAIDA TEM APENAS UM SINAL, ESTA PODE IR PARA 
    //VARIAS ENTRADAS.
    this->ListaAux.clear();
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        if((*k)->getPortOrigem()->getLigacao() != (*k)->getNome()){            
            (*k)->getPortDestino()->setLigacao((*k)->getPortOrigem()->getLigacao());
            (*k)->setName((*k)->getPortOrigem()->getLigacao());
//            this->ListaAux.push_back((*k)->getNome());
        }
    }

    //SINAIS VALIDADOS NO PASSO ANTERIOR
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        if(this->ExisteNaListaAux((*k)->getNome()) == false){
            string res = "signal "+(*k)->getNome();
            
            if((*k)->getTipo() == "std_logic"){
                res += "\t: std_logic; \n";
            }
            else{
                int LigacWidth = FuncoesAux::StrToInt((*k)->getWidth());
                res += "\t: "+(*k)->getTipo()+"("+FuncoesAux::IntToStr(LigacWidth-1)+" downto 0); \n";
            }
            fout << res;
            this->ListaAux.push_back((*k)->getNome());
        }
    }
    
    fout << "\nbegin \n\n";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX ) continue;
        
        fout << (*i)->geraCompVHDL();
    }
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp != CompType::AUX ) continue;
        fout << (*i)->geraCompVHDL();
    }
    fout << "end behavior; ";
    
    //cout<<"------------------------------------"<<endl;
}

void ArquivosDotHW::GeraMemoryVHDL() {
    
    list<Componente*>::iterator i;
    list<int>::iterator val;
    std::ofstream fout("VHDL/memory.vhd");
    
    fout << "-- IEEE Libraries -- \n";
    
    
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if((*i)->tipo_comp != CompType::REF) continue;
        (*i)->getComponenteRef()->setWE((*i)->getWE());
    }
    
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if((*i)->tipo_comp != CompType::MEM) continue;
        block_ram* mem = (block_ram*)(*i); 
        if( ((*i)->getEInicializado() == true) && ((*i)->getWE() == false) ){
            int dataSize = mem->getWidth();
            int memoryWords =  (int) pow(2,mem->getAddressWidth());
//            cout<< "-----------------------------------"<< endl;
//            cout<< "Memory Width: "<<mem->getAddressWidth()<< endl;
//            cout<< "memoryWords: "<<memoryWords << endl;
//            cout<< "-----------------------------------"<< endl;
            fout << "library IEEE; \n";
            fout << "use IEEE.std_logic_1164.all; \n";
            fout << "use IEEE.std_logic_arith.all; \n";
            fout << "use IEEE.std_logic_unsigned.all; \n\n";
            fout << "entity "+(*i)->getNomeCompVHDL()+" is \n";
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
            fout << "end "+(*i)->getNomeCompVHDL()+"; \n\n";

            fout << "architecture rtl of "+(*i)->getNomeCompVHDL()+" is \n\n";

            fout << "constant mem_depth : integer := 2**address_width; \n";
            fout << "type ram_type is array (mem_depth-1 downto 0) \n";
            fout << "of std_logic_vector (data_width-1 downto 0); \n\n";

            fout << "signal read_a : std_logic_vector(address_width-1 downto 0); \n";
            fout << "signal RAM : ram_type := ram_type'( \n";

            //cout<< "-----------------------------------"<< endl;
            //cout<< "block_ram_"+(*i)->getName() << endl;
            //cout<< "VALOR COMPLETO: " << endl;
            //cout<< "-----------------------------------"<< endl;

            //const vector<string> values = FuncoesAux::split((*i)->valor, "|");
            int   intValues[mem->qtd_elem_vet];
	    int aux1 = 0;
            for(val=mem->valores.begin(); val != mem->valores.end(); val++){
		intValues[aux1] = (*val);
		aux1++;
            }
            string valPos = "";
            string posVec;
            //cout<< "VALOR VETOR QTD: " << mem->qtd_elem_vet << endl;
            //cout<< "LIST SIZE : " << mem->valores.size() << endl;
            //cout<< "DATA SIZE : " << dataSize << endl;
            //cout<< "ADDRES WI : " << mem->getAddressWidth() << endl;
            //cout<< "MEMORY WORD : " << memoryWords << endl;
            //cout<< "-----------------------------------"<< endl;
            for (int c = memoryWords-1; c >= 0; c--){
                posVec = boost::lexical_cast<std::string>(c);
                int value;
                string bin;
                
                if(c < mem->qtd_elem_vet){
//                    value = this->LPad(this->ConvertDecToBin(values[c]),dataSize);
//                    value = FuncoesAux::StrToInt(string(values[c].c_str()));
                    value = intValues[c];
                }else{
                    value = 0;
                }
                
                bin = this->LPad(this->ConvertDecToBin(FuncoesAux::IntToStr(value)),dataSize);
                
                valPos += "\t (\""+bin+"\")";
                if (c == 0){
                    valPos += ");";
                }else{
                    valPos += ",";
                }
                
                valPos += "\t -- "+posVec+"\t"+FuncoesAux::IntToStr(value)+"\n";
                
            }
            fout << valPos << endl;
           
            fout << "\nbegin \n";
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
            fout << "end rtl; \n\n";
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


void ArquivosDotHW::organizaListaNome(){
    list<Componente*>::iterator i;
//    cout<<"#####################################"<<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX ) continue;
        
//        cout<< (*i)->getNomeCompVHDL() << " -- " << (*i)->getName() << endl;
        this->CompMap.insert(make_pair( (*i)->getNomeCompVHDL(), (*i)));
    }
    
//    map<string, Componente*> ::iterator m;
//    cout<<"#####################################"<<endl;
//    cout<< "LISTA: " << this->ListaComp.size() <<endl;
//    cout<< "MAPA:  " << this->CompMap.size() <<endl;
//    cout<<"MAP"<<endl;
//    for(m=this->CompMap.begin(); m != this->CompMap.end(); m++){
//        cout<< (*m).first << " -- " << (*m).second->getName() <<endl;
//    }
//    cout<<"#####################################"<<endl;
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

