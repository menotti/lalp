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

Core::Core(SgProject* project, list<SgNode*> lista) {
    this->debug = false;
    this->isParallel = false;
    this->project = project;
    this->maxSchedulingTime = 0;
    this->ListaForParall = lista;
    
    this->identificaVariaveis();
    this->identificaFor();
    
    //Apos gerar todos os componentes
    //trocar os nomes dos comp duplicados
    if(this->isParallel){
        this->preIdentificacaoCompParalelizados();
    }
    
    this->FinalizaComponentes();
    this->identificaReturn();
    
    this->detectBackwardEdges();
    this->ALAP();
    this->balanceAndSyncrhonize();
    
    this->retirarCompDelayRedundante();
    
    this->setClkReset();
    
    this->geraArquivosDotHW();
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
        int qtdRetorno=0;
       
        string      tipoOP = "";
        string      tipoREF= "";
        if(this->isParallel == true){
            cout<<"#--variaveis paralelas"<<endl;
            
            //Identificar variaveis com os resultados, proximo passo e juntar estas em uma unica saida
            for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
                if ((*i)->tipo_comp != CompType::REF) continue;
                if ((*i)->getNomeVarRef() == varRetorno){
                    comp_ref* CompRefI = (comp_ref*) (*i);
                    if(CompRefI->getTipoVar() == "VET"){
                    }
                    if(CompRefI->getTipoVar() == "VAR"){
                        Ligacao* s1Lig = CompRefI->getLigacaoByName(CompRefI->getPortDataInOut("IN")->getLigacao());
//                        if( s1Lig->getOrigem()->getNomeCompVHDL() == "add_reg_op_s"){
                            tipoREF     = "VAR";
                            tipoOP      = "+";
//                        }
                    }
                    qtdRetorno++;
                }
            }
            
            if(tipoREF == "VAR" && tipoOP == "+"){
                comp_ref* CompRefI0     = NULL;
                comp_ref* CompRefI1     = NULL;
                comp_ref* CompRefLas    = NULL;
                op_add_s* CompResult    = NULL;
                // <editor-fold defaultstate="collapsed" desc="REF_COMP">
                cout<< "- Criacao de ADD com base em comp REF "<< endl;
                for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
                    if ((*i)->tipo_comp != CompType::REF) continue;
                    if ((*i)->getNomeVarRef() == varRetorno) {
                        cout<< "COMP: " << (*i)->getName()<< endl;
                        CompRefLas= (comp_ref*)(*i);
                        if (CompRefI0 == NULL) {
                            CompRefI0 = (comp_ref*)(*i);
                            CompRefLas= (comp_ref*)(*i);
                            cout<< "--- I0: " << CompRefI0->getName()<< endl;
                            continue;
                        };
                        if (CompRefI1 == NULL) {
                            CompRefI1 = (comp_ref*)(*i);
                            CompRefLas= NULL;
                            cout<< "--- I1: " << CompRefI1->getName()<< endl;
                        }
                        if (CompRefI0 != NULL && CompRefI1 != NULL) {
                            cout<< "--- CRIANDO LIGACAO I0 + I1: " << endl;
                            op_add_s* addComp = new op_add_s();
                            addComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                            addComp->setNumLinha(numLinha+1);
                            //            this->ListaComp.push_back(comp);
                            this->addComponent(addComp);

                            addComp->setName(CompRefI0->getName() + "_" + addComp->getNomeCompVHDL() + "_" + CompRefI1->getName());

                            Ligacao* newLig = new Ligacao(CompRefI0, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            newLig->setPortDestino(addComp->getPortOther("I0"));
                            newLig->setPortOrigem(CompRefI0->getPortDataInOut("OUT"));
                            newLig->setWidth(CompRefI0->getPortDataInOut("OUT")->getWidth());
                            newLig->setTipo(CompRefI0->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
                            newLig->getPortDestino()->setLigacao(newLig->getNome());
                            newLig->getPortOrigem()->setLigacao(newLig->getNome());

                            //ADICIONAR LIGACAO NO COMPONENTE
                            CompRefI0->addLigacao(newLig);
                            addComp->addLigacao(newLig);

                            //ADD LISTAS
                            this->ListaLiga.push_back(newLig);


                            Ligacao* newLig2 = new Ligacao(CompRefI1, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            newLig2->setPortDestino(addComp->getPortOther("I1"));
                            newLig2->setPortOrigem(CompRefI1->getPortDataInOut("OUT"));
                            newLig2->setWidth(CompRefI1->getPortDataInOut("OUT")->getWidth());
                            newLig2->setTipo(CompRefI1->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
                            newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                            newLig2->getPortOrigem()->setLigacao(newLig2->getNome());

                            //ADICIONAR LIGACAO NO COMPONENTE
                            CompRefI1->addLigacao(newLig2);
                            addComp->addLigacao(newLig2);

                            //ADD LISTAS
                            this->ListaLiga.push_back(newLig2);
			    cout<< "NEW ADD: "<< addComp->getName()<<endl;
			    cout<< "IO : "<< CompRefI0->getName()<<endl;
                            cout<< "I1 : "<< CompRefI1->getName()<<endl;
                            cout<< " "<< endl;

                            CompRefI0 = NULL;
                            CompRefI1 = NULL;
			    CompRefLas= NULL;
                        }
                    }
                }
		if(CompRefLas != NULL){
                	cout<< "CL : "<< CompRefLas->getName()<<endl;
                }else{
			cout<< "CL : "<<endl;
		}
		cout<< "-----------------------------"<<endl;
                cout<< "- Criacao de ADD com base em comp REF OK"<< endl;
                // </editor-fold>

                op_add_s* addOpI0  = NULL;
                op_add_s* addOpI1  = NULL;
                op_add_s* addOpLas = NULL;
                //VARRER TODAS AS NOVAS LIGACOES SEM SINAL NA PORTA SAIDA
                // <editor-fold defaultstate="collapsed" desc="ADD_OP">
                cout<< "- Criacao de ADD com base em comp ADD "<< endl;
                for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
                    if ((*i)->tipo_comp != CompType::OPE) continue;
                    if ((*i)->getPortDataInOut("OUT")->getLigacao() == "") {
                        addOpLas= (op_add_s*)(*i);
                        if (addOpI0 == NULL) {
                            addOpI0 = (op_add_s*)(*i);
                            addOpLas= (op_add_s*)(*i);
                            continue;
                        };
                        if (addOpI1 == NULL) {
                            addOpI1 = (op_add_s*)(*i);
                            addOpLas= NULL;
                        }
                        if (addOpI0 != NULL && addOpI1 != NULL) {
                            op_add_s* addComp = new  op_add_s();
                            addComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                            addComp->setNumLinha(addOpI0->getNumLinha() + 1);
                            //            this->ListaComp.push_back(comp);
                            this->addComponent(addComp);

                            addComp->setName(addOpI0->getName() + "_" + addComp->getNomeCompVHDL() + "_" + addOpI1->getName());

                            Ligacao* newLig = new Ligacao(addOpI0, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            newLig->setPortDestino(addComp->getPortOther("I0"));
                            newLig->setPortOrigem(addOpI0->getPortDataInOut("OUT"));
                            newLig->setWidth(addOpI0->getPortDataInOut("OUT")->getWidth());
                            newLig->setTipo(addOpI0->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
                            newLig->getPortDestino()->setLigacao(newLig->getNome());
                            newLig->getPortOrigem()->setLigacao(newLig->getNome());

                            //ADICIONAR LIGACAO NO COMPONENTE
                            addOpI0->addLigacao(newLig);
                            addComp->addLigacao(newLig);

                            //ADD LISTAS
                            this->ListaLiga.push_back(newLig);


                            Ligacao* newLig2 = new Ligacao(addOpI1, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            newLig2->setPortDestino(addComp->getPortOther("I1"));
                            newLig2->setPortOrigem(addOpI1->getPortDataInOut("OUT"));
                            newLig2->setWidth(addOpI1->getPortDataInOut("OUT")->getWidth());
                            newLig2->setTipo(addOpI1->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
                            newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                            newLig2->getPortOrigem()->setLigacao(newLig2->getNome());

                            //ADICIONAR LIGACAO NO COMPONENTE
                            addOpI1->addLigacao(newLig2);
                            addComp->addLigacao(newLig2);

                            //ADD LISTAS
                            this->ListaLiga.push_back(newLig2);
			    cout<< "NEW ADD: "<< addComp->getName()<<endl;
			    cout<< "IO : "<< addOpI0->getName()<<endl;
                            cout<< "I1 : "<< addOpI1->getName()<<endl;
                            cout<< " "<< endl;
                            addOpI0 = NULL;
                            addOpI1 = NULL;
                            addOpLas= NULL;
                        }
                    }
                }// </editor-fold>
                if(addOpLas != NULL){
			cout<< "LS : "<< addOpLas->getName()<<endl;
		}else{
			cout<< "LS : "<<endl;
		}
		cout<< "----------------------------"<<endl;
                cout<< "- Criacao de ADD com base em comp ADD OK"<< endl;
                
                cout<< "- Ligar o ultimo ADD ao ultimo REF"<< endl;
                if(addOpLas != NULL && CompRefLas != NULL){
                    op_add_s* addComp = new op_add_s();
                    CompResult = addComp;
                    addComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                    addComp->setNumLinha(addOpLas->getNumLinha()+1); 
        //            this->ListaComp.push_back(comp);
                    this->addComponent(addComp);

                    addComp->setName(addOpLas->getName()+"_"+addComp->getNomeCompVHDL()+"_"+CompRefLas->getName());

                    Ligacao* newLig = new Ligacao(addOpLas, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                    newLig->setPortDestino(addComp->getPortOther("I0"));
                    newLig->setPortOrigem(addOpLas->getPortDataInOut("OUT"));
                    newLig->setWidth(addOpLas->getPortDataInOut("OUT")->getWidth());
                    newLig->setTipo(addOpLas->getPortDataInOut("OUT")->getType());

                    //ADICIONAR NOME LIGACAO NA PORTA
                    newLig->getPortDestino()->setLigacao(newLig->getNome());
                    newLig->getPortOrigem()->setLigacao(newLig->getNome());

                    //ADICIONAR LIGACAO NO COMPONENTE
                    addOpLas->addLigacao(newLig);
                    addComp->addLigacao(newLig);

                    //ADD LISTAS
                    this->ListaLiga.push_back(newLig);


                    Ligacao* newLig2 = new Ligacao(CompRefLas, addComp, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                    newLig2->setPortDestino(addComp->getPortOther("I1"));
                    newLig2->setPortOrigem(CompRefLas->getPortDataInOut("OUT"));
                    newLig2->setWidth(CompRefLas->getPortDataInOut("OUT")->getWidth());
                    newLig2->setTipo(CompRefLas->getPortDataInOut("OUT")->getType());

                    //ADICIONAR NOME LIGACAO NA PORTA
                    newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                    newLig2->getPortOrigem()->setLigacao(newLig2->getNome());

                    //ADICIONAR LIGACAO NO COMPONENTE
                    CompRefLas->addLigacao(newLig2);
                    addComp->addLigacao(newLig2);

                    //ADD LISTAS
                    this->ListaLiga.push_back(newLig2);
                    addOpLas = NULL;
                    CompRefLas = NULL;
                }else{
                    CompResult = addOpLas;
                }
                cout<< "- Ligar o ultimo ADD ao ultimo REF OK"<< endl;
                
                
                cout<< "- Criar e ligar RESULT "<< endl;
                comp_aux* comp_return = new comp_aux(NULL,"RESULT");
                comp_return->setName("result");
                comp_return->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                comp_return->setNumLinha(1000);
		cout<< "- 1"<< endl;
                //LIGACAO
                Ligacao* newLig3 = new Ligacao(CompResult, comp_return, "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                newLig3->setPortDestino(comp_return->getPortDataInOut("IN"));
                newLig3->setPortOrigem(CompResult->getPortDataInOut("OUT"));
                newLig3->setWidth(CompResult->getPortDataInOut("OUT")->getWidth());
                newLig3->setTipo(CompResult->getPortDataInOut("OUT")->getType());
		cout<< "- 2"<< endl;
                //ADICIONAR NOME LIGACAO NA PORTA
                newLig3->getPortDestino()->setLigacao(newLig3->getNome());
                newLig3->getPortOrigem()->setLigacao(newLig3->getNome());
		cout<< "- 3"<< endl;
                //ADICIONAR LIGACAO NO COMPONENTE
                CompResult->addLigacao(newLig3);
                comp_return->addLigacao(newLig3);

                //ADD LISTAS
                this->ListaLiga.push_back(newLig3);
                this->addComponent(comp_return);
                cout<< "- Criar e ligar RESULT OK"<< endl;
            }
        }else{
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
    bool hadForParallel = false;
    
    
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
            
            
            cout<< "+++++QTD ELEMENTOS: " << this->ListaForParall.size() <<endl;
            if (this->ListaForParall.size() > 0){
                hadForParallel = true;
                this->isParallel = true;
            }
            
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
                    
                    if(hadForParallel){
                        list<SgNode*>::iterator i;
                        for (i = this->ListaForParall.begin(); i != this->ListaForParall.end(); i++) {
                            SgNode* nodo_a      = isSgNode(cur_for);
                            SgNode* nodo_b      = isSgNode((*i));
                            SgNode* basicBlocP  = NULL;
                            int id = 1;
                            if(nodo_a == nodo_b){                                
                                SgStatement* loopBody       = cur_for->get_loop_body();
                                Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(loopBody,V_SgNode); 
                                cout<<" PROCESSO DE IDENTIFICACAO DAS LINHAS PARALELIZADAS"<<endl;
                                cout<<" SIZE: " << varLoopBody.size() <<endl;
                                for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                                {
                                    SgBasicBlock* basic = isSgBasicBlock((*ilb));
                                    SgNode* sg_basic    = isSgNode((*ilb));
                                    if(basic != NULL){
                                        if ( (basic->get_parent() == nodo_a) && (basicBlocP == NULL) ){
                                            basicBlocP = sg_basic;
                                            Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(sg_basic,V_SgNode); 
                                            if (varLoopBody.size()==0) continue;
                                            int aux = 0;
                                            cout<<"linha paralelizada: "<< id <<endl;
                                            for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                                            {
                                                
                                                if(isSgExprStatement(*ilb)||isSgVarRefExp(*ilb)||isSgMultiplyOp(*ilb)||isSgPntrArrRefExp(*ilb)||isSgAddOp(*ilb)) continue;                                                
                                                if(isSgIntVal(*ilb)) continue;
                                                if(isSgBasicBlock(*ilb)){
                                                    aux++;
                                                }
                                                if(aux > 1) continue;
                                                SgNode* expStmt = isSgNode(*ilb);
                                                if(expStmt != NULL){
                                                    analisaExp(expStmt, NULL, "", FuncoesAux::IntToStr(id));
                    //                                break;
                                                }
                                            }
                                            cout<<"#linha paralelizada: "<< id << " - OK" <<endl;
                                            id++;
                                            continue;
                                        }

                                        if ( basic->get_parent() == basicBlocP && (basicBlocP != NULL)  ) {
                                            Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(basic,V_SgNode); 
                                            if (varLoopBody.size()==0) continue;
                                            
                                            cout<<"linha paralelizada: "<< id <<endl;
                                            for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                                            {
                                                if(isSgExprStatement(*ilb)||isSgBasicBlock(*ilb)||isSgVarRefExp(*ilb)||isSgMultiplyOp(*ilb)||isSgPntrArrRefExp(*ilb)||isSgAddOp(*ilb)) continue;
                                                if(isSgIntVal(*ilb))continue;
                                                
                                                SgNode* expStmt = isSgNode(*ilb);

                                                if(expStmt != NULL){
                                                    analisaExp(expStmt, NULL, "", FuncoesAux::IntToStr(id));
                                                }
                                            }
                                            cout<<"#linha paralelizada: "<< id << " - OK" <<endl;
                                            id++;
                                            continue;
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        

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
                            if(isSgIntVal(*ilb))continue;

                            SgNode* expStmt = isSgNode(*ilb);
                            cout<< "NODOS INTERNOS BODY FOR: "<< expStmt->class_name() << endl;
                            if(expStmt != NULL){

                                analisaExp(expStmt, NULL, "", "0");
//                                break;
                            }
                        }
                        cout<<"# Iniciando processo expressao FOR: OK        #"<<endl;
                    }
                }         
            }
        }
    }    
}

Componente* Core::analisaExp(SgNode *nodoAtual, SgNode* pai, const string& aux, const string& lineParal) {
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
        analisaExp(proxNodo, pai, aux, lineParal);
    }
    
    SgBasicBlock* sgBasic =  isSgBasicBlock(nodoAtual);
    if (sgExpEst != NULL) {
        SgNode* proxNodo = isSgNode(sgBasic);
        analisaExp(proxNodo, pai, aux, lineParal);
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
            
            analisaExp(filhoEsq, nodoAtual,"WE", lineParal);
            analisaExp(filhoDir, filhoEsq, aux, lineParal);
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
            
            analisaExp(filhoEsq, nodoAtual, "WE", lineParal);
            analisaExp(filhoDir, filhoEsq, aux, lineParal);
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
        analisaExp(proxNodo, pai, aux, lineParal);
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
            comp->setNumParalelLina(lineParal);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal);
            analisaExp(filhoDir, nodoAtual, aux, lineParal);
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
            comp->setNumParalelLina(lineParal);
            this->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal);
            analisaExp(filhoDir, nodoAtual, aux, lineParal);
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
//            analisaExp(filhoEsq, nodoAtual, debug, aux, lineParal);
//            analisaExp(filhoDir, nodoAtual, debug, aux, lineParal);
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
            comp->setNumParalelLina(lineParal);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal);
            analisaExp(filhoDir, nodoAtual, aux, lineParal);
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
                    ifComp->setNumParalelLina(lineParal);
                    compReturn = ifComp;
                }
            }
        }
        if(tBody != NULL){
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(tBody,V_SgNode);             
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                if(isSgExprStatement((*i))){
                    analisaExp((*i), NULL, "", lineParal);
                }
            }
        }
        if(fBody != NULL){
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(fBody,V_SgNode);             
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                if(isSgExprStatement((*i))){
                    analisaExp((*i), NULL, "", lineParal);
                }
            }
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
        comp->setNumParalelLina(lineParal);
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
        comp->setNumParalelLina(lineParal);
        if(pai) comp->setPai(pai);
        this->addComponent(comp);
        this->updateCompRef(decVar, comp);
        compReturn = comp;
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
        comp_input->setNumParalelLina(lineParal);
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

void Core::preIdentificacaoCompParalelizados(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    cout<<"--Processo renomear variaveis paralelizadas iguais"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REF) continue;
        if ((*i)->getEIndice() == true) continue;
        comp_ref* CompRefI = (comp_ref*) (*i);
        int numP = FuncoesAux::StrToInt(CompRefI->getNumParalelLina());
        if(numP > 1 ){
//            cout<< "("<<CompRefI->getTipoVar()<<") NOME: " << (*i)->getName()<< ": COM ORIGINAL: "<< (*i)->getNomeVarRef() << " - #Line: " << (*i)->getNumLinha() << " - #ID Paral: " << (*i)->getNumParalelLina() << " - #REF: " << (*i)->getComponenteRef()->getName() << " - #REF2: " << (*i)->getComponenteRef()->getNomeCompVHDL() <<endl;

            if(CompRefI->getTipoVar() == "VET"){

//                block_ram *newComp = new block_ram();
                block_ram *ref = (block_ram*)(*i)->getComponenteRef();
                
                block_ram *newComp = new block_ram(*ref);
                
                newComp->setName((*i)->getName());
                (*i)->setComponenteRef(newComp);
                newComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                this->addComponent(newComp);
                if(CompRefI->getNomeCompVHDL() != "block_ram") newComp->setNomeCompVHDL("block_ram_"+(*i)->getName());
            }
            if(CompRefI->getTipoVar() == "VAR"){
                if(CompRefI->getNomeCompVHDL() == "reg_op"){
                    reg_op *ref2 = (reg_op*)(*i)->getComponenteRef();
                    reg_op *newComp = new reg_op(*ref2);

                    newComp->setName((*i)->getName());
                    (*i)->setComponenteRef(newComp);
                    newComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                    this->addComponent(newComp);
                }
                if(CompRefI->getNomeCompVHDL() == "add_reg_op_s"){
                    add_reg_op_s *ref2 = (add_reg_op_s*)(*i)->getComponenteRef();
                    add_reg_op_s *newComp = new add_reg_op_s(*ref2);

                    newComp->setName((*i)->getName());
                    (*i)->setComponenteRef(newComp);
                    newComp->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
                    this->addComponent(newComp);
                }
            }
        }
    }
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REF) continue;
        if ((*i)->getEIndice() == true) continue;
        comp_ref* CompRefI = (comp_ref*) (*i);
        cout<< "("<<CompRefI->getTipoVar()<<") NOME: " << (*i)->getName()<< ": COM ORIGINAL: "<< (*i)->getNomeVarRef() << " - #Line: " << (*i)->getNumLinha() << " - #ID Paral: " << (*i)->getNumParalelLina() << " - #REF: " << (*i)->getComponenteRef()->getName() << " - #REF2: " << (*i)->getComponenteRef()->getNomeCompVHDL()<< " - #REF2: " << (*i)->getComponenteRef()->getNumIdComp()  <<endl;
        
    }
    
    cout<<"--Processo renomear variaveis paralelizadas iguais OK"<<endl;
    
    //Apos a identificacao verificar a necessidade de duplicacao de mem'orias
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

