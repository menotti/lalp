// ROSE translator example: identity translator.
//
// No AST manipulations, just a simple translation:
//
//    input_code > ROSE AST > output_code


//#include "rose.h"
#include "header/meuHeader.h"
#include "Core.h"
#include "Aux/starParalel.h"
//#include "Aux/autoParSupport.h"

int main (int argc, char** argv)
{
    // Build the AST used by ROSE
    list<SgNode*>listaForParall;
    
    SgProject* project = frontend(argc, argv);
    starParalel* para  = new starParalel(project, listaForParall);
    Core* core = new Core(project, para->getListaComp());    
    //generateGraphOfAST(project,"DOT/AST");
    
//    //generatePDF(project);
//    core->grafo();
    return backend(project);
}

