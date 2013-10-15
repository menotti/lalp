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
#include "Componente/op_mult_s.h"
#include "Componente/op_add_s.h"
#include "Componente/op_simple.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include "Componente/comp_ref.h"
#include "Componente/reg_op.h"
#include "Componente/add_reg_op_s.h"
#include "Componente/delay_op.h"
#include "Componente/if_gt_op_s.h"
#include "Componente/comp_aux.h"
#include "Aux/FuncoesAux.h"
#include "ArquivosDotHW.h"
#include <iostream>
#include <fstream>
#include "ProcessGraph.h"

using namespace std;
using namespace boost;
using std::stringstream;
using std::string;

Core::Core(SgProject* project) {
    this->debug = true;
    this->project = project;
    this->maxSchedulingTime = 0;
    
    this->identificaVariaveis();
    this->identificaFor();
    this->FinalizaComponentes();
    this->identificaReturn();
    
    //Processo de Schedulling
    this->detectBackwardEdges();
    this->ALAP();
    this->balanceAndSyncrhonize();
    
    this->setClkReset();
}

void Core::identificaReturn() {
    cout<<"#--Ident Return:                              #"<<endl;
    
    
    SgProject *project = this->project;
    string varRetorno;
    int    numLinha = 0;
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
                numLinha = cur_var->get_file_info()->get_line();     
                
                Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgVarRefExp); 
                if (var2.size()==0) continue;

                for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
                {
                    SgVarRefExp* decVar = isSgVarRefExp((*j));
                    varRetorno = decVar->get_symbol()->get_name().getString();
                }
            }
        }
    }
    
    if(numLinha > 0){
        list<Componente*>::iterator i;
        for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
            if ((*i)->tipo_comp != CompType::REF) continue;
            if ((*i)->getName() == varRetorno){
                
                comp_aux* comp_return = new comp_aux(NULL,"RESULT");
                comp_return->setName("result");
                comp_return->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                comp_return->setNumLinha(numLinha);

                //LIGACAO
                Ligacao* newLig = new Ligacao((*i), comp_return, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                newLig->setPortDestino(comp_return->getPortDataInOut("IN"));
                newLig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                newLig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                newLig->setTipo((*i)->getPortDataInOut("OUT")->getType());

                //ADICIONAR NOME LIGACAO NA PORTA
                newLig->getPortDestino()->setLigacao(newLig->getNome());
                newLig->getPortOrigem()->setLigacao(newLig->getNome());

                //ADICIONAR LIGACAO NO COMPONENTE
                (*i)->addLigacao(newLig);
                comp_return->addLigacao(newLig);

                //ADD LISTAS
                this->ListaLiga.push_back(newLig);
//                this->ListaComp.push_back(comp_return);
                this->addComponent(comp_return);
                cout<<"  Ident Return na linha: "<<numLinha<<endl;
            }
        }
    }
    cout<<"#--Ident Return: OK                           #"<<endl;
}

void Core::identificaVariaveis() {
    cout<<"#--Ident Variavei:                            #"<<endl;
    
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
                        mem->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
//                        this->ListaComp.push_back(mem);
                        this->addComponent(mem);
                        this->updateBlockRam(cur_var, mem);
                        mem->setNumLinha(cur_var->get_file_info()->get_line());   
                        if(this->debug){
                            cout<<" - Array: "<<mem->getName()<<endl;
                        }
                    }else{
                        reg_op* reg = new reg_op(cur_var);
                        reg->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
//                        this->ListaComp.push_back(reg);
                        this->addComponent(reg);
                        this->updateRegister(cur_var, reg);
                        reg->setNumLinha(cur_var->get_file_info()->get_line()); 
                        if(this->debug){
                            cout<<" - Var: "<<reg->getName()<<endl;
                        }
                    }
                }         
            }
        }
    }
    cout<<"#--Ident Variavei: OK                         #"<<endl;
}

void Core::identificaFor() {
    cout<<"#--Comp Counter:                              #"<<endl;
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
                    comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
//                    this->ListaComp.push_back(comp);                    
                    this->addComponent(comp);                    
                    this->updateCounter(cur_for, comp);
                    comp->setNumLinha(cur_for->get_file_info()->get_line());
                    
                    cout<<"#--Comp Counter: OK                           #"<<endl;
                    cout<<"# Iniciando processo expressao FOR            #"<<endl;
                    
                    //Corpo do Loop com as operacoes
                    SgStatement* loopBody       = cur_for->get_loop_body();                    
                    
                    Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(loopBody,V_SgNode); 
                    if (varLoopBody.size()==0) continue;
                    cout<<"buscando expressões internas no for"<<endl;
                    for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                    {
                        if(isSgExprStatement(*ilb)||isSgBasicBlock(*ilb)||isSgVarRefExp(*ilb)||isSgMultiplyOp(*ilb)||isSgPntrArrRefExp(*ilb)||isSgAddOp(*ilb)) continue;

                        SgNode* expStmt = isSgNode(*ilb);
                        cout<< "NODOS INTERNOS BODY FOR: "<< expStmt->class_name() << endl;
                        if(expStmt != NULL){
                            
                            analisaExp(expStmt, NULL, "");
                            break;
                        }
                    }
                    cout<<"# Iniciando processo expressao FOR: OK        #"<<endl;
                }         
            }
        }
    }    
}

