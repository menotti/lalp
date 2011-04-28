/* Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its 
 * documentation for NON-COMERCIAL purposes and without fee is hereby granted 
 * provided that this copyright notice appears in all copies.
 *
 * RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR 
 * NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES 
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS 
 * SOFTWARE OR ITS DERIVATIVES. 
 */

package alp.designs.swreference;

public class simple_scc {
	final static int SIZE = 8;
	public simple_scc() {
		int sum = 0;
		int a = 0;
		int b = 0;
		int c = 0;
		int indata[] = {12, 41, 96, 87, 56, 25, 69, 31};
		System.out.println("i	a	b	c	sum");
		for (int i = 0; i < SIZE; i++) {
			a = indata[i];
			b = a - c;
			c = b + a;
			sum += c;
			System.out.print(i + "\t");
			System.out.print(a + "\t");
			System.out.print(b + "\t");
			System.out.print(c + "\t");
			System.out.println(sum);
		}
	}
	public static void main(String[] args) {
		new simple_scc();
	}
}
