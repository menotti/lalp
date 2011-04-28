package alp.tests.java;

public class Neto extends Filho {

	public static void main(String[] args) {
		Neto n = new Neto();
		if (n instanceof Filho)
			System.out.println("Neto instanceof Filho");
		if (n instanceof Pai)
			System.out.println("Neto instanceof Pai");
		n.reza();
		if (n instanceof Catolico)
			System.out.println("Neto instanceof Catolico");
	}
}