Componente* Core::analisaExp(SgNode *nodoAtual, SgNode* pai, const string& aux) {
    Componente* compReturn;
    // <editor-fold defaultstate="collapsed" desc="DEBUG">
    if (this->debug) {
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
    
    SgExprStatement* sgExpEst =  isSgExprStatement(nodoAtual);
    if (sgExpEst != NULL) {
        SgNode* proxNodo = isSgNode(sgExpEst->get_expression());
        analisaExp(proxNodo, pai, aux);
    }
    
    SgBasicBlock* sgBasic =  isSgBasicBlock(nodoAtual);
    if (sgExpEst != NULL) {
        SgNode* proxNodo = isSgNode(sgBasic);
        analisaExp(proxNodo, pai, aux);
    }
    
    
    /*
     * Quando identificar ATRIBUICAO
     *
     */
    // <editor-fold defaultstate="collapsed" desc="ATRIBUICAO">
    SgAssignOp* sgAssignOp = isSgAssignOp(nodoAtual);
    if (sgAssignOp != NULL) {
        SgNode* filhoEsq = isSgNode(sgAssignOp->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(sgAssignOp->get_rhs_operand_i());

        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">

            if (this->debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << " ) " << endl;
                cout << "-------------------------" << endl;
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << filhoEsq->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            
            analisaExp(filhoEsq, nodoAtual,"WE");
            analisaExp(filhoDir, filhoEsq, aux);
        }
    }// </editor-fold>
    
    
    /*
     * Quando identificar MAIS ATRIBUICAO
     *
     */
    // <editor-fold defaultstate="collapsed" desc="MAIS ATRIBUICAO">
    SgPlusAssignOp* sgPlusAssignOp = isSgPlusAssignOp(nodoAtual);
    if (sgPlusAssignOp != NULL) {
        SgNode* filhoEsq = isSgNode(sgPlusAssignOp->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(sgPlusAssignOp->get_rhs_operand_i());

        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">

            if (this->debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " <<  " ) " << endl;
                cout << "-------------------------" << endl;
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << filhoEsq->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }// </editor-fold>
            
            analisaExp(filhoEsq, nodoAtual, "WE");
            analisaExp(filhoDir, filhoEsq, aux);
        }
    }
    // </editor-fold>
    
    /*
     * Quando identificar CAST_EXP
     * neste caso ignora e passa para o NODO abaixo
     */
    // <editor-fold defaultstate="collapsed" desc="NODO CAST - IGNORADO">
    SgCastExp* castExp = isSgCastExp(nodoAtual);
    if (castExp != NULL) {
        SgNode* proxNodo = isSgNode(castExp->get_operand_i());
        analisaExp(proxNodo, pai, aux);
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
            if (this->debug) {
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
            comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
//            this->ListaComp.push_back(comp);
            this->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux);
            analisaExp(filhoDir, nodoAtual, aux);
        }
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de SUBTRACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    //    <editor-fold defaultstate="collapsed" desc="OP SUB">
    SgSubtractOp* expSub = isSgSubtractOp(nodoAtual);
    if (expSub != NULL) {
        SgNode* filhoEsq = isSgNode(expSub->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expSub->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (this->debug) {
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
            op_sub_s* comp = new op_sub_s(expSub);
            comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            if(pai) comp->setPai(pai);
//            this->ListaComp.push_back(comp);
            this->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux);
            analisaExp(filhoDir, nodoAtual, aux);
        }
    }// </editor-fold>
    
    
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
//            comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
////            this->ListaComp.push_back(comp);
//            this->addComponent(comp);
//            analisaExp(filhoEsq, nodoAtual, debug, aux);
//            analisaExp(filhoDir, nodoAtual, debug, aux);
//        }
//    }
    // </editor-fold>

    
    /*
     * Quando identificar operacao de MULTIPLICACAO
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    //<editor-fold defaultstate="collapsed" desc="OP MULT">
    SgMultiplyOp* expMul = isSgMultiplyOp(nodoAtual);
    if (expMul != NULL) {
        SgNode* filhoEsq = isSgNode(expMul->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expMul->get_rhs_operand_i());
        if (filhoEsq != NULL && filhoDir != NULL) {
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            if (this->debug) {
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

            op_mult_s* comp = new op_mult_s(expMul);
            if(pai) comp->setPai(pai);
            comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
//            this->ListaComp.push_back(comp);
            this->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux);
            analisaExp(filhoDir, nodoAtual, aux);
        }
    }
    // </editor-fold>

    
    /*
     * Quando identificar IF
     */
    //<editor-fold defaultstate="collapsed" desc="IF">
    SgIfStmt* ifStm = isSgIfStmt(nodoAtual);
    if(ifStm != NULL){
        SgStatement* cond  =  ifStm->get_conditional();
        SgStatement* tBody =  ifStm->get_true_body();
        SgStatement* fBody =  ifStm->get_false_body();
        
        if(cond != NULL){
            cout<<"Condicional"<<endl;
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(cond,V_SgNode);             
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgGreaterThanOp* greaterThan =  isSgGreaterThanOp((*i));
                if(greaterThan != NULL){
                    if_gt_op_s* ifComp = new if_gt_op_s(nodoAtual);
                    ifComp->setNumLinha(nodoAtual->get_file_info()->get_line());
                    
                    string varName1 = "";
                    string varName2 = "";
                    
                    SgNode* cndEsq = isSgNode(greaterThan->get_lhs_operand_i());
                    SgNode* cndDir = isSgNode(greaterThan->get_rhs_operand_i());
                    
                    SgPntrArrRefExp* decArrEsq = isSgPntrArrRefExp(cndEsq);
                    SgVarRefExp* decVarEsq     = isSgVarRefExp(cndEsq);
                    if (decArrEsq != NULL) {
                        SgVarRefExp* fe = isSgVarRefExp(decArrEsq->get_lhs_operand_i());
                        varName1 = fe->get_symbol()->get_name().getString();
                    }else if(decVarEsq != NULL){
                        varName1 = decVarEsq->get_symbol()->get_name().getString();
                    }
                    
                    SgPntrArrRefExp* decArrDir = isSgPntrArrRefExp(cndDir);
                    SgVarRefExp* decVarDir     = isSgVarRefExp(cndDir);
                    if (decArrDir != NULL) {
                        SgVarRefExp* fe = isSgVarRefExp(decArrDir->get_lhs_operand_i());
                        varName2 = fe->get_symbol()->get_name().getString();
                    }else if(decVarDir != NULL){
                        varName2 = decVarDir->get_symbol()->get_name().getString();
                    }
                    
                    ifComp->setCondEsq(varName1);
                    ifComp->setCondDir(varName2);
                    this->addComponent(ifComp);
                    compReturn = ifComp;
                }
            }
        }
        if(tBody != NULL){
            analisaExp(tBody, NULL, "");
        }
        if(fBody != NULL){
            analisaExp(fBody, NULL, "");
        }
    }
    // </editor-fold>
    
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
        if (fe != NULL) {
             arrName = fe->get_symbol()->get_name().getString();
        }
        if (fd != NULL) {
            arrPos = fd->get_symbol()->get_name().getString();
        }else{
            arrPos = "EXP";
        }
        
        comp_ref* comp = new comp_ref(decArr, aux);
        comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
        comp->setNumLinha(decArr->get_file_info()->get_line()); 
        if(pai) comp->setPai(pai);
        this->addComponent(comp);
        compReturn = comp;
        this->updateCompRef(decArr, comp);
        
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (this->debug) {
            cout << "-------------------------------" << endl;
            cout << "      DENTRO DO COMPONENTE     " << endl;
            cout << "-------------------------------" << endl;
            cout << "ATUAL:    " << nodoAtual->class_name() << endl;
            if (pai){
                    cout << "PAI:      " << pai->class_name() << endl;
            }
            cout << "-------------------------------" << endl;
            cout << "ARRAY: " << arrName << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold>
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
        varNome = decVar->get_symbol()->get_name().getString();
        
        comp_ref* comp = new comp_ref(decVar, aux);
        comp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
        comp->setNumLinha(decVar->get_file_info()->get_line());
        if(pai) comp->setPai(pai);
        this->addComponent(comp);
        compReturn = comp;
        this->updateCompRef(decVar, comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (this->debug){
            cout << "-------------------------------" << endl;
            cout << "VAR: " << varNome << " ---> " << endl;
            if (pai){
                cout << "PAI: " << pai->class_name() << endl;
            }
            cout << "-------------------------------" << endl;
        }// </editor-fold>   
    }// </editor-fold>

   
    /*
     * Quando identificar um valor INTEIRO na expressao.
     */
    //<editor-fold defaultstate="collapsed" desc="CONSTANTE INTEIRA">
    SgIntVal* valInt = isSgIntVal(nodoAtual);
    if (valInt != NULL) {
        comp_aux* comp_input = new comp_aux(valInt, "VALOR");
        comp_input->setName("c" + FuncoesAux::IntToStr(this->ListaComp.size()));
        comp_input->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
        
        string str = FuncoesAux::IntToStr(valInt->get_value());
        comp_input->setValAux(str);
        
        if(pai) comp_input->setPai(pai);
        this->addComponent(comp_input);
        compReturn = comp_input;
                
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (this->debug) {
            cout << "-------------------------------" << endl;
            cout << "INT VALOR:    " << valInt->get_valueString() << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold> 
    }// </editor-fold>
    
    return compReturn;
}

bool Core::isIndiceVector(const string& name){
    bool res = false;
    list<Componente*>::iterator i;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::CTD){
            counter* CompCounter = (counter*)(*i); 
            if(CompCounter->getVarControlCont() == name){
                res = true;
            }
        }
    }
    return res;
}

