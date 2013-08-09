// ROSE translator example: identity translator.
//
// No AST manipulations, just a simple translation:
//
//    input_code > ROSE AST > output_code


//#include "rose.h"
#include "header/meuHeader.h"
#include "Core.h"
int main (int argc, char** argv)
{
    // Build the AST used by ROSE
    SgProject* project = frontend(argc, argv);
    Core* core = new Core(project);
    core->identificaVariaveis();
    core->identificaFor();
    core->FinalizaComponentes();
    core->identificaReturn();
    core->imprimeAll();
    core->geraArquivosDotHW();
//    //generateGraphOfAST(project,"DOT/AST");
//    //generatePDF(project);
    core->grafo();
}

