/* 
 * File:   op_add.cpp
 * Author: demo
 * 
 * Created on July 11, 2013, 11:20 AM
 */
#include "rose.h"
#include "op_sub_s.h"

op_sub_s::op_sub_s(SgNode* node) : op_simple(node){
    this->setNomeCompVHDL("op_sub_s");
    this->op_tipo       = "SUB";
}

op_sub_s::~op_sub_s() {
}

