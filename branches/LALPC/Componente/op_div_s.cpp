/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
//#include "../header/meuHeader.h"
#include "op_div_s.h"

op_div_s::op_div_s(void*node, int dataWidth) : op_simple(node, dataWidth){
    this->setNomeCompVHDL("div_op_s");
    this->op_tipo       = "DIV";
    this->setSync(false);
    this->dataWidth     = dataWidth;
}

op_div_s::~op_div_s() {
}

