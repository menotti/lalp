/* 
 * File:   FuncoesAux.h
 * Author: demo
 *
 * Created on July 13, 2013, 2:39 PM
 */

#ifndef FUNCOESAUX_H
#define	FUNCOESAUX_H
#include <string>
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
using namespace std;
using std::string;
using std::vector;

class FuncoesAux {
public:
    FuncoesAux();
    virtual ~FuncoesAux();
    static vector<string> split(const string& s, const string& delim);
    static int StrToInt(const string& val);
    static string IntToStr(int val);
private:

};

#endif	/* FUNCOESAUX_H */
