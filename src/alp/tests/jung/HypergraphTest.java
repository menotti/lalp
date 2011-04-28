package alp.tests.jung;

import javax.swing.JFrame;

import edu.uci.ics.jung.algorithms.shortestpath.DijkstraDistance;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Hyperedge;
import edu.uci.ics.jung.graph.Hypergraph;
import edu.uci.ics.jung.graph.Hypervertex;
import edu.uci.ics.jung.graph.impl.SetHyperedge;
import edu.uci.ics.jung.graph.impl.SetHypergraph;
import edu.uci.ics.jung.graph.impl.SetHypervertex;
import edu.uci.ics.jung.visualization.FRLayout;
import edu.uci.ics.jung.visualization.PluggableRenderer;
import edu.uci.ics.jung.visualization.VisualizationViewer;

public class HypergraphTest {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("Starting...");
		HypergraphTest cg = new HypergraphTest();
		JFrame jf = new JFrame();
        VisualizationViewer vv = new VisualizationViewer(new FRLayout((Graph)cg.g), new PluggableRenderer());
        jf.getContentPane().add(vv);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jf.pack();
        jf.setVisible(true);

		System.out.println("Finished!");
	}
	
	public Hypergraph g = new SetHypergraph();

	public HypergraphTest() {
		Hypervertex v1 = g.addVertex(new SetHypervertex());
		Hypervertex v2 = g.addVertex(new SetHypervertex());
		Hypervertex v3 = g.addVertex(new SetHypervertex());
		Hypervertex v4 = g.addVertex(new SetHypervertex());
		Hypervertex v5 = g.addVertex(new SetHypervertex());
		Hyperedge e1 = g.addEdge(new SetHyperedge());
		Hyperedge e2 = g.addEdge(new SetHyperedge());
		Hyperedge e3 = g.addEdge(new SetHyperedge());
		e1.connectVertex(v1);
		e1.connectVertex(v2);
		e1.connectVertex(v3);
		e1.connectVertex(v3);
		e2.connectVertex(v3);
		e2.connectVertex(v4);
		e2.connectVertex(v5);
		e3.connectVertex(v4);
		e3.connectVertex(v5);
		DijkstraDistance dd = new DijkstraDistance(g);
		System.out.println("e1.numVertices(): " + e1.numVertices());
		System.out.println("e2.numVertices(): " + e2.numVertices());
		System.out.println("e3.numVertices(): " + e3.numVertices());
		System.out.println("getDistance(v1,v2): " + dd.getDistance(v1, v2).intValue());
		System.out.println("getDistance(v1,v3): " + dd.getDistance(v1, v3).intValue());
		System.out.println("getDistance(v1,v4): " + dd.getDistance(v1, v4).intValue());
		System.out.println("getDistance(v1,v5): " + dd.getDistance(v1, v5).intValue());
		v5.disconnectEdge(e2);
		dd = new DijkstraDistance(g);
		System.out.println("getDistance(v1,v5): " + dd.getDistance(v1, v5).intValue());
	}
}
