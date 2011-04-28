package alp.tests.java;

public class Operators {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int a = -0xa;
		int b = 0x9;
		boolean c=false, d=false;
		show("a", a);
		show("a<<1", a<<1);
		show("a>>1", a>>1);
		show("a>>>1", a>>>1);
		show("a", a);
		show("~a", ~a);
		show("c", c);
		show("!c", !c);
		show("b", b);
		show("a&b", a&b);
		show("a^b", a^b);
		show("a|b", a|b);
		show("c||d", c||d);
		show("c|d", c|d);
	}

	public static void show(String s, int i) {
		System.out.println(s+"\t"+i+"\t"+Integer.toBinaryString(i)+"\t0x"+Integer.toHexString(i));
	}
	
	public static void show(String s, boolean i) {
		System.out.println(s+"\t"+i+"\t"+i);
	}
}
