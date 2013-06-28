/* 
 * File:   Componente.cpp
 * Author: Lucas Porto
 * 
 * Created on 14 de Junho de 2013, 10:07
 */
#include "rose.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include "Componente.h"
#include "variables.h"
#include <boost/lexical_cast.hpp>
#include "Ligacao.h"

using namespace std;
using namespace SageInterface;
using std::stringstream;
using boost::lexical_cast;
using std::string;

Componente::Componente(SgNode* node){
    this->limpaAtributos();
    this->node = node;
    
    /************************************************/
    //DECLARACAO VARIAVEL-VETOR
    SgInitializedName* nodo_var  = isSgInitializedName(this->node);
    if(nodo_var != NULL){
        this->montaComponenteVar();
    }
    /************************************************/
    
    /************************************************/
    //LACO FOR
    SgForStatement* nodo_for    = isSgForStatement(this->node);
    if(nodo_for != NULL){
        this->montaComponenteLoop();
    }
    /************************************************/
    
    /************************************************/
    //OP ADD
    SgAddOp* nodo_op_add = isSgAddOp(this->node);
    if(nodo_op_add != NULL){
        this->montaComponenteOp();
    }
    //TODO - Fazer para outras operacoes
    /************************************************/
    
    /************************************************/
    //CONSTANTE INTEIRA
    SgIntVal* nodo_int  = isSgIntVal(this->node);
    if(nodo_int != NULL){
        this->montaComponenteConst();
    }
    //TODO - Fazer para outras constantes - float, char, etc
    /************************************************/
    
    /************************************************/
    //REFERENCIA DE VARIAVEL NA EXPRESSAO
    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(this->node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(this->node);
    if(nodo_ref_var != NULL || nodo_ref_arr != NULL){
        this->montaComponenteRef();
    }
    
    /************************************************/
}

void Componente::ligado_Em(SgNode* nodo){
    //Cria a ligacao do noto atual na entrada do nodo do PARAMETRO
    this->nodoPai = nodo;
}

void Componente::limpaAtributos(){
    //COMUM
    this->nome;
    this->tipo_comp     = "";     //Tipo do Componente - Registrador - Operacao - Contador - etc
    this->eInicializado = false;  //Se a variavel foi inicializada
    this->nodoPai       = NULL;   //Informa o nodo Pai na expressao. 
    //this->out_comp      = NULL;

    //VAR
    this->tipo_var      = "";     //Int - Str - Flo
    this->valor         = "";     //Valor da Variavel ou Todos os elementos do Vetor

    //VETOR
    this->eVetor        = false;
    this->qtd_ele_vet   = 0;      //quantidade de elementos dentro do vetor

    //OPERACAO
    this->op_tipo       = "";
    //this->op_in_1       = NULL; //Define entrada 1
    //this->op_in_2       = NULL; //Define entrada 2
    
    //FOR
    this->for_ctr_var   = "";   //Variavel de controle - EX.: (i) => for (i = 0, ....)
    this->for_ctr_val_ini= 0;   //Valor inicial da variavel de controle
    this->for_cond_var  = "";   //variavel de condicao - EX.: (i) => i < 10
    this->for_cond_val  = 0;    //valor de condicao - EX.: (10) => i < 10
    this->for_cond_op   = "";   //operacao de controle do for - EX.: (<) => i < 10
    this->for_incr_var  = "";   //variavel incrementar for - EX.: (i) => i++;
    this->for_incr_op   = "";   //incrementar for - EX.: (++) => i++;
    this->for_incr_val  = 0;    //valor incrementar for - EX.: 1
    
    //Constante
    this->cons_tipo     = "";
    
    //Referencias
    this->ref_var_nome  = "";
    this->ref_var_index = "";
    this->ref_var_tipo  = "";
}

void Componente::addLigacao(Ligacao* lig){
    this->ligacoes.push_back(lig);
}

SgNode* Componente::getPai(){
    return this->nodoPai;
}
 

string Componente::imprimeDOT(){
    string res = "";
    if(this->tipo_comp == "REG"){
    
        cout<< "NOME VAR:  "<< this->nome           << endl;
        cout<< "E INICIADO:"<< this->eInicializado  << endl;
        cout<< "E VETOR:   "<< this->eVetor         << endl;
        cout<< "TIPO VAR:  "<< this->tipo_var       << endl;
        cout<< "TIPO COMP: "<< this->tipo_comp      << endl;
        cout<< "QTD ELEME: "<< this->qtd_ele_vet    << endl;
        cout<< "VALOR:     "<< this->valor          << endl;
    }if(this->tipo_comp == "MEM"){    
        res += "\""+this->nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address[11]|<clk>clk|<data_in>data_in[32]|<oe>oe|<we>we}|block_ram:"+this->nome+"|{<data_out>data_out[32]}}\"]; \n";
        cout<< "NOME VAR:  "<< this->nome           << endl;
        cout<< "E INICIADO:"<< this->eInicializado  << endl;
        cout<< "E VETOR:   "<< this->eVetor         << endl;
        cout<< "TIPO VAR:  "<< this->tipo_var       << endl;
        cout<< "TIPO COMP: "<< this->tipo_comp      << endl;
        cout<< "QTD ELEME: "<< this->qtd_ele_vet    << endl;
        cout<< "VALOR:     "<< this->valor          << endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "CTD"){
        res += "\""+this->for_ctr_var +"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<clk>clk|<clk_en>clk_en|<input>input[16]|<load>load|<reset>reset|<termination>termination[16]}|counter:"+this->for_ctr_var +"\\n\\<\\n+=1\\nsteps=1|{<done>done|<output>output[16]|<step>step}}\"]; \n";   
        cout<< "VAR:       "<<this->for_ctr_var     << endl;
        cout<< "VAL INI:   "<<this->for_ctr_val_ini << endl;
        cout<< " "<< endl;
        cout<< "VAR:       "<<this->for_cond_var    << endl;
        cout<< "OP CONTR:  "<<this->for_cond_op     << endl;
        cout<< "VAL CONTR: "<<this->for_cond_val    << endl;  
        cout<< " "<< endl;
        cout<< "VAR INCR:  "<<this->for_incr_var    << endl;
        cout<< "OP  INCR:  "<<this->for_incr_op     << endl;
        cout<< "VAL INCR:  "<<this->for_incr_val    << endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "OPE"){
        
        cout<<"OPERCACAO:  "<<this->tipo_comp       <<endl;
        cout<<"TIPO OP:    "<<this->op_tipo         <<endl;
        if(this->tipo_comp == "ADD"){
            res += "\"x_add_op_s_y\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|add_op_s:x_add_op_s_y|{<O0>O0[32]}}\"]; \n";
        } 
       
        
        cout<<"TIPO OP:    "<<this->op_tipo         <<endl;
        cout<<"LIGADO EM-->"<<this->nodoPai->class_name()   <<endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "CON"){
        cout<<"Constante"<<endl;
        cout<<"TIPO:      "<<this->cons_tipo        <<endl;
        cout<<"VALOR:     "<<this->valor             <<endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "REF"){
        cout<<"Referencia "<<endl;
        cout<<"TIPO:  "<<this->ref_var_tipo      <<endl;
        cout<<"Nome Ref:  "<<this->ref_var_nome      <<endl;
        cout<<"INDICE:    "<<this->ref_var_index     <<endl;
        cout<< "--------------------------------------------"<< endl;
    }
    return res;
}

