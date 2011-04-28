package alp.tests.java;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map.Entry;

public class CollectionsTest {
	public CollectionsTest() {
		Hashtable<Integer,Integer> c = new Hashtable<Integer,Integer>();
		c.put(1,8);
		c.put(3,8);
		c.put(5,0);
		c.put(7,0);
		c.put(2,0);
		c.put(4,8);
		c.put(6,8);
		Iterator<Entry<Integer, Integer>> it = c.entrySet().iterator(); 
		while (it.hasNext()) {
			System.out.println(it.next());
		}
	}
	public static void main(String[] args) {
		new CollectionsTest();
	}
}
