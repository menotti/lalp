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
#include "Componente/Port.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include "Componente/comp_aux.h"
#include <vector>
#include <math.h>

using namespace std;
using std::string;
using std::stringstream;

ArquivosDotHW::ArquivosDotHW(){
}

void ArquivosDotHW::imprimeHWDOT(list<Componente*> listaComp, list<Ligacao*> listaLiga, const string& arquivo, bool debug, bool temMemoria) {
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;
    this->temMemoria= temMemoria;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    
    
    if(arquivo != ""){
        this->nomeArquivo = arquivo;
    }
        
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
    this->ListaAux.clear();
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::DEL ) continue; 
        if ((*i)->tipo_comp == CompType::AUX ){
            comp_aux* compAUX = (comp_aux*)(*i);
            if(compAUX->getGlobalComp() == true) continue;
        }
        if(this->ExisteNaListaAux((*i)->getName()) == false){
            fout << (*i)->geraDOTComp();
            if(debug) cout << (*i)->geraDOTComp();
            this->ListaAux.push_back((*i)->getName());
        }
    }
    this->ListaAux.clear();
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

void ArquivosDotHW::geraTesteVHDL(){
    list<Componente*>::iterator i;
    const string& end_arquivo = "VHDL/t_"+this->nomeArquivo+".vhd";
    const char * c = end_arquivo.c_str();
    
    std::ofstream fout(c);
    
    fout << "library IEEE; \n";
    fout << "use IEEE.std_logic_1164.all; \n";
    fout << "use IEEE.std_logic_arith.all; \n";
    fout << "use IEEE.std_logic_unsigned.all; \n";
    fout << "entity t_"+this->nomeArquivo+" is \n";
    fout << "end t_"+this->nomeArquivo+"; \n";
    fout << "architecture behavior of t_"+this->nomeArquivo+" is \n\n";
    fout << "component "+this->nomeArquivo+" \n";

    fout << "\tport (\n";
    
    string nome = "";
    string OutIn= "";
    string type = "";
    string size = "";
    bool dp     = false;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if( (*i)->tipo_comp != CompType::AUX ) continue;
        if( (*i)->getNomeCompVHDL() == "valor") continue;
        comp_aux* compAUX = (comp_aux*)(*i);
        nome  = compAUX->getName();
        OutIn = "in";
        if(!compAUX->ehCompIn()) OutIn = "out";
        type  = "std_logic";
        if(compAUX->getWidth() > 1) {
            size =  FuncoesAux::IntToStr(compAUX->getWidth()-1);
            type = "std_logic_vector("+size+" downto 0)";
        }
        if(dp){
            fout << ";\n";
        }else{
            dp = true;
        }
        fout << "\t\t\\" + nome + "\\\t: " + OutIn + "\t" + type;
    }
    fout <<"\n\t);\n";
    fout << "end component;\n\n";
    
    string init = "";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if( (*i)->tipo_comp != CompType::AUX )  continue;
        if( (*i)->getNomeCompVHDL() == "valor") continue;
        comp_aux* compAUX = (comp_aux*)(*i);
        nome  = compAUX->getName();

        type  = "std_logic";
        init  = "'0'";
        if(compAUX->getWidth() > 1) {
            size =  FuncoesAux::IntToStr(compAUX->getWidth()-1);
            type = "std_logic_vector("+size+" downto 0)";
            init = "(others => '0')";
        }            
        fout <<"signal \\" + nome + "\\\t: " + type + "\t:= " + init + ";\n";

    }
        
    fout << "\nbegin\n\n";
    fout << "\nuut: "+this->nomeArquivo+" \n";
    fout << "port map ( \n";
    dp = false;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if( (*i)->tipo_comp != CompType::AUX ) continue;
        if( (*i)->getNomeCompVHDL() == "valor") continue;
        
        if (dp) {
            fout <<",\n";
        }
        else {
            dp = true;
        }
        fout <<"\t\\" + (*i)->getName() + "\\ => \\" + (*i)->getName() + "\\";
    }
    fout << "\n);\n\n";
    fout << "clock: process \n";
    fout << "begin\n";
    fout << "\twait for 5 ns; \n";
    fout << "\t\\clk\\  <= not \\clk\\; \n";
    fout << "end process clock; \n\n";

    fout << "stimulus: process \n";
    fout << "begin \n";
    fout << "\t\\reset\\  <= '1'; \n";
    fout << "\twait for 50 ns; \n";
    fout << "\t\\reset\\  <= '0'; \n";
    fout << "\twait for 50 ns; \n";
    fout << "\t\\init\\  <= '1'; \n";
    fout << "\twait; \n";
    fout << "end process stimulus; \n";

    fout << "end behavior;\n";

}

