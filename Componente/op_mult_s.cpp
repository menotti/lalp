/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
#include "../header/meuHeader.h"
#include "op_mult_s.h"

op_mult_s::op_mult_s(SgNode* node) : op_simple(node){
    this->setDelayValComp("0");
    this->setNomeCompVHDL("mult_op_s");
    this->op_tipo       = "MUL";
    this->setSync(false);
}

op_mult_s::~op_mult_s() {
}
