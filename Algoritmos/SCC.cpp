/* 
 * File:   ProcessGraph.cpp
 * Author: demo
 * 
 * Created on August 6, 2013, 1:13 PM
 */
#include "../header/headerGraph.h"
#include "SCC.h"
#include <iostream>
#include <fstream>
using namespace std;
using namespace boost;
SCC::SCC() {
}

bool SCC::existeVertice(const string& vert){
    return this->vertMap.find(vert) != this->vertMap.end();
}

int SCC::getIdVertice(const string& vert){
    return this->vertMap.find(vert)->second;
}

int SCC::addVertice(const string& nodo){
    int size = this->vertMap.size();
    this->vertMap.insert(make_pair(nodo, size));
    //A ideia é utilizar o ID do MAP igual ao ID do Grafo
    //e o ID do vertice
    Graph::vertex_descriptor v  = boost::add_vertex(this->graph);
   
    this->graph[v].id           = size;
    this->graph[v].nodo         = nodo;
    
    return size;
}

void SCC::imprimeEdgesAdj(){
    cout<<"*******************************************"<<endl;
    cout<<"Arestas Adj"<<endl;
    cout<<"*******************************************"<<endl;
    for ( int v = 0; v  < num_vertices(this->graph) ; v++){
        cout<<"Vertice: "<< this->graph[v].nodo <<endl;
        graph_traits < Graph >::out_edge_iterator ei, ei_end;
        for (boost::tie(ei, ei_end) = out_edges(v, this->graph); ei != ei_end; ++ei) {
            graph_traits < Graph >::edge_descriptor e = *ei;
            graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);

            cout<< this->graph[e].name << ": ["<<this->graph[u].nodo<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].nodo<<"]\n";
        }
        cout<<""<<endl;
    }
    cout<<"*******************************************"<<endl;
}
int SCC::getSCC(){
//     const char* name = "abcdefgh";
//     /*
//      
//      * a 0
//      * b 1
//      * c 2
//      * d 3
//      * e 4
//      * f 5 
//      * g 6 
//      * h 7
//      */
//  GraphvizDigraph G;
////  read_graphviz("scc.dot", G);
//  
//  boost::add_edge(0,1, G);
//  boost::add_edge(1,4, G);
//  boost::add_edge(1,5, G);
//  boost::add_edge(1,2, G);
//  boost::add_edge(2,3, G);
//  boost::add_edge(2,5, G);
//  boost::add_edge(3,2, G);
//  boost::add_edge(3,7, G);
//  boost::add_edge(4,0, G);
//  boost::add_edge(4,5, G);
//  boost::add_edge(5,6, G);
//  boost::add_edge(6,5, G);
//  boost::add_edge(6,7, G);
//  boost::add_edge(7,7, G);
//
//  std::cout << "A directed graph:" << std::endl;
//  print_graph(G, name);
//  std::cout << std::endl;
//
//  //vector<int> teste = {1,1,2};
//  int teste[] = {1,12,1,1,1,1,1,1};
//  std::vector<int> c(8);
  
  typedef graph_traits<GraphvizGraph>::vertex_descriptor Vertex;
    
  std::vector<int> component(num_vertices(this->graph)), discover_time(num_vertices(this->graph));
  std::vector<default_color_type> color(num_vertices(this->graph));
  std::vector<Vertex> root(num_vertices(this->graph));
  int num = strong_components(this->graph, &component[0], 
                              root_map(&root[0]).
                              color_map(&color[0]).
                              discover_time_map(&discover_time[0]));
//  int num = strong_components(G, make_iterator_property_map(c.begin(), get(vertex_index, G), c[0]));
//  int num = strong_components(G, make_iterator_property_map(c.begin(), get(vertex_index, G), c[0]));
    
  std::cout << "Total number of components: " << num << std::endl;
  std::vector<int>::size_type i;
  for (i = 0; i != component.size(); ++i)
//    std::cout << "Vertex '" << this->graph[i].name
    std::cout << "Vertex '"      <<"' is in component " << component[i] << std::endl;
    

    return num;
}
void SCC::imprimeEdgesInc(){
     cout<<"*******************************************"<<endl;
    cout<<"Arestas Inc"<<endl;
    cout<<"*******************************************"<<endl;
//    for ( int v = 0; v  < num_vertices(this->graph) ; v++){
//        cout<<"Vertice: "<< this->graph[v].nodo <<endl;
//        graph_traits < Graph >::in_edge_iterator ei, ei_end;
//        for (boost::tie(ei, ei_end) = in_edges(v, this->graph); ei != ei_end; ++ei) {
//            graph_traits < Graph >::edge_descriptor e = *ei;
//            graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
//            
//            cout<< this->graph[e].name << ": ["<<this->graph[u].nodo<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].nodo<<"]\n";
//        }
//        cout<<""<<endl;
//    }
    cout<<"*******************************************"<<endl;
}

