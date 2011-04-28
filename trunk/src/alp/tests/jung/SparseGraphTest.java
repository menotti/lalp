package alp.tests.jung;

import javax.swing.JFrame;

import edu.uci.ics.jung.graph.Edge;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Vertex;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
import edu.uci.ics.jung.graph.impl.SparseGraph;
import edu.uci.ics.jung.graph.impl.SparseVertex;
import edu.uci.ics.jung.visualization.FRLayout;
import edu.uci.ics.jung.visualization.PluggableRenderer;
import edu.uci.ics.jung.visualization.VisualizationViewer;

public class SparseGraphTest {

	public SparseGraphTest() {
		Graph g = new SparseGraph();
		Vertex v1 = g.addVertex(new SparseVertex());
		Vertex v2 = g.addVertex(new SparseVertex());
		Edge e1 = new DirectedSparseEdge(v1, v2);
		g.addEdge(e1 );
		g.addEdge( new DirectedSparseEdge(v1, v1));
		g.addEdge( new DirectedSparseEdge(v2, v1));
		JFrame jf = new JFrame();
        VisualizationViewer vv = new VisualizationViewer(new FRLayout((Graph)g), new PluggableRenderer());
        jf.getContentPane().add(vv);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jf.pack();
        jf.setVisible(true);
        for (Object v : v1.getSuccessors())
        	System.out.println(v);
        for (Object v : v1.getInEdges())
        	System.out.println(v);
        for (Object v : v1.getOutEdges())
        	System.out.println(v);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new SparseGraphTest();
	}

}
