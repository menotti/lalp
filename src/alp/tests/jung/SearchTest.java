package alp.tests.jung;

import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Vertex;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
import edu.uci.ics.jung.graph.impl.SparseGraph;
import edu.uci.ics.jung.graph.impl.SparseVertex;
import edu.uci.ics.jung.utils.UserData;

public class SearchTest {
	Graph grafo = new SparseGraph();
	Vertex a = grafo.addVertex(new SparseVertex());
	Vertex b = grafo.addVertex(new SparseVertex());
	Vertex c = grafo.addVertex(new SparseVertex());
	Vertex d = grafo.addVertex(new SparseVertex());
	Vertex e = grafo.addVertex(new SparseVertex());
	Vertex f = grafo.addVertex(new SparseVertex());
	Vertex g = grafo.addVertex(new SparseVertex());
	Vertex h = grafo.addVertex(new SparseVertex());
	Vertex i = grafo.addVertex(new SparseVertex());
	Vertex j = grafo.addVertex(new SparseVertex());
	Vertex k = grafo.addVertex(new SparseVertex());
	Vertex l = grafo.addVertex(new SparseVertex());
	public SearchTest() {
		a.addUserDatum("label", "A", UserData.SHARED);
		b.addUserDatum("label", "B", UserData.SHARED);
		c.addUserDatum("label", "C", UserData.SHARED);
		d.addUserDatum("label", "D", UserData.SHARED);
		e.addUserDatum("label", "E", UserData.SHARED);
		f.addUserDatum("label", "F", UserData.SHARED);
		g.addUserDatum("label", "G", UserData.SHARED);
		h.addUserDatum("label", "H", UserData.SHARED);
		i.addUserDatum("label", "I", UserData.SHARED);
		j.addUserDatum("label", "J", UserData.SHARED);
		k.addUserDatum("label", "K", UserData.SHARED);
		l.addUserDatum("label", "L", UserData.SHARED);
		grafo.addEdge(new DirectedSparseEdge(a, b));
		grafo.addEdge(new DirectedSparseEdge(a, c));
		grafo.addEdge(new DirectedSparseEdge(a, d));
		grafo.addEdge(new DirectedSparseEdge(b, e));
		grafo.addEdge(new DirectedSparseEdge(b, f));
		grafo.addEdge(new DirectedSparseEdge(c, g));
		grafo.addEdge(new DirectedSparseEdge(d, h));
		grafo.addEdge(new DirectedSparseEdge(d, i));
		grafo.addEdge(new DirectedSparseEdge(e, j));
		grafo.addEdge(new DirectedSparseEdge(i, k));
		grafo.addEdge(new DirectedSparseEdge(i, l));
	}
	private void BreadthFirstSearch() {
		System.out.print("BreadthFirstSearch: ");
		Queue<Vertex> fila = new LinkedList<Vertex>();
		fila.offer(a);
		while (!fila.isEmpty()) {
			Vertex v = fila.poll();
			for (Object w : v.getSuccessors())
				fila.offer((Vertex)w);
			System.out.print(v.getUserDatum("label") + " ");
		}
		System.out.println();
	}
	private void DepthFirstSearch() {
		System.out.print("DepthFirstSearch: ");
		Stack<Vertex> fila = new Stack<Vertex>();
		fila.push(a);
		while (!fila.isEmpty()) {
			Vertex v = fila.pop();
			for (Object w : v.getSuccessors())
				fila.push((Vertex)w);
			System.out.print(v.getUserDatum("label") + " ");
		}
		System.out.println();
	}
	public static void main(String[] args) {
		SearchTest st = new SearchTest();
		st.BreadthFirstSearch();
		st.DepthFirstSearch();
	}
}
