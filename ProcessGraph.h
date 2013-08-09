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
    int         addVertice(const string& nome);
    void        addEdge(const string& orig, const string& dest, const string& nome = NULL);
    void        imprimeVertices();
    void        imprimeEdges();
    void        geraDot();
    virtual     ~ProcessGraph();
    void        updateVertex(const string& nome, int delay, int pos);
private:
    int         getIdVertice(const string& vert);
    bool        existeVertice(const string& vert);
    
    struct Vertex{ 
        int     id;
        string  name;
        int     delayVal;
        int     pos;
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