void Core::deletaLigacao(const string& name){
    list<Ligacao*>::iterator    i;
    for (i = this->ListaLiga.begin(); i != this->ListaLiga.end(); i++) {
        if((*i)->getNome() == name){
           (*i)->setAtivo(false); 
        }
    }
}

void Core::retirarCompDelayRedundante(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::DLY) continue;
        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::DLY) continue;
            if ((*i)->getName() == (*j)->getName()) continue;
            delay_op* CompRefI = (delay_op*) (*i);
            delay_op* CompRefJ = (delay_op*) (*j);
            if( CompRefI->getDelayVal() == CompRefJ->getDelayVal()){               
                Ligacao* dlyI  = (*i)->getLigacaoByName((*i)->getPortDataInOut("IN")->getLigacao());
                Ligacao* dlyJ  = (*j)->getLigacaoByName((*j)->getPortDataInOut("IN")->getLigacao());
                Ligacao* dlyJ2 = (*j)->getLigacaoByName((*j)->getPortDataInOut("OUT")->getLigacao());
                Ligacao* dlyI2 = (*i)->getLigacaoByName((*i)->getPortDataInOut("OUT")->getLigacao());
                if(dlyI->getOrigem() == dlyJ->getOrigem() && dlyI->getPortOrigem() == dlyJ->getPortOrigem() && 
                  (*i)->getPortDataInOut("OUT")->getWidth() == (*j)->getPortDataInOut("OUT")->getWidth() && 
                  (*i)->getPortDataInOut("IN")->getWidth() == (*j)->getPortDataInOut("IN")->getWidth() &&
                  (*i)->getPortDataInOut("OUT")->getType() == (*j)->getPortDataInOut("OUT")->getType() && 
                  (*i)->getPortDataInOut("IN")->getType() == (*j)->getPortDataInOut("IN")->getType() ){
//                    cout<< " --------------------------- "<<endl;
//                    cout<< " (*i) " << (*i)->getName() << " - " << CompRefI->getDelayVal() << endl;
//                    cout<< " Lig IN : " << dlyI->getNome() << " - " << dlyI->getOrigem()->getName() << " -> "<< dlyI->getDestino()->getName()  << endl;        
//                    cout<< " Lig OUT: " << dlyI2->getNome() << " - " << dlyI2->getOrigem()->getName() << " -> "<< dlyI2->getDestino()->getName()  << endl; 
//                    cout<< " "<< endl;
//                    cout<< " (*j) " << (*j)->getName() << " - " << CompRefJ->getDelayVal() << endl;
//                    cout<< " Lig IN : " << dlyJ->getNome() << " - " << dlyJ->getOrigem()->getName() << " -> "<< dlyJ->getDestino()->getName()  << endl;        
//                    cout<< " Lig OUT: " << dlyJ2->getNome() << " - " << dlyJ2->getOrigem()->getName() << " -> "<< dlyJ2->getDestino()->getName()  << endl;  
//                    cout<< " --------------------------- "<<endl ;
                    dlyJ->getOrigem()->removeLigacao(dlyJ);
                    dlyJ2->getDestino()->removeLigacao(dlyJ2);
                    
                    dlyI->getPortOrigem()->setLigacao((*i)->getPortDataInOut("IN")->getLigacao());
                    
                    //CRIAR NOVA LIGACAO
                    string str = FuncoesAux::IntToStr(this->ListaLiga.size());
                    Ligacao* lig = new Ligacao((*i), dlyJ2->getDestino(), "s" + str);
                    lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                    lig->setPortDestino(dlyJ2->getPortDestino());
                    lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                    lig->setTipo((*i)->getPortDataInOut("OUT")->getType());

                    //ADICIONAR LIGACAO NA PORTA                        
                    lig->getPortDestino()->setLigacao(lig->getNome());
                    lig->getPortOrigem()->setLigacao(lig->getNome());

                    //ADICIONAR LIGACAO AOS COMPONENTES
                    (*i)->addLigacao(lig);
                    dlyJ2->getDestino()->addLigacao(lig);

                    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                    this->ListaLiga.push_back(lig);
                                        
                    this->deletaLigacao(dlyJ->getNome());
                    this->deletaLigacao(dlyJ2->getNome());
                    
                    //Neste caso nao gera nem VHDL/DOT para o J (comp repetido)
                    (*j)->tipo_comp = CompType::REG; 
                }
            }
        }
    }
}

