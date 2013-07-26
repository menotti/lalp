/* 
 * File:   GenericMap.h
 * Author: demo
 *
 * Created on July 23, 2013, 6:18 PM
 */

#ifndef GENERICMAP_H
#define	GENERICMAP_H
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
using namespace std;

class GenericMap {
public:
    GenericMap(const string& name, const string& tipo, const string& valor);
    string      getNome();
    string      getTipo();
    string      getValor();
    void        setNome( const string& valor);
    void        setTipo( const string& valor);
    void        setValor( const string& valor);
    virtual ~GenericMap();
private:
    string      tipo;
    string      nome;
    string      valor;
};

#endif	/* GENERICMAP_H */

