/*
 * Lucas Porto
*/
#include "rose.h"
#include "LoopTransformInterface.h"
#include "sageInterface.h"
#include "CommandOptions.h"
#include "DefUseAnalysis.h"
#include <AstInterface_ROSE.h>
#include <stdio.h>
#include <stdlib.h>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <set>
#include <string.h>
#include "autoParSupport.h"
#include "analysis.h"
#include <list>
#include <sstream>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include <map>
#include "liveDeadVarAnalysis.h"
#include "Componente.h"
#include <boost/lexical_cast.hpp>

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/kruskal_min_spanning_tree.hpp>
#include <iostream>
#include <fstream>
#include <list>



using namespace std;
using namespace SageInterface;
using namespace AutoParallelization;
using std::stringstream;
using boost::lexical_cast;


class Main : public AstSimpleProcessing
{
    protected: virtual void visit(SgNode* n);
    //public: string identificaNodo(SgNode* n){
    public: vector<string> split(const string& s, const string& delim);
    public: virtual void analisaLoop(SgProject *project, bool OpenMP);
    public: virtual void geraGraficoFluxo(SgProject *project, const string& nome);
    public: virtual void geraGraficoDataFlow(SgProject *project, const string& nome);
    public: virtual void geraGraficoDefuseAnalysis(SgProject *project, const string& nome);
    //public: virtual void teste(SgProject *project, const string& nome);
    public: virtual void identificaVariaveis(SgProject *project, list<Componente> &container);
    public: virtual void identificaFor(SgProject *project, list<Componente> &container);
    public: virtual void analisaExp(SgNode *nodoAtual, SgNode* pai, bool debug, list<Componente> &container);
};

void Main::visit(SgNode* n){
    /*
    SgFunctionDefinition* nodo = isSgFunctionDefinition(n);
    if (nodo != NULL)
    {
        PRE::partialRedundancyEliminationFunction(nodo);
    }
     * */
    
    /*
    SgType*  t_node = isSgType(n);
    if (t_node != NULL)
    {
      cout<<"-----------------------------"<< endl;
      cout<<"Type "<< t_node->class_name()<<endl;
      cout<<"\tunparsed string is "<< t_node->unparseToString()<<endl;
      cout<<"\tmangled name is "<< t_node->get_mangled().getString()  <<endl;
      cout<<"-----------------------------"<< endl;
    }

    SgDeclarationStatement*  d_node = isSgDeclarationStatement(n);
    if (d_node != NULL)
    {
      cout<<"-----------------------------"<< endl;
      cout<<"Declaration statement "<< d_node->class_name()<<endl;
      cout<<"\tunparsed string is "<< d_node->unparseToString()<<endl;
      cout<<"\tmangled name is "<< d_node->get_mangled_name().getString()  <<endl;
      cout<<"-----------------------------"<< endl;
    }

    SgInitializedName*  i_node = isSgInitializedName(n);
    if (i_node != NULL)
    {
      cout<<"-----------------------------"<<endl;
      cout<<"SgInitializedName "<< i_node->class_name()<<endl;
      cout<<"\tunparsed string is "<< i_node->unparseToString()<<endl;
      cout<<"\tmangled name is "<< i_node->get_mangled_name().getString()  <<endl;
      cout<<"-----------------------------"<< endl;
    } 
    */
    /*
    SgPragma* pragma = isSgPragma(n);
    if (pragma != NULL){
        if (pragma->get_pragma().find("unroll") == 0){
            const vector<string> words = split(pragma->get_pragma(), " ");
            _loopFator = atoi(words[1].c_str());
        }
    }
    
    SgForStatement* forVar = isSgForStatement(n);
    //ReductionRecognition(forVar);
    if (forVar != NULL){
        ArrayAnnotation* annot = ArrayAnnotation::get_inst(); 
        ArrayInterface array_interface(*annot);
        
        bool isParal = ParallelizeOutermostLoop(n, &array_interface, annot, false);
        if(isParal == true){
            loopUnrolling(forVar, _loopFator);
        }
        _loopFator = 0;
    }
     * */
};

void Main::geraGraficoFluxo(SgProject *project, const string& nome=""){
    
    Rose_STL_Container<SgNode*> functions = NodeQuery::querySubTree(project, V_SgFunctionDefinition);

    
    for( Rose_STL_Container<SgNode*>::const_iterator i = functions.begin(); i != functions.end(); ++i){
        SgFunctionDefinition* proc = isSgFunctionDefinition(*i);
        ROSE_ASSERT(proc != NULL);
        string fileName = StringUtility::stripPathFromFileName(proc->get_file_info()->get_filenameString());
               
        VirtualCFG::cfgToDotForDebugging(proc,nome+"debug.dot");
        VirtualCFG::interestingCfgToDot(proc,nome+"interestin.dot");
    }
}

