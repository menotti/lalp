/* 
 * File:   ArquivosDotHW.cpp
 * Author: Luca Porto
 * 
 * Created on July 4, 2013, 5:13 PM
 */
//#include "header/meuHeader.h"
#include "ArquivosDotHW.h"
#include <string>
#include "stdlib.h"
#include "stdio.h"
#include <iostream>
#include <fstream>
#include "CompType.h"
#include "Aux/FuncoesAux.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include <vector>
#include <math.h>

using namespace std;
using std::string;
using std::stringstream;

ArquivosDotHW::ArquivosDotHW(){
}

void ArquivosDotHW::imprimeHWDOT(list<Componente*> listaComp, list<Ligacao*> listaLiga, const string& arquivo, bool debug) {
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;
    if(arquivo != ""){
        this->nomeArquivo = arquivo;
    }
    
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    
    if(debug){
        cout<<"------------------------------------"<<endl;
        cout<<"Conteudo Arquivo DOT"<<endl;
        cout<<"Nome: _HW.dot"<<endl;
        cout<<"------------------------------------"<<endl;
    }
    const char * c = arquivo.c_str();
    std::ofstream fout;
    fout.open(c);
    fout << "digraph diagram {\n";
    fout << "// Components (Nodes) \n";
    
    if(debug){
        cout << "digraph diagram {\n";
        cout << "// Components (Nodes) \n";
    }
    
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::DEL ) continue;  
        
        fout << (*i)->geraDOTComp();
        if(debug) cout << (*i)->geraDOTComp();
    }
    fout << "// Signals (Edges) \n";
    
    if(debug) cout << "// Signals (Edges) \n";
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
        fout << (*k)->imprimeDot();
        if(debug) cout << (*k)->imprimeDot();
    }
    fout << "}\n";
    if(debug) cout << "}\n";
    if(debug) cout<<"------------------------------------"<<endl;
}

void ArquivosDotHW::imprimeVHDL(list<Componente*> listaComp, list<Ligacao*> listaLiga, const string& arquivo){
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;  
    if(arquivo != ""){
        this->nomeArquivo = arquivo;
    }
    this->organizaListaNome();
    GeraMemoryVHDL();
    map<string, Componente*> ::iterator m;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
//    list<Port*>::iterator       p;
    
    cout<<"------------------------------------"<<endl;
    cout<<"Processo criacao arquivo VHDL"<<endl;
    cout<<"Nome: "<<this->nomeArquivo<<".vhd"<<endl;
    cout<<"------------------------------------"<<endl;
    
    const string& end_arquivo = "VHDL/"+arquivo+".vhd";
    const char * c = end_arquivo.c_str();
    
    std::ofstream fout(c);
    
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
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX || (*i)->tipo_comp == CompType::DEL  ) continue;
        
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
//        block_ram* mem = (block_ram*)(*i); 
        if( ((*i)->getEInicializado() == true) && ((*i)->getWE() == false) ){
            int dataSize = (*i)->getWidth();
            int memoryWords =  (int) pow(2,(*i)->getAddressWidth());

            fout << (*i)->getMemoriaVHDLCab() ;
            
            int   intValues[(*i)->valores.size()];
	    int aux1 = 0;
//            cout<< " -------------------------- "<<endl;
//            cout<< (*i)->getName() << " - " << (*i)->getNomeCompVHDL() <<endl;
//            cout<< " -------------------------- "<<endl;
            for(val=(*i)->valores.begin(); val != (*i)->valores.end(); val++){
//                cout<< "["<< aux1 <<"] = " << (*val) <<endl;
		intValues[aux1] = (*val);
		aux1++;
            }
            string valPos = "";
            string posVec;
//            cout<< "VALOR VETOR QTD: " << (*i)->qtd_elem_vet << endl;
//            cout<< "LIST SIZE : " << (*i)->valores.size() << endl;
//            cout<< "DATA SIZE : " << dataSize << endl;
//            cout<< "ADDRES WI : " << (*i)->getAddressWidth() << endl;
//            cout<< "MEMORY WORD : " << memoryWords << endl;
//            cout<< "-----------------------------------"<< endl;
            for (int c = memoryWords-1; c >= 0; c--){
                posVec = FuncoesAux::IntToStr(c);
                int value;
                string bin;
                
                if(c < (*i)->valores.size()){
//                    value = this->LPad(this->ConvertDecToBin(values[c]),dataSize);
//                    value = FuncoesAux::StrToInt(string(values[c].c_str()));
                    value = intValues[c];
                }else{
                    value = 0;
                }
                
                bin = FuncoesAux::LPad(FuncoesAux::ConvertDecToBin(FuncoesAux::IntToStr(value)),dataSize);
                
                valPos += "\t (\""+bin+"\")";
                if (c == 0){
                    valPos += ");";
                }else{
                    valPos += ",";
                }
                
                valPos += "\t -- "+posVec+"\t"+FuncoesAux::IntToStr(value)+"\n";
                
            }
            fout << valPos << endl;
           
            fout << (*i)->getMemoriaVHDLRod();
        }
    }
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
    this->CompMap.clear();
//    cout<<"#####################################"<<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX || (*i)->tipo_comp == CompType::DEL ) continue;
        
//        cout<< (*i)->getNomeCompVHDL() << " -- " << (*i)->getName() << endl;
        this->CompMap.insert(make_pair( (*i)->getNomeCompVHDL(), (*i)));
    }
}

ArquivosDotHW::~ArquivosDotHW() {
}

