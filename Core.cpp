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
#include "Design.h"
#include "Algoritmos/Scheduling.h"
#include "Algoritmos/SCC.h"
#include "Componente/Componente.h"
#include "Componente/op_sub_s.h"
#include "Componente/and_op.h"
#include "Componente/or_op.h"
#include "Componente/op_div_s.h"
#include "Componente/neg_op_s.h"
#include "Componente/op_mult_s.h"
#include "Componente/op_add_s.h"
#include "Componente/op_simple.h"
#include "Componente/mux_m_op.h"
#include "Componente/counter.h"
#include "Componente/block_ram.h"
#include "Componente/block_ram_dual.h"
#include "Componente/comp_ref.h"
#include "Componente/reg_op.h"
#include "Componente/reg_mux_op.h"
#include "Componente/add_reg_op_s.h"
#include "Componente/sub_reg_op_s.h"
#include "Componente/delay_op.h"
#include "Componente/if_gt_op_s.h"
#include "Componente/if_lt_op_s.h"
#include "Componente/if_le_op_s.h"
#include "Componente/if_ge_op_s.h"
#include "Componente/if_ne_op_s.h"
#include "Componente/shr_c_op_s.h"
#include "Componente/shl_c_op_s.h"
#include "Componente/comp_aux.h"
#include "Componente/not_op.h"
#include "Aux/FuncoesAux.h"
#include "ArquivosDotHW.h"
#include <iostream>
#include <fstream>
#include "ProcessGraph.h"
#include "AlgoritHdw/analisaMem.h"
#include "AlgoritHdw/analisaLigaComponente.h"
#include "AlgoritHdw/analisaIf.h"
#include "AlgoritHdw/analisaCounter.h"

using namespace std;
using namespace boost;
using std::stringstream;
using std::string;

Core::Core(SgProject* project, list<SgNode*> lista) {
    this->debug = false;
    this->isParallel = false;
    this->gerarDual = false;
    this->ramMultPort = false;
    this->project = project;
    this->maxSchedulingTime = 0;
    this->ListaForParall = lista;
    this->dot = new ArquivosDotHW();
    this->graph = new ProcessGraph();
    this->compForAux = NULL;
    this->DATA_WIDTH = 32;
    
    //Identificar todos os pragmas no arquivo
    this->identificaPragmas();
    
    this->design = new Design(this->ListaLiga, this->ListaComp, this->DATA_WIDTH);
    
    this->identificaVariaveis();
    this->identificaFor();
    
    //Objeto para tratar mem'oria
    analisaMem* memHdr = new analisaMem(this->design);
    
    //Apos gerar todos os componentes
    //trocar os nomes dos comp duplicados
    if(this->isParallel){
        this->preIdentificacaoCompParalelizados();
    }
    
    this->FinalizaComponentes();
    if (this->ramMultPort == false){
        memHdr->insereMux();
        this->design = memHdr->getDesign();
    }
    this->design->finalizaComponentesIF();
    this->ligaCompDep();
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/6_LIGA_COMP_DEP.dot", false);
    this->aplicarDelayPragma();
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/7_APLICA_DLY_PRAGMA.dot", false);

    if (this->ramMultPort == false){
        memHdr->insereStepMux();
        this->design = memHdr->getDesign();
    }else{
        memHdr = new analisaMem(this->design);
        memHdr->insereRamMultPort();
        this->design = memHdr->getDesign();
    }
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/10_ANTES_SCHEDULE.dot", false);   
    //Processo de Scheduling
    Scheduling* sched = new Scheduling(this->design);
    sched->detectBackwardEdges();
    sched->ALAP();
    sched->balanceAndSyncrhonize();
    
    this->design = sched->getDesign();
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/11_DEPOIS_SCHEDULE.dot", false);  
    
    this->insereDelayLigBackEdge();
    
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/12_DEPOIS_SCHEDULE.dot", false); 
    
    //Rodar processo para identificar componente fortemente conectado.
//    this->rodarSCC();
    
//    this->corrigeRegWe();

//    this->retirarCompDelayRedundante();

//    if(this->isParallel && this->gerarDual){
//        this->analiseMemoriaDualPort();
//    }
    
    this->setClkReset();
    this->identificaReturn();
    this->corrigeRegSemValorInicial();
    this->geraArquivosDotHW();
//    this->design->graph->geraDot();
}

void Core::insereDelayLigBackEdge(){
    //TODO aqui vai o esquema de colocar os DELAYS autmaticos para substituir os pragmas
    //e' definido no SCHEDULING.CPP na LINHA: 300
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if( (*i)->getSchedSync() == true ){
            if((*i)->getPortOther("we")->temLigacao() ){
                Ligacao* ligAux = (*i)->getPortOther("we")->getLigacao2();
                if(ligAux->getOrigem()->tipo_comp == CompType::DLY){
                    delay_op* dly = (delay_op*)(ligAux->getOrigem());
                    string dlyValOld = dly->getDelayVal();
                    int oldVal = FuncoesAux::StrToInt(dlyValOld);
                    int comPal = FuncoesAux::StrToInt((*i)->getDelaySchedComp());
                    int newVal = oldVal + comPal; // VERIFICA AQUI se realmente SOME ou se pega apenas o valor em getDelaySchedComp()
                    dly->setDelayVal(FuncoesAux::IntToStr(newVal));
                }else{
                    int val = FuncoesAux::StrToInt((*i)->getDelaySchedComp());
                    Componente* newDly = this->design->insereDelay(ligAux,val, 0);
                    this->design->addComponent(newDly);
                }
            }else{
                Componente* ctdAux = NULL;
                ctdAux = (*i)->getForComp();
                Ligacao* newLig = this->design->insereLigacao(ctdAux, (*i), "step", "we");

                int val = FuncoesAux::StrToInt((*i)->getDelaySchedComp());
                Componente* newDly = this->design->insereDelay(newLig,val, 0);
 
                this->design->addComponent(newDly);
            }
        }
    }
}

void Core::rodarSCC(){
    cout<<"#--Algoritmo SCC:                             #"<<endl;
    SCC* scc = new SCC();
    list<Ligacao*>::iterator k;
    for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
        if ( (*k)->getAtivo() == false ) continue;
        scc->addEdge((*k)->getOrigem()->getName(), (*k)->getDestino()->getName(), (*k)->getNome());
    }
    int valSCC = 0;
    valSCC = scc->getSCC();
    scc->geraDot();
    cout<< " Valor SCC: '"<< valSCC<<"'" << endl;
    cout<<"#--Algoritmo SCC: OK                          #"<<endl;
}


void Core::aplicarDelayPragma(){

    cout<<"#--Aplicar pragmas Delay/step:                #"<<endl;

    list<Componente*>::iterator i;
    VariantVector vv (V_SgPragma); 
    Rose_STL_Container<SgNode*> loops = NodeQuery::queryMemoryPool(vv); 
    // #pragma delay 8
    for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin(); iter!= loops.end(); iter++ ){
        SgPragma* pragma = isSgPragma((*iter));
        if (pragma != NULL){
            if (pragma->get_pragma().find("delay") == 0){
                
                int linha = pragma->get_file_info()->get_line();
                const vector<string> words = FuncoesAux::split(pragma->get_pragma(), " ");
                
                string newValDelay = string(words[1].c_str());
                
                for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                    if ((linha+1) != (*i)->getNumLinha() ) continue;
                    if ((*i)->getWE() == true){
                        //verificar se a porta WE ja tem uma conexao
                        if( (*i)->temPorta("we") == true ) {
                            (*i)->setUserSync(true);
                            if((*i)->getPortOther("we")->temLigacao()){
                                //pegar ligacao
                                Ligacao* oldLig = (*i)->getPortOther("we")->getLigacao2();
                                
                                oldLig->getOrigem()->removeLigacao(oldLig);
                                oldLig->getDestino()->removeLigacao(oldLig);
                                
                                //Criar componente AND
                                and_op* comp      = new and_op(NULL, 1);
                                comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                                comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
                                this->design->addComponent(comp);
                                
                                this->design->insereLigacao(oldLig->getOrigem(), comp, oldLig->getPortOrigem()->getName(), "I0");
                                this->design->deletaLigacao(oldLig->getNome());
                                
                                Ligacao* newLig = this->design->insereLigacao((*i)->getForComp(), comp, "step", "I1");
                                this->design->insereLigacao(comp, (*i), "O0", "we");
                                
                                Componente* compDLY = this->design->insereDelay(newLig,FuncoesAux::StrToInt(newValDelay));
                                this->design->addComponent(compDLY);
                            }else{
                                //Inserir DELAY diretamente na porta
                                Ligacao* newLig = this->design->insereLigacao((*i)->getForComp(), (*i), "step", "we");
                                Componente* compDLY = this->design->insereDelay(newLig,FuncoesAux::StrToInt(newValDelay));
                                this->design->addComponent(compDLY);
                            }
                        }
                        
                        cout<< "Comp: '" << (*i)->getName() << "' recebendo novo valor delay: '" << newValDelay << "' " << endl;
                        break;
                    }
                }
            }
            if (pragma->get_pragma().find("step") == 0){
                
                int linha = pragma->get_file_info()->get_line();
                const vector<string> words = FuncoesAux::split(pragma->get_pragma(), " ");
                
                string newValStep = string(words[1].c_str());
                
                for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                    if ((linha+1) != (*i)->getNumLinha() ) continue;
                    if ((*i)->tipo_comp == CompType::CTD){
                        counter* ctd = (counter*)(*i);
                        cout<< "Contador: '" << (*i)->getName() << "' recebendo novo valor step: '" << newValStep << "' " << endl;
                        ctd->setGenericMapSteps(newValStep);
                        break;
                    }
                }
            }
        }
    }
    cout<<"#--Aplicar pragmas Delay/step: OK             #"<<endl;
}

void Core::corrigeRegSemValorInicial(){
    string valor = "";
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REF) continue;
        comp_ref* auxCom = (comp_ref*)(*i);
        if (auxCom->getTipoVar() != "VAR") continue;
        if ((*i)->getPortDataInOut("IN")->temLigacaoo) continue;
        if ((*i)->getPortDataInOut("IN")->temLigacaoo == false && (*i)->getPortDataInOut("OUT")->temLigacaoo == true){
           
            valor = (*i)->getGenericMapVal("initial","VAL") ;
         
            comp_aux* comp_input = new comp_aux(NULL, "VALOR", (*i)->dataWidth);
            comp_input->setName("num_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp_input->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp_input->setNumParalelLina((*i)->getNumParalelLina());
            comp_input->setNumLinha((*i)->getNumLinha());
            comp_input->setValAux(valor);
            this->design->addComponent(comp_input);
     
             //LIGACAO
            Ligacao* newLig3 = new Ligacao(comp_input, (*i), "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
            newLig3->setPortDestino((*i)->getPortDataInOut("IN"));
            newLig3->setPortOrigem(comp_input->getPortDataInOut("OUT"));
            newLig3->setWidth((*i)->getPortDataInOut("IN")->getWidth());
            newLig3->setTipo((*i)->getPortDataInOut("IN")->getType());

            //ADICIONAR NOME LIGACAO NA PORTA
            newLig3->getPortDestino()->addLigacao(newLig3);
            newLig3->getPortOrigem()->addLigacao(newLig3);

            //ADICIONAR LIGACAO NO COMPONENTE
            (*i)->addLigacao(newLig3);
            comp_input->addLigacao(newLig3);

            //ADD LISTAS
            this->design->ListaLiga.push_back(newLig3);
        }
    }
}

