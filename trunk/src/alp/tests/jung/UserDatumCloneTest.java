package alp.tests.jung;

import edu.uci.ics.jung.graph.Edge;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Vertex;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
import edu.uci.ics.jung.graph.impl.SparseGraph;
import edu.uci.ics.jung.graph.impl.SparseVertex;
import edu.uci.ics.jung.utils.UserData;

public class UserDatumCloneTest {

	public static void main(String[] args) {
		Graph g = new SparseGraph();
		Vertex v1 = g.addVertex(new SparseVertex());
		Vertex v2 = g.addVertex(new SparseVertex());
		Edge e1 = new DirectedSparseEdge(v1, v2);
		g.addEdge(e1 );
		g.addEdge(new DirectedSparseEdge(v1, v2));
		v1.addUserDatum("integer0", new Integer(0), UserData.REMOVE);
		v1.addUserDatum("integer1", new Integer(1), UserData.SHARED);
		Graph gt = new SparseGraph();
		Vertex v1t = (Vertex)v1.copy(gt);
		System.out.println(v1t.getUserDatum("integer0"));
		System.out.println(v1t.getUserDatum("integer1"));
		v1.setUserDatum("integer1", new Integer(2), UserData.SHARED);
		System.out.println(v1t.getUserDatum("integer1"));
		System.out.println(v1.getUserDatum("integer1"));
	}
}
