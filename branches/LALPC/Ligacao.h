/* 
 * File:   Ligacao.h
 * Author: Lucas Porto
 *
 * Created on June 28, 2013, 8:51 AM
 */

#ifndef LIGACAO_H
#define	LIGACAO_H

//#include "Componente.h"
#include <string>

using namespace std;

class Ligacao {
public:
    Ligacao(class Componente* origem, class Componente* destino,const string &nome = "");
    class       Componente* getOrigem();
    class       Componente* getDestino();
    void        editOrig(class Componente* newOrig);
    void        editDest(class Componente* newDest);
    void        setDestPort(const string &porta);
    void        setOrigPort(const string &porta);
    void        setSize(const string &size);
    string      getSize();
    string      getDestPort();
    string      getOrigPort();
    string      imprimeDot();
    string      getNome();
    virtual     ~Ligacao();
private:
    class       Componente* origem;
    class       Componente* destino;
    string      nome;
    string      tamBarramento;
    string      outPort;
    string      inPort;
    //Componente* origem;
    //TODO: Pode ser que mais pra frente seja necessario novos atributos e 
    //metodos para identificar e parametrizar a ligacao
};

#endif	/* LIGACAO_H */