void Core::identificaPragmas(){
    cout<<"#--Ident Prgmas:                              #"<<endl;
    VariantVector vv (V_SgPragma); 
    Rose_STL_Container<SgNode*> loops = NodeQuery::queryMemoryPool(vv); 
 
    for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin(); iter!= loops.end(); iter++ )
    {
        SgPragma* pragma = isSgPragma((*iter));
        if (pragma != NULL){
            if (pragma->get_pragma().find("multport") == 0){
                this->ramMultPort = true;
            }
            if (pragma->get_pragma().find("bit") == 0){
                const vector<string> words = FuncoesAux::split(pragma->get_pragma(), " ");
                this->bitRegList.insert(string(words[1].c_str()));
            }
            if (pragma->get_pragma().find("DATA_WIDTH") == 0){
                const vector<string> words = FuncoesAux::split(pragma->get_pragma(), " ");
                string val = string(words[1].c_str());
                this->DATA_WIDTH = FuncoesAux::StrToInt(val);
            }
        }
    }
    cout<<"#--Ident Pragmas: OK                          #"<<endl;
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
            for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                if ((*i)->tipo_comp != CompType::REF) continue;
                if ((*i)->getNomeVarRef() == varRetorno){
                    comp_ref* CompRefI = (comp_ref*) (*i);
                    if(CompRefI->getTipoVar() == "VET"){
                    }
                    if(CompRefI->getTipoVar() == "VAR"){
                        Ligacao* s1Lig = CompRefI->getPortDataInOut("IN")->getLigacao2();
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
                for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                    if ((*i)->tipo_comp != CompType::REF) continue;
                    if ((*i)->getNomeVarRef() == varRetorno) {
 
                        CompRefLas= (comp_ref*)(*i);
                        if (CompRefI0 == NULL) {
                            CompRefI0 = (comp_ref*)(*i);
                            CompRefLas= (comp_ref*)(*i);

                            continue;
                        };
                        if (CompRefI1 == NULL) {
                            CompRefI1 = (comp_ref*)(*i);
                            CompRefLas= NULL;

                        }
                        if (CompRefI0 != NULL && CompRefI1 != NULL) {

                            op_add_s* addComp = new op_add_s();
                            addComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                            addComp->setNumLinha(numLinha+1);
                            //            this->design->ListaComp.push_back(comp);
                            this->design->addComponent(addComp);

                            addComp->setName(CompRefI0->getName() + "_" + addComp->getNomeCompVHDL() + "_" + CompRefI1->getName());

                            Ligacao* newLig = new Ligacao(CompRefI0, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                            newLig->setPortDestino(addComp->getPortOther("I0"));
                            newLig->setPortOrigem(CompRefI0->getPortDataInOut("OUT"));
                            newLig->setWidth(CompRefI0->getPortDataInOut("OUT")->getWidth());
                            newLig->setTipo(CompRefI0->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
//                            newLig->getPortDestino()->setLigacao(newLig->getNome());
                            newLig->getPortDestino()->addLigacao(newLig);
//                            newLig->getPortOrigem()->setLigacao(newLig->getNome());
                            newLig->getPortOrigem()->addLigacao(newLig);

                            //ADICIONAR LIGACAO NO COMPONENTE
                            CompRefI0->addLigacao(newLig);
                            addComp->addLigacao(newLig);

                            //ADD LISTAS
                            this->design->ListaLiga.push_back(newLig);


                            Ligacao* newLig2 = new Ligacao(CompRefI1, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                            newLig2->setPortDestino(addComp->getPortOther("I1"));
                            newLig2->setPortOrigem(CompRefI1->getPortDataInOut("OUT"));
                            newLig2->setWidth(CompRefI1->getPortDataInOut("OUT")->getWidth());
                            newLig2->setTipo(CompRefI1->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
//                            newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                            newLig2->getPortDestino()->addLigacao(newLig2);
//                            newLig2->getPortOrigem()->setLigacao(newLig2->getNome());
                            newLig2->getPortOrigem()->addLigacao(newLig2);

                            //ADICIONAR LIGACAO NO COMPONENTE
                            CompRefI1->addLigacao(newLig2);
                            addComp->addLigacao(newLig2);

                            //ADD LISTAS
                            this->design->ListaLiga.push_back(newLig2);

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
                for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                    if ((*i)->tipo_comp != CompType::OPE) continue;
                    if ((*i)->getPortDataInOut("OUT")->temLigacao() == false) {
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
                            addComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                            addComp->setNumLinha(addOpI0->getNumLinha() + 1);
                            //            this->design->ListaComp.push_back(comp);
                            this->design->addComponent(addComp);

                            addComp->setName(addOpI0->getName() + "_" + addComp->getNomeCompVHDL() + "_" + addOpI1->getName());

                            Ligacao* newLig = new Ligacao(addOpI0, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                            newLig->setPortDestino(addComp->getPortOther("I0"));
                            newLig->setPortOrigem(addOpI0->getPortDataInOut("OUT"));
                            newLig->setWidth(addOpI0->getPortDataInOut("OUT")->getWidth());
                            newLig->setTipo(addOpI0->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
//                            newLig->getPortDestino()->setLigacao(newLig->getNome());
                            newLig->getPortDestino()->addLigacao(newLig);
//                            newLig->getPortOrigem()->setLigacao(newLig->getNome());
                            newLig->getPortOrigem()->addLigacao(newLig);

                            //ADICIONAR LIGACAO NO COMPONENTE
                            addOpI0->addLigacao(newLig);
                            addComp->addLigacao(newLig);

                            //ADD LISTAS
                            this->design->ListaLiga.push_back(newLig);


                            Ligacao* newLig2 = new Ligacao(addOpI1, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                            newLig2->setPortDestino(addComp->getPortOther("I1"));
                            newLig2->setPortOrigem(addOpI1->getPortDataInOut("OUT"));
                            newLig2->setWidth(addOpI1->getPortDataInOut("OUT")->getWidth());
                            newLig2->setTipo(addOpI1->getPortDataInOut("OUT")->getType());

                            //ADICIONAR NOME LIGACAO NA PORTA
//                            newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                            newLig2->getPortDestino()->addLigacao(newLig2);
//                            newLig2->getPortOrigem()->setLigacao(newLig2->getNome());
                            newLig2->getPortOrigem()->addLigacao(newLig2);

                            //ADICIONAR LIGACAO NO COMPONENTE
                            addOpI1->addLigacao(newLig2);
                            addComp->addLigacao(newLig2);

                            //ADD LISTAS
                            this->design->ListaLiga.push_back(newLig2);

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
                    addComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    addComp->setNumLinha(addOpLas->getNumLinha()+1); 
        //            this->design->ListaComp.push_back(comp);
                    this->design->addComponent(addComp);

                    addComp->setName(addOpLas->getName()+"_"+addComp->getNomeCompVHDL()+"_"+CompRefLas->getName());

                    Ligacao* newLig = new Ligacao(addOpLas, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                    newLig->setPortDestino(addComp->getPortOther("I0"));
                    newLig->setPortOrigem(addOpLas->getPortDataInOut("OUT"));
                    newLig->setWidth(addOpLas->getPortDataInOut("OUT")->getWidth());
                    newLig->setTipo(addOpLas->getPortDataInOut("OUT")->getType());

                    //ADICIONAR NOME LIGACAO NA PORTA
//                    newLig->getPortDestino()->setLigacao(newLig->getNome());
                    newLig->getPortDestino()->addLigacao(newLig);
//                    newLig->getPortOrigem()->setLigacao(newLig->getNome());
                    newLig->getPortOrigem()->addLigacao(newLig);

                    //ADICIONAR LIGACAO NO COMPONENTE
                    addOpLas->addLigacao(newLig);
                    addComp->addLigacao(newLig);

                    //ADD LISTAS
                    this->design->ListaLiga.push_back(newLig);


                    Ligacao* newLig2 = new Ligacao(CompRefLas, addComp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                    newLig2->setPortDestino(addComp->getPortOther("I1"));
                    newLig2->setPortOrigem(CompRefLas->getPortDataInOut("OUT"));
                    newLig2->setWidth(CompRefLas->getPortDataInOut("OUT")->getWidth());
                    newLig2->setTipo(CompRefLas->getPortDataInOut("OUT")->getType());

                    //ADICIONAR NOME LIGACAO NA PORTA
//                    newLig2->getPortDestino()->setLigacao(newLig2->getNome());
                    newLig2->getPortDestino()->addLigacao(newLig2);
//                    newLig2->getPortOrigem()->setLigacao(newLig2->getNome());
                    newLig2->getPortOrigem()->addLigacao(newLig2);

                    //ADICIONAR LIGACAO NO COMPONENTE
                    CompRefLas->addLigacao(newLig2);
                    addComp->addLigacao(newLig2);

                    //ADD LISTAS
                    this->design->ListaLiga.push_back(newLig2);
                    addOpLas = NULL;
                    CompRefLas = NULL;
                }else{
                    CompResult = addOpLas;
                }
                cout<< "- Ligar o ultimo ADD ao ultimo REF OK"<< endl;
                
                
                cout<< "- Criar e ligar RESULT "<< endl;
                comp_aux* comp_return = new comp_aux(NULL,"RESULT");
                comp_return->setName("result");
                comp_return->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                comp_return->setNumLinha(1000);

                //LIGACAO
                Ligacao* newLig3 = new Ligacao(CompResult, comp_return, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                newLig3->setPortDestino(comp_return->getPortDataInOut("IN"));
                newLig3->setPortOrigem(CompResult->getPortDataInOut("OUT"));
                newLig3->setWidth(CompResult->getPortDataInOut("OUT")->getWidth());
                newLig3->setTipo(CompResult->getPortDataInOut("OUT")->getType());

                //ADICIONAR NOME LIGACAO NA PORTA
                newLig3->getPortDestino()->setLigacao(newLig3->getNome());
//                newLig3->getPortDestino()->addLigacao(newLig3);
                newLig3->getPortOrigem()->setLigacao(newLig3->getNome());
//                newLig3->getPortOrigem()->addLigacao(newLig3);

                //ADICIONAR LIGACAO NO COMPONENTE
                CompResult->addLigacao(newLig3);
                comp_return->addLigacao(newLig3);

                //ADD LISTAS
                this->design->ListaLiga.push_back(newLig3);
                this->design->addComponent(comp_return);
                cout<< "- Criar e ligar RESULT OK"<< endl;
            }
        }else{
            Componente* aux = NULL;
            for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
                if ((*i)->tipo_comp != CompType::REF) continue;
                if ((*i)->getNomeVarRef() == varRetorno){
                    aux = (*i);
                }
            }
            if(aux != NULL){
                comp_aux* comp_return = new comp_aux(NULL,"RESULT");
                comp_return->setName("result");
                comp_return->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                comp_return->setNumLinha(numLinha);

                //LIGACAO
                Ligacao* newLig = new Ligacao(aux, comp_return, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
                newLig->setPortDestino(comp_return->getPortDataInOut("IN"));
                newLig->setPortOrigem(aux->getPortDataInOut("OUT"));
                newLig->setWidth(aux->getPortDataInOut("OUT")->getWidth());
                newLig->setTipo(aux->getPortDataInOut("OUT")->getType());

                //ADICIONAR NOME LIGACAO NA PORTA
                newLig->getPortDestino()->setLigacao(newLig->getNome());
//                newLig->getPortDestino()->addLigacao(newLig);
                newLig->getPortOrigem()->setLigacao(newLig->getNome());
//                newLig->getPortOrigem()->addLigacao(newLig);

                //ADICIONAR LIGACAO NO COMPONENTE
                aux->addLigacao(newLig);
                comp_return->addLigacao(newLig);

                //ADD LISTAS
                this->design->ListaLiga.push_back(newLig);
    //                this->design->ListaComp.push_back(comp_return);
                this->design->addComponent(comp_return);
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
                int auxDataWidth = this->DATA_WIDTH;
                
                if(this->bitRegList.find(cur_var->get_name().getString()) != this->bitRegList.end()){
                    auxDataWidth = 1;
                }
         
                if (cur_var != NULL){
                    ROSE_ASSERT(cur_var);
                    varID var(isSgInitializedName(cur_var));
                    if(var.isArrayType()){
                        block_ram* mem = new block_ram(this->GetStrPointerAdd(cur_var), auxDataWidth);
                        mem->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                        this->design->addComponent(mem);
                        this->updateBlockRam(cur_var, mem);
                        mem->setNumLinha(cur_var->get_file_info()->get_line());   
                        if(this->debug){
                            cout<<" - Array: "<<mem->getName()<<endl;
                        }
                        this->design->setTemMemoria(true);
                    }else{
                        reg_op* reg = new reg_op(this->GetStrPointerAdd(cur_var), "", auxDataWidth);
                        reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                        this->design->addComponent(reg);
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
            

            if (this->ListaForParall.size() > 0){
                hadForParallel = true;
                this->isParallel = true;
            }
            
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                SgForStatement* cur_for = isSgForStatement(*i);
                
                if (cur_for != NULL){
                    ROSE_ASSERT(cur_for);
                    
                    counter* comp = new counter(this->GetStrPointerAdd(cur_for), this->DATA_WIDTH);
                    this->compForAux = comp;
                    comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
//                    this->design->ListaComp.push_back(comp);                    
                    this->design->addComponent(comp);                    
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
//                                            int aux = 0;
                                            cout<<"linha paralelizada: "<< id <<endl;
                                            for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                                            {
                                                SgNode* expStmt = isSgNode(*ilb);
                                                if(expStmt != NULL && expStmt->get_parent() == basicBlocP && !isSgBasicBlock((*ilb))){
                                                    analisaExp(expStmt, NULL, "", FuncoesAux::IntToStr(id), comp);
                                                }
                                            }                                      
                                            cout<<"#linha paralelizada: "<< id << " - OK" <<endl;
                                            id++;
                                        }

                                        if ( basic->get_parent() == basicBlocP && (basicBlocP != NULL)  ) {
                                            Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(basic,V_SgNode); 
                                            if (varLoopBody.size()==0) continue;
                                            
                                            cout<<"linha paralelizada: "<< id <<endl;
                                            for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                                            {

                                                SgNode* expStmt = isSgNode(*ilb);
                                                if(expStmt != NULL && expStmt->get_parent() == basic && !isSgBasicBlock((*ilb))){
                                                    analisaExp(expStmt, NULL, "", FuncoesAux::IntToStr(id), comp);
                                                }
                                            }
                                            cout<<"#linha paralelizada: "<< id << " - OK" <<endl;
                                            id++;
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        cout<<"#--Comp Counter: OK                           #"<<endl;
                        cout<<"# Iniciando processo expressao FOR            #"<<endl;

                        //Corpo do Loop com as operacoes
                        SgStatement* loopBody   = cur_for->get_loop_body();                    
                        SgNode* sg_basic        = NULL;
                        Rose_STL_Container<SgNode*> varLoopBody = NodeQuery::querySubTree(loopBody,V_SgNode); 
                        if (varLoopBody.size()==0) continue;
                        cout<<"buscando expressões internas no for"<<endl;
                        for (Rose_STL_Container<SgNode*>::iterator ilb = varLoopBody.begin(); ilb != varLoopBody.end(); ilb++ ) 
                        {

                            if(isSgBasicBlock(*ilb) && (*ilb)->get_parent() == cur_for){
                                sg_basic = isSgNode(*ilb);
                            }
                            SgNode* expStmt = isSgNode(*ilb);
                            if(expStmt != NULL && sg_basic != NULL && expStmt->get_parent() == sg_basic){
                                
                                analisaExp(expStmt, NULL, "", "0", comp);
                         }
                        }
                        cout<<"# Iniciando processo expressao FOR: OK        #"<<endl;
                    }
                }
                this->compForAux = NULL;
            }
        }
    }    
}

int Core::getDataWidthByName(const string& name){
    list<Componente*>::iterator i;
    int res = this->DATA_WIDTH;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REG) continue;
        if ((*i)->getName() == name){
            res = (*i)->dataWidth;
            break;
        }
    }
    return res;
}

void Core::trataIfTernario(Componente* comp, SgNode* condicao){

    Componente* compIf    = NULL;
    Componente* comTrue   = NULL;
    Componente* comFalse  = NULL;

    SgNode* CondNode      = NULL;
    SgNode* BodyTrue      = NULL;
    SgNode* BodyFalse     = NULL;

    
    SgConditionalExp* IFNode = isSgConditionalExp(condicao);
    
    CondNode = IFNode->get_conditional_exp();
    if(CondNode != NULL) compIf = analisaExp(CondNode, NULL, "", comp->getNumParalelLina(), comp->getForComp());

    if(compIf != NULL){
        BodyTrue = IFNode->get_true_exp();
        BodyFalse= IFNode->get_false_exp();
        if(BodyTrue  != NULL) comTrue =  analisaExp(BodyTrue , NULL, "", comp->getNumParalelLina(), comp->getForComp());
        if(BodyFalse != NULL) comFalse =  analisaExp(BodyFalse, NULL, "", comp->getNumParalelLina(), comp->getForComp());
    }    

    comp_ref* ref = new comp_ref(NULL, "WE", comp->dataWidth);
    string name = this->design->getNomeCompRef(comp->getNomeVarRef());
    ref->setName(name);
    ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));

    ref->setNumParalelLina(comp->getNumParalelLina()); 
    
    ref->setNumLinha(comp->getNumLinha());

    ref->setTipoVar("VAR");
    ref->setNomeVarRef(comp->getNomeVarRef());

    reg_mux_op* reg = new reg_mux_op(NULL, "WE", comp->dataWidth);
    reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    reg->setName(ref->getName());
    this->design->addComponent(reg);

    ref->setComponenteRef(reg);
    ref->updateCompRef();

    ref->setDelayValComp(comp->getDelayValComp());

    
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i) == comp) {
            (*i) = ref;
            break;
        }
    }
    if(comTrue  != NULL) this->design->insereLigacao(comTrue , ref, comTrue->getPortDataInOut("OUT")->getName()  , "I1"  );
    if(comFalse != NULL) this->design->insereLigacao(comFalse, ref, comFalse->getPortDataInOut("OUT")->getName() , "I0"  );
    if(compIf   != NULL) this->design->insereLigacao(compIf  , ref, compIf->getPortDataInOut("OUT")->getName()   , "Sel1");    
}

Componente* Core::analisaExp(SgNode *nodoAtual, SgNode* pai, const string& aux, const string& lineParal, Componente* compFor) {
    Componente* compReturn = NULL;
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
        compReturn = analisaExp(proxNodo, pai, aux, lineParal, compFor);
    }
    
    SgBasicBlock* sgBasic =  isSgBasicBlock(nodoAtual);
    if (sgExpEst != NULL) {
        SgNode* proxNodo = isSgNode(sgBasic);
        analisaExp(proxNodo, pai, aux, lineParal, compFor);
    }
    
    // <editor-fold defaultstate="collapsed" desc="NOT VAR">
    //SgNotEqualOp* expNotE = isSgNotEqualOp(nodoAtual);
    SgNotOp* expNotE = isSgNotOp(nodoAtual);
    if (expNotE != NULL) {
        SgNode* filhoAbaixo     = isSgNode(expNotE->get_operand_i());
        
        SgNotEqualOp* expNotE2  = isSgNotEqualOp(filhoAbaixo);
        
        SgNode* filhoEsq        = isSgNode(expNotE2->get_lhs_operand_i());
        
        if (filhoEsq != NULL ) {
            int dataWidht = this->DATA_WIDTH;
     
            //Se o filho ESQ for uma variavel tem que pegar o DATA_WIDTH para calcular corretamenta
            SgVarRefExp* decVarAux = isSgVarRefExp(filhoEsq);
            if (decVarAux != NULL) {

                string varNome = "";
                varNome = decVarAux->get_symbol()->get_name().getString();

                dataWidht = getDataWidthByName(varNome);
            }

            
            not_op* comp = new not_op(this->GetStrPointerAdd(expNotE), dataWidht);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;

            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
        }
    }
    // </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="MENOS VAR">
    SgMinusOp* expMin = isSgMinusOp(nodoAtual);
    if (expMin != NULL) {
        SgExpression* expres = expMin->get_operand_i();

        SgIntVal* valInt = isSgIntVal(expres);
        if (valInt != NULL) {
            comp_aux* comp_input = new comp_aux(this->GetStrPointerAdd(valInt), "VALOR", this->DATA_WIDTH);
            comp_input->setName("num_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp_input->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp_input->setNumParalelLina(lineParal);
            comp_input->setForComp(compFor);
            string str = FuncoesAux::IntToStr(valInt->get_value()*(-1));
            comp_input->setNumLinha(valInt->get_file_info()->get_line());
            comp_input->setValAux(str);
            if(pai != NULL) comp_input->setPai(this->GetStrPointerAdd(pai));
            this->design->addComponent(comp_input);
            
            compReturn = comp_input;
         
        }else{
            neg_op_s* comp = new neg_op_s(this->GetStrPointerAdd(expMin), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;

            analisaExp(expres, nodoAtual, aux, lineParal, compFor);
        }
    }
    // </editor-fold>

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
            Componente* compEsqWE = NULL;
            compEsqWE = analisaExp(filhoEsq, nodoAtual,"WE", lineParal, compFor);
            
            SgConditionalExp* condDirExp = NULL;
            condDirExp = isSgConditionalExp(filhoDir);
            if(condDirExp != NULL){
                this->trataIfTernario(compEsqWE, condDirExp);
            }else{
                analisaExp(filhoDir, filhoEsq, aux, lineParal, compFor);
            }
        }
    }// </editor-fold>
    
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
            
            Componente* comp = analisaExp(filhoEsq, nodoAtual, "WE", lineParal, compFor);
            analisaExp(filhoDir, filhoEsq, aux, lineParal, compFor);
            add_reg_op_s* add_reg = new add_reg_op_s(comp->node, "WE", comp->dataWidth);

            add_reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));

            this->design->ListaComp.push_back(add_reg);
            add_reg->setName(comp->getName());
            add_reg->setValor(comp->getGenericMapVal("initial", "VAL"));

            add_reg->setNumLinha(comp->getNumLinha());
            add_reg->setForComp(compFor);
            add_reg->setNumParalelLina(lineParal);

            comp->setComponenteRef(add_reg);
            comp->updateCompRef();
        }
    }
    // </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="MENOS ATRIBUICAO">
    SgMinusAssignOp* sgMinusAssignOp = isSgMinusAssignOp(nodoAtual);
    
    if (sgMinusAssignOp != NULL) {
        SgNode* filhoEsq = isSgNode(sgMinusAssignOp->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(sgMinusAssignOp->get_rhs_operand_i());

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
            
            Componente* comp = analisaExp(filhoEsq, nodoAtual, "WE", lineParal, compFor);
            analisaExp(filhoDir, filhoEsq, aux, lineParal, compFor);
            sub_reg_op_s* sub_reg = new sub_reg_op_s(comp->node, "WE", comp->dataWidth);

            sub_reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));

            this->design->ListaComp.push_back(sub_reg);
            sub_reg->setName(comp->getName());
            sub_reg->setValor(comp->getGenericMapVal("initial", "VAL"));

            sub_reg->setNumLinha(comp->getNumLinha());
            sub_reg->setForComp(compFor);
            sub_reg->setNumParalelLina(lineParal);

            comp->setComponenteRef(sub_reg);
            comp->updateCompRef();
        }
    }
    // </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="NODO CAST - IGNORADO">
    SgCastExp* castExp = isSgCastExp(nodoAtual);
    if (castExp != NULL) {
        SgNode* proxNodo = isSgNode(castExp->get_operand_i());
        analisaExp(proxNodo, pai, aux, lineParal, compFor);
    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="OP RIGHT SHIF">
    SgRshiftOp* rightShift = isSgRshiftOp(nodoAtual);
    if (rightShift != NULL) {
        SgNode* filhoEsq = isSgNode(rightShift->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(rightShift->get_rhs_operand_i());
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
            string valAmount = "1";
            //Componente Shift precisa do valor interno ao componente
            SgIntVal* valInt = isSgIntVal(filhoDir);
            if(valInt != NULL){
                valAmount = FuncoesAux::IntToStr(valInt->get_value());
            }
            
            shr_c_op_s* comp      = new shr_c_op_s(this->GetStrPointerAdd(rightShift),valAmount, this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
//            this->design->ListaComp.push_back(comp);
            
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="OP LEFT SHIF">
    SgLshiftOp* leftShift = isSgLshiftOp(nodoAtual);
    if (leftShift != NULL) {
        SgNode* filhoEsq = isSgNode(leftShift->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(leftShift->get_rhs_operand_i());
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
            string valAmount = "1";
            //Componente Shift precisa do valor interno ao componente
            SgIntVal* valInt = isSgIntVal(filhoDir);
            if(valInt != NULL){
                valAmount = FuncoesAux::IntToStr(valInt->get_value());
            }
            
            shl_c_op_s* comp      = new shl_c_op_s(this->GetStrPointerAdd(leftShift),valAmount, this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>
    
    // <editor-fold defaultstate="collapsed" desc="OP BIT OR">
    SgBitOrOp* bitOr = isSgBitOrOp(nodoAtual);
    if (bitOr != NULL) {
        SgNode* filhoEsq = isSgNode(bitOr->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(bitOr->get_rhs_operand_i());
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
            or_op* comp      = new or_op(this->GetStrPointerAdd(bitOr), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>
         
    // <editor-fold defaultstate="collapsed" desc="OP BIT AND">
    SgBitAndOp* bitAnd = isSgBitAndOp(nodoAtual);
    if (bitAnd != NULL) {
        SgNode* filhoEsq = isSgNode(bitAnd->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(bitAnd->get_rhs_operand_i());
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
            and_op* comp      = new and_op(this->GetStrPointerAdd(bitAnd), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
//            this->design->ListaComp.push_back(comp);
            comp->setForComp(compFor);
            comp->setNumParalelLina(lineParal);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>
    
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
            op_add_s* comp    = new op_add_s(this->GetStrPointerAdd(expAdd), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
//            this->design->ListaComp.push_back(comp);
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>

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
            op_sub_s* comp = new op_sub_s(this->GetStrPointerAdd(expSub), this->DATA_WIDTH);
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }// </editor-fold>
    
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

            op_div_s* comp = new op_div_s(this->GetStrPointerAdd(expDiv), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }
    // </editor-fold>

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

            op_mult_s* comp = new op_mult_s(this->GetStrPointerAdd(expMul), this->DATA_WIDTH);
            if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
            comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp->setNumLinha(nodoAtual->get_file_info()->get_line()); 
            comp->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
//            this->design->ListaComp.push_back(comp);
            comp->setNumParalelLina(lineParal);
            comp->setForComp(compFor);
            this->design->addComponent(comp);
            compReturn = comp;
            analisaExp(filhoEsq, nodoAtual, aux, lineParal, compFor);
            analisaExp(filhoDir, nodoAtual, aux, lineParal, compFor);
        }
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="IF DEFINICAO">    
    SgGreaterThanOp* greaterThan        =  isSgGreaterThanOp(nodoAtual);
    SgGreaterOrEqualOp* greaterOrEqual  =  isSgGreaterOrEqualOp(nodoAtual);
    SgLessThanOp* lessThan              =  isSgLessThanOp(nodoAtual);
    SgLessOrEqualOp* lessThanOrEqual    =  isSgLessOrEqualOp(nodoAtual);
    SgNotEqualOp* notEqualOp            =  isSgNotEqualOp(nodoAtual);
    
    if(lessThan != NULL  || greaterThan != NULL  || greaterOrEqual != NULL  || lessThanOrEqual != NULL || notEqualOp != NULL) {
        
        Componente* comp        = NULL;
        Componente* compCondEsq = NULL;
        Componente* compCondDir = NULL;
        int dataWidhtEsq= this->DATA_WIDTH;       
        int dataWidhtDir= this->DATA_WIDTH;
        int dataWidht   = this->DATA_WIDTH;
        SgNode* cndEsq =  NULL;
        SgNode* cndDir =  NULL;
        
        
        //-----------------------------------------------------
        //Pegando condicionais para calcular o valor correto do data width
        if(lessThan != NULL){
            cndEsq = isSgNode(lessThan->get_lhs_operand_i());
            cndDir = isSgNode(lessThan->get_rhs_operand_i());
        }
        if(greaterThan != NULL){ 
            cndEsq = isSgNode(greaterThan->get_lhs_operand_i());
            cndDir = isSgNode(greaterThan->get_rhs_operand_i());
        }
        if(greaterOrEqual != NULL){ 
            cndEsq = isSgNode(greaterOrEqual->get_lhs_operand_i());
            cndDir = isSgNode(greaterOrEqual->get_rhs_operand_i());
        }
        if(lessThanOrEqual != NULL){ 
            cndEsq = isSgNode(lessThanOrEqual->get_lhs_operand_i());
            cndDir = isSgNode(lessThanOrEqual->get_rhs_operand_i());
        }
        if(notEqualOp != NULL){ 
            cndEsq = isSgNode(notEqualOp->get_lhs_operand_i());
            cndDir = isSgNode(notEqualOp->get_rhs_operand_i());
        }
        
        //---------------------------------------------
        //Se o filho ESQ for uma variavel tem que pegar o DATA_WIDTH para calcular corretamenta
        SgVarRefExp* decVarEsq = isSgVarRefExp(cndEsq);
        SgVarRefExp* decVarDir = isSgVarRefExp(cndDir);
        if (decVarEsq != NULL) {
            string varNome = "";
            varNome = decVarEsq->get_symbol()->get_name().getString();
            dataWidhtEsq = getDataWidthByName(varNome);
        }
        if (decVarDir != NULL) {
            string varNome = "";
            varNome = decVarDir->get_symbol()->get_name().getString();
            dataWidhtDir = getDataWidthByName(varNome);
        }
        if(dataWidhtEsq < dataWidht) dataWidht = dataWidhtEsq;
        if(dataWidhtDir < dataWidht) dataWidht = dataWidhtDir;
        
        // <editor-fold defaultstate="collapsed" desc="MENOR QUE">
                if (lessThan != NULL) {

                    if_lt_op_s* ifComp = new if_lt_op_s(this->GetStrPointerAdd(nodoAtual), dataWidht);
                    ifComp->setName("if_lt_op_s_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    comp = ifComp;
                }// </editor-fold>

        // <editor-fold defaultstate="collapsed" desc="MAIOR QUE">
        if (greaterThan != NULL) {
            if_gt_op_s* ifComp = new if_gt_op_s(this->GetStrPointerAdd(nodoAtual), dataWidht);
            ifComp->setName("if_gt_op_s_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp = ifComp;
        } // </editor-fold>

        // <editor-fold defaultstate="collapsed" desc="MAIOR IGUAL QUE">
        if (greaterOrEqual != NULL) {
            if_ge_op_s* ifComp = new if_ge_op_s(this->GetStrPointerAdd(nodoAtual), dataWidht);
            ifComp->setName("if_ge_op_s_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp = ifComp;
        }// </editor-fold>

        // <editor-fold defaultstate="collapsed" desc="MENOR IGUAL QUE">
        if (lessThanOrEqual != NULL) {
            if_le_op_s* ifComp = new if_le_op_s(this->GetStrPointerAdd(nodoAtual), dataWidht);
            ifComp->setName("if_le_op_s_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp = ifComp;
        }// </editor-fold>

        // <editor-fold defaultstate="collapsed" desc="DIFERENTE">
        if (notEqualOp != NULL) {
            if_ne_op_s* ifComp = new if_ne_op_s(this->GetStrPointerAdd(nodoAtual), dataWidht);
            ifComp->setName("if_ne_op_s_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
            comp = ifComp;
        }// </editor-fold>

        comp->setNumLinha(nodoAtual->get_file_info()->get_line());
        comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        
        if(cndEsq != NULL) compCondEsq = analisaExp(cndEsq, NULL, "" , lineParal, compFor);
        if(cndDir != NULL) compCondDir = analisaExp(cndDir, NULL, "" , lineParal, compFor);

        comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));

        comp->setNumParalelLina(lineParal);
        comp->setForComp(compFor);
        this->design->addComponent(comp);

        if (compCondEsq != NULL)this->design->insereLigacao(compCondEsq, comp, compCondEsq->getPortDataInOut("OUT")->getName(), comp->getPortOther("I0")->getName());                        
        if (compCondDir != NULL)this->design->insereLigacao(compCondDir, comp, compCondDir->getPortDataInOut("OUT")->getName(), comp->getPortOther("I1")->getName());                        

        compReturn = comp;
    }// </editor-fold>

    //<editor-fold defaultstate="collapsed" desc="IF">
    SgIfStmt* ifStm = isSgIfStmt(nodoAtual);
    if(ifStm != NULL){
        SgStatement* cond  =  ifStm->get_conditional();
        SgStatement* tBody =  ifStm->get_true_body();
        SgStatement* fBody =  ifStm->get_false_body();
        int lastId = 0;
        
        lastId = this->design->ListaComp.size();
        
        compReturn = analisaExp(cond, NULL, "", lineParal, compFor);
        
        if(compReturn->tipo_comp != CompType::CND) compReturn->tipo_comp = CompType::CND;
        
        if(tBody != NULL){
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(tBody,V_SgNode);             
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                if(isSgExprStatement((*i))){
                    analisaExp((*i), NULL, "", lineParal, compFor);                    
                }
            }
            list<Componente*>::iterator com;

            for (com = this->design->ListaComp.begin(); com != this->design->ListaComp.end(); com++) {
                int idI =  FuncoesAux::StrToInt((*com)->getNumIdComp());
                if ( idI > lastId){
                    (*com)->setIf(true);
                    (*com)->setIfBody(true);
                    (*com)->setIfComp(compReturn);
                }
            }
            lastId = this->design->ListaComp.size();
        }

        if(fBody != NULL){
            Rose_STL_Container<SgNode*> var = NodeQuery::querySubTree(fBody,V_SgNode);             
            for (Rose_STL_Container<SgNode*>::iterator i = var.begin(); i != var.end(); i++ ) 
            {
                if(isSgExprStatement((*i))){
                    analisaExp((*i), NULL, "", lineParal, compFor);
                }
            }
            list<Componente*>::iterator com;
            for (com = this->design->ListaComp.begin(); com != this->design->ListaComp.end(); com++) {
                int idI =  FuncoesAux::StrToInt((*com)->getNumIdComp());
                if ( idI >= lastId){
                    
                    (*com)->setIf(true);
                    (*com)->setIfBody(false);
                    (*com)->setIfComp(compReturn);
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
        
        comp_ref* comp = new comp_ref(this->GetStrPointerAdd(decArr), aux);
        comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp->setNumLinha(decArr->get_file_info()->get_line());
        comp->setNumParalelLina(lineParal);
        comp->setForComp(compFor);
        if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
        this->design->addComponent(comp);
        compReturn = comp;
        this->updateCompRef(decArr, comp);
        
        //analisaExp(decArr->get_rhs_operand_i(), decArr, comp->getName(), lineParal);
        
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
        comp_ref* comp = new comp_ref(this->GetStrPointerAdd(decVar), aux);
        comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp->setNumLinha(decVar->get_file_info()->get_line());
        comp->setForComp(compFor);
        comp->setNumParalelLina(lineParal);
        if(pai != NULL) comp->setPai(this->GetStrPointerAdd(pai));
        this->design->addComponent(comp);
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
        comp_aux* comp_input = new comp_aux(this->GetStrPointerAdd(valInt), "VALOR", this->DATA_WIDTH);
        comp_input->setName("num_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp_input->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp_input->setNumParalelLina(lineParal);
        comp_input->setForComp(compFor);
        string str = FuncoesAux::IntToStr(valInt->get_value());
        comp_input->setNumLinha(valInt->get_file_info()->get_line());
        comp_input->setValAux(str);
        if(pai != NULL) comp_input->setPai(pai);
        this->design->addComponent(comp_input);
        compReturn = comp_input;
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (this->debug) {
            string res = "";
            cout << "-------------------------------" << endl;
            cout << "INT VALOR:    " << valInt->get_valueString() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold> 
    }// </editor-fold>
    
    
    //TODO Nao sei porque mas o compilador nao esta permitindo dar include na classe ProcessGraph na classe Desing
    //nesse caso no processo de addComponete nao pode setar os nodos para busca se e pai ou nao 
    if(compReturn != NULL && compReturn->getPai() != NULL){
        void* node = NULL;
        void* pai  = NULL;
        node = compReturn->node;
        pai = compReturn->getPai();
        if(node != NULL && pai != NULL) this->graph->addEdge(node, pai, "");
    }
    
    return compReturn;
}

void Core::preIdentificacaoCompParalelizados(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    cout<<"--Processo renomear variaveis paralelizadas iguais"<<endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REF) continue;
        if ((*i)->getEIndice() == true) continue;
        if (this->isIndiceVector((*i)->getNomeVarRef()) == true) continue;
        comp_ref* CompRefI = (comp_ref*) (*i);
        int numP = FuncoesAux::StrToInt(CompRefI->getNumParalelLina());
        if(numP > 1 ){

            if(CompRefI->getTipoVar() == "VET"){

                block_ram *ref = (block_ram*)(*i)->getComponenteRef();
                
                block_ram *newComp = new block_ram(*ref);
                
                newComp->setName((*i)->getName());
                (*i)->setComponenteRef(newComp);
                newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                this->design->addComponent(newComp);
                string name = "block_ram";
                if(CompRefI->getNomeCompVHDL() != "block_ram"){
                    name += "_"+(*i)->getName();
                }
                newComp->setNomeCompVHDL(name);
                (*i)->setNomeCompVHDL(name);
            }
            if(CompRefI->getTipoVar() == "VAR"){
                //REGISTRADOR NORMAL
                if(CompRefI->getNomeCompVHDL() == "reg_op"){
                    reg_op *ref2 = (reg_op*)(*i)->getComponenteRef();
                    reg_op *newComp = new reg_op(*ref2);

                    newComp->setName((*i)->getName());
                    (*i)->setComponenteRef(newComp);
                    newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    this->design->addComponent(newComp);
                }
                //ACUMULADOR
                if(CompRefI->getNomeCompVHDL() == "add_reg_op_s"){
                    add_reg_op_s *ref2 = (add_reg_op_s*)(*i)->getComponenteRef();
                    add_reg_op_s *newComp = new add_reg_op_s(*ref2);

                    newComp->setName((*i)->getName());
                    (*i)->setComponenteRef(newComp);
                    newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    this->design->addComponent(newComp);
                }
                
                //sub
                if(CompRefI->getNomeCompVHDL() == "sub_reg_op_s"){
                    sub_reg_op_s *ref2 = (sub_reg_op_s*)(*i)->getComponenteRef();
                    sub_reg_op_s *newComp = new sub_reg_op_s(*ref2);

                    newComp->setName((*i)->getName());
                    (*i)->setComponenteRef(newComp);
                    newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    this->design->addComponent(newComp);
                }
            }
        }
    }
    
    cout<<"--Processo renomear variaveis paralelizadas iguais OK"<<endl;
    
    //Apos a identificacao verificar a necessidade de duplicacao de mem'orias
}

bool Core::isIndiceVector(const string& name){
    bool res = false;
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::CTD){
            counter* CompCounter = (counter*)(*i); 
            if(CompCounter->getVarControlCont() == name){
                res = true;
            }
        }
    }
    return res; 
}

void Core::retirarCompDelayRedundante(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    this->ListaComp = this->design->getListaComp();
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::DLY) continue;
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::DLY) continue;
            if ((*i)->getName() == (*j)->getName()) continue;
            delay_op* CompRefI = (delay_op*) (*i);
            delay_op* CompRefJ = (delay_op*) (*j);
            if( CompRefI->getDelayVal() == CompRefJ->getDelayVal()){               
                Ligacao* dlyI  = (*i)->getPortDataInOut("IN")->getLigacao2();
                Ligacao* dlyJ  = (*j)->getPortDataInOut("IN")->getLigacao2();
                Ligacao* dlyJ2 = (*j)->getPortDataInOut("OUT")->getLigacao2();
                Ligacao* dlyI2 = (*i)->getPortDataInOut("OUT")->getLigacao2();
                if(dlyI->getOrigem() == dlyJ->getOrigem() && dlyI->getPortOrigem() == dlyJ->getPortOrigem() && 
                  (*i)->getPortDataInOut("OUT")->getWidth() == (*j)->getPortDataInOut("OUT")->getWidth() && 
                  (*i)->getPortDataInOut("IN")->getWidth() == (*j)->getPortDataInOut("IN")->getWidth() &&
                  (*i)->getPortDataInOut("OUT")->getType() == (*j)->getPortDataInOut("OUT")->getType() && 
                  (*i)->getPortDataInOut("IN")->getType() == (*j)->getPortDataInOut("IN")->getType() ){

                    dlyJ->getOrigem()->removeLigacao(dlyJ);
                    dlyJ2->getDestino()->removeLigacao(dlyJ2);
                    
//                    dlyI->getPortOrigem()->setLigacao((*i)->getPortDataInOut("IN")->getLigacao());
                    dlyI->getPortOrigem()->addLigacao((*i)->getPortDataInOut("IN")->getLigacao2());

                    //CRIAR NOVA LIGACAO
                    string str = FuncoesAux::IntToStr(this->design->ListaLiga.size());
                    Ligacao* lig = new Ligacao((*i), dlyJ2->getDestino(), "s" + str);
                    lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                    lig->setPortDestino(dlyJ2->getPortDestino());
                    lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                    lig->setTipo((*i)->getPortDataInOut("OUT")->getType());

                    //ADICIONAR LIGACAO NA PORTA                        
//                    lig->getPortDestino()->setLigacao(lig->getNome());
                    lig->getPortDestino()->addLigacao(lig);
//                    lig->getPortOrigem()->setLigacao(lig->getNome());
                    lig->getPortOrigem()->addLigacao(lig);

                    //ADICIONAR LIGACAO AOS COMPONENTES
                    (*i)->addLigacao(lig);
                    dlyJ2->getDestino()->addLigacao(lig);

                    //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                    this->design->ListaLiga.push_back(lig);
                                        
                    this->design->deletaLigacao(dlyJ->getNome());
                    this->design->deletaLigacao(dlyJ2->getNome());
                    
                    //Neste caso nao gera nem VHDL/DOT para o J (comp repetido)
                    (*j)->tipo_comp = CompType::REG; 
                }
            }
        }
    }
}

void Core::ligaRegNoWE(){
    //procedimento para efetuar um calculo correto no balanceamento
    cout<< "------------------------" <<endl;
    cout<< "COLOCANDO SINAL PORTA WE" <<endl;
    cout<< "------------------------" <<endl;
    list<Componente*>::iterator i;
    Componente* ctd = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CTD) continue;
        ctd = (*i);
        break;
    }
    cout<< "------------------------" <<endl;
    cout<< "Achou o contador: "<< ctd->getName() <<endl;
    cout<< "------------------------" <<endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
        if ((*i)->getComponenteRef()->getNomeCompVHDL() != "reg_op") continue;
        if ((*i)->writeEnable == true) continue;
        if ((*i)->getPortOther("we")->temLigacao() == false){
            cout<< " - inserindo ligacao: '" << ctd->getName() << "' -> '" << (*i)->getName() <<"'" << endl;
            this->design->insereLigacao(ctd,(*i), "step", "we");
        }
    }
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/6_colocandoSinalWE.dot", false);
}

void Core::corrigeRegWe(){
    list<Componente*>::iterator i;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
       if ((*i)->tipo_comp != CompType::REF) continue;
       if ((*i)->getEIndice()) continue;
       if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;
       if ((*i)->getComponenteRef()->getNomeCompVHDL() != "reg_op") continue;
       if ((*i)->writeEnable == true) continue;
       if ((*i)->getPortOther("we")->temLigacao() != false){
           Ligacao* lig = (*i)->getPortOther("we")->getLigacao2();
           Componente* comp = lig->getOrigem();

           comp->removeLigacao(lig);

           if (comp->tipo_comp == CompType::DLY){
               Ligacao* lig2 = comp->getPortDataInOut("IN")->getLigacao2();
               Componente* compCTD = lig->getOrigem();
               if (comp->tipo_comp == CompType::CTD){
                   compCTD->removeLigacao(lig2);
                   comp->removeLigacao(lig2);
                   this->design->deletaLigacao(lig2->getNome());
                   this->design->removeComponente(comp);
               }
           }
           (*i)->getPortOther("we")->lig = NULL;
           (*i)->getPortOther("we")->temLigacaoo = false;
           
           (*i)->removeLigacao(lig);
           this->design->deletaLigacao(lig->getNome());
       }
    }  
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/7_RemovendoSinalWE.dot", false);
}

void Core::ligaCompDep(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator    k;
    
    // <editor-fold defaultstate="collapsed" desc="Ligar comp com dependencia">
    cout << "--Ligar componentes DEPENDENTES:" << endl;
    Componente* lastWE = NULL;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->getEIndice()) continue;
        if ((*i)->getComponenteRef()->tipo_comp != CompType::REG) continue;

        lastWE = NULL;
//                cout<< " ----- "<< endl;
//                cout<< " Componente (I): "<< (*i)->getName() << endl;
//                cout<< " identificando ultimo comp WE: "<< endl;
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->getEIndice()) continue;
            if ((*j)->getComponenteRef()->tipo_comp != CompType::REG) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            //if((*i)->node == (*j)->node) continue;
            if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    lastWE = (*j);
//                    cout<< "WE: "<< lastWE->getName() <<  endl;
                }
            }
        }
//        cout<< "WE: "<< lastWE->getName() <<  endl;
        if (lastWE == NULL) continue;
        
//        cout<< "PROCURAR PRIMEIRA OCORRENCIA DO REG COM NOME: '"<< lastWE->getNomeCompVHDL() << "'" <<  endl;
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*j)->tipo_comp != CompType::REF) continue;
            if ((*j)->getComponenteRef()->tipo_comp != CompType::REG) continue;
            if ((*i)->getNumParalelLina() != (*j)->getNumParalelLina()) continue;
            if (lastWE->node == (*j)->node) continue;