void Core::FinalizaComponentes(){
 
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    list<Componente*>ListaCompAux;
    //Ligacao* reset = new 
    int qtdLig = 0;

    //Passo para informar as referencias se durante o processo de criacao de 
    //variaveis tem valor inicial
    // <editor-fold defaultstate="collapsed" desc="Informacao Complementar REF">
//    cout<<"--------------------------"<<endl;
//    cout<<"IDENTIFICACAO DOS COMP REF"<<endl;
//    cout<<"--------------------------"<<endl;
    cout<<"--Finalizando comp REF"<<endl;
//    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp == CompType::REF) {
//            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
//                if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) {
//                    if ((*i)->getName() == (*j)->getName()) {
//                        (*i)->setComponenteRef((*j));
//                        (*i)->updateCompRef();
//                        if(isIndiceVector((*i)->getName())){
//                            (*i)->setEIndice(true);
//                            (*i)->setName("indice_"+(*i)->getName());
//                            (*i)->getComponenteRef()->setName((*i)->getName());
//                            (*i)->getComponenteRef()->setEIndice(true);
//                        }
//                    }
//                }
//            }
//        }
//    }
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
                if( (*i)->getPortDataInOut("OUT")->getLigacao() == "" ){
                
                    string str = FuncoesAux::IntToStr(this->ListaLiga.size());

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
                }
            }
        }
    }
    cout<<"--Criando ligacoes basicas: OK"<<endl;
    // </editor-fold>    
    
    //Processo de identificacao dos componentes CONCIDICIONAIS
    // <editor-fold defaultstate="collapsed" desc="Criar ligacoes entre ref e comp CONCIDICIONAIS">
    cout<<"--Criando novas ligacoes comp condicional:"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CND) continue;
        if ((*i)->tipo_comp == CompType::CND) {
            string nameEsq = "";
            string nameDir = "";
            string name    = "";
            if( (*i)->getNomeCompVHDL() == "if_gt_op_s" ){
                if_gt_op_s* cond = (if_gt_op_s*)(*i);
                nameEsq = cond->getCondEsq();
                nameDir = cond->getCondDir();
                name    = (*i)->getNomeCompVHDL();
            }
             
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                
                if ((*j)->tipo_comp == CompType::REF) {
                    //Necessario para pegar funcao especifica do contador
                    comp_ref* CompRef = (comp_ref*)(*j); 
                                        
                    if (nameEsq == (*j)->getName() || nameDir == (*j)->getName()) {
                        string porta ="";
                        Componente* comp = (*j);
                        if(nameEsq == (*j)->getName()){
                            porta = "I0";
                            name = (*j)->getName()+"_"+name;
                            (*i)->setName(name);
                        }else{
                            porta = "I1";
                            name += "_"+(*j)->getName();
                            (*i)->setName(name);
                        }

//                        if(CompRef->getTipoCompRef() == CompType::MEM){
//                            (*j)->setNumLinha((*i)->getNumLinha()-1);
//                            comp = this->insereReg((*j)->getLigacaoOutDefault());
//                            ListaCompAux.push_back(comp);
//                        }
                        
                        //CRIAR NOVA LIGACAO
                        string str = FuncoesAux::IntToStr(this->ListaLiga.size());
                        Ligacao* lig = new Ligacao(comp, (*i), "s" + str);
                        lig->setPortOrigem(comp->getPortDataInOut("OUT"));
                        lig->setPortDestino((*i)->getPortOther(porta));
                        lig->setWidth(comp->getPortDataInOut("OUT")->getWidth());
                        lig->setTipo(comp->getPortDataInOut("OUT")->getType());

                        //ADICIONAR LIGACAO NA PORTA                        
                        lig->getPortDestino()->setLigacao(lig->getNome());
                        lig->getPortOrigem()->setLigacao(lig->getNome());

                        //ADICIONAR LIGACAO AOS COMPONENTES
                        (*i)->addLigacao(lig);
                        comp->addLigacao(lig);

                        //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                        this->ListaLiga.push_back(lig);

                        if( CompRef->getWE() ){
                            //CRIAR NOVA LIGACAO
                            Ligacao* lig2 = new Ligacao((*i), (*j), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            lig2->setPortOrigem((*i)->getPortOther("O0"));
                            lig2->setPortDestino((*j)->getPortOther("we"));
                            lig2->setWidth((*i)->getPortOther("O0")->getWidth());
                            lig2->setTipo((*i)->getPortOther("O0")->getType());

                            //ADICIONAR LIGACAO NA PORTA                        
                            lig2->getPortDestino()->setLigacao(lig2->getNome());
                            lig2->getPortOrigem()->setLigacao(lig2->getNome());

                            //ADICIONAR LIGACAO AOS COMPONENTES
                            (*i)->addLigacao(lig2);
                            (*j)->addLigacao(lig2);

                            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                            this->ListaLiga.push_back(lig2);
                        }
                    }
                }
            }
        }
    }
    for (i = ListaCompAux.begin(); i != ListaCompAux.end(); i++) {
        this->addComponent((*i));
    }
    cout<<"--Criando novas ligacoes comp condicional: OK"<<endl;
    // </editor-fold> 
    
    //Processo de identificacao dos componentes CONTADORES e criar a ligacao
    //para as memorias 
    // <editor-fold defaultstate="collapsed" desc="Criar ligacoes entre memorias e contador">
    cout<<"--Criando novas ligacoes do Contador"<<endl;
    ListaCompAux.clear();
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->tipo_comp == CompType::CTD) {
            //Necessario para pegar funcao especifica do contador
            counter* CompCounter = (counter*)(*i); 
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
                if ((*i)->node == (*j)->node) continue;
                
                if ((*j)->tipo_comp == CompType::REF) {
                    //Necessario para pegar funcao especifica do contador
                    comp_ref* CompRef = (comp_ref*)(*j); 
                    
                    if((*j)->getEIndice()){
                        if( (*j)->getPortDataInOut("OUT")->getLigacao() != "" ){
                            
                            Ligacao* s1Lig = (*j)->getLigacaoByName((*j)->getPortDataInOut("OUT")->getLigacao());
                            s1Lig->getOrigem()->removeLigacao(s1Lig);
                            s1Lig->editOrig((*i));
                            (*i)->addLigacao(s1Lig);
                            
                            s1Lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                            s1Lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                            s1Lig->setTipo((*i)->getPortDataInOut("OUT")->getType());
                            s1Lig->getPortOrigem()->setLigacao(s1Lig->getNome());
                            
                            (*j)->tipo_comp = CompType::REG;
//                            ListaCompAux.push_back((*j));                            
                        }
                    }
                    
                    
                    if (CompRef->getNomeVarIndex() == CompCounter->getVarControlCont()) {
                        if(CompRef->getPortOther("address")->getLigacao() == ""){

                            //CRIAR NOVA LIGACAO
                            string str = FuncoesAux::IntToStr(this->ListaLiga.size());
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
                        }
                    }else{
                        if( CompRef->getWE() ){
                            if(CompRef->getPortOther("we")->getLigacao() == ""){
                                //CRIAR NOVA LIGACAO
                                Ligacao* lig = new Ligacao((*i), (*j), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                                lig->setPortOrigem((*i)->getPortOther("step"));
                                lig->setPortDestino((*j)->getPortOther("we"));
                                lig->setWidth((*i)->getPortOther("step")->getWidth());
                                lig->setTipo((*i)->getPortOther("step")->getType());

                                //ADICIONAR LIGACAO NA PORTA                        
                                lig->getPortDestino()->setLigacao(lig->getNome());
                                lig->getPortOrigem()->setLigacao(lig->getNome());

                                //ADICIONAR LIGACAO AOS COMPONENTES
                                (*i)->addLigacao(lig);
                                (*j)->addLigacao(lig);

                                //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                                this->ListaLiga.push_back(lig);
                            }
                        }
                    }
                }
            }
        }
    }
