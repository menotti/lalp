/* 
 * File:   starParalel.cpp
 * Author: demo
 * 
 * Created on October 11, 2013, 8:58 AM
 */
#include "../header/meuHeader.h"
#include "starParalel.h"
#include "autoParSupport.h"
#include "FuncoesAux.h"
using namespace std;
using namespace SageInterface;
using namespace AutoParallelization;
using std::stringstream;
using boost::lexical_cast;
starParalel::starParalel(SgProject* project, list<SgNode*> listFor) {
    
//    this->project = project;
    cout<<"###############################################"<<endl;
    cout<<"#               DESENROLAR LOOP               #"<<endl;

//    this->removeRedundance(project);
//    this->verifyLiveDeadVar(project);
//    this->normalizeLoop(project);
    this->tryParallelLoop(project, listFor);
    
    cout<<"#              DESENROLAR LOOP: OK            #"<<endl;
    cout<<"###############################################"<<endl;
}
void starParalel::removeRedundance(SgProject* project){
    cout<<"# - redundancia:                              #"<<endl;
    PRE::partialRedundancyElimination(project);
    cout<<"# - redundancia: OK                           #"<<endl;
}
void starParalel::verifyLiveDeadVar(SgProject* project){
    cout<<"# - variaveis live dead:                      #"<<endl;
    initialize_analysis(project, false);
    cout<<"# - variaveis live dead: OK                   #"<<endl;
}
void starParalel::normalizeLoop(SgProject* project){
    cout<<"# - normalizar loops:                         #"<<endl;
    /**************************************************************************
     * normalize C99 style for (int i= x, ...) to C89 style: int i;  (i=x, ...)
     * Liao, 10/22/2009. Thank Jeff Keasler for spotting this bug
     */
    VariantVector vv (V_SgForStatement); 
    Rose_STL_Container<SgNode*> loops = NodeQuery::queryMemoryPool(vv); 
 
    for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin(); iter!= loops.end(); iter++ )
    {
      SgForStatement* cur_loop = isSgForStatement(*iter);
      ROSE_ASSERT(cur_loop);
      normalizeForLoopInitDeclaration(cur_loop);
    }
    //Prepare liveness analysis etc.
    cout<<"# - normalizar loops: OK                      #"<<endl;
}
void starParalel::tryParallelLoop(SgProject* project, list<SgNode*> listFor){
    cout<<"# - paralelizar loops:                        #"<<endl;
    bool OpenMP = false;
    
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
                        const vector<string> words = FuncoesAux::split(pragma->get_pragma(), " ");
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
//            NormalizeForLoop(fa_body, AstNodePtrImpl(body));
            
            const vector<string> words = FuncoesAux::split(listaPragma, "-");
            int i = 0;
            if(words.size() > 0){
                for (Rose_STL_Container<SgNode*>::iterator iter = loops.begin(); iter!= loops.end(); iter++ ) 
                {
                    SgNode* current_loop = *iter;

                    //cout<<"\t ACIMA DO FOR "<< newNodo->class_name() << endl;


                    //X. Parallelize loop one by one
                    // getLoopInvariant() will actually check if the loop has canonical forms 
                    // which can be handled by dependence analysis
                    bool parallel = false;
                    SgInitializedName* invarname = getLoopInvariant(current_loop);
                    if (invarname != NULL)
                    {
                        hasOpenMP = ParallelizeOutermostLoop(current_loop, &array_interface, annot, OpenMP);

                        if (hasOpenMP && !OpenMP){
                            SgForStatement* forVar = isSgForStatement(current_loop);
                            if (forVar != NULL){
    //                            ReductionRecognition(forVar);
                                parallel = loopUnrolling(forVar, atoi(words[i].c_str()));
                                if(parallel){
    //                                cout<<"FOR PARALELIZADO"<<endl;
    //                                cout<<"NODO: "<<forVar->class_name()<<endl;
                                    listFor.push_back(forVar);
                                }
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
            }
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
    cout<<"# - paralelizar loops: OK                     #"<<endl;
}

starParalel::~starParalel() {
}