void Core::removeComReg(Componente* compRemove){
    Ligacao* sOrigem = compRemove->getLigacaoByName(compRemove->getPortDataInOut("IN")->getLigacao());
    Componente* compOrigem = sOrigem->getOrigem();    
    
    Ligacao* s1Lig = compRemove->getLigacaoByName(compRemove->getPortDataInOut("OUT")->getLigacao());
    s1Lig->getOrigem()->removeLigacao(s1Lig);
    s1Lig->editOrig(compOrigem);
    compOrigem->addLigacao(s1Lig);

    s1Lig->setPortOrigem(compOrigem->getPortDataInOut("OUT"));
    s1Lig->setWidth(compOrigem->getPortDataInOut("OUT")->getWidth());
    s1Lig->setTipo(compOrigem->getPortDataInOut("OUT")->getType());
    s1Lig->getPortOrigem()->setLigacao(s1Lig->getNome());

    compRemove->tipo_comp = CompType::REG;
   
    list<Ligacao*>::iterator    k;
    for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if ( (*k)->getAtivo() == false  ) continue;
        if((*k)->getOrigem() == compRemove){
            
            (*k)->getOrigem()->removeLigacao((*k));
            (*k)->editOrig(compOrigem);
            compOrigem->addLigacao((*k));

            (*k)->setPortOrigem(compOrigem->getPortDataInOut("OUT"));
            (*k)->setWidth(compOrigem->getPortDataInOut("OUT")->getWidth());
            (*k)->setTipo(compOrigem->getPortDataInOut("OUT")->getType());
            (*k)->getPortOrigem()->setLigacao((*k)->getNome());     
        }
    }
    
    
    if(compRemove->getPortOther("we")->getLigacao() != ""){
        Ligacao* s1Lig2 = compRemove->getLigacaoByName(compRemove->getPortOther("we")->getLigacao());
        s1Lig->getOrigem()->removeLigacao(s1Lig2);
        s1Lig->getDestino()->removeLigacao(s1Lig2);
        this->deletaLigacao(s1Lig2->getNome());
    }
}

