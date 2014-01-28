/* 
 * File:   CompType.h
 * Author: demo
 *
 * Created on July 15, 2013, 8:05 PM
 */

#ifndef COMPTYPE_H
#define	COMPTYPE_H

class CompType {
public:
    enum TIPO_COMP {REG,MEM,CTD,OPE,DLY,REF,AUX,CND,MUX,DEL};
    CompType();
    virtual ~CompType();
private:

};

#endif	/* COMPTYPE_H */