void Componente::imprime(){
    if(this->tipo_comp == "REG" || this->tipo_comp == "MEM"){
        cout<< "NOME VAR:  "<< this->nome           << endl;
        cout<< "E INICIADO:"<< this->eInicializado  << endl;
        cout<< "E VETOR:   "<< this->eVetor         << endl;
        cout<< "TIPO VAR:  "<< this->tipo_var       << endl;
        cout<< "TIPO COMP: "<< this->tipo_comp      << endl;
        cout<< "QTD ELEME: "<< this->qtd_ele_vet    << endl;
        cout<< "VALOR:     "<< this->valor          << endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "CTD"){
        cout<< "VAR:       "<<this->for_ctr_var     << endl;
        cout<< "VAL INI:   "<<this->for_ctr_val_ini << endl;
        cout<< " "<< endl;
        cout<< "VAR:       "<<this->for_cond_var    << endl;
        cout<< "OP CONTR:  "<<this->for_cond_op     << endl;
        cout<< "VAL CONTR: "<<this->for_cond_val    << endl;  
        cout<< " "<< endl;
        cout<< "VAR INCR:  "<<this->for_incr_var    << endl;
        cout<< "OP  INCR:  "<<this->for_incr_op     << endl;
        cout<< "VAL INCR:  "<<this->for_incr_val    << endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "OPE"){
        cout<<"OPERCACAO:  "<<this->tipo_comp       <<endl;
        cout<<"TIPO OP:    "<<this->op_tipo         <<endl;
        cout<<"-- LIGACOES:   "<<endl;
        this->imprimeLigacoes();
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "CON"){
        cout<<"Constante   "<<endl;
        cout<<"TIPO:       "<<this->cons_tipo        <<endl;
        cout<<"VALOR:      "<<this->valor             <<endl;
        //cout<<"SAIDA:      "<<this->out_comp->node->class_name()   <<endl;
        cout<< "--------------------------------------------"<< endl;
    }else if(this->tipo_comp == "REF"){
        cout<<"Referencia  "<<endl;
        cout<<"TIPO:       "<<this->ref_var_tipo      <<endl;
        cout<<"Nome Ref:   "<<this->ref_var_nome      <<endl;
        cout<<"INDICE:     "<<this->ref_var_index     <<endl;
        //cout<<"SAIDA:      "<<this->out_comp->node->class_name()   <<endl;
        cout<< "--------------------------------------------"<< endl;
    }
}

