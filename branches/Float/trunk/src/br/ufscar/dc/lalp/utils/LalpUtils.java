package br.ufscar.dc.lalp.utils;

import br.ufscar.dc.lalp.parser.lang.VarType;

public class LalpUtils {

	/**
	   * Convert a float to  fixed-point representation
	   * @param val The value to convert
	   * @param bits_after The number of bits after point
	   * @return The resulting fixed-point representation
	   */
	
	/*		once parsed your fixed point becomes (D << 12) + d.
	Now to parse d (assuming base 10 for string) you go through every digit and multiply by 10^(-digit)

	example: x=12.1234
	lets take 1234 now lets construct d
	the decimal part of x can be represented as
	1/10 + 2/100 + 3/1000 + 4/10000
	The numerator can be represented as fixed point.
	d = (1 << 12)/10 + (2 << 12)/100 + (3 << 12)/1000 + (4 << 12)/10000

	it works by first converting the digit to fixed point representation (shifting by 12 so its 1.00 or 2.00 etc ...) then dividing by 10, 100, 1000 etc ... to. 

	Since you have only 12bits the fourth digit will have a poor precision.*/
	
	/*
	private static int toFixed(float val, int bits_after) {
		return (int) (val * Math.pow(2, bits_after));
	}

	private static int toFixed(String s, int bits_before, int bits_after) {
		int fx = toFixed(Float.parseFloat(s), bits_after);

		fx = fx & ((int) Math.pow(2, bits_before + bits_after) - 1);
		return fx;
	}
	*/

	private static Long toFixed(String s, int bits_before, int bits_after) {
		long fx = (long)(Float.parseFloat(s)* Math.pow(2, bits_after));

		fx = fx & ((long) Math.pow(2, bits_before + bits_after) - 1);
		return fx;
	}

	private static Long toLong(String s) {

		if (s.length() > 1 && s.charAt(1) == 'x') {
			return Long.parseLong(s.substring(2), 16);
		} else {
			return Long.parseLong(s);
		}
        
	}

	private static Long floatToLong(String s) {
		int raw = Float.floatToIntBits((Float.parseFloat(s)));
		return new Long(raw);
	}
	
	
	public static Long parseValue(String s, VarType t){

		//FIXME: Incluir outros tipos e tamanhos
		if(t.getType() == VarType.Type.FLOAT)
			return floatToLong(s);
		else
			return toLong(s);
		
	}
	
}