void ArquivosDotHW::imprimeVHDL(list<Componente*> listaComp, list<Ligacao*> listaLiga, const string& arquivo){
    this->ListaComp = listaComp;
    this->ListaLiga = listaLiga;  
    map<string, Componente*> ::iterator m;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
 
    if(arquivo != ""){
        this->nomeArquivo = arquivo;
    }
    this->organizaListaNome();
    if(this->temMemoria) GeraMemoryVHDL();
    
    geraTesteVHDL();
//    map<string, Componente*> ::iterator m;
//    list<Componente*>::iterator i;
//    list<Ligacao*>::iterator    k;
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
    fout << "\tport (\n";
    
    string nome = "";
    string OutIn= "";
    string type = "";
    string size = "";
    bool dp     = false;
    
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if( (*i)->tipo_comp != CompType::AUX ) continue;
        if( (*i)->getNomeCompVHDL() == "valor") continue;
        comp_aux* compAUX = (comp_aux*)(*i);
        nome  = compAUX->getName();
        OutIn = "in";
        if(!compAUX->ehCompIn()) OutIn = "out";
        type  = "std_logic";
        if(compAUX->getWidth() > 1) {
            size =  FuncoesAux::IntToStr(compAUX->getWidth()-1);
            type = "std_logic_vector("+size+" downto 0)";
        }
        if(dp){
            fout << ";\n";
        }else{
            dp = true;
        }
        fout << "\t\t\\" + nome + "\\\t: " + OutIn + "\t" + type;
    }
    fout <<"\n\t);\n";
    fout << "end "+this->nomeArquivo+"; \n\n";
    fout << "architecture behavior of "+this->nomeArquivo+" is \n\n";
    
    //COMPONENTES
    //Carrega as estruturas necessarias
    this->ListaAux.clear();

//    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
    for(m=this->CompMap.begin(); m != this->CompMap.end(); m++){
        fout << (*m).second->getEstruturaComponenteVHDL();
        this->ListaAux.push_back((*m).first);
    }
   
    //IGUAO OCORRE NO LALP UMA SAIDA TEM APENAS UM SINAL, ESTA PODE IR PARA 
    //VARIAS ENTRADAS.
    this->ListaAux.clear();
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
  
        if((*k)->getPortOrigem()->getLigacao2()->getNome() != (*k)->getNome()){
            (*k)->getPortDestino()->addLigacao((*k)->getPortOrigem()->getLigacao2());
            (*k)->getPortDestino()->setLigacao((*k)->getPortOrigem()->getLigacao2()->getNome());
 
            (*k)->getDestino()->removeLigacao((*k));

            (*k)->getDestino()->addLigacao((*k));
            (*k)->setAtivo(false);
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
        if(this->ExisteNaListaAux((*i)->getName()) == false){
            this->ListaAux.push_back((*i)->getName());
            fout << (*i)->geraCompVHDL();
        }
    }
        
    // IO ports attributions
    bool debug = false;
    if(debug){
        cout << "criacao ligacoes IO" << endl;
    }
    string tipo = "";
    list<Port*>::iterator ports;
    list<Port*> ListaPortas;
    Port* p;
    Ligacao* lig;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp != CompType::AUX ) continue;
        if ((*i)->getGlobalComp() == true ) continue;
        
        comp_aux* compAux = (comp_aux*)(*i);
        if(debug) cout << "Componente: " << compAux->getName() << endl;
        ListaPortas.clear();
        p           = NULL;
        lig         = NULL;
        
        ListaPortas = (*i)->getPorts();
        
        if(ListaPortas.size() < 1) continue;
        
        for(ports=ListaPortas.begin(); ports != ListaPortas.end(); ports++){
            p = (*ports);
        }

        lig = p->getLigacao2();
        
        
        
        if(lig != NULL && p != NULL){
            if(p->getInput() == "in"){
                if(p->getType() == lig->getTipo()){
                    int ligWidth        = FuncoesAux::StrToInt(lig->getWidth());
                    int porWidth        = FuncoesAux::StrToInt(p->getWidth());
                    if (ligWidth == porWidth){
                        fout << "\\" + compAux->getName() + "\\ <= " + lig->getNome()+ ";\n";
                    }else{
                        if (porWidth < ligWidth) {
                            int newporWidth     = porWidth-1;
                            string newPorWidth  = FuncoesAux::IntToStr(newporWidth);
                            fout <<"\\" + compAux->getName() + "\\(" + newPorWidth + " downto 0) <= " + lig->getNome() + "(" + newPorWidth + " downto 0);\n";
                        }
                        else {
                            int newligWidth     = ligWidth-1;
                            string newLigWidth  = FuncoesAux::IntToStr(newligWidth);
                            fout <<"\\" + compAux->getName() + "\\(" + newLigWidth + " downto 0) <= " + lig->getNome() + "(" + newLigWidth + " downto 0);\n";
                        }
                    }
                }else{
                    if (lig->getTipo() == "std_logic"){
                        fout << "\\" + compAux->getName() + "\\(0) <= " + lig->getNome() + ";\n";
                    }else{
                        fout << "\\" + compAux->getName() + "\\ <= " + lig->getNome() + "(0);\n";
                    }
                }
            }else {
                fout << lig->getNome() + " <= ";
                if(compAux->getNomeCompVHDL() != "valor"){
                    fout << "\\" + compAux->getName() + "\\;\n";
                }else{
                    fout <<"conv_std_logic_vector(" + compAux->getValAux() + ", " + lig->getWidth() + ");\n";
                }
            }
        }
        if(debug) cout << "----" << endl;
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
        if ((*i)->getNomeCompVHDL() == "block_ram" ) continue;
//        block_ram* mem = (block_ram*)(*i); 
        
            int dataSize = (*i)->getWidth();
            int memoryWords =  (int) pow(2,(*i)->getAddressWidth());

            fout << (*i)->getMemoriaVHDLCab() ;
            if( ((*i)->getEInicializado() == true) && ((*i)->getWE() == false) ){
                int   intValues[(*i)->valores.size()];
                int aux1 = 0;

                for(val=(*i)->valores.begin(); val != (*i)->valores.end(); val++){
                    intValues[aux1] = (*val);
                    aux1++;
                }
                string valPos = "";
                string posVec;
                fout << "signal RAM : ram_type := ram_type'( \n";
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
            }else{
                fout << "signal RAM : ram_type; \n";
            }
        fout << (*i)->getMemoriaVHDLRod();
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