//            cout<< "---: "<< lastWE->getName() <<  endl;
            if ((*i)->getNomeVarRef() == (*j)->getNomeVarRef()) {
                if ((*j)->writeEnable == true) {
                    continue;
                } else {
                    if ((*j)->getPortDataInOut("IN")->temLigacao() == false) {
                        cout<<"--Ligando componentes (dependencia): " << lastWE->getName() << " -> " << (*j)->getName() <<endl;

                        //pegar ligacao na porta IN do componente lastWE e setar como BACKEDGE
                        
                        //Pegar todas as ligacores da saida do componente que o compoente ORIGEM seja (*j)
                        for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                            if ((*k)->getOrigem() == (*j) && (*k)->getAtivo() == true){
                                
                                (*j)->removeLigacao((*k));
                                (*k)->editOrig(lastWE);
                                (*k)->setPortOrigem(lastWE->getPortDataInOut("OUT"));
                                lastWE->addLigacao((*k));
                                lastWE->getPortDataInOut("OUT")->addLigacao((*k));
//                                (*k)->setBackEdge(true);
                                
                                if( (*k)->getDestino()->tipo_comp == CompType::DLY ){
                                    Componente* dlyAux = (*k)->getDestino();
                                    Ligacao* ligOutDly = dlyAux->getLigacaoOutDefault();
                                    
                                    dlyAux->removeLigacao(ligOutDly);
                                    
                                    Componente* newAux = ligOutDly->getDestino();
                                    newAux->removeLigacao(ligOutDly);
                                    
                                    (*k)->editDest(newAux);
                                    (*k)->setPortDestino(ligOutDly->getPortDestino());
                                    dlyAux->addLigacao((*k));
                          
                                    this->design->removeComponente(dlyAux, NULL);
                                }
                                
                            }
                        }
                        this->design->removeComponente((*j), NULL);
                        
//                        lastWE->getPortDataInOut("IN")->getLigacao2()->setBackEdge(true);
                        
                        break;
                    }
                }
            }
        }
    }
    cout << "--Ligar componentes DEPENDENTES: OK" << endl; 
    // </editor-fold>
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/8_LigDependentes.dot", false);
   
    
}

