/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
//#include "../header/meuHeader.h"
#include "op_sub_s.h"

op_sub_s::op_sub_s(void*node) : op_simple(node){
//    this->setDelayValComp("0");
    this->setNomeCompVHDL("sub_op_s");
    this->op_tipo       = "SUB";
    this->setSync(false);
}

op_sub_s::~op_sub_s() {
}

