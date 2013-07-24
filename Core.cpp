/* 
 * File:   ListaComponente.cpp
 * Author: Lucas Porto
 * 
 * Created on 23 de Junho de 2013, 10:07
 */
#include "header/meuHeader.h"

#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "Core.h"
#include "Componente/Componente.h"
#include "Componente/op_sub_s.h"
#include "Componente/op_add_s.h"
#include "Componente/op_simple.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include "Componente/comp_ref.h"
#include "Componente/reg_op.h"
#include "Componente/delay_op.h"
#include "Aux/FuncoesAux.h"
#include "ArquivosDotHW.h"
#include <iostream>
#include <fstream>


using namespace std;
using std::stringstream;
using std::string;

Core::Core(SgProject* project) {
    this->project = project;
    cout<<"Entrou no construtor com sucesso"<<endl;
}

void Core::identificaReturn() {
    SgProject *project = this->project;

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
            // For each loop 
            
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(defn,V_SgReturnStmt); 
            if (var.size()==0) continue;
            
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgReturnStmt* cur_var   = isSgReturnStmt(*i);
                              
                
                Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgVarRefExp); 
                if (var2.size()==0) continue;

                for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
                {
                    SgVarRefExp* decVar = isSgVarRefExp((*j));
                    string varNome = decVar->get_symbol()->get_name().getString();
                    cout<<"RETORNO "<< varNome << endl;
                }
            }
        }
    }   
}