void Core::FinalizaComponentes(){
 
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Componente*>::iterator y;
    list<Ligacao*>::iterator    k;
    list<Componente*>ListaCompAux;
    set<string>ListaAuxString;
    //Ligacao* reset = new 
    int qtdLig = 0;
//    this->imprimeAll();
    

    
    this->ListaComp = this->design->getListaComp();
     
    //Processo de Ligacao SIMPLES (cria a ligacao disponivel na arvore AST gerada pelo ROSE)
    // <editor-fold defaultstate="collapsed" desc="Cria ligacoes conforme ROSE AST">
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/0_AntesLigBasicOK.dot", false);
    cout<<"--Criando ligacoes basicas"<<endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
            if ((*i)->tipo_comp ==  CompType::REG || (*i)->tipo_comp == CompType::MEM || (*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
            if ((*i)->node == (*j)->node) continue;
            
            //TODO sem saber o motivo a funcao isParent ou getParent do boost do Rose nao esta funcionando
            //por isso a necessidade de se usar uma estrutura de arvore a parte
            if (this->graph->isParent((*i)->node, (*j)->node)) {

                string str = FuncoesAux::IntToStr(this->design->ListaLiga.size());                   
                string portIn = "IN";
                Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                if( (*j)->tipo_comp == CompType::OPE){
                    string nome = "";
                    if((*j)->getPortOther("I0")->temLigacao() == false){
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
//                (*i)->getPortDataInOut("OUT")->setLigacao(lig->getNome());
                (*i)->getPortDataInOut("OUT")->addLigacao(lig);
                if(portIn == "IN"){
//                    (*j)->getPortDataInOut("IN")->setLigacao(lig->getNome());
                    (*j)->getPortDataInOut("IN")->addLigacao(lig);
                }else{
//                    (*j)->getPortOther(portIn)->setLigacao(lig->getNome());
                    (*j)->getPortOther(portIn)->addLigacao(lig);
                }

                //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
                (*i)->addLigacao(lig);
                (*j)->addLigacao(lig);
                //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                this->design->ListaLiga.push_back(lig);

                if((*j)->getNomeCompVHDL() == "add_reg_op_s" || (*j)->getNomeCompVHDL() == "sub_reg_op_s"){
                    if((*j)->getPortOther("I0")->temLigacao() == false){
                        Ligacao* lig1 = new Ligacao((*j), (*j), "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));

                        lig1->setPortOrigem((*j)->getPortDataInOut("OUT"));
                        lig1->setPortDestino((*j)->getPortOther("I0"));
                        lig1->setWidth((*j)->getPortDataInOut("OUT")->getWidth());
                        lig1->setTipo((*j)->getPortDataInOut("OUT")->getType());

//                        (*j)->getPortDataInOut("OUT")->setLigacao(lig1->getNome());
                        (*j)->getPortDataInOut("OUT")->addLigacao(lig1);
//                        (*j)->getPortOther("I0")->setLigacao(lig1->getNome());
                        (*j)->getPortOther("I0")->addLigacao(lig1);

                        (*j)->addLigacao(lig1);
                        this->design->ListaLiga.push_back(lig1);
                    }
                }

            }
        }
    }
    cout<<"--Criando ligacoes basicas: OK"<<endl;
    
    // </editor-fold>    
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/1_LigBasicOK.dot", false);
    
//    if(this->isParallel==true && this->gerarDual == false){
//        this->analiseDividirMemoria();
//    }
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/2_AntesAnalisaIF.dot", false);
    
    cout<<"--Ligar componentes IF:"<<endl;
    analisaIf* compAnaIf = new analisaIf(this->design);
    this->design = compAnaIf->getDesign();
    cout<<"--Ligar componentes IF: OK"<<endl;
    
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/2_1_RegMUX_OK.dot", false);   
    
    // <editor-fold defaultstate="collapsed" desc="Criar ligacao entre expressoes SIMPLES">
    cout<<"--Ligar componentes entre expressoes:"<<endl;
    
    analisaLigaComponente* objAnalisa = new analisaLigaComponente(this->design);
    this->design = objAnalisa->getDesign();

    cout<<"--Ligar componentes entre expressoes: OK"<<endl;
    // </editor-fold>
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/2_2_LigExpresOK.dot", false);
  
    
    // <editor-fold defaultstate="collapsed" desc="Efetuar ligacao varaivel que liga no indice vetor">
    cout << "--Criando novas ligacoes indice vet com variavel:" << endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->tipo_comp == CompType::REF) {

            comp_ref* CompRefI = (comp_ref*) (*i);
            if (CompRefI->getTipoVar() != "VET") continue;

            if (CompRefI->getPortOther("address")->temLigacao() == false) {
                for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                    if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
                    if ((*j)->tipo_comp == CompType::REF) {
                        comp_ref* CompRefJ = (comp_ref*) (*j);
                        if (CompRefJ->getTipoVar() != "VAR") continue;
                        if (CompRefI->getNomeVarIndex() == CompRefJ->getNomeVarRef()) {
                            if (CompRefI->getNumParalelLina() != CompRefJ->getNumParalelLina()) continue;
                             
                             //CRIAR NOVA LIGACAO
                            string str = FuncoesAux::IntToStr(this->design->ListaLiga.size());
                            Ligacao* lig = new Ligacao((*j), (*i), "s" + str);
                            lig->setPortOrigem((*j)->getPortDataInOut("OUT"));
                            lig->setPortDestino((*i)->getPortOther("address"));
                            lig->setWidth((*j)->getPortDataInOut("OUT")->getWidth());
                            lig->setTipo((*j)->getPortDataInOut("OUT")->getType());

                            //ADICIONAR LIGACAO NA PORTA                        
//                            lig->getPortDestino()->setLigacao(lig->getNome());
                            lig->getPortDestino()->addLigacao(lig);
//                            lig->getPortOrigem()->setLigacao(lig->getNome());
                            lig->getPortOrigem()->addLigacao(lig);

                            //ADICIONAR LIGACAO AOS COMPONENTES
                            (*i)->addLigacao(lig);
                            (*j)->addLigacao(lig);

                            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                            this->design->ListaLiga.push_back(lig);
                        }
                    }
                }
            }
        }
    }
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/4_LigIndiceVar.dot", false);
    cout << "--Criando novas ligacoes indice vet com variavel: OK" << endl; // </editor-fold>
    
    //Processo de identificacao dos componentes CONTADORES e criar a ligacao
    //para as memorias 
    // <editor-fold defaultstate="collapsed" desc="Criar ligacoes entre memorias e contador">
    cout<<"--Criando novas ligacoes do Contador"<<endl;
    ListaCompAux.clear();
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM) continue;
        if ((*i)->tipo_comp == CompType::CTD) {
            //Necessario para pegar funcao especifica do contador
            counter* CompCounter = (counter*)(*i); 
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) continue;
                if ((*i)->node == (*j)->node) continue;
                
                if ((*j)->tipo_comp == CompType::REF) {
 
                    comp_ref* CompRef = (comp_ref*)(*j); 
                    
                    //Liga a saida do contador na entrada na saida do registrador com o mesmo nome da variavel 
                    //de controle do contador
                    if (CompRef->getTipoVar() == "VAR" && CompRef->getNomeVarRef() == CompCounter->getVarControlCont()) {
                        if( (*j)->getPortDataInOut("OUT")->temLigacao()){
                                   
                            for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                                if((*k)->getAtivo() == false) continue;
                                if((*k)->getOrigem() == (*j)){                                                          
                                    (*k)->editOrig((*i));
                                    (*j)->removeLigacao((*k));
                                    (*i)->addLigacao((*k));

                                    (*k)->setPortOrigem((*i)->getPortDataInOut("OUT"));
                                    (*k)->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                                    (*k)->setTipo((*i)->getPortDataInOut("OUT")->getType());
                                    (*k)->getPortOrigem()->addLigacao((*k));
                                }
                            }

                            (*j)->tipo_comp = CompType::DEL;                        
                        }
                    }
                    
                    //Nao usa mais
                    if (CompRef->getNomeVarIndex() == CompCounter->getVarControlCont()) {
                        if(CompRef->getPortOther("address")->temLigacao() == false){
                            
                            //CRIAR NOVA LIGACAO
                            string str = FuncoesAux::IntToStr(this->design->ListaLiga.size());
                            Ligacao* lig = new Ligacao((*i), (*j), "s" + str);
                            lig->setPortOrigem((*i)->getPortDataInOut("OUT"));
                            lig->setPortDestino((*j)->getPortOther("address"));
                            lig->setWidth((*i)->getPortDataInOut("OUT")->getWidth());
                            lig->setTipo((*i)->getPortDataInOut("OUT")->getType());

                            //ADICIONAR LIGACAO NA PORTA                        
//                            lig->getPortDestino()->setLigacao(lig->getNome());
                            lig->getPortDestino()->addLigacao(lig);
//                            lig->getPortOrigem()->setLigacao(lig->getNome());
                            lig->getPortOrigem()->addLigacao(lig);

                            //ADICIONAR LIGACAO AOS COMPONENTES
                            (*i)->addLigacao(lig);
                            (*j)->addLigacao(lig);

                            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
                            this->design->ListaLiga.push_back(lig);
                        }
                    }
                }
            }
        }
    }
    
