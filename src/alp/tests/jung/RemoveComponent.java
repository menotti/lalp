package alp.tests.jung;

import alp.components.reg_op;
import alp.core.Component;
import alp.core.Design;
import alp.core.Signal;

public class RemoveComponent {

	public RemoveComponent() {
		Design design = new Design();
		reg_op a, b, c;
		a = (reg_op)design.addComponent(new reg_op());
		b = (reg_op)design.addComponent(new reg_op());
		c = (reg_op)design.addComponent(new reg_op());
		try {
//			a.connectComponent(b);
			b.connectComponent(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		for (Component i : design.getComponents()) {
			System.out.println(i);
		}
		for (Signal s : design.getSignals()) {
			System.out.println(s);
		}
		System.out.println("Remover um componente implica em remover todos os sinais conectados a ele");
		try {
			design.removeComponent(a);
		} catch (Exception e) {
			e.printStackTrace();
		}
		for (Component i : design.getComponents()) {
			System.out.println(i);
		}
		for (Signal s : design.getSignals()) {
			System.out.println(s);
		}
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new RemoveComponent();
	}

}
