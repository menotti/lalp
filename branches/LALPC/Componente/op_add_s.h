/* 
 * File:   op_add.h
 * Author: demo
 *
 * Created on July 11, 2013, 11:20 AM
 */

#ifndef OP_ADD_S_H
#define	OP_ADD_S_H
#include "rose.h"
#include "op_simple.h"
#include <string>

using namespace std;

class op_add_s : public op_simple {
public:
    op_add_s(SgNode* node);
    virtual ~op_add_s();
private:

};

#endif	/* OP_ADD_S_H */

