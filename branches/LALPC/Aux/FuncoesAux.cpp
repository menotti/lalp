/* 
 * File:   FuncoesAux.cpp
 * Author: demo
 * 
 * Created on July 13, 2013, 2:39 PM
 */
#include "../header/meuHeader.h"
#include "FuncoesAux.h"
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <string>
#include <vector>
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
    int rem,i=1,sum=0;
    do
    {
        rem=dec%2;
        sum=sum + (i*rem);
        dec=dec/2;
        i=i*10;
    }while(dec>0);
    string res = FuncoesAux::IntToStr(sum);
    return res;
}



FuncoesAux::~FuncoesAux() {
}



