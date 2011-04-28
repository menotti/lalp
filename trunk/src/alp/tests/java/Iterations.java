package alp.tests.java;

public class Iterations {
	public static void main(String[] args) {
		for (int i=0; i<1024; i+=64) { //@64
			for (int j=i; j<i+8; j++) { //@8
				for (int k=j; k<j+64; k+=8) { //@1
					System.out.print(k+"\t");
				}
				System.out.println("");
			}
			System.out.println("");
			System.out.println(i<500 ? "<" : "");
		}
	}
}