//    cout<< "@@@@ REMOVER DA LISTA AUX" <<endl;
//    for (i = ListaCompAux.begin(); i != ListaCompAux.end(); i++) {
//        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
//            if((*i)->getName() == (*j)->getName()){
//                if( (*j)->tipo_comp == CompType::REF){
//                    cout<< " (i): " <<(*i)->getName()<<endl;
//                    cout<< " (j): " <<(*j)->getName()<<endl;
//                    Componente comp = (*j);
//                    cout<<"11"<<endl;
//                    this->ListaComp.remove(&comp);
//                }
//            }
//        }
//    }
//    ListaCompAux.clear();
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
    
    //Setar INICIALIZACAO
    comp_aux* comp_init = new comp_aux(NULL,"INIT");
    comp_init->setName("init");
    comp_init->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
    this->addComponent(comp_init); 
    
    comp_aux* comp_done = new comp_aux(NULL, "DONE");
    comp_done->setName("done");
    comp_done->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
    this->addComponent(comp_done); 
    
    // <editor-fold defaultstate="collapsed" desc="COMP INICIALIZACO">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CTD) continue;
        counter* CompCounter = (counter*)(*i);        
        
        //*********************************************************************
        // <editor-fold defaultstate="collapsed" desc="TERMINATION">
        comp_aux* comp_term = new comp_aux(NULL, "VALOR");
        comp_term->setName("c" + FuncoesAux::IntToStr(this->ListaComp.size()));
        comp_term->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
        //Pegar valor do contator referente ao MAXIMO de INTERACOES
        comp_term->setValAux(CompCounter->getVarControlValStop());
        
        //LIGACAO
        Ligacao* newLig2 = new Ligacao(comp_term, (*i), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
        newLig2->setPortDestino((*i)->getPortOther("termination"));
        newLig2->setPortOrigem(comp_term->getPortDataInOut("OUT"));
        newLig2->setWidth((*i)->getPortOther("termination")->getWidth());
        newLig2->setTipo((*i)->getPortOther("termination")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig2->getPortDestino()->setLigacao(newLig2->getNome());
        newLig2->getPortOrigem()->setLigacao(newLig2->getNome());

        //ADICIONAR LIGACAO NO COMPONENTE
        (*i)->addLigacao(newLig2);
        comp_term->addLigacao(newLig2);

        //ADD LISTAS
        this->ListaLiga.push_back(newLig2);
//        this->ListaComp.push_back(comp_term); 
        this->addComponent(comp_term); 
        // </editor-fold>
        //*********************************************************************
        
        
        //*********************************************************************
        // <editor-fold defaultstate="collapsed" desc="INPUT">
        comp_aux* comp_input = new comp_aux(NULL, "VALOR");
        comp_input->setName("c" + FuncoesAux::IntToStr(this->ListaComp.size()));
        comp_input->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
        //Pegar valor do contator referente ao MAXIMO de INTERACOES
        comp_input->setValAux(CompCounter->getVarControlValIni());
        
        //LIGACAO
        Ligacao* newLig3 = new Ligacao(comp_input, (*i), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
        newLig3->setPortDestino((*i)->getPortOther("input"));
        newLig3->setPortOrigem(comp_input->getPortDataInOut("OUT"));
        newLig3->setWidth((*i)->getPortOther("input")->getWidth());
        newLig3->setTipo((*i)->getPortOther("input")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig3->getPortDestino()->setLigacao(newLig3->getNome());
        newLig3->getPortOrigem()->setLigacao(newLig3->getNome());

        //ADICIONAR LIGACAO NO COMPONENTE
        (*i)->addLigacao(newLig3);
        comp_input->addLigacao(newLig3);

        //ADD LISTAS
        this->ListaLiga.push_back(newLig3);
//        this->ListaComp.push_back(comp_input); 
        this->addComponent(comp_input); 
        // </editor-fold>
        //*********************************************************************
    }
    // </editor-fold>   
    
}

void Core::updateCompRef(SgNode* node, comp_ref* comp){
        
    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(node);
    bool expIndVec                = false;
    if(nodo_ref_var != NULL){
        comp->setTipoVar("VAR");
        comp->setNomeVarRef(nodo_ref_var->get_symbol()->get_name().getString());
        comp->setName(nodo_ref_var->get_symbol()->get_name().getString());
    }
    if(nodo_ref_arr != NULL){
        comp->setTipoVar("VET");
        
        string arrName  = "";
        string arrPos   = ""; 
        SgVarRefExp* fe = isSgVarRefExp( nodo_ref_arr->get_lhs_operand_i() );
        SgVarRefExp* fd = isSgVarRefExp( nodo_ref_arr->get_rhs_operand_i() );
        if (fe != NULL){
            arrName     = fe->get_symbol()->get_name().getString();
            if(fd != NULL){
                arrPos      = fd->get_symbol()->get_name().getString();
            }else{
                expIndVec = true;
            }
            comp->setNomeVarRef(arrName);
            comp->setName(arrName);
            comp->setNomeVarIndex(arrPos);            
        }
        
    }
    
    if(isSgPlusAssignOp(comp->getPai())){
        list<Componente*>::iterator i;
//        cout<<"-----ACHOU: "<< comp->getName() <<endl;
        for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//            cout<< (*i)->getName()<< "-- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
            if ((*i)->tipo_comp !=  CompType::REG) continue;
            if ((*i)->getName() == comp->getName()){
//                cout<< "---" << (*i)->getName()<< " -- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
                add_reg_op_s* add_reg = new add_reg_op_s((*i)->node);
                add_reg->setName((*i)->getName());
                add_reg->setValor( (*i)->getGenericMapVal("initial", "VAL") );
//                this->ListaComp.remove((*i));
//                this->addComponent(add_reg);
                (*i) = add_reg;
                
                string str = FuncoesAux::IntToStr(this->ListaLiga.size());
                
                //CRIAR LIGACAO
                Ligacao* lig = new Ligacao(add_reg, add_reg, "s" + str);
                lig->setPortDestino(add_reg->getPortOther("I0"));
                lig->setPortOrigem(add_reg->getPortDataInOut("OUT"));
                lig->setWidth(add_reg->getPortDataInOut("OUT")->getWidth());
                lig->setTipo(add_reg->getPortDataInOut("OUT")->getType());
  
                //INFORMAR CADA PORTA QUEM E SUA LIGACAO
                add_reg->getPortDataInOut("IN")->setLigacao(lig->getNome());
                add_reg->getPortDataInOut("OUT")->setLigacao(lig->getNome());
                
                //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
                add_reg->addLigacao(lig);
                
                //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                this->ListaLiga.push_back(lig);
                
                break;
            }
        }
    }
    
    list<Componente*>::iterator j;
    for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
        if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) {
            if (comp->getName() == (*j)->getName()) {
                comp->setComponenteRef((*j));
                comp->updateCompRef();
                if(isIndiceVector(comp->getName())){
                    comp->setEIndice(true);
                    comp->setName("indice_"+comp->getName());
                    comp->getComponenteRef()->setName(comp->getName());
                    comp->getComponenteRef()->setEIndice(true);
                }
            }
        }
    }
    
    if(expIndVec == true && nodo_ref_arr != NULL){
        SgNode* expInd = isSgNode( nodo_ref_arr->get_rhs_operand_i() );   
        Componente* compExp = analisaExp(expInd, NULL, "");
        
        Ligacao* lig = new Ligacao(compExp, comp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
        lig->setPortDestino(comp->getPortOther("address"));
        lig->setPortOrigem(compExp->getPortDataInOut("OUT"));
        lig->setWidth(compExp->getPortDataInOut("OUT")->getWidth());
        lig->setTipo(compExp->getPortDataInOut("OUT")->getType());

        //INFORMAR CADA PORTA QUEM E SUA LIGACAO
        compExp->getPortDataInOut("OUT")->setLigacao(lig->getNome());
        comp->getPortOther("address")->setLigacao(lig->getNome());

        //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
        compExp->addLigacao(lig);
        comp->addLigacao(lig);

        //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
        this->ListaLiga.push_back(lig);
    }
}