void Main::geraGraficoDataFlow(SgProject *project, const string& nome=""){
    DFAnalysis* defuse = new DefUseAnalysis(project);
    bool debug = false;
    defuse->run(debug);
    defuse->dfaToDOT();
    NodeQuerySynthesizedAttributeType vars = NodeQuery::querySubTree(project, V_SgInitializedName);
    NodeQuerySynthesizedAttributeType::const_iterator i = vars.begin();     
    for(; i != vars.end();++i) {
        SgInitializedName* initName = isSgInitializedName(*i);
        std::string name = initName->get_qualified_name().str();
        vector<SgNode*> vec = defuse->getDefFor(initName, initName);
        if(vec.size()>0){
                std::cout <<" DEF>> Vector entries for " <<name<<" ( "<<initName<<" ) : "<<vec.size()<<std::endl;
        }
    }
    
}

void Main::geraGraficoDefuseAnalysis(SgProject *project, const string& nome=""){
    // Call the Def-Use Analysis
    DFAnalysis* defuse = new DefUseAnalysis(project);
    bool debug = false;
    defuse->run(debug);
    // Output def use analysis results into a dot file
    

    // Find all variable references
    NodeQuerySynthesizedAttributeType vars = NodeQuery::querySubTree(project, V_SgVarRefExp); 
    NodeQuerySynthesizedAttributeType::const_iterator i = vars.begin();
    for (; i!=vars.end();++i) 
    {
        SgVarRefExp * varRef = isSgVarRefExp(*i);
        SgInitializedName* initName = isSgInitializedName(varRef->get_symbol()->get_declaration());
        std::string name = initName->get_qualified_name().str();
        
        // Find reaching definition of initName at the control flow node varRef
        vector<SgNode* > vec = defuse->getDefFor(varRef, initName);
        ROSE_ASSERT (vec.size() >0 ); // each variable reference must have a definition somewhere

        // Output each reaching definition node and the corresponding statement.
        std::cout<<"---------------------------------------------"<<std::endl;
        std::cout << vec.size() << " definition entry/entries for " << varRef->unparseToString() << " @ line " << varRef->get_file_info()->get_line()<<":"<<varRef->get_file_info()->get_col() << std::endl;
        for (size_t j =0; j<vec.size(); j++)
        {
            cout<<vec[j]->class_name()<<" "<<vec[j]<<endl;
            SgStatement * def_stmt = SageInterface::getEnclosingStatement(vec[j]);
            ROSE_ASSERT(def_stmt);
            cout<<def_stmt->unparseToString()<<"  @ line "<<def_stmt->get_file_info()->get_line() <<":"<<def_stmt->get_file_info()->get_col() <<endl;
        }
    }
    defuse->dfaToDOT();
}

