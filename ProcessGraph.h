/* 
 * File:   ProcessGraph.h
 * Author: demo
 *
 * Created on August 6, 2013, 1:13 PM
 */

#ifndef PROCESSGRAPH_H
#define	PROCESSGRAPH_H
#include "header/headerGraph.h"
#include <map>

using namespace std;
using namespace boost;

class ProcessGraph {
public:
    ProcessGraph();
    ProcessGraph(const ProcessGraph& orig);
    int         addVertice(void* vert);
    void        addEdge(void* orig, void* dest, const string& nome = "");
    void        imprimeVertices();
    void        imprimeEdges();
    void        imprimeEdgesAdj();
    void        imprimeEdgesInc();
    void        imprimeTeste();
    void        geraDot();
    virtual     ~ProcessGraph();
    void        updateVertex(void* vert, int delay, int pos);
    bool        isParent(void * origem, void* destino);
private:
    int         getIdVertice(void* vert);
    bool        existeVertice(void* vert);
    
    struct Vertex{ 
        int     id;
        void*   nodo;
        int     delayVal;
        int     pos;
        bool    isVisited;
    };
    struct Edge{
        string name;
    };
    typedef     adjacency_list<vecS, vecS, bidirectionalS, Vertex, Edge> Graph;

    Graph       graph;
    map<void*, int> vertMap;
};

#endif	/* PROCESSGRAPH_H */

