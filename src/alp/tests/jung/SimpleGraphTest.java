package alp.tests.jung;

import javax.swing.JFrame;

import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Vertex;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
import edu.uci.ics.jung.graph.impl.DirectedSparseVertex;
import edu.uci.ics.jung.graph.impl.SparseGraph;
import edu.uci.ics.jung.graph.impl.SparseVertex;
import edu.uci.ics.jung.utils.UserData;
import edu.uci.ics.jung.visualization.FRLayout;
import edu.uci.ics.jung.visualization.PluggableRenderer;
import edu.uci.ics.jung.visualization.VisualizationViewer;

public class SimpleGraphTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("Starting...");
		SimpleGraphTest cg = new SimpleGraphTest();
		Graph g;
		JFrame jf = new JFrame();
        VisualizationViewer vv = new VisualizationViewer(new FRLayout((Graph)cg.g), new PluggableRenderer());
        jf.getContentPane().add(vv);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jf.pack();
        jf.setVisible(true);
        // testa a obten��o da string contida no vertice v1
        System.out.println("getUserDatum() from v1 vertex: " + cg.v1.getUserDatum("label"));
        // copia o grafo todo
        g = cg.copyGraph();
        cg.status();
        cg.removeVertex(cg.v1);
        cg.status();
        cg.removeVertex(cg.v5);
        cg.status();
        // cria uma nova visualiza��o para o grafo copiado, que contem todos os v�rtices originais
        jf.getContentPane().remove(vv);
        vv = new VisualizationViewer(new FRLayout(g), new PluggableRenderer());
        jf.getContentPane().add(vv);
		System.out.println("Finished!");
	}
	public Graph g; 
	public Vertex v1;

	public Vertex v5;
	
	public SimpleGraphTest() {
		String s = new String("Hello");
		g = new SparseGraph();
 		v1 = (Vertex) g.addVertex(new DirectedSparseVertex());
 		// adiciona uma string ao v�rtice
 		v1.addUserDatum("label", s, UserData.SHARED);
 		// adiciona o grafo todo ao vertice (para testar posteriormente a copia)
 		v1.addUserDatum("redundant", g, UserData.CLONE);
		Vertex v2 = (Vertex) g.addVertex(new SparseVertex());
		Vertex v3 = (Vertex) g.addVertex(new SparseVertex());
		Vertex v4 = (Vertex) g.addVertex(new SparseVertex());
		Vertex v6 = (Vertex) g.addVertex(new SparseVertex());
		v5 = (Vertex) g.addVertex(new DirectedSparseVertex());
		g.addEdge(new DirectedSparseEdge(v1, v3));
		g.addEdge(new DirectedSparseEdge(v2, v4));
		g.addEdge(new DirectedSparseEdge(v2, v5));
		g.addEdge(new DirectedSparseEdge(v3, v5));
		g.addEdge(new DirectedSparseEdge(v3, v6));
		g.addEdge(new DirectedSparseEdge(v1, v1));
		g.addEdge(new DirectedSparseEdge(v1, v3));
		g.addEdge(new DirectedSparseEdge(v2, v4));
		g.addEdge(new DirectedSparseEdge(v2, v5));
		g.addEdge(new DirectedSparseEdge(v3, v5));
		g.addEdge(new DirectedSparseEdge(v3, v6));
		g.addEdge(new DirectedSparseEdge(v1, v1));
		g.addEdge(new DirectedSparseEdge(v1, v3));
		g.addEdge(new DirectedSparseEdge(v2, v4));
		g.addEdge(new DirectedSparseEdge(v2, v5));
		g.addEdge(new DirectedSparseEdge(v3, v5));
		g.addEdge(new DirectedSparseEdge(v3, v6));
		g.addEdge(new DirectedSparseEdge(v1, v1));
		g.addEdge(new DirectedSparseEdge(v1, v3));
		g.addEdge(new DirectedSparseEdge(v2, v4));
		g.addEdge(new DirectedSparseEdge(v2, v5));
		g.addEdge(new DirectedSparseEdge(v3, v5));
		g.addEdge(new DirectedSparseEdge(v3, v6));
		g.addEdge(new DirectedSparseEdge(v1, v1));
	}
	
	public Graph copyGraph() {
		return (Graph) this.g.copy();
	}
	
	public void removeVertex(Vertex v) {
		removeVertex(v, 3000);
	}
	
	public void removeVertex(Vertex v, long t) {
		System.out.println("Removing Vertex...");
		try {
			Thread.sleep(t);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		g.removeVertex(v);
	}
	
	public void status() {
		System.out.println("numVertices(): " + g.numVertices());
		System.out.println("numEdges(): " + g.numEdges());
		System.gc();
		System.out.println("Used Memory (estimated): " + (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()));
	}
}