void Core::updateCounter(SgNode* node, counter* comp){
    SgForStatement* cur_for = isSgForStatement(node);
    if (cur_for != NULL){
        
        ROSE_ASSERT(cur_for);

        comp->setName(SageInterface::getLoopIndexVariable(node)->get_name().str());
        comp->setVarControlCont(SageInterface::getLoopIndexVariable(node)->get_name().str());
         /**********************************************************/
        //Parte de pegar o padrao de inicio do FOR => EX.: int i = 0 
        SgForInitStatement* stmt    = cur_for->get_for_init_stmt();
        
        Rose_STL_Container<SgNode*> NodosFor1 = NodeQuery::querySubTree(stmt,V_SgNode); 
        for (Rose_STL_Container<SgNode*>::iterator for1 = NodosFor1.begin(); for1 != NodosFor1.end(); for1++ ) 
        {
            SgIntVal* valIni = isSgIntVal(*for1);
            if(valIni != NULL){
                comp->setVarControlValIni(FuncoesAux::IntToStr(valIni->get_value()));
            }
        }               
        /**********************************************************/


        /**********************************************************/
        //Condicao de parada do FOR => EX.: i < 10
//        this->for_cond_var = this->for_ctr_var;
//        -- possible conditions are:
//        -- 0	<
//        -- 1	<=
//        -- 2	>
//        -- 3	>=
//        -- 4  ==
//        -- 5  !=
        SgExpression* testExp       = cur_for->get_test_expr();
        
        Rose_STL_Container<SgNode*> NodosFor2 = NodeQuery::querySubTree(testExp,V_SgNode);
        for (Rose_STL_Container<SgNode*>::iterator for2 = NodosFor2.begin(); for2 != NodosFor2.end(); for2++ ) 
        {
            SgLessThanOp* opMenorQue            = isSgLessThanOp(*for2);
            SgLessOrEqualOp* opMenorIgual       = isSgLessOrEqualOp(*for2);
            SgGreaterThanOp* opMaiorQue         = isSgGreaterThanOp(*for2);
            SgGreaterOrEqualOp* opMaiorIgual    = isSgGreaterOrEqualOp(*for2);
            SgEqualityOp* Igual                 = isSgEqualityOp(*for2);
            
            
            if (opMenorQue != NULL){
                comp->setGenericMapCondition("0");
            }
            if (opMenorIgual != NULL){
                comp->setGenericMapCondition("1");
            }
            if (opMaiorQue != NULL){
                comp->setGenericMapCondition("2");
            }
            if (opMaiorIgual != NULL){
                comp->setGenericMapCondition("3");
            }
            if (Igual != NULL){
                comp->setGenericMapCondition("4");
            }
            
            //SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            SgIntVal* valPar        = isSgIntVal(*for2);
            if (valPar != NULL){
                comp->setVarControlValStop(FuncoesAux::IntToStr(valPar->get_value()));
            }
        }
        /**********************************************************/


        /**********************************************************/
        //Parte que identifica o incremento do FOR => EX.: i++
//        this->for_incr_var = this->for_ctr_var;
        
        SgExpression* increment     = cur_for->get_increment();
        Rose_STL_Container<SgNode*> NodosFor3 = NodeQuery::querySubTree(increment,V_SgNode);
        
        for (Rose_STL_Container<SgNode*>::iterator for3 = NodosFor3.begin(); for3 != NodosFor3.end(); for3++ ) 
        {
            //SgNode* node = isSgNode(*for3);
            SgPlusPlusOp*   opMaisMais    = isSgPlusPlusOp(*for3);
            SgMinusMinusOp* opMenosMenos  = isSgMinusMinusOp(*for3);
            SgAssignOp*     opAtt         = isSgAssignOp(*for3);
            //SgVarRefExp*  varIncr       = isSgVarRefExp(*for3);
            if(opMaisMais != NULL){
                comp->setGenericMapIncrements("1");
                comp->setGenericMapDown("0");
            }
            if(opMenosMenos != NULL){
                comp->setGenericMapIncrements("1");
                comp->setGenericMapDown("1");
            }
            if(opAtt != NULL){
                SgNode* filhoDir  = isSgNode(opAtt->get_rhs_operand_i());
                SgAddOp* opAddNode= isSgAddOp(filhoDir);
                 
                if(opAddNode != NULL){
                    SgNode* filhoAddDir  = isSgNode(opAddNode->get_rhs_operand_i());
                    if(filhoAddDir != NULL){
                        SgIntVal* intVal = isSgIntVal(filhoAddDir);
                        if(intVal != NULL){
                            string str = FuncoesAux::IntToStr(intVal->get_value());
                            comp->setGenericMapIncrements(str);
                            comp->setGenericMapDown("0");
                        }
                    }
                }
            }
        }
        /**********************************************************/
    }
}

void Core::updateBlockRam(SgNode* node, block_ram* comp){
     SgInitializedName* cur_var          = isSgInitializedName(node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(cur_var->get_parent());
    
    if (cur_var != NULL){
        comp->setName(cur_var->get_name().getString());
            
        //Pegar tipo do vetor
        string tipo = SageInterface::getArrayElementType(cur_var->get_type())->get_mangled().str();

        //Tamanho do Vetor
        const vector<string> words = FuncoesAux::split(varDec->get_mangled_name().getString(), "_");
        comp->setQtdElementos(string(words[7].c_str()));
        
        //TODO - Ver como que vai ficar o esquema de tipo da variavel ou vetor
        //Identificar o tipo da variavel/vetor
        //if((tipo.compare("i")) == 1){
        string tipo_var = "";
        if(tipo=="i"){
            tipo_var = "INT";
        }
        //if((tipo.compare("c")) == 1){
        if(tipo=="c"){
            tipo_var = "CHA";
        }
        //if((tipo.compare("f")) == 1){
        if(tipo=="f"){
            tipo_var = "FLO";
        }
        //if((tipo.compare("d")) == 1){
        if(tipo=="d"){
            tipo_var = "DOU";
        }
        comp->setTipo(tipo_var);
        
        /*
         * abaixo verifica a subtree apartir do nodo isSgInitializedName
         * sendo assim dentro desta sub-arvore temos todas as informacoes da
         * variavel/vetor
         */
        string val = "";
        Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgAssignInitializer);
        if(var2.size() > 0){
            comp->setEInicializado(true);
//            //Caso for vetor, pegar a quantidade de elementos dentro do mesmo
//            this->qtd_ele_vet = var2.size();
            
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    string str = FuncoesAux::IntToStr(intVal->get_value());
                    if(var2.size() < 2){
                        val += ""+str;
                    }else{
                        val += ""+str+"|";
                    }
                }
            }
        }
        comp->setValor(val);
    }
    
    string nome_comp_vhdl = "block_ram";
    nome_comp_vhdl += "_"+comp->getName();
    comp->setNomeCompVHDL(nome_comp_vhdl);
}

void Core::updateRegister(SgNode* node, reg_op* comp){
    SgInitializedName* cur_var          = isSgInitializedName(node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(node->get_parent());
    
    if (cur_var != NULL){
        varID var(isSgInitializedName(node));
        
        //Pegar nome
        comp->setName(cur_var->get_name().getString());
        
        //Verificar se e vetor ou nao - isso vai empactar para definir hardware
        //registrador (variavel) ou memoria (vetor)
        string tipo="";

        //Pegar tipo da variavel
        tipo = cur_var->get_type()->get_mangled().str();
        

        //TODO - Ver como que vai ficar o esquema de tipo da variavel ou vetor
        //Identificar o tipo da variavel/vetor
        //if((tipo.compare("i")) == 1){
        string tipo_var = "";
        if(tipo=="i"){
            tipo_var = "INT";
        }
        //if((tipo.compare("c")) == 1){
        if(tipo=="c"){
            tipo_var = "CHA";
        }
        //if((tipo.compare("f")) == 1){
        if(tipo=="f"){
            tipo_var = "FLO";
        }
        //if((tipo.compare("d")) == 1){
        if(tipo=="d"){
            tipo_var = "DOU";
        }
        comp->setTipo(tipo_var);
        
        /*
         * abaixo verifica a subtree apartir do nodo isSgInitializedName
         * sendo assim dentro desta sub-arvore temos todas as informacoes da
         * variavel/vetor
         */
        Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgAssignInitializer);
        if(var2.size() > 0){
            comp->setEInicializado(true);
                                    
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    string str = FuncoesAux::IntToStr(intVal->get_value());
                    comp->setValor(str);
                }
            }
        }
    }
}

