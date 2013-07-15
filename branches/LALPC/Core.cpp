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
#include "Core.h"
#include "variables.h"
#include <boost/lexical_cast.hpp>
#include "Componente/Componente.h"
#include <boost/graph/graphviz.hpp>
#include "grafo.h"
#include "Ligacao.h"
#include "ArquivosDotHW.h"
#include "Componente/op_sub_s.h"
#include "Componente/op_add_s.h"
#include "Componente/op_simple.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include "Componente/comp_ref.h"
#include "Componente/reg_op.h"
#include "Componente/delay_op.h"
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

Core::Core(SgProject *project) {
    this->project = project;
}

vector<string> Core::split(const string& s, const string& delim) {
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

//Imprime todos os componentes operacoes referencias e declaracao de variaveis
void Core::imprimeTodosComponentes() {
    cout<< "************************************************"<<  endl;
    cout<< "IMPRESSAO TODOS OS COMPONENTES DA LISTA"<<  endl;
    cout<< "************************************************"<<  endl;
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
        (*i)->imprime();
    }
    cout<< "************************************************"<<  endl;
}

void Core::identificaVariaveis() {
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
                SgInitializedName* cur_var    = isSgInitializedName(*i);
                
                if (cur_var != NULL){
                    ROSE_ASSERT(cur_var);
                    varID var(isSgInitializedName(cur_var));
                    if(var.isArrayType()){
                        block_ram* mem = new block_ram(cur_var);
                        this->ListaComp.push_back(mem);
                    }else{
                        reg_op* reg = new reg_op(cur_var);
                        this->ListaComp.push_back(reg);
                    }
                }         
            }
        }
    }   
}

void Core::identificaFor() {
    
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
                    
                    //Componente* comp = new Componente(cur_for);
                    counter* comp = new counter(cur_for);

                    this->ListaComp.push_back(comp);
                    //comp->imprime();
                    cout<<"#--Comp Counter: OK                           #"<<endl;
                    cout<<"# Iniciando processo expressao FOR            #"<<endl;
                    
                    //Corpo do Loop com as operacoes
                    SgStatement* loopBody       = cur_for->get_loop_body();
                    //SgStatement* loopBody1      = SageInterface::getLoopBody(cur_for);
                    
                    
                    Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(loopBody,V_SgNode); 
                    if (varLoopBody.size()==0) continue;
                    
                    for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                    {
                        
                        SgAssignOp* expStmt = isSgAssignOp(*ilb);
                        if(expStmt != NULL){
                            analisaExp(expStmt, NULL, false, "");
                        }
                    }
                    cout<<"# Iniciando processo expressao FOR: OK        #"<<endl;
                }         
            }
        }
    }    
}

