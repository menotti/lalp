/* 
 * File:   FuncoesAux.cpp
 * Author: demo
 * 
 * Created on July 13, 2013, 2:39 PM
 */
#include "../header/meuHeader.h"
#include "FuncoesAux.h"
#include <stdio.h>
#include <cstdlib>
#include <sstream>
#include <stdlib.h>
#include <string>
#include <vector>
#include <bitset>

using namespace std;
using boost::lexical_cast;

FuncoesAux::FuncoesAux() {
}

int FuncoesAux::StrToInt(const string& val){
//    cout<<"StrToInt:" << val <<endl;
    int res = 0;
    res = lexical_cast<int>(val);
    return(res);
}
string FuncoesAux::IntToStr(int val){
//    cout<<"IntToStr:" << val <<endl;
    string res = "0";
    res = lexical_cast<string>(val);
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

string FuncoesAux::LPad(const string &val, int size){
    string res ="";
    string res2 ="";
    while((val.size() + res.size()) < size){
        res.push_back('0');
    }
    res2 = string(res.c_str())+val;
    return res2;
}

string FuncoesAux::ConvertDecToBin(const string &val){
    int dec = FuncoesAux::StrToInt(val);
    bitset<32> binaryNumber;     
    binaryNumber = dec;
    /*
     * As duas funcoes estao funfando
    int i = dec; //my value
    std::string result;
    for (int bit = 0; bit < sizeof(int)*8; ++bit)
    {
       int bit_val = 1 & i;
       result = (bit_val ? "1" : "0") + result;
       i = i >> 1;
    }
     return result;
     */
    
    return binaryNumber.to_string();
}


FuncoesAux::~FuncoesAux() {
}



