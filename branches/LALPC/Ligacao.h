/* 
 * File:   Ligacao.h
 * Author: Lucas Porto
 *
 * Created on June 28, 2013, 8:51 AM
 */

#ifndef LIGACAO_H
#define	LIGACAO_H


#include <string>

using namespace std;

class Ligacao {
public:
    Ligacao(class Componente* origem, class Componente* destino,const string &nome = "");
    class       Componente* getOrigem();
    class       Componente* getDestino();
    void        editOrig(class Componente* newOrig);
    void        editDest(class Componente* newDest);   
    class Port*       getPortDestino();
    class Port*       getPortOrigem();
    void        setPortDestino(class Port* porta);
    void        setPortOrigem(class Port* porta);
    void        setWidth(const string &size);
    void        setTipo(const string &size);
    string      getWidth();
    string      getTipo();
    string      imprimeDot();
    string      getNome();
    virtual     ~Ligacao();
private:
    class       Componente* origem;
    class       Componente* destino;
    string      nome;
    string      tipo;
    string      tamBarramento;
    string      outPort;
    string      inPort;
    class Port*       portOrigem;
    class Port*       portDestino;
    //Componente* origem;
    //TODO: Pode ser que mais pra frente seja necessario novos atributos e 
    //metodos para identificar e parametrizar a ligacao
};

#endif	/* LIGACAO_H */

