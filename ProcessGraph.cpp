/* 
 * File:   ProcessGraph.cpp
 * Author: demo
 * 
 * Created on August 6, 2013, 1:13 PM
 */
#include "header/headerGraph.h"
#include "ProcessGraph.h"
#include <iostream>
#include <fstream>
using namespace std;
using namespace boost;
ProcessGraph::ProcessGraph() {
}

ProcessGraph::ProcessGraph(const ProcessGraph& orig) {
}

bool ProcessGraph::existeVertice(const string& vert){
    return this->vertMap.find(vert) != this->vertMap.end();
}

int ProcessGraph::getIdVertice(const string& vert){
    return this->vertMap.find(vert)->second;
}

int ProcessGraph::addVertice(const string& nome){
    int size = this->vertMap.size();
    this->vertMap.insert(make_pair(nome, size));
    //A ideia é utilizar o ID do MAP igual ao ID do Grafo
    //e o ID do vertice
    Graph::vertex_descriptor v  = boost::add_vertex(this->graph);
    this->graph[v].id           = size;
    this->graph[v].name         = nome;
    
    return size;
}

void ProcessGraph::imprimeEdgesAdj(){
    cout<<"*******************************************"<<endl;
    cout<<"Arestas Adj"<<endl;
    cout<<"*******************************************"<<endl;
    for ( int v = 0; v  < num_vertices(this->graph) ; v++){
        cout<<"Vertice: "<< this->graph[v].name <<endl;
        graph_traits < Graph >::out_edge_iterator ei, ei_end;
        for (boost::tie(ei, ei_end) = out_edges(v, this->graph); ei != ei_end; ++ei) {
            graph_traits < Graph >::edge_descriptor e = *ei;
            graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);

            cout<< this->graph[e].name << ": ["<<this->graph[u].name<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].name<<"]\n";
        }
        cout<<""<<endl;
    }
    cout<<"*******************************************"<<endl;
}

void ProcessGraph::imprimeEdgesInc(){
     cout<<"*******************************************"<<endl;
    cout<<"Arestas Inc"<<endl;
    cout<<"*******************************************"<<endl;
    for ( int v = 0; v  < num_vertices(this->graph) ; v++){
        cout<<"Vertice: "<< this->graph[v].name <<endl;
        graph_traits < Graph >::in_edge_iterator ei, ei_end;
        for (boost::tie(ei, ei_end) = in_edges(v, this->graph); ei != ei_end; ++ei) {
            graph_traits < Graph >::edge_descriptor e = *ei;
            graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
            
            cout<< this->graph[e].name << ": ["<<this->graph[u].name<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].name<<"]\n";
        }
        cout<<""<<endl;
    }
    cout<<"*******************************************"<<endl;
}

void ProcessGraph::imprimeEdges(){
    graph_traits < Graph >::edge_iterator ei, ei_end;
    for (boost::tie(ei, ei_end) = edges(this->graph); ei != ei_end; ++ei) {
        graph_traits < Graph >::edge_descriptor e = *ei;
        graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
//        cout << this->graph[e].name << "\n";
        cout<< this->graph[e].name << ": ["<<this->graph[u].name<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].name<<"]\n";
    }
}

void ProcessGraph::updateVertex(const string& nome, int delay, int pos){
    if(existeVertice(nome)){
        int id = getIdVertice(nome);
        graph[id].delayVal   = delay;
        graph[id].pos        = pos;
        graph[id].isVisited  = false;
    }
}

void ProcessGraph::imprimeVertices(){
    typedef boost::graph_traits<Graph>::vertex_iterator VItr;
    VItr vitr, vend;
    //int qtd = num_vertices(this->graph);
    boost::tie( vitr, vend) = boost::vertices(this->graph);

    for ( int i = 0; i  < num_vertices(this->graph) ; i++){
        std::cout << this->graph[i].id <<" - "<< this->graph[i].name << "\n";
    }
}

void ProcessGraph::geraDot(){
    //typedef adjacency_list<vecS, vecS, directedS> Graph;
    ofstream dot("DOT/graphBoost.dot");
    write_graphviz(dot, this->graph);
    std::ofstream dot_file("DOT/graphBoost2.dot");

    dot_file<< "digraph D {\n"
            << "  rankdir=LR\n"
            << "  size=\"4,3\"\n"
            << "  ratio=\"fill\"\n"
            << "  edge[style=\"bold\"]\n" << "  node[shape=\"circle\"]\n";

    graph_traits < Graph >::edge_iterator ei, ei_end;
    for (boost::tie(ei, ei_end) = edges(this->graph); ei != ei_end; ++ei) {
        graph_traits < Graph >::edge_descriptor e = *ei;
        graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
        dot_file << this->graph[u].name<< this->graph[u].pos << " -> " << this->graph[v].name<<this->graph[v].pos<< "[label=\"\"";
        dot_file << ", color=\"black\"";
        dot_file << "]\n";
    }
    dot_file << "}";
}

void ProcessGraph::addEdge(const string& orig, const string& dest, const string& nome /*= NULL*/){
    int vertOrig;
    int vertDest;
    if(!existeVertice(orig)){
        vertOrig = addVertice(orig);
    }else{
        vertOrig = getIdVertice(orig);
    }
    if(!existeVertice(dest)){
        vertDest = addVertice(dest);
    }else{
        vertDest = getIdVertice(dest);
    }
    Edge e;
    e.name = nome;
    boost::add_edge(vertOrig, vertDest, e,this->graph);
    
}

ProcessGraph::~ProcessGraph() {
}

void ProcessGraph::imprimeTeste(){
    if (is_adjacent(this->graph, 4, 1)){
        cout<< "Is Adjacent 4 -> 1" << endl;
    }
    if (!is_adjacent(this->graph, 4, 0)){
        cout<< "Not is Adjacent 4 -> 0" << endl;
    }
    
}