void Core::imprimeAll(){
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    cout<<"*********************************"<<endl;
    cout<<"COMPONENTES"<<endl;
    cout<<"Qtd: "<< this->ListaComp.size() <<endl;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM ) continue;
//        if ((*i)->tipo_comp != CompType::CTD) contiopAttnue;
//        (*i)->printAllPortsAllLig();
    }
    cout<<"*********************************"<<endl;
}

void Core::grafo(){
    ProcessGraph* ObjGraph = new ProcessGraph();
    list<Ligacao*>::iterator    k;
    list<Componente*>::iterator i;
    
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if ((*k)->getOrigem()->tipo_comp == CompType::REG || (*k)->getOrigem()->tipo_comp == CompType::MEM || (*k)->getOrigem()->tipo_comp == CompType::AUX  ) continue;
        if ((*k)->getDestino()->tipo_comp == CompType::REG || (*k)->getDestino()->tipo_comp == CompType::MEM || (*k)->getDestino()->tipo_comp == CompType::AUX  ) continue;
        ObjGraph->addEdge((*k)->getOrigem()->getName(), (*k)->getDestino()->getName(), (*k)->getNome());
    }
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX ) continue;
        
        string  name    = (*i)->getName();
        int     delayVal= FuncoesAux::StrToInt((*i)->getDelayValComp());
        int     idComp  = FuncoesAux::StrToInt((*i)->getNumIdComp());
        ObjGraph->updateVertex(name, delayVal, idComp);
    }
//    ObjGraph->geraDot();
//    ObjGraph->imprimeVertices();
//    ObjGraph->imprimeEdges();
//    ObjGraph->imprimeEdgesAdj();
//    ObjGraph->imprimeEdgesInc();
//    ObjGraph->imprimeTeste();
}

void Core::detectBackwardEdges(){
    list<Ligacao*>::iterator    k;
    bool debug = true;
    cout<<"*********************************"<<endl;
    cout<<"Detectando Backward Edges (Topological)..."<<endl;
    cout<<"*********************************"<<endl;
    
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){

        //Self-connected component EX.: A->A
        if((*k)->getOrigem()->getName() == (*k)->getDestino()->getName()){
            (*k)->setBlackEdge(true);
            if(debug)
                cout<< "signal " << (*k)->getOrigem()->getName() << " -> " <<  (*k)->getDestino()->getName() << " marked as backedge (self-connected)" << endl;
        }
        //self-connected components (pair) EX.: A->B and B->A 
        else if((*k)->getOrigem()->isSuccessorOf((*k)->getDestino())){
            (*k)->setBlackEdge(true);
            if(debug)
                 cout<< "signal " << (*k)->getOrigem()->getName() << " -> " <<  (*k)->getDestino()->getName() << " marked as backedge (self-connected pair)" << endl;
        }
        else{
            if ((*k)->getDestino()->tipo_comp == CompType::REG || (*k)->getDestino()->tipo_comp == CompType::MEM || (*k)->getDestino()->tipo_comp == CompType::AUX  ) continue;
            int origLine = (*k)->getOrigem()->getNumLinha();
            int destLine = (*k)->getDestino()->getNumLinha();
            
            if(origLine > 0){
                if (destLine == 0){
                    destLine = (*k)->getDestino()->getSuccessorsLine();
                }
                if(origLine > destLine){
                    (*k)->setBlackEdge(true);
                    if(debug)
                        cout<< "signal \"" << (*k)->getOrigem()->getName() << "\" -> \"" <<  (*k)->getDestino()->getName() << "\" marked as backedge (source defined after destination in source code)" << endl;
        
                }
            }
        }
    }
    cout<<"*********************************"<<endl;
    cout<<"Detectando Backward Edges (Topological)...OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Core::balanceAndSyncrhonize(){
    cout<<"*********************************"<<endl;
    cout<<"Balance And Synchronize..."<<endl;
    cout<<"*********************************"<<endl;
//    list<Componente*> ListaCompAux;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    list<Ligacao*>::iterator    m;
    bool debug = true;
    Componente* counter = NULL;
    Componente* firstCounter = NULL;
    int mii = 0, ats = 0;

    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        Componente* c = (*i);
        if ((*i)->tipo_comp == CompType::CTD){
            counter = c;
            if(firstCounter == NULL){
                firstCounter = (*i);
            }
            int step = 0;
            step = FuncoesAux::StrToInt(counter->getGenericMapVal("steps", "VAL"));
            
            if (step > mii){
                mii = step;
            }
            if(debug){
                cout<< "using counter \""<< (*i)->getName() << "\" to syncronize operations " << endl;
            }
            int counterSched = counter->getASAP();

            for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
                if((*k)->getOrigem() != counter) continue;
                if((*k)->getPortDestino()->getName() != "address") continue;
                
                Componente* destino = (*k)->getDestino();
                int distance = destino->getASAP() - counterSched;
//                cout<<"************************"<<endl;
//                cout<<"NOME: "<< destino->getName()<<endl;
//                cout<<"ASAP: "<< destino->getASAP()<<endl;
//                cout<<"DIST: "<< distance<<endl;
//                cout<<"************************"<<endl;
                if (distance > 1) {
                    string strAux = counter->getDelayValComp();
                    int dlyCtd = 0;
                    if(strAux != ""){
                        dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
                    }

                    Componente* dly1 = this->insereDelay((*k), distance-1, destino->getASAP() - dlyCtd);
                    ats++;

                    if(debug){
                        cout<< "inserting " << (distance-1) << " delay(s) on signal "<< counter->getName()<< "->" << destino->getName() <<" (memory address)" << endl;
                    }
                    
                    this->addComponent(dly1);
                    
                    string port = "we";
                    if(!destino->getWE())
                        port = "oe";

                    //CRIAR NOVA LIGACAO
                    Ligacao* lig = new Ligacao(counter, destino, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                    lig->setPortOrigem(counter->getPortOther("step"));
                    lig->setPortDestino(destino->getPortOther(port));
                    lig->setWidth(counter->getPortOther("step")->getWidth());
                    lig->setTipo(counter->getPortOther("step")->getType());

                    //ADICIONAR LIGACAO NA PORTA                        
                    lig->getPortDestino()->setLigacao(lig->getNome());
                    lig->getPortOrigem()->setLigacao(lig->getNome());

                    //ADICIONAR LIGACAO AOS COMPONENTES
                    counter->addLigacao(lig);
                    destino->addLigacao(lig);

                    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                    this->ListaLiga.push_back(lig);

                    //INSERINDO DELAY NA NOVA LIGACAO
                    Componente* dly2 = this->insereDelay(lig, distance-1, (*k)->getDestino()->getASAP() - dlyCtd);
                    this->addComponent(dly2);
                    
                    ats++;
                    if(debug){
                        cout<< "inserting " << (distance-1) << " delay(s) on signal "<< counter->getName()<< "->" << destino->getName() <<" (memory port: WE)" << endl;
                    }                      
                }
            }
        }
        else if( (counter != NULL) && (c->getTipoCompRef() != CompType::MEM) && (c->temPorta("we"))){
//            cout<< "sinc oper part 1.1" << endl;
            if(c->getWE() == false) continue;
//            cout<<"COMPONENTE: "<<c->getName()<<endl;
//            cout<<"vhdl nome : "<<c->getNomeCompVHDL()<<endl;
//            cout<< c->imprimeLigacoes() << endl;
            if(c->getPortOther("we")->getLigacao() != ""){
//                cout<<"1"<<endl;
                int distance = c->getASAP() - counter->getASAP();
//                cout<<"************************"<<endl;
//                cout<<"NOME: "<< c->getName()<<endl;
//                cout<<"ASAP: "<< c->getASAP()<<endl;
//                cout<<"DIST: "<< distance<<endl;
//                cout<<"CONT: "<< counter->getASAP()<<endl;
//                cout<<"************************"<<endl;
                if(distance > 1){
                    Ligacao* s1 = c->getLigacaoByName(c->getPortOther("we")->getLigacao());
                    if (s1->getOrigem()->tipo_comp != CompType::CND){
                        string strAux = counter->getDelayValComp();
                        int dlyCtd = 0;
                        if(strAux != ""){
                            dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
                        }
                        Componente* dly3 = this->insereDelay(s1, distance-1, counter->getASAP() + dlyCtd);
                        this->addComponent(dly3);
                        ats++;
                        if(debug){
                            cout<< "inserting " << (distance-1) << " delay(s) on signal "<< counter->getName()<< "->" << c->getName() <<" (memory port: WE)" << endl;
                        }
                    }
                }
            }else{
                cout<< "port 'we' of component \"" << c->getName() << "\" is connected, please check if aditional synchronization is needed (when ... && "<<counter->getName()<<".step@N)" << endl;
            }
        }
    }