void Core::identificaVariaveis() {
    SgProject *project = this->project;

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
 
            // For each loop 
            
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(defn,V_SgForStatement); 
            if (var.size()==0) continue;
            
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgForStatement* cur_for = isSgForStatement(*i);
                
                if (cur_for != NULL){
                    ROSE_ASSERT(cur_for);
                    
                    counter* comp = new counter(cur_for);
                    this->ListaComp.push_back(comp);
                    
                    cout<<"#--Comp Counter: OK                           #"<<endl;
                    cout<<"# Iniciando processo expressao FOR            #"<<endl;
                    
                    //Corpo do Loop com as operacoes
                    SgStatement* loopBody       = cur_for->get_loop_body();                    
                    
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
    //     <editor-fold defaultstate="collapsed" desc="OP SUB">
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
    //Ligacao* reset = new 
    int qtdLig = 0;

    //Passo para informar as referencias se durante o processo de criacao de 
    //variaveis tem valor inicial
    // <editor-fold defaultstate="collapsed" desc="Informacao Complementar REF">
//    cout<<"--------------------------"<<endl;
//    cout<<"IDENTIFICACAO DOS COMP REF"<<endl;
//    cout<<"--------------------------"<<endl;
    cout<<"--Finalizando comp REF"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REF) {
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) {
                    if ((*i)->getName() == (*j)->getName()) {
                        (*i)->setEInicializado((*j)->getEInicializado());
                        (*i)->setComponenteRef((*j));
                    }
                }
            }
        }
    }
    cout<<"--Finalizando comp REF: OK"<<endl;
    // </editor-fold>
    
    
    //Processo de Ligacao SIMPLES (cria a ligacao disponivel na arvore AST gerada pelo ROSE)
    // <editor-fold defaultstate="collapsed" desc="Cria ligacoes conforme ROSE AST">
    cout<<"--Criando ligacoes basicas"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*i)->tipo_comp ==  CompType::REG || (*i)->tipo_comp == CompType::MEM || (*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
            if ((*i)->node == (*j)->node) continue;

            if ((*i)->getPai() == (*j)->node) {
                string str = FuncoesAux::IntToStr(qtdLig);
                
                //CRIAR LIGACAO
                Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                lig->setPortDestino((*j)->getPortDataInOut("IN"));
                lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                lig->setTipo((*i)->getPortDataInOut("OUT")->getType());
                
                //INFORMAR CADA PORTA QUEM E SUA LIGACAO
                (*j)->getPortDataInOut("IN")->setLigacao(lig->getNome());
                (*i)->getPortDataInOut("OUT")->setLigacao(lig->getNome());
                
                //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
                (*i)->addLigacao(lig);
                (*j)->addLigacao(lig);
                
                //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                this->ListaLiga.push_back(lig);
                qtdLig++;
            }
        }
    }
    cout<<"--Criando ligacoes basicas: OK"<<endl;
    // </editor-fold>    
    
    
    //Processo de identificacao dos componentes CONTADORES e criar a ligacao
    //para as memorias 
    // <editor-fold defaultstate="collapsed" desc="Criar ligacoes entre memorias e contador">
    cout<<"--Criando novas ligacoes do Contador"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->tipo_comp == CompType::CTD) {
            
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
                if ((*i)->node == (*j)->node) continue;
                
                if ((*j)->tipo_comp == CompType::REF) {
                    if ((*j)->ref_var_index == (*i)->for_ctr_var) {
                        
                        //CRIAR NOVA LIGACAO
                        string str = FuncoesAux::IntToStr(qtdLig);
//                        Ligacao* lig = new Ligacao((*i), (*j)->getComponenteRef(), "s" + str);
                        Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                        lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                        lig->setPortDestino((*j)->getPortOther("address"));
                        lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                        lig->setTipo((*i)->getPortDataInOut("OUT")->getType());
                        
                        //ADICIONAR LIGACAO NA PORTA                        
                        lig->getPortDestino()->setLigacao(lig->getNome());
                        lig->getPortOrigem()->setLigacao(lig->getNome());
                        
                        //ADICIONAR LIGACAO AOS COMPONENTES
                        (*i)->addLigacao(lig);
                        (*j)->addLigacao(lig);

                        //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                        this->ListaLiga.push_back(lig);
                        qtdLig++;
                        
                        //Verificar se e de gravacao
                        //caso verdadeiro tem que ligar o WE da memoria no STEP do contador
                        if((*j)->writeEnable){
//                            //CRIAR NOVA LIGACAO
                            string str = FuncoesAux::IntToStr(qtdLig);
//                            Ligacao* ligWE = new Ligacao((*i), (*j)->getComponenteRef(), "s" + str);
                            Ligacao* ligWE = new Ligacao((*i), (*j), "s" + str);
                            ligWE->setPortOrigem((*i)->getPortOther("step"));
                            ligWE->setPortDestino((*j)->getPortOther("we"));
                            ligWE->setWidth((*i)->getPortOther("step")->getWidth());
                            ligWE->setTipo((*i)->getPortOther("step")->getType());
                            
                            //ADICIONAR NOME LIGACAO NA PORTA
                            ligWE->getPortDestino()->setLigacao(ligWE->getNome());
                            ligWE->getPortOrigem()->setLigacao(ligWE->getNome());
                            
                            //ADICIONAR LIGACAO NA PORTA
                            (*i)->addLigacao(ligWE);
                            (*j)->addLigacao(ligWE);
                            
                            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                            this->ListaLiga.push_back(ligWE);
                            qtdLig++;
                        }
                    }
                }
            }
        }
    }
    cout<<"--Criando novas ligacoes do Contador: OK"<<endl;
    // </editor-fold> 
    
    
    //Processo responsavel por criar nomes dos componentes similar ao proposto
    //no LALP (VAR_op_add_VAR) isso ajuda a diferenciar cada ligacao
    // <editor-fold defaultstate="collapsed" desc="Criar nome componente OP">
    bool sair = false;
    while (sair == false) {
        sair = true;
        for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
            
            if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
            if ((*i)->tipo_comp == CompType::OPE) {
                
                string nome, aux = "";
                int incr_nome = 0;
                for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++) {
                    Componente* destino = (*k)->getDestino();
                    
                    if ((*i)->node == destino->node) {
                        aux = (*k)->getOrigem()->getName();

                        if (aux == "") {
                            sair = false;
                        } else if ((*i)->getName() == "") {
                            
                            op_add_s* node_op = (op_add_s*)(*i);
                            
                            if (incr_nome < 1) {
                                nome = aux +"_"+ node_op->getNomeCompVHDL();
                                (*k)->setPortDestino((*i)->getPortOther("I0"));
                                
                                //ADICIONAR NOME LIGACAO NA PORTA
                                (*k)->getPortDestino()->setLigacao((*k)->getNome());
                                incr_nome++;
                            } else {
                                nome += "_"+aux;
                                (*i)->setName(nome);
                                (*k)->setPortDestino((*i)->getPortOther("I1"));
                                
                                //ADICIONAR NOME  LIGACAO NA PORTA
                                (*k)->getPortDestino()->setLigacao((*k)->getNome());
                            }
                        }
                    }
                }
            }
        }
    }// </editor-fold>
    

    //Processo de Criacao de componentes de Delay
    //inicialmente estes vao entrar nas ligacoes incidentes nos componentes 
    //setados com WE
    // <editor-fold defaultstate="collapsed" desc="Cria componentes de Delays">
    list<Componente*> ListaCompAux;
    list<Ligacao*> ListaLigaAux;
    int qtdComp = ListaComp.size();
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->writeEnable) {
            for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++) {
                
                if ((*i) == (*k)->getDestino()) {
                    //Nao pode ser a ligacao para a entrada da memoria
                    if ((*k)->getPortDestino() != (*i)->getPortDataInOut("IN")) {

                        std::string str = FuncoesAux::IntToStr(qtdComp);

                        delay_op* comp = new delay_op(NULL);
                        string nome = "c" + str;
                        comp->setName(nome);
                        comp->getPortDataInOut("IN")->setWidth((*k)->getWidth());
                        comp->getPortDataInOut("OUT")->setWidth((*k)->getWidth());
 
                        //CRIAR NOVA LIGACAO
                        str = FuncoesAux::IntToStr(qtdLig);
                        Ligacao* newLig = new Ligacao(comp, (*i), "s" + str);
                        newLig->setPortDestino(((*k)->getPortDestino()));
                        newLig->setPortOrigem(comp->getPortDataInOut("OUT"));
                        newLig->setWidth((*k)->getWidth());
                        newLig->setTipo(comp->getPortDataInOut("OUT")->getType());
                        
                        //ADICIONAR NOME LIGACAO NA PORTA
                        newLig->getPortDestino()->setLigacao(newLig->getNome());
                        newLig->getPortOrigem()->setLigacao(newLig->getNome());
                        
                        //Adicionando as novas ligacoes no Delay
                        comp->addLigacao(newLig);
                        comp->addLigacao((*k));
                        comp->setDelayBits((*k)->getWidth());
                        
                        //Inserindo na lista auxiliar
                        ListaLigaAux.push_back(newLig);
                        ListaCompAux.push_back(comp);

                        //EDITAR PARAMETRO LIGACAO ANTIGA 
                        (*k)->editDest(comp);
                        (*k)->setPortDestino(comp->getPortDataInOut("IN"));
                        
                        //ADICIONAR LIGACAO NA PORTA
                        (*k)->getPortDestino()->setLigacao((*k)->getNome());
                        
                        //Excluir referencia da ligacao antiga
                        (*i)->removeLigacao((*k));
                        (*i)->addLigacao(newLig);
                        qtdComp++;
                        qtdLig++;
                    }
                }
            }
        }
    }
    //Lista auxliar foi necessária pois para definir o nome dos comp do tipo
    //DLY foi utilizado a quantidade de comp dentro da LISTA COMP.  Neste caso
    //a utilizacão "lista.size()" estava entrando em LOOP sem a utilizacao da 
    //lista aux.
    for (i = ListaCompAux.begin(); i != ListaCompAux.end(); i++) {
        this->ListaComp.push_back((*i));
    }
    for (k = ListaLigaAux.begin(); k != ListaLigaAux.end(); k++) {
        this->ListaLiga.push_back((*k));
    }
    // </editor-fold>
    
    
    //Setar todoas as portas CLK e RESET
    // <editor-fold defaultstate="collapsed" desc="Setar Portas CLK e RESET">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REF) continue;
        if ((*i)->getPortOther("clk") != NULL)(*i)->getPortOther("clk")->setLigacao("\\clk\\");
        if ((*i)->getPortOther("reset") != NULL)(*i)->getPortOther("reset")->setLigacao("\\reset\\");
    }// </editor-fold>
    
    
    //Criar Componentes AUX (INIT, DONE, ETC)