//    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//        if ((*i)->writeEnable != true) continue;
//        if ((*i)->tipo_comp != CompType::REF) continue;
////        if ((*i)->getComponenteRef()->tipo_comp != CompType::MEM) continue;
//        if((*i)->getPortOther("we")->temLigacao() == false && (*i)->getForComp() != NULL){
//            this->design->insereLigacao((*i)->getForComp(), (*i), "step"  , "we");
//        }
//    }
    
    this->dot->imprimeHWDOT(this->design->getListaComp(), this->design->getListaLiga(), "DOT/5_LigContador.dot", false);
    cout<<"--Criando novas ligacoes do Contador: OK"<<endl;
    // </editor-fold> 
       
    //Setar INICIALIZACAO
    comp_aux* comp_init = new comp_aux(NULL,"INIT", this->DATA_WIDTH);
    comp_init->setName("init");
    comp_init->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    this->design->addComponent(comp_init); 
    
    comp_aux* comp_done = new comp_aux(NULL, "DONE", this->DATA_WIDTH);
    comp_done->setName("done");
    comp_done->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    this->design->addComponent(comp_done); 
    
    // <editor-fold defaultstate="collapsed" desc="COMP INICIALIZACO">
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::CTD) continue;
        counter* CompCounter = (counter*)(*i);   

        //*********************************************************************
        // <editor-fold defaultstate="collapsed" desc="TERMINATION">
        comp_aux* comp_term = new comp_aux(NULL, "VALOR", this->DATA_WIDTH);
        comp_term->setName("comp_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp_term->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        //Pegar valor do contator referente ao MAXIMO de INTERACOES
        comp_term->setValAux(CompCounter->getVarControlValStop());
        
        //LIGACAO
        Ligacao* newLig2 = new Ligacao(comp_term, (*i), "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
        newLig2->setPortDestino((*i)->getPortOther("termination"));
        newLig2->setPortOrigem(comp_term->getPortDataInOut("OUT"));
        newLig2->setWidth((*i)->getPortOther("termination")->getWidth());
        newLig2->setTipo((*i)->getPortOther("termination")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig2->getPortDestino()->addLigacao(newLig2);
        newLig2->getPortOrigem()->addLigacao(newLig2);

        //ADICIONAR LIGACAO NO COMPONENTE
        (*i)->addLigacao(newLig2);
        comp_term->addLigacao(newLig2);

        //ADD LISTAS
        this->design->ListaLiga.push_back(newLig2);
//        this->design->ListaComp.push_back(comp_term); 
        this->design->addComponent(comp_term); 
        // </editor-fold>
        //*********************************************************************
        
        
        //*********************************************************************
        // <editor-fold defaultstate="collapsed" desc="INPUT">
        comp_aux* comp_input = new comp_aux(NULL, "VALOR", this->DATA_WIDTH);
        comp_input->setName("comp_" + FuncoesAux::IntToStr(this->design->ListaComp.size()));
        comp_input->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
        //Pegar valor do contator referente ao MAXIMO de INTERACOES
        comp_input->setValAux(CompCounter->getVarControlValIni());
        
        //LIGACAO
        Ligacao* newLig3 = new Ligacao(comp_input, (*i), "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
        newLig3->setPortDestino((*i)->getPortOther("input"));
        newLig3->setPortOrigem(comp_input->getPortDataInOut("OUT"));
        newLig3->setWidth((*i)->getPortOther("input")->getWidth());
        newLig3->setTipo((*i)->getPortOther("input")->getType());

        //ADICIONAR NOME LIGACAO NA PORTA
        newLig3->getPortDestino()->addLigacao(newLig3);
        newLig3->getPortOrigem()->addLigacao(newLig3);

        //ADICIONAR LIGACAO NO COMPONENTE
        (*i)->addLigacao(newLig3);
        comp_input->addLigacao(newLig3);

        //ADD LISTAS
        this->design->ListaLiga.push_back(newLig3);
        this->design->addComponent(comp_input); 
        // </editor-fold>
        //*********************************************************************
    }
    // </editor-fold>   
    
//    this->balanceAndSyncrhonize();
}

bool Core::existeSgNode(SgNode* node){
    this->ListaComp = this->design->getListaComp();
//    cout<<" -- Verificando se existe este nodo na lista: "<< endl;
     list<Componente*>::iterator i;
     bool existe = false;
     for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::CTD  ) continue;
        if ((*i)->node == node){
            existe = true;
        }
     }
     return existe;
}

