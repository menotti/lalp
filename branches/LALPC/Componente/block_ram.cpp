/* 
 * File:   block_ram.cpp
 * Author: demo
 * 
 * Created on July 12, 2013, 10:02 AM
 */
#include "rose.h"
#include "block_ram.h"
#include "string"

using namespace std;


block_ram::block_ram(SgNode* node, const string &aux) : Componente(node, aux) {
    this->tipo_comp= "MEM";
    
    this->ref_address   = "";
    this->ref_clk       = "";
    this->ref_data_in   = "";
    this->ref_data_out  = "";
    this->ref_we        = "";
    
    
    SgInitializedName* cur_var          = isSgInitializedName(this->node);
    SgVariableDeclaration* varDec       =  isSgVariableDeclaration(cur_var->get_parent());
    
    if (cur_var != NULL){
        this->nome = cur_var->get_name().getString();
        //this->eVetor        = true;
        this->tipo_comp     = "MEM";
            
        //Pegar tipo do vetor
        string tipo = SageInterface::getArrayElementType(cur_var->get_type())->get_mangled().str();

        //Tamanho do Vetor
        const vector<string> words = this->SplitStr(varDec->get_mangled_name().getString(), "_");
        this->qtd_ele_vet = this->ConverteStrToInt(string(words[7].c_str()));
        
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
            this->setEInicializado(true);
            //Caso for vetor, pegar a quantidade de elementos dentro do mesmo
            this->qtd_ele_vet = var2.size();
            
            //Abaixo percorre cada posicao do vetor para pegar os valores
            for (Rose_STL_Container<SgNode*>::iterator j = var2.begin(); j != var2.end(); j++ ) 
            {
                SgAssignInitializer* nodeINI   = isSgAssignInitializer(*j);
         
                Rose_STL_Container<SgNode*> var3 = NodeQuery::querySubTree(nodeINI,V_SgIntVal);
                for (Rose_STL_Container<SgNode*>::iterator k = var3.begin(); k != var3.end(); k++ ) 
                {
                    SgIntVal* intVal = isSgIntVal(*k);
                    string str = this->ConverteIntToStr(intVal->get_value());
                    if(var2.size() < 2){
                        this->valor = ""+str;
                    }else{
                        this->valor += ""+str+"|";
                    }
                }
            }
        }        
    }
    
    string nome_comp_vhdl = "";
    if(this->getEInicializado() == true){
        nome_comp_vhdl += "block_ram_"+this->nome;
    }else{
        nome_comp_vhdl += "block_ram";
    }
    this->setNomeCompVHDL(nome_comp_vhdl);
}

block_ram::~block_ram() {
}

string block_ram::getEstruturaComponenteVHDL(){
    string res = "";
    res += "component "+this->getNomeCompVHDL()+" \n";
    res += "generic ( \n";
    res += "        data_width	: integer := 8; \n";
    res += "        address_width	: integer := 8 \n";
    res += "); \n";
    res += "port ( \n";
    res += "        clk		: in	std_logic; \n";
    res += "        we		: in	std_logic := '0'; \n";
    res += "        oe		: in	std_logic := '1'; \n";
    res += "        address		: in	std_logic_vector(address_width-1 downto 0); \n";
    res += "        data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0'); \n";
    res += "        data_out	: out	std_logic_vector(data_width-1 downto 0) \n";
    res += "); \n";
    res += "end component; \n\n";
    return res;
}

string block_ram::geraDOTComp(){
    string res = "";
    res += "\""+this->nome+"\" [shape=record, fontcolor=blue, style=\"filled\", fillcolor=\"lightgray\", label=\"{{<address>address[11]|<clk>clk|<data_in>data_in[32]|<oe>oe|<we>we}|block_ram:"+this->nome+"|{<data_out>data_out[32]}}\"]; \n";
    return res;
}

string block_ram::geraVHDLComp(){
    string res = "";

    int val_add_wid             = this->ConverteStrToInt(this->ref_address_width);
    string val_add_wid_aux      = this->ConverteIntToStr(val_add_wid-1);

    res += "\\" + this->nome + "\\: "+this->getNomeCompVHDL()+" \n";

    res += "generic map (\n";
    res += "	address_width => "+this->ref_address_width+",\n";
    res += "	data_width => "+this->ref_data_width+"\n";
    res += ")\n";
    res += "port map (\n";

    res += "	address("+val_add_wid_aux+" downto 0) => "+this->ref_address+"("+val_add_wid_aux+" downto 0)";

    if(this->ref_clk != ""){
        res += ",\n";
        res += "	clk => "+this->ref_clk;
    }
    if(this->ref_data_in != ""){
         res += ",\n";
         res += "	data_in => "+this->ref_data_in;
    }
    if(this->ref_data_out != ""){
         res += ",\n";
         res += "	data_out => "+this->ref_data_out;
    }
    if(this->ref_we != ""){
        res += ",\n";
        res += "	we => "+this->ref_we+"\n";
    }
    res += ");\n\n"; 

    return res;
}

void block_ram::finalizaPortasComp(){
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

        if(res == "address" && this->ref_address ==""){
                    this->ref_address   = (*k)->getNome();
        }
        if(res == "clk" && this->ref_clk ==""){
            this->ref_clk       = (*k)->getNome();
        }
        if(res == "data_in" && this->ref_data_in ==""){
            this->ref_data_in   = (*k)->getNome();
        }
        if(res == "data_out" && this->ref_data_out ==""){
            this->ref_data_out  = (*k)->getNome();
        }
        if(res == "we" && this->ref_we ==""){
            this->ref_we        = (*k)->getNome();
        }  
    }
}