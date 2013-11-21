/* 
 * File:   op_add.h
 * Author: demo
 *
 * Created on July 11, 2013, 11:20 AM
 */

#ifndef OP_SUB_S_H
#define	OP_SUB_S_H
#include "op_simple.h"
#include <string>

using namespace std;

class op_sub_s : public op_simple {
public:
    op_sub_s(void* node);
    virtual ~op_sub_s();
private:

};

#endif	/* OP_ADD_S_H */