void Core::analisaExp(SgNode *nodoAtual, SgNode* pai, bool debug,  const string& aux) {

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
        cout << "AUX: " << aux << endl;
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
            // <editor-fold defaultstate="collapsed" desc="DEBUG">

            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << filhoEsq->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << filhoEsq->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            
            analisaExp(filhoEsq, NULL, debug, "WE");
            analisaExp(filhoDir, filhoEsq, debug, aux);
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
        analisaExp(proxNodo, pai, debug, aux);
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
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            //Componente* comp = new Componente(expAdd);
            op_add_s* comp    = new op_add_s(expAdd);
            if(pai) comp->setPai(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug, aux);
            analisaExp(filhoDir, nodoAtual, debug, aux);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de SUBTRACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP SUB">
//    SgSubtractOp* expSub = isSgSubtractOp(nodoAtual);
//    if (expSub != NULL) {
//        SgNode* filhoEsq = isSgNode(expSub->get_lhs_operand_i());
//        SgNode* filhoDir = isSgNode(expSub->get_rhs_operand_i());
//        if (filhoEsq != NULL && filhoDir != NULL) {
//            // <editor-fold defaultstate="collapsed" desc="DEBUG">
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//
//            }
//
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//            }// </editor-fold>
//            Componente* comp = new Componente(expSub);
//            if(pai) comp->setPai(pai);
//            this->ListaComp.push_back(comp);
//            analisaExp(filhoEsq, nodoAtual, debug, aux);
//            analisaExp(filhoDir, nodoAtual, debug, aux);
//        }
//    }// </editor-fold>

    
    /*
     * Quando identificar operacao de DIVISAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP DIV">
//    SgDivideOp* expDiv = isSgDivideOp(nodoAtual);
//    if (expDiv != NULL) {
//        SgNode* filhoEsq = isSgNode(expDiv->get_lhs_operand_i());
//        SgNode* filhoDir = isSgNode(expDiv->get_rhs_operand_i());
//        if (filhoEsq != NULL && filhoDir != NULL) {
//            // <editor-fold defaultstate="collapsed" desc="DEBUG">
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//
//            }
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//            }// </editor-fold>
//
//            Componente* comp = new Componente(expDiv);
//            if(pai) comp->setPai(pai);
//            this->ListaComp.push_back(comp);
//            analisaExp(filhoEsq, nodoAtual, debug, aux);
//            analisaExp(filhoDir, nodoAtual, debug, aux);
//        }
//    }// </editor-fold>

    
    /*
     * Quando identificar operacao de MULTIPLICACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    // <editor-fold defaultstate="collapsed" desc="OP MULT">
//    SgMultiplyOp* expMul = isSgMultiplyOp(nodoAtual);
//    if (expMul != NULL) {
//        SgNode* filhoEsq = isSgNode(expMul->get_lhs_operand_i());
//        SgNode* filhoDir = isSgNode(expMul->get_rhs_operand_i());
//        if (filhoEsq != NULL && filhoDir != NULL) {
//            // <editor-fold defaultstate="collapsed" desc="DEBUG">
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//
//            }
//            if (debug) {
//                cout << "-------------------------" << endl;
//                cout << "      CHAMOU RECURSAO    " << endl;
//                cout << "-------------------------" << endl;
//                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
//                cout << "-------------------------" << endl;
//            }// </editor-fold>
//
//            Componente* comp = new Componente(expMul);
//            if(pai) comp->setPai(pai);
//            this->ListaComp.push_back(comp);
//            analisaExp(filhoEsq, nodoAtual, debug, aux);
//            analisaExp(filhoDir, nodoAtual, debug, aux);
//        }
//    }// </editor-fold>

    
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
                if (pai){
                        cout << "PAI:      " << pai->class_name() << endl;
                }
                cout << "-------------------------------" << endl;
                if (pai){
                    cout << "ARRAY:    " << arrName << "[ " << arrPos << " ]" << " ---> " << pai->class_name() << endl;
                }else{
                    cout << "ARRAY:    " << arrName << "[ " << arrPos << " ]" << endl;
                }
                cout << "-------------------------------" << endl;
            }// </editor-fold>
            //Componente* comp = new Componente(decArr);
            comp_ref* comp = new comp_ref(decArr, aux);
            if(pai) comp->setPai(pai);
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
        //Componente* comp = new Componente(decVar);
        comp_ref* comp = new comp_ref(decVar, aux);
        if(pai) comp->setPai(pai);
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
//    SgIntVal* valInt = isSgIntVal(nodoAtual);
//    if (valInt != NULL) {
//        Componente* comp = new Componente(valInt);
//        if(pai) comp->setPai(pai);
//        this->ListaComp.push_back(comp);
//        // <editor-fold defaultstate="collapsed" desc="DEBUG">
//        if (debug) {
//            cout << "-------------------------------" << endl;
//            cout << "INT VALOR:    " << valInt->get_valueString() << " ---> " << pai->class_name() << endl;
//            cout << "-------------------------------" << endl;
//        }// </editor-fold> 
//    }// </editor-fold>

}


//Durante o processo de criacao dos componentes, estes armazenam informacoes 
//de quem e o nodo PAI. Este passo vai preencher os atributos de ligacao dos 
//componentes de acordo com o nodo pai.
void Core::FinalizaComponentes(){

    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    
    int qtdLig = 0;
    
    //Processo de Ligacao SIMPLES (cria a ligacao disponivel na arvore AST gerada pelo ROSE)
    // <editor-fold defaultstate="collapsed" desc="Cria ligacoes conforme ROSE AST">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        //if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
        //cout<< "Impressao: " << (*i)->tipo_comp << endl;
        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" || (*j)->tipo_comp == "REG" || (*j)->tipo_comp == "MEM") continue;
            if ((*i)->node == (*j)->node) continue;

            if ((*i)->getPai() == (*j)->node) {
                std::string str = boost::lexical_cast<std::string>(qtdLig);
                
                Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                lig->setDestPort((*j)->getStringPortIN());
                lig->setOrigPort((*i)->getStringPortOUT());
                lig->setSize((*i)->getStringPortOUTSize());
                
                (*i)->addLigacao(lig);
                (*j)->addLigacao(lig);
                //(*i)->imprimeLigacoes();
                this->ListaLiga.push_back(lig);
                qtdLig++;
            }
        }
    }// </editor-fold>  
    
    //Passo para informar as referencias se durante o processo de criacao de 
    //variaveis tem valor inicial
    // <editor-fold defaultstate="collapsed" desc="Informacao Complementar REF">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        
        if ((*i)->tipo_comp == "REF") {
            
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == "REG" || (*j)->tipo_comp == "MEM") {
                    if ((*i)->getName() == (*j)->getName()) {
//                        cout<<"--------------------------"<<endl;
//                        cout<<(*i)->tipo_comp<<" - "<< (*i)->getName()<<endl;
//                        cout<<(*j)->tipo_comp<<" - "<< (*j)->getName()<<endl;
//                        cout<<"--------------------------"<<endl;
                        (*i)->setEInicializado((*j)->getEInicializado());
                        (*i)->setComponenteRef((*j));
//                        comp_ref* nodeRef = (comp_ref*)(*i);
//                        nodeRef->setComponenteRef((*j));
                    }
                }
            }
        }
    }// </editor-fold>
    
    
    //Processo de identificacao dos componentes CONTADORES e criar a ligacao
    //para as memorias 
    // <editor-fold defaultstate="collapsed" desc="Criar ligacoes entre memorias e contador">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM") continue;

        if ((*i)->tipo_comp == "CTD") {
            //cout<<"Contador usando indice na var: "<< (*i)->for_ctr_var <<endl;
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == "REG" || (*j)->tipo_comp == "MEM") continue;
                if ((*i)->node == (*j)->node) continue;

                if ((*j)->tipo_comp == "REF") {
                    if ((*j)->ref_var_index == (*i)->for_ctr_var) {
                        std::string str = boost::lexical_cast<std::string>(qtdLig);
                        Ligacao* lig = new Ligacao((*i), (*j)->getComponenteRef(), "s" + str);
                        lig->setOrigPort((*i)->getStringPortOUT());
                        lig->setDestPort("address");
                        lig->setSize((*i)->getStringPortOUTSize());
                        (*i)->addLigacao(lig);
                        (*j)->getComponenteRef()->addLigacao(lig);
                        this->ListaLiga.push_back(lig);
                        qtdLig++;
                        
                        //Verificar se e de gravacao
                        //caso verdadeiro tem que ligar o WE da memoria no STEP do contador
                        if((*j)->writeEnable){
                            std::string str = boost::lexical_cast<std::string>(qtdLig);
                            Ligacao* ligWE = new Ligacao((*i), (*j), "s" + str);
                            ligWE->setOrigPort("step");
                            ligWE->setDestPort("we");
                            ligWE->setSize("1");
                            (*i)->addLigacao(ligWE);
                            (*j)->getComponenteRef()->addLigacao(ligWE);
                            this->ListaLiga.push_back(ligWE);
                            qtdLig++;
                        }
                    }
                }
            }
        }
    }// </editor-fold> 
    
    
    //Processo responsavel por criar nomes dos componentes similar ao proposto
    //no LALP (VAR_op_add_VAR) isso ajuda a diferenciar cada ligacao
    // <editor-fold defaultstate="collapsed" desc="Criar nome componente OP">
    bool sair = false;
    while (sair == false) {
        sair = true;
        for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
            
            if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM") continue;
            if ((*i)->tipo_comp == "OPE") {
                
                string nome, aux = "";
                int incr_nome = 0;
                for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++) {
                    Componente* destino = (*k)->getDestino();
                    if ((*i)->node == destino->node) {
                        aux = (*k)->getOrigem()->getName();
                        //cout<< "---------------------"<<endl;
                        //cout<< "NODE: " << (*i)->node <<endl;
                        //cout<< "NOME: " << (*i)->getName() <<endl;
                        //cout<< "AUX:  " << aux <<endl;
                        //cout<< "---------------------"<<endl;
                        if (aux == "") {
                            sair = false;
                        } else if ((*i)->getName() == "") {
                            
                            op_add_s* node_op = (op_add_s*)(*i);
                            //op_add_s* node_op = (op_add_s*)(*i);
                            
                            if (incr_nome < 1) {
                                //TODO fazer os restantes das OPERACOES
                                //nome += aux + "_op_add_";
                                nome = aux +"_"+ node_op->getNomeCompVHDL();
                                (*k)->setDestPort("I0");
                                incr_nome++;
                            } else {
                                nome += "_"+aux;
                                (*i)->setName(nome);
                                (*k)->setDestPort("I1");
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
    }// </editor-fold>
    

    //Processo de Criacao de componentes de Delay
    //inicialmente estes vao entrar nas ligacoes incidentes nos componentes 
    //setados com WE
    // <editor-fold defaultstate="collapsed" desc="Cria componentes de Delays">
//    cout<< "-----------------------------------------------" <<endl;
//    cout<< "Processo de criacao de componentes de delay    " <<endl;
//    cout<< "Tam Lista Comp: "<<ListaComp.size()              <<endl;
//    cout<< "Tam Lista Liga: "<<ListaLiga.size()              <<endl;
//    cout<< "-----------------------------------------------" <<endl;
    list<Componente*> ListaCompAux;
    list<Ligacao*> ListaLigaAux;
    int qtdComp = ListaComp.size();
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM") continue;
        if ((*i)->writeEnable == true) {
            cout<< "-----------------------------------------------" <<endl;
            cout<< (*i)->getName() <<endl;
            cout<< "-----------------------------------------------" <<endl;
            //cout<< "Componente WE: " << (*i)->getName() <<endl;
            for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++) {
                //Componente* destino = (*k)->getDestino();
                //if ((*i)->node == (*k)->getDestino()->node) {
                if ((*i)->node == (*k)->getDestino()->node) {
                    //Nao pode ser a ligacao para a entrada da memoria
                    if ((*k)->getDestPort() != (*i)->getStringPortIN()) {
                        //cout<< "Ligacao: " << (*k)->getNome() <<endl;
                        //Aresta identificada

                        std::string str = boost::lexical_cast<std::string>(qtdComp);

                        //Componente* comp = new Componente(NULL, "DLY");
                        delay_op* comp = new delay_op(NULL);
                        string nome = "c" + str;
                        comp->setName(nome);

 
                        //CRIAR NOVA LIGACAO
                        str = boost::lexical_cast<std::string>(qtdLig);
                        Ligacao* newLig = new Ligacao(comp, (*i), "s" + str);
                        newLig->setDestPort(((*k)->getDestPort()));
                        newLig->setOrigPort("a_delayed");
                        newLig->setSize((*k)->getSize());
                        
                        //Adicionando as novas ligacoes no Delay
                        comp->addLigacao(newLig);
                        comp->addLigacao((*k));
                        comp->setDelayBits((*k)->getSize());
                        
                        //Inserindo na lista auxiliar
                        ListaLigaAux.push_back(newLig);
                        ListaCompAux.push_back(comp);

                        //EDITAR PARAMETRO LIGACAO ANTIGA 
                        (*k)->editDest(comp);
                        (*k)->setDestPort("a");
                        
                        //Excluir referencia da ligacao antiga
                        (*i)->removeLigacao((*k));

                        qtdComp++;
                        qtdLig++;
                        
                        //(*k) -> comp -> (*i) 
                        
                        //cout<< "Novo Comp: " << comp->getName()  <<endl;
                        //cout<< "Nova Liga: " << newLig->getNome()  <<endl;
                        //cout<< "" << endl;
                    }
                }
            }
        }
    }
    for (i = ListaCompAux.begin(); i != ListaCompAux.end(); i++) {
        this->ListaComp.push_back((*i));
    }
    for (k = ListaLigaAux.begin(); k != ListaLigaAux.end(); k++) {
        this->ListaLiga.push_back((*k));
    }
//    cout<< "-----------------------------------------------" <<endl;
//    cout<< "Tam Lista Comp: "<<ListaComp.size()              <<endl;
//    cout<< "Tam Lista Liga: "<<ListaLiga.size()              <<endl;
//    cout<< "-----------------------------------------------" <<endl;
//    cout<< "-----------------------------------------------" <<endl;
    // </editor-fold>
    
    
    //Passo que varre cada componente e todas suas ligacores para setar todas 
    //as portas conforme modelo VHDL
    // <editor-fold defaultstate="collapsed" desc="Percorre ligacoes e define as portas VHDL">
    
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM") continue;
        

        (*i)->finalizaPortasComp();
        
//        if ((*i)->tipo_comp == "CTD" || (*i)->tipo_comp == "DLY" || (*i)->tipo_comp == "OPE"){
//            cout<< (*i)->geraVHDLComp()<< endl;
//        }
        
    }// </editor-fold>
    

}

//Imprime componentes que serao utilizados no VHDL e todas as ligacoes geradas
void Core::imprimeAll(){
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"*********************************"<<endl;
    cout<<"COMPONENTES"<<endl;
    cout<<"Qtd: "<< this->ListaComp.size() <<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
        
        //cout << (*i)->node->class_name() << " - " << (*i)->tipo_comp << endl;
        //cout << (*i)->getName() << " - " << (*i)->tipo_comp << " - " << (*i)->node->class_name() << endl;
        cout << (*i)->getName() << " - " << (*i)->tipo_comp  << endl;
    }
    cout<<"*********************************"<<endl;
    cout<<"*********************************"<<endl;
    cout<<"LIGACOES"<<endl;
    cout<<"Qtd: "<< this->ListaLiga.size() <<endl;
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        cout<< (*k)->getNome() << " :: " << (*k)->getOrigem()->getName()<<":"<< (*k)->getOrigPort() << " -> "<< (*k)->getDestino()->getName()<<":"<< (*k)->getDestPort() <<endl;
    }
}

void Core::geraArquivosDotHW(){
    ArquivosDotHW *dot = new ArquivosDotHW(this->ListaComp, this->ListaLiga);
    dot->imprimeHWDOT();
    //dot->imprimeVHDL();
}

void Core::geraGrafo(){
//
//    SgGraph* g = new SgGraph("Demo graph");
//    
//    
//    //Efetuar contagem de nodos importantes para a geracao dos grafos.
//    //Nesse caso a declaracao de variaveis ou vetores e dispensavel, pois os 
//    //mesmos sao acessados pelas REFERENCIAS nas expressoes.
//    list<Componente*>::iterator i;
//    int qtd = 0;
//    string nome = "";
//    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
//        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
//        
//        qtd++;
//    }
//    
//
//    //CRIAR NODOS
//    SgGraphNode* nodes[qtd];
//    int pos = 0;
//    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
//        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
//        if ((*i)->tipo_comp == "REG" || (*i)->tipo_comp == "MEM" ) continue;
//        
//        if ((*i)->tipo_comp == "CTD"){
//            nome = (*i)->getName();
//        }
//        if ((*i)->tipo_comp == "OPE"){
//            nome = (*i)->getName();
//        }
//        if ((*i)->tipo_comp == "CON"){
//            nome = (*i)->getName();
//        }
//        if ((*i)->tipo_comp == "REF"){
//            nome = (*i)->getName();
//        }
//        
//        //Criando Node
//        SgGraphNode* nodeGraph = g->addNode(nome, (*i)->node);
//        nodes[pos] = nodeGraph;
//        pos++;
//    }
//    //fout << "}\n";
//    
//    //CRIAR ARESTAS
//    for(int i=0; i < qtd; i++){
//        for(int j=0; j < qtd; j++){
//            if (i < j){
//                Componente a = nodes[i];
//                Componente b = nodes[j];
//                
//                g->addEdge(nodes[i],nodes[j]);
//            }
//        }    
//    }
//    //GraphDotOutput(g);
//    
//    //Graph
//    
//    cout<< "numerdo de NODOS   " << g->numberOfGraphNodes()<< endl;
//    cout<< "numerdo de ARESTAS " << g->numberOfGraphEdges()<< endl;    
}

Core::~Core() {
}

