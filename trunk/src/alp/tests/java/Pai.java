package alp.tests.java;

public class Pai implements Catolico {
	public Pai() {
		System.out.println(this.getClass().getName() + " nasce!");
	}
	public void reza() {
		System.out.println(this.getClass().getName() + " reza!");
	}
}