Componente* Core::getCompBySgNode(SgNode* node){
     list<Componente*>::iterator i;
     Componente* comp = NULL;
     for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp == CompType::REG || (*i)->tipo_comp == CompType::MEM || (*i)->tipo_comp == CompType::CTD  ) continue;
        if ((*i)->node == node){
              comp = (*i);
          }
     }
     return comp;
}


void Core::updateCompRef(SgNode* node, comp_ref* comp){
    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(node);
    // <editor-fold defaultstate="collapsed" desc="E VAR">
    bool expIndVec = false;
    string name = "";
    if (nodo_ref_var != NULL) {
        comp->setTipoVar("VAR");
        comp->setNomeVarRef(nodo_ref_var->get_symbol()->get_name().getString());
        name = nodo_ref_var->get_symbol()->get_name().getString();
        name = this->design->getNomeCompRef(name);
        comp->setName(name);
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="E VETOR">
    if (nodo_ref_arr != NULL) {
        comp->setTipoVar("VET");
        string arrName = "";
        string arrPos = "";
        SgVarRefExp* fe = isSgVarRefExp(nodo_ref_arr->get_lhs_operand_i());
        SgVarRefExp* fd = isSgVarRefExp(nodo_ref_arr->get_rhs_operand_i());
        if (fe != NULL) {
            arrName = fe->get_symbol()->get_name().getString();
            if (fd != NULL) {
                arrPos = fd->get_symbol()->get_name().getString();
            } else {
                expIndVec = true;
            }
            comp->setNomeVarRef(arrName);
            name = this->design->getNomeCompRef(arrName);
            
            comp->setName(name);
            comp->setNomeVarIndex(arrPos);

        }
    }
    // </editor-fold>   

//    // <editor-fold defaultstate="collapsed" desc="Componente ACC">
//    if(comp->getPai() != NULL ){
//        SgNode* castPai = (SgNode*)(comp->getPai()); 
//        SgNode* nodePA = isSgPlusAssignOp(castPai);
//        if (nodePA != NULL) {
//            list<Componente*>::iterator i;
//            for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//                //            cout<< (*i)->getName()<< "-- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
//                if ((*i)->tipo_comp != CompType::REG) continue;
//                if ((*i)->getName() == comp->getName()) {
//                    //                cout<< "---" << (*i)->getName()<< " -- "<< (*i)->getNomeCompVHDL() << " -- " << (*i)->node <<endl;
//                    add_reg_op_s* add_reg = new add_reg_op_s((*i)->node, "WE", (*i)->dataWidth);
//                    //                if(comp->getNumParalelLina() == ""){
//                    name = (*i)->getName();
////                    (*i)->getComponenteRef()->tipo_comp = CompType::DEL;
//                    add_reg->setName(name);
//                    add_reg->setNomeVarRef(name);
//                    add_reg->setNumIdComp((*i)->getNumIdComp());
//                    add_reg->setValor((*i)->getGenericMapVal("initial", "VAL"));
//                    (*i) = add_reg;
//                }
//            }
//        }
//    }// </editor-fold>

    //MODIFICANDO E IDENTIFICANDO VARIAVEIS DO TIPO INDICES
    // <editor-fold defaultstate="collapsed" desc="VERIFICAR SE INDICE DO VET">
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
        if ((*j)->tipo_comp != CompType::REG && (*j)->tipo_comp != CompType::MEM) continue; 
        if ((*j)->tipo_comp == CompType::REG || (*j)->tipo_comp == CompType::MEM) {
            if (comp->getName() == (*j)->getName() || comp->getNomeVarRef() == (*j)->getName()) {
                comp->setComponenteRef((*j));
                if(comp->getNomeVarRef() == (*j)->getName() && (*j)->tipo_comp == CompType::REG){
                    if ((*j)->getNomeCompVHDL() == "add_reg_op_s") {
                        add_reg_op_s *ref2 = (add_reg_op_s*)(*j);
                        add_reg_op_s *newComp = new add_reg_op_s(*ref2);
                        newComp->setName(comp->getName());
                        comp->setComponenteRef(newComp);
                        newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                        this->design->addComponent(newComp);
                    }
                    if ((*j)->getNomeCompVHDL() == "sub_reg_op_s") {
                        sub_reg_op_s *ref2 = (sub_reg_op_s*)(*j);
                        sub_reg_op_s *newComp = new sub_reg_op_s(*ref2);
                        newComp->setName(comp->getName());
                        comp->setComponenteRef(newComp);
                        newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                        this->design->addComponent(newComp);
                    }
                    if ((*j)->getNomeCompVHDL() == "reg_op") {
                        reg_op *ref2 = (reg_op*)(*j);
                        reg_op *newComp = new reg_op(*ref2);
                        newComp->setName(comp->getName());
                        comp->setComponenteRef(newComp);
                        newComp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                        this->design->addComponent(newComp);
                    }
                }
                comp->updateCompRef();
                if (isIndiceVector(comp->getNomeVarRef())) {
                    comp->setEIndice(true);
                    comp->getComponenteRef()->setEIndice(true);
                }
                break;
            }
        }
    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Gerando ligacao com Exp ou indice do vetor">
    if (comp->getTipoVar() == "VET" && nodo_ref_arr != NULL) {

        SgNode* expInd = isSgNode(nodo_ref_arr->get_rhs_operand_i());
        Componente* compExp = NULL;
        if (this->existeSgNode(nodo_ref_arr->get_rhs_operand_i()) == true) {
            compExp = this->getCompBySgNode(expInd);
        }
        if (this->getCompBySgNode(nodo_ref_arr->get_rhs_operand_i()) == NULL) {
            compExp = analisaExp(expInd, NULL, "", comp->getNumParalelLina());
            comp->setNomeVarIndex(compExp->getName());
            compExp->setEIndice(true);
        }
        if (compExp != NULL) {
            Ligacao* lig = new Ligacao(compExp, comp, "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
            lig->setPortDestino(comp->getPortOther("address"));
            lig->setPortOrigem(compExp->getPortDataInOut("OUT"));
            lig->setWidth(compExp->getPortDataInOut("OUT")->getWidth());
            lig->setTipo(compExp->getPortDataInOut("OUT")->getType());

            //INFORMAR CADA PORTA QUEM E SUA LIGACAO
            compExp->getPortDataInOut("OUT")->addLigacao(lig);
            comp->getPortOther("address")->addLigacao(lig);

            //ADICIONAR EM CADA COMPONENTE ESTA LIGACAO
            compExp->addLigacao(lig);
            comp->addLigacao(lig);

            //ADICIONAR NA LISTA DE LIGACOES A NOVA LIGACAO
            this->design->ListaLiga.push_back(lig);
        }
        //        cout<< "CRIANDO LIGACAO COM O INDICE DO VETOR: OK" << endl;
    }// </editor-fold>

}

void Core::updateCounter(SgNode* node, counter* comp){
    SgForStatement* cur_for = isSgForStatement(node);
    if (cur_for != NULL){
        
        ROSE_ASSERT(cur_for);

        comp->setName(SageInterface::getLoopIndexVariable(node)->get_name().str());
//        comp->setName("CTD_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
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
                    int valor = intVal->get_value();
                    if (isSgMinusOp(intVal->get_parent())) valor *= -1;
                    comp->valores.push_back(valor);
                }
            }
            //comp->setValor(valores);
        }
        if(comp->valores.size() > 0){
            comp->setEInicializado(true);
            string nome_comp_vhdl = "block_ram";
            nome_comp_vhdl += "_"+comp->getName();
            comp->setNomeCompVHDL(nome_comp_vhdl);
        }
        
    }
    

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
    cout<< " ======================================== "<<endl;
    cout<< " LIGACOES"<<endl;
    cout<< " ======================================== "<<endl;
    for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
        if ((*k)->getAtivo() == false) continue; 