//    if(debug){
//        cout<< "sinc oper part 1: OK" << endl;
//    }
    
    Componente* comp_init = getComponent("init");
    if(firstCounter != NULL && comp_init != NULL && comp_init->getLigacaoOutDefault() == NULL){
        //LIGACAO
        Ligacao* newLig = new Ligacao(comp_init, firstCounter, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));

        newLig->setPortDestino(firstCounter->getPortOther("clk_en"));
        newLig->setPortOrigem(comp_init->getPortDataInOut("OUT"));
        newLig->setWidth(firstCounter->getPortOther("clk_en")->getWidth());
        newLig->setTipo(firstCounter->getPortOther("clk_en")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig->getPortDestino()->setLigacao(newLig->getNome());
        newLig->getPortOrigem()->setLigacao(newLig->getNome());

        //ADICIONAR LIGACAO NO COMPONENTE
        firstCounter->addLigacao(newLig);
        comp_init->addLigacao(newLig);

        //ADD LISTAS
        this->ListaLiga.push_back(newLig);
    }
    
    Componente* comp_done = getComponent("done");
 
    if(counter != NULL && comp_done != NULL &&  comp_done->getLigacaoInDefault() == NULL){
        int amount = this->getMaxSchedulingTime() - counter->getASAP();// - 1;

        //LIGACAO 
        Ligacao* newLig4 = new Ligacao(firstCounter, comp_done, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
        newLig4->setPortOrigem(counter->getPortOther("done"));
        newLig4->setPortDestino(comp_done->getPortDataInOut("IN"));
        newLig4->setWidth(counter->getPortOther("done")->getWidth());
        newLig4->setTipo(counter->getPortOther("done")->getType());
        
        //ADICIONAR NOME LIGACAO NA PORTA
        newLig4->getPortDestino()->setLigacao(newLig4->getNome());
        newLig4->getPortOrigem()->setLigacao(newLig4->getNome());
        
        //ADICIONAR LIGACAO NO COMPONENTE
        counter->addLigacao(newLig4);
        comp_done->addLigacao(newLig4);

        //ADD LISTAS LIGACAO
        this->ListaLiga.push_back(newLig4);
        
        string strAux = counter->getDelayValComp();
        int dlyCtd = 0;
        if(strAux != ""){
            dlyCtd = FuncoesAux::StrToInt(counter->getDelayValComp());
        }
        
        Componente* dly4 = this->insereDelay(newLig4, amount, counter->getASAP() + dlyCtd);
        this->addComponent(dly4); 
        if(debug){
            cout<< "inserting " << amount << " delay(s) on signal "<< counter->getName()<< "->" << comp_done->getName() <<" (termination)" << endl;
        }
    }    
    
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        Componente* orig = (*k)->getOrigem();
        Componente* dest = (*k)->getDestino();
        
        if(orig->tipo_comp == CompType::DLY || dest->tipo_comp == CompType::DLY) continue;
        if(orig->tipo_comp == CompType::AUX || dest->tipo_comp == CompType::AUX) continue;
        
        int sourceSched = this->calculateASAP(orig);
        int destSched   = dest->getASAP();
        int distance    = destSched - sourceSched;
        if (distance > 1) {
            Componente* dly5 = this->insereDelay((*k), distance, dest->getASAP());
            ats++;
            this->addComponent(dly5);
            if(debug){
                cout<< "inserting " << distance << " delay(s) on signal "<< orig->getName()<< "->" << dest->getName() <<" (balance)" << endl;
            }
        }

    }
    
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getBlackEdge()){
            Componente* orig = (*k)->getOrigem();
            Componente* dest = (*k)->getDestino();
            
            string strAux = orig->getDelayValComp();
            int dlyCtd = 0;
            if(strAux != ""){
                dlyCtd = FuncoesAux::StrToInt(orig->getDelayValComp());
            }
            
            int sourceSched = orig->getASAP() + dlyCtd;
            int destSched = dest->getASAP();
            int distance = sourceSched - destSched;
            
            if(orig->getSync() && dest->getSync()){
                if(distance > mii){
                    cout<< "backedge "<< orig->getName()<< "->" << dest->getName() <<" have distance "<<distance<< " which is bigger than MII = "<<mii<<", this can limit MII to lower value" << endl;
                }
            }
            if(debug){
                cout<< "backedge "<< orig->getName()<< "->" << dest->getName()<< " with distance "<< distance << endl;
            }
        }
    }
    
    
    
    cout<<"*********************************"<<endl;
    cout<<"Balance And Synchronize...OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Core::ALAP(){
    cout<<"*********************************"<<endl;
    cout<<"ALAP..."<<endl;
    cout<<"*********************************"<<endl;
    list<Componente*>::iterator i;
    list<Ligacao*>::iterator    k;
    
    this->ASAP();
    this->copySchedulingTimes();
    bool change = true;
    int min, succ, dlyAux;
    while(change){
        change = false;
        for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
            if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX ) continue;
            min  = 0;
            succ = 0;
            
            //Fazer calc para todos sucessores QUANDO ARESTA FOR DIFERENTE DE BLACK
            for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
                if((*k)->getOrigem() == (*i) && !(*k)->getBlackEdge()){
                    dlyAux = FuncoesAux::StrToInt((*i)->getDelayValComp());
                    succ = (*k)->getDestino()->getALAP() - dlyAux;
                    if(succ < min)
                        min = succ;
                }
                
            }
            if((*i)->getALAP() != min){
                (*i)->setALAP(min);
                change = true;
            }
        }
    }
    cout<<"*********************************"<<endl;
    cout<<"ALAP... OK"<<endl;
    cout<<"*********************************"<<endl;
}

void Core::ASAP(){
    cout<<"Scheduling (ASAP)..."<<endl;
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    bool debug = true;
    bool change = true;
    int max, pred, dlyAux;
    int id = 0;
    while(change){
        change = false;
        //varrer todos componentes
        for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
            if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::AUX ) continue;
            max = 0;
            pred = 0;
            if(debug){
                cout<< "scheduling \""<<(*i)->getName()<<"\" ASAP: \"" << (*i)->getASAP() << "\" line:" << (*i)->getNumLinha()<<endl;
//                cout<< "---DLY:  "<<(*i)->getDelayValComp()<<endl;
//                cout<< "---ASAP: "<<(*i)->getASAP()<<endl;
            }
            //all predecessors 
            for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
                if( ((*k)->getDestino() == (*i))  && ((*k)->getBlackEdge()==false  )){
                    dlyAux = FuncoesAux::StrToInt((*k)->getOrigem()->getDelayValComp());
                    pred = (*k)->getOrigem()->getASAP() + dlyAux;

                    if(pred > max){
                        max = pred;
                        if(debug)
                            cout<< "dependence \""<<(*k)->getOrigem()->getName()<<"\" ASAP:" << (*k)->getOrigem()->getASAP() << " line:" << (*k)->getOrigem()->getNumLinha()<<endl;
                    }
                }
            }
            
            //all source code predecessors
            if((*i)->getWE()){
                for(j=this->ListaComp.begin(); j != this->ListaComp.end(); j++){
                    if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM || (*j)->tipo_comp == CompType::AUX ) continue;
                    int line = (*j)->getNumLinha();
                    if(line > (*i)->getNumLinha()){
                        cout<< "break on: \""<<(*j)->getName()<<"\" ASAP:" << (*j)->getASAP() << " line:" << (*j)->getNumLinha()<<endl;
                        goto innerBreak;
                    }
                    pred = (*j)->getASAP();
                    if(pred > max){
                        max = pred;
                        if(debug)
                            cout<< " predecessor \""<<(*j)->getName()<<"\" ASAP:" << (*j)->getASAP() << " line:" << (*j)->getNumLinha()<<endl;
                    }
                }
            }
            innerBreak:
            
            if( (*i)->getASAP() != max ){
                (*i)->setASAP(max);
                change = true;
                if (max > this->getMaxSchedulingTime())
                    this->setMaxSchedulingTime(max);
            }
