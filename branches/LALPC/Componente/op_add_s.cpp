/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
//#include "../header/meuHeader.h"
#include "op_add_s.h"

op_add_s::op_add_s(void*node, int dataWidth) : op_simple(node){
    this->setNomeCompVHDL("add_op_s");
    this->op_tipo       = "ADD";
    this->setSync(false);
    this->dataWidth     = dataWidth;
}

op_add_s::~op_add_s() {
}