//        cout<< "nome: : " << (*k)->getNome() << " - "<< (*k)->getOrigem()->getName() << " ->" << (*k)->getDestino()->getName() << endl;
    }
    cout<< " ======================================== "<<endl;
    cout<< " COMPONENTES "<<endl;
    cout<< " ======================================== "<<endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp ==  CompType::MEM ) continue; 
        if ((*i)->tipo_comp ==  CompType::REG ) continue; 
        if ((*i)->tipo_comp ==  CompType::DEL ) continue; 
        if((*i)->getNomeCompVHDL() == "block_ram_mult_in"){
                //        cout<< (*i)->imprimePortas() << endl;
            cout<< " ---------------------------------------- "<<endl;
            cout<< (*i)->imprimeLigacoes() << endl;
            cout<< " ---------------------------------------- "<<endl;
            cout<< (*i)->geraCompVHDL() << endl;
            cout<< " ---------------------------------------- "<<endl;
        }
//        cout<< "COMP: " << (*i)->getName() << " - NUM: " <<(*i)->getNumIdComp() << endl;
//        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->imprimePortas() << endl;
//        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->imprimeLigacoes() << endl;
//        cout<< " ---------------------------------------- "<<endl;
//        cout<< (*i)->geraCompVHDL() << endl;
//        cout<< " ---------------------------------------- "<<endl;
    }
    cout<< " ======================================== "<<endl;   
}

Componente* Core::insereReg(Ligacao* lig){

    Componente* origem  = lig->getOrigem();  
 
    reg_op* reg = new reg_op(NULL, "WE");

    this->design->addComponent(reg);
    reg->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    reg->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));

    comp_ref* ref = new comp_ref(NULL, "WE");
//    this->design->addComponent(ref);
    ref->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
    ref->setNumLinha(origem->getNumLinha());

    ref->setTipoVar("VAR");
    ref->setNomeVarRef(reg->getName());
    ref->setName("comp_"+FuncoesAux::IntToStr(this->design->ListaComp.size()));
    ref->setComponenteRef(reg);
    ref->updateCompRef();

    ref->getPortDataInOut("IN")->setWidth(lig->getWidth());
    ref->getPortDataInOut("OUT")->setWidth(lig->getWidth());
    //CRIAR NOVA LIGACAO
    Ligacao* newLig = new Ligacao(ref, lig->getDestino(), "s" + FuncoesAux::IntToStr(this->design->ListaLiga.size()));
    newLig->setPortDestino((lig->getPortDestino()));
    newLig->setPortOrigem(ref->getPortDataInOut("OUT"));
    newLig->setWidth(lig->getWidth());
    newLig->setTipo(ref->getPortDataInOut("OUT")->getType());

    //ADICIONAR NOME LIGACAO NA PORTA
    newLig->getPortDestino()->addLigacao(newLig);
    newLig->getPortOrigem()->addLigacao(newLig);

    //Adicionando as novas ligacoes no Registrador
    reg->addLigacao(newLig);
    reg->addLigacao(lig);

    //EDITAR PARAMETRO LIGACAO ANTIGA 
    lig->editDest(reg);
    lig->setPortDestino(reg->getPortDataInOut("IN"));

    //ADICIONAR LIGACAO NA PORTA
    lig->getPortDestino()->addLigacao(lig);

    //Excluir referencia da ligacao antiga
    newLig->getDestino()->removeLigacao(lig);
    newLig->getDestino()->addLigacao(newLig);

    this->design->ListaLiga.push_back(newLig);
    
    return ref;
}

void Core::setClkReset(){
    list<Componente*>::iterator i;
    //Setar todoas as portas CLK e RESET
    // <editor-fold defaultstate="collapsed" desc="Setar Portas CLK e RESET">
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
//        if ((*i)->tipo_comp == CompType::REF) continue;
        if ((*i)->getPortOther("clk") != NULL){
            (*i)->getPortOther("clk")->setLigacao("\\clk\\");
            (*i)->getPortOther("clk")->temLigacaoo = false;
        }
        if ((*i)->getPortOther("reset") != NULL){
            (*i)->getPortOther("reset")->setLigacao("\\reset\\");
            (*i)->getPortOther("reset")->temLigacaoo = false;
        }
    }// </editor-fold>
}

void Core::geraArquivosDotHW(){
    string nameFilePath = this->project->get_file_info()->getFilenameFromID(0);
    const vector<string> fileVec = FuncoesAux::split(nameFilePath, "/");
    const vector<string> fileVec2= FuncoesAux::split(string(fileVec[fileVec.size()-1].c_str())  , ".");
    string nome = string(fileVec2[0].c_str());

//    this->imprimeAll();
    
    this->dot->imprimeHWDOT(this->design->ListaComp, this->design->ListaLiga, "DOT/"+nome+"_HW.dot", false, this->design->getTemMemoria());
    this->dot->imprimeVHDL(this->design->ListaComp, this->design->ListaLiga, nome);
}