void Componente::imprimeLigacoes(){
    cout<<"Entrando no metodo impr Lig"<<endl;
    list<Ligacao*>::iterator i;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        cout<< "ORIGEM:  "<< (*i)->getOrigem()->node->class_name()<<endl;
        cout<< "DESTINO: "<< (*i)->getDestino()->node->class_name()<<endl;
        cout<< "" <<endl;
    }
    cout<<"Saindo do metodo impr Lig"<<endl;
}
    
void Componente::montaComponenteRef(){
    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(this->node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(this->node);
    this->tipo_comp = "REF";
    if(nodo_ref_var != NULL){
        this->ref_var_nome = nodo_ref_var->get_symbol()->get_name().getString();
        this->ref_var_tipo  = "VAR";
    }
    if(nodo_ref_arr != NULL){
        this->ref_var_tipo  = "VET";
        string arrName  = "";
        string arrPos   = ""; 
        SgVarRefExp* fe = isSgVarRefExp( nodo_ref_arr->get_lhs_operand_i() );
        SgVarRefExp* fd = isSgVarRefExp( nodo_ref_arr->get_rhs_operand_i() );
        if ( fe != NULL &&  fd != NULL){
            arrName     = fe->get_symbol()->get_name().getString();
            arrPos      = fd->get_symbol()->get_name().getString();
            this->ref_var_nome = arrName;
            this->ref_var_index= arrPos;
        }
    }
}

void Componente::montaComponenteLoop(){
    SgForStatement* cur_for = isSgForStatement(this->node);
    this->tipo_comp = "CTD";     
    if (cur_for != NULL){
        ROSE_ASSERT(cur_for);

        this->for_ctr_var = getLoopIndexVariable(this->node)->get_name().str();
      
        /**********************************************************/
        //Parte de pegar o padrao de inicio do FOR => EX.: int i = 0 
        SgForInitStatement* stmt    = cur_for->get_for_init_stmt();

        Rose_STL_Container<SgNode*> NodosFor1 = NodeQuery::querySubTree(stmt,V_SgNode); 
        for (Rose_STL_Container<SgNode*>::iterator for1 = NodosFor1.begin(); for1 != NodosFor1.end(); for1++ ) 
        {
            SgIntVal* valIni = isSgIntVal(*for1);
            if(valIni != NULL){
                this->for_ctr_val_ini = valIni->get_value();
            }
        }               
        /**********************************************************/


        /**********************************************************/
        //Condicao de parada do FOR => EX.: i < 10
        this->for_cond_var = this->for_ctr_var;
        
        SgExpression* testExp       = cur_for->get_test_expr();
        
        Rose_STL_Container<SgNode*> NodosFor2 = NodeQuery::querySubTree(testExp,V_SgNode);
        for (Rose_STL_Container<SgNode*>::iterator for2 = NodosFor2.begin(); for2 != NodosFor2.end(); for2++ ) 
        {
            //SgNode* node = isSgNode(*for2);
            //cout<<node->class_name()<< endl;
            SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            //SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            //SgLessThanOp* opMenorQue= isSgLessThanOp(*for2);
            SgIntVal* valPar        = isSgIntVal(*for2);
            if (opMenorQue != NULL){
                //cond += " < ";
                this->for_cond_op = "<";
            }
            if (valPar != NULL){
                //std::string str = boost::lexical_cast<std::string>(valPar->get_value());
                //cond += str;
                this->for_cond_val = valPar->get_value();
            }
        }
        /**********************************************************/


        /**********************************************************/
        //Parte que identifica o incremento do FOR => EX.: i++
        this->for_incr_var = this->for_ctr_var;
        
        SgExpression* increment     = cur_for->get_increment();
        Rose_STL_Container<SgNode*> NodosFor3 = NodeQuery::querySubTree(increment,V_SgNode);
        
        for (Rose_STL_Container<SgNode*>::iterator for3 = NodosFor3.begin(); for3 != NodosFor3.end(); for3++ ) 
        {
            //SgNode* node = isSgNode(*for3);
            SgPlusPlusOp* opMaisMais    = isSgPlusPlusOp(*for3);
            SgVarRefExp*  varIncr       = isSgVarRefExp(*for3);
            if(opMaisMais != NULL){
                this->for_incr_op  = "++";
                this->for_incr_val = 1;
            }
        }
        /**********************************************************/
    }   
}

void Componente::montaComponenteConst(){
    SgIntVal* nodo_int  = isSgIntVal(this->node);
    if(nodo_int != NULL){
        this->tipo_comp = "CON";
        this->cons_tipo = "INT";
        this->valor     = nodo_int->get_valueString();
    }
}

void Componente::montaComponenteOp(){
    SgAddOp* nodo_op_add = isSgAddOp(this->node);
    if(nodo_op_add != NULL){
        this->tipo_comp = "OPE";
        this->op_tipo   = "ADD";
        //this->op_in_add1;     //Define entrada 1 da operacao ADD
        //this->op_in_add2;     //Define entrada 1 da operacao ADD
        //this->op_out_add2;    //Define saida da operacao ADD
    }
}

//Metodo Resonsavel por montar o componente de acordo com sua estrutura: VARIAVEL
void Componente::montaComponenteVar(){
    //VERIFICAR SE E VARIAVEL
    SgInitializedName* cur_var          = isSgInitializedName(this->node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(cur_var->get_parent());
    
    if (cur_var != NULL){
        varID var(isSgInitializedName(this->node));
        
        //Pegar nome
        this->nome = cur_var->get_name().getString();
        
        //Verificar se e vetor ou nao - isso vai empactar para definir hardware
        //registrador (variavel) ou memoria (vetor)
        string tipo="";
        if (var.isArrayType() == true){
            this->eVetor        = true;
            this->tipo_comp     = "MEM";
            
            //Pegar tipo do vetor
            tipo = SageInterface::getArrayElementType(cur_var->get_type())->get_mangled().str();
            
            //Tamanho do Vetor
            const vector<string> words = split(varDec->get_mangled_name().getString(), "_");
            this->qtd_ele_vet = lexical_cast<int>(string(words[7].c_str()));
        }else{
            this->eVetor = false;
            this->tipo_comp     = "REG";
            
            //Pegar tipo da variavel
            tipo = cur_var->get_type()->get_mangled().str();
        }

        //TODO - Ver como que vai ficar o esquema de tipo da variavel ou vetor
        //Identificar o tipo da variavel/vetor
        //if((tipo.compare("i")) == 1){
        if(tipo=="i"){
            this->tipo_var = "INT";
        }
        //if((tipo.compare("c")) == 1){
        if(tipo=="c"){
            this->tipo_var = "CHA";
        }
        //if((tipo.compare("f")) == 1){
        if(tipo=="f"){
            this->tipo_var = "FLO";
        }
        //if((tipo.compare("d")) == 1){
        if(tipo=="d"){
            this->tipo_var = "DOU";
        }
        
        
        /*
         * abaixo verifica a subtree apartir do nodo isSgInitializedName
         * sendo assim dentro desta sub-arvore temos todas as informacoes da
         * variavel/vetor
         */
        Rose_STL_Container<SgNode*> var2 = NodeQuery::querySubTree(cur_var,V_SgAssignInitializer);
        if(var2.size() > 0){
            this->eInicializado = true;
            //Caso for vetor, pegar a quantidade de elementos dentro do mesmo
            if(var.isArrayType()){
                this->qtd_ele_vet = var2.size();
            }else{
                this->qtd_ele_vet = 1;
            }
            
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    std::string str = boost::lexical_cast<std::string>(intVal->get_value());
                    if(var2.size() < 2){
                        this->valor = ""+str;
                    }else{
                        this->valor += ""+str+"|";
                    }
                }
            }
        }
    }   
}

vector<string> Componente::split(const string& s, const string& delim) {
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

Componente::~Componente() {
}