//            cout<<" "<<endl;
        }
    }
    cout<<"Scheduling (ASAP)...OK"<<endl;
}

int Core::calculateASAP(Componente* comp){
    bool debug = true;
    list<Ligacao*>::iterator    k;
    if(comp->getSync()){
        int dlyAux = FuncoesAux::StrToInt(comp->getDelayValComp());
        return comp->getASAP() + dlyAux;
    }else{
        int max = 0;
        for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
            if((*k)->getDestino() == comp){
                if ((*k)->getOrigem()->tipo_comp == CompType::REG || (*k)->getOrigem()->tipo_comp == CompType::MEM || (*k)->getOrigem()->tipo_comp == CompType::AUX ) continue;
                int newMax = this->calculateASAP((*k)->getOrigem());
                
                if(newMax > max){
                    max = newMax;
                    if(debug)
                        cout<< "calculating ASAP of \""<< comp->getName() << "\" by" << (*k)->getOrigem()->getName()<< endl;
            
                }
            }
        }
        return max;
    }
}

int Core::getMaxSchedulingTime(){
    return this->maxSchedulingTime;
}

void Core::setMaxSchedulingTime(int maxSchedulingTime){
    this->maxSchedulingTime = maxSchedulingTime;
}

void Core::copySchedulingTimes(){
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        (*i)->copySchedulingTimes();
    }
}

void Core::setSync(bool sync){
    this->sync = sync;
}

bool Core::isSync(){
    return this->sync;
}

void Core::addComponent(Componente* comp){
    this->ListaComp.push_back(comp);
    if(!this->isSync() && comp->getSync()){
        setSync(true);
    }
}

Componente* Core::getComponent(const string& name){
    Componente* comp = NULL;
    list<Componente*>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        if((*i)->getName() == name){
            comp = (*i);
        }
    }
    
    return comp;
}

Componente* Core::insereReg(Ligacao* lig){

    Componente* origem  = lig->getOrigem();  
 
    reg_op* reg = new reg_op(NULL, "WE");

    this->addComponent(reg);
    reg->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
    reg->setName("c"+FuncoesAux::IntToStr(this->ListaComp.size()));

    comp_ref* ref = new comp_ref(NULL, "WE");
//    this->addComponent(ref);
    ref->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
    ref->setNumLinha(origem->getNumLinha());

    ref->setTipoVar("VAR");
    ref->setNomeVarRef(reg->getName());
    ref->setName("c"+FuncoesAux::IntToStr(this->ListaComp.size()));
    ref->setComponenteRef(reg);
    ref->updateCompRef();

    ref->getPortDataInOut("IN")->setWidth(lig->getWidth());
    ref->getPortDataInOut("OUT")->setWidth(lig->getWidth());
    //CRIAR NOVA LIGACAO
    Ligacao* newLig = new Ligacao(ref, lig->getDestino(), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
    newLig->setPortDestino((lig->getPortDestino()));
    newLig->setPortOrigem(ref->getPortDataInOut("OUT"));
    newLig->setWidth(lig->getWidth());
    newLig->setTipo(ref->getPortDataInOut("OUT")->getType());

    //ADICIONAR NOME LIGACAO NA PORTA
    newLig->getPortDestino()->setLigacao(newLig->getNome());
    newLig->getPortOrigem()->setLigacao(newLig->getNome());

    //Adicionando as novas ligacoes no Registrador
    reg->addLigacao(newLig);
    reg->addLigacao(lig);

    //EDITAR PARAMETRO LIGACAO ANTIGA 
    lig->editDest(reg);
    lig->setPortDestino(reg->getPortDataInOut("IN"));

    //ADICIONAR LIGACAO NA PORTA
    lig->getPortDestino()->setLigacao(lig->getNome());

    //Excluir referencia da ligacao antiga
    newLig->getDestino()->removeLigacao(lig);
    newLig->getDestino()->addLigacao(newLig);

    this->ListaLiga.push_back(newLig);
    
    return ref;
}

Componente* Core::insereDelay(Ligacao* lig, int delay, int asap){
    
    string str = FuncoesAux::IntToStr(this->ListaComp.size());

    delay_op* comp = new delay_op(NULL);
    
    comp->setDelayVal(FuncoesAux::IntToStr(delay));

    
     //Setando Valor do ID
    comp->setNumIdComp(str);

    string nome = "c" + str;
    comp->setName(nome);
    comp->getPortDataInOut("IN")->setWidth(lig->getWidth());
    comp->getPortDataInOut("OUT")->setWidth(lig->getWidth());
    comp->setDelayBits(lig->getWidth());
    comp->setASAP(asap);

    //CRIAR NOVA LIGACAO
    Ligacao* newLig = new Ligacao(comp, lig->getDestino(), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
    newLig->setPortDestino((lig->getPortDestino()));
    newLig->setPortOrigem(comp->getPortDataInOut("OUT"));
    newLig->setWidth(lig->getWidth());
    newLig->setTipo(comp->getPortDataInOut("OUT")->getType());

    //ADICIONAR NOME LIGACAO NA PORTA
    newLig->getPortDestino()->setLigacao(newLig->getNome());
    newLig->getPortOrigem()->setLigacao(newLig->getNome());

    //Adicionando as novas ligacoes no Delay e no DESTINO DO DELAY
    comp->addLigacao(newLig);
    comp->addLigacao(lig);
    comp->setDelayBits(lig->getWidth());

    //Setando Valor do ID
    comp->setNumIdComp(str);

    //EDITAR PARAMETRO LIGACAO ANTIGA 
    lig->editDest(comp);
    lig->setPortDestino(comp->getPortDataInOut("IN"));

    //ADICIONAR LIGACAO NA PORTA
    lig->getPortDestino()->setLigacao(lig->getNome());

    //Excluir referencia da ligacao antiga
    newLig->getDestino()->removeLigacao(lig);
    newLig->getDestino()->addLigacao(newLig);
    
    this->ListaLiga.push_back(newLig);
    
    return comp;
}

void Core::setClkReset(){
    list<Componente*>::iterator i;
    //Setar todoas as portas CLK e RESET
    // <editor-fold defaultstate="collapsed" desc="Setar Portas CLK e RESET">
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp == CompType::REF) continue;
        if ((*i)->getPortOther("clk") != NULL)(*i)->getPortOther("clk")->setLigacao("\\clk\\");
        if ((*i)->getPortOther("reset") != NULL)(*i)->getPortOther("reset")->setLigacao("\\reset\\");
    }// </editor-fold>
}

void Core::geraArquivosDotHW(){
    string nameFilePath = this->project->get_file_info()->getFilenameFromID(0);
    const vector<string> fileVec = FuncoesAux::split(nameFilePath, "/");
    const vector<string> fileVec2= FuncoesAux::split(string(fileVec[fileVec.size()-1].c_str())  , ".");
    string nome = string(fileVec2[0].c_str());

    ArquivosDotHW *dot = new ArquivosDotHW(this->ListaComp, this->ListaLiga, nome);
    dot->imprimeHWDOT();
    dot->imprimeVHDL();
}

Core::~Core() {
}

