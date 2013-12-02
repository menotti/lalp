/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
//#include "../header/meuHeader.h"
#include "op_div_s.h"

op_div_s::op_div_s(void*node) : op_simple(node){
    this->setNomeCompVHDL("div_op_s");
    this->op_tipo       = "DIV";
    this->setSync(false);
}

op_div_s::~op_div_s() {
}