void Core::substiuiComRecorente(Componente* origem, Componente* destino){
    //Ligacao nodo DESTINO
    Ligacao* sDestino = destino->getLigacaoByName(destino->getPortDataInOut("OUT")->getLigacao());    
    sDestino->getDestino()->removeLigacao(sDestino);
    
    //CRIAR NOVA LIGACAO
    string str = FuncoesAux::IntToStr(this->ListaLiga.size());
    Ligacao* lig = new Ligacao(origem, sDestino->getDestino(), "s" + str);
    lig->setPortOrigem(origem->getPortDataInOut("OUT"));
    lig->setPortDestino(sDestino->getPortDestino());
    lig->setWidth(origem->getPortDataInOut("OUT")->getWidth());
    lig->setTipo(origem->getPortDataInOut("OUT")->getType());

    //ADICIONAR LIGACAO NA PORTA                        
    lig->getPortDestino()->setLigacao(lig->getNome());
    lig->getPortOrigem()->setLigacao(lig->getNome());

    //ADICIONAR LIGACAO AOS COMPONENTES
    origem->addLigacao(lig);
    sDestino->getDestino()->addLigacao(lig);

    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
    this->ListaLiga.push_back(lig);

    this->deletaLigacao(sDestino->getNome());
    //Neste caso nao gera nem VHDL/DOT para o J (comp repetido)
    destino->tipo_comp = CompType::REG;

}

