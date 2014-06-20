/* 
 * File:   analisaMem.h
 * Author: demo
 *
 * Created on January 17, 2014, 9:28 AM
 */

#ifndef ANALISAIF_H
#define	ANALISAIF_H
#include "../Design.h"
#include "../Componente/Componente.h"
#include "../Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;

class analisaIf {
public:
    analisaIf(Design* design);
    virtual ~analisaIf();
    void        buscaIfs();
    void        ligaExpInternoIf(Componente* comp);
    Design*     getDesign();
    
private:
    void                criaLigIfParaPortaWE(Componente* comp);
    bool                verificaCompAntesIf(Componente* compIf,Componente* compAtual);
    bool                verificaCompExisteBodyTrueEFalse(Componente* compIf,Componente* compAtual, bool corpo, bool isWE);
    void                analiseProcessoCriaMux(Componente* compIf);
    void                criaComponenteMux(Componente* compIf, Componente* compAtual);
    void                finalizaDependenciaMux(Componente* compIf);
    void                conectaCompIfSemMux(Componente* compIf);
    Componente*         getCompAntesIf(Componente* compIf, const string& linhaParal);
    bool                verificaCompPrecisaMux(Componente* compIf, Componente* compAtual);
    Design*             design;
    bool                debug;
};

#endif	/* ANALISAMEM_H */

