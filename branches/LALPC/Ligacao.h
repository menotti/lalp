/* 
 * File:   Ligacao.h
 * Author: Lucas Porto
 *
 * Created on June 28, 2013, 8:51 AM
 */

#ifndef LIGACAO_H
#define	LIGACAO_H

//#include "Componente.h"

class Ligacao {
public:
    Ligacao(class Componente* origem, class Componente* destino);
    class Componente* getOrigem();
    class Componente* getDestino();
    virtual ~Ligacao();
private:
    class Componente* origem;
    class Componente* destino;
    //Componente* origem;
    //TODO: Pode ser que mais pra frente seja necessario novos atributos e 
    //metodos para identificar e parametrizar a ligacao
};

#endif	/* LIGACAO_H */

