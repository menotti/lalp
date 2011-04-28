package alp.tests.java;

import alp.core.Component;
import alp.core.Design;
import alp.core.Signal;

public class EdgeRules {

	public EdgeRules() {
		Design design = new Design();
		Component x = design.addComponent(new Component("x"));
		Component a = design.addComponent(new Component("a"));
		Component b = design.addComponent(new Component("b"));
		Component c = design.addComponent(new Component("c"));
		design.addSignal(new Signal(x, a));
		Signal xb = design.addSignal(new Signal(x, b));
		design.addSignal(new Signal(x, c));
		for (Component i : x.getSuccessors()) {
			System.out.println(i);
		}
		xb.setBackEdge(true);
		System.out.println("Without back edges");
		for (Component i : x.getSuccessors()) {
			System.out.println(i);
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new EdgeRules();
	}
}
