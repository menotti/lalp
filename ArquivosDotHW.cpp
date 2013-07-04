/* 
 * File:   ArquivosDotHW.cpp
 * Author: Luca Porto
 * 
 * Created on July 4, 2013, 5:13 PM
 */

#include "ArquivosDotHW.h"
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
    std::ofstream fout("_HW.dot");
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

ArquivosDotHW::~ArquivosDotHW() {
}