void Core::FinalizaComponentes(){
 
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    list<Componente*>ListaCompAux;
    //Ligacao* reset = new 
    int qtdLig = 0;
        
    //Processo de Ligacao SIMPLES (cria a ligacao disponivel na arvore AST gerada pelo ROSE)
    // <editor-fold defaultstate="collapsed" desc="Cria ligacoes conforme ROSE AST">
    cout<<"--Criando ligacoes basicas"<<endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
            if ((*i)->tipo_comp ==  CompType::REG || (*i)->tipo_comp == CompType::MEM || (*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
            if ((*i)->node == (*j)->node) continue;
            
            if ((*i)->getPai() == (*j)->node) {
//                cout<< "---------------------" << endl;
//                cout<< (*i)->getName() << " -> " << (*j)->getName() << endl;
//                cout<< "---------------------" << endl;
                if( (*i)->getPortDataInOut("OUT")->getLigacao() == "" ){
                    string str = FuncoesAux::IntToStr(this->ListaLiga.size());                   
                    string portIn = "IN";
                    Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                    if( (*j)->tipo_comp == CompType::OPE){
                        string nome = "";
                        if((*j)->getPortOther("I0")->getLigacao() == ""){
                            portIn = "I0";
                            nome = (*i)->getName()+"_"+(*j)->getNomeCompVHDL();
                        }else{
                            portIn = "I1";
                            nome = (*j)->getName()+"_"+(*i)->getName();   
                        }
                        (*j)->setName(nome);                       
                    }
                    if(portIn == "IN"){
                        lig->setPortDestino((*j)->getPortDataInOut("IN"));
                    }else{
                        lig->setPortDestino((*j)->getPortOther(portIn));
                    }

                    lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                    lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                    lig->setTipo((*i)->getPortDataInOut("OUT")->getType());
                    
                    //INFORMAR CADA PORTA QUEM E SUA LIGACAO
                    (*i)->getPortDataInOut("OUT")->setLigacao(lig->getNome());
                    if(portIn == "IN"){
                        (*j)->getPortDataInOut("IN")->setLigacao(lig->getNome());
                    }else{
                        (*j)->getPortOther(portIn)->setLigacao(lig->getNome());
                    }

                    //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
                    (*i)->addLigacao(lig);
                    (*j)->addLigacao(lig);
                    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                    this->ListaLiga.push_back(lig);
                    
                    if((*j)->getNomeCompVHDL() == "add_reg_op_s"){
                        if((*j)->getPortOther("I0")->getLigacao() == ""){
                            Ligacao* lig1 = new Ligacao((*j), (*j), "s" + FuncoesAux::IntToStr(this->ListaLiga.size()));
                            
                            lig1->setPortOrigem((*j)->getPortDataInOut("OUT"));
                            lig1->setPortDestino((*j)->getPortOther("I0"));
                            lig1->setWidth((*j)->getPortDataInOut("OUT")->getWidth());
                            lig1->setTipo((*j)->getPortDataInOut("OUT")->getType());
                            
                            (*j)->getPortDataInOut("OUT")->setLigacao(lig1->getNome());
                            (*j)->getPortOther("I0")->setLigacao(lig1->getNome());
                            
                            (*j)->addLigacao(lig1);
                            this->ListaLiga.push_back(lig1);
                        }
                    }
                }
            }
        }
    }
    cout<<"--Criando ligacoes basicas: OK"<<endl;
    // </editor-fold>    
    
    //Criar ligacoes entre componentes iguais ou com o mesmo nome neste caso
    //evitar a repeticao destes na dentro do mesmo
    // <editor-fold defaultstate="collapsed" desc="Substituir nodos RECORRENTES">
    //
    //TODO: No passo 1 nao esta funcionando quando encontrar a mesma var(WE)
    // a = 1 + 3;
    // c = a + 1;
    // a = 2 + c; - ERROR
    // d = a + 1; - ERROR
    //
    cout<<"--Removendo componentes redundantes:"<<endl;
//    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp != CompType::REF) continue;
//        if ((*i)->getWE()) continue; //apenas nao inicializados
//        comp_ref* CompRefAux = NULL;
//        for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
//            if ((*j)->getWE()) continue;
//            comp_ref* CompRefI = (comp_ref*) (*i);
//            comp_ref* CompRefJ = (comp_ref*) (*j);
//            if (CompRefI->getName() == CompRefJ->getNomeVarRef() && CompRefI->node != CompRefJ->node) {
//                if ((*i)->getPortDataInOut("OUT")->getLigacao() != "") {
//                    this->substiuiComRecorente((*i), (*j));
//                    (*j)->tipo_comp = CompType::REG;
//                    CompRefAux = (comp_ref*) (*i);
//                }
//            }
//        }
//        if(CompRefAux != NULL){
//            comp_aux* comp_input = new comp_aux(NULL, "VALOR");
//            comp_input->setName("c_" +CompRefAux->getNomeVarRef()+":"+CompRefAux->getGenericMapVal("initial", "VAL"));
//            comp_input->setNumIdComp(FuncoesAux::IntToStr(this->ListaComp.size()));
//            comp_input->setValAux((*i)->getGenericMapVal("initial", "VAL"));
//            comp_input->getPortDataInOut("OUT")->setLigacao((*i)->getPortDataInOut("OUT")->getLigacao());
//            this->addComponent(comp_input);
//
//            for (k = this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
//                if((*k)->getOrigem() == (*i)){
//                    (*k)->editOrig(comp_input);
//                    (*i)->removeLigacao((*k));
//                    (*k)->setPortOrigem(comp_input->getPortDataInOut("OUT"));
//                    comp_input->addLigacao((*k));
//                }
//            }
//            (*i)->tipo_comp = CompType::REG;
//        }
//    }
//    cout<<" # Parte 2: "<<endl;
//    comp_ref* CompRefAux = NULL;
//    int indJ = 0;
//    bool aux = false;
//    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++){
//        if ((*i)->tipo_comp != CompType::REF) continue;
//        if((*i)->getWE()){
//            CompRefAux = (comp_ref*)(*i);
//        }
//        if(CompRefAux != NULL){
//            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++){
//                if ((*j)->tipo_comp != CompType::REF) continue;
//                if ((*i)->node == (*j)->node) continue;
//                if ((*i)->getNumIdComp() == (*j)->getNumIdComp())
//                if ((*j)->getNumLinha() < CompRefAux->getNumLinha()) continue;
//                comp_ref* refI = (comp_ref*)(*j);
//                if(CompRefAux->getNomeVarRef() == refI->getNomeVarRef()){
//                    if((*j)->getWE())break;
//                    
//                    this->substiuiComRecorente((*i),(*j));
//                    (*j)->tipo_comp = CompType::REG;                
//                }
//            }
//        }
//    }   
    cout<<"--Removendo componentes redundantes: OK"<<endl;
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
            cout<<"COMPOENENTE: "<< (*i)->getName() << " - "<<  (*i)->getNomeCompVHDL() <<endl;
            for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                
                if ((*j)->tipo_comp == CompType::REF) {
                    //Necessario para pegar funcao especifica do contador
                    comp_ref* CompRef = (comp_ref*)(*j); 
                    cout<<"ref: "<< CompRef->getName() <<endl;
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
                            cout<<"COMPOENENTE: "<< (*i)->getName() << " - "<<  (*i)->getNomeCompVHDL() <<endl;
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

    // <editor-fold defaultstate="collapsed" desc="Efetuar ligacao varaivel que liga no indice vetor">
    cout << "--Criando novas ligacoes indice vet com variavel:" << endl;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->tipo_comp == CompType::REF) {

            comp_ref* CompRefI = (comp_ref*) (*i);
            if (CompRefI->getTipoVar() != "VET") continue;

            if (CompRefI->getPortOther("address")->getLigacao() == "") {
                for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
                    if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
                    if ((*j)->tipo_comp == CompType::REF) {
                        comp_ref* CompRefJ = (comp_ref*) (*j);
                        if (CompRefJ->getTipoVar() != "VAR") continue;
                        if (CompRefI->getNomeVarIndex() == CompRefJ->getNomeVarRef()) {
                            if (CompRefI->getNumParalelLina() != CompRefJ->getNumParalelLina()) continue;
                             
                             //CRIAR NOVA LIGACAO
                            string str = FuncoesAux::IntToStr(this->ListaLiga.size());
                            Ligacao* lig = new Ligacao((*j), (*i), "s" + str);
                            lig->setPortOrigem((*j)->getPortDataInOut("OUT"));
                            lig->setPortDestino((*i)->getPortOther("address"));
                            lig->setWidth((*j)->getPortDataInOut("OUT")->getWidth());
                            lig->setTipo((*j)->getPortDataInOut("OUT")->getType());

                            //ADICIONAR LIGACAO NA PORTA                        
                            lig->getPortDestino()->setLigacao(lig->getNome());
                            lig->getPortOrigem()->setLigacao(lig->getNome());

                            //ADICIONAR LIGACAO AOS COMPONENTES
                            (*i)->addLigacao(lig);
                            (*j)->addLigacao(lig);

                            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                            this->ListaLiga.push_back(lig);

                            //                            this->removeComReg((*j));
                            //                            (*j)->tipo_comp = CompType::REG;
                        }
                    }
                }
            }
        }
    }
    cout << "--Criando novas ligacoes indice vet com variavel: OK" << endl; // </editor-fold>

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
    cout<<"--Criando novas ligacoes do Contador: OK"<<endl;
    // </editor-fold> 
   
    
    

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
    string name= "";
    if(nodo_ref_var != NULL){
        comp->setTipoVar("VAR");
        comp->setNomeVarRef(nodo_ref_var->get_symbol()->get_name().getString());
       
//        if(comp->getNumParalelLina() == ""){
            name = nodo_ref_var->get_symbol()->get_name().getString();
//        }else{
//            name = nodo_ref_var->get_symbol()->get_name().getString()+comp->getNumParalelLina();
//        }
        comp->setName(name);
        comp->setNomeVarRef(name);
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
            
//            if(comp->getNumParalelLina() == ""){
            name = arrName;
//            }else{
//                nome = arrName+comp->getNumParalelLina();
//            }
            comp->setName(name);
            comp->setNomeVarIndex(arrPos);            
        }
        
    }
    
    //VERIFICAR A EXISTENCIA DE OUTRO COMPONENTE COM O MESMO NOME
    list<Componente*>::iterator i;
    for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->tipo_comp == CompType::REF){
            comp_ref* CompRef = (comp_ref*)(*i);
            if(CompRef->getName() == comp->getNomeVarRef()  && CompRef->node != comp->node){
//                    cout<< " ##################### " << endl;
//                    cout<< " COMP REF: " << CompRef->getName() << endl;
//                    cout<< " COMP    : " << comp->getNomeVarRef() << endl;
//                    cout<< " ##################### " << endl;
//                    if(comp->getNumParalelLina() == ""){
                    name = comp->getNomeVarRef()+"_"+FuncoesAux::IntToStr(this->ListaComp.size());
//                    }else{
//                        nome = comp->getNomeVarRef()+comp->getNumParalelLina()+"_"+FuncoesAux::IntToStr(this->ListaComp.size());
//                    }
                comp->setName(name);
            }
        }
    }
    
    //PASSO PARA VERIFICAR A EXISTENCIA OPERADOR += 
    //NESTE CASO O COMPONENTE E' OUTRO
    if(isSgPlusAssignOp(comp->getPai())){
        list<Componente*>::iterator i;
//        cout<<"-----ACHOU: "<< comp->getName() <<endl;
        for (i = this->ListaComp.begin(); i != this->ListaComp.end(); i++) {
//            cout<< (*i)->getName()<< "-- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
            if ((*i)->tipo_comp !=  CompType::REG) continue;
            if ((*i)->getName() == comp->getName()){
//                cout<< "---" << (*i)->getName()<< " -- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
                add_reg_op_s* add_reg = new add_reg_op_s((*i)->node, "WE");
//                if(comp->getNumParalelLina() == ""){
                        name = (*i)->getName();
//                }else{
//                    nome = (*i)->getName()+comp->getNumParalelLina();
//                }
                add_reg->setName(name);
                add_reg->setNomeVarRef(name);
                add_reg->setNumIdComp((*i)->getNumIdComp());
                add_reg->setValor((*i)->getGenericMapVal("initial", "VAL"));
                (*i) = add_reg;                
            }
        }
    }
    
    //MODIFICANDO E IDENTIFICANDO VARIAVEIS DO TIPO INDICES
    list<Componente*>::iterator j;
    for (j = this->ListaComp.begin(); j != this->ListaComp.end(); j++) {
        if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) {
            
            if (comp->getName() == (*j)->getName() || comp->getNomeVarRef() == (*j)->getName() ) {
                comp->setComponenteRef((*j));
                comp->updateCompRef();
                if(isIndiceVector(comp->getName())){
                    comp->setEIndice(true);
                    name = comp->getName()+"_"+FuncoesAux::IntToStr(this->ListaComp.size());
                    comp->setName(name);
                    comp->getComponenteRef()->setEIndice(true);
//                    cout<<comp->getName()<<endl;
//                    cout<<comp->imprimePortas()<< endl;
                }
            }
        }
    }
    
    if(expIndVec == true && nodo_ref_arr != NULL){
        SgNode* expInd = isSgNode( nodo_ref_arr->get_rhs_operand_i() );
        Componente* compExp = analisaExp(expInd, NULL, "", comp->getNumParalelLina());
        
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
//        SgNode* nodeCond = NULL;
        
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
//                varID var = SgExpr2Var(opMenorIgual->get_rhs_operand_i());
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
            SgPlusAssignOp* opAttMais     = isSgPlusAssignOp(*for3);
            //SgVarRefExp*  varIncr       = isSgVarRefExp(*for3);
            if(opMaisMais != NULL){
                comp->setGenericMapIncrements("1");
                comp->setGenericMapDown("0");
            }
            if(opMenosMenos != NULL){
                comp->setGenericMapIncrements("1");
                comp->setGenericMapDown("1");
            }
            if(opAttMais != NULL){
                SgNode* filhoAddDir  = isSgNode(opAttMais->get_rhs_operand_i());
                if(filhoAddDir != NULL){
                    SgIntVal* intVal = isSgIntVal(filhoAddDir);
                    if(intVal != NULL){
                        string str = FuncoesAux::IntToStr(intVal->get_value());
                        comp->setGenericMapIncrements(str);
                        comp->setGenericMapDown("0");
                    }
                }
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
        comp->qtd_elem_vet = FuncoesAux::StrToInt(string(words[7].c_str()));
        
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
            int id = 0;
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    string str = FuncoesAux::IntToStr(intVal->get_value());
                    comp->valores.push_back(intVal->get_value());

                    if(var2.size() < 2){
                        val += ""+str;
                    }else{
                        val += ""+str+"|";
                    }
                }
            }
            //comp->setValor(valores);
        }
        
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
        if((*k)->getAtivo() == false) continue;
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
        if((*k)->getAtivo() == false ) continue;
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
                if((*k)->getAtivo() == false ) continue;
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
        
        Componente* dly4 = this->insereDelay(newLig4, amount+2, counter->getASAP() + dlyCtd);
        this->addComponent(dly4); 
        if(debug){
            cout<< "inserting " << amount << " delay(s) on signal "<< counter->getName()<< "->" << comp_done->getName() <<" (termination)" << endl;
        }
    }    
    
    for(k=this->ListaLiga.begin(); k != this->ListaLiga.end(); k++){
        if((*k)->getAtivo() == false ) continue;
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
        if((*k)->getAtivo() == false ) continue;
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
                if((*k)->getAtivo() == false ) continue;
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
                if((*k)->getAtivo() == false ) continue;
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
            if((*k)->getAtivo() == false ) continue;
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

