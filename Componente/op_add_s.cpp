/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
#include "rose.h"
#include "op_add_s.h"

op_add_s::op_add_s(SgNode* node) : op_simple(node){
    this->setNomeCompVHDL("op_add_s");
    this->tipo_comp     = "OPE";
}

op_add_s::~op_add_s() {
}
