/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
//#include "../header/meuHeader.h"
#include "op_mult_s.h"

op_mult_s::op_mult_s(void*node, int dataWidth) : op_simple(node, dataWidth){
    this->setNomeCompVHDL("mult_op_s");
    this->op_tipo       = "MUL";
    this->setSync(false);
    this->dataWidth     = dataWidth;
}

op_mult_s::~op_mult_s() {
}

