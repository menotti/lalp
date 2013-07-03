/* 
 * File:   ListaComponente.cpp
 * Author: Lucas Porto
 * 
 * Created on 23 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "ListaComponente.h"
#include "variables.h"
#include <boost/lexical_cast.hpp>
#include "Componente.h"
#include <boost/graph/graphviz.hpp>
#include "grafo.h"
#include "Ligacao.h"

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/kruskal_min_spanning_tree.hpp>
#include <iostream>
#include <fstream>

using namespace std;
using namespace SageInterface;
using namespace boost;
using std::stringstream;
using boost::lexical_cast;
using std::string;

ListaComponente::ListaComponente(SgProject *project) {
    this->project = project;
}

vector<string> ListaComponente::split(const string& s, const string& delim) {
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

void ListaComponente::imprimeTodosComponentes() {
    
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
        (*i)->imprime();
    }
}

void ListaComponente::identificaVariaveis() {
    SgProject *project = this->project;
    string nome = "";
    // For each source file in the project
    ROSE_ASSERT (project != NULL);
    SgFilePtrList & ptr_list = project->get_fileList();
    for (SgFilePtrList::iterator iter = ptr_list.begin(); iter!=ptr_list.end(); iter++)
    {
        SgFile* sageFile = (*iter);
        SgSourceFile * sfile = isSgSourceFile(sageFile);
        ROSE_ASSERT(sfile);
        SgGlobal *root = sfile->get_globalScope();
        SgDeclarationStatementPtrList& declList = root->get_declarations ();
        bool hasOpenMP= false; // flag to indicate if omp.h is needed in this file

        //For each function body in the scope
        for (SgDeclarationStatementPtrList::iterator p = declList.begin(); p != declList.end(); ++p) 
        {
            
            SgFunctionDeclaration *func = isSgFunctionDeclaration(*p);
            if (func == 0)  continue;
            SgFunctionDefinition *defn = func->get_definition();
            if (defn == 0)  continue;
            //ignore functions in system headers, Can keep them to test robustness
            if (defn->get_file_info()->get_filename()!=sageFile->get_file_info()->get_filename())
                continue;
            SgBasicBlock *body = defn->get_body();  
            // For each loop 
            
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(defn,V_SgInitializedName); 
            if (var.size()==0) continue;
            
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgInitializedName* cur_var = isSgInitializedName(*i);
                SgVariableDeclaration* varDec =  isSgVariableDeclaration(cur_var->get_parent());
                
                if (cur_var != NULL){
                    ROSE_ASSERT(cur_var);
                    Componente* comp = new Componente(cur_var);
                    this->ListaComp.push_back(comp);
                    //comp->imprime();
                    //cout<<container.size()<<endl;
                }         
            }
        }
    }   
}

void ListaComponente::identificaFor() {
    
    SgProject *project = this->project;
    string nome = "";
    // For each source file in the project
    ROSE_ASSERT (project != NULL);
    SgFilePtrList & ptr_list = project->get_fileList();
    for (SgFilePtrList::iterator iter = ptr_list.begin(); iter!=ptr_list.end(); iter++)
    {
        SgFile* sageFile = (*iter);
        SgSourceFile * sfile = isSgSourceFile(sageFile);
        ROSE_ASSERT(sfile);
        SgGlobal *root = sfile->get_globalScope();
        SgDeclarationStatementPtrList& declList = root->get_declarations ();
        bool hasOpenMP= false; // flag to indicate if omp.h is needed in this file

        //For each function body in the scope
        for (SgDeclarationStatementPtrList::iterator p = declList.begin(); p != declList.end(); ++p) 
        {
            
            SgFunctionDeclaration *func = isSgFunctionDeclaration(*p);
            if (func == 0)  continue;
            SgFunctionDefinition *defn = func->get_definition();
            if (defn == 0)  continue;
            //ignore functions in system headers, Can keep them to test robustness
            if (defn->get_file_info()->get_filename()!=sageFile->get_file_info()->get_filename())
                continue;
            SgBasicBlock *body = defn->get_body();  
            // For each loop 
            
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(defn,V_SgForStatement); 
            if (var.size()==0) continue;
            
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgForStatement* cur_for = isSgForStatement(*i);
                
                if (cur_for != NULL){
                    ROSE_ASSERT(cur_for);
                    
                    Componente* comp = new Componente(cur_for);
                    this->ListaComp.push_back(comp);
                    //comp->imprime();

                    
                    //Corpo do Loop com as operacoes
                    SgStatement* loopBody       = cur_for->get_loop_body();
                    //SgStatement* loopBody1      = SageInterface::getLoopBody(cur_for);
                    
                    
                    Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(loopBody,V_SgNode); 
                    if (varLoopBody.size()==0) continue;
                    
                    for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                    {
                        
                        SgAssignOp* expStmt = isSgAssignOp(*ilb);
                        if(expStmt != NULL){
                            analisaExp(expStmt, NULL, false);
                        }
                    }
                }         
            }
        }
    } 
    
}

void ListaComponente::analisaExp(SgNode *nodoAtual, SgNode* pai, bool debug) {

    // <editor-fold defaultstate="collapsed" desc="DEBUG">
    if (debug) {
        cout << "" << endl;
        cout << "-------------------------" << endl;
        cout << "         CHEGOU          " << endl;
        cout << "-------------------------" << endl;
        if (nodoAtual)
            cout << "ATUAL: " << nodoAtual->class_name() << endl;

        if (pai)
            cout << "PAI:        " << pai->class_name() << endl;

        cout << "-------------------------" << endl;
    }// </editor-fold>

    /*
     * Quando identificar ATRIBUICAO
     *
     */
    // <editor-fold defaultstate="collapsed" desc="ATRIBUICAO">
    SgAssignOp* expStmt = isSgAssignOp(nodoAtual);
    if (expStmt != NULL) {
        SgNode* filhoEsq = isSgNode(expStmt->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expStmt->get_rhs_operand_i());

        if (filhoEsq != NULL && filhoDir != NULL) {
            //O filho esquerdo pode ser uma REFERENCIA a uma VARIAVEL ou um ARRAY
            //neste caso tem q ser tratado neste passo inicial
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            SgPntrArrRefExp* decArr = isSgPntrArrRefExp(filhoEsq);
            if (decArr != NULL) {
                string arrName = "";
                string arrPos = "";
                SgVarRefExp* fe = isSgVarRefExp(decArr->get_lhs_operand_i());
                SgVarRefExp* fd = isSgVarRefExp(decArr->get_rhs_operand_i());
                if (fe != NULL && fd != NULL) {
                    arrName = fe->get_symbol()->get_name().getString();
                    arrPos = fd->get_symbol()->get_name().getString();
                    //filhoEsq = fe->get_symbol()->get_symbol_basis();
                }
            }
            //TODO - FAZER PARTE DE ADD NA LISTA

            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << filhoEsq->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            Componente* comp = new Componente(filhoEsq);
            this->ListaComp.push_back(comp);
            analisaExp(filhoDir, filhoEsq, debug);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar CAST_EXP
     * neste caso ignora e passa para o NODO abaixo
     */
    // <editor-fold defaultstate="collapsed" desc="NODO CAST - IGNORADO">
    SgCastExp* castExp = isSgCastExp(nodoAtual);
    if (castExp != NULL) {
        SgNode* proxNodo = isSgNode(castExp->get_operand_i());
        analisaExp(proxNodo, pai, debug);
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de SOMA
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP ADD">
    SgAddOp* expAdd = isSgAddOp(nodoAtual);
    if (expAdd != NULL) {
        SgNode* filhoEsq = isSgNode(expAdd->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expAdd->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }

            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            Componente* comp = new Componente(expAdd);
            comp->ligado_Em(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug);
            analisaExp(filhoDir, nodoAtual, debug);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de SUBTRACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP SUB">
    SgSubtractOp* expSub = isSgSubtractOp(nodoAtual);
    if (expSub != NULL) {
        SgNode* filhoEsq = isSgNode(expSub->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expSub->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }

            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            Componente* comp = new Componente(expSub);
            comp->ligado_Em(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug);
            analisaExp(filhoDir, nodoAtual, debug);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de DIVISAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP DIV">
    SgDivideOp* expDiv = isSgDivideOp(nodoAtual);
    if (expDiv != NULL) {
        SgNode* filhoEsq = isSgNode(expDiv->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expDiv->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>

            Componente* comp = new Componente(expDiv);
            comp->ligado_Em(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug);
            analisaExp(filhoDir, nodoAtual, debug);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de MULTIPLICACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP MULT">
    SgMultiplyOp* expMul = isSgMultiplyOp(nodoAtual);
    if (expMul != NULL) {
        SgNode* filhoEsq = isSgNode(expMul->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expMul->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>

            Componente* comp = new Componente(expMul);
            comp->ligado_Em(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug);
            analisaExp(filhoDir, nodoAtual, debug);
        }
    }// </editor-fold>

    
    //**************************************************************************
    //ABAIXO AS FOLHAS DAS ARVORES, NESTE CASO NAO CHAMA MAIS A RECURSAO
    //**************************************************************************
    /*
     * Quando identificar Pntr ARRAY
     * este nodo mostra que identificou um array que 'e utilizado na 
     * expressao, neste caso pode-se pegar os dois filhos deste nodo
     * pois os mesmos ja sao folhas da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="REFENRENCIA ARRAY">
    SgPntrArrRefExp* decArr = isSgPntrArrRefExp(nodoAtual);
    if (decArr != NULL) {
        string arrName = "";
        string arrPos = "";
        SgVarRefExp* fe = isSgVarRefExp(decArr->get_lhs_operand_i());
        SgVarRefExp* fd = isSgVarRefExp(decArr->get_rhs_operand_i());
        if (fe != NULL && fd != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            arrName = fe->get_symbol()->get_name().getString();
            arrPos = fd->get_symbol()->get_name().getString();

            if (debug) {
                cout << "-------------------------------" << endl;
                cout << "      DENTRO DO COMPONENTE     " << endl;
                cout << "-------------------------------" << endl;
                cout << "ATUAL:    " << nodoAtual->class_name() << endl;
                cout << "PAI:      " << pai->class_name() << endl;
                cout << "-------------------------------" << endl;
                cout << "ARRAY:    " << arrName << "[ " << arrPos << " ]" << " ---> " << pai->class_name() << endl;
                cout << "-------------------------------" << endl;
            }// </editor-fold>
            Componente* comp = new Componente(decArr);
            comp->ligado_Em(pai);
            this->ListaComp.push_back(comp);
        }
    }// </editor-fold>

 
    /*
     * Quando identificar uma REFERENCIA a uma VARIAVEL
     * este nodo mostra que identificou uma variavel que 'e utilizado na 
     * expressao.
     */
    // <editor-fold defaultstate="collapsed" desc="REFENRENCIA VARIAVEL">
    SgVarRefExp* decVar = isSgVarRefExp(nodoAtual);
    if (decVar != NULL) {
        string varNome = "";
        string arrPos = "";
        varNome = decVar->get_symbol()->get_name().getString();
        Componente* comp = new Componente(decVar);
        comp->ligado_Em(pai);
        this->ListaComp.push_back(comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (debug) {
            cout << "-------------------------------" << endl;
            cout << "VAR: " << varNome << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold>   
    }// </editor-fold>

   
    /*
     * Quando identificar um valor INTEIRO na expressao.
     */
    // <editor-fold defaultstate="collapsed" desc="CONSTANTE INTEIRA">
    SgIntVal* valInt = isSgIntVal(nodoAtual);
    if (valInt != NULL) {
        Componente* comp = new Componente(valInt);
        comp->ligado_Em(pai);
        this->ListaComp.push_back(comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (debug) {
            cout << "-------------------------------" << endl;
            cout << "INT VALOR:    " << valInt->get_valueString() << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold> 
    }// </editor-fold>

}

//Durante o processo de criacao dos componentes, estes armazenam informacoes 
//de quem e o nodo PAI. Este passo vai preencher os atributos de ligacao dos 
//componentes de acordo com o nodo pai.
void ListaComponente::FinalizaComponentes(){

    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    
    int qtdLig = 0;
    
    //Processo de Ligacao SIMPLES (cria a ligacao disponivel na arvore AST gerada pelo ROSE)
    cout<<"Entrou no processo de finalizacao dos COMPONENTES"<<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        //if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
        //cout<< "Impressao: " << (*i)->tipo_comp << endl;
        for(j=this->ListaComp.begin(); j != this->ListaComp.end(); j++){
            if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" || (*j)->tipo_comp == "REG" || (*j)->tipo_comp == "MEM"  ) continue;
            if ((*i)->node == (*j)->node ) continue;
            
            if( (*i)->getPai() == (*j)->node ){    
                std::string str = boost::lexical_cast<std::string>(qtdLig);
                Ligacao* lig = new Ligacao((*i), (*j), "s"+str);
                (*i)->addLigacao(lig);
                //(*i)->imprimeLigacoes();
                this->ListaLiga.push_back(lig);
                qtdLig++;
            }
        }
    }
    
    
    //Processo de identificacao dos componentes CONTADORES e criar a ligacao
    //para as memorias 
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
        
        if ((*i)->tipo_comp == "CTD"){
            //cout<<"Contador usando indice na var: "<< (*i)->for_ctr_var <<endl;
            for(j=this->ListaComp.begin(); j != this->ListaComp.end(); j++){
                if ((*j)->tipo_comp == "REG" || (*j)->tipo_comp == "MEM") continue;
                if ((*i)->node == (*j)->node ) continue;
                
                if ((*j)->tipo_comp == "REF"){
                    if ((*j)->ref_var_index == (*i)->for_ctr_var){
                        std::string str = boost::lexical_cast<std::string>(qtdLig);
                        Ligacao* lig = new Ligacao((*i), (*j), "s"+str);
                        (*i)->addLigacao(lig);
                        this->ListaLiga.push_back(lig);
                        qtdLig++;
                    }
                }
            }
        }
    }
    
    
    
    //Processo responsavel por criar nomes dos componentes similar ao proposto
    //no LALP (VAR_op_add_VAR) isso ajuda a diferenciar cada ligacao
    bool sair = false;
    while (sair == false){
        sair = true;
        for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
            if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
            if ((*i)->tipo_comp == "OPE"){
                string nome, aux= "";
                int incr_nome= 0;
                for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
                    Componente* destino = (*k)->getDestino();
                    if((*i)->node == destino->node){
                        aux = (*k)->getOrigem()->getName();
                        //cout<< "---------------------"<<endl;
                        //cout<< "NODE: " << (*i)->node <<endl;
                        //cout<< "NOME: " << (*i)->getName() <<endl;
                        //cout<< "AUX:  " << aux <<endl;
                        //cout<< "---------------------"<<endl;
                        if (aux == "") {
                            sair = false;
                        }else if((*i)->getName() == ""){
                            if (incr_nome < 1){
                                //TODO fazer os restantes das OPERACOES
                                nome += aux+"_op_add_";
                                incr_nome++;
                            }else{
                                nome += aux;
                                (*i)->setName(nome);
                                //cout<< "---------------------"<<endl;
                                //cout<< nome <<endl;
                                //cout<< (*k)->getOrigem()->getName() <<endl;
                                //cout<< "---------------------"<<endl;
                            } 
                        }
                        //cout<< "SAIR: "<< sair <<endl;
                        //cout<< "---------------------"<<endl;
                    }
                }    
            }            
        }  
    }
    
    
 
    //CRIA ARQUIVO .DOT
    std::ofstream fout("comp.dot");
    fout << "digraph diagram {\n";
    fout << "// Components (Nodes) \n";
    //cout<<"------------------------------------"<<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;  
        
        fout << (*i)->imprimeDOT();
       // cout << (*i)->imprimeDOT();
    }
    fout << "// Signals (Edges) \n";
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        fout << (*k)->imprimeDot();
        //cout << (*k)->imprimeDot();
    }
    fout << "}\n";
    //cout<<"------------------------------------"<<endl;
    
    
    cout<<"Saiu do processo de finalizacao dos COMPONENTES"<<endl;
    
}
    
void ListaComponente::imprimeAll(){
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"*********************************"<<endl;
    cout<<"COMPONENTES"<<endl;
    cout<<"Qtd: "<< this->ListaComp.size() <<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
        
        //cout << (*i)->node->class_name() << " - " << (*i)->tipo_comp << endl;
        cout << (*i)->getName() << " - " << (*i)->tipo_comp << " - " << (*i)->node->class_name() << endl;
    }
    cout<<"*********************************"<<endl;
    cout<<"*********************************"<<endl;
    cout<<"LIGACOES"<<endl;
    cout<<"Qtd: "<< this->ListaLiga.size() <<endl;
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        cout<< (*k)->getOrigem()->getName()<< " -> "<< (*k)->getDestino()->getName() <<endl;
    }
}
void ListaComponente::geraGrafo(){
    /**
    //SgGraph* g = new SgGraph("Demo graph");
    SgGraph* g = new SgGraph("Demo graph");
    
    
    //Efetuar contagem de nodos importantes para a geracao dos grafos.
    //Nesse caso a declaracao de variaveis ou vetores e dispensavel, pois os 
    //mesmos sao acessados pelas REFERENCIAS nas expressoes.
    list<Componente>::iterator i;
    int qtd = 0;
    string nome = "";
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i).tipo_comp == "REG" || (*i).tipo_comp == "MEM" ) continue;
        
        qtd++;
    }
    
    //CRIA ARQUIVO .DOT
    //std::ofstream fout("comp->dot");
    
    //fout << "digraph diagram {\n";

    //CRIAR NODOS
    SgGraphNode* nodes[qtd];
    int pos = 0;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
        if ((*i).tipo_comp == "REG" || (*i).tipo_comp == "MEM" ) continue;
        
        if ((*i).tipo_comp == "CTD"){
            nome = "CONTADOR: "+(*i).for_ctr_var;
            //fout << (*i).imprimeDOT();
        }
        if ((*i).tipo_comp == "OPE"){
            nome = "OPERACAO: "+(*i).tipo_comp;
        }
        if ((*i).tipo_comp == "CON"){
            nome = "CONSTANTE: "+(*i).cons_tipo+" VALOR "+(*i).valor;
        }
        if ((*i).tipo_comp == "REF"){
            nome = "REFERENCIA: "+(*i).ref_var_nome;
        }
        
        //Criando Node
        SgGraphNode* nodeGraph = g->addNode(nome, (*i).node);
        nodes[pos] = nodeGraph;
        pos++;
    }
    //fout << "}\n";
    
    //CRIAR ARESTAS
    for(int i=0; i < qtd; i++){
        for(int j=0; j < qtd; j++){
            if (i < j){
                Componente a = nodes[i];
                Componente b = nodes[j];
                
                g->addEdge(nodes[i],nodes[j]);
            }
        }    
    }
    //GraphDotOutput(g);
    
    //Graph
    
    cout<< "numerdo de NODOS   " << g->numberOfGraphNodes()<< endl;
    cout<< "numerdo de ARESTAS " << g->numberOfGraphEdges()<< endl;
    
    */
    
}

ListaComponente::~ListaComponente() {
}

