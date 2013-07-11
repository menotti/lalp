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

Componente::Componente(SgNode* node/*=NULL*/, const string &aux/*=""*/){
    this->limpaAtributos();
    
    //Criacao de componentes baseados na arvore AST Rose
    if(node != NULL){
        this->node = node;
        
        if(aux == "WE"){
            //Significa que e um nodo que necessita de gravacao
            //ou seja, este esta a esquerda de uma atribuicao
            //permite setar um FLAG para criar uma ligacao para o Write Enable
            this->writeEnable = true;
        }

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
    }else{
        //Caso Contrario sao nodos inferidos
        //nodos necessarios para o funcionamento correto. EX: DELAY
        if(aux == "DLY"){
            this->montaComponenteDelay();
        }
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
    this->writeEnable   = false;

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
    
    //Delay
    this->delayVal      = 0;
}

void Componente::addLigacao(Ligacao* lig){
    this->ligacoes.push_back(lig);
}

void Componente::removeLigacao(Ligacao* lig){
    this->ligacoes.remove(lig);
}

SgNode* Componente::getPai(){
    return this->nodoPai;
}

string Componente::getStringPortOUT(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "O0";
    }
    if(this->tipo_comp == "CTD"){
        res = "output";
    }
    if(this->tipo_comp == "DLY"){
        res = "a_delayed";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "data_out";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "O0";
        }
    }
    
    return res;
}

string Componente::getStringPortOUTSize(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "32";
    }
    if(this->tipo_comp == "CTD"){
        res = "16";
    }
    if(this->tipo_comp == "DLY"){
        res = "1";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "32";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "32";
        }
    }
    return res;
}

string Componente::getStringPortIN(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "I0";
    }
    if(this->tipo_comp == "DLY"){
        res = "a";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "data_in";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "I0";
        }
    }
    return res;
}

string Componente::getStringPortINSize(){
    string res = "";
    if(this->tipo_comp == "OPE"){
        res = "32";
    }
    if(this->tipo_comp == "DLY"){
        res = "1";
    }
    if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res = "32";
        }
        if(this->ref_var_tipo == "VAR"){
                res = "32";
        }
    }
    return res;
}

string Componente::imprimeDOT(){
    string res = "";
    if(this->tipo_comp == "CTD"){
        res += "\""+this->for_ctr_var +"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<clk>clk|<clk_en>clk_en|<input>input[16]|<load>load|<reset>reset|<termination>termination[16]}|counter:"+this->for_ctr_var +"\\n\\<\\n+=1\\nsteps=1|{<done>done|<output>output[16]|<step>step}}\"]; \n";   
    }else if(this->tipo_comp == "OPE"){  
            res += "\""+this->nome+"\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|add_op_s:"+this->nome+"|{<O0>O0[32]}}\"]; \n";
            //res += "\"x_add_op_s_y\" [shape=record, fontcolor=blue, label=\"{{<I0>I0[32]|<I1>I1[32]}|add_op_s:x_add_op_s_y|{<O0>O0[32]}}\"]; \n";     
    }else if(this->tipo_comp == "CON"){
        
    }else if(this->tipo_comp == "REF"){
        if(this->ref_var_tipo == "VET"){
                res += "\""+this->ref_var_nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address[11]|<clk>clk|<data_in>data_in[32]|<oe>oe|<we>we}|block_ram:"+this->ref_var_nome+"|{<data_out>data_out[32]}}\"]; \n";
        }
        if(this->ref_var_tipo == "VAR"){
                res += "\""+this->ref_var_nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0[32]|<clk>clk|<reset>reset|<we>we}|reg_op:"+this->ref_var_nome+"|{<O0>O0[32]}}\"]; \n";
        }
    }else if(this->tipo_comp == "DLY"){
        //this->delayVal 
        res += "\""+this->nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<a>a["+this->delay_bits+"]|<clk>clk|<reset>reset}|delay_op:"+this->nome+"\\ndelay=0|{<a_delayed>a_delayed["+this->delay_bits+"]}}\"]; \n";
    }   
    return res;
}

