package alp.tests.java;

import java.util.*;

public class Collections {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		HashSet<Integer> hs = new HashSet<Integer>();
//		TreeMap<?,?> tm = new TreeMap();
		Hashtable<Integer, String> ht = new Hashtable<Integer, String>();
		for (int i=10; i>0; i-=2) {
			hs.add(i);
			ht.put(i, new Integer(i).toString());
		}
		for (int i=1; i<10; i+=2) {
			hs.add(i);
			ht.put(i, new Integer(i).toString());
		}
		int x = new Integer(2);
		hs.add(x);
		ht.put(x, new Integer(x).toString());
		x = new Integer(2);
		hs.add(x);
		ht.put(x, new Integer(x).toString());
		System.out.println("HashSet");
		for (Integer n: hs) 
			System.out.println(n);
		System.out.println("Hashtable");
		for (Integer n: ht.keySet()) 
			System.out.println(n);
	}

}
