package alp.tests.java;

public class BaseConversion {

	public BaseConversion() {
		long i = 9223372036854775807L;
		print("9223372036854775807");
		print("0x1");
		print("0xffffffff");
		print("0x7fffffffffffffff");
		print("-1");
	}
	
	public void print(String s) {
		System.out.println(StringToInteger(s));
		System.out.println(Long.toBinaryString((long)StringToInteger(s)));
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new BaseConversion();
	}

	public long StringToInteger(String s) {
		if (s.charAt(1) == 'x')
			return Long.parseLong(s.substring(2), 16);
		else
			return Long.parseLong(s);
	}
}