string Componente::geraVHDLComp(){
    string res = "";
    // <editor-fold defaultstate="collapsed" desc="CONTADOR">
    if (this->tipo_comp == "CTD") {
        res += "\\" + this->nome + "\\: counter \n";
        res += "generic map ( \n";
        res += "	bits => " + this->counter_bits + ", \n";
        res += "	condition => " + this->counter_condition + ", \n";
        res += "	down => " + this->counter_down + ", \n";
        res += "	increment => " + this->counter_increment + ", \n";
        res += "	steps => " + this->counter_steps + " \n";
        res += ") \n";
        res += "port map ( \n";
        res += "	clk => " + this->counter_clk + ", \n";
        res += "	clk_en => " + this->counter_clk_en + ", \n";
        res += "	done => " + this->counter_done + ", \n";
        res += "	input => " + this->counter_input + ", \n";
        res += "	output => " + this->counter_output + ", \n";
        res += "	reset => " + this->counter_reset + ", \n";
        res += "	step => " + this->counter_step + ", \n";
        res += "	termination => " + this->counter_termination + " \n";
        res += "); \n\n";
    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="OPERCAO">
    else if (this->tipo_comp == "OPE") {
        res += "\"" + this->nome + "\" : " + this->op_tipo_comp_vhdl + " \n";
        res += "generic map ( \n";
        res += "        w_in1 => " + this->op_w_in1 + ", \n";
        res += "        w_in2 => " + this->op_w_in2 + ", \n";
        res += "        w_out => " + this->op_w_out + " \n";
        res += " ) \n";
        res += "port map ( \n";
        res += "        I0 => " + this->op_I0 + ", \n";
        res += "        I1 => " + this->op_I1 + ", \n";
        res += "        O0 => " + this->op_O0 + " \n";
        res += "); \n\n";
    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="CONDICIONAL">
    else if (this->tipo_comp == "CON") {

    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="REFERENCIA">
    else if (this->tipo_comp == "REF") {
        if (this->ref_var_tipo == "VET") {
            //res += "\"" + this->ref_var_nome + "\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address[11]|<clk>clk|<data_in>data_in[32]|<oe>oe|<we>we}|block_ram:" + this->ref_var_nome + "|{<data_out>data_out[32]}}\"]; \n";
        }
        if (this->ref_var_tipo == "VAR") {
            //res += "\"" + this->ref_var_nome + "\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<I0>I0[32]|<clk>clk|<reset>reset|<we>we}|reg_op:" + this->ref_var_nome + "|{<O0>O0[32]}}\"]; \n";
        }
    }// </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="DELAY">
    else if (this->tipo_comp == "DLY") {
        res += "\\" + this->nome + "\\: delay_op \n";
        res += "generic map ( \n";
        res += "	bits => " + this->delay_bits + ", \n";
        res += "	delay => " + this->delay_delay + " \n";
        res += ") \n";
        res += "port map ( \n";
        res += "	a => " + this->delay_a + ", \n";
        res += "	a_delayed => " + this->delay_a_delayed + ", \n";
        res += "	clk => " + this->delay_clk + ", \n";
        res += "	reset => " + this->delay_reset + " \n";
        res += "); \n\n";
    }// </editor-fold>
   
    return res;
}

bool Componente::VetorTemValorInicial(){
    return this->eInicializado;
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
        //this->imprimeLigacoes();
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

void Componente::finalizaPortasComp(){
    list<Ligacao*>::iterator k;
    //cout<<"*********************************"<<endl;
    //cout<<"*********************************"<<endl;
    //cout<<"LIGACOES"<<endl;
    //cout<<"Qtd: "<< this->ligacoes.size() <<endl;
    string res = "";
    for(k=this->ligacoes.begin(); k != this->ligacoes.end(); k++){
        //cout<< (*k)->getNome() << " :: " << (*k)->getOrigem()->getName()<<":"<< (*k)->getOrigPort() << " -> "<< (*k)->getDestino()->getName()<<":"<< (*k)->getDestPort() <<endl;
        if((*k)->getOrigem()->getName() == this->getName()){
            res = (*k)->getOrigPort();
            //cout<<"RES 1: " << res <<endl;
            //cout<<"NOME : " << (*k)->getNome() <<endl;
        }else {
            res = (*k)->getDestPort();
            //cout<<"RES 2: " << res <<endl;
            //cout<<"NOME : " << (*k)->getNome() <<endl;
        }
        
        //agora o proximo passo 'e verificar qual o componente e setar cada campo
        if(this->tipo_comp == "CTD"){
            if(res == "output" && this->counter_output == ""){
                this->counter_output    = (*k)->getNome();
            }
            if(res == "done" && this->counter_done == ""){
                this->counter_done      = (*k)->getNome();
            }
            if(res == "step" && this->counter_step == ""){
                this->counter_step      = (*k)->getNome();
            }
            if(res == "clock_en" && this->counter_clk_en == ""){
                this->counter_clk_en    = (*k)->getNome();
            }
            if(res == "clk" && this->counter_clk == ""){
                this->counter_clk       = (*k)->getNome();
            }
            if(res == "termination" && this->counter_termination == ""){
                this->counter_termination= (*k)->getNome();
            }
            if(res == "input" && this->counter_input == ""){
                this->counter_input     = (*k)->getNome();
            }
            if(res == "reset" && this->counter_reset == ""){
                this->counter_reset     = (*k)->getNome();
            }  
        }
        if(this->tipo_comp == "DLY"){
            if(res == "bits" && this->delay_bits ==""){
                this->delay_bits        = (*k)->getNome();
            }
            if(res == "delay" && this->delay_delay ==""){
                this->delay_delay       = (*k)->getNome();
            }
            if(res == "a" && this->delay_a ==""){
                    this->delay_a       = (*k)->getNome();
            }
            if(res == "a_delayed" && this->delay_a_delayed ==""){
                    this->delay_a_delayed= (*k)->getNome();
            }
            if(res == "clk" && this->delay_clk ==""){
                    this->delay_clk     = (*k)->getNome();
            }
            if(res == "reset" && this->delay_reset ==""){
                    this->delay_reset   = (*k)->getNome();
            }
        }
        if(this->tipo_comp == "OPE"){
            if(res == "I0" && this->op_I0 ==""){
                this->op_I0             = (*k)->getNome();
            }
            if(res == "I1" && this->op_I1 ==""){
                this->op_I1             = (*k)->getNome();
            }
            if(res == "O0" && this->op_O0 ==""){
                this->op_O0             = (*k)->getNome();
            }    
        }
    }
}

void Componente::imprimeLigacoes(){
    list<Ligacao*>::iterator i;
    //cout<<"QTD ELEM: "<< this->ligacoes.size() << endl;
    for(i=this->ligacoes.begin(); i != this->ligacoes.end(); i++){
        cout<< "ORIGEM:  "<< (*i)->getOrigem()->node->class_name()<<endl;
        cout<< "DESTINO: "<< (*i)->getDestino()->node->class_name()<<endl;
        cout<< "" <<endl;
    }
}
    
void Componente::montaComponenteRef(){
    SgVarRefExp* nodo_ref_var     = isSgVarRefExp(this->node);
    SgPntrArrRefExp* nodo_ref_arr = isSgPntrArrRefExp(this->node);
    this->tipo_comp = "REF";
    if(nodo_ref_var != NULL){
        this->ref_var_nome = nodo_ref_var->get_symbol()->get_name().getString();
        this->nome = this->ref_var_nome;
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
            this->nome = this->ref_var_nome;
        }
    }
}

void Componente::montaComponenteLoop(){
    SgForStatement* cur_for = isSgForStatement(this->node);
    this->tipo_comp = "CTD";     
    if (cur_for != NULL){
        
        //Info necessarias para geracao do componente VHDL
        this->counter_bits      = "16";
        this->counter_condition = "0";
        this->counter_down      = "1";
        this->counter_increment = "1";
        this->counter_steps     = "1";
        
        //port map
        this->counter_clk       = "\\clk\\";
        this->counter_clk_en    = "";
        this->counter_done      = "";
        this->counter_input     = "";
        this->counter_output    = "";
        this->counter_reset     = "\\reset\\";
        this->counter_step      = "";
        this->counter_termination= "";
        
        
        ROSE_ASSERT(cur_for);

        this->for_ctr_var = getLoopIndexVariable(this->node)->get_name().str();
        this->nome = this->for_ctr_var;
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
    this->op_tipo_comp_vhdl = ""; //add_op_s
    //generic map
    this->op_w_in1 = "32";
    this->op_w_in2 = "32";
    this->op_w_out = "32";

    //port map
    this->op_I0 = "";
    this->op_I1 = "";
    this->op_O0 = "";
    SgAddOp* nodo_op_add        = isSgAddOp(this->node);
    if(nodo_op_add != NULL){
        this->tipo_comp = "OPE";
        this->op_tipo   = "ADD";
        this->op_tipo_comp_vhdl = "op_add_s";
    }
    SgDivideOp* nodo_op_div     = isSgDivideOp(this->node);
    if(nodo_op_div != NULL){
        this->tipo_comp = "OPE";
        this->op_tipo   = "DIV";
        this->op_tipo_comp_vhdl = "op_div_s";
    }
    SgSubtractOp* nodo_op_sub   = isSgSubtractOp(this->node);
    if(nodo_op_sub != NULL){
        this->tipo_comp = "OPE";
        this->op_tipo   = "SUB";
        this->op_tipo_comp_vhdl = "op_sub_s";
    }
    SgMultiplyOp* nodo_op_mul   = isSgMultiplyOp(this->node);
    if(nodo_op_mul != NULL){
        this->tipo_comp = "OPE";
        this->op_tipo   = "MUL";
        this->op_tipo_comp_vhdl = "op_mul_s";
    }
}

string Componente::getTipoOpVHDL(){
    return this->op_tipo_comp_vhdl;
}

void Componente::montaComponenteDelay(){
        this->tipo_comp         = "DLY";
        
        this->delay_bits        = "";
	this->delay_delay       = "";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
	this->delay_a           = "";
	this->delay_a_delayed   = "";
	this->delay_clk         = "\\clk\\";
	this->delay_reset       = "\\reset\\";
}

void Componente::setName(const string &nome){
    this->nome = nome;
}

void Componente::setDelayBits(const string &bits){
    this->delay_bits = bits;
}

string Componente::getDelayBits(){
    return this->delay_bits;
}

void Componente::setDelayVal(const string &val){
    this->delay_delay = val;
}

string Componente::getDelayVal(){
    return this->delay_delay;
}

string Componente::getName(){
    return this->nome;
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