void Core::analiseDividirMemoria(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<int>::iterator val;
    bool debug = true;
    int newQtdFor = 0;
    bool achouFirst = false;
    Componente* compOrigemAux = NULL;
    Port* portOrigemAux = NULL;
    Ligacao* ligOrigemAux= NULL;
    
    if(debug) cout<<"--Processo de divisao de intens dentro da memoria: "<<endl;
    
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp !=  CompType::REF) continue;
        if ((*i)->getEIndice() == true) continue;
        if (this->isIndiceVector((*i)->getNomeVarRef()) == true) continue;
        if ((*i)->getNumParalelLina() == "") continue;
        comp_ref* CompRefI = (comp_ref*)(*i);
        if (CompRefI->getTipoVar() != "VET") continue;
        block_ram* blockRam = (block_ram*)(*i)->getComponenteRef();
        int numP = FuncoesAux::StrToInt(CompRefI->getNumParalelLina());
        if(numP > 0){
            int totalVars = 0;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp !=  CompType::REF) continue;
                comp_ref* CompRefJ = (comp_ref*) (*j);
                if (CompRefJ->getTipoVar() != "VET") continue;
                if( CompRefI->getNomeVarRef() == CompRefJ->getNomeVarRef()) totalVars++;
            }
            if(totalVars > 1){
                if(debug) cout<< " COMP: " << CompRefI->getName() << " - "<< CompRefI->getNomeCompVHDL()<< " - Linha Parall: " <<  numP << endl;

                //Pegando informacoes da porta address, ligacao e do comp de origem.
                if(CompRefI->getPortOther("address")->temLigacao()){
                    if(debug) cout << "entrou no IF" << endl;
                    Componente* compOrigemI = NULL;
                    Port* portOrigemI = NULL;
                    Ligacao* ligOrigemI= NULL;
                    ligOrigemI = CompRefI->getPortOther("address")->getLigacao2();

                    if( ligOrigemI->getAtivo() == true ){
                        if( ligOrigemI != NULL ){
                            portOrigemI = ligOrigemI->getPortOrigem();
                            compOrigemI = ligOrigemI->getOrigem();
                            if(numP == 1 && achouFirst == false){
                                
                                ligOrigemAux  = ligOrigemI;
                                portOrigemAux = portOrigemI;
                                compOrigemAux = compOrigemI;
                                
                                if(debug){
                                    cout<< " DEFININDO COMPOENENTES INICIAIS PARA TROCA DO INDICE" <<endl;
                                    cout << "Lig Orig: " << ligOrigemAux->getNome() << endl;
                                    cout << "Por Orig: " << portOrigemAux->getName() << endl;
                                    cout << "Com Orig: " << compOrigemAux->getName() << endl;
                                }
                                
                                achouFirst = true;
                            }
                        }
                    }
                    if(portOrigemAux != NULL && compOrigemAux != NULL){
                        if(compOrigemAux != compOrigemI && portOrigemAux != portOrigemI){
                            if(debug) cout<< " entrou no processo de remover comps e criar nova ligacao" <<endl;
                            if(ligOrigemI->getAtivo() == true ){
                                if(compOrigemI->tipo_comp != CompType::DEL) this->design->removeComponente(compOrigemI, NULL);
                            }
                            this->design->insereLigacao(compOrigemAux, CompRefI, portOrigemAux->getName(), "address");
                            if(debug) cout<< " -- nova ligacao: '" << compOrigemAux->getName() << "' -> '"<< CompRefI->getName() <<"'"<<endl;
                        }
                    }
                }else{
                    if(debug) cout << "entrou no ELSE" << endl;
                    this->design->insereLigacao(compOrigemAux, CompRefI, portOrigemAux->getName(), "address");
                }
                
                int   intValues[blockRam->valores.size()];
                int aux1 = 0;
    //            cout<< " -------------------------- "<<endl;
    //            cout<< (*i)->getName() << " - " << (*i)->getNomeCompVHDL() <<endl;
    //            cout<< " -------------------------- "<<endl;
                for(val=blockRam->valores.begin(); val != blockRam->valores.end(); val++){
    //                cout<< "["<< aux1 <<"] = " << (*val) <<endl;
                    intValues[aux1] = (*val);
                    aux1++;//                cout<< "["<< aux1 <<"] = " << (*val) <<endl;
                }
//                cout<< " Lista antiga: " << blockRam->valores.size() << endl;
//                cout<< " AddressWidth: " << blockRam->getAddressWidth() << endl;
                list<int> novaLista;
                int totalElementos = blockRam->valores.size();
                int valIniFor = (numP-1)*(totalElementos/totalVars);
                int valFimFor = ((numP*totalElementos)/totalVars);
//                cout<< "-- pegando elementos da pos: " << valIniFor << " ate: " << valFimFor << endl;
                for(int te=valIniFor; te < valFimFor; te++){
                    int ele = intValues[te];
                    novaLista.push_back(ele);
                }
                blockRam->valores = novaLista;           
                blockRam->editQtdElementos(FuncoesAux::IntToStr(blockRam->valores.size()));
                newQtdFor = blockRam->valores.size();
//                cout<< " Lista Nova: " << blockRam->valores.size() << endl;
                (*i)->dataWidth = blockRam->getAddressWidth();
                (*i)->setGenericMapVal("address_width", "VAL", FuncoesAux::IntToStr(blockRam->getAddressWidth()) );
                (*i)->getPortOther("address")->setWidth(FuncoesAux::IntToStr(blockRam->getAddressWidth()));
//                cout<< " AddressWidth: " << blockRam->getAddressWidth() << endl;
            }
        }
    }
    if(newQtdFor > 0){
        for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
            if ((*i)->tipo_comp !=  CompType::CTD) continue;
            if ((*i)->tipo_comp ==  CompType::CTD){
                counter* comp = (counter*)(*i);
                comp->setGenericMapIncrements("1");
                comp->setVarControlValStop(FuncoesAux::IntToStr(newQtdFor-1));
            }
        }
    }
    cout<<"--Processo de divisao de intens dentro da memoria: OK"<<endl;
}

void Core::analiseMemoriaDualPort(){
    list<Componente*>::iterator i;
    list<Componente*>::iterator j;
    list<Ligacao*>::iterator k;
    
    //Processo de verificacao se existe duas memorias iguais do processo de paralelizacao
    //neste caso se existir apenas 2 estas vao ser substituidas por uma memoria DUAL
    // <editor-fold defaultstate="collapsed" desc="Inserir Dual Port">

    Componente* compAux=NULL;
    int aux = 0;
    cout<<"--Processo de insercao memoria dual port: "<<endl;
    for (i = this->design->ListaComp.begin(); i != this->design->ListaComp.end(); i++) {
        if ((*i)->tipo_comp != CompType::REF) continue;
        if ((*i)->tipo_comp == CompType::REF){
            comp_ref* CompRefi = (comp_ref*)(*i);
            compAux = NULL;
            aux = 0;
            if(CompRefi->getTipoVar() != "VET") continue;
            for (j = this->design->ListaComp.begin(); j != this->design->ListaComp.end(); j++) {
                if ((*j)->tipo_comp != CompType::REF) continue;
                if ((*j)->tipo_comp == CompType::REF){
                    comp_ref* CompRefj = (comp_ref*)(*j);
                    if(CompRefj->getTipoVar() != "VET") continue;
//                        if(CompRefi->getNomeVarRef() != CompRefj->getNomeVarRef()) aux++;
                    if(CompRefi->getNomeVarRef() == CompRefj->getNomeVarRef()) {
                        aux++;
                        compAux = CompRefj;
                    }                        
                }
            }

            if(aux == 2 && compAux != NULL){
                if((*i)->getComponenteRef()->tipo_comp == CompType::MEM){
                    //Criar novo componente referencia
                    comp_ref* comp = new comp_ref();
                    comp->setNumIdComp(FuncoesAux::IntToStr(this->design->ListaComp.size()));
                    comp->setNumLinha((*i)->getNumLinha());
                    comp->setNumParalelLina("");
                    comp->setName((*i)->getNomeVarRef());
                    comp->setEInicializado((*i)->getEInicializado());
                    this->design->addComponent(comp);

                    block_ram* mem = (block_ram*)(*i)->getComponenteRef();

                   //Criar novo componente dual port
                    block_ram_dual* comp_dbr = new block_ram_dual();

                    comp_dbr->setName((*i)->getNomeVarRef());
                    this->design->addComponent(comp_dbr);

                    if(mem->getEInicializado() == true){
                        comp_dbr->setEInicializado(true);
                        comp_dbr->setNomeCompVHDL("dual_block_ram_"+(*i)->getNomeVarRef());
                    }

                    //Varrer a memoria original e colocar os dados dentro
                    //da memoria dual
                    comp_dbr->valores = mem->valores;
                    comp_dbr->setQtdElementos(FuncoesAux::IntToStr(mem->qtd_elem_vet));

                    comp->setComponenteRef(comp_dbr);
                    comp->updateCompRef();

                    //APAGANDO COMP ANTIGOS
                    (*i)->tipo_comp = CompType::REG; 
                    compAux->tipo_comp = CompType::REG;
                    compAux->getComponenteRef()->tipo_comp = CompType::REG;
                    mem->tipo_comp = CompType::REG;
                    
//                    cout<< " COMP: ANTES " << comp->getName() << endl;
//                    cout<< " -------------------------- " << endl;
//                    cout<< comp->imprimePortas()<< endl;
//                    cout<< " -------------------------- " << endl;                    
                    //pegar todoas as ligacoes de (*i) e setar nas portas 0
                    for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                         if((*k)->getAtivo() == false) continue;
                         if((*k)->getOrigem() == (*i)){                                                          
                             Port* pOrig = comp->getPortOther((*k)->getPortOrigem()->getName()+"_0");
                             (*k)->setPortOrigem(pOrig);
//                             pOrig->setLigacao((*k)->getNome());
                             pOrig->addLigacao((*k));
                             (*k)->editOrig(comp);
                             (*i)->removeLigacao((*k));
                             comp->addLigacao((*k));
                         }
                         if((*k)->getDestino() == (*i)){                            
                             Port* pDest = comp->getPortOther((*k)->getPortDestino()->getName()+"_0");
                             (*k)->setPortDestino(pDest);
//                             pDest->setLigacao((*k)->getNome());
                             pDest->addLigacao((*k));
                             (*k)->editDest(comp);
                             (*i)->removeLigacao((*k));
                             comp->addLigacao((*k));                         
                         }
                    }

                    //pegar todoas as ligacoes de compAux e setar nas portas 1
                    for (k = this->design->ListaLiga.begin(); k != this->design->ListaLiga.end(); k++) {
                        if((*k)->getAtivo() == false) continue;
                        if((*k)->getOrigem() == compAux){
                            Port* pOrig = comp->getPortOther((*k)->getPortOrigem()->getName()+"_1");
//                            pOrig->setLigacao((*k)->getNome());
                            pOrig->addLigacao((*k));
                            (*k)->setPortOrigem(pOrig);
                            (*k)->editOrig(comp);
                            compAux->removeLigacao((*k));
                            comp->addLigacao((*k));
                        }
                        if((*k)->getDestino() == compAux){
                            Port* pDest = comp->getPortOther((*k)->getPortDestino()->getName()+"_1");
                            (*k)->setPortDestino(pDest);
//                            pDest->setLigacao((*k)->getNome());
                            pDest->addLigacao((*k));
                            (*k)->editDest(comp);
                            compAux->removeLigacao((*k));
                            comp->addLigacao((*k));
                       }
                    }
//                     cout<< " COMP: DEPOIS " << comp->getName() << endl;
//                    cout<< " -------------------------- " << endl;
//                    cout<< comp->imprimePortas()<< endl;
//                    cout<< " -------------------------- " << endl;
//                    cout<< comp->imprimeLigacoes()<< endl;
//                    cout<< " -------------------------- " << endl;
                }                  
            }
        }
    }
    cout<<"--Processo de insercao memoria dual port: OK"<<endl;
    // </editor-fold>
}

void* Core::GetStrPointerAdd(SgNode* nodo){
    void* address = static_cast<void*>(nodo);
//    std::stringstream ss;
//    ss << address;  
//    std::string name123 = ss.str(); 
    return address;
}

Core::~Core() {
}

