/* 
 * File:   Port.h
 * Author: demo
 *
 * Created on July 16, 2013, 1:33 PM
 */

#ifndef PORT_H
#define	PORT_H
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
//#include "../Ligacao.h"

using namespace std;

class Port {
public:
    Port(const string& name, const string& input, const string& type, const string& width, const string& aux);
    string      getName();
    string      getType();
    string      getInput();
    string      getWidth();
    string      getAux();
//    Ligacao*    getLigacao();
    string      getLigacao();
//    void        setLigacao(Ligacao* lig);
    void        setLigacao(const string&  lig);
    void        setWidth(const string&  width);
    virtual     ~Port();
private:
//    Ligacao*    ligacao;
    string      ligacao;
    string      name;
    string      type;
    string      input;
    string      width;
    string      aux;
};

#endif	/* PORT_H */

