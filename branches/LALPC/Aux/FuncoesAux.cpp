/* 
 * File:   FuncoesAux.cpp
 * Author: demo
 * 
 * Created on July 13, 2013, 2:39 PM
 */

#include "FuncoesAux.h"
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <string>
#include <boost/lexical_cast.hpp>
#include "variables.h"

using namespace std;
using namespace boost;
using std::stringstream;
using boost::lexical_cast;
using std::string;
using std::vector;

FuncoesAux::FuncoesAux() {
}

int FuncoesAux::StrToInt(const string& val){
    int res = lexical_cast<int>(val);
    return(res);
}
string FuncoesAux::IntToStr(int val){
    string res = lexical_cast<string>(val);
    return(res);
}

vector<string> FuncoesAux::split(const string& s, const string& delim) {
    vector<string> result;
    if (delim.empty()) {
        result.push_back(s);
        return result;
    }
    string::const_iterator substart = s.begin(), subend;
    while (true) {
        subend = search(substart, s.end(), delim.begin(), delim.end());
        string temp(substart, subend);
        if (!temp.empty()) {
            result.push_back(temp);
        }
        if (subend == s.end()) {
            break;
        }
        substart = subend + delim.size();
    }
    return result;
}

FuncoesAux::~FuncoesAux() {
}



