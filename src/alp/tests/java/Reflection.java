package alp.tests.java;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public class Reflection {
	public static void main(String args[])
	{
		try {
			Class<?> c = Class.forName("loop.components.counter");
			Constructor<?> b[] = c.getConstructors();
			Method m[] = c.getMethods();

			for (int i = 0; i < b.length; i++)
				System.out.println(b[i].toString());

			for (int j = 0; j < m.length; j++)
				System.out.println(m[j].toString());
			System.out.println(c.newInstance().toString());
			System.out.println(c.getConstructor(String.class).newInstance("myCounter").toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}