/* 
 * File:   op_add.h
 * Author: demo
 *
 * Created on July 11, 2013, 11:20 AM
 */

#ifndef OP_MULT_S_H
#define	OP_MULT_S_H
#include "op_simple.h"
#include <string>

using namespace std;

class op_mult_s : public op_simple {
public:
    op_mult_s(void*node, int dataWidth = 32 );
    virtual ~op_mult_s();
private:

};

#endif	/* OP_MULT_S_H */

