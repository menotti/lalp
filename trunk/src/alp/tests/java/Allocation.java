package alp.tests.java;

public class Allocation {
	public static final int N = 11;
	public Allocation() {
		int indata[] = new int[N];
		int outdata[] = new int[N/2];
		System.out.println("indata: " + indata.length);
		System.out.println("outdata: " + outdata.length);		
	}
	public static void main(String[] args) {
		new Allocation();
	}
}

