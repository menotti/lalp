/* 
 * File:   ProcessGraph.h
 * Author: demo
 *
 * Created on August 6, 2013, 1:13 PM
 */

#ifndef SCC_H
#define	SCC_H
#include "../header/headerGraph.h"
#include <map>

using namespace std;
using namespace boost;

class SCC {
public:
    SCC();
    int         addVertice(const string& vert);
    void        addEdge(const string& orig, const string& dest, const string& nome = "");
    void        imprimeVertices();
    void        imprimeEdges();
    void        imprimeEdgesAdj();
    void        imprimeEdgesInc();
    void        imprimeTeste();
    void        geraDot();
    int         getSCC();
    virtual     ~SCC();
    void        updateVertex(const string& vert, int delay, int pos);
    bool        isParent(const string& origem, const string& destino);
private:
    int         getIdVertice(const string& vert);
    bool        existeVertice(const string& vert);
    
    struct Vertex{ 
        int     id;
        string  nodo;
        int     delayVal;
        bool    isVisited;
    };
    struct Edge{
        string name;
    };
    typedef     adjacency_list<vecS, vecS, directedS, Vertex, Edge> Graph;

    Graph       graph;
    map<string, int> vertMap;
};

#endif	/* PROCESSGRAPH_H */

