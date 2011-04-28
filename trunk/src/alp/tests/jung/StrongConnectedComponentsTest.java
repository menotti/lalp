package alp.tests.jung;

import alp.algorithms.StrongConnectedComponents;
import alp.components.reg_op;
import alp.core.Design;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;

public class StrongConnectedComponentsTest {
	public StrongConnectedComponentsTest() {
		Design design = new Design();
		reg_op a = (reg_op)design.addVertex(new reg_op("a"));
		reg_op b = (reg_op)design.addVertex(new reg_op("b"));
		reg_op c = (reg_op)design.addVertex(new reg_op("c"));
		reg_op d = (reg_op)design.addVertex(new reg_op("d"));
		reg_op e = (reg_op)design.addVertex(new reg_op("e"));
		reg_op f = (reg_op)design.addVertex(new reg_op("f"));
		reg_op g = (reg_op)design.addVertex(new reg_op("g"));
		reg_op h = (reg_op)design.addVertex(new reg_op("h"));
//		reg_op a = (reg_op)design.addVertex(new reg_op("a"));
		design.addEdge(new DirectedSparseEdge(a, b));
		design.addEdge(new DirectedSparseEdge(b, c));
		design.addEdge(new DirectedSparseEdge(b, e));
		design.addEdge(new DirectedSparseEdge(b, f));
		design.addEdge(new DirectedSparseEdge(c, d));
		design.addEdge(new DirectedSparseEdge(c, g));
		design.addEdge(new DirectedSparseEdge(d, c));
		design.addEdge(new DirectedSparseEdge(d, h));
		design.addEdge(new DirectedSparseEdge(h, d));
		design.addEdge(new DirectedSparseEdge(h, g));
		design.addEdge(new DirectedSparseEdge(g, f));
		design.addEdge(new DirectedSparseEdge(f, g));
		design.addEdge(new DirectedSparseEdge(e, a));
		design.addEdge(new DirectedSparseEdge(e, f));
//		design.addEdge(new DirectedSparseEdge(t, a));
//		design.addEdge(new DirectedSparseEdge(a, s));
		// initialize visit/finish
		design.setInit(h);
		StrongConnectedComponents scc = new StrongConnectedComponents();
		scc.detectStrongConnectedComponents(design);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new StrongConnectedComponentsTest();
	}
}


