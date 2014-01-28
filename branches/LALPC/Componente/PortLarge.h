/* 
 * File:   Port.h
 * Author: demo
 *
 * Created on July 16, 2013, 1:33 PM
 */

#ifndef PORTLARGE_H
#define	PORTLARGE_H
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <map>

#include "Port.h"
#include "../Ligacao.h"

using namespace std;

class PortLarge: public Port {
public:
    PortLarge(const string& name, const string& input, const string& type, const string& width, const string& aux);
    map<int, Ligacao*> getLigacoes();
    void        addLigacao(Ligacao* lig);
    void        setLigacao(const string&  lig);
    virtual     ~PortLarge();
private:
    map<int, Ligacao*> ligacaoMap;
    int         lastConnectedBit;
};

#endif	/* PORT_H */

