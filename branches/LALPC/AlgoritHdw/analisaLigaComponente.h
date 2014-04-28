/* 
 * File:   analisaLigaComponente.h
 * Author: demo
 *
 * Created on March 13, 2014, 3:00 PM
 */

#ifndef ANALISALIGACOMPONENTE_H
#define	ANALISALIGACOMPONENTE_H

#include "../Design.h"
#include "../Componente/Componente.h"
#include "../Ligacao.h"
#include <string>
#include <stdio.h>
#include <sstream>
#include <stdlib.h>
#include <list>

using namespace std;

class analisaLigaComponente {
public:
    analisaLigaComponente(Design* design);
    void        ligaComponentes(Componente* comp);
    Design*     getDesign();
    void        setDesign(Design* design);
    virtual ~analisaLigaComponente();
private:
    Componente*         bustaCompNaoWEnaMesmaLinha(Componente* comp);
    void                listaComponentes();
    Design*             design;
    bool                debug;

};

#endif	/* ANALISALIGACOMPONENTE_H */