void Main::analisaLoop(SgProject *project, bool OpenMP){
    // For each source file in the project
    ROSE_ASSERT (project != NULL);
    initialize_analysis (project,false);
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
            
            Rose_STL_Container<SgNode*> loops = NodeQuery::querySubTree(defn,V_SgForStatement); 
            if (loops.size()==0) continue;
            
            
            //TODO o esquema do pragma funciona apenas se estiver SETADOS a marcacao em todos os LACOS
            Rose_STL_Container<SgNode*> pragmas = NodeQuery::querySubTree(defn,V_SgPragma); 
            string listaPragma = "";
            for (Rose_STL_Container<SgNode*>::iterator iter = pragmas.begin(); iter!= pragmas.end(); iter++ ) 
            {
                SgNode* current_pragma = *iter;
                SgPragma* pragma = isSgPragma(current_pragma);
                if (pragma != NULL){
                    if (pragma->get_pragma().find("unroll") == 0){
                        const vector<string> words = split(pragma->get_pragma(), " ");
                        listaPragma +="-"+string(words[1].c_str())+"-";
                    }
                }
            }
           
            // X. Replace operators with their equivalent counterparts defined 
            // in "inline" annotations
            AstInterfaceImpl faImpl_1(body);
            CPPAstInterface fa_body(&faImpl_1);
            OperatorInlineRewrite()( fa_body, AstNodePtrImpl(body));

            // Pass annotations to arrayInterface and use them to collect 
            // alias info. function info etc.  
            ArrayAnnotation* annot = ArrayAnnotation::get_inst(); 
            ArrayInterface array_interface(*annot);
            array_interface.initialize(fa_body, AstNodePtrImpl(defn));
            array_interface.observe(fa_body);

            //FR(06/07/2011): aliasinfo was not set which caused segfault
            LoopTransformInterface::set_aliasInfo(&array_interface);

            // X. Loop normalization for all loops within body
            NormalizeForLoop(fa_body, AstNodePtrImpl(body));
            
            const vector<string> words = split(listaPragma, "-");
            int i = 0;
            for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin(); iter!= loops.end(); iter++ ) 
            {
                SgNode* current_loop = *iter;
                
                SgNode* newNodo = current_loop->get_parent();
                //cout<<"\t ACIMA DO FOR "<< newNodo->class_name() << endl;
                
                
                //X. Parallelize loop one by one
                // getLoopInvariant() will actually check if the loop has canonical forms 
                // which can be handled by dependence analysis
                SgInitializedName* invarname = getLoopInvariant(current_loop);
                if (invarname != NULL)
                {
                    hasOpenMP = ParallelizeOutermostLoop(current_loop, &array_interface, annot, OpenMP);
                    
                    if (hasOpenMP && !OpenMP){
                        SgForStatement* forVar = isSgForStatement(current_loop);
                        //ReductionRecognition(forVar);
                        if (forVar != NULL){
                                loopUnrolling(forVar, atoi(words[i].c_str()));
                        }
                    }
                }
                else // cannot grab loop index from a non-conforming loop, skip parallelization
                {
                    if (enable_debug)
                        cout<<"Skipping a non-canonical loop at line:"<<current_loop->get_file_info()->get_line()<<"..."<<endl;
                    hasOpenMP = false;
                }
                i++;
            }// end for loops
        } // end for-loop for declarations
        // insert omp.h if needed
        if (OpenMP && hasOpenMP && !enable_diff)
        {
            SageInterface::insertHeader("omp.h",PreprocessingInfo::after,false,root);
            if (enable_patch)
                generatePatchFile(sfile); 
        }
        // compare user-defined and compiler-generated OmpAttributes
        if (enable_diff)
                diffUserDefinedAndCompilerGeneratedOpenMP(sfile); 
    } //end for-loop of files
}

//FUNCAO SPLIT STRING
vector<string> Main::split(const string& s, const string& delim) {
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

void Main::identificaVariaveis(SgProject *project, list<Componente> &container) {
    string nome = "";
    // For each source file in the project
    ROSE_ASSERT (project != NULL);
    initialize_analysis (project,false);
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
                    container.push_back(comp);
                    //comp.imprime();
                    cout<<container.size()<<endl;
                }         
            }
        }
    }   
}

void Main::identificaFor(SgProject *project, list<Componente> &container) {
    string nome = "";
    // For each source file in the project
    ROSE_ASSERT (project != NULL);
    initialize_analysis (project,false);
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
                    container.push_back(comp);
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
                            this->analisaExp(expStmt, NULL, false, container);
                        }
                    }
                }         
            }
        }
    }   
}

