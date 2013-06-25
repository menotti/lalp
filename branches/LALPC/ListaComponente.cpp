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


using namespace std;
using namespace SageInterface;
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
    list<Componente>::iterator i;
    for(i=this->ListaComp.begin(); i != this->ListaComp.end(); i++){
        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
        (*i).imprime();
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
                    Componente comp(cur_var);
                    this->ListaComp.push_back(comp);
                    //comp.imprime();
                    //cout<<container.size()<<endl;
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
                    filhoEsq = fe->get_symbol()->get_symbol_basis();
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
            Componente comp(filhoEsq);
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
            Componente comp(expAdd);
            comp.ligado_Em(pai);
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
            Componente comp(expSub);
            comp.ligado_Em(pai);
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

            Componente comp(expDiv);
            comp.ligado_Em(pai);
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

            Componente comp(expMul);
            comp.ligado_Em(pai);
            this->ListaComp.push_back(comp);
            analisaExp(filhoEsq, nodoAtual, debug);
            analisaExp(filhoDir, nodoAtual, debug);
        }
    }// </editor-fold>

    
    /**************************************************************************/
    //ABAIXO AS FOLHAS DAS ARVORES, NESTE CASO NAO CHAMA MAIS A RECURSAO
    /**************************************************************************/
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
            Componente comp(decArr);
            comp.ligado_Em(pai);
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
        Componente comp(decVar);
        comp.ligado_Em(pai);
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
        Componente comp(valInt);
        comp.ligado_Em(pai);
        this->ListaComp.push_back(comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (debug) {
            cout << "-------------------------------" << endl;
            cout << "INT VALOR:    " << valInt->get_valueString() << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold> 
    }// </editor-fold>

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
                    
                    Componente comp(cur_for);
                    this->ListaComp.push_back(comp);
                    //comp.imprime();

                    /**********************************************************/
                    //Corpo do Loop com as operacoes
                    SgStatement* loopBody       = cur_for->get_loop_body();
                    //SgStatement* loopBody1      = SageInterface::getLoopBody(cur_for);
                    /**********************************************************/
                    
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

ListaComponente::~ListaComponente() {
}