//    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp == CompType::CTD){
//            
//            Componente* init = new Componente(NULL, "INIT");
//            Ligacao* newLig = new Ligacao(init, (*i), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
//            newLig->setPortDestino(((*i)->getPortOther("clk_en")));
//            newLig->setPortOrigem(init->getPortDataInOut("OUT"));
//            newLig->setWidth((*k)->getWidth());
//            
//            //ADICIONAR NOME LIGACAO NA PORTA
//            newLig->getPortDestino()->setLigacao(newLig->getNome());
//            newLig->getPortOrigem()->setLigacao(newLig->getNome());
//            
//            //ADICIONAR LIGACAO NO COMPONENTE
//            (*i)->addLigacao(newLig);
//            init->addLigacao(newLig);
//            
////    Componente iput = new Componente(NULL, "INPUT");
////    Componente term = new Componente(NULL, "TERMINATION");
////    Componente done = new Componente(NULL, "DONE");
////    Componente done = new Componente(NULL, "RESULT");
//            break;
//        }
//    }
    
    
}

////Imprime componentes que serao utilizados no VHDL e todas as ligacoes geradas
void Core::imprimeAll(){
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"*********************************"<<endl;
    cout<<"COMPONENTES"<<endl;
    cout<<"Qtd: "<< this->ListaComp.size() <<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM ) continue;
//        if ((*i)->tipo_comp != CompType::CTD) continue;
        cout<< "--------------------"<< endl;
        cout<< "COMP: " <<(*i)->getName()<< endl;
        cout<< "--------------------" << endl;
        cout<< "## Portas" << endl;
        cout<< (*i)->imprimePortas() << endl;
        cout<< "" << endl;
        cout<< "## Ligacões" << "QTD: "<< (*i)->getQtdLig() << endl;
        cout<< (*i)->imprimeLigacoes() << endl;
        cout<< "--------------------" << endl;
        cout<< "--------------------" << endl;
        cout<< (*i)->geraCompVHDL() << endl;
        cout<< "--------------------" << endl;
    }
}

void Core::geraArquivosDotHW(){
    ArquivosDotHW *dot = new ArquivosDotHW(this->ListaComp, this->ListaLiga);
    dot->imprimeHWDOT();
    dot->imprimeVHDL();
}


Core::~Core() {
}