void Main::analisaExp(SgNode *nodoAtual, SgNode* pai, bool debug, list<Componente> &container) {

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
     */
    SgAssignOp* expStmt = isSgAssignOp(nodoAtual);
    if(expStmt != NULL){
        SgNode* filhoEsq = isSgNode(expStmt->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expStmt->get_rhs_operand_i());
        
        if(filhoEsq != NULL && filhoDir != NULL){
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
            container.push_back(comp);
            analisaExp(filhoDir,filhoEsq, debug, container);
        }
    }
    
    /*
     * Quando identificar CAST_EXP
     * neste caso ignora e passa para o NODO abaixo
     */
    // <editor-fold defaultstate="collapsed" desc="NODO CAST - IGNORADO">
    SgCastExp* castExp = isSgCastExp(nodoAtual);
    if (castExp != NULL) {
        SgNode* proxNodo = isSgNode(castExp->get_operand_i());
        analisaExp(proxNodo, pai, debug, container);
    }// </editor-fold>

    
    /*
     * Quando identificar operacao de SOMA
     * este nodo sempre chama rescursao pois o mesmo sempre se encontra no meio
     * da arvore.
     */
    SgAddOp* expAdd = isSgAddOp(nodoAtual);
    if(expAdd != NULL){
        SgNode* filhoEsq = isSgNode(expAdd->get_lhs_operand_i());
        SgNode* filhoDir = isSgNode(expAdd->get_rhs_operand_i());
        if(filhoEsq != NULL && filhoDir != NULL){
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
            container.push_back(comp);
            analisaExp(filhoEsq,nodoAtual,debug, container);
            analisaExp(filhoDir,nodoAtual,debug, container);
        }         
    }
    
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
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }
            analisaExp(filhoEsq, nodoAtual, debug, container);
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }
            analisaExp(filhoDir, nodoAtual, debug, container);
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
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }
            analisaExp(filhoEsq, nodoAtual, debug, container);
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }
            analisaExp(filhoDir, nodoAtual, debug, container);
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
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoEsq->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;

            }
            analisaExp(filhoEsq, nodoAtual, debug, container);
            if (debug) {
                cout << "-------------------------" << endl;
                cout << "      CHAMOU RECURSAO    " << endl;
                cout << "-------------------------" << endl;
                cout << " ( " << filhoDir->class_name() << " , " << nodoAtual->class_name() << " ) " << endl;
                cout << "-------------------------" << endl;
            }
            analisaExp(filhoDir, nodoAtual, debug, container);
        }
    }// </editor-fold>

    
    
    /**************************************************************************/
    //ABAIXO AS FOLHAS DAS ARVORES, NESTE CASO NAO CHAMA MAIS A RECURSAO
    /*
     * Quando identificar Pntr ARRAY
     * este nodo mostra que identificou um array que 'e utilizado na 
     * expressao, neste caso pode-se pegar os dois filhos deste nodo
     * pois os mesmos ja sao folhas da arvore.
     */
    SgPntrArrRefExp* decArr = isSgPntrArrRefExp(nodoAtual);
    if(decArr != NULL){
        string arrName  = "";
        string arrPos   = ""; 
        SgVarRefExp* fe = isSgVarRefExp( decArr->get_lhs_operand_i() );
        SgVarRefExp* fd = isSgVarRefExp( decArr->get_rhs_operand_i() );
        if ( fe != NULL &&  fd != NULL){
            // <editor-fold defaultstate="collapsed" desc="DEBUG">
            arrName     = fe->get_symbol()->get_name().getString();
            arrPos      = fd->get_symbol()->get_name().getString();
            
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
            //comp.ligadoEm(pai);
            //container.push_back(comp);
        }
    }
    
    
    /*
     * Quando identificar uma REFERENCIA a uma VARIAVEL
     * este nodo mostra que identificou uma variavel que 'e utilizado na 
     * expressao.
     */
    SgVarRefExp* decVar = isSgVarRefExp(nodoAtual);
    if(decVar != NULL){
        string varNome  = "";
        string arrPos   = "";         
        varNome     = decVar->get_symbol()->get_name().getString();
        Componente comp(decVar);
        //comp.ligadoEm(pai);
        container.push_back(comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (debug) {
            cout << "-------------------------------" << endl;
            cout << "VAR: " << varNome << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold>   
    }
   
    /*
     * Quando identificar um valor INTEIRO na expressao.
     */
    SgIntVal* valInt = isSgIntVal(nodoAtual);
    if(valInt != NULL){
        Componente comp(valInt);
        //comp.ligadoEm(pai);
        container.push_back(comp);
        // <editor-fold defaultstate="collapsed" desc="DEBUG">
        if (debug) {
            cout << "-------------------------------" << endl;
            cout << "INT VALOR:    " << valInt->get_valueString() << " ---> " << pai->class_name() << endl;
            cout << "-------------------------------" << endl;
        }// </editor-fold> 
    }
    
}

int main(int argc, char * argv[]){
    SgProject *project = frontend (argc, argv);
    initAnalysis(project);
    Main        	myvisitor;
    bool OpenMP         = false;
    bool Redundancia    = false; 
    bool VarLiveDead    = false;
    bool AnaliseLoops   = false;
    ROSE_ASSERT (project != NULL);
    
    //Criando Container dos componentes identificados na arvore AST
    list<Componente> componentes;
    
    //RETIRAR REDUNDANCIA
    if(Redundancia == true){
        cout<<"###############################################"<<endl;
        cout<<"#           ELIMINACAO DE REDUNDANCIA         #"<<endl;
        cout<<"###############################################"<<endl;
        PRE::partialRedundancyElimination(project);      
    }
    
    //VERIFICAR VARIAVEIS MORTAS
    if(VarLiveDead == true){
        cout<<"###############################################"<<endl;
        cout<<"#           VERIFICACAO DE VARIAVEIS          #"<<endl;
        cout<<"###############################################"<<endl;
        initialize_analysis(project,false);
    }
    
    //myvisitor.geraGraficoFluxo(project, "ANTES");
    
    /**************************************************************************
     * normalize C99 style for (int i= x, ...) to C89 style: int i;  (i=x, ...)
     * Liao, 10/22/2009. Thank Jeff Keasler for spotting this bug
     */
    VariantVector vv (V_SgForStatement); 
    Rose_STL_Container<SgNode*> loops = NodeQuery::queryMemoryPool(vv); 
 
    for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin();
                iter!= loops.end(); iter++ )
    {
      SgForStatement* cur_loop = isSgForStatement(*iter);
      ROSE_ASSERT(cur_loop);
      normalizeForLoopInitDeclaration(cur_loop);
    }
    //Prepare liveness analysis etc.
    
    /*************************************************************************/
    
    
    /******************************************************/
    //ANALISE PRINCIPAL DOS LOOPs
    if(AnaliseLoops == true){
        cout<<"###############################################"<<endl;
        cout<<"#      ANALISE E PARALELIZACAO DOS LOOPS      #"<<endl;
        cout<<"###############################################"<<endl;
        myvisitor.analisaLoop(project, OpenMP);
    }
    
    cout<<"###############################################"<<endl;
    cout<<"#          IDENTIFICACAO DE VARIAVEIS         #"<<endl;
    cout<<"###############################################"<<endl;
    cout<<"#                                             #"<<endl;
    cout<<"# Iniciando processo de identificacao das     #"<<endl;
    cout<<"# Variaveis                                   #"<<endl;
    
    myvisitor.identificaVariaveis(project, componentes);
    
    cout<<"# ------------------------------------------  #"<<endl;
    cout<<"# Variaveis identificadas                     #"<<endl;
    cout<<"###############################################"<<endl;
    
    
    cout<<"###############################################"<<endl;
    cout<<"#           IDENTIFICACAO DE LOOPS            #"<<endl;
    cout<<"###############################################"<<endl;
    cout<<"#                                             #"<<endl;
    cout<<"# Iniciando processo de identificacao dos     #"<<endl;
    cout<<"# Loops                                       #"<<endl;
    myvisitor.identificaFor(project, componentes);
    //myvisitor.traverseInputFiles(project,preorder);
    cout<<"# ------------------------------------------  #"<<endl;
    cout<<"# Loops identificados                         #"<<endl;
    cout<<"###############################################"<<endl;
    
    
    
    cout<<"###############################################"<<endl;
    cout<<"#            RODANDO COMPONENTES              #"<<endl;
    cout<<"###############################################"<<endl;
    cout<<"# Iniciando testes                            #"<<endl;
    cout<<"  Total Comp: "<< componentes.size()<<endl;
    list<Componente>::iterator i;
    for(i=componentes.begin(); i != componentes.end(); i++){
        //cout<< (*i).tipo_comp<< " - "<< cout<< (*i).node <<  endl;
        (*i).imprime();
    }
    cout<<"###############################################"<<endl;
    
    
    
    //PERCORRE CADA NODO
    //myvisitor.traverseInputFiles(project,preorder);
    
    
    //myvisitor.geraGraficoFluxo(project, "DEPOIS");
    
    //myvisitor.geraGraficoDataFlow(project,"GDF");
    generateGraphOfAST(project,"AST");
    /******************************************************/
    
    //myvisitor.teste(project,"teste");
    
    //SageInterface::outputLocalSymbolTables(project);
    
    release_analysis();
    generatePDF(*project);
    
    // Dump mangled map
    /**
    cout<<""<<endl;
    cout<<"----------- mangled name map -------------"<<endl;
    std::map< SgNode *, std::string > & m_map = SgNode::get_globalMangledNameMap ();
    //std::map< SgNode *, std::string > & m_map = SgNode::get_globalQualifiedNameMapForTypes();
    std::map< SgNode *, std::string >::iterator iter = m_map.begin();
    for (; iter != m_map.end(); iter++)
    {
      cout<<"SgNode is "<< (*iter).first->class_name()<<"    ";
      cout<<"Mangled name is "<< (*iter).second <<endl;
    }

    // Dump mangled types
    cout<<"----------- mangled types-------------"<<endl;
    */ 
   
    return backend(project);
}