void SCC::imprimeEdges(){
    graph_traits < Graph >::edge_iterator ei, ei_end;
    for (boost::tie(ei, ei_end) = edges(this->graph); ei != ei_end; ++ei) {
        graph_traits < Graph >::edge_descriptor e = *ei;
        graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
//        cout << this->graph[e].name << "\n";
        cout<< this->graph[e].name << ": ["<<this->graph[u].nodo<<"]"<<"("<<u<<")"<<" -> "<<"("<<v<<")"<<"["<<this->graph[v].nodo<<"]\n";
    }
}

void SCC::updateVertex(const string& nodo, int delay, int pos){
    if(existeVertice(nodo)){
        int id = getIdVertice(nodo);
        graph[id].delayVal   = delay;
        graph[id].isVisited  = false;
    }
}

void SCC::imprimeVertices(){
    typedef boost::graph_traits<Graph>::vertex_iterator VItr;
    VItr vitr, vend;
    //int qtd = num_vertices(this->graph);
    boost::tie( vitr, vend) = boost::vertices(this->graph);

    for ( int i = 0; i  < num_vertices(this->graph) ; i++){
        std::cout << this->graph[i].id <<" - "<< this->graph[i].nodo << "\n";
    }
}

void SCC::geraDot(){
    //typedef adjacency_list<vecS, vecS, directedS> Graph;
    ofstream dot("DOT/graphBoost.dot");
    write_graphviz(dot, this->graph);
//    std::ofstream dot_file("DOT/graphBoost2.dot");
//
//    dot_file<< "digraph D {\n"
//            << "  rankdir=LR\n"
//            << "  size=\"4,3\"\n"
//            << "  ratio=\"fill\"\n"
//            << "  edge[style=\"bold\"]\n" << "  node[shape=\"circle\"]\n";
//
//    graph_traits < Graph >::edge_iterator ei, ei_end;
//    for (boost::tie(ei, ei_end) = edges(this->graph); ei != ei_end; ++ei) {
//        graph_traits < Graph >::edge_descriptor e = *ei;
//        graph_traits < Graph >::vertex_descriptor u = source(e, this->graph), v = target(e, this->graph);
//        dot_file << this->graph[u].nodo<< this->graph[u].pos << " -> " << this->graph[v].nodo<<this->graph[v].pos<< "[label=\"\"";
//        dot_file << ", color=\"black\"";
//        dot_file << "]\n";
//    }
//    dot_file << "}";
}

void SCC::addEdge(const string& orig, const string& dest, const string& nome /*= NULL*/){
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

SCC::~SCC() {
}

bool SCC::isParent(const string& origem, const string& destino) {
    bool isParent = false;
    if(existeVertice(origem) && existeVertice(destino)){
        int idV1  = getIdVertice(origem);
        int idV2 = getIdVertice(destino);
        isParent = boost::is_adjacent(this->graph, idV1, idV2);   
    }
    return(isParent);
}

void SCC::imprimeTeste(){
    if (is_adjacent(this->graph, 4, 1)){
        cout<< "Is Adjacent 4 -> 1" << endl;
    }
    if (!is_adjacent(this->graph, 4, 0)){
        cout<< "Not is Adjacent 4 -> 0" << endl;
    }
    
